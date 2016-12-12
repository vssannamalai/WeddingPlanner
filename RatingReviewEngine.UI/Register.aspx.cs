using System;
using System.Web.Services;

public partial class Register : System.Web.UI.Page
{
    #region Variables

    #endregion

    #region Methods
    private void ClearControls()
    {
        txtEmail.Text = string.Empty;
        txtVerifyEmail.Text = string.Empty;
        txtPassword.Text = string.Empty;
        txtVerifyPassword.Text = string.Empty;
    }

    private void RegisterAccount()
    {
        MichaelHill.OAuthAccount oauthAccount = new MichaelHill.OAuthAccount();
        oauthAccount.Provider = "General";
        oauthAccount.ProviderUserID = txtEmail.Text.Trim();
        oauthAccount.Token = txtPassword.Text;

        MichaelHill.RatingReviewEngineAPIClient ratingAPI = new MichaelHill.RatingReviewEngineAPIClient();
        ratingAPI.RegisterAccount(oauthAccount);
    }

    [WebMethod]
    public static string CheckValidUserID(string strProvider, string strProviderUserId)
    {
        string strOutput = string.Empty;
        MichaelHill.OAuthAccount oauthAccount = new MichaelHill.OAuthAccount();
        oauthAccount.Provider = strProvider;
        oauthAccount.ProviderUserID = strProviderUserId;

        MichaelHill.RatingReviewEngineAPIClient ratingAPI = new MichaelHill.RatingReviewEngineAPIClient();
        strOutput = ratingAPI.CheckValidUserID(oauthAccount);
        
        return strOutput;
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
            RegisterAccount();
            ClearControls();
        }
        catch (Exception ex)
        {

        }
    }
    #endregion
}