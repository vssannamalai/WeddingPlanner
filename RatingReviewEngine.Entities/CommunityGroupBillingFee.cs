using System;

namespace RatingReviewEngine.Entities
{
    public class CommunityGroupBillingFee
    {
        #region Basic Properties

        public int CommunityGroupBillingFeeID { get; set; }

        /// <summary>
        /// Reference back to the particular action that this community-configured fee is being applied to.
        /// </summary>
        public int TriggeredEventID { get; set; }

        public int CommunityGroupID { get; set; }

        /// <summary>
        /// The fee that is to be billed to the supplier for the particular service
        /// </summary>
        public decimal Fee { get; set; }

        /// <summary>
        /// Reference to the particular currency that this fee is defined in - based off the Community Default Currency. 
        /// E.g., if the parent community currency is USD, then the 'fee' would automatically be defined in USD.
        /// </summary>
        public int FeeCurrencyID { get; set; }
        
        /// <summary>
        /// The number of days that a newly registered supplier will remain bill-free for within this community group for the given action.
        /// I.e., if the supplier joins the community on 01/03/2014 and they are bill-free for 10 days for the 'View' action, then the 
        /// supplier will not have any credit deducted from their community virtual account for customer views until 11/03/2014.
        /// </summary>
        public int BillFreeDays { get; set; }

        /// <summary>
        /// The datetime stamp of when the fee was last updated
        /// </summary>
        public DateTime DateUpdated { get; set; }

        #endregion

        #region Relative Properties
        public string ActionName { get; set; }

        public string CommunityGroupName { get; set; }

        public bool IsPercentFee { get; set; }

        public int CommunityID { get; set; }

        #endregion
    }
}
