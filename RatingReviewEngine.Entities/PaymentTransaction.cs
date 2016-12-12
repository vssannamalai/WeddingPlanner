using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class PaymentTransaction
    {
        public int ReceiptID { get; set; }

        public int OAuthAccountID { get; set; }

        public decimal TransactionAmount { get; set; }

        public string OrderCode { get; set; }

        public string EchoData { get; set; }

        public string SuccessMessage { get; set; }

        public string ErrorMessage { get; set; }

        public string ResponseXML { get; set; }
    }
}
