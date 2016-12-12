using System.Collections.Generic;

namespace RatingReviewEngine.Entities.ServiceResponse
{
    public class CommunityDetailResponse : ServiceResponseBase
    {
        public string Description { get; set; }

        public int CommunityGroupCount { get; set; }

        public int SupplierCount { get; set; }

        public int IsMember { get; set; }

        public List<CommunityDetailChildResponse> lstCommunityGroupDetail { get; set; }
    }
}
