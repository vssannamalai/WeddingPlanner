using RatingReviewEngine.DAC;
using RatingReviewEngine.Entities;
using RatingReviewEngine.Entities.ServiceRequest;
using RatingReviewEngine.Entities.ServiceResponse;
using RatingReviewEngine.Business.Shared;

namespace RatingReviewEngine.Business
{
    public class UserComponent
    {
        /// <summary>
        /// Validate the login details against existing active registered account
        /// </summary>
        /// <param name="loginRequests"></param>
        /// <returns></returns>
        public LoginResponse ValidateAccount(LoginRequest loginRequest)
        {
            LoginResponse loginServiceResponse = new LoginResponse();
            UserDAC userDAC = new UserDAC();
            //For authentication using General OAuth provider, Encrypt the plain text password to compare against the encrypted password.
            if (loginRequest.Provider == GlobalConstants.strProvider)
            {
                loginRequest.Token = Shared.Cryptographer.Encrypt(loginRequest.Token);
            }

            loginServiceResponse = userDAC.ValidateAccount(loginRequest);

            //If login success store the OAuth token in a session variable so that the subsequent request will be validated against OAuth Token stored in session variable
            //TODO: Need to revise while implementing OAuth 2.0 provider. Whether to pass the OAuth Token stored in database or we need to generate a temporary access token.
            if (loginServiceResponse.strOut == "valid")
            {
                loginServiceResponse.AuthId = loginRequest.ProviderUserID;
                loginServiceResponse.AuthToken = loginRequest.Token;
                SessionHelper.OAuthToken = loginRequest.Token;

                AdministratorComponent administratorComponent = new AdministratorComponent();
                loginServiceResponse.AllowedPages = administratorComponent.AccessRightSelectByOAuthaccount(loginServiceResponse.OAuthAccountID);
            }

            return loginServiceResponse;
        }

        public bool ValidateAPIToken(string APIToken)
        {
            AuthenticationDAC authenticationDAC = new AuthenticationDAC();
            return authenticationDAC.ValidateAPIToken(APIToken);
        }


        /// <summary>
        /// Create new account within the system based on the supplied details (OAuthAccount)
        /// </summary>
        /// <param name="oauthAccount"></param>
        public int RegisterNewAccount(OAuthAccount oauthAccount)
        {
            UserDAC userDAC = new UserDAC();
            int oAuthAccountId = 0;
            //If registered using General OAuth provider , encrypt the password before saving it into database
            if (oauthAccount.Provider == GlobalConstants.strProvider)
            {
                oauthAccount.Token = Shared.Cryptographer.Encrypt(oauthAccount.Token);
            }

            oAuthAccountId = userDAC.RegisterNewAccount(oauthAccount);
            if (oauthAccount.Provider == GlobalConstants.strProvider)
            {
                SendAccountActivationEmail(oauthAccount.ProviderUserID);
            }

            return oAuthAccountId;
        }

        private void SendAccountActivationEmail(string providerUserId)
        {
            EmailDispatcher emailDispatcher = new EmailDispatcher();
            string strEmailBody = emailDispatcher.GenerateActivateAccountEmail(Shared.Cryptographer.Encrypt(providerUserId));
            emailDispatcher.SendEmail("FromEmail", providerUserId, "Ratings & Reviews Engine: Activate your account", strEmailBody, true);
        }


        /// <summary>
        /// Activate the account for the registered email
        /// </summary>
        /// <param name="providerUserId"></param>
        /// <returns></returns>
        public AccountActivationResponse ActivateAccount(string providerUserId)
        {
            UserDAC userDAC = new UserDAC();
            providerUserId = Shared.Cryptographer.Decrypt(providerUserId);
            if (providerUserId != string.Empty)
            {
                return userDAC.AccountActivate(providerUserId);
            }
            else
            {
                AccountActivationResponse response = new AccountActivationResponse();
                response.ActivationMessage = "invalid";
                return response;
            }
        }

        /// <summary>
        /// Check Provider and UserID already Exist IF Exist return Valid ELSE Invalid
        /// </summary>
        /// <param name="oauthAccount"></param>
        /// <returns></returns>
        public string CheckValidUserID(OAuthAccount oauthAccount)
        {
            UserDAC userDAC = new UserDAC();
            return userDAC.CheckValidUserID(oauthAccount);
        }

        /// <summary>
        /// Change password
        /// </summary>
        /// <param name="oauthaccount"></param>
        public string OAuthAccountTokenUpdate(OAuthAccount oauthAccount)
        {
            UserDAC userDAC = new UserDAC();

            oauthAccount.ProviderUserID = Shared.Cryptographer.Decrypt(oauthAccount.ProviderUserID);
            oauthAccount.Token = Shared.Cryptographer.Encrypt(oauthAccount.Token);
            return userDAC.OAuthAccountTokenUpdate(oauthAccount);
        }
        /// <summary>
        /// Delete data from UserSecurity, EntityOAuthAccount and OAuthAccount tables. (Unit test purpose)
        /// </summary>
        /// <param name="oauthAccountId"></param>
        public void OAuthAccountDelete(int oauthAccountId)
        {
            UserDAC userDAC = new UserDAC();
            userDAC.OAuthAccountDelete(oauthAccountId);
        }
    }
}
