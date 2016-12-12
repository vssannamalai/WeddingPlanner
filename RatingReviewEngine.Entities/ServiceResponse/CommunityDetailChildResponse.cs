namespace RatingReviewEngine.Entities.ServiceResponse
{
    public class CommunityDetailChildResponse : ServiceResponseBase
    {
        public int CommunityGroupId { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        public int SupplierCount { get; set; }

        public decimal AverageRating { get; set; }

        public decimal MyRating { get; set; }

        public int ReviewCount { get; set; }

        public decimal TotalIncome { get; set; }

        public int CurrencyID { get; set; }

        public string CurrencyName { get; set; }

        public string IsActive { get; set; }
    }
}