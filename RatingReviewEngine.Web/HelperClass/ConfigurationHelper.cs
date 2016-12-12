using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;

namespace RatingReviewEngine.Web.HelperClass
{
    public static class ConfigurationHelper
    {

        public static string APIToken
        {
            get
            {
                return ConfigurationManager.AppSettings["APIToken"].ToString();
            }
        }

        public static string APIUrl
        {
            get
            {
                return ConfigurationManager.AppSettings["APIUrl"].ToString();
            }
        }

        public static string WebUrl
        {
            get
            {
                return ConfigurationManager.AppSettings["WebUrl"].ToString();
            }
        }

        public static string FileUploadUrl
        {
            get
            {
                return ConfigurationManager.AppSettings["FileUploadUrl"].ToString();
            }
        }

        public static string TwitterKey
        {
            get
            {
                return ConfigurationManager.AppSettings["TwittKey"].ToString();
            }
        }

        public static string TwitterSecret
        {
            get
            {
                return ConfigurationManager.AppSettings["TwittSecret"].ToString();
            }
        }

        public static string FacebookID
        {
            get
            {
                return ConfigurationManager.AppSettings["FacebookID"].ToString();
            }
        }

        public static string FacebookSecret
        {
            get
            {
                return ConfigurationManager.AppSettings["FacebookSecret"].ToString();
            }
        }

        public static string MicrosoftId
        {
            get
            {
                return ConfigurationManager.AppSettings["MicrosoftId"].ToString();
            }
        }

        public static string MicrosoftSecret
        {
            get
            {
                return ConfigurationManager.AppSettings["MicrosoftSecret"].ToString();
            }
        }
    }
}