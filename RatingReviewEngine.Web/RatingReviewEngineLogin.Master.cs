using System;
using System.Web.Configuration;
using System.Web;
using System.Collections.Generic;
using System.Linq;

using RatingReviewEngine.Web.HelperClass;

namespace RatingReviewEngine.Web
{
    public partial class RatingReviewEngineLogin : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();

            if (!IsPostBack)
            {
                InitializeBaseValues();

                string currenctPage = Request.Url.Segments[Request.Url.Segments.Length - 1].ToLower();
                if (currenctPage == "webform1.aspx" || currenctPage == "terms.aspx" || currenctPage == "privacy.aspx" || currenctPage == "aboutus.aspx" || currenctPage == "contactus.aspx"
                    || currenctPage == "home.aspx" || currenctPage == "resetpassword.aspx")
                {

                }
                else
                {
                    if (currenctPage != "nopermission.aspx" && currenctPage != "nodata.aspx" && currenctPage != "paymentresponse.aspx" && currenctPage != "paymentresult.aspx")
                    {
                        if (string.IsNullOrEmpty(SessionHelper.AllowedPages))
                        {
                            if (SessionHelper.IsValid)
                            {
                                if (currenctPage != "registerassupplier.aspx" && currenctPage != "registerascommunityowner.aspx" && currenctPage != "settings.aspx" && currenctPage != "paymentresponse.aspx" && currenctPage != "paymentresult.aspx")
                                {
                                    Response.Redirect("NoPermission.aspx", false);
                                }
                            }

                        }
                        else
                        {
                            if (!SessionHelper.AllowedPageArray.Contains(currenctPage))
                            {
                                Response.Redirect("NoPermission.aspx", false);
                            }
                        }
                    }

                    if (hdnUserName.Value == "")
                    {
                        Response.Redirect("Home.aspx", false);
                    }
                }
            }
        }

        /// <summary>
        /// Assign the settings like WebAPI url and Token to hidden field to access it the service from jquery. 
        /// Assign user details from session.
        /// </summary>
        private void InitializeBaseValues()
        {
            hdnAPIUrl.Value = ConfigurationHelper.APIUrl;
            hdnApplicationAPIToken.Value = ConfigurationHelper.APIToken;
            hdnWebUrl.Value = ConfigurationHelper.WebUrl;
            hdnFileUploadUrl.Value = ConfigurationHelper.FileUploadUrl;

            if (SessionHelper.IsValid == true)
            {
                email.InnerHtml = SessionHelper.UserName;
                hdnUserName.Value = SessionHelper.UserName;
                hdnAuthToken.Value = SessionHelper.Token;
                hdnCommunityOwnerId.Value = SessionHelper.CommunityOwnerId.ToString();
                hdnSupplierId.Value = SessionHelper.SupplierId.ToString();
                hdnOAuthAccountID.Value = SessionHelper.OAuthAccountId.ToString();
            }
        }
    }
}