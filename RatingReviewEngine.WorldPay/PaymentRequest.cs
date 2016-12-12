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

namespace RatingReviewEngine.WorldPay
{
    public class PaymentRequest
    {


        public int installationID { get; set; }
        public string MerchantCode { get; set; }
        public string XMLPassword { get; set; }
        public string OrderCode { get; set; }
        public string Description { get; set; }
        public string orderContent { get; set; }
        public string MD5secretKey { get; set; }
        public int amount { get; set; }
        public string currencyCode { get; set; }
        public string cardType { get; set; }
        public string cardNumber { get; set; }
        public string expiryMonth { get; set; }
        public string expiryYear { get; set; }
        public string startMonth { get; set; }
        public string startYear { get; set; }
        public string issueNumber { get; set; }
        public string cardHolderName { get; set; }
        public string cvc { get; set; }
        public string address1 { get; set; }
        public string address2 { get; set; }
        public string address3 { get; set; }
        public string postalCode { get; set; }
        public string city { get; set; }
        public string countryCode { get; set; }
        public string custIPaddress { get; set; }
        public string transactionTime { get; set; }
        public string shopperEmailAddress { get; set; }
        public string acceptHeader { get; set; }
        public string userAgentHeader { get; set; }
        public int testMode { get; set; }

    }
}
