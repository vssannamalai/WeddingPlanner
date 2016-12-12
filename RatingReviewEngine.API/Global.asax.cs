using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;

namespace RatingReviewEngine.API
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            APITokenVerification = Convert.ToBoolean(ConfigurationSettings.AppSettings["APITokenVerification"].ToString() );
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            HttpContext.Current.Response.AddHeader("Access-Control-Allow-Origin", "*");
            //HttpContext.Current.Response.AddHeader("Access-Control-Allow-Origin", "http://localhost:3302");
            if (HttpContext.Current.Request.HttpMethod == "OPTIONS")
            {
                //HttpContext.Current.Response.AddHeader("Domain", "localhost");
                HttpContext.Current.Response.AddHeader("Cache-Control", "cache");
                HttpContext.Current.Response.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
                HttpContext.Current.Response.AddHeader("Access-Control-Allow-Headers", "Content-Type, Accept, APIToken, AuthToken, AuthUserId,Authorization");
                HttpContext.Current.Response.AddHeader("Access-Control-Max-Age", "1728000");
                HttpContext.Current.Response.AddHeader("Access-Control-Allow-Credentials", "true");

                HttpContext.Current.Response.End();
            }
        }

        void Application_EndRequest(Object sender, EventArgs e)
        {
            if (Response.Cookies.Count > 0)
            {
                foreach (string s in Response.Cookies.AllKeys)
                {
                    if (s == "ASP.NET_SessionId")
                    {
                        Response.Cookies["ASP.NET_SessionId"].HttpOnly = false;
                    }
                }
            }

        }
        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }

        public static bool APITokenVerification { get; set; }
       
    }
}