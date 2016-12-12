using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class AdminTransactionHistory
    {
        #region Basic Properties
        public int AdminTransactionHistoryID { get; set; }

        public int CommunityID { get; set; }

        public int CommunityGroupID { get; set; }

        public string Description { get; set; }

        public decimal Amount { get; set; }

        public DateTime DateApplied { get; set; }

        public decimal Balance { get; set; }
        
        #endregion

        #region Relative Properties

        public int OwnerID { get; set; }

        public string OwnerName { get; set; }

        public string CommunityName { get; set; }

        public string CommunityGroupName { get; set; }

        public string SupplierName { get; set; }

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
