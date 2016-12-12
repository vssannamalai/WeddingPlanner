using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Configuration;
using System.Collections.Specialized;
using System.Net;
using System.IO;
using System.Xml.Linq;
using System.Reflection;
using System.Configuration;

namespace RatingReviewEngine.WorldPay
{
    public class PaymentProcess
    {
        public PaymentResult SubmitTransaction(PaymentRequest PaymentRequest, HttpContext Context)
        {
            //Context.Session["WPGW_"] = "";

            var XML = new StringBuilder();

            XML.AppendLine("<?xml version='1.0' encoding='UTF-8'?>");
            XML.AppendLine("<!DOCTYPE paymentService PUBLIC '-//WorldPay/DTD WorldPay PaymentService v1//EN' 'http://dtd.worldpay.com/paymentService_v1.dtd'>");
            XML.AppendLine("<paymentService version='1.4' merchantCode='" + PaymentRequest.MerchantCode + "'>");
            XML.AppendLine("<submit>");
            XML.AppendLine("<order orderCode='" + PaymentRequest.OrderCode + "' installationId='" + PaymentRequest.installationID + "'>");
            XML.AppendLine("<description>" + PaymentRequest.Description + "</description>");
            XML.AppendLine("<amount value='" + PaymentRequest.amount + "' currencyCode='" + PaymentRequest.currencyCode + "' exponent='2'/>");
            XML.AppendLine("<orderContent>");
            XML.AppendLine("<![CDATA[" + PaymentRequest.orderContent + "]]>");
            XML.AppendLine("</orderContent>");
            XML.AppendLine("<paymentDetails>");
            XML.AppendLine("<" + PaymentRequest.cardType + "-SSL>");
            XML.AppendLine("<cardNumber>" + PaymentRequest.cardNumber + "</cardNumber>");
            XML.AppendLine("<expiryDate><date month='" + PaymentRequest.expiryMonth + "' year='" + PaymentRequest.expiryYear + "'/></expiryDate>");

            if (PaymentRequest.cardType == "MAESTRO" && PaymentRequest.startMonth != "" && PaymentRequest.startYear != "")
            {
                XML.AppendLine("<startDate><date month='" + PaymentRequest.startMonth + "' year='" + PaymentRequest.startYear + "' /></startDate>");
            }

            if (PaymentRequest.issueNumber != "")
            {
                XML.AppendLine("<issueNumber>" + PaymentRequest.issueNumber + "</issueNumber>");
            }

            XML.AppendLine("<cardHolderName>" + PaymentRequest.cardHolderName + "</cardHolderName>");
            XML.AppendLine("<cvc>" + PaymentRequest.cvc + "</cvc>");
            XML.AppendLine("<cardAddress>");
            XML.AppendLine("<address>");
            XML.AppendLine("<firstName></firstName>");
            XML.AppendLine("<lastName></lastName>");
            XML.AppendLine("<address1>" + PaymentRequest.address1 + "</address1>");
            XML.AppendLine("<address2>" + PaymentRequest.address2 + "</address2>");
            XML.AppendLine("<address3>" + PaymentRequest.address3 + "</address3>");
            XML.AppendLine("<postalCode>" + PaymentRequest.postalCode + "</postalCode>");
            XML.AppendLine("<city>" + PaymentRequest.city + "</city>");
            XML.AppendLine("<countryCode>" + PaymentRequest.countryCode + "</countryCode>");
            XML.AppendLine("</address>");
            XML.AppendLine("</cardAddress>");
            XML.AppendLine("</" + PaymentRequest.cardType + "-SSL>");
            XML.AppendLine("<session shopperIPAddress='" + PaymentRequest.custIPaddress + "' id='" + PaymentRequest.transactionTime + "'/>");
            XML.AppendLine("</paymentDetails>");
            XML.AppendLine("<shopper>");
            XML.AppendLine("<shopperEmailAddress>" + PaymentRequest.shopperEmailAddress + "</shopperEmailAddress><browser>");
            XML.AppendLine("<acceptHeader>" + PaymentRequest.acceptHeader + "</acceptHeader>");
            XML.AppendLine("<userAgentHeader>" + PaymentRequest.userAgentHeader + "</userAgentHeader>");
            XML.AppendLine("</browser>");
            XML.AppendLine("</shopper>");
            XML.AppendLine("</order>");
            XML.AppendLine("</submit>");
            XML.AppendLine("</paymentService>");

            string URL = "";

            if (PaymentRequest.testMode == 0)
            {
                URL = ConfigurationManager.AppSettings["TestPaymentURL"].ToString();
            }
            else
            {
                URL = ConfigurationManager.AppSettings["LivePaymentURL"].ToString();
            }

            WebRequest request = WebRequest.Create(URL);
            CredentialCache loginas = new CredentialCache();
            loginas.Add(new Uri(URL), "Basic", new NetworkCredential(PaymentRequest.MerchantCode, PaymentRequest.XMLPassword));
            request.Credentials = loginas;
            request.Method = "POST";
            request.ContentType = "text/xml";
            StreamWriter writer = new StreamWriter(request.GetRequestStream());
            writer.WriteLine(XML.ToString());
            writer.Close();
            WebResponse rsp = request.GetResponse();
            StreamReader sr = new StreamReader(rsp.GetResponseStream());

            string ReturnedXML = sr.ReadToEnd();

            sr.Close();

            PaymentResult result = new PaymentResult();
            result.ReturnedXML = ReturnedXML;

            // Read XML Response0 into Memory Stream.
            MemoryStream stream1 = new MemoryStream();
            StreamWriter writer1 = new StreamWriter(stream1);
            writer1.Write(ReturnedXML);
            writer1.Flush();
            stream1.Position = 0;

            // Load XML from a stream.
            var doc1 = XDocument.Load(stream1);

            // Query the XML, pull out useful information.
            var o1 = (from node in doc1.Descendants("paymentService").Descendants("reply").Descendants("orderStatus")
                      select new
                      {
                          OrderCode = (string)node.Attribute("orderCode") ?? "",
                          echoData = (string)node.Element("echoData") ?? ""
                      }).SingleOrDefault();

            var o2 = (from node in doc1.Descendants("paymentService").Descendants("reply").Descendants("orderStatus").Descendants("payment")
                      select new
                      {
                          lastEvent = (string)node.Element("lastEvent") ?? ""
                      }).SingleOrDefault();

            var o3 = (from node in doc1.Descendants("paymentService").Descendants("reply").Descendants("orderStatus").Descendants("requestInfo").Descendants("request3DSecure")
                      select new
                      {
                          paRequest = (string)node.Element("paRequest") ?? "",
                          issuerURL = (string)node.Element("issuerURL") ?? ""
                      }).SingleOrDefault();

            var o4 = (from node in doc1.Descendants("paymentService").Descendants("reply").Descendants("error")
                      select new
                      {
                          errorcode = (string)node.Attribute("code") ?? "",
                          errormessage = (string)node ?? ""
                      }).SingleOrDefault();

            if (o1 != null)
            {
                result.orderCode = o1.OrderCode;
                result.echoData = o1.echoData;
            }

            if (o2 != null)
            {
                result.lastEvent = o2.lastEvent;
            }

            if (o3 != null)
            {
                result.paRequest = o3.paRequest;
                result.issuerURL = o3.issuerURL;
                result.ThreeDAuthRequired = true;
            }

            if (o4 != null)
            {
                result.errorCode = o4.errorcode;
                result.errorMessage = o4.errormessage;
                result.PaymentError = true;
            }

            //Check result of transaction
            switch (result.lastEvent)
            {
                case "AUTHORISED":
                    result.PaymentSuccessful = true;
                    break;
                default:
                    result.PaymentSuccessful = false;
                    break;
            }

            //Check if 3DS required
            //if (result.ThreeDAuthRequired)
            //{
            //    AES256 encrypter = new AES256(GetBytes(WebConfigurationManager.AppSettings["AESCrypt"]));

            //    //Set Session Variables
            //    Context.Session[PaymentRequest.MerchantCode + "_OrderCode"] = encrypter.Encrypt(PaymentRequest.OrderCode);
            //    Context.Session[PaymentRequest.MerchantCode + "_Description"] = encrypter.Encrypt(PaymentRequest.Description);
            //    Context.Session[PaymentRequest.MerchantCode + "_orderContent"] = encrypter.Encrypt(PaymentRequest.orderContent);
            //    Context.Session[PaymentRequest.MerchantCode + "_amount"] = encrypter.Encrypt(PaymentRequest.amount.ToString());
            //    Context.Session[PaymentRequest.MerchantCode + "_currencyCode"] = encrypter.Encrypt(PaymentRequest.currencyCode);
            //    Context.Session[PaymentRequest.MerchantCode + "_cardType"] = encrypter.Encrypt(PaymentRequest.cardType);
            //    Context.Session[PaymentRequest.MerchantCode + "_cardNumber"] = encrypter.Encrypt(PaymentRequest.cardNumber);
            //    Context.Session[PaymentRequest.MerchantCode + "_expiryMonth"] = encrypter.Encrypt(PaymentRequest.expiryMonth);
            //    Context.Session[PaymentRequest.MerchantCode + "_expiryYear"] = encrypter.Encrypt(PaymentRequest.expiryYear);
            //    Context.Session[PaymentRequest.MerchantCode + "_startMonth"] = encrypter.Encrypt(PaymentRequest.startMonth);
            //    Context.Session[PaymentRequest.MerchantCode + "_startYear"] = encrypter.Encrypt(PaymentRequest.startYear);
            //    Context.Session[PaymentRequest.MerchantCode + "_issueNumber"] = encrypter.Encrypt(PaymentRequest.issueNumber);
            //    Context.Session[PaymentRequest.MerchantCode + "_cardHolderName"] = encrypter.Encrypt(PaymentRequest.cardHolderName);
            //    Context.Session[PaymentRequest.MerchantCode + "_cvc"] = encrypter.Encrypt(PaymentRequest.cvc);
            //    Context.Session[PaymentRequest.MerchantCode + "_address1"] = encrypter.Encrypt(PaymentRequest.address1);
            //    Context.Session[PaymentRequest.MerchantCode + "_address2"] = encrypter.Encrypt(PaymentRequest.address2);
            //    Context.Session[PaymentRequest.MerchantCode + "_address3"] = encrypter.Encrypt(PaymentRequest.address3);
            //    Context.Session[PaymentRequest.MerchantCode + "_postalCode"] = encrypter.Encrypt(PaymentRequest.postalCode);
            //    Context.Session[PaymentRequest.MerchantCode + "_city"] = encrypter.Encrypt(PaymentRequest.city);
            //    Context.Session[PaymentRequest.MerchantCode + "_countryCode"] = encrypter.Encrypt(PaymentRequest.countryCode);
            //    Context.Session[PaymentRequest.MerchantCode + "_custIPaddress"] = encrypter.Encrypt(PaymentRequest.custIPaddress);
            //    Context.Session[PaymentRequest.MerchantCode + "_transactionTime"] = encrypter.Encrypt(PaymentRequest.transactionTime);
            //    Context.Session[PaymentRequest.MerchantCode + "_shopperEmailAddress"] = encrypter.Encrypt(PaymentRequest.shopperEmailAddress);
            //    Context.Session[PaymentRequest.MerchantCode + "_acceptHeader"] = encrypter.Encrypt(PaymentRequest.acceptHeader);
            //    Context.Session[PaymentRequest.MerchantCode + "_userAgentHeader"] = encrypter.Encrypt(PaymentRequest.userAgentHeader);
            //    Context.Session[PaymentRequest.MerchantCode + "_testMode"] = encrypter.Encrypt(PaymentRequest.testMode.ToString());

            //    var remotePost = new RemotePost(Context, result.issuerURL, FormMethod.POST);

            //    remotePost.AddInput("PaReq", result.paRequest);
            //    remotePost.AddInput("TermUrl", WebConfigurationManager.AppSettings["WebsiteURL"] + "/ProcessThreeDSecure.aspx");
            //    remotePost.AddInput("MD", result.echoData);

            //    remotePost.Post("CardSaveThreeDSecure");
            //}

            return result;
        }

        public static IEnumerable<FieldInfo> GetAllFields(Type t)
        {
            if (t == null)
                return Enumerable.Empty<FieldInfo>();

            BindingFlags flags = BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static | BindingFlags.Instance | BindingFlags.DeclaredOnly;
            return t.GetFields(flags).Concat(GetAllFields(t.BaseType));
        }

        static byte[] GetBytes(string str)
        {
            byte[] bytes = new byte[str.Length * sizeof(char)];
            System.Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);
            return bytes;
        }
    }
}
