using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities.ServiceResponse
{
    public class SupplierTransactionResponse : ServiceResponseBase
    {
        public int SupplierID { get; set; }

        public string SupplierName { get; set; }

        public decimal AverageRating { get; set; }

        public Int64 ReviewCount { get; set; }

        public decimal TotalRevenue { get; set; }

        public decimal TotalIncome { get; set; }

        public int CurrencyID { get; set; }

        public string CurrencyName { get; set; }

        public int TotalRecords { get; set; }

        public List<SupplierCommunityTransaction> lstSupplierCommunityTransaction { get; set; }
    }

    public class SupplierCommunityTransaction
    {
        public int SupplierID { get; set; }

        public int CommunityID { get; set; }

        public string CommunityName { get; set; }

        public decimal Credit { get; set; }

        public decimal TotalRevenue { get; set; }

        public decimal TotalIncome { get; set; }

        public int CurrencyID { get; set; }

        public string CurrencyName { get; set; }

        public List<SupplierCommunityGroupTransaction> lstSupplierCommunityGroupTransaction { get; set; }
    }

    public class SupplierCommunityGroupTransaction
    {
        public int SupplierID { get; set; }

        public int CommunityID { get; set; }

        public int CommunityGroupID { get; set; }

        public string CommunityGroupName { get; set; }

        public decimal AverageRating { get; set; }

        public Int64 ReviewCount { get; set; }

        /// <summary>
        /// Owner's revenue
        /// </summary>
        public decimal TotalRevenue { get; set; }

        /// <summary>
        /// Supplier's Income
        /// </summary>
        public decimal TotalIncome  { get; set; }

        public decimal TotalTransaction { get; set; }

        public Int64 ViewsCount { get; set; }

        public int CurrencyID { get; set; }

        public string CurrencyName { get; set; }
    }
}
