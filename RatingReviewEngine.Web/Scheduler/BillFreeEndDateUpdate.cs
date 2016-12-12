using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.IO;

using RatingReviewEngine.Web.HelperClass;
using Quartz;

namespace RatingReviewEngine.Web.Scheduler
{
    public class BillFreeEndDateUpdate : IJob
    {
        public virtual void Execute(IJobExecutionContext context)
        {
            string ServiceUrl = HelperClass.ConfigurationHelper.APIUrl;
            var httpWebRequest1 = (HttpWebRequest)WebRequest.Create(ServiceUrl + "UpdateBillFreeEndDate");
            ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;
            httpWebRequest1.ContentType = "text/json";
            httpWebRequest1.Method = "POST";
            httpWebRequest1.Headers.Add("APIToken", ConfigurationHelper.APIToken);
            httpWebRequest1.Headers.Add("AuthToken", string.Empty);

            using (var streamWriter = new StreamWriter(httpWebRequest1.GetRequestStream()))
            {
                //string json = "{ " + DateTime.Now.Date + "}";

                //streamWriter.Write(json);
                streamWriter.Flush();
                streamWriter.Close();
            }
            var httpResponse1 = (HttpWebResponse)httpWebRequest1.GetResponse();
        }
    }
}