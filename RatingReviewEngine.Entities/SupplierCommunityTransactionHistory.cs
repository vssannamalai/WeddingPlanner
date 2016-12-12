using System;

namespace RatingReviewEngine.Entities
{
    public class SupplierCommunityTransactionHistory
    {
        #region Basic Properties

        public int SupplierCommunityTransactionHistoryID { get; set; }

        public int SupplierID { get; set; }

        public int CommunityID { get; set; }

        /// <summary>
        /// If the transaction is performed within the context of a community group, then this field is to be completed. 
        /// If the transaction is account-based, such as topup or transfer, then this field is to remain null.
        /// </summary>
        public int CommunityGroupID { get; set; }

        /// <summary>
        /// The description of the type of transaction. I.e., could be "CREDIT APPLIED", "CUSTOMER REVIEW", etc.
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// The amount of revenue earned by the supplier. Value can be positive or negative.
        /// </summary>
        public decimal Amount { get; set; }

        /// <summary>
        /// The datetime stamp that the revenue was applied
        /// </summary>
        public DateTime DateApplied { get; set; }

        /// <summary>
        /// The current balance based on credits & debits from previous balance. Balance starts at 0 and is credited or debited depending on the amount applied.
        /// </summary>
        public decimal Balance { get; set; }

        /// <summary>
        /// Reference to the Customer whose action resulted in the generation of this bill.
        /// The Supplier will not be able to see details of an individual Customer; however, anonymous metrics will be
        /// able to be derived from this relationship. This reference will also enable the Community Owner to perform 
        /// informative metrics on active Customers whose actions create revenue.
        /// If the transaction was not a result of Customer action, then this field will be null.
        /// </summary>
        public int? CustomerID { get; set; }

        #endregion

        #region Relative Properties
        public string CommunityName { get; set; }

        public string CommunityGroupName { get; set; }

        public string CustomerName { get; set; }

        public string FromDate { get; set; }

        public string ToDate { get; set; }

        public int CurrencyID { get; set; }

        public string CurrencyName { get; set; }

        public int RowIndex { get; set; }

        public int RowCount { get; set; }

        public int TotalRecords { get; set; }

        public string DateAppliedString { get { return DateApplied.ToString("dd/MM/yyyy hh:mm:tt").Replace("-", "/"); } set { /* NOOP */ } }

        #endregion
    }
}
