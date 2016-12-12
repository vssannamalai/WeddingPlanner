using System;
using RatingReviewEngine.Web.HelperClass;

namespace RatingReviewEngine.Web
{
    public partial class CommunityOwnerDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (SessionHelper.IsCommunityOwner)
                {
                    SessionHelper.IsSupplierDashboard = false;
                    SessionHelper.IsAdminDashboard = false;
                    SessionHelper.IsOwnerDashboard = true;
                }
            }
        }
    }
}