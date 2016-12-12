using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Configuration;
using System.Collections.Specialized;

using PayPal.Payments.Common.Utility;
using PayPal.Payments.Communication;
using PayPal.Payments.DataObjects;

using RatingReviewEngine.DAC;
using RatingReviewEngine.Entities;

namespace RatingReviewEngine.Business
{
    public class PaypalPayflowComponent
    {
        public PaypalTransaction PayflowCreditCardProcess(Payflow payflow)
        {
            string PayPalRequest = "TRXTYPE=" + payflow.TransactionType //S - sale transaction
                 + "&TENDER=" + payflow.Tender //C - Credit card
                 + "&ACCT=" + payflow.Acct //card number
                 + "&EXPDATE=" + payflow.ExpDate
                 + "&CVV2=" + payflow.SecurityCode   //card validation value (card security code)               
                 + "&AMT=" + payflow.Amount
                 + "&COMMENT1=" + payflow.Comment
                 + "&USER=" + payflow.User
                 + "&VENDOR=" + payflow.Vendor
                 + "&PARTNER=" + payflow.Partner
                  + "&CURRENCY=" + payflow.Currency
                 + "&PWD=" + payflow.Password;


            // Create an instantce of PayflowNETAPI.
            PayflowNETAPI PayflowNETAPI = new PayflowNETAPI();

            // RequestId is a unique string that is required for each & every transaction. 
            // The merchant can use her/his own algorithm to generate this unique request id or 
            // use the SDK provided API to generate this as shown below (PayflowUtility.RequestId).
            string PayPalResponse = PayflowNETAPI.SubmitTransaction(PayPalRequest, PayflowUtility.RequestId);

            //place data from PayPal into a namevaluecollection

            //  NameValueCollection RequestCollection = GetPayPalCollection(PayflowNETAPI.TransactionRequest);
            NameValueCollection ResponseCollection = GetPayPalCollection(PayPalResponse);

            //show request
            //string result = "<span class=\"heading\">PayPal Payflow Pro transaction request</span><br />";
            //result += ShowPayPalInfo(RequestCollection).ResponseText;

            //show response
            string result = "<span class=\"heading\">PayPal Payflow Pro transaction response</span><br />";
            PaypalTransaction transaction = ShowPayPalInfo(ResponseCollection);
            result += transaction.ResponseText;

            //show transaction errors if any
            string TransErrors = PayflowNETAPI.TransactionContext.ToString();
            if (TransErrors != null && TransErrors.Length > 0)
            {
                result += "<br /><br /><span class=\"bold-text\">Transaction Errors:</span> " + TransErrors;
            }

            //show transaction status
            transaction.Status = PayflowUtility.GetStatus(PayPalResponse);
            result += "<br /><br /><span class=\"bold-text\">Status:</span> " + transaction.Status;
            transaction.ResultText = result;
            return transaction;
        }

        public PaypalTransaction PayflowPaypalProcess(Payflow payflow)
        {
            string PayPalRequest = "TRXTYPE=" + payflow.TransactionType //S - sale transaction
                 + "&TENDER=P"
                 + "&ACTION=S"
                 + "&CANCELURL=" + ConfigurationSettings.AppSettings["PCANCELURL"].ToString()
                 + "&CURRENCY=" + payflow.Currency
                + "&RETURNURL=" + ConfigurationSettings.AppSettings["PRETURNURL"].ToString() + "?od=" + payflow.OAuthAccountID + "_" + payflow.Amount + "_" + payflow.Currency
                                + "_" + payflow.ID + "_" + payflow.Entity + "_" + payflow.CommunityID + "_" + payflow.Description + "_" + HttpUtility.UrlEncode(payflow.CommunityName)
                 + "&AMT=" + payflow.Amount

                 + "&USER=" + payflow.User
                 + "&VENDOR=" + payflow.Vendor
                 + "&PARTNER=" + payflow.Partner
                 + "&PWD=" + payflow.Password;


            // Create an instantce of PayflowNETAPI.
            PayflowNETAPI PayflowNETAPI = new PayflowNETAPI();

            // RequestId is a unique string that is required for each & every transaction. 
            // The merchant can use her/his own algorithm to generate this unique request id or 
            // use the SDK provided API to generate this as shown below (PayflowUtility.RequestId).
            string PayPalResponse = PayflowNETAPI.SubmitTransaction(PayPalRequest, PayflowUtility.RequestId);

            //place data from PayPal into a namevaluecollection

            NameValueCollection RequestCollection = GetPayPalCollection(PayflowNETAPI.TransactionRequest);
            NameValueCollection ResponseCollection = GetPayPalCollection(PayPalResponse);

            //show request
            string result = "<span class=\"heading\">PayPal Payflow Pro transaction request</span><br />";
            result += ShowPayPalInfo(RequestCollection);

            //show response
            result += "<br /><br /><span class=\"heading\">PayPal Payflow Pro transaction response</span><br />";
            PaypalTransaction transaction = ShowPayPalInfo(ResponseCollection);
            result += transaction.ResponseText;
            if (transaction.Result == "0")
            {
                //  HttpContext.Current.Response.Redirect(ConfigurationSettings.AppSettings["PEXPRESSURL"].ToString() + "?cmd=_express-checkout&useraction=commit&token=" + transaction.Token);
                transaction.URL = ConfigurationSettings.AppSettings["PEXPRESSURL"].ToString() + "?cmd=_express-checkout&useraction=commit&token=" + transaction.Token;
            }
            //show transaction errors if any
            string TransErrors = PayflowNETAPI.TransactionContext.ToString();
            if (TransErrors != null && TransErrors.Length > 0)
            {
                result += "<br /><br /><span class=\"bold-text\">Transaction Errors:</span> " + TransErrors;
            }

            //show transaction status
            transaction.Status = PayflowUtility.GetStatus(PayPalResponse);
            result += "<br /><br /><span class=\"bold-text\">Status:</span> " + transaction.Status;
            transaction.TransactionDate = DateTime.Now;
            return transaction;
        }

        public PaypalTransaction PayflowPaypalConfirm(Payflow payflow)
        {
            string PayPalRequest = "TRXTYPE=" + payflow.TransactionType //S - sale transaction
                 + "&TENDER=P"  //C - Credit card
                 + "&ACTION=D"
                + "&TOKEN=" + payflow.Token
                 + "&PAYERID=" + payflow.PayerID
                + "&AMT=" + payflow.Amount
                + "&CURRENCY=" + payflow.Currency
                 + "&USER=" + payflow.User
                 + "&VENDOR=" + payflow.Vendor
                 + "&PARTNER=" + payflow.Partner
                 + "&PWD=" + payflow.Password;


            // Create an instantce of PayflowNETAPI.
            PayflowNETAPI PayflowNETAPI = new PayflowNETAPI();

            // RequestId is a unique string that is required for each & every transaction. 
            // The merchant can use her/his own algorithm to generate this unique request id or 
            // use the SDK provided API to generate this as shown below (PayflowUtility.RequestId).
            string PayPalResponse = PayflowNETAPI.SubmitTransaction(PayPalRequest, PayflowUtility.RequestId);

            //place data from PayPal into a namevaluecollection

            //NameValueCollection RequestCollection = GetPayPalCollection(PayflowNETAPI.TransactionRequest);
            NameValueCollection ResponseCollection = GetPayPalCollection(PayPalResponse);

            //show request
            //string result = "<span class=\"heading\">PayPal Payflow Pro transaction request</span><br />";
            // result += ShowPayPalInfo(RequestCollection);

            //show response
            string result = "<span class=\"heading\">PayPal Payflow Pro transaction response</span><br />";
            PaypalTransaction transaction = ShowPayPalInfo(ResponseCollection);
            result += transaction.ResponseText;

            //show transaction errors if any
            string TransErrors = PayflowNETAPI.TransactionContext.ToString();
            if (TransErrors != null && TransErrors.Length > 0)
            {
                result += "<br /><br /><span class=\"bold-text\">Transaction Errors:</span> " + TransErrors;
            }

            //show transaction status
            transaction.Status = PayflowUtility.GetStatus(PayPalResponse);
            result += "<br /><br /><span class=\"bold-text\">Status:</span> " + transaction.Status;
            transaction.ResultText = result;
            return transaction;
        }

        public PaypalTransaction PayflowACHProcess(Payflow payflow)
        {
            string PayPalRequest = "TRXTYPE=" + payflow.TransactionType //S - sale transaction
                 + "&TENDER=" + payflow.Tender //C - Credit card
                 + "&ACCT=" + payflow.Acct //card number
                 + "&FIRSTNAME=" + payflow.Firstname
                 + "&ACCTTYPE=C"
                 + "&BA=091000019"
                 + "&AMT=" + payflow.Amount
                 + "&USER=" + payflow.User
                 + "&VENDOR=" + payflow.Vendor
                 + "&PARTNER=" + payflow.Partner
                  + "&CURRENCY=" + payflow.Currency
                 + "&PWD=" + payflow.Password;


            // Create an instantce of PayflowNETAPI.
            PayflowNETAPI PayflowNETAPI = new PayflowNETAPI();

            // RequestId is a unique string that is required for each & every transaction. 
            // The merchant can use her/his own algorithm to generate this unique request id or 
            // use the SDK provided API to generate this as shown below (PayflowUtility.RequestId).
            string PayPalResponse = PayflowNETAPI.SubmitTransaction(PayPalRequest, PayflowUtility.RequestId);

            //place data from PayPal into a namevaluecollection

            //  NameValueCollection RequestCollection = GetPayPalCollection(PayflowNETAPI.TransactionRequest);
            NameValueCollection ResponseCollection = GetPayPalCollection(PayPalResponse);

            //show request
            //string result = "<span class=\"heading\">PayPal Payflow Pro transaction request</span><br />";
            //result += ShowPayPalInfo(RequestCollection).ResponseText;

            //show response
            string result = "<span class=\"heading\">PayPal Payflow Pro transaction response</span><br />";
            PaypalTransaction transaction = ShowPayPalInfo(ResponseCollection);
            result += transaction.ResponseText;

            //show transaction errors if any
            string TransErrors = PayflowNETAPI.TransactionContext.ToString();
            if (TransErrors != null && TransErrors.Length > 0)
            {
                result += "<br /><br /><span class=\"bold-text\">Transaction Errors:</span> " + TransErrors;
            }

            //show transaction status
            transaction.Status = PayflowUtility.GetStatus(PayPalResponse);
            result += "<br /><br /><span class=\"bold-text\">Status:</span> " + transaction.Status;
            transaction.ResultText = result;
            return transaction;
        }
        private NameValueCollection GetPayPalCollection(string payPalInfo)
        {
            //place the responses into collection
            NameValueCollection PayPalCollection = new System.Collections.Specialized.NameValueCollection();
            string[] ArrayReponses = payPalInfo.Split('&');

            for (int i = 0; i < ArrayReponses.Length; i++)
            {
                string[] Temp = ArrayReponses[i].Split('=');
                PayPalCollection.Add(Temp[0], Temp[1]);
            }
            return PayPalCollection;
        }
        private PaypalTransaction ShowPayPalInfo(NameValueCollection collection)
        {
            PaypalTransaction payPalTransaction = new PaypalTransaction();
            string PayPalInfo = "";
            foreach (string key in collection.AllKeys)
            {
                switch (key)
                {
                    case "PNREF":
                        payPalTransaction.TransactionID = collection[key];
                        break;
                    case "RESPMSG":
                        payPalTransaction.ResponseMessage = collection[key];
                        break;
                    case "RESULT":
                        payPalTransaction.Result = collection[key];
                        break;
                    case "TOKEN":
                        payPalTransaction.Token = collection[key];
                        break;
                }
                PayPalInfo += "<br /><span class=\"bold-text\">" +
                    key + ":</span> " + collection[key];
            }
            payPalTransaction.ResponseText = PayPalInfo;

            return payPalTransaction;
        }
    }
}
