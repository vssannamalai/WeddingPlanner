using RatingReviewEngine.Web.HelperClass;
using System;


namespace RatingReviewEngine.Web
{
    public partial class AdminSettings : System.Web.UI.Page
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
            if (SessionHelper.IsAdministrator == false)
            {
                Response.Redirect("NoData.aspx", false);
            }
            else
            {
                SessionHelper.IsSupplierDashboard = false;
                SessionHelper.IsAdminDashboard = true;
                SessionHelper.IsOwnerDashboard = false;
            }
        }
    }
}