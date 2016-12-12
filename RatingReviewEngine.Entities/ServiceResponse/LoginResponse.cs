namespace RatingReviewEngine.Entities.ServiceResponse
{
    public class LoginResponse : ServiceResponseBase
    {
        public string strOut { get; set; }

        public string AuthId { get; set; }
        
        public string AuthToken { get; set; }

        public int OAuthAccountID { get; set; }

        public bool Active { get; set; }

        public bool IsCommunityOwner { get; set; }

        public bool IsSupplier { get; set; }

        public bool IsCustomer { get; set; }

        public bool IsAdministrator { get; set; }

        public int SupplierID { get; set; }

        public int CommunityOwnerID { get; set; }

        public int CustomerID { get; set; }

        public int AdministratorID { get; set; }

        public string UserName { get; set; }

        public string AllowedPages { get; set; }
    }
}
