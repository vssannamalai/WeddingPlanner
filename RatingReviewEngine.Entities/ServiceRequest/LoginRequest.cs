namespace RatingReviewEngine.Entities.ServiceRequest
{
    public class LoginRequest : ServiceRequestBase
    {
        public string Provider { get; set; }

        public string ProviderUserID { get; set; }

        public string Token { get; set; } 
    }
}
