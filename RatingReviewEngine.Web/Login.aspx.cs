using System;
using System.Configuration;
using System.Globalization;
using System.Web;

namespace RatingReviewEngine.Web
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                OpenAuthLogin.ReturnUrl = Request.QueryString["ReturnUrl"];
            }
        }

       /* protected override void InitializeCulture()
        {
            string lang = string.Empty;
            HttpCookie cookie = Request.Cookies["CurrentLanguage"];

            if (cookie != null && cookie.Value != null)
            {
                lang = cookie.Value;
                CultureInfo Cul = CultureInfo.CreateSpecificCulture(lang);

                System.Threading.Thread.CurrentThread.CurrentUICulture = Cul;
                System.Threading.Thread.CurrentThread.CurrentCulture = Cul;
            }
            else
            {
                if (string.IsNullOrEmpty(lang)) lang = "en-US";
                CultureInfo Cul = CultureInfo.CreateSpecificCulture(lang);

                System.Threading.Thread.CurrentThread.CurrentUICulture = Cul;
                System.Threading.Thread.CurrentThread.CurrentCulture = Cul;

                HttpCookie cookie_new = new HttpCookie("CurrentLanguage");
                cookie_new.Value = lang;
                Response.SetCookie(cookie_new);
            }

            base.InitializeCulture();
        }*/
    }
}