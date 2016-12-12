using System;
using System.Configuration;
using System.Web.UI;

public partial class Login : System.Web.UI.Page
{
    #region Variables

    #endregion

    #region Methods
    private void ClearControls()
    {
        txtEmail.Text = string.Empty;
        txtPassword.Text = string.Empty;
    }

    private void UserLogin(string strProvider, string strProviderUserId, string strToken)
    {
        MichaelHill.RatingReviewEngineAPIClient ratingAPI = new MichaelHill.RatingReviewEngineAPIClient();
        string strOutput = ratingAPI.Login(strProvider, strProviderUserId, strToken);
        hdnLoginStatus.Value = strOutput;
        hdnPassword.Value = strToken;
        if (strOutput == "valid")
        {
            Page.ClientScript.RegisterStartupScript(this.GetType(), "RegisterStartupScript", "<script>SaveCookie('" + strOutput + "')</script>");            
        }
        else
        {
            emailDiv.Attributes.Add("class", "form-group has-error");
            passwordDiv.Attributes.Add("class", "form-group has-error");
            spanValidationMessage.Attributes.Add("style", "display:block; font-size:15px; font-weight:normal; line-height:2.4; color:#E74C3C;");
        }
    }
    #endregion

    #region Events
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            hdnDomainName.Value = ConfigurationManager.AppSettings.Get("ServiceUrl");
            hdnAPIToken.Value = ConfigurationManager.AppSettings.Get("APIToken");
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        try
        {
            UserLogin("General", txtEmail.Text.Trim(), txtPassword.Text);
        }
        catch (Exception ex)
        { 
            
        }
    }
    #endregion
}