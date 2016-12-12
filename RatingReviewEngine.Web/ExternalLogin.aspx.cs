using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Net;
using System.IO;
using System.Configuration;

using DotNetOpenAuth.AspNet;
using Microsoft.AspNet.Membership.OpenAuth;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using RatingReviewEngine.Web.HelperClass;

namespace RatingReviewEngine.Web
{
    public partial class ExternalLogin : System.Web.UI.Page
    {
        #region Properties
        protected string ProviderName
        {
            get { return (string)ViewState["ProviderName"] ?? String.Empty; }
            private set { ViewState["ProviderName"] = value; }
        }

        protected string ProviderDisplayName
        {
            get { return (string)ViewState["ProviderDisplayName"] ?? String.Empty; }
            private set { ViewState["ProviderDisplayName"] = value; }
        }

        protected string ProviderUserId
        {
            get { return (string)ViewState["ProviderUserId"] ?? String.Empty; }
            private set { ViewState["ProviderUserId"] = value; }
        }

        protected string ProviderUserName
        {
            get { return (string)ViewState["ProviderUserName"] ?? String.Empty; }
            private set { ViewState["ProviderUserName"] = value; }
        }
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                ProcessProviderResult();
        }

        private void ProcessProviderResult()
        {
            // Process the result from an auth provider in the request
            ProviderName = OpenAuth.GetProviderNameFromCurrentRequest();

            if (String.IsNullOrEmpty(ProviderName))
            {
                Response.Redirect(FormsAuthentication.LoginUrl);
            }

            // Build the redirect url for OpenAuth verification
            var redirectUrl = "~/ExternalLogin";
            var returnUrl = Request.QueryString["ReturnUrl"];
            if (!String.IsNullOrEmpty(returnUrl))
            {
                redirectUrl += "?ReturnUrl=" + HttpUtility.UrlEncode(returnUrl);
            }

            // Verify the OpenAuth payload
            var authResult = OpenAuth.VerifyAuthentication(redirectUrl);
            ProviderDisplayName = OpenAuth.GetProviderDisplayName(ProviderName);
            if (!authResult.IsSuccessful)
            {
                Title = "External login failed";
                lblMsg.Text = Title;

                ModelState.AddModelError("Provider", String.Format("External login {0} failed.", ProviderDisplayName));

                // To view this error, enable page tracing in web.config (<system.web><trace enabled="true"/></system.web>) and visit ~/Trace.axd
                Trace.Warn("OpenAuth", String.Format("There was an error verifying authentication with {0})", ProviderDisplayName), authResult.Error);
                Response.Redirect("Home.aspx", false);
                return;
            }
            else
            {
                string ServiceUrl = HelperClass.ConfigurationHelper.APIUrl;
                var httpWebRequest = (HttpWebRequest)WebRequest.Create(ServiceUrl + "Login");
                ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;
                httpWebRequest.ContentType = "text/json";
                httpWebRequest.Method = "POST";
                httpWebRequest.Headers.Add("APIToken", ConfigurationHelper.APIToken);
                httpWebRequest.Headers.Add("AuthToken", string.Empty);

                string token = string.Empty;

                using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
                {

                    switch (authResult.Provider)
                    {
                        case "google":
                            token = authResult.ProviderUserId.Replace("https://www.google.com/accounts/o8/id?id=", "");
                            break;
                        case "facebook":
                            token = authResult.ProviderUserId;
                            break;
                        case "twitter":
                            token = authResult.ProviderUserId;
                            break;
                    }
                    string json = "{\"Provider\": \"" + authResult.Provider + "\", \"ProviderUserID\": \"" + authResult.UserName + "\", \"Token\": \"" + token + "\"}";

                    streamWriter.Write(json);
                    streamWriter.Flush();
                    streamWriter.Close();
                }
                var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
                using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                {
                    var result = streamReader.ReadToEnd();
                    //result = result.Replace("{", "").Replace("}", "").Replace("\"", "");

                    JObject jObject = JObject.Parse(result);
                    JsonSerializer serializer = new JsonSerializer();
                    LoginResponse loginResponse = (LoginResponse)serializer.Deserialize(new JTokenReader(jObject), typeof(LoginResponse));

                    if (!result.Contains("invalid"))
                    {
                        HelperClass.SessionHelper.Provider = authResult.Provider;

                        SessionHelper.UserName = authResult.UserName;
                        SessionHelper.Token = token;
                        SessionHelper.IsValid = true;

                        SessionHelper.OAuthAccountId = loginResponse.OAuthAccountID;
                        SessionHelper.OAuthAccountId = loginResponse.OAuthAccountID;
                        SessionHelper.IsCommunityOwner = loginResponse.IsCommunityOwner;
                        SessionHelper.IsSupplier = loginResponse.IsSupplier;
                        SessionHelper.IsCustomer = loginResponse.IsCustomer;
                        SessionHelper.IsAdministrator = loginResponse.IsAdministrator;
                        SessionHelper.CommunityOwnerId = loginResponse.CommunityOwnerID;
                        SessionHelper.SupplierId = loginResponse.SupplierID;
                        SessionHelper.CustomerId = loginResponse.CustomerID;
                        SessionHelper.AdministratorId = loginResponse.AdministratorID;
                        SessionHelper.AllowedPages = loginResponse.AllowedPages;
                        if (SessionHelper.IsSupplier && SessionHelper.IsCommunityOwner)
                            Response.Redirect("~/Settings.aspx");
                        else if (SessionHelper.IsCommunityOwner)
                        {
                            SessionHelper.IsOwnerDashboard = true;
                            Response.Redirect("~/CommunityOwnerDashboard.aspx");
                        }
                        else if (SessionHelper.IsSupplier)
                        {
                            SessionHelper.IsSupplierDashboard = true;
                            Response.Redirect("~/SupplierDashboard.aspx");
                        }
                        else
                            Response.Redirect("~/Settings.aspx");
                    }

                    else
                    {
                        // Register new Account
                        var httpWebRequest1 = (HttpWebRequest)WebRequest.Create(ServiceUrl + "RegisterAccount");
                        ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;
                        httpWebRequest1.ContentType = "text/json";
                        httpWebRequest1.Method = "POST";
                        httpWebRequest1.Headers.Add("APIToken", ConfigurationHelper.APIToken);
                        httpWebRequest1.Headers.Add("AuthToken", string.Empty);

                        using (var streamWriter1 = new StreamWriter(httpWebRequest1.GetRequestStream()))
                        {
                            string json = "{\"Provider\": \"" + authResult.Provider + "\", \"ProviderUserID\": \"" + authResult.UserName + "\", \"Token\": \"" + token + "\"}";

                            streamWriter1.Write(json);
                            streamWriter1.Flush();
                            streamWriter1.Close();
                        }
                        var httpResponse1 = (HttpWebResponse)httpWebRequest1.GetResponse();
                        using (var streamReader1 = new StreamReader(httpResponse1.GetResponseStream()))
                        {
                            var result1 = streamReader1.ReadToEnd();



                            JObject jObjectRegisterResponse = JObject.Parse(result1);
                            JsonSerializer serializerRegisterResponse = new JsonSerializer();
                            RegisterAccountResponse registerResponse = (RegisterAccountResponse)serializerRegisterResponse.Deserialize(new JTokenReader(jObjectRegisterResponse), typeof(RegisterAccountResponse));



                            HelperClass.SessionHelper.Provider = authResult.Provider;
                            HelperClass.SessionHelper.UserName = authResult.UserName;
                            HelperClass.SessionHelper.OAuthAccountId = registerResponse.OAuthAccountId;
                            HelperClass.SessionHelper.Token = token;
                            HelperClass.SessionHelper.IsValid = true;

                            Response.Redirect("~/Settings.aspx");
                        }

                    }
                }

            }
            // User has logged in with provider successfully
            // Check if user is already registered locally
            //if (OpenAuth.Login(authResult.Provider, authResult.ProviderUserId, createPersistentCookie: false))
            //{
            //    RedirectToReturnUrl();
            //}

            //// Store the provider details in ViewState
            //ProviderName = authResult.Provider;
            //ProviderUserId = authResult.ProviderUserId;
            //ProviderUserName = authResult.UserName;

            //// Strip the query string from action
            //Form.Action = ResolveUrl(redirectUrl);

            //if (User.Identity.IsAuthenticated)
            //{
            //    // User is already authenticated, add the external login and redirect to return url
            //    OpenAuth.AddAccountToExistingUser(ProviderName, ProviderUserId, ProviderUserName, User.Identity.Name);
            //    RedirectToReturnUrl();
            //}
            //else
            //{
            //    // User is new, ask for their desired membership name
            //    lblMsg.Text = authResult.UserName;
            //}
        }

        private void RedirectToReturnUrl()
        {
            var returnUrl = Request.QueryString["ReturnUrl"];
            if (!String.IsNullOrEmpty(returnUrl) && OpenAuth.IsLocalUrl(returnUrl))
            {
                Response.Redirect(returnUrl);
            }
            else
            {
                Response.Redirect("~/");
            }
        }
    }

    public class LoginResponse
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

        public string AllowedPages { get; set; }
    }

    public class RegisterAccountResponse
    {
        public int OAuthAccountId { get; set; }
    }
}