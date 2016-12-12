using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using RatingReviewEngine.Business;
using RatingReviewEngine.Business.Shared;
using RatingReviewEngine.Entities.ServiceRequest;
using RatingReviewEngine.Entities;
using System.Text;

namespace RatingReviewEngine.API
{
    public partial class TestPage : System.Web.UI.Page
    {
        private static String EncryptIt(String s)
        {
            String result;
            var key = Encoding.UTF8.GetBytes("9061737323313233");
            var IV = Encoding.UTF8.GetBytes("9061737323313233");

            RijndaelManaged rijn = new RijndaelManaged();
            rijn.Mode = CipherMode.CBC;
            rijn.Padding = PaddingMode.PKCS7;

            using (MemoryStream msEncrypt = new MemoryStream())
            {
                using (ICryptoTransform encryptor = rijn.CreateEncryptor(key, IV))
                {
                    using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                    {
                        using (StreamWriter swEncrypt = new StreamWriter(csEncrypt))
                        {
                            swEncrypt.Write(s);
                        }
                    }
                }
                result = Convert.ToBase64String(msEncrypt.ToArray());
            }
            rijn.Clear();

            return result;
        }

        private static String DecryptIt(String s)
        {
            String result;
            var key = Encoding.UTF8.GetBytes("9061737323313233");
            var IV = Encoding.UTF8.GetBytes("9061737323313233");
            RijndaelManaged rijn = new RijndaelManaged();
            rijn.Mode = CipherMode.CBC;
            rijn.Padding = PaddingMode.PKCS7;

            using (MemoryStream msDecrypt = new MemoryStream(Convert.FromBase64String(s)))
            {
                using (ICryptoTransform decryptor = rijn.CreateDecryptor(key, IV))
                {
                    using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                    {
                        using (StreamReader swDecrypt = new StreamReader(csDecrypt))
                        {
                            result = swDecrypt.ReadToEnd();
                        }
                    }
                }
            }
            rijn.Clear();

            return result;
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void btnEncrypt_Click(object sender, EventArgs e)
        {
            txtEncrypt.Text = EncryptIt(txtEncrypt.Text);
        }

        protected void btnDecrypt_Click(object sender, EventArgs e)
        {
            txtEncrypt.Text = DecryptIt(txtEncrypt.Text);
        }

        protected void btnGetValue_Click(object sender, EventArgs e)
        {
            //UserComponent userComponent = new UserComponent();
            //userComponent.Login("test", "test", "test");
            Response.Write(Cryptographer.GenerateAuthToken());

        }

        protected void btnSendEmail_Click(object sender, EventArgs e)
        {
            RatingReviewEngine.Business.Shared.EmailDispatcher emailComponent = new Business.Shared.EmailDispatcher();
            emailComponent.SendEmail("test@versatile-soft.com", "annamalai@versatile-soft.com", "", "<html><body> Hi, <br/> This is a sample email to check the email sending functionality. </body> </html>", true);
        }

        protected void btnApplicationRegister_Click(object sender, EventArgs e)
        {
            RatingReviewEngineAPI ratings = new RatingReviewEngineAPI();
            //ratings.RegisterApplication("Michael Hill Jewellery Administrators", "annamalai@versatile-soft.com", 1);
            //ratings.RegisterApplication("Michael Hill Wedding Planner Developers", "hemachandran@versatile-soft.com", 2);
        }

        protected void btnGenerateAPIToken_Click(object sender, EventArgs e)
        {
            lblToken.Text = Cryptographer.GenerateAuthToken();

        }
        protected void btnReport_Click(object sender, EventArgs e)
        {
            RatingReviewEngineAPI ratings = new RatingReviewEngineAPI();
            SupplierComponent supplierComponent = new SupplierComponent();
            SupplierCommunityTransactionHistory supplierHistory = new SupplierCommunityTransactionHistory();
            supplierHistory.SupplierID = 21;

            List<SupplierCommunityTransactionHistory> lstTransactionHistories = supplierComponent.SupplierCommunityTransactionSelect(supplierHistory);
            SupplierTransactionHistoryRequest supplierTransactionHistory = new SupplierTransactionHistoryRequest();
            supplierTransactionHistory.ReportName = "Report2.rdlc";
            supplierTransactionHistory.PDFFileName = DateTime.Now.Ticks.ToString() + "_" + "supplierTransaction.pdf";
            supplierTransactionHistory.lstSupplierTransactionHistory = lstTransactionHistories;
            string filename = ratings.ExportReportToPDF(supplierTransactionHistory);
            EmailDispatcher emailDispatcher = new EmailDispatcher();
            emailDispatcher.SendEmail("From email", "philomineraj@versatile-soft.com", " MONTHLY BILLING CYCLE", " MONTHLY BILLING CYCLE", new System.Net.Mail.Attachment(System.IO.Path.Combine(HttpContext.Current.Server.MapPath("~/Assets/ExportedFiles/"), filename)), true);
        }

        protected void btnPayment_Click(object sender, EventArgs e)
        {
            RatingReviewEngineAPI api = new RatingReviewEngineAPI();
            PaymentProcessRequest payment = new PaymentProcessRequest();
            payment.Cardnumber = "6355059797";
            payment.Amount = "10";
            payment.OAuthAccountID = 73;
            PaypalTransaction transaction = api.PayflowACHPayment(payment);
            //Response.Write(transaction.Result);
        }
    }
}