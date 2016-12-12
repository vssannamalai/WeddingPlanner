using System.Collections.Generic;

namespace RatingReviewEngine.Entities
{
    public class TriggeredEvent
    {
        #region Basic Properties

        public int TriggeredEventID { get; set; }

        /// <summary>
        /// Reference to the unique action that this triggered event is intercepting
        /// </summary>
        public int ActionID { get; set; }

        public int RecVer { get; set; }

        /// <summary>
        /// The percentage of the resulting fee that will be given to the administrator upon billing the 
        /// supplier the amount defined in the CommunityGroupBillingFee table. E.g., if the BillingPercentageAdministrator is defined 
        /// as 0.01, then 1% of the total amount billed to the supplier for this particular Action will be credited to the Administrator.
        /// </summary>
        public decimal? BillingPercentageAdministrator { get; set; }

        /// <summary>
        /// The percentage of the resulting fee that will be given to the community owner upon billing the supplier the amount defined 
        /// in the CommunityGroupBillingFee table. E.g., if the BillingPercentageOwner is defined as 0.01, then 1% of the total amount 
        /// billed to the supplier for this particular Action will be credited to the Community Owner.
        /// </summary>
        public decimal? BillingPercentageOwner { get; set; }

        /// <summary>
        /// If the action is currently active, then the value is to be "true"
        /// If the action is currently inactive, then the value is to be "false"
        /// </summary>
        public bool IsActive { get; set; }

        public bool IsPercentFee { get; set; }

        #endregion

        #region Relative Properties

        public string ActionName { get; set; }

        public List<ActionResponse> lstActionResponse { get; set; }

        public int ActionResponseID { get; set; }

        public string ResponseId { get; set; }

        #endregion
    }
}
