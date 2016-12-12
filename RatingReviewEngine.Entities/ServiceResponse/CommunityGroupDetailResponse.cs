using System.Collections.Generic;

namespace RatingReviewEngine.Entities.ServiceResponse
{
    public class CommunityGroupDetailResponse
    {
        public int CommunityID { get; set; }

        public int CommunityGroupID { get; set; }

        public int SupplierCount { get; set; }

        public int IsMember { get; set; }

        public decimal CommunityGroupRating { get; set; }

        public int HigherRatingSupplier { get; set; }

        public int LowerRatingSupplier { get; set; }

        public int EqualRatingSupplier { get; set; }

        public decimal SupplierRating { get; set; }

        public List<CommunityGroupDetailChildResponse> lstCommunityGroupDetailChild { get; set; }
    }
}