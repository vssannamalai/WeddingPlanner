using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities.ServiceRequest
{
    public class PaymentProcessRequest
    {
        public int OAuthAccountID { get; set; }
        public string Cardnumber { get; set; }
        public string ExpiryDate { get; set; }
        public string SecuirtyCode { get; set; }
        public string Amount { get; set; }
        public string Commnet { get; set; }

        public string Currency { get; set; }
        public string PayerID { get; set; }
        public string Token { get; set; }

        public int ID { get; set; }
        public string Entity { get; set; }
        public int CommunityID { get; set; }
        public int CommunityGroupID { get; set; }
        public string CommunityName { get; set; }
        public string Description { get; set; }
        public string Email { get; set; }


    }
}
