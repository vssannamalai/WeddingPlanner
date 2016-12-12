using RatingReviewEngine.Business;
using RatingReviewEngine.Business.Shared;
using RatingReviewEngine.Entities;
using RatingReviewEngine.Entities.ServiceRequest;
using RatingReviewEngine.Entities.ServiceResponse;
using System;
using System.Collections.Generic;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Configuration;
using System.Web;
using System.Text;
using System.IO;

using System.Collections.Specialized;

using Microsoft.Reporting.WebForms;
using RatingReviewEngine.WorldPay;

namespace RatingReviewEngine.API
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "RatingReviewEngineAPI" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select RatingReviewEngineAPI.svc or RatingReviewEngineAPI.svc.cs at the Solution Explorer and start debugging.
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class RatingReviewEngineAPI : IRatingReviewEngineAPI
    {
        private string ApplicationName { get { return ConfigurationManager.AppSettings["ApplicationName"].ToString(); } }

        #region Exception
        private void LogException(Exception ex)
        {
            ////Entity
            ErrorLogs errorLog = new ErrorLogs();
            errorLog.Description = ex.Message;
            errorLog.Details = ex.StackTrace;
            errorLog.Timestamp = CommonComponent.MYSQLDateTime();

            ////Component
            ErrorLogComponent errorLogComponent = new ErrorLogComponent();
            errorLogComponent.ErrorLog(errorLog);

            EmailDispatcher emailDispatcher = new EmailDispatcher();

            emailDispatcher.SendErrorEmail("MHJ-Error", "MHJ API-Error on-" + errorLog.Timestamp, "Message:" + ex.Message + "<br/> Description:" + ex.StackTrace, true);

        }
        #endregion

        #region User
        public LoginResponse Login(LoginRequest loginRequest)
        {
            try
            {
                UserComponent userComponent = new UserComponent();
                return userComponent.ValidateAccount(loginRequest);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        ////public string UserLogin(LoginServiceRequest loginServiceRequest)
        ////{
        ////    try
        ////    {
        ////        UserComponent userComponent = new UserComponent();
        ////        return userComponent.ValidateAccount(loginServiceRequest);
        ////    }
        ////    catch (Exception ex)
        ////    {
        ////        LogException(ex);
        ////        RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
        ////        throw new FaultException<RatingReviewEngineException>(ratingException, new FaultReason("Invalid request"));
        ////    }
        ////}

        public RegisterAccountResponse RegisterAccount(OAuthAccount oauthAccount)
        {
            try
            {
                RegisterAccountResponse registerResponse = new RegisterAccountResponse();
                UserComponent userComponent = new UserComponent();
                registerResponse.OAuthAccountId = userComponent.RegisterNewAccount(oauthAccount);
                return registerResponse;
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public AccountActivationResponse ActivateAccount(AccountActivationRequest activationRequest)
        {
            try
            {
                UserComponent userComponent = new UserComponent();
                return userComponent.ActivateAccount(activationRequest.ProviderUserID);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public string CheckValidUserID(OAuthAccount oauthAccount)
        {
            try
            {
                UserComponent userComponent = new UserComponent();
                return userComponent.CheckValidUserID(oauthAccount);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public string SendForgotPasswordEmail(OAuthAccount oauthAccount)
        {
            try
            {
                UserComponent userComponent = new UserComponent();
                string valid = userComponent.CheckValidUserID(oauthAccount);
                if (valid == "invalid")
                {
                    EmailDispatcher emailDispatcher = new EmailDispatcher();
                    string encryptedEmail = Business.Shared.Cryptographer.Encrypt(oauthAccount.ProviderUserID);
                    string encDate = CommonComponent.EncryptIt(DateTime.UtcNow.ToString("dd MM yyyy hh-mm"));
                    string url = ConfigurationSettings.AppSettings["WebUrl"].ToString() + "ResetPassword.aspx?id=" + encryptedEmail + "&d=" + encDate;

                    string path = Path.Combine(HttpContext.Current.Server.MapPath("~/Template/"), "ForgotPassword.html");
                    string emailBody = File.ReadAllText(path);
                    emailBody = string.Format(emailBody, url);

                    emailDispatcher.SendEmail("FromEmail", oauthAccount.ProviderUserID, ApplicationName + " - Reset Password", emailBody, true);
                }
                return valid;
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public string ValidateForgotPasswordLink(string lnkDate)
        {
            string isValid = "0";
            lnkDate = lnkDate.Replace("-", ":");
            DateTime? dFormattedDate = null;
            System.Globalization.CultureInfo MyCultureInfo = new System.Globalization.CultureInfo("en-AU");
            System.Globalization.DateTimeFormatInfo dtfi = new System.Globalization.DateTimeFormatInfo();
            dtfi.ShortDatePattern = lnkDate;
            MyCultureInfo.DateTimeFormat = dtfi;

            DateTime tmpDate;
            if (DateTime.TryParseExact(lnkDate, "dd MM yyyy hh:mm", MyCultureInfo, System.Globalization.DateTimeStyles.None, out tmpDate))
            { dFormattedDate = tmpDate; }

            TimeSpan time = DateTime.UtcNow.Subtract(tmpDate);

            if (time.Minutes > 5)
                isValid = "1";
            return isValid;
        }



        public string ChangePassword(OAuthAccount oauthAccount)
        {
            try
            {
                UserComponent userComponent = new UserComponent();
                return userComponent.OAuthAccountTokenUpdate(oauthAccount);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        #endregion

        #region Administrator

        public List<AccessRights> GetAllAccessRight()
        {
            try
            {
                AdministratorComponent administratorComponent = new AdministratorComponent();
                return administratorComponent.AccessRightSelectAll();
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void UpdateAccessRight(AccessRights accessRight)
        {
            try
            {
                AdministratorComponent administratorComponent = new AdministratorComponent();
                administratorComponent.AccessRightUpdate(accessRight);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }
        public string GetAllowedPages(string userroleId)
        {
            try
            {
                AdministratorComponent administratorComponent = new AdministratorComponent();
                return administratorComponent.AccessRightSelectByRole(Convert.ToInt32(userroleId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public string GetAllowedPagesByOAuthAccount(string OAuthaccountId)
        {
            try
            {
                AdministratorComponent administratorComponent = new AdministratorComponent();
                return administratorComponent.AccessRightSelectByOAuthaccount(Convert.ToInt32(OAuthaccountId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }
        public int NewCurrency(Currency currency)
        {
            try
            {
                AdministratorComponent administratorComponent = new AdministratorComponent();
                return administratorComponent.CurrencyInsert(currency);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void UpdateCurrency(Currency currency)
        {
            try
            {
                AdministratorComponent administratorComponent = new AdministratorComponent();
                administratorComponent.CurrencyUpdate(currency);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void UpdateCurrencyList(CurrencyList currencyList)
        {
            try
            {
                foreach (Currency currency in currencyList.lstCurrency)
                {
                    AdministratorComponent administratorComponent = new AdministratorComponent();
                    administratorComponent.CurrencyUpdate(currency);
                }
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }
        public List<Currency> CurrencyActiveList()
        {
            try
            {
                AdministratorComponent administrativeComponent = new AdministratorComponent();
                return administrativeComponent.CurrencySelectActive();
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Currency> CurrencyList()
        {
            try
            {
                AdministratorComponent administrativeComponent = new AdministratorComponent();
                return administrativeComponent.CurrencySelectAll();
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Currency> OwnerCurrencyList(string ownerId)
        {
            try
            {
                AdministratorComponent administrativeComponent = new AdministratorComponent();
                return administrativeComponent.CurrencySelectByOwner(Convert.ToInt32(ownerId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }
        public List<Country> CountryList()
        {
            try
            {
                AdministratorComponent administratorComponent = new AdministratorComponent();
                return administratorComponent.CountrySelectAll();
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void NewTriggeredEvent(TriggeredEvent triggeredEvent)
        {
            try
            {
                AdministratorComponent administrativeComponent = new AdministratorComponent();
                administrativeComponent.TriggeredEventInsert(triggeredEvent);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void UpdateTriggeredEvent(TriggeredEvent triggeredEvent)
        {
            try
            {
                AdministratorComponent administrativeComponent = new AdministratorComponent();
                administrativeComponent.TriggeredEventUpdate(triggeredEvent);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void UpdateTriggeredEventList(TriggeredEventList triggeredEventList)
        {
            try
            {
                foreach (TriggeredEvent triggeredEvent in triggeredEventList.lstTriggeredEvent)
                {
                    AdministratorComponent administrativeComponent = new AdministratorComponent();
                    administrativeComponent.TriggeredEventUpdate(triggeredEvent);
                }
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }
        public List<Actions> GetActionList()
        {
            try
            {
                AdministratorComponent administrativeComponent = new AdministratorComponent();
                return administrativeComponent.ActionList();
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Actions> GetActiveActionList()
        {
            try
            {
                AdministratorComponent administrativeComponent = new AdministratorComponent();
                return administrativeComponent.ActiveActionList();
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<ActionResponse> GetActionResponse(string actionId)
        {
            try
            {
                AdministratorComponent administrativeComponent = new AdministratorComponent();
                return administrativeComponent.ActionResponseSelect(Convert.ToInt32(actionId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<ActionResponse> GetActionResponseWithoutRespondAndQuote(string actionId, string supplieractionId)
        {
            try
            {
                AdministratorComponent administrativeComponent = new AdministratorComponent();
                return administrativeComponent.ActionResponseSelectWithoutRespondAndQuote(Convert.ToInt32(actionId), Convert.ToInt32(supplieractionId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<ApplicationAuthentication> ApplicationAuthenticationList(string ownerId)
        {
            try
            {
                AdministratorComponent administrativeComponent = new AdministratorComponent();
                return administrativeComponent.ApplicationAuthenticationSelectAll(Convert.ToInt32(ownerId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<TriggeredEvent> TriggeredEventList()
        {
            try
            {
                AdministratorComponent administrativeComponent = new AdministratorComponent();
                return administrativeComponent.TriggeredEventSelectAll();
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public string CheckCurrency(Currency currency)
        {
            try
            {
                if (currency.ISOCode == "nullstring")
                    currency.ISOCode = string.Empty;
                if (currency.Description == "nullstring")
                    currency.Description = string.Empty;

                AdministratorComponent administrativeComponent = new AdministratorComponent();
                return administrativeComponent.CheckCurrencyExist(Convert.ToInt32(currency.CurrencyID), HttpUtility.UrlDecode(currency.ISOCode), HttpUtility.UrlDecode(currency.Description));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<AdminTransactionHistory> GetAdminTrasactionSummary()
        {
            try
            {
                AdministratorComponent administratorComponent = new AdministratorComponent();
                return administratorComponent.AdminTransactionSummary();
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<AdminTransactionHistory> GetAdminTransaction(AdminTransactionHistory adminTransactionHistory)
        {
            try
            {
                AdministratorComponent administratorComponent = new AdministratorComponent();
                return administratorComponent.AdminTransactionSelect(adminTransactionHistory);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public string DownloadAdminTransaction(ExportAdminTransactionRequest exportOwnerTransaction)
        {
            try
            {
                AdministratorComponent administratorComponent = new AdministratorComponent();
                return administratorComponent.DownloadAdminTransaction(exportOwnerTransaction);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void SendContactMail(ContactUs contactUs)
        {
            try
            {
                //EmailDispatcher emailDispatcher = new EmailDispatcher();
                //emailDispatcher.SendEmail("FromEmail", ConfigurationSettings.AppSettings["ContactEmail"].ToString(), "Wedding Planner Ratings and Reviews - Customer Contact Message", GenerateContactEmailContent(contactUs), true);

                EmailDispatcher emailDispatcher = new EmailDispatcher();

                string path = Path.Combine(HttpContext.Current.Server.MapPath("~/Template/"), "ContactUs.html");
                string emailBody = File.ReadAllText(path);
                emailBody = string.Format(emailBody, contactUs.SourceSystem, contactUs.Title, HttpUtility.HtmlEncode(HttpUtility.UrlDecode(contactUs.FirstName)), HttpUtility.HtmlEncode(HttpUtility.UrlDecode(contactUs.LastName)), HttpUtility.HtmlEncode(HttpUtility.UrlDecode(contactUs.Email))
                    , HttpUtility.HtmlEncode(HttpUtility.UrlDecode(contactUs.Phone)), contactUs.PreferredContact, HttpUtility.HtmlEncode(HttpUtility.UrlDecode(contactUs.Subject)), HttpUtility.HtmlEncode(HttpUtility.UrlDecode(contactUs.Comment)));

                emailDispatcher.SendEmail("FromEmail", ConfigurationSettings.AppSettings["ContactEmail"].ToString(), ApplicationName + " - Customer Contact Message", emailBody, true);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        private string GenerateContactEmailContent(ContactUs contactUs)
        {
            StringBuilder strEmailContent = new StringBuilder();
            strEmailContent.Append("<table class='twelve columns' style='width: 800px; table-layout: fixed;'>");
            strEmailContent.Append(String.Format("<tr><td style='white-space: nowrap; width: 200px;' class='panel lead'><b>Source System</b></td> <td class='panel' style='width: 600px;'> {0}</td> </tr>", contactUs.SourceSystem));
            strEmailContent.Append(String.Format("<tr><td style='white-space: nowrap;' class='panel lead'><b>Title</b></td> <td  style='word-break: normal;' class='panel'> {0}</td> </tr>", contactUs.Title));
            strEmailContent.Append(String.Format("<tr><td style='white-space: nowrap;' class='panel lead'><b>First Name</b></td> <td style='word-break: normal;' class='panel'> {0}</td> </tr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(contactUs.FirstName))));
            strEmailContent.Append(String.Format("<tr><td style='white-space: nowrap;' class='panel lead'><b>Last Name</b></td> <td style=' word-break: normal;' class='panel'> {0}</td> </tr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(contactUs.LastName))));
            strEmailContent.Append(String.Format("<tr><td style='white-space: nowrap;' class='panel lead'><b>Email</b></td> <td style='word-break: normal;' class='panel'> {0}</td> </tr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(contactUs.Email))));
            strEmailContent.Append(String.Format("<tr><td style='white-space: nowrap;' class='panel lead'><b>Phone</b></td> <td style=' word-break: normal;' class='panel'> {0}</td> </tr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(contactUs.Phone))));
            strEmailContent.Append(String.Format("<tr><td style='white-space: nowrap;' class='panel lead'><b>Preferred Contact Method</b></td> <td style=' word-break: normal;' class='panel'> {0}</td> </tr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(contactUs.PreferredContact))));
            strEmailContent.Append(String.Format("<tr><td style='white-space: nowrap;' class='panel lead'><b>Subject</b></td> <td style=' word-break: normal;' class='panel'> {0}</td> </tr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(contactUs.Subject))));
            strEmailContent.Append(String.Format("<tr><td style='white-space: nowrap;' class='panel lead'><b>Comment</b></td> <td style='word-break: break-word;word-wrap: break-word;' class='panel'><div style='width: 600px;'> {0}</div></td> </tr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(contactUs.Comment))));
            strEmailContent.Append("</table>");
            return strEmailContent.ToString();
        }
        #endregion

        #region Community Owner
        public int RegisterOwner(Owner owner)
        {
            try
            {
                OwnerComponent ownerComponent = new OwnerComponent();
                owner.DateAdded = CommonComponent.MYSQLDateTime();
                return ownerComponent.RegisterNewCommunityOwner(owner);
            }

            catch (Exception ex)
            {
                LogException(ex);

                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void UpdateOwner(Owner owner)
        {
            try
            {
                OwnerComponent ownerComponent = new OwnerComponent();
                ownerComponent.OwnerUpdate(owner);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public Owner GetOwner(string ownerId)
        {
            try
            {
                OwnerComponent ownerComponent = new OwnerComponent();
                return ownerComponent.OwnerSelect(Convert.ToInt32(ownerId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public string CheckOwnerEmail(string ownerId, string email)
        {
            try
            {
                OwnerComponent ownerComponent = new OwnerComponent();
                return ownerComponent.CheckOwnerEmailExist(Convert.ToInt32(ownerId), email);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void ActivateAPIToken(string applicationId)
        {
            try
            {
                ApplicationAuthentication applicationAuthentication = new ApplicationAuthentication();
                applicationAuthentication.ApplicationID = Convert.ToInt32(applicationId);
                applicationAuthentication.APIToken = Cryptographer.GenerateAuthToken();
                applicationAuthentication.TokenGenerated = CommonComponent.MYSQLDateTime();


                OwnerComponent ownerComponent = new OwnerComponent();
                applicationAuthentication = ownerComponent.APITokenActivate(applicationAuthentication);

                if (applicationAuthentication.RegisteredEmail != string.Empty)
                {
                    EmailDispatcher emailDispatcher = new EmailDispatcher();
                    string strEmailBody = emailDispatcher.GenerateActivateAPIToken(applicationAuthentication);
                    emailDispatcher.SendEmail("FromEmail", applicationAuthentication.RegisteredEmail, ApplicationName + ": API Token Activated", strEmailBody, true);
                }
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void DeactivateAPIToken(string applicationId)
        {
            try
            {
                string registeredEmail = string.Empty;
                OwnerComponent ownerComponent = new OwnerComponent();
                ApplicationAuthentication applicationAuthentication = ownerComponent.APITokenDeactivate(Convert.ToInt32(applicationId));

                if (!string.IsNullOrEmpty(applicationAuthentication.RegisteredEmail))
                {
                    EmailDispatcher emailDispatcher = new EmailDispatcher();
                    string strEmailBody = emailDispatcher.GenerateDeActivateAPIToken(applicationAuthentication);
                    emailDispatcher.SendEmail("FromEmail", applicationAuthentication.RegisteredEmail, ApplicationName + ": API Token Deactivated", strEmailBody, true);
                }

            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void RegisterApplication(ApplicationAuthentication applicationAuthentication)
        {
            try
            {
                OwnerComponent ownerComponent = new OwnerComponent();
                ownerComponent.ApplicationInsert(applicationAuthentication);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void ResetAPIToken(string applicationId)
        {
            try
            {
                ApplicationAuthentication applicationAuthentication = new ApplicationAuthentication();
                applicationAuthentication.ApplicationID = Convert.ToInt32(applicationId);
                applicationAuthentication.APIToken = Cryptographer.GenerateAuthToken();
                applicationAuthentication.TokenGenerated = CommonComponent.MYSQLDateTime();

                OwnerComponent ownerComponent = new OwnerComponent();
                applicationAuthentication = ownerComponent.APITokenReset(applicationAuthentication);

                EmailDispatcher emailDispatcher = new EmailDispatcher();
                string strEmailBody = emailDispatcher.GenerateResetAPIToken(applicationAuthentication);
                emailDispatcher.SendEmail("FromEmail", applicationAuthentication.RegisteredEmail, ApplicationName + ": API Token Reset", strEmailBody, true);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void ResendAPIToken(string applicationId, string apiToken)
        {
            try
            {
                ApplicationAuthentication applicationAuthentication = new ApplicationAuthentication();
                applicationAuthentication.ApplicationID = Convert.ToInt32(applicationId);
                applicationAuthentication.APIToken = apiToken;

                OwnerComponent ownerComponent = new OwnerComponent();
                applicationAuthentication = ownerComponent.APITokenResend(applicationAuthentication);

                EmailDispatcher emailDispatcher = new EmailDispatcher();
                string strEmailBody = emailDispatcher.GenerateResendAPIToken(applicationAuthentication);
                emailDispatcher.SendEmail("FromEmail", applicationAuthentication.RegisteredEmail, ApplicationName + ": API Token Resent", strEmailBody, true);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<CustomerTransactionResponse> FindCustomerTransaction(TransactionSearch transactionSearch)
        {
            try
            {
                if (transactionSearch.SearchText == "nullstring")
                    transactionSearch.SearchText = string.Empty;

                OwnerComponent ownerComponent = new OwnerComponent();
                return ownerComponent.CustomerTransactionSearch(transactionSearch.SearchText, transactionSearch.OwnerId, transactionSearch.CommunityId, transactionSearch.CommunityGroupId, transactionSearch.RowIndex, transactionSearch.RowCount);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<SupplierTransactionResponse> FindSupplierTransaction(TransactionSearch transactionSearch)
        {
            try
            {
                if (transactionSearch.SearchText == "nullstring")
                    transactionSearch.SearchText = string.Empty;

                OwnerComponent ownerComponent = new OwnerComponent();
                return ownerComponent.SupplierTransactionSearch(transactionSearch.SearchText, transactionSearch.OwnerId, transactionSearch.CommunityId, transactionSearch.CommunityGroupId, transactionSearch.CategoryId, transactionSearch.RowIndex, transactionSearch.RowCount);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<MenuItem> GetOwnerCommunityMenu(string ownerId)
        {
            try
            {
                OwnerComponent ownerComponent = new OwnerComponent();
                return ownerComponent.CommunityListMenu(Convert.ToInt32(ownerId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<CommunityOwnerTransactionHistory> GetOwnerAccountSummary(string ownerId)
        {
            try
            {
                OwnerComponent ownerComponent = new OwnerComponent();
                return ownerComponent.OwnerAccountSummary(Convert.ToInt32(ownerId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        /// <summary>
        /// Export the community owner transaction to a file, based on the input search criterea
        /// </summary>
        /// <param name="exportSupplierCommunityTransaction"></param>
        /// <returns>Return the temporary filename which should be downloaded using FileUploadService.svc/DownloadFile/{fileName}</returns>
        public string DownloadCommunityOwnerTransaction(ExportCommunityOwnerTransactionRequest exportOwnerTransaction)
        {
            try
            {
                OwnerComponent ownerComponent = new OwnerComponent();
                return ownerComponent.DownloadCommunityOwnerTransaction(exportOwnerTransaction);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<CommunityOwnerTransactionHistory> GetCommunityOwnerTransaction(CommunityOwnerTransactionHistory communityOwnerTransactionHistory)
        {
            try
            {
                OwnerComponent ownerComponent = new OwnerComponent();
                return ownerComponent.CommunityOwnerTransactionSelect(communityOwnerTransactionHistory);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public string CheckApplicationName(SearchRequest searchRequest)
        {
            try
            {
                OwnerComponent ownerComponent = new OwnerComponent();
                return ownerComponent.CheckApplicationExist(searchRequest.Name);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public decimal GetOwnerAccountBalance(string ownerId, string communityId)
        {
            try
            {
                OwnerComponent ownerComponent = new OwnerComponent();
                return ownerComponent.OwnerAccountBalanceByCommunity(Convert.ToInt32(ownerId), Convert.ToInt32(communityId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Owner> GetAllOwner()
        {
            try
            {
                OwnerComponent ownerComponent = new OwnerComponent();
                return ownerComponent.OwnerSelectAll();
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }
        #endregion

        #region Community Group
        public void UpdateCommunityGroup(CommunityGroup communityGroup)
        {
            try
            {
                CommunityGroupComponent communiyGroupComponent = new CommunityGroupComponent();
                communiyGroupComponent.CommunityGroupUpdate(communityGroup);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void UpdateCommunityGroupBillingFee(CommunityGroupBillingFee communityGroupBillingFee)
        {
            try
            {
                CommunityGroupComponent communiyGroupComponent = new CommunityGroupComponent();
                communiyGroupComponent.CommunityGroupBillingFeeUpdate(communityGroupBillingFee);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void AddCommunityGroupBillingFee(CommunityGroupBillingFee communityGroupBillingFee)
        {
            try
            {
                CommunityGroupComponent communiyGroupComponent = new CommunityGroupComponent();
                communiyGroupComponent.CommunityGroupBillingFeeInsert(communityGroupBillingFee);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public int NewCommunityGroup(CommunityGroup communityGroup)
        {
            try
            {
                CommunityGroupComponent communiyGroupComponent = new CommunityGroupComponent();
                return communiyGroupComponent.CommunityGroupInsert(communityGroup);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void SupplierJoinCommunityGroup(CommunityGroupSupplier communityGroupSupplier)
        {
            try
            {
                CommunitySupplier communitySupplier = GetCommunitySupplier(communityGroupSupplier.SupplierID.ToString(), communityGroupSupplier.CommunityID.ToString());
                if (communitySupplier.CommunityID == 0)
                {
                    CommunitySupplier cSupplier = new CommunitySupplier();
                    cSupplier.SupplierID = communityGroupSupplier.SupplierID;
                    cSupplier.CommunityID = communityGroupSupplier.CommunityID;
                    cSupplier.AutoTransferAmtSupplier = 0;
                    cSupplier.AutoTopUp = false;
                    cSupplier.MinCredit = 0;

                    NewSupplierCommunityMembership(cSupplier);
                }

                CommunityGroupComponent communiyGroupComponent = new CommunityGroupComponent();
                communiyGroupComponent.CommunityGroupJoin(communityGroupSupplier);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void SupplierLeaveCommunityGroup(CommunityGroupSupplier communityGroupSupplier)
        {
            try
            {
                CommunityGroupComponent communiyGroupComponent = new CommunityGroupComponent();
                communiyGroupComponent.CommunityGroupLeave(communityGroupSupplier);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public CommunityGroup FindCommunityGroup(string strSerachTerm, int communityId)
        {
            try
            {
                CommunityGroupComponent communiyGroupComponent = new CommunityGroupComponent();
                return communiyGroupComponent.CommunityGroupSearch(strSerachTerm, communityId);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        /// <summary>
        /// Used to search Community Group from Supplier Dashboard
        /// </summary>
        /// <param name="searchTerm">Search term used to search in Community Group Name and its Description. Pass "nullstring" if empty</param>
        /// <param name="searchDistance"></param>
        /// <param name="searchDistanceUnit"></param>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<CommunityGroup> FindCommunityGroupBySupplier(CommunitySearchRequest communitySearchRequest)
        {
            decimal nSearchDistance = 0, nSearchDistanceInMiles = 0;
            decimal latitude = 0, longitude = 0;
            try
            {
                if (Decimal.TryParse(communitySearchRequest.Distance, out nSearchDistance) && nSearchDistance > 0)
                {
                    nSearchDistanceInMiles = ((communitySearchRequest.DistanceUnit.ToLower() == "km")) ? (nSearchDistance / 1.60934M) : nSearchDistance;
                    Supplier supplier = GetSupplier(communitySearchRequest.SupplierID.ToString());
                    if (supplier != null)
                    {
                        latitude = (supplier.Latitude == null) ? 0.00M : (decimal)supplier.Latitude;
                        longitude = (supplier.Longitude == null) ? 0.00M : (decimal)supplier.Longitude;
                    }
                }

                if (communitySearchRequest.Term.ToLower() == "nullstring")
                {
                    communitySearchRequest.Term = "";
                }

                CommunityGroupComponent communityGroupComponent = new CommunityGroupComponent();
                return communityGroupComponent.CommunityGroupSearchByDistance(communitySearchRequest.Term, nSearchDistanceInMiles, longitude, latitude, 0);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public CommunityGroup GetCommunityGroup(string communityGroupId)
        {
            try
            {
                CommunityGroupComponent communiyGroupComponent = new CommunityGroupComponent();
                return communiyGroupComponent.CommunityGroupSelect(Convert.ToInt32(communityGroupId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public CommunityGroup GetCommunityGroupByIDAndOwner(string ownerId, string communityId, string communityGroupId)
        {
            try
            {
                CommunityGroupComponent communiyGroupComponent = new CommunityGroupComponent();
                return communiyGroupComponent.CommunityGroupSelectByIDAndOwner(Convert.ToInt32(ownerId), Convert.ToInt32(communityId), Convert.ToInt32(communityGroupId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<CommunityGroup> GetSupplierCommunityCommunityGroupList(string strSupplierID)
        {
            try
            {
                CommunityGroupComponent communiyGroupComponent = new CommunityGroupComponent();
                return communiyGroupComponent.SupplierCommunityCommunityGroupList(Convert.ToInt32(strSupplierID));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<CommunityGroup> GetCommunityGroupSummaryByCommunity(string communityId, string communityGroupActive)
        {
            try
            {
                CommunityGroupComponent communityGroupComponent = new CommunityGroupComponent();
                return communityGroupComponent.CommunityGroupSummaryByCommunity(Convert.ToInt32(communityId), Convert.ToBoolean(communityGroupActive));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public CommunityGroup GetCommunityGroupSummary(string communityGroupId)
        {
            try
            {
                CommunityGroupComponent communityGroupComponent = new CommunityGroupComponent();
                return communityGroupComponent.CommunityGroupSummary(Convert.ToInt32(communityGroupId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<CommunityGroup> GetCommunityGroupListByCommunity(string communityId)
        {
            try
            {
                CommunityGroupComponent communityGroupComponent = new CommunityGroupComponent();
                return communityGroupComponent.CommunityGroupSelectByCommunity(Convert.ToInt32(communityId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<CommunityGroupBillingFee> GetCommunityGroupBillingFeeList(string communityIdGroupId)
        {
            try
            {
                CommunityGroupComponent communityGroupComponent = new CommunityGroupComponent();
                return communityGroupComponent.CommunityGroupBillingFeeSelect(Convert.ToInt32(communityIdGroupId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<CommunityGroupReward> GetCommunityGroupRewardList(string communityGroupId)
        {
            try
            {
                CommunityGroupComponent communityGroupComponenet = new CommunityGroupComponent();
                return communityGroupComponenet.CommunityGroupRewardSelect(Convert.ToInt32(communityGroupId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void AddCommunityGroupRewardPoint(CommunityGroupReward communityGroupReward)
        {
            try
            {
                CommunityGroupComponent communityGroupComponenet = new CommunityGroupComponent();
                communityGroupComponenet.CommunityGroupRewardInsert(communityGroupReward);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void UpdateCommunityGroupRewardPoint(CommunityGroupReward communityGroupReward)
        {
            try
            {
                CommunityGroupComponent communityGroupComponenet = new CommunityGroupComponent();
                communityGroupComponenet.CommunityGroupRewardUpdate(communityGroupReward);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<CommunityGroup> GetSupplierCommunityGroupByCommunity(string supplierId, string communityId)
        {
            try
            {
                CommunityGroupComponent communiyGroupComponent = new CommunityGroupComponent();
                return communiyGroupComponent.SupplierCommunityGroupByCommunity(Convert.ToInt32(supplierId), Convert.ToInt32(communityId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<CommunityGroup> GetAllSupplierCommunityGroupByCommunity(string supplierId, string communityId)
        {
            try
            {
                CommunityGroupComponent communiyGroupComponent = new CommunityGroupComponent();
                return communiyGroupComponent.SupplierCommunityGroupSelectAllByCommunity(Convert.ToInt32(supplierId), Convert.ToInt32(communityId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<MenuItem> GetCommunityGroupMenu(string communityId)
        {
            try
            {
                CommunityGroupComponent communiyGroupComponent = new CommunityGroupComponent();
                return communiyGroupComponent.CommunityGroupListMenu(Convert.ToInt32(communityId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void UpdateCommunityGroupRewardList(CommunityGroupRewardList rewardList)
        {
            foreach (CommunityGroupReward communityGroupReward in rewardList.lstCommunityGroupReward)
            {
                if (communityGroupReward.CommunityGrouprewardID == 0)
                {
                    AddCommunityGroupRewardPoint(communityGroupReward);
                }
                else
                {
                    UpdateCommunityGroupRewardPoint(communityGroupReward);
                }
            }
        }

        public void UpdateCommunityGroupBillingFeeList(CommunityGroupFeeList billingFeeList)
        {
            foreach (CommunityGroupBillingFee communityGroupBillingFee in billingFeeList.lstGroupBillingFee)
            {
                if (communityGroupBillingFee.CommunityGroupBillingFeeID == 0)
                {
                    AddCommunityGroupBillingFee(communityGroupBillingFee);
                }
                else
                {
                    UpdateCommunityGroupBillingFee(communityGroupBillingFee);
                }
            }
        }

        public string CheckCommunityGroupNameExist(SearchRequest searchRequest)
        {
            try
            {
                CommunityGroupComponent communityGroupComponent = new CommunityGroupComponent();
                return communityGroupComponent.CheckCommunityGroupNameExist(searchRequest.ID, searchRequest.ParentID, searchRequest.Name);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        #endregion

        #region Community
        public Community GetCommunity(string communityId)
        {
            try
            {
                CommunityComponent communityComponent = new CommunityComponent();
                return communityComponent.CommunitySelect(Convert.ToInt32(communityId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public Community GetCommunityByIDAndOwner(string ownerId, string communityId)
        {
            try
            {
                CommunityComponent communityComponent = new CommunityComponent();
                return communityComponent.CommunitySelectByIdAndOwner(Convert.ToInt32(ownerId), Convert.ToInt32(communityId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public Community NewCommunity(Community community)
        {
            try
            {
                CommunityComponent communityComponent = new CommunityComponent();
                return communityComponent.CommunityInsert(community);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void UpdateCommunity(Community community)
        {
            try
            {
                CommunityComponent communityComponent = new CommunityComponent();
                communityComponent.CommunityUpdate(community);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Community> FindCommunity(string searchTerm, string searchDistance, string referenceLongitude, string referenceLatitude)
        {
            try
            {
                CommunityComponent communityComponent = new CommunityComponent();
                return communityComponent.CommunitySearch(searchTerm, Convert.ToDecimal(searchDistance), Convert.ToDecimal(referenceLongitude), Convert.ToDecimal(referenceLatitude));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Community> FindCommunityBySupplier(CommunitySearchRequest communitySearchRequest)
        {
            decimal nSearchDistance = 0, nSearchDistanceInMiles = 0;
            decimal latitude = 0, longitude = 0;
            try
            {
                if (Decimal.TryParse(communitySearchRequest.Distance, out nSearchDistance) && nSearchDistance > 0)
                {
                    nSearchDistanceInMiles = ((communitySearchRequest.DistanceUnit.ToLower() == "km")) ? (nSearchDistance / 1.60934M) : nSearchDistance;
                    Supplier supplier = GetSupplier(communitySearchRequest.SupplierID.ToString());
                    if (supplier != null)
                    {
                        latitude = (supplier.Latitude == null) ? 0.00M : (decimal)supplier.Latitude;
                        longitude = (supplier.Longitude == null) ? 0.00M : (decimal)supplier.Longitude;
                    }
                }

                if (communitySearchRequest.Term.ToLower() == "nullstring")
                {
                    communitySearchRequest.Term = "";
                }

                CommunityComponent communityComponent = new CommunityComponent();
                return communityComponent.CommunitySearch(communitySearchRequest.Term, nSearchDistanceInMiles, longitude, latitude);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void CancelSupplierCommunityMembership(string id, string entity, string communityId)
        {
            try
            {
                CommunityComponent communityComponent = new CommunityComponent();
                communityComponent.CommunityLeave(Convert.ToInt32(id), entity, Convert.ToInt32(communityId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Community> GetCommunitySummaryListByOwner(string ownerId, string communityActive)
        {
            try
            {
                CommunityComponent communityComponent = new CommunityComponent();
                return communityComponent.CommunitySummaryByOwner(Convert.ToInt32(ownerId), Convert.ToBoolean(communityActive));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public string CheckCommunityNameExist(SearchRequest searchRequest)
        {
            try
            {
                CommunityComponent communityComponent = new CommunityComponent();
                return communityComponent.CheckCommunityNameExist(searchRequest.ID, searchRequest.Name);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public Community GetCommunitySummary(string communityId)
        {
            try
            {
                CommunityComponent communityComponent = new CommunityComponent();
                return communityComponent.CommunitySummary(Convert.ToInt32(communityId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public Community GetCommunitySummaryByIDAndOwner(string ownerId, string communityId)
        {
            try
            {
                CommunityComponent communityComponent = new CommunityComponent();
                return communityComponent.CommunitySummaryByIDAndOwner(Convert.ToInt32(ownerId), Convert.ToInt32(communityId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Community> GetCommunityListByOwner(string ownerId)
        {
            try
            {
                CommunityComponent commuityComponent = new CommunityComponent();
                return commuityComponent.CommunitySelectByOwner(Convert.ToInt32(ownerId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Community> CommunityList()
        {
            try
            {
                CommunityComponent commuityComponent = new CommunityComponent();
                return commuityComponent.CommunitySelectAll();
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public CommunitySupplier GetCommunitySupplier(string supplierId, string communityId)
        {
            try
            {
                CommunityComponent commuityComponent = new CommunityComponent();
                return commuityComponent.CommunitySupplierSelect(Convert.ToInt32(supplierId), Convert.ToInt32(communityId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Community> CommunityListBySupplier(string supplierId)
        {
            try
            {
                CommunityComponent commuityComponent = new CommunityComponent();
                return commuityComponent.CommunitySelectBySupplier(Convert.ToInt32(supplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Community> GetCommunityListByCurrency(string currencyId)
        {
            CommunityComponent communityComponent = new CommunityComponent();
            return communityComponent.CommunitySelectByCurrency(Convert.ToInt32(currencyId));
        }
        #endregion

        #region Supplier
        public int RegisterSupplier(Supplier supplier)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                supplier.DateAdded = CommonComponent.MYSQLDateTime();
                supplier.ProfileCompletedDate = CommonComponent.MYSQLDateTime();
                return supplierComponent.RegisterNewSupplier(supplier);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public int NewCustomerSupplier(Supplier supplier)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierInsert(supplier);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public bool UpdateSupplier(Supplier supplier)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                supplierComponent.SupplierUpdate(supplier);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
            return true;
        }

        public Supplier GetSupplier(string supplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierSelect(Convert.ToInt32(supplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Supplier> GetAllSupplier()
        {
            SupplierComponent supplierComponent = new SupplierComponent();
            return supplierComponent.SupplierSelectAll();
        }

        public void UpdateShortList(SupplierShortlist supplierShortlist)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                supplierComponent.ShortlistUpate(supplierShortlist);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void AddSupplierSocial(SupplierSocialReference supplierSocialReference)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                supplierComponent.SupplierSocialReferenceInsert(supplierSocialReference);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void UpdateSupplierSocial(SupplierSocialReference supplierSocialReference)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                supplierComponent.SupplierSocialReferenceUpdate(supplierSocialReference);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Supplier> FindSupplier(string searchTerm, int communityId, int communityGroupId, string filter)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierSearch(searchTerm, communityId, communityGroupId, filter);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void InsertSupplierNote(SupplierCustomerNote supplierCustomerNote)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                supplierComponent.SupplierNoteUpdate(supplierCustomerNote);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void RemoveSupplierSocial(string supplierSocialReferenceId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                supplierComponent.SupplierSocialReferenceDelete(Convert.ToInt32(supplierSocialReferenceId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void AddReviewResponse(ReviewResponse reviewResponse)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                reviewResponse.ResponseDate = CommonComponent.MYSQLDateTime();
                CustomerSupplierCommunication customerSupplierCommunication = supplierComponent.ReviewResponseInsert(reviewResponse);
                customerSupplierCommunication.Message = reviewResponse.Response;
                //Customer customer = new Customer();
                //CustomerComponent customerComponent = new CustomerComponent();
                //customer = customerComponent.CustomerSelect(reviewResponse.CustomerID);

                EmailDispatcher emailDispatcher = new EmailDispatcher();
                emailDispatcher.SendEmail("FromEmail", customerSupplierCommunication.CustomerEmail, ApplicationName + ": " + HttpUtility.UrlDecode(reviewResponse.CommunityName + " - " + reviewResponse.CommunityGroupName) + " - " + "Respond"
                    , GenerateEmailContent(customerSupplierCommunication), true);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        #region Supplier Icon
        public void SupplierIconInsert(SupplierIcon supplierIcon)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                supplierComponent.SupplierIconInsert(supplierIcon);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public SupplierIcon SupplierIconSelect(string supplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                SupplierIcon supplierIcon = supplierComponent.SupplierIconSelect(Convert.ToInt32(supplierId));
                if (supplierIcon.Icon != null)
                {
                    ///Convert byte array to base64 string to bind it in image source
                    supplierIcon.Base64String = Convert.ToBase64String(supplierIcon.Icon);

                    //Clean up image value to avoid unwanted traffic
                    supplierIcon.Icon = null;
                }


                return supplierIcon;
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void RemoveSupplierIcon(string supplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                supplierComponent.SupplierIconDelete(Convert.ToInt32(supplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        #endregion

        #region Supplier Logo
        public void SupplierLogoInsert(SupplierLogo supplierLogo)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                supplierComponent.SupplierLogoInsert(supplierLogo);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public SupplierLogo SupplierLogoSelect(string supplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                SupplierLogo supplierLogo = supplierComponent.SupplierLogoSelect(Convert.ToInt32(supplierId));

                if (supplierLogo.Logo != null)
                {
                    ///Convert byte array to base64 string to bind it in image source
                    supplierLogo.Base64String = Convert.ToBase64String(supplierLogo.Logo);

                    //Clean up image value to avoid unwanted traffic
                    supplierLogo.Logo = null;
                }

                return supplierLogo;
                // WebOperationContext.Current.OutgoingResponse.ContentType = "image/png";
                //return new MemoryStream(supplierLogo.Logo);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void RemoveSupplierLogo(string supplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                supplierComponent.SupplierLogoDelete(Convert.ToInt32(supplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }
        #endregion

        public string CheckSupplierEmail(string supplierId, string email)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.CheckSupplierEmailExist(Convert.ToInt32(supplierId), email);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public string CheckSupplierCompanyName(SearchRequest searchRequest)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.CheckSupplierCompanyNameExist(searchRequest.ID, searchRequest.Name);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<SupplierAction> GetSupplierActionByCustomer(string strSupplierID, string strCustomerID)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierActionSelectByCustomer(Convert.ToInt32(strSupplierID), Convert.ToInt32(strCustomerID));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<SocialMedia> GetSocialMedia()
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SocialMediaSelect();
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<SupplierSocialReference> GetSupplierSocialReference(string supplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierSocialReferenceSelect(Convert.ToInt32(supplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public SupplierCommunityCount GetSupplierCommunityMembershipCount(string supplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierCommunityMembershipCount(Convert.ToInt32(supplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<SupplierCommunityGroupCount> GetCommunityListBySupplier(string supplierId, string isActive)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.CommunityListBySupplier(Convert.ToInt32(supplierId), isActive == "active" ? 1 : 0);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public CommunityDetailResponse GetCommunityDetailBySupplierId(string communityId, string supplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.CommunityDetailBySupplierId(Convert.ToInt32(communityId), Convert.ToInt32(supplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void NewSupplierCommunityMembership(CommunitySupplier communitySupplier)
        {
            try
            {
                CommunityComponent communityComponent = new CommunityComponent();
                communitySupplier.DateJoined = CommonComponent.MYSQLDateTime();
                communityComponent.CommunityJoin(communitySupplier);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<MenuItem> GetCommunityListActiveBySupplier(string supplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.CommunityListActiveBySupplier(Convert.ToInt32(supplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<MenuItem> GetSupplierReviewCount(string supplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.ReviewCountBySupplier(Convert.ToInt32(supplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public SupplierReviewResponse GetSupplierReview(string ownerId, string communityId, string communityGroupId, string supplierId, string customerId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierReviewSelect(Convert.ToInt32(ownerId), Convert.ToInt32(communityId), Convert.ToInt32(communityGroupId), Convert.ToInt32(supplierId), Convert.ToInt32(customerId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public SupplierReviewResponse GetSupplierReviewBySupplier(string ownerId, string communityId, string communityGroupId, string supplierId, string customerId, string loggedinSupplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierReviewSelectBySupplier(Convert.ToInt32(ownerId), Convert.ToInt32(communityId), Convert.ToInt32(communityGroupId), Convert.ToInt32(supplierId), Convert.ToInt32(customerId), Convert.ToInt32(loggedinSupplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public CommunityGroupDetailResponse GetCommunityGroupDetailBySupplier(string communityGroupId, string supplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.CommunityGroupDetailBySupplier(Convert.ToInt32(communityGroupId), Convert.ToInt32(supplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<MenuItem> GetCommunityGroupListActiveBySupplier(string supplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.CommunityGroupListActiveBySupplier(Convert.ToInt32(supplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<CommunitySupplier> GetSupplierCredit(string supplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierCreditSummary(Convert.ToInt32(supplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<CommunityGroupDetailChildResponse> GetCommunityGroupReviewListBySupplierRating(string communityGroupId, string supplierId, string ratingType)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.CommunityGroupReviewBySupplierRating(Convert.ToInt32(communityGroupId), Convert.ToInt32(supplierId), ratingType);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void UpdateReviewHide(Review review)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                review.ReviewDate = CommonComponent.MYSQLDateTime();
                supplierComponent.ReviewHideUpdate(review);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<SupplierDashboardResponse> GetCommunityCommunityGroupBySupplier(string supplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.CommunityCommunityGroupBySupplier(Convert.ToInt32(supplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        /// <summary>
        /// Export the supplier community transaction to a file, based on the input search criterea
        /// </summary>
        /// <param name="exportSupplierCommunityTransaction"></param>
        /// <returns>Return the temporary filename which should be downloaded using FileUploadService.svc/DownloadFile/{fileName}</returns>
        public string DownloadSupplierCommunityTransaction(ExportSupplierCommunityTransactionRequest exportSupplierCommunityTransaction)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.DownloadSupplierCommunityTransaction(exportSupplierCommunityTransaction);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<SupplierCommunityTransactionHistory> GetSupplierCommunityTransaction(SupplierCommunityTransactionHistory supplierCommunityTransactionHistory)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierCommunityTransactionSelect(supplierCommunityTransactionHistory);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public SupplierSocialReference GetSupplierSocialReferenceBySocialMedia(string supplierId, string socialMediaId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierSocialReferenceSelectBySocialMedia(Convert.ToInt32(supplierId), Convert.ToInt32(socialMediaId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public SupplierActivity GetSupplierAction(string supplierId, string communityGroupId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierActionSelectByCommunityGroup(Convert.ToInt32(supplierId), Convert.ToInt32(communityGroupId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public SupplierActivity GetSupplierActionBySupplierActionId(string supplierId, string communityGroupId, string supplierActionId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierActionSelectByCommunityGroup(Convert.ToInt32(supplierId), Convert.ToInt32(communityGroupId), Convert.ToInt32(supplierActionId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        //public void SendCustomerMessage(CustomerSupplierCommunication customerSupplierCommunication)
        //{
        //    try
        //    {
        //        CustomerComponent customerComponent = new CustomerComponent();
        //        customerComponent.CustomerSupplierCommunicationInsert(customerSupplierCommunication);

        //        Customer customer = new Customer();
        //        customer = customerComponent.CustomerSelect(customerSupplierCommunication.CustomerId);

        //        EmailDispatcher emailDispatcher = new EmailDispatcher();
        //        emailDispatcher.SendEmail("FromEmail", customer.Email, "Ratings & Reviews Engine: Supplier Message", customerSupplierCommunication.Message, true);

        //    }
        //    catch (Exception ex)
        //    {
        //        LogException(ex);
        //        RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
        //        throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
        //    }
        //}

        public void SendCustomerAnswer(CustomerSupplierCommunication customerSupplierCommunication)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                customerSupplierCommunication = customerComponent.CustomerSupplierCommunicationInsert(customerSupplierCommunication);
                customerSupplierCommunication.ActionName = "Supplier Answer";

                EmailDispatcher emailDispatcher = new EmailDispatcher();
                emailDispatcher.SendEmail("FromEmail", customerSupplierCommunication.CustomerEmail, ApplicationName + ": " + HttpUtility.UrlDecode(customerSupplierCommunication.CommunityName + " - " + customerSupplierCommunication.CommunityGroupName) + " - Answer",
                    GenerateEmailContent(customerSupplierCommunication), true);

                /*Customer customer = new Customer();
                customer = customerComponent.CustomerSelect(customerSupplierCommunication.CustomerId);

                EmailDispatcher emailDispatcher = new EmailDispatcher();
                emailDispatcher.SendEmail("FromEmail", customer.Email, "Ratings & Reviews Engine: " + HttpUtility.UrlDecode(customerSupplierCommunication.CommunityName + " - " + customerSupplierCommunication.CommunityGroupName) + " - Answer",
                    GenerateEmailContent(customerSupplierCommunication), true);
                 * */

            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        private string GenerateEmailContent(CustomerSupplierCommunication communication)
        {

            //CommunitySupplierCommunication communication = new CommunitySupplierCommunication(){
            // ActionDate = DateTime.Now,
            // ActionDetail = "Reply" , CommunicationId = 0 , CommunityGroupName = "Wedding Planner" , CommunityName = "Brisbane Community", CustomerEmail="anna_MHJ@versatile-soft.com" , CustomerFirstName = "Annamalai", CustomerLastName = "Samy" , SupplierEmail = "annamalai@versatile-soft.com" , SupplierName = "Card Designer",
            // Message = "Phasellus dictum sapien a neque luctus cursus. Pellentesque sem dolor, fringilla et pharetra vitae. consequat vel lacus. Sed iaculis pulvinar ligula, ornare fringilla ante viverra et. In hac habitasse platea dictumst. Donec vel orci mi, eu congue justo. Integer eget odio est, eget malesuada lorem. Aenean sed tellus dui, vitae viverra risus. Nullam massa sapien, pulvinar eleifend fringilla id, convallis eget nisi. Mauris a sagittis dui. Pellentesque non lacinia mi. Fusce sit amet libero sit amet erat venenatis sollicitudin vitae vel eros. Cras nunc sapien, interdum sit amet porttitor ut, congue quis urna."
            //};
            //= HttpUtility.HtmlEncode(HttpUtility.UrlDecode(customerSupplierCommunication.Message)); 

            //StringBuilder strEmailContent = new StringBuilder();
            //strEmailContent.Append("<table class='twelve columns'>");
            //strEmailContent.Append(String.Format("<tr><td class='panel lead '>Community </td> <td class='panel'> {0}</td> </tr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(communication.CommunityName))));
            //strEmailContent.Append(String.Format("<tr><td class='panel lead three'>Community Group </td> <td class='panel'> {0}</td> </tr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(communication.CommunityGroupName))));
            //strEmailContent.Append(String.Format("<tr><td class='panel lead'>Customer  </td> <td class='panel'> {0} {1}</td> </tr>", communication.CustomerFirstName, communication.CustomerLastName));
            //strEmailContent.Append(String.Format("<tr><td class='panel lead'>Supplier </td> <td class='panel'> {0}</td> </tr></table><hr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(communication.SupplierName))));

            //strEmailContent.Append(String.Format("<table class='twelve columns'> <tr><td class='panel lead'>  <b> {0} </b></td>   </tr>", communication.ActionName));
            //strEmailContent.Append(String.Format("<tr><td class='panel lead'>   <p>  {0} </p>  </td> </tr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(communication.Message))));

            //strEmailContent.Append("</table>");

            string path = Path.Combine(HttpContext.Current.Server.MapPath("~/Template/"), "ActivityEmail.html");
            string emailBody = File.ReadAllText(path);
            emailBody = string.Format(emailBody, communication.ActionName, HttpUtility.HtmlEncode(HttpUtility.UrlDecode(communication.CommunityName)), HttpUtility.HtmlEncode(HttpUtility.UrlDecode(communication.CommunityGroupName))
                , communication.CustomerFirstName + " " + communication.CustomerLastName, HttpUtility.HtmlEncode(HttpUtility.UrlDecode(communication.SupplierName)), HttpUtility.HtmlEncode(HttpUtility.UrlDecode(communication.Message)));

            return emailBody;// strEmailContent.ToString();
        }

        public void SendCustomerMoreInfo(CustomerSupplierCommunication customerSupplierCommunication)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                customerComponent.CustomerSupplierCommunicationInsert(customerSupplierCommunication);

                customerSupplierCommunication.ActionName = "More information needed for quote request";

                EmailDispatcher emailDispatcher = new EmailDispatcher();
                emailDispatcher.SendEmail("FromEmail", customerSupplierCommunication.CustomerEmail, ApplicationName + ": More information needed for quote request",
                    GenerateEmailContent(customerSupplierCommunication), true);

                /*
                 * 
                Customer customer = new Customer();
                customer = customerComponent.CustomerSelect(customerSupplierCommunication.CustomerId);

                EmailDispatcher emailDispatcher = new EmailDispatcher();
                emailDispatcher.SendEmail("FromEmail", customer.Email, "Ratings & Reviews Engine: " + HttpUtility.UrlDecode(customerSupplierCommunication.CommunityName + " - " + customerSupplierCommunication.CommunityGroupName) + " - More Info", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(customerSupplierCommunication.Message)), true);
                */
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void SendCustomerQuoteDetail(CustomerSupplierCommunication customerSupplierCommunication)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                customerSupplierCommunication = customerComponent.CustomerSupplierCommunicationInsert(customerSupplierCommunication);

                EmailDispatcher emailDispatcher = new EmailDispatcher();
                emailDispatcher.SendEmail("FromEmail", customerSupplierCommunication.CustomerEmail, ApplicationName + ": " + HttpUtility.UrlDecode(customerSupplierCommunication.CommunityName + " - " + customerSupplierCommunication.CommunityGroupName) + " - Quote", GenerateEmailContent(customerSupplierCommunication), true);
                /*
                                Customer customer = new Customer();
                                customer = customerComponent.CustomerSelect(customerSupplierCommunication.CustomerId);

                                EmailDispatcher emailDispatcher = new EmailDispatcher();
                                emailDispatcher.SendEmail("FromEmail", customer.Email, "Ratings & Reviews Engine: " + HttpUtility.UrlDecode(customerSupplierCommunication.CommunityName + " - " + customerSupplierCommunication.CommunityGroupName) + " - Quote", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(customerSupplierCommunication.Message)), true);
                                */
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void SendCustomerMessage(CustomerSupplierCommunication customerSupplierCommunication)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                customerSupplierCommunication = customerComponent.CustomerSupplierCommunicationInsert(customerSupplierCommunication);
                customerSupplierCommunication.ActionName = "Supplier Message";

                EmailDispatcher emailDispatcher = new EmailDispatcher();
                emailDispatcher.SendEmail("FromEmail", customerSupplierCommunication.CustomerEmail, ApplicationName + ": " + HttpUtility.UrlDecode(customerSupplierCommunication.CommunityName + " - " + customerSupplierCommunication.CommunityGroupName) + " - Reply", GenerateEmailContent(customerSupplierCommunication), true);

            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }
        public List<MenuItem> SupplierActionCountMenu(string supplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierActionCount(Convert.ToInt32(supplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void SendCustomerQuote(CustomerQuote quote)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                quote = customerComponent.CustomerQuoteInsert(quote);

                /* Customer customer = new Customer();
                 customer = customerComponent.CustomerSelect(customerQuote.CustomerID);
               
                 string emailBody = "Quote Amount:" + customerQuote.QuoteAmount + "<br/> Quote Terms:" + HttpUtility.HtmlEncode(HttpUtility.UrlDecode(customerQuote.QuoteTerms)) + "<br/> Additional Note:" + customerQuote.QuoteDetail + "<br/> Specify Deposit:" + customerQuote.DepositSpecified
                     + "<br/> Deposit Amount:" + customerQuote.DepositAmount + "<br/> Deposit Terms:" + HttpUtility.HtmlEncode(HttpUtility.UrlDecode(customerQuote.DepositTerms));
  */
                //EmailDispatcher emailDispatcher = new EmailDispatcher();
                //emailDispatcher.SendEmail("FromEmail", customerQuote.CustomerEmail, "Ratings & Reviews Engine: Quote detail", GenerateQuoteEmail(customerQuote), true);

                EmailDispatcher emailDispatcher = new EmailDispatcher();


                string path = Path.Combine(HttpContext.Current.Server.MapPath("~/Template/"), "Quote.html");
                string emailBody = File.ReadAllText(path);
                emailBody = string.Format(emailBody, HttpUtility.HtmlEncode(HttpUtility.UrlDecode(quote.CommunityName)), HttpUtility.HtmlEncode(HttpUtility.UrlDecode(quote.CommunityGroupName)), quote.CustomerFirstName, quote.CustomerLastName
                    , HttpUtility.HtmlEncode(HttpUtility.UrlDecode(quote.SupplierName)), quote.QuoteAmount, quote.CurrencyCode, HttpUtility.HtmlEncode(HttpUtility.UrlDecode(quote.QuoteTerms)), quote.QuoteDetail, (quote.DepositSpecified ? "Yes" : "No")
                    , quote.DepositAmount, quote.CurrencyCode, HttpUtility.HtmlEncode(HttpUtility.UrlDecode(quote.DepositTerms)));

                emailDispatcher.SendEmail("FromEmail", quote.CustomerEmail, ApplicationName + ": Quote detail", emailBody, true);

            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        private string GenerateQuoteEmail(CustomerQuote quote)
        {
            StringBuilder strEmailContent = new StringBuilder();
            strEmailContent.Append("<table class='twelve columns'>");
            strEmailContent.Append(String.Format("<tr><td class='panel lead '>Community </td> <td class='panel'> {0}</td> </tr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(quote.CommunityName))));
            strEmailContent.Append(String.Format("<tr><td class='panel lead three'>Community Group </td> <td class='panel'> {0}</td> </tr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(quote.CommunityGroupName))));
            strEmailContent.Append(String.Format("<tr><td class='panel lead'>Customer  </td> <td class='panel'> {0} {1}</td> </tr>", quote.CustomerFirstName, quote.CustomerLastName));
            strEmailContent.Append(String.Format("<tr><td class='panel lead'>Supplier </td> <td class='panel'> {0}</td> </tr></table><hr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(quote.SupplierName))));


            strEmailContent.Append(String.Format("<table class='twelve columns'> <tr><td class='panel lead' colspan='2' >  <b> {0} </b></td>   </tr>", "Quote Detail"));
            strEmailContent.Append(String.Format("<tr><td class='panel lead three'><b> Quote Amount </b></td> <td class='panel'> <b>({1}) {0} </b></td> </tr>", quote.QuoteAmount, quote.CurrencyCode));
            strEmailContent.Append(String.Format("<tr><td class='panel lead'>Quote Terms </td> <td class='panel'> {0}</td> </tr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(quote.QuoteTerms))));
            strEmailContent.Append(String.Format("<tr><td class='panel lead'>Additional Note </td> <td class='panel'> {0}</td> </tr>", quote.QuoteDetail));
            strEmailContent.Append(String.Format("<tr><td class='panel lead'>Specify Deposit </td> <td class='panel'> {0} </td> </tr>", quote.DepositSpecified ? "Yes" : "No"));
            if (quote.DepositSpecified)
            {
                strEmailContent.Append(String.Format("<tr><td class='panel lead'>Deposit Amount </td> <td class='panel'> ({1}) {0}</td> </tr>", quote.DepositAmount, quote.CurrencyCode));
                strEmailContent.Append(String.Format("<tr><td class='panel lead'>Deposit Terms </td> <td class='panel'> {0}</td> </tr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(quote.DepositTerms))));
            }
            //strEmailContent.Append(String.Format("<tr><td class='panel lead'>   <p>  {0} </p>  </td> </tr>", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(communication.Message))));

            strEmailContent.Append("</table>");
            return strEmailContent.ToString();
        }
        public SupplierAction GetSupplierActionByActionId(string supplierActionId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierActionSelect(Convert.ToInt32(supplierActionId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public SupplierAction GetSupplierParentActionByActionId(string supplierActionId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierPArentActionSelect(Convert.ToInt32(supplierActionId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public int GetSupplierReviewPendingCountByGroup(string supplierId, string communityGroupId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierReviewPendingCountByCommunityGroupId(Convert.ToInt32(supplierId), Convert.ToInt32(communityGroupId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public MenuItem GetSupplierReviewHeader(string communityId, string communityGroupId, string supplierId, string ownerId, string loggedinSupplierId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierReviewCountByCommunityGroup(Convert.ToInt32(communityId), Convert.ToInt32(communityGroupId), Convert.ToInt32(supplierId), Convert.ToInt32(ownerId), Convert.ToInt32(loggedinSupplierId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void UpdateBillFreeEndDate()
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                supplierComponent.BillFreeEndDateUpdate(CommonComponent.MYSQLDateTime());
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public decimal GetSupplierAccountBalance(string supplierId, string communityId)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                return supplierComponent.SupplierAccountBalanceByCommunity(Convert.ToInt32(supplierId), Convert.ToInt32(communityId));
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }


        public void SupplierMonthlyBill(SupplierCommunityTransactionHistory supplierTransactionHistoryRequest)
        {
            try
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                List<SupplierBillingResponse> lstSupplierBilling = supplierComponent.SupplierMonthlyBilling(supplierTransactionHistoryRequest);
                foreach (SupplierBillingResponse supplierBillingReference in lstSupplierBilling)
                {
                    Microsoft.Reporting.WebForms.Warning[] warnings;
                    string[] streamids;
                    string mimeType = string.Empty;
                    string encoding = string.Empty;
                    string filenameExtension = string.Empty;
                    ReportDataSource rdsAct = new ReportDataSource("RatingReviewEngineBusiness", supplierBillingReference.listSupplierTransactionHistory);
                    rdsAct.Name = "DataSet1";
                    rdsAct.Value = supplierBillingReference.listSupplierTransactionHistory;

                    ReportViewer rpt = new ReportViewer();
                    LocalReport rep = rpt.LocalReport;
                    rep.DataSources.Clear();
                    ReportParameter suppliernameParam = new ReportParameter("SupplierName", supplierBillingReference.SupplierName);
                    ReportParameter fromDateParam = new ReportParameter("FromDate", supplierTransactionHistoryRequest.FromDate);
                    ReportParameter toDateParam = new ReportParameter("ToDate", supplierTransactionHistoryRequest.ToDate);


                    rpt.LocalReport.ReportPath = "SupplierBilling.rdlc";
                    rpt.LocalReport.DataSources.Add(rdsAct);
                    rpt.LocalReport.SetParameters(suppliernameParam);
                    rpt.LocalReport.SetParameters(fromDateParam);
                    rpt.LocalReport.SetParameters(toDateParam);

                    rpt.LocalReport.Refresh();
                    byte[] bytes = rpt.LocalReport.Render("PDF", null, out mimeType, out encoding, out filenameExtension, out streamids, out warnings);

                    string filename = Path.Combine(HttpContext.Current.Server.MapPath("~/Assets/ExportedFiles/"), supplierBillingReference.SupplierID + ".pdf");
                    using (var fs = new FileStream(filename, FileMode.Create))
                    {
                        fs.Write(bytes, 0, bytes.Length);
                        fs.Close();
                    }

                    // EmailDispatcher emailDispatcher = new EmailDispatcher();
                    // emailDispatcher.SendEmail("From email", supplierBillingReference.Email, " MONTHLY BILLING CYCLE", " MONTHLY BILLING CYCLE" + supplierBillingReference.SupplierName + " " + supplierBillingReference.Email, new System.Net.Mail.Attachment(filename), true);
                }
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }
        #endregion

        #region Bank Account
        public void UpdateBankAccount(BankAccount bankAccount)
        {
            try
            {
                BankAccountComponent bankAccountComponent = new BankAccountComponent();
                bankAccountComponent.BankAccountUpdate(bankAccount);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }
        public BankAccount GetBankingDetails(string id, string entity)
        {
            try
            {
                BankAccountComponent bankAccountComponent = new BankAccountComponent();
                return bankAccountComponent.BankingDetailsSelect(Convert.ToInt32(id), entity);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }
        public VirtualCommunityAccount DebitVirtualCommunityAccount(VirtualCommunityAccount virtualCommunityAccount)
        {
            try
            {
                BankAccountComponent bankAccountComponent = new BankAccountComponent();
                return bankAccountComponent.DebitVirtualCommunityAccount(virtualCommunityAccount.ID, virtualCommunityAccount.Entity, virtualCommunityAccount.CommunityID, virtualCommunityAccount.CommunityGroupID, virtualCommunityAccount.Description
                    , virtualCommunityAccount.Amount, CommonComponent.MYSQLDateTime(), virtualCommunityAccount.CustomerID);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public VirtualCommunityAccount CreditVirtualCommunityAccount(VirtualCommunityAccount virtualCommunityAccount)
        {
            try
            {
                BankAccountComponent bankAccountComponent = new BankAccountComponent();
                return bankAccountComponent.CreditVirtualCommunityAccount(virtualCommunityAccount.ID, virtualCommunityAccount.Entity, virtualCommunityAccount.CommunityID, virtualCommunityAccount.CommunityGroupID, virtualCommunityAccount.Description
                    , virtualCommunityAccount.Amount, CommonComponent.MYSQLDateTime(), virtualCommunityAccount.CustomerID);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public VirtualCommunityAccount GetTransactionHistory(int transactionHistoryId, string entity)
        {
            try
            {
                BankAccountComponent bankComponent = new BankAccountComponent();
                return bankComponent.TransactionSelect(transactionHistoryId, entity);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void NewCustomerTransaction(VirtualCommunityAccount virtualCommunityAccount)
        {
            try
            {
                virtualCommunityAccount.DateApplied = CommonComponent.MYSQLDateTime();
                BankAccountComponent bankComponent = new BankAccountComponent();
                bankComponent.TransactionInsert(virtualCommunityAccount);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public PaypalTransaction GetPaypalTransaction(string transactionId)
        {
            try
            {
                BankAccountComponent bankComponent = new BankAccountComponent();
                return bankComponent.PaypalTransactionSelect(transactionId);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        #endregion

        #region Customer
        public void UpdateCustomer(Customer customer)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                customerComponent.CustomerUpdate(customer);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public Customer GetCustomer(int customerId)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                return customerComponent.CustomerSelect(customerId);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Customer> GetAllCustomer()
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                return customerComponent.CustomerSelectAll();

            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Customer> FindCustomer(string searchTerm, int communityId, int supplierId)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                return customerComponent.CustomerSearch(searchTerm, communityId, supplierId);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public int SubmitCustomerReview(Review review)
        {
            try
            {
                int id;
                CustomerComponent customerComponent = new CustomerComponent();
                CustomerSupplierCommunication customerSupplierCommunication = new CustomerSupplierCommunication();
                customerSupplierCommunication = customerComponent.CustomerReviewInsert(review);
                id = customerSupplierCommunication.ReviewID;


                EmailDispatcher emailDispatcher = new EmailDispatcher();

                string path = Path.Combine(HttpContext.Current.Server.MapPath("~/Template/"), "Review.html");
                string emailBody = File.ReadAllText(path);
                emailBody = string.Format(emailBody, HttpUtility.HtmlEncode(HttpUtility.UrlDecode(customerSupplierCommunication.CommunityName)), HttpUtility.HtmlEncode(HttpUtility.UrlDecode(customerSupplierCommunication.CommunityGroupName)),
                    customerSupplierCommunication.CustomerFirstName, HttpUtility.HtmlEncode(HttpUtility.UrlDecode(customerSupplierCommunication.SupplierName)), review.Rating, HttpUtility.HtmlEncode(HttpUtility.UrlDecode(review.ReviewMessage)));

                emailDispatcher.SendEmail("FromEmail", customerSupplierCommunication.SupplierEmail, ApplicationName + ": Rate & Review", emailBody, true);
                return id;
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public Review GetCustomerReview(int reviewId)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                return customerComponent.CustomerReviewSelect(reviewId);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Review> GetCustomerReviews(int supplierId, int communityId, int communityGroupId)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                return customerComponent.CustomerReviewsSelect(supplierId, communityId, communityGroupId);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void ReviewHelpful(ReviewHelpful reviewHelpful)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                customerComponent.ReviewHelpfulInsert(reviewHelpful);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<ReviewResponse> GetReviewResponse(int reviewId)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                return customerComponent.ReviewResponseSelect(reviewId);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void InsertCustomerNote(SupplierCustomerNote supplierCustomerNote)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                customerComponent.CustomerNoteUpdate(supplierCustomerNote);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void CustomerJoinCommunity(CommunitySupplier communitySupplier)
        {
            try
            {
                CommunityComponent communityComponent = new CommunityComponent();
                communityComponent.CommunityJoin(communitySupplier);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public CustomerRewards GetCustomerRewards(int customerId, int communityId)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                return customerComponent.RewardsSelect(customerId, communityId);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public CustomerPointsTally GetCustomerRewardsTally(int customerId, int communityId)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                return customerComponent.RewardsTallySelect(customerId, communityId);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public List<Customer> FindCustomerBySupplier(CustomerSearchRequest customerSearchRequest)
        {
            try
            {
                if (customerSearchRequest.Handle == "nullstring")
                    customerSearchRequest.Handle = "";
                if (customerSearchRequest.FirstName == "nullstring")
                    customerSearchRequest.FirstName = "";
                if (customerSearchRequest.LastName == "nullstring")
                    customerSearchRequest.LastName = "";
                if (customerSearchRequest.Email == "nullstring")
                    customerSearchRequest.Email = "";

                CustomerComponent customerComponent = new CustomerComponent();
                return customerComponent.CustomerSearchBySupplier(customerSearchRequest.SupplierID, customerSearchRequest.Handle, customerSearchRequest.FirstName, customerSearchRequest.LastName, customerSearchRequest.Email, customerSearchRequest.CommunityGroupID, customerSearchRequest.ActionID, customerSearchRequest.CustomerID);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void AddCustomerSupplierCommunication(CustomerSupplierCommunication customerSupplierCommunication)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                customerSupplierCommunication = customerComponent.CustomerSupplierCommunicationInsert(customerSupplierCommunication);

                EmailDispatcher emailDispatcher = new EmailDispatcher();
                emailDispatcher.SendEmail("FromEmail", customerSupplierCommunication.CustomerEmail, ApplicationName + ": " + HttpUtility.UrlDecode(customerSupplierCommunication.CommunityName + " - " + customerSupplierCommunication.CommunityGroupName) + " - " + customerSupplierCommunication.ActionName,
                    GenerateEmailContent(customerSupplierCommunication), true);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void SendSupplierQuestion(CustomerSupplierCommunication customerSupplierCommunication)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                customerSupplierCommunication = customerComponent.CustomerSupplierCommunicationInsert(customerSupplierCommunication);

                customerSupplierCommunication.ActionName = "Customer Question";

                /*SupplierComponent supplierComponent = new SupplierComponent();
                Supplier supplier = new Supplier();
                supplier = supplierComponent.SupplierSelect(customerSupplierCommunication.SupplierId);
                */
                EmailDispatcher emailDispatcher = new EmailDispatcher();
                emailDispatcher.SendEmail("FromEmail", customerSupplierCommunication.SupplierEmail, ApplicationName + ": Customer Question", GenerateEmailContent(customerSupplierCommunication), true);

            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public void SendMessage(CustomerSupplierCommunication customerSupplierCommunication)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                customerSupplierCommunication = customerComponent.CustomerSupplierCommunicationInsert(customerSupplierCommunication);

                /* TODO : Remove after implementing email content changes and testing complete
                SupplierComponent supplierComponent = new SupplierComponent();
                Supplier supplier = new Supplier();
                supplier = supplierComponent.SupplierSelect(customerSupplierCommunication.SupplierId);
                */
                customerSupplierCommunication.ActionName = "Customer Message";
                //customerSupplierCommunication.Message = HttpUtility.HtmlEncode(HttpUtility.UrlDecode(customerSupplierCommunication.Message)) ;
                customerSupplierCommunication.Message = customerSupplierCommunication.Message;
                EmailDispatcher emailDispatcher = new EmailDispatcher();
                emailDispatcher.SendEmail("FromEmail", customerSupplierCommunication.SupplierEmail, ApplicationName + ": Customer Message", GenerateEmailContent(customerSupplierCommunication), true);

            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public CustomerSupplierCommunication SendQuoteRequest(CustomerSupplierCommunication customerSupplierCommunication)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                customerSupplierCommunication = customerComponent.CustomerSupplierCommunicationInsert(customerSupplierCommunication);
                customerSupplierCommunication.ActionName = "Quote Request Information";
                /* TODO : Remove after implementing email content changes and testing complete
                 SupplierComponent supplierComponent = new SupplierComponent();
                 Supplier supplier = new Supplier();
                 supplier = supplierComponent.SupplierSelect(customerSupplierCommunication.SupplierId);
                 */
                EmailDispatcher emailDispatcher = new EmailDispatcher();
                // emailDispatcher.SendEmail("FromEmail", supplier.Email, "Ratings & Reviews Engine: Customer Quote Request", HttpUtility.HtmlEncode(HttpUtility.UrlDecode(customerSupplierCommunication.Message)), true);
                emailDispatcher.SendEmail("FromEmail", customerSupplierCommunication.SupplierEmail, ApplicationName + ": Customer Quote Request", GenerateEmailContent(customerSupplierCommunication), true);
                return customerSupplierCommunication;

            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public CustomerQuote GetCustomerQuote(string quoteId)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                return customerComponent.CustomerQuoteSelect(Convert.ToInt32(quoteId));

            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }


        public CustomerQuote GetCustomerQuoteByParentSupplierActionId(string supplierActionId)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                return customerComponent.CustomerQuoteSelectByParentSupplierActionId(Convert.ToInt32(supplierActionId));

            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }


        public string DownloadSupplierActionAttachment(string supplierActionId)
        {
            try
            {
                CustomerComponent customerComponent = new CustomerComponent();
                CustomerSupplierActionAttachment customerSupplierActionAttachment = customerComponent.CustomerSupplieractionAttachmentSelect(Convert.ToInt32(supplierActionId));
                string filename = customerSupplierActionAttachment.FileName;
                MemoryStream stream = new MemoryStream(customerSupplierActionAttachment.Attachment);

                //stream.Write(customerSupplierActionAttachment.Attachment, 0, customerSupplierActionAttachment.Attachment.Length);
                //stream.Position = 0;


                //  HttpMultipartParser.MultipartFormDataParser parser = new HttpMultipartParser.MultipartFormDataParser(stream);

                using (var fileStream = new System.IO.FileStream(System.Web.HttpContext.Current.Server.MapPath("~/Assets/ExportedFiles/") + supplierActionId + "_" + filename, System.IO.FileMode.Create, System.IO.FileAccess.Write))
                {
                    fileStream.Write(customerSupplierActionAttachment.Attachment, 0, customerSupplierActionAttachment.Attachment.Length);
                }
                return supplierActionId + "_" + filename;
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }
        #endregion

        #region TestMethods
        [RequireUserAuthentication]
        public ServiceResponseBase SampleGetMethod()
        {
            return new ServiceResponseBase();
        }
        [RequireUserAuthentication]
        public ServiceResponseBase SamplePostMethod(ServiceRequestBase request)
        {
            return new ServiceResponseBase();
        }

        public string ExportReportToPDF(SupplierTransactionHistoryRequest supplierTransactionHistoryRequest)
        {
            Microsoft.Reporting.WebForms.Warning[] warnings;
            string[] streamids;
            string mimeType = string.Empty;
            string encoding = string.Empty;
            string filenameExtension = string.Empty;
            ReportDataSource rdsAct = new ReportDataSource("RatingReviewEngineBusiness", supplierTransactionHistoryRequest.lstSupplierTransactionHistory);
            rdsAct.Name = "DataSet1";
            rdsAct.Value = supplierTransactionHistoryRequest.lstSupplierTransactionHistory;

            ReportViewer rpt = new ReportViewer();
            LocalReport rep = rpt.LocalReport;
            rep.DataSources.Clear();

            rpt.LocalReport.ReportPath = supplierTransactionHistoryRequest.ReportName;
            rpt.LocalReport.DataSources.Add(rdsAct);
            rpt.LocalReport.Refresh();
            byte[] bytes = rpt.LocalReport.Render("PDF", null, out mimeType, out encoding, out filenameExtension, out streamids, out warnings);

            string filename = Path.Combine(HttpContext.Current.Server.MapPath("~/Assets/ExportedFiles/"), supplierTransactionHistoryRequest.PDFFileName);
            using (var fs = new FileStream(filename, FileMode.Create))
            {
                fs.Write(bytes, 0, bytes.Length);
                fs.Close();
            }

            return filename;
        }
        #endregion

        #region Payment methods
        public void PaymentTransaction(PaymentRequest paymentRequest)
        {
            try
            {
                PaymentProcess paymentProcess = new PaymentProcess();
                paymentRequest.testMode = Convert.ToInt32(ConfigurationManager.AppSettings["PaymentMode"].ToString());
                PaymentResult paymentResult = paymentProcess.SubmitTransaction(paymentRequest, HttpContext.Current);
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public PaypalTransaction PayflowPayment(PaymentProcessRequest paymentProcess)
        {
            try
            {
                Payflow payflow = new Payflow();
                PaypalPayflowComponent paypalPayflowComponent = new PaypalPayflowComponent();
                payflow.TransactionType = "S";
                payflow.Tender = "C";
                payflow.Acct = paymentProcess.Cardnumber;
                payflow.Amount = paymentProcess.Amount;
                payflow.Comment = paymentProcess.Commnet;
                payflow.ExpDate = paymentProcess.ExpiryDate;
                payflow.SecurityCode = paymentProcess.SecuirtyCode;
                payflow.Partner = ConfigurationManager.AppSettings["PARTNER"].ToString();
                payflow.Password = ConfigurationManager.AppSettings["PWD"].ToString();
                payflow.User = ConfigurationManager.AppSettings["USER"].ToString();
                payflow.Vendor = ConfigurationManager.AppSettings["VENDOR"].ToString();
                payflow.Currency = paymentProcess.Currency;

                PaypalTransaction transaction = paypalPayflowComponent.PayflowCreditCardProcess(payflow);
                transaction.OAuthAccountID = paymentProcess.OAuthAccountID;
                transaction.TransactionDate = CommonComponent.MYSQLDateTime();
                BankAccountComponent bankAccountComponent = new BankAccountComponent();
                bankAccountComponent.PaypalTransactionInsert(transaction);

                string path = Path.Combine(HttpContext.Current.Server.MapPath("~/Template/"), "PaymentReceipt.html");
                string emailBody = File.ReadAllText(path);
                string responseMessage = transaction.ResponseMessage;
                if (responseMessage.Contains("Invalid expiration date"))
                    responseMessage = "Invalid expiration date";

                transaction.Status = transaction.Status.TrimEnd('.');
                emailBody = string.Format(emailBody, HttpUtility.HtmlEncode(HttpUtility.UrlDecode(paymentProcess.CommunityName)), paymentProcess.Amount, paymentProcess.Currency, transaction.TransactionID, transaction.Status, responseMessage, "Credit Card");

                EmailDispatcher emailDispatcher = new EmailDispatcher();
                emailDispatcher.SendEmail("FromEmail", paymentProcess.Email, ApplicationName + " - Payment Receipt", emailBody, true);


                return transaction;
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public PaypalTransaction PayflowPaypalPayment(PaymentProcessRequest paymentProcess)
        {
            PaypalTransaction transaction = new PaypalTransaction();
            string url = string.Empty;
            try
            {
                Payflow payflow = new Payflow();
                PaypalPayflowComponent paypalPayflowComponent = new PaypalPayflowComponent();
                payflow.TransactionType = "S";
                payflow.Currency = paymentProcess.Currency;
                payflow.Amount = paymentProcess.Amount;
                payflow.Partner = ConfigurationManager.AppSettings["PARTNER"].ToString();
                payflow.Password = ConfigurationManager.AppSettings["PWD"].ToString();
                payflow.User = ConfigurationManager.AppSettings["USER"].ToString();
                payflow.Vendor = ConfigurationManager.AppSettings["VENDOR"].ToString();

                payflow.ID = paymentProcess.ID;
                payflow.CommunityID = paymentProcess.CommunityID;
                payflow.CommunityGroupID = paymentProcess.CommunityGroupID;
                payflow.Description = paymentProcess.Description;
                payflow.Entity = paymentProcess.Entity;
                payflow.CommunityName = paymentProcess.CommunityName;

                payflow.OAuthAccountID = paymentProcess.OAuthAccountID.ToString();

                transaction = paypalPayflowComponent.PayflowPaypalProcess(payflow);


            }
            catch (Exception ex)
            {

                //LogException(ex);
                //RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                //throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
            return transaction;
        }

        public PaypalTransaction PayflowPaypalPaymentConfirm(PaymentProcessRequest paymentProcess)
        {
            try
            {
                Payflow payflow = new Payflow();
                PaypalPayflowComponent paypalPayflowComponent = new PaypalPayflowComponent();
                payflow.TransactionType = "S";
                payflow.Tender = "P";
                payflow.PayerID = paymentProcess.PayerID;
                payflow.Token = paymentProcess.Token;
                payflow.Amount = paymentProcess.Amount;
                payflow.Currency = paymentProcess.Currency;


                payflow.Partner = ConfigurationManager.AppSettings["PARTNER"].ToString();
                payflow.Password = ConfigurationManager.AppSettings["PWD"].ToString();
                payflow.User = ConfigurationManager.AppSettings["USER"].ToString();
                payflow.Vendor = ConfigurationManager.AppSettings["VENDOR"].ToString();

                PaypalTransaction transaction = paypalPayflowComponent.PayflowPaypalConfirm(payflow);
                transaction.OAuthAccountID = paymentProcess.OAuthAccountID;
                transaction.TransactionDate = CommonComponent.MYSQLDateTime();
                BankAccountComponent bankAccountComponent = new BankAccountComponent();
                bankAccountComponent.PaypalTransactionInsert(transaction);

                string path = Path.Combine(HttpContext.Current.Server.MapPath("~/Template/"), "PaymentReceipt.html");
                string emailBody = File.ReadAllText(path);
                transaction.Status = transaction.Status.TrimEnd('.');
                string responseMessage = transaction.ResponseMessage;
                if (responseMessage.Contains("Invalid expiration date"))
                    responseMessage = "Invalid expiration date";

                emailBody = string.Format(emailBody, HttpUtility.HtmlEncode(HttpUtility.UrlDecode(paymentProcess.CommunityName)), paymentProcess.Amount, paymentProcess.Currency, transaction.TransactionID, transaction.Status, responseMessage, "PayPal");

                EmailDispatcher emailDispatcher = new EmailDispatcher();
                emailDispatcher.SendEmail("FromEmail", paymentProcess.Email, ApplicationName + " - Payment Receipt", emailBody, true);


                return transaction;
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        public PaypalTransaction PayflowACHPayment(PaymentProcessRequest paymentProcess)
        {
            try
            {
                Payflow payflow = new Payflow();
                PaypalPayflowComponent paypalPayflowComponent = new PaypalPayflowComponent();
                payflow.TransactionType = "S";
                payflow.Tender = "A";
                payflow.Acct = paymentProcess.Cardnumber;
                payflow.Amount = paymentProcess.Amount;
                payflow.Firstname = "Susan Smith";
                payflow.Partner = ConfigurationManager.AppSettings["PARTNER"].ToString();
                payflow.Password = ConfigurationManager.AppSettings["PWD"].ToString();
                payflow.User = ConfigurationManager.AppSettings["USER"].ToString();
                payflow.Vendor = ConfigurationManager.AppSettings["VENDOR"].ToString();
                payflow.Currency = paymentProcess.Currency;

                PaypalTransaction transaction = paypalPayflowComponent.PayflowACHProcess(payflow);
                transaction.OAuthAccountID = paymentProcess.OAuthAccountID;
                transaction.TransactionDate = CommonComponent.MYSQLDateTime();
                BankAccountComponent bankAccountComponent = new BankAccountComponent();
                bankAccountComponent.PaypalTransactionInsert(transaction);

                string path = Path.Combine(HttpContext.Current.Server.MapPath("~/Template/"), "PaymentReceipt.html");
                string emailBody = File.ReadAllText(path);
                emailBody = string.Format(emailBody, HttpUtility.HtmlEncode(HttpUtility.UrlDecode(paymentProcess.CommunityName)), paymentProcess.Amount, paymentProcess.Currency, transaction.TransactionID, transaction.Status, transaction.ResponseMessage, "Credit Card");

                EmailDispatcher emailDispatcher = new EmailDispatcher();
                emailDispatcher.SendEmail("FromEmail", paymentProcess.Email, ApplicationName + " - Payment Receipt", emailBody, true);

                return transaction;
            }
            catch (Exception ex)
            {
                LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
        }

        #endregion
    }

}