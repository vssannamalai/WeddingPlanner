using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using RatingReviewEngine.Web.HelperClass;

namespace RatingReviewEngine.Web
{
    public partial class ManageAPIToken : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!SessionHelper.IsOwnerDashboard)
            {
                if (SessionHelper.IsAdministrator)
                {
                    SessionHelper.IsSupplierDashboard = false;
                    SessionHelper.IsAdminDashboard = true;
                    SessionHelper.IsOwnerDashboard = false;
                }
            }
        }
    }
}