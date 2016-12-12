namespace RatingReviewEngine.Entities
{
    public class CommunityGroup
    {
        #region Basic Properties

        public int CommunityGroupID { get; set; }

        public int CommunityID { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        /// <summary>
        /// A minimum credit bound that a supplier can have within the given community group. 
        /// When suppliers reach below this credit min, they appear as "Below Min Suppliers".
        /// </summary>
        public decimal? CreditMin { get; set; }

        /// <summary>
        /// The currency that this community group's financials are managed in. NB: The default currency is the currency of the parent community.
        /// </summary>
        public int CurrencyID { get; set; }

        /// <summary>
        /// If the community group is active within the system, then the value is "1"
        /// If the community group is not active within the system, then the value is "0"
        /// </summary>
        public bool Active { get; set; }

        #endregion

        #region Relative Properties
        public int InCreditSuppliersCount { get; set; }

        public int OutofCreditSuppliersCount { get; set; }

        public int BelowMinCreditSuppliersCount { get; set; }

        public int CustomersCount { get; set; }

        public decimal CurrentRevenue { get; set; }

        public string CommunityName { get; set; }

        public string CurrencyName { get; set; }

        #endregion
    }
}
