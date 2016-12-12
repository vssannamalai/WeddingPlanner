namespace RatingReviewEngine.Entities.ServiceResponse
{
    public class CommunityGroupDetailChildResponse
    {
        public decimal SupplierCommunityGroupRating { get; set; }

        public int SupplierID { get; set; }

        public string SupplierName { get; set; }

        public decimal Longitude { get; set; }

        public decimal Latitude { get; set; }

        public string Description { get; set; }

        public int ReviewCount { get; set; }
    }
}
