using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    /// <summary>
    /// Common class to get Account details
    /// </summary>
    public class VirtualCommunityAccount
    {
        public int SupplierCommunityTransactionHistoryID { get; set; }

        public int CommunityOwnerTransactionHistoryID { get; set; }

        public int SupplierID { get; set; }

        public int OwnerID { get; set; }

        public int CommunityID { get; set; }

        public int? CommunityGroupID { get; set; }

        public string Description { get; set; }

        public decimal Amount { get; set; }

        public DateTime DateApplied { get; set; }

        public decimal Balance { get; set; }

        public int? CustomerID { get; set; }

        public string Entity { get; set; }

        public int ID { get; set; }

        public int ActionID { get; set; }
    }
}
