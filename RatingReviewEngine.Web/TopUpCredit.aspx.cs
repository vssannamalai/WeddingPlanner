using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Net;
using System.IO;
using System.Configuration;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using RatingReviewEngine.Web.HelperClass;

namespace RatingReviewEngine.Web
{
    public partial class TopUpCredit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {

            }
        }

        protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
        {
            string ServiceUrl = HelperClass.ConfigurationHelper.APIUrl;
            var httpWebRequest = (HttpWebRequest)WebRequest.Create(ServiceUrl + "PayflowPaypalPayment");
            //  ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;
            httpWebRequest.ContentType = "text/json";
            httpWebRequest.Method = "POST";
            httpWebRequest.Headers.Add("APIToken", ConfigurationHelper.APIToken);
            httpWebRequest.Headers.Add("AuthToken", string.Empty);

            string token = string.Empty;

            using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
            {


                string json = "{\"OAuthAccountID\": \"" + SessionHelper.OAuthAccountId + "\", \"Amount\": \"" + "20" + "\", \"Currency\": \"" + "AUD" + "\"}";

                streamWriter.Write(json);
                streamWriter.Flush();
                streamWriter.Close();
            }
            var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
            using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
            {
                var result = streamReader.ReadToEnd();
                //JObject jObject = JObject.Parse(result);
            }
        }
    }
}