using System;
using RatingReviewEngine.Web.HelperClass;

namespace RatingReviewEngine.Web
{
    public partial class SupplierDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                if (SessionHelper.IsSupplier)
                {
                    SessionHelper.IsSupplierDashboard = true;
                    SessionHelper.IsAdminDashboard = false;
                    SessionHelper.IsOwnerDashboard = false;
                }
            }
        }
    }
}