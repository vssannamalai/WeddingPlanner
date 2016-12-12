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
    public partial class PaymentResponse : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                string transId = string.Empty;
                try
                {
                    string token = Request.Params["Token"].ToString();
                    string payerId = Request.Params["PayerID"].ToString();
                    string param = Request.QueryString["od"].ToString();
                    string[] splitParam = param.Split('_');
                    string communityName = string.Empty;
                    communityName = splitParam[7];

                    string ServiceUrl = HelperClass.ConfigurationHelper.APIUrl;
                    var httpWebRequest = (HttpWebRequest)WebRequest.Create(ServiceUrl + "PayflowPaypalPaymentConfirm");
                    //  ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;
                    httpWebRequest.ContentType = "text/json";
                    httpWebRequest.Method = "POST";
                    httpWebRequest.Headers.Add("APIToken", ConfigurationHelper.APIToken);
                    httpWebRequest.Headers.Add("AuthToken", string.Empty);

                    using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
                    {
                        string json = "{\"OAuthAccountID\": \"" + SessionHelper.OAuthAccountId + "\", \"Amount\": \"" + splitParam[1] + "\", \"Currency\": \"" + splitParam[2] + "\",\"Token\":\"" + token + "\",\"PayerID\":\"" + payerId
                            + "\",\"Email\":\"" + SessionHelper.UserName + "\",\"CommunityName\":\"" + communityName + "\"}";

                        streamWriter.Write(json);
                        streamWriter.Flush();
                        streamWriter.Close();
                    }

                    var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
                    using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                    {
                        var result = streamReader.ReadToEnd();
                        JObject jObject = JObject.Parse(result);

                        transId = jObject["TransactionID"].ToString();
                        lblMessage.Text = "Online topup transaction has been processed successfully.<br/> Receipt ID: " + jObject["TransactionID"].ToString();
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "Message", "SuccessWindow('Payment Process', '" + lblMessage.Text + "', 'ManageSupplierAccounts.aspx')", true);

                        CreditVirtualCommunityTransaction(splitParam[3], splitParam[4], splitParam[5], splitParam[6], splitParam[1]);
                    }
                }
                catch (Exception ex)
                {
                    Response.Redirect("PaymentResult.aspx?era=" + ex.Message);
                }
                Response.Redirect("PaymentResult.aspx?tra=" + transId);

            }
            //System.Web.HttpContext.Current.Response.StatusCode = 204;
        }

        private void CreditVirtualCommunityTransaction(string id, string entity, string communityId, string description, string amount)
        {
            string ServiceUrl = HelperClass.ConfigurationHelper.APIUrl;
            var httpWebRequest = (HttpWebRequest)WebRequest.Create(ServiceUrl + "CreditVirtualCommunityAccount");
            //  ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;
            httpWebRequest.ContentType = "text/json";
            httpWebRequest.Method = "POST";
            httpWebRequest.Headers.Add("APIToken", ConfigurationHelper.APIToken);
            httpWebRequest.Headers.Add("AuthToken", string.Empty);

            using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
            {
                string json = "{\"ID\": \"" + id + "\", \"Entity\": \"" + entity + "\", \"CommunityID\": \"" + communityId + "\",\"Description\":\"" + description + "\",\"Amount\":\"" + amount + "\"}";

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