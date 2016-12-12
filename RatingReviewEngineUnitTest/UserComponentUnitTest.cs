using Microsoft.VisualStudio.TestTools.UnitTesting;
using RatingReviewEngine.Business;
using RatingReviewEngine.Entities;
using RatingReviewEngine.Entities.ServiceRequest;

namespace RatingReviewEngineUnitTest
{
    [TestClass]
    public class UserComponentUnitTest
    {
        int oauthId;

        [TestMethod]
        public void TestValidLogin()
        {
            UserComponent userComponent = new UserComponent();
            LoginRequest loginServiceRequest = new LoginRequest();
            loginServiceRequest.Provider = "General";
            loginServiceRequest.ProviderUserID = "hemachandran@versatile-soft.com";
            loginServiceRequest.Token = "test";
            var expected = "valid";
            var result = userComponent.ValidateAccount(loginServiceRequest);
            Assert.AreEqual(expected, result.strOut);
        }

        [TestMethod]
        public void TestInValidLogin()
        {
            UserComponent userComponent = new UserComponent();
            LoginRequest loginServiceRequest = new LoginRequest();
            loginServiceRequest.Provider = "invalidauthprovider";
            loginServiceRequest.ProviderUserID = "invaliduser";
            loginServiceRequest.Token = "invalidtoken";
            var expected = "invalid";
            var result = userComponent.ValidateAccount(loginServiceRequest);
            Assert.AreEqual(expected, result.strOut);
        }

        [TestMethod]
        public void TestRegisterNewAccount()
        {
            OAuthAccount oauthAccount = new OAuthAccount();
            oauthAccount.Provider = "GeneralTest";
            oauthAccount.ProviderUserID = "unittest@test.com";
            oauthAccount.Token = "test";

            UserComponent userComponent = new UserComponent();
            oauthId = userComponent.RegisterNewAccount(oauthAccount);
        }

        [TestCleanup()]
        public void TestRegisterDeleteAccount()
        {
            UserComponent userComponent = new UserComponent();

            if(oauthId > 0)
                userComponent.OAuthAccountDelete(oauthId);
        }
    }
}
