using System;
using System.Collections.Generic;

namespace RatingReviewEngine.Entities.ServiceResponse
{
    public class CustomerTransactionResponse : ServiceResponseBase
    {
        public int CustomerID { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string Handle { get; set; }

        public decimal TotalRevenue { get; set; }

        public decimal TotalSpend { get; set; }

        public int CurrencyID { get; set; }

        public string CurrencyName { get; set; }

        public int RowIndex { get; set; }

        public int RowCount { get; set; }

        public int TotalRecords { get; set; }

        public List<CommunityTransaction> lstCommunityTransaction { get; set; }
    }

    public class CommunityTransaction
    {
        public int CustomerID { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string Handle { get; set; }

        public int CommunityID { get; set; }

        public string CommunityName { get; set; }

        public Int64 ReviewCount { get; set; }

        public decimal TotalRevenue { get; set; }

        public decimal TotalSpend { get; set; }

        public int CurrencyID { get; set; }

        public string CurrencyName { get; set; }

        public List<CommunityGroupTransaction> lstCommunityGroupTransaction { get; set; }
    }

    public class CommunityGroupTransaction
    {
        public int CustomerID { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string Handle { get; set; }

        public int CommunityID { get; set; }

        public string CommunityName { get; set; }

        public int CommunityGroupID { get; set; }

        public string CommunityGroupName { get; set; }

        public Int64 ReviewCount { get; set; }

        public decimal TotalRevenue { get; set; }

        public decimal TotalSpend { get; set; }

        public Int64 ViewsCount { get; set; }

        public int CurrencyID { get; set; }

        public string CurrencyName { get; set; }
    }
}
