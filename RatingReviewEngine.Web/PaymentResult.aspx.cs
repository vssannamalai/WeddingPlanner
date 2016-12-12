using Newtonsoft.Json.Linq;
using RatingReviewEngine.Web.HelperClass;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace RatingReviewEngine.Web
{
    public partial class PaymentResult : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //if(hdfRefresh.Value=="1")
            //{
            //    Response.Redirect("ManageSupplierAccounts.aspx");
            //}
            if (Request.Params["tra"] != null)
            {
                string ServiceUrl = HelperClass.ConfigurationHelper.APIUrl;
                var httpWebRequest = (HttpWebRequest)WebRequest.Create(ServiceUrl + "GetPaypalTransaction/" + Request.Params["tra"]);
                //  ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;
                httpWebRequest.ContentType = "text/json";
                httpWebRequest.Method = "GET";
                httpWebRequest.Headers.Add("APIToken", ConfigurationHelper.APIToken);
                httpWebRequest.Headers.Add("AuthToken", string.Empty);

                //using (var streamWriter = new StreamWriter(httpWebRequest.GetRequestStream()))
                //{
                //    string json = Request.Params["tra"];

                //    streamWriter.Write(json);
                //    streamWriter.Flush();
                //    streamWriter.Close();
                //}

                var httpResponse = (HttpWebResponse)httpWebRequest.GetResponse();
                using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                {
                    var result = streamReader.ReadToEnd();
                    JObject jObject = JObject.Parse(result);
                    if (string.IsNullOrEmpty(jObject["PaypalTransactionID"].ToString()) || jObject["PaypalTransactionID"].ToString() == "0")
                    {
                        Response.Redirect("ManageSupplierAccounts.aspx");
                    }
                }

                string token = Request.Params["tra"].ToString();
                lblMessage.Text = "Online topup transaction has been processed successfully.<br/> Reference Number: " + token;
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "Message", "SuccessWindow('Payment Process', '" + lblMessage.Text + "', 'ManageSupplierAccounts.aspx')", true);
            }
            if (Request.Params["era"] != null)
            {
                string token = Request.Params["era"].ToString();
                lblMessage.Text = token;
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "Message", "ErrorWindow('Payment Process', '" + lblMessage.Text + "', 'ManageSupplierAccounts.aspx')", true);
            }
            //hdfRefresh.Value = "1";
            //System.Web.HttpContext.Current.Response.StatusCode = 204;
        }
    }
}