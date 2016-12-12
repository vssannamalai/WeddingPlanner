using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Membership.OpenAuth;
using RatingReviewEngine.Web.HelperClass;

namespace RatingReviewEngine.Web.App_Start
{
    internal static class AuthConfig
    {
        public static void RegisterOpenAuth()
        {
            // See http://go.microsoft.com/fwlink/?LinkId=252803 for details on setting up this ASP.NET
            // application to support logging in via external services.

            OpenAuth.AuthenticationClients.AddTwitter(
                consumerKey:ConfigurationHelper.TwitterKey, //"uVkWkacLN6Q4vlOB7jXdXPYrE",
                consumerSecret:ConfigurationHelper.TwitterSecret); //"7MoksWaEoanPHSZ5wzjEoLvdUH0HDDL6xnXYffrbPDBjUmUZIq");

            OpenAuth.AuthenticationClients.AddFacebook(
                appId:ConfigurationHelper.FacebookID, //"312069488942229",
                appSecret: ConfigurationHelper.FacebookSecret);//"e944bd5adb63b731faa80d7a02e7ac49");

            //OpenAuth.AuthenticationClients.AddMicrosoft(
            //    clientId: ConfigurationHelper.MicrosoftId,//"000000004811841E",
            //    clientSecret:ConfigurationHelper.MicrosoftSecret); //"K4pA2Jkz06-dAAOyq-ddGoMdq1SAo0bz");

            OpenAuth.AuthenticationClients.AddGoogle();
        }
    }
}