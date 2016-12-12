using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class SupplierCommunityBillFreeOverride
    {
        #region Basic Properties

        public int SupplierCommunityBillFreeOverrideID { get; set; }

        public int CommunitySupplierID { get; set; }

        public int CommunityGroupBillingFeeID { get; set; }

        /// <summary>
        /// The date that the bill-free period commences
        /// </summary>
        public DateTime BillFreeStart { get; set; }

        /// <summary>
        /// The date that the bill-free period finishes
        /// </summary>
        public DateTime BillFreeEnd { get; set; }

        /// <summary>
        /// If the current date is within the bounds of the BillFreeStart and BillFreeEnd inclusively, then the value is "true" else "false"
        /// </summary>
        public bool IsActive { get; set; }

        public int CommunityID { get; set; }

        public int CommunityGroupID { get; set; }

        public int SupplierID { get; set; }

        #endregion

        #region Relative Properties

        #endregion
    }
}
