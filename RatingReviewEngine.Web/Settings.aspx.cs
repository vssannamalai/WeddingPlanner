using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RatingReviewEngine.Web.HelperClass;

namespace RatingReviewEngine.Web
{
    public partial class Settings : System.Web.UI.Page
    {
        private void InitializeBaseValues()
        {
            if (SessionHelper.IsCommunityOwner == true && SessionHelper.IsSupplier == true)
            {
                lblRegisterCommunityOwner.Visible = false;
                lblCommunityOwnerDashboard.Visible = true;
                lblRegisterSupplier.Visible = false;
                lblSupplierDashboard.Visible = true;
                lblAdministratorMenu.Visible = false;
            }
            else
            {
                if (SessionHelper.IsCommunityOwner == true)
                {
                    lblRegisterCommunityOwner.Visible = false;
                    lblCommunityOwnerDashboard.Visible = true;
                    //Response.Redirect("CommunityOwnerDashboard.aspx", false);
                }
                else
                {
                    lblRegisterCommunityOwner.Visible = true;
                    lblCommunityOwnerDashboard.Visible = false;
                }

                if (SessionHelper.IsSupplier == true)
                {
                    lblRegisterSupplier.Visible = false;
                    lblSupplierDashboard.Visible = true;
                    //Response.Redirect("SupplierDashboard.aspx", false);
                }
                else
                {
                    lblRegisterSupplier.Visible = true;
                    lblSupplierDashboard.Visible = false;
                }

                if (SessionHelper.IsAdministrator == true)
                {
                    lblAdministratorMenu.Visible = true;
                    //Response.Redirect("ManageAPIToken.aspx", false);
                }
                else
                    lblAdministratorMenu.Visible = false;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitializeBaseValues();
            }
        }
    }
}