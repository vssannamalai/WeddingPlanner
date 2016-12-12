using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class RegisterAsSupplier : System.Web.UI.Page
{
    #region Variables

    #endregion

    #region Methods
    private void ClearControls()
    {
        txtSupplierName.Text = string.Empty;
        txtEmail.Text = string.Empty;
        txtPrimaryPhone.Text = string.Empty;
        txtOtherPhone.Text = string.Empty;
        txtBusinessNumber.Text = string.Empty;
        txtWebsite.Text = string.Empty;

        txtAddress1.Text = string.Empty;
        txtAddress2.Text = string.Empty;
        txtCity.Text = string.Empty;
        txtState.Text = string.Empty;
        txtPostalCode.Text = string.Empty;

        txtBillingName.Text = string.Empty;
        txtBillingAddress1.Text = string.Empty;
        txtBillingAddress2.Text = string.Empty;
        txtBillingCity.Text = string.Empty;
        txtBillingState.Text = string.Empty;
        txtBillingPostalCode.Text = string.Empty;
    }

    #endregion

    #region Events
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ClearControls();
        }
    }

    #endregion
}