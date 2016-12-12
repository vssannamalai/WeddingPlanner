using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
namespace RatingReviewEngine.Business.Shared
{
    public static class SessionHelper
    {
        public static string OAuthToken
        {
            get
            {
                if (System.Web.HttpContext.Current != null)
                    return Convert.ToString(System.Web.HttpContext.Current.Session["OAuthToken"]);
                else
                    return "";
            }
            set
            {
                if (System.Web.HttpContext.Current != null)
                    System.Web.HttpContext.Current.Session["OAuthToken"] = value;
            }
        }
    }
}
