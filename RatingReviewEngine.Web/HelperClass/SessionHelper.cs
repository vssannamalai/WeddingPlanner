using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace RatingReviewEngine.Web.HelperClass
{
    public static class SessionHelper
    {
        public static int OAuthAccountId
        {
            get
            {
                return Convert.ToInt32(System.Web.HttpContext.Current.Session["OAuthAccountId"]);

            }
            set
            {
                System.Web.HttpContext.Current.Session["OAuthAccountId"] = value;
            }
        }

        public static string UserName
        {
            get
            {
                return Convert.ToString(System.Web.HttpContext.Current.Session["UserName"]);
            }
            set
            {
                System.Web.HttpContext.Current.Session["UserName"] = value;
            }
        }

        public static string Token
        {
            get
            {
                return Convert.ToString(System.Web.HttpContext.Current.Session["Token"]);
            }
            set
            {
                System.Web.HttpContext.Current.Session["Token"] = value;
            }
        }

        public static string Provider
        {
            get
            {
                return Convert.ToString(System.Web.HttpContext.Current.Session["Provider"]);
            }
            set
            {
                System.Web.HttpContext.Current.Session["Provider"] = value;
            }
        }

        public static bool IsValid
        {
            get
            {
                return Convert.ToBoolean(System.Web.HttpContext.Current.Session["IsValid"]);

            }
            set
            {
                System.Web.HttpContext.Current.Session["IsValid"] = value;
            }
        }

        public static bool IsCommunityOwner
        {
            get
            {
                return Convert.ToBoolean(System.Web.HttpContext.Current.Session["IsCommunityOwner"]);

            }
            set
            {
                System.Web.HttpContext.Current.Session["IsCommunityOwner"] = value;
            }
        }

        public static bool IsSupplier
        {
            get
            {
                return Convert.ToBoolean(System.Web.HttpContext.Current.Session["IsSupplier"]);

            }
            set
            {
                System.Web.HttpContext.Current.Session["IsSupplier"] = value;
            }
        }

        public static bool IsCustomer
        {
            get
            {
                return Convert.ToBoolean(System.Web.HttpContext.Current.Session["IsCustomer"]);

            }
            set
            {
                System.Web.HttpContext.Current.Session["IsCustomer"] = value;
            }
        }

        public static bool IsAdministrator
        {
            get
            {
                return Convert.ToBoolean(System.Web.HttpContext.Current.Session["IsAdministrator"]);

            }
            set
            {
                System.Web.HttpContext.Current.Session["IsAdministrator"] = value;
            }
        }

        public static int CommunityOwnerId
        {
            get
            {
                return Convert.ToInt32(System.Web.HttpContext.Current.Session["CommunityOwnerId"]);

            }
            set
            {
                System.Web.HttpContext.Current.Session["CommunityOwnerId"] = value;
            }

        }

        public static int SupplierId
        {
            get
            {
                return Convert.ToInt32(System.Web.HttpContext.Current.Session["SupplierId"]);

            }
            set
            {
                System.Web.HttpContext.Current.Session["SupplierId"] = value;
            }

        }

        public static int CustomerId
        {
            get
            {
                return Convert.ToInt32(System.Web.HttpContext.Current.Session["CustomerId"]);

            }
            set
            {
                System.Web.HttpContext.Current.Session["CustomerId"] = value;
            }

        }

        public static int AdministratorId
        {
            get
            {
                return Convert.ToInt32(System.Web.HttpContext.Current.Session["AdministratorId"]);

            }
            set
            {
                System.Web.HttpContext.Current.Session["AdministratorId"] = value;
            }

        }

        public static bool IsAdminDashboard
        {
            get
            {
                return Convert.ToBoolean(System.Web.HttpContext.Current.Session["IsAdminDashboard"]);

            }
            set
            {
                System.Web.HttpContext.Current.Session["IsAdminDashboard"] = value;
            }
        }

        public static bool IsOwnerDashboard
        {
            get
            {
                return Convert.ToBoolean(System.Web.HttpContext.Current.Session["IsOwnerDashboard"]);

            }
            set
            {
                System.Web.HttpContext.Current.Session["IsOwnerDashboard"] = value;
            }
        }

        public static bool IsSupplierDashboard
        {
            get
            {
                return Convert.ToBoolean(System.Web.HttpContext.Current.Session["IsSupplierDashboard"]);

            }
            set
            {
                System.Web.HttpContext.Current.Session["IsSupplierDashboard"] = value;
            }
        }

        public static string AllowedPages
        {
            get
            {
                return System.Web.HttpContext.Current.Session["AllowedPages"] == null ? string.Empty : System.Web.HttpContext.Current.Session["AllowedPages"].ToString();
            }
            set
            {
                System.Web.HttpContext.Current.Session["AllowedPages"] = value;
            }
        }
        public static string[] AllowedPageArray
        {
            get
            {
                return System.Web.HttpContext.Current.Session["AllowedPages"].ToString().Split(',');
            }
        }
    }
}