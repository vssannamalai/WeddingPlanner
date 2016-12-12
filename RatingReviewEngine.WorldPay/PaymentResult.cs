using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.WorldPay
{
    public class PaymentResult
    {
        public PaymentResult()
        {
            PaymentSuccessful = false;
            ThreeDAuthRequired = false;
            PaymentError = false;
        }

        public Boolean PaymentSuccessful { get; set; }
        public string lastEvent { get; set; }
        public string orderCode { get; set; }

        public string ReturnedXML { get; set; }

        public Boolean PaymentError { get; set; }
        public string errorMessage { get; set; }
        public string errorCode { get; set; }

        //Used for 3DS
        public Boolean ThreeDAuthRequired { get; set; }
        public string paRequest { get; set; }
        public string issuerURL { get; set; }
        public string echoData { get; set; }
    }
}
