using RatingReviewEngine.Web.HelperClass;
using System;

namespace RatingReviewEngine.Web
{
    public partial class RegisterAsCommunityOwner : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                hdfDateAdded.Value = DateTime.Now.ToString();
                InitializeBaseValues();
            }
        }

        private void InitializeBaseValues()
        {
            if (SessionHelper.IsCommunityOwner == true)
            {
                Response.Redirect("Settings.aspx", false);
            }
        }
    }
}