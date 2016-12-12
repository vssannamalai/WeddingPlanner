using RatingReviewEngine.Web.HelperClass;
using System;

namespace RatingReviewEngine.Web
{
    public partial class RegisterAsSupplier : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitializeBaseValues();
            }
        }

        private void InitializeBaseValues()
        {
            if (SessionHelper.IsSupplier == true)
            {
                Response.Redirect("Settings.aspx", false);
            }
        }
    }
}