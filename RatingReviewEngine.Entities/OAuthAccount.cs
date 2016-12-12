using RatingReviewEngine.Entities.ServiceRequest;

namespace RatingReviewEngine.Entities
{
    public class OAuthAccount : ServiceRequestBase
    {
        #region Basic Properties

        public int OAuthAccountID { get; set; }

        /// <summary>
        /// NB: If the provider is not actually an OAuth Provider (i.e., isn't facebook, twitter, etc), as the user has 
        /// opted to register their account via email & password, then the Provider is "General"
        /// </summary>
        public string Provider { get; set; }

        /// <summary>
        /// NB: If the provider is not actually an OAuth Provider is "General", as the user has opted to register their 
        /// account via email & password, then the ProviderUserID is the users' Email Address.
        /// </summary>
        public string ProviderUserID { get; set; }

        public string Token { get; set; }        

        #endregion

        #region Relative Properties

        #endregion
    }
}
