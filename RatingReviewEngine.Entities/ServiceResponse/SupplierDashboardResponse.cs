using System;
using System.Collections.Generic;

namespace RatingReviewEngine.Entities.ServiceResponse
{
    public class SupplierDashboardResponse : ServiceResponseBase
    {
        public int CommunityID { get; set; }

        public string CommunityName { get; set; }

        public decimal Credit { get; set; }

        public int CurrencyID { get; set; }

        public string CurrencyName { get; set; }

        public string IsActive { get; set; }

        public List<SupplierCommunityGroupResponse> lstSupplierCommunityGroupResponse { get; set; }
    }

    public class SupplierCommunityGroupResponse
    {
        public int CommunityID { get; set; }

        public int CommunityGroupID { get; set; }

        public string CommunityGroupName { get; set; }

        public decimal AverageRating { get; set; }

        public Int64 ReviewCount { get; set; }

        public Int64 ResponsePendingCount { get; set; }

        public string PastMonthActivity { get; set; }

        public string ActionRequired { get; set; }

        public string IsActive { get; set; }
    }
}
