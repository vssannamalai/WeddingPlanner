using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using RatingReviewEngine.Web.HelperClass;

namespace RatingReviewEngine.Web
{
    /// <summary>
    /// Summary description for LoginService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class LoginService : System.Web.Services.WebService
    {
        [WebMethod(true)]
        public string GetSession(string strSessionName)
        {
            string SessionValue = "";
            if (Session[strSessionName] != null)
            {
                if (strSessionName == "UserName")
                    SessionValue = SessionHelper.UserName;
            }

            return SessionValue;
        }

        [WebMethod(true)]
        public void SetLoginSession(string OAuthAccountId, string UserName, string Provider, string IsValid, string IsCommunityOwner, string IsSupplier, string IsCustomer, string IsAdministrator, string CommunityOwnerId, string SupplierId, string CustomerId, string AdministratorId, string AllowedPages)
        {
            SessionHelper.OAuthAccountId = Convert.ToInt32(OAuthAccountId);
            SessionHelper.UserName = UserName;
            SessionHelper.Provider = Provider;
            SessionHelper.IsValid = Convert.ToBoolean(IsValid);

            SessionHelper.IsCommunityOwner = Convert.ToBoolean(IsCommunityOwner);
            SessionHelper.IsSupplier = Convert.ToBoolean(IsSupplier);
            SessionHelper.IsCustomer = Convert.ToBoolean(IsCustomer);
            SessionHelper.IsAdministrator = Convert.ToBoolean(IsAdministrator);

            SessionHelper.CommunityOwnerId = Convert.ToInt32(CommunityOwnerId);
            SessionHelper.SupplierId = Convert.ToInt32(SupplierId);
            SessionHelper.CustomerId = Convert.ToInt32(CustomerId);
            SessionHelper.AdministratorId = Convert.ToInt32(AdministratorId);

            SessionHelper.AllowedPages = AllowedPages;
        }


        [WebMethod(true)]
        public void SetCommunityOwnerSession(string IsCommunityOwner, string CommunityOwnerId)
        {
            SessionHelper.IsCommunityOwner = Convert.ToBoolean(IsCommunityOwner);
            SessionHelper.CommunityOwnerId = Convert.ToInt32(CommunityOwnerId);
        }

        [WebMethod(true)]
        public void SetSupplierSession(string IsSupplier, string SupplierId)
        {
            SessionHelper.IsSupplier = Convert.ToBoolean(IsSupplier);
            SessionHelper.SupplierId = Convert.ToInt32(SupplierId);
        }

        [WebMethod(true)]
        public void SetAllowedPages(string pages)
        {
            SessionHelper.AllowedPages = pages;
        }

        [WebMethod(true)]
        public string ClearSession()
        {
            System.Web.HttpContext.Current.Session.Clear();
            return "";
        }
    }
}
