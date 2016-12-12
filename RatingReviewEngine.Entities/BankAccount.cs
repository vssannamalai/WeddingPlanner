namespace RatingReviewEngine.Entities
{
    public class BankAccount
    {
        #region Basic Properties
        /// <summary>
        /// If Entity is "Supplier", then EntityID holds "SupplierID". Else if Entity is "Community Owner", then EntityID holds "OwnerID".
        /// </summary>
        public int EnitiyID { get; set; }

        public string Entity { get; set; }

        public string Bank { get; set; }

        public string AccountName { get; set; }

        public string BSB { get; set; }

        public string AccountNumber { get; set; }

        #endregion

        #region Relative Properties

        #endregion
    }
}
