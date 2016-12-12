using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class Payflow
    {
        public string TransactionType { get; set; }
        public string Tender { get; set; }
        public string Firstname { get; set; }
        public string Acct { get; set; }
        public string ExpDate { get; set; }
        public string SecurityCode { get; set; }
        public string Amount { get; set; }
        public string Comment { get; set; }
        public string User { get; set; }
        public string Vendor { get; set; }
        public string Partner { get; set; }
        public string Password { get; set; }

        public string Currency { get; set; }
        public string PayerID { get; set; }
        public string Token { get; set; }
        public string OAuthAccountID { get; set; }

        public int ID { get; set; }
        public string Entity { get; set; }
        public int CommunityID { get; set; }
        public int CommunityGroupID { get; set; }
        public string CommunityName { get; set; }
        public string Description { get; set; }

    }
}
