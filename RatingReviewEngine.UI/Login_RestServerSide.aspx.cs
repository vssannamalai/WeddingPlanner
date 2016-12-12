using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Login_RestServerSide : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string strProvider = "General";
        string strEmail = txtEmail.Text.Trim();
        string strPassword = txtPassword.Text;
        string url = "http://localhost:19406/RatingReviewEngineAPI.svc/Login/" + strProvider + "/" + strEmail + "/" + strPassword;        

        ASCIIEncoding encoding = new ASCIIEncoding();
        byte[] data = encoding.GetBytes(url);
        HttpWebRequest webRequest = (HttpWebRequest)WebRequest.Create(url);

        webRequest.Method = "POST";
        webRequest.ContentType = "application/x-www-form-urlencoded";
        webRequest.ContentLength = data.Length;

        Stream newStream = webRequest.GetRequestStream();
        newStream.Write(data, 0, data.Length);
        newStream.Close();

        HttpWebResponse webResponse = (HttpWebResponse)webRequest.GetResponse();
        Encoding enc = System.Text.Encoding.GetEncoding("utf-8");        
        StreamReader loResponseStream = new StreamReader(webResponse.GetResponseStream(), enc);       
        string strResult = loResponseStream.ReadToEnd();        
        loResponseStream.Close();       
        webResponse.Close();        
        strResult = strResult.Replace("\"", "");

        if (strResult == "valid")
        {
            Response.Redirect("Settings.aspx", false);
        }
        else if (strResult == "invalid")
        {
            emailDiv.Attributes.Add("class", "form-group has-error");
            passwordDiv.Attributes.Add("class", "form-group has-error");
            spanValidationMessage.Attributes.Add("style", "display:block; font-size:15px; font-weight:normal; line-height:2.4; color:#E74C3C;");
        }
    }
}
