using System;

public partial class RegisterAsCommunityOwner : System.Web.UI.Page
{
    #region Variables

    #endregion

    #region Methods
    private void ClearControls()
    {
        txtBusinessName.Text = string.Empty;
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

    private void RegisterOwner()
    {
        MichaelHill.Owner owner = new MichaelHill.Owner();
        owner.CompanyName = txtBusinessName.Text.Trim();
        owner.Email = txtEmail.Text.Trim();
        owner.PrimaryPhone = txtPrimaryPhone.Text.Trim();
        owner.OtherPhone = txtOtherPhone.Text.Trim();
        owner.BusinessNumber = txtBusinessNumber.Text.Trim();
        owner.Website = txtWebsite.Text.Trim();

        owner.AddressLine1 = txtAddress1.Text.Trim();
        owner.AddressLine2 = txtAddress2.Text.Trim();
        owner.AddressCity = txtCity.Text.Trim();
        owner.AddressState = txtState.Text.Trim();
        owner.AddressPostalCode = txtPostalCode.Text.Trim();

        owner.BillingName = txtBillingName.Text.Trim();
        owner.BillingAddressLine1 = txtBillingAddress1.Text.Trim();
        owner.BillingAddressLine2 = txtBillingAddress2.Text.Trim();
        owner.BillingAddressCity = txtBillingCity.Text.Trim();
        owner.BillingAddressState = txtBillingState.Text.Trim();
        owner.BillingAddressPostalCode = txtBillingPostalCode.Text.Trim();

        owner.OAuthAccountID = 3;       //Id should be supplied from Sessoin variable based on login (Class yet to create)

        MichaelHill.RatingReviewEngineAPIClient rattingAPI = new MichaelHill.RatingReviewEngineAPIClient();
        rattingAPI.RegisterOwner(owner);
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
    
    protected void btnRegister_Click(object sender, EventArgs e)
    {
        try
        {
            RegisterOwner();
            ClearControls();
        }
        catch (Exception ex)
        {

        }
    }
    #endregion
}