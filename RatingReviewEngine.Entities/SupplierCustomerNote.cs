using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class SupplierCustomerNote
    {
        #region Basic Properties

        public int SupplierCustomerNoteID { get; set; }

        public int CustomerID { get; set; }

        public int CommunityID { get; set; }

        public int CommunityGroupID { get; set; }

        public int SupplierID { get; set; }

        /// <summary>
        /// The notes that a Supplier has added about a customer relationship.
        /// </summary>
        public string SupplierNote { get; set; }

        /// <summary>
        /// The notes that a Customer has added about a supplier relationship.
        /// </summary>
        public string CustomerNote { get; set; }

        #endregion

        #region Relative Properties

        #endregion
    }
}
