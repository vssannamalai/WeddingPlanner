using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class PaypalTransaction
    {
        public int PaypalTransactionID { get; set; }

        public int OAuthAccountID { get; set; }

        public string TransactionID { get; set; }

        public string ResponseMessage { get; set; }

        public string Status { get; set; }

        public string ResponseText { get; set; }

        public string Result { get; set; }

        public string ResultText { get; set; }
        public DateTime TransactionDate { get; set; }

        public string Token { get; set; }

        public string URL { get; set; }
    }
}
