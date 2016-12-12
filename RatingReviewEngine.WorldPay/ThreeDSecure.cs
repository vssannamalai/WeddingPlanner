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
    public class ThreeDSecure
    {
        public class PaymentResult
        {
            public PaymentResult()
            {
                PaymentSuccessful = false;
                PaymentError = false;
            }

            public Boolean PaymentSuccessful { get; set; }
            public string lastEvent { get; set; }
            public string orderCode { get; set; }

            public string SentXML { get; set; }
            public string ReturnedXML { get; set; }

            public Boolean PaymentError { get; set; }
            public string errorMessage { get; set; }
            public string errorCode { get; set; }
        }

        public PaymentResult SubmitTransaction(string paResponse, string echoData, string MerchantCode, string XMLPassword, string installationID, HttpContext Context)
        {
            var XML = new StringBuilder();

            AES256 encrypter = new AES256(GetBytes(WebConfigurationManager.AppSettings["AESCrypt"]));

            XML.AppendLine("<?xml version='1.0' encoding='UTF-8'?>");
            XML.AppendLine("<!DOCTYPE paymentService PUBLIC '-//WorldPay/DTD WorldPay PaymentService v1//EN' 'http://dtd.worldpay.com/paymentService_v1.dtd'>");
            XML.AppendLine("<paymentService version='1.4' merchantCode='" + MerchantCode + "'>");
            XML.AppendLine("<submit>");
            XML.AppendLine("<order orderCode='" + encrypter.Decrypt(Context.Session[MerchantCode + "_OrderCode"].ToString()) + "' installationId='" + installationID + "'>");
            XML.AppendLine("<description>" + encrypter.Decrypt(Context.Session[MerchantCode + "_Description"].ToString()) + "</description>");
            XML.AppendLine("<amount value='" + encrypter.Decrypt(Context.Session[MerchantCode + "_amount"].ToString()) + "' currencyCode='" + encrypter.Decrypt(Context.Session[MerchantCode + "_currencyCode"].ToString()) + "' exponent='2'/>");
            XML.AppendLine("<orderContent>");
            XML.AppendLine("<![CDATA[" + encrypter.Decrypt(Context.Session[MerchantCode + "_orderContent"].ToString()) + "]]>");
            XML.AppendLine("</orderContent>");
            XML.AppendLine("<paymentDetails>");
            XML.AppendLine("<" + encrypter.Decrypt(Context.Session[MerchantCode + "_cardType"].ToString()) + "-SSL>");
            XML.AppendLine("<cardNumber>" + encrypter.Decrypt(Context.Session[MerchantCode + "_cardNumber"].ToString()) + "</cardNumber>");
            XML.AppendLine("<expiryDate><date month='" + encrypter.Decrypt(Context.Session[MerchantCode + "_expiryMonth"].ToString()) + "' year='" + encrypter.Decrypt(Context.Session[MerchantCode + "_expiryYear"].ToString()) + "'/></expiryDate>");

            if (encrypter.Decrypt(Context.Session[MerchantCode + "_cardType"].ToString()) == "MAESTRO" && encrypter.Decrypt(Context.Session[MerchantCode + "_startMonth"].ToString()) != "" && encrypter.Decrypt(Context.Session[MerchantCode + "_startYear"].ToString()) != "")
            {
                XML.AppendLine("<startDate><date month='" + encrypter.Decrypt(Context.Session[MerchantCode + "_startMonth"].ToString()) + "' year='" + encrypter.Decrypt(Context.Session[MerchantCode + "_startYear"].ToString()) + "' /></startDate>");
            }

            if (encrypter.Decrypt(Context.Session[MerchantCode + "_issueNumber"].ToString()) != "")
            {
                XML.AppendLine("<issueNumber>" + encrypter.Decrypt(Context.Session[MerchantCode + "_issueNumber"].ToString()) + "</issueNumber>");
            }

            XML.AppendLine("<cardHolderName>" + encrypter.Decrypt(Context.Session[MerchantCode + "_cardHolderName"].ToString()) + "</cardHolderName>");
            XML.AppendLine("<cvc>" + encrypter.Decrypt(Context.Session[MerchantCode + "_cvc"].ToString()) + "</cvc>");
            XML.AppendLine("<cardAddress>");
            XML.AppendLine("<address>");
            XML.AppendLine("<firstName></firstName>");
            XML.AppendLine("<lastName></lastName>");
            XML.AppendLine("<address1>" + encrypter.Decrypt(Context.Session[MerchantCode + "_address1"].ToString()) + "</address1>");
            XML.AppendLine("<address2>" + encrypter.Decrypt(Context.Session[MerchantCode + "_address2"].ToString()) + "</address2>");
            XML.AppendLine("<address3>" + encrypter.Decrypt(Context.Session[MerchantCode + "_address3"].ToString()) + "</address3>");
            XML.AppendLine("<postalCode>" + encrypter.Decrypt(Context.Session[MerchantCode + "_postalCode"].ToString()) + "</postalCode>");
            XML.AppendLine("<city>" + encrypter.Decrypt(Context.Session[MerchantCode + "_city"].ToString()) + "</city>");
            XML.AppendLine("<countryCode>" + encrypter.Decrypt(Context.Session[MerchantCode + "_countryCode"].ToString()) + "</countryCode>");
            XML.AppendLine("</address>");
            XML.AppendLine("</cardAddress>");
            XML.AppendLine("</" + encrypter.Decrypt(Context.Session[MerchantCode + "_cardType"].ToString()) + "-SSL>");
            XML.AppendLine("<session shopperIPAddress='" + encrypter.Decrypt(Context.Session[MerchantCode + "_custIPaddress"].ToString()) + "' id='" + encrypter.Decrypt(Context.Session[MerchantCode + "_transactionTime"].ToString()) + "'/>");
            XML.AppendLine("<info3DSecure><paResponse>" + paResponse + "</paResponse></info3DSecure>");
            XML.AppendLine("</paymentDetails>");
            XML.AppendLine("<shopper>");
            XML.AppendLine("<shopperEmailAddress>" + encrypter.Decrypt(Context.Session[MerchantCode + "_shopperEmailAddress"].ToString()) + "</shopperEmailAddress><browser>");
            XML.AppendLine("<acceptHeader>" + encrypter.Decrypt(Context.Session[MerchantCode + "_acceptHeader"].ToString()) + "</acceptHeader>");
            XML.AppendLine("<userAgentHeader>" + encrypter.Decrypt(Context.Session[MerchantCode + "_userAgentHeader"].ToString()) + "</userAgentHeader>");
            XML.AppendLine("</browser>");
            XML.AppendLine("</shopper>");
            XML.AppendLine("<echoData>" + echoData + "</echoData>");
            XML.AppendLine("</order>");
            XML.AppendLine("</submit>");
            XML.AppendLine("</paymentService>");

            string URL = "";

            if (encrypter.Decrypt(Context.Session[MerchantCode + "_testMode"].ToString()) == "0")
            {
                URL = ConfigurationManager.AppSettings["TestPaymentURL"].ToString();
            }
            else
            {
                URL = ConfigurationManager.AppSettings["LivePaymentURL"].ToString();
            }

            WebRequest request = WebRequest.Create(URL);
            CredentialCache loginas = new CredentialCache();
            loginas.Add(new Uri(URL), "Basic", new NetworkCredential(MerchantCode, XMLPassword));
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

            result.SentXML = XML.ToString();
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
                          OrderCode = (string)node.Attribute("orderCode") ?? ""
                      }).SingleOrDefault();

            var o2 = (from node in doc1.Descendants("paymentService").Descendants("reply").Descendants("orderStatus").Descendants("payment")
                      select new
                      {
                          lastEvent = (string)node.Element("lastEvent") ?? ""
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
            }

            if (o2 != null)
            {
                result.lastEvent = o2.lastEvent;
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

            return result;
        }

        static byte[] GetBytes(string str)
        {
            byte[] bytes = new byte[str.Length * sizeof(char)];
            System.Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);
            return bytes;
        }

    }
}
