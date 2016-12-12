using System;
using System.Web.Configuration;
using RatingReviewEngine.Web.HelperClass;
using System.Web;
using System.Web.UI;

namespace RatingReviewEngine.Web
{
    public partial class RatingReviewEngine : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitializeBaseValues();
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
        }
        #region LanguageSelection
        /*
        //On En Button click, change the value of the CurrentLanguage cookie
        //reload page with English edition

        protected void ImgBut_En_Click(object sender, ImageClickEventArgs e)
        {
            HttpCookie cookie = new HttpCookie("CurrentLanguage");
            cookie.Value = "en-US";
            Response.SetCookie(cookie);
            Response.Redirect(Request.RawUrl);

        }

        //On En Button click, change the value of the CurrentLanguage cookie
        //reload page with French edition

        protected void ImgBut_Ta_Click(object sender, ImageClickEventArgs e)
        {
            HttpCookie cookie = new HttpCookie("CurrentLanguage");
            cookie.Value = "ta-IN";
            Response.SetCookie(cookie);
            Response.Redirect(Request.RawUrl);

        }
         */
        #endregion
    }
}