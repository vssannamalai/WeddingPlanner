using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using RatingReviewEngine.Entities;
using RatingReviewEngine.Business;
using RatingReviewEngine.Business.Shared;
using RatingReviewEngine.Entities.ServiceRequest;

namespace RatingReviewEngine.API
{
    public partial class PaypalResponse : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            PaymentProcessRequest payflow = new PaymentProcessRequest();
            payflow.Token = Request.Params["Token"].ToString();
            payflow.PayerID = Request.Params["PayerID"].ToString();
            string param = CommonComponent.DecryptIt(Request.QueryString["od"].ToString());
            payflow.OAuthAccountID = Convert.ToInt32(param.Split('_')[0].ToString());
            payflow.Amount = param.Split('_')[1].ToString();
            payflow.Currency = param.Split('_')[2].ToString();
            RatingReviewEngineAPI api = new RatingReviewEngineAPI();
            PaypalTransaction transaction = api.PayflowPaypalPaymentConfirm(payflow);
            Response.Write(transaction.Result);
        }
    }
}