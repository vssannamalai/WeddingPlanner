using Microsoft.Practices.EnterpriseLibrary.Data;
using RatingReviewEngine.Entities;
using RatingReviewEngine.Entities.ServiceRequest;
using RatingReviewEngine.Entities.ServiceResponse;
using System;
using System.Data;
using System.Data.Common;

namespace RatingReviewEngine.DAC
{
    public class UserDAC : DataAccessComponent
    {
        Database objDb = DatabaseFactory.CreateDatabase(CONNECTION_NAME);
        
        public AccountActivationResponse AccountActivate(string providerUserId)
        {
            DbCommand cmd;
            AccountActivationResponse activationResponse = new AccountActivationResponse();

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("AccountActivate"))
            {
                objDb.AddInParameter(cmd, "IN_ProviderUserId", DbType.String, providerUserId);
              
                using (IDataReader drLoginResponse = objDb.ExecuteReader(cmd))
                {
                    while (drLoginResponse.Read())
                    {
                        activationResponse.ActivationMessage = drLoginResponse["Result"].ToString();

                        //if (activationResponse.ActivationMessage == "valid")
                        //{
                        //    activationResponse.ActivationMessage = "Your account has been activated. Please login to continue.";
                        //}
                        //else {
                        //    activationResponse.ActivationMessage = "Sorry, There is no account registered for your email.";
                        //}
                    }
                }
            }

            return activationResponse;
        }

        /// <summary>
        /// Validate the login details against existing active registered account
        /// </summary>
        /// <param name="loginRequest"></param>
        /// <returns></returns>
        public LoginResponse ValidateAccount(LoginRequest loginRequest)
        {
            DbCommand cmd;
            LoginResponse loginResponse = new LoginResponse();

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("ValidateAccount"))
            {
                objDb.AddInParameter(cmd, "OAuthProvider", DbType.String, loginRequest.Provider);
                objDb.AddInParameter(cmd, "OAuthUserID", DbType.String, loginRequest.ProviderUserID);
                objDb.AddInParameter(cmd, "OAuthToken", DbType.String, loginRequest.Token);
                
                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    dataSet.Tables[0].TableName = "Entity";
                    

                    foreach (DataRow drLoginResponse in dataSet.Tables["Entity"].Rows)
                    {
                        loginResponse.strOut = drLoginResponse["Result"].ToString();
                        if (loginResponse.strOut == "valid")
                        {
                            loginResponse.OAuthAccountID = Convert.ToInt32(drLoginResponse["OAuthAccountID"]);
                            loginResponse.Active = Convert.ToBoolean(drLoginResponse["Active"].ToString() == "1" ? true : false);
                            loginResponse.UserName = drLoginResponse["provideruserid"].ToString();

                            switch (drLoginResponse["EntityType"].ToString().ToLower())
                            {
                                case "communityowner":
                                    loginResponse.IsCommunityOwner = true;
                                    loginResponse.CommunityOwnerID = Convert.ToInt32(drLoginResponse["EntityID"] == DBNull.Value ? 0 : drLoginResponse["EntityID"]);
                                    break;

                                case "supplier":
                                    loginResponse.IsSupplier = true;
                                    loginResponse.SupplierID = Convert.ToInt32(drLoginResponse["EntityID"] == DBNull.Value ? 0 : drLoginResponse["EntityID"]);
                                    break;

                                case "customer":
                                    loginResponse.IsCustomer = true;
                                    loginResponse.CustomerID = Convert.ToInt32(drLoginResponse["EntityID"] == DBNull.Value ? 0 : drLoginResponse["EntityID"]);
                                    break;
                            }
                        }
                    }

                    if (dataSet.Tables.Count > 1)
                    {
                        dataSet.Tables[1].TableName = "Admin";
                        loginResponse.IsAdministrator = Convert.ToBoolean(Convert.ToInt32(dataSet.Tables["Admin"].Rows[0]["Administrator"]));
                        loginResponse.AdministratorID = 0;
                    }
                    
                }
            }

            return loginResponse;
        }

        /// <summary>
        /// Create new account within the system based on the supplied details (OAuthAccount)
        /// </summary>
        /// <param name="oauthAccount"></param>
        public int RegisterNewAccount(OAuthAccount oauthAccount)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("RegisterNewAccount"))
            {
                objDb.AddInParameter(cmd, "IN_OAuthProvider", DbType.String, oauthAccount.Provider);
                objDb.AddInParameter(cmd, "IN_OAuthUserID", DbType.String, oauthAccount.ProviderUserID);
                objDb.AddInParameter(cmd, "IN_OAuthToken", DbType.String, oauthAccount.Token);
                return Convert.ToInt32(objDb.ExecuteScalar(cmd));
            }
        }

        /// <summary>
        /// Check Provider and UserID already Exist IF Exist return Valid ELSE Invalid
        /// </summary>
        /// <param name="oauthAccount"></param>
        /// <returns></returns>
        public string CheckValidUserID(OAuthAccount oauthAccount)
        {
            DbCommand cmd;
            string strOutput = string.Empty;

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CheckValidUserID"))
            {
                objDb.AddInParameter(cmd, "IN_OAuthProvider", DbType.String, oauthAccount.Provider);
                objDb.AddInParameter(cmd, "IN_OAuthUserID", DbType.String, oauthAccount.ProviderUserID);
                strOutput = objDb.ExecuteScalar(cmd).ToString();
            }

            return strOutput;
        }

        /// <summary>
        /// Change password
        /// </summary>
        /// <param name="oauthaccount"></param>
        public string OAuthAccountTokenUpdate(OAuthAccount oauthaccount)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("oauthaccounttokenupdate"))
            {
                objDb.AddInParameter(cmd, "in_provider", DbType.String, oauthaccount.Provider);
                objDb.AddInParameter(cmd, "in_provideruserid", DbType.String, oauthaccount.ProviderUserID);
                objDb.AddInParameter(cmd, "in_token", DbType.String, oauthaccount.Token);
              return  objDb.ExecuteScalar(cmd).ToString();
            }
        }
        /// <summary>
        /// Delete data from UserSecurity, EntityOAuthAccount and OAuthAccount tables. (Unit test purpose)
        /// </summary>
        /// <param name="oauthAccountId"></param>
        public void OAuthAccountDelete(int oauthAccountId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("UT_OAuthAccountDelete"))
            {
                objDb.AddInParameter(cmd, "in_oauthaccountid", DbType.Int32, oauthAccountId);
                objDb.ExecuteNonQuery(cmd);
            }
        }
    }
}
