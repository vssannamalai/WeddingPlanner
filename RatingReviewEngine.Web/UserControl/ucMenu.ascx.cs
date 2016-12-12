using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.IO;

using RatingReviewEngine.Web.HelperClass;

namespace RatingReviewEngine.Web.UserControl
{
    public partial class ucMenu : System.Web.UI.UserControl
    {
        private void InitializeBaseValues()
        {


            if (SessionHelper.IsAdminDashboard == true)
            {
                AdminMenu.Visible = true;
            }
            else
                AdminMenu.Visible = false;

            if (SessionHelper.IsOwnerDashboard == true)
            {
                CommuniyMenu.Visible = true;
            }
            else
                CommuniyMenu.Visible = false;

            if (SessionHelper.IsSupplierDashboard == true)
            {
                SupplierMenu.Visible = true;
            }
            else
                SupplierMenu.Visible = false;

            if (string.IsNullOrEmpty(SessionHelper.AllowedPages))
            {
                string ServiceUrl = HelperClass.ConfigurationHelper.APIUrl;
                var httpWebRequest = (HttpWebRequest)WebRequest.Create(ServiceUrl + "GetAllowedPagesByOAuthAccount/" + SessionHelper.OAuthAccountId);
                ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;
                httpWebRequest.ContentType = "text/json";
                httpWebRequest.Method = "GET";
                httpWebRequest.Headers.Add("APIToken", ConfigurationHelper.APIToken);
                httpWebRequest.Headers.Add("AuthToken", string.Empty);

                var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
                using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                {
                    var result = streamReader.ReadToEnd();
                    SessionHelper.AllowedPages = result.Replace("\"", "");
                }
            }

          

        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitializeBaseValues();
            }
        }
    }
}