using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class LoginTest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            hdnDomainName.Value = ConfigurationManager.AppSettings.Get("ServiceUrl");
            hdnAPIToken.Value = ConfigurationManager.AppSettings.Get("APIToken");
        }
    }
}