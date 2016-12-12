using System;
using System.Data;
using System.Data.Common;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

using Microsoft.Practices.EnterpriseLibrary.Data;
using RatingReviewEngine.Entities;
using RatingReviewEngine.Entities.ServiceResponse;
using System.Web;

namespace RatingReviewEngine.DAC
{
    public class OwnerDAC : DataAccessComponent
    {
        Database objDb = DatabaseFactory.CreateDatabase(CONNECTION_NAME);

        /// <summary>
        /// Create a new community owner record with the supplied details (Owner)
        /// Associate the newly created Owner record (Owner.OwnerID) with the supplied OAuth Account (OAuthAccount.OAuthAccountID) (EntityOAuthAccount)
        /// </summary>
        /// <param name="owner"></param>
        /// <returns></returns>
        public int RegisterNewCommunityOwner(Owner owner)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("RegisterNewCommunityOwner"))
            {
                objDb.AddInParameter(cmd, "IN_OAuthAccountID", DbType.Int32, owner.OAuthAccountID);
                objDb.AddInParameter(cmd, "IN_CompanyName", DbType.String, HttpUtility.UrlDecode(owner.CompanyName));
                objDb.AddInParameter(cmd, "IN_Email", DbType.String, owner.Email);
                objDb.AddInParameter(cmd, "IN_BusinessNumber", DbType.String, HttpUtility.UrlDecode(owner.BusinessNumber));
                objDb.AddInParameter(cmd, "IN_PreferredPaymentCurrencyID", DbType.Int32, owner.PreferredPaymentCurrencyID);
                objDb.AddInParameter(cmd, "IN_PrimaryPhone", DbType.String, HttpUtility.UrlDecode(owner.PrimaryPhone));
                objDb.AddInParameter(cmd, "IN_OtherPhone", DbType.String, HttpUtility.UrlDecode(owner.OtherPhone));
                objDb.AddInParameter(cmd, "IN_DateAdded", DbType.DateTime, owner.DateAdded);
                objDb.AddInParameter(cmd, "IN_Website", DbType.String, HttpUtility.UrlDecode(owner.Website));
                objDb.AddInParameter(cmd, "IN_AddressLine1", DbType.String, HttpUtility.UrlDecode(owner.AddressLine1));
                objDb.AddInParameter(cmd, "IN_AddressLine2", DbType.String, HttpUtility.UrlDecode(owner.AddressLine2));
                objDb.AddInParameter(cmd, "IN_AddressCity", DbType.String, HttpUtility.UrlDecode(owner.AddressCity));
                objDb.AddInParameter(cmd, "IN_AddressState", DbType.String, HttpUtility.UrlDecode(owner.AddressState));
                objDb.AddInParameter(cmd, "IN_AddressPostalCode", DbType.String, HttpUtility.UrlDecode(owner.AddressPostalCode));
                objDb.AddInParameter(cmd, "IN_AddressCountryID", DbType.Int32, owner.AddressCountryID == -1 ? null : owner.AddressCountryID);
                objDb.AddInParameter(cmd, "IN_BillingName", DbType.String, HttpUtility.UrlDecode(owner.BillingName));
                objDb.AddInParameter(cmd, "IN_BillingAddressLine1", DbType.String, HttpUtility.UrlDecode(owner.BillingAddressLine1));
                objDb.AddInParameter(cmd, "IN_BillingAddressLine2", DbType.String, HttpUtility.UrlDecode(owner.BillingAddressLine2));
                objDb.AddInParameter(cmd, "IN_BillingAddressCity", DbType.String, HttpUtility.UrlDecode(owner.BillingAddressCity));
                objDb.AddInParameter(cmd, "IN_BillingAddressState", DbType.String, HttpUtility.UrlDecode(owner.BillingAddressState));
                objDb.AddInParameter(cmd, "IN_BillingAddressPostalCode", DbType.String, HttpUtility.UrlDecode(owner.BillingAddressPostalCode));
                objDb.AddInParameter(cmd, "IN_BillingAddressCountryID", DbType.String, owner.BillingAddressCountryID == -1 ? null : owner.BillingAddressCountryID);

                return Convert.ToInt32(objDb.ExecuteScalar(cmd));
            }
        }

        /// <summary>
        /// Update the details of an existing community owner record (Owner.OwnerID) with the supplied details.
        /// </summary>
        /// <param name="owner"></param>
        public void OwnerUpdate(Owner owner)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("OwnerUpdate"))
            {
                objDb.AddInParameter(cmd, "IN_OwnerID", DbType.Int32, owner.OwnerID);
                objDb.AddInParameter(cmd, "IN_CompanyName", DbType.String, HttpUtility.UrlDecode(owner.CompanyName));
                objDb.AddInParameter(cmd, "IN_Email", DbType.String, owner.Email);
                objDb.AddInParameter(cmd, "IN_BusinessNumber", DbType.String, HttpUtility.UrlDecode(owner.BusinessNumber));
                objDb.AddInParameter(cmd, "IN_PreferredPaymentCurrencyID", DbType.Int32, owner.PreferredPaymentCurrencyID);
                objDb.AddInParameter(cmd, "IN_PrimaryPhone", DbType.String, HttpUtility.UrlDecode(owner.PrimaryPhone));
                objDb.AddInParameter(cmd, "IN_OtherPhone", DbType.String, HttpUtility.UrlDecode(owner.OtherPhone));
                objDb.AddInParameter(cmd, "IN_DateAdded", DbType.DateTime, owner.DateAdded);
                objDb.AddInParameter(cmd, "IN_Website", DbType.String, owner.Website);
                objDb.AddInParameter(cmd, "IN_AddressLine1", DbType.String, HttpUtility.UrlDecode(owner.AddressLine1));
                objDb.AddInParameter(cmd, "IN_AddressLine2", DbType.String, HttpUtility.UrlDecode(owner.AddressLine2));
                objDb.AddInParameter(cmd, "IN_AddressCity", DbType.String, HttpUtility.UrlDecode(owner.AddressCity));
                objDb.AddInParameter(cmd, "IN_AddressState", DbType.String, HttpUtility.UrlDecode(owner.AddressState));
                objDb.AddInParameter(cmd, "IN_AddressPostalCode", DbType.String, HttpUtility.UrlDecode(owner.AddressPostalCode));
                objDb.AddInParameter(cmd, "IN_AddressCountryID", DbType.Int32, owner.AddressCountryID == -1 ? null : owner.AddressCountryID);
                objDb.AddInParameter(cmd, "IN_BillingName", DbType.String, HttpUtility.UrlDecode(owner.BillingName));
                objDb.AddInParameter(cmd, "IN_BillingAddressLine1", DbType.String, HttpUtility.UrlDecode(owner.BillingAddressLine1));
                objDb.AddInParameter(cmd, "IN_BillingAddressLine2", DbType.String, HttpUtility.UrlDecode(owner.BillingAddressLine2));
                objDb.AddInParameter(cmd, "IN_BillingAddressCity", DbType.String, HttpUtility.UrlDecode(owner.BillingAddressCity));
                objDb.AddInParameter(cmd, "IN_BillingAddressState", DbType.String, HttpUtility.UrlDecode(owner.BillingAddressState));
                objDb.AddInParameter(cmd, "IN_BillingAddressPostalCode", DbType.String, HttpUtility.UrlDecode(owner.BillingAddressPostalCode));
                objDb.AddInParameter(cmd, "IN_BillingAddressCountryID", DbType.String, owner.BillingAddressCountryID == -1 ? null : owner.BillingAddressCountryID);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Get Owner information based on OwnerId 
        /// </summary>
        /// <param name="ownerId"></param>
        /// <returns></returns>
        public Owner OwnerSelect(int ownerId)
        {
            Owner owner = new Owner();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("OwnerSelect"))
            {
                objDb.AddInParameter(cmd, "IN_OwnerID", DbType.Int32, ownerId);
                using (IDataReader drOwner = objDb.ExecuteReader(cmd))
                {
                    while (drOwner.Read())
                    {
                        owner.OwnerID = Convert.ToInt32(drOwner["OwnerID"].ToString());
                        owner.CompanyName = drOwner["CompanyName"].ToString();
                        owner.Email = drOwner["Email"].ToString();
                        owner.BusinessNumber = drOwner["BusinessNumber"].ToString();
                        owner.PreferredPaymentCurrencyID = Convert.ToInt32(drOwner["PreferredPaymentCurrencyID"].ToString());
                        owner.PrimaryPhone = drOwner["PrimaryPhone"].ToString();
                        owner.OtherPhone = drOwner["OtherPhone"].ToString();
                        owner.DateAdded = Convert.ToDateTime(drOwner["DateAdded"]);
                        owner.Website = drOwner["Website"].ToString();
                        owner.AddressLine1 = drOwner["AddressLine1"].ToString();
                        owner.AddressLine2 = drOwner["AddressLine2"].ToString();
                        owner.AddressCity = drOwner["AddressCity"].ToString();
                        owner.AddressState = drOwner["AddressState"].ToString();
                        owner.AddressPostalCode = drOwner["AddressPostalCode"].ToString();
                        if (drOwner["AddressCountryID"] != DBNull.Value)
                            owner.AddressCountryID = Convert.ToInt32(drOwner["AddressCountryID"].ToString());
                        owner.BillingName = drOwner["BillingName"].ToString();
                        owner.BillingAddressLine1 = drOwner["BillingAddressLine1"].ToString();
                        owner.BillingAddressLine2 = drOwner["BillingAddressLine2"].ToString();
                        owner.BillingAddressCity = drOwner["BillingAddressCity"].ToString();
                        owner.BillingAddressState = drOwner["BillingAddressState"].ToString();
                        owner.BillingAddressPostalCode = drOwner["BillingAddressPostalCode"].ToString();
                        if (drOwner["BillingAddressCountryID"] != DBNull.Value)
                            owner.BillingAddressCountryID = Convert.ToInt32(drOwner["BillingAddressCountryID"].ToString());

                        owner.AddressCountryName = drOwner["AddressCountryName"].ToString();
                        owner.BillingAddressCountryName = drOwner["BillingAddressCountryName"].ToString();
                    }
                }
            }

            return owner;
        }

        /// <summary>
        /// Delete Owner information (Unit test purpose)
        /// </summary>
        /// <param name="ownerId"></param>
        public void OwnerDelete(int ownerId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("UT_OWNERDELETE"))
            {
                objDb.AddInParameter(cmd, "IN_OwnerID", DbType.Int32, ownerId);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        ///1. Save the given Application details (ApplicationAuthentication)
        ///2. Generate a new API Token and update the application record to save the token (ApplicationAuthentication.APIToken & ApplicationAuthentication.TokenGenerated)
        ///3. Activate the API Token (ApplicationAuthentication.IsActive = true)
        /// </summary>
        /// <param name="applicationAuthentication"></param>
        public ApplicationAuthentication APITokenActivate(ApplicationAuthentication applicationAuthentication)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("ApiTokenActivate"))
            {
                objDb.AddInParameter(cmd, "in_applicationid", DbType.Int32, applicationAuthentication.ApplicationID);
                objDb.AddInParameter(cmd, "in_apitoken", DbType.String, applicationAuthentication.APIToken);

                using (IDataReader drApplicationAuthentication = objDb.ExecuteReader(cmd))
                {
                    while (drApplicationAuthentication.Read())
                    {
                        applicationAuthentication.ApplicationID = Convert.ToInt32(drApplicationAuthentication["applicationid"].ToString());
                        applicationAuthentication.ApplicationName = drApplicationAuthentication["applicationname"].ToString();
                        applicationAuthentication.APIToken = drApplicationAuthentication["apitoken"].ToString();
                        applicationAuthentication.RegisteredEmail = drApplicationAuthentication["RegisteredEmail"].ToString();

                    }
                }

                return applicationAuthentication;
            }
        }

        /// <summary>
        /// Update the application record and deactivate the API Token associated to the registered application (ApplicationAuthentication.IsActive = false)
        /// </summary>
        /// <param name="nApplicationID"></param>
        public ApplicationAuthentication APITokenDeactivate(int applicationID)
        {
            DbCommand cmd;
            ApplicationAuthentication applicationAuthentication = new ApplicationAuthentication();
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("ApiTokenDeactivate"))
            {
                objDb.AddInParameter(cmd, "IN_ApplicationID", DbType.Int32, applicationID);
                using (IDataReader drApplicationAuthentication = objDb.ExecuteReader(cmd))
                {
                    while (drApplicationAuthentication.Read())
                    {
                        applicationAuthentication.ApplicationID = Convert.ToInt32(drApplicationAuthentication["applicationid"].ToString());
                        applicationAuthentication.ApplicationName = drApplicationAuthentication["applicationname"].ToString();
                        applicationAuthentication.APIToken = drApplicationAuthentication["apitoken"].ToString();
                        applicationAuthentication.RegisteredEmail = drApplicationAuthentication["RegisteredEmail"].ToString();
                        
                    }
                }
            
            }
            return applicationAuthentication;
        }

        /// <summary>
        /// Insert application record in ApplicationAuthentication table.
        /// </summary>
        /// <param name="applicationAuthentication"></param>
        public void ApplicationInsert(ApplicationAuthentication applicationAuthentication)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("ApplicationInsert"))
            {
                objDb.AddInParameter(cmd, "IN_ApplicationName", DbType.String,HttpUtility.UrlDecode(applicationAuthentication.ApplicationName));
                objDb.AddInParameter(cmd, "IN_RegisteredEmail", DbType.String, applicationAuthentication.RegisteredEmail);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, applicationAuthentication.CommunityID);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// 1. Generate a new API Token and update the application record to save the token (ApplicationAuthentication.APIToken & ApplicationAuthentication.TokenGenerated)
        /// 2. Activate the API Token (ApplicationAuthentication.IsActive = true)
        /// </summary>
        /// <param name="applicationAuthentication"></param>
        public ApplicationAuthentication APITokenReset(ApplicationAuthentication applicationAuthentication)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("APITokenReset"))
            {
                objDb.AddInParameter(cmd, "IN_ApplicationID", DbType.Int32, applicationAuthentication.ApplicationID);
                objDb.AddInParameter(cmd, "IN_APIToken", DbType.String, applicationAuthentication.APIToken);
                objDb.AddInParameter(cmd, "IN_TokenGenerated", DbType.DateTime, applicationAuthentication.TokenGenerated);

                using (IDataReader drApplicationAuthentication = objDb.ExecuteReader(cmd))
                {
                    while (drApplicationAuthentication.Read())
                    {
                        applicationAuthentication.RegisteredEmail = drApplicationAuthentication["RegisteredEmail"].ToString();
                        applicationAuthentication.ApplicationName = drApplicationAuthentication["ApplicationName"].ToString();
                    }
                }
            }

            return applicationAuthentication;
        }

        public ApplicationAuthentication APITokenResend(ApplicationAuthentication applicationAuthentication)
        { 
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("APITokenResend"))
            {
                objDb.AddInParameter(cmd, "IN_ApplicationID", DbType.Int32, applicationAuthentication.ApplicationID);

                using (IDataReader drApplicationAuthentication = objDb.ExecuteReader(cmd))
                {
                    while (drApplicationAuthentication.Read())
                    {
                        applicationAuthentication.RegisteredEmail = drApplicationAuthentication["RegisteredEmail"].ToString();
                        applicationAuthentication.ApplicationName = drApplicationAuthentication["ApplicationName"].ToString();
                    }
                }
            }

            return applicationAuthentication;
        }

        /// <summary>
        /// Check Owner email is already exist. If exist return 1 else return 0.
        /// For new record pass ownerID as 0
        /// </summary>
        /// <param name="ownerEmail"></param>
        /// <returns></returns>
        public string CheckOwnerEmailExist(int ownerId, string email)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CheckOwnerEmailExist"))
            {
                objDb.AddInParameter(cmd, "IN_OwnerID", DbType.Int32, ownerId);
                objDb.AddInParameter(cmd, "IN_Email", DbType.String, email);
                return (objDb.ExecuteScalar(cmd)).ToString();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="searchText"></param>
        /// <param name="communityId"></param>
        /// <param name="communityGroupId"></param>
        /// <param name="rowIndex"></param>
        /// <param name="rowCount"></param>
        /// <returns></returns>
        public List<CustomerTransactionResponse> CustomerTransactionSearch(string searchText, int ownerId, int communityId, int communityGroupId, int rowIndex, int rowCount)
        {
            CustomerTransactionResponse customerTransactionResponse;
            List<CustomerTransactionResponse> lstCustomerTransactionResponse = new List<CustomerTransactionResponse>();
            CommunityTransaction communityTransaction;
            CommunityGroupTransaction communityGroupTransaction;
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CustomerTransactionSearch"))
            {
                objDb.AddInParameter(cmd, "in_ownerid", DbType.Int32, ownerId);
                objDb.AddInParameter(cmd, "in_search", DbType.String, searchText);
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, communityId);
                objDb.AddInParameter(cmd, "in_communitygroupid", DbType.Int32, communityGroupId);
                objDb.AddInParameter(cmd, "in_rowindex", DbType.Int32, rowIndex);
                objDb.AddInParameter(cmd, "in_rowcount", DbType.Int32, rowCount);

                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    dataSet.Tables[0].TableName = "Customer";
                    dataSet.Tables[1].TableName = "TotalRecords";
                    dataSet.Tables[2].TableName = "Community";
                    dataSet.Tables[3].TableName = "CommunityGroup";

                    foreach (DataRow drCustomer in dataSet.Tables["Customer"].Rows)
                    {
                        customerTransactionResponse = new CustomerTransactionResponse();
                        customerTransactionResponse.CustomerID = Convert.ToInt32(drCustomer["customerid"]);
                        customerTransactionResponse.FirstName = drCustomer["Firstname"].ToString();
                        customerTransactionResponse.LastName = drCustomer["lastname"].ToString();
                        customerTransactionResponse.Handle = drCustomer["Handle"].ToString();
                        customerTransactionResponse.TotalRevenue = Convert.ToDecimal(drCustomer["totalrevenue"]);
                        customerTransactionResponse.TotalSpend = Convert.ToDecimal(drCustomer["totalspend"]);
                        customerTransactionResponse.CurrencyID = Convert.ToInt32(drCustomer["CurrencyID"]);
                        customerTransactionResponse.CurrencyName = drCustomer["CurrencyName"].ToString();
                        customerTransactionResponse.TotalRecords = Convert.ToInt32(dataSet.Tables["TotalRecords"].Rows[0]["TotalRecords"].ToString());

                        DataTable dtCommunity = dataSet.Tables["Community"];
                        IEnumerable<DataRow> result = from A in dtCommunity.AsEnumerable() select A;
                        IEnumerable<DataRow> communityResult = result.Where(A => A.Field<int>("customerid") == customerTransactionResponse.CustomerID);

                        customerTransactionResponse.lstCommunityTransaction = new List<CommunityTransaction>();
                        foreach (var community in communityResult)
                        {
                            communityTransaction = new CommunityTransaction();
                            communityTransaction.CustomerID = community.Field<int>("customerid");
                            communityTransaction.FirstName = community.Field<string>("Firstname");
                            communityTransaction.LastName = community.Field<string>("lastname");
                            communityTransaction.Handle = community.Field<string>("handle");
                            communityTransaction.CommunityName = community.Field<string>("Communityname");
                            communityTransaction.CommunityID = community.Field<int>("communityid");
                            communityTransaction.ReviewCount = community.Field<Int64>("reviewcount");
                            communityTransaction.TotalRevenue = community.Field<decimal>("totalrevenue");
                            communityTransaction.TotalSpend = community.Field<decimal>("totalspend");
                            communityTransaction.CurrencyID = community.Field<int>("CurrencyID");
                            communityTransaction.CurrencyName = community.Field<string>("CurrencyName");

                            DataTable dtCommunityGroup = dataSet.Tables["CommunityGroup"];
                            IEnumerable<DataRow> query = from A in dtCommunityGroup.AsEnumerable() select A;
                            IEnumerable<DataRow> communityGroupResult = query.Where(A => A.Field<int>("customerid") == customerTransactionResponse.CustomerID && A.Field<int>("communityid") == communityTransaction.CommunityID);

                            communityTransaction.lstCommunityGroupTransaction = new List<CommunityGroupTransaction>();
                            foreach (var communityGroup in communityGroupResult)
                            {
                                communityGroupTransaction = new CommunityGroupTransaction();
                                communityGroupTransaction.CustomerID = communityGroup.Field<int>("customerid");
                                communityGroupTransaction.FirstName = communityGroup.Field<string>("Firstname");
                                communityGroupTransaction.LastName = communityGroup.Field<string>("lastname");
                                communityGroupTransaction.Handle = communityGroup.Field<string>("Handle");
                                communityGroupTransaction.CommunityName = communityGroup.Field<string>("Communityname");
                                communityGroupTransaction.CommunityID = communityGroup.Field<int>("communityid");
                                communityGroupTransaction.ReviewCount = communityGroup.Field<Int64>("reviewcount");
                                communityGroupTransaction.TotalRevenue = communityGroup.Field<decimal>("totalrevenue");
                                communityGroupTransaction.TotalSpend = communityGroup.Field<decimal>("totalspend");
                                communityGroupTransaction.CommunityGroupName = communityGroup.Field<string>("Communitygroupname");
                                communityGroupTransaction.CommunityGroupID = communityGroup.Field<int>("communitygroupid");
                                communityGroupTransaction.ViewsCount = communityGroup.Field<Int64>("viewscount");
                                communityGroupTransaction.CurrencyID = community.Field<int>("CurrencyID");
                                communityGroupTransaction.CurrencyName = community.Field<string>("CurrencyName");

                                communityTransaction.lstCommunityGroupTransaction.Add(communityGroupTransaction);
                            }

                            customerTransactionResponse.lstCommunityTransaction.Add(communityTransaction);
                        }

                        lstCustomerTransactionResponse.Add(customerTransactionResponse);
                    }
                }
            }

            return lstCustomerTransactionResponse;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplierName"></param>
        /// <param name="ownerId"></param>
        /// <param name="communityId"></param>
        /// <param name="communityGroupId"></param>
        /// <param name="categoryId"></param>
        /// <returns></returns>
        public List<SupplierTransactionResponse> SupplierTransactionSearch(string supplierName, int ownerId, int communityId, int communityGroupId, int categoryId, int rowIndex, int rowCount)
        {
            SupplierTransactionResponse supplierTransactionResponse;
            List<SupplierTransactionResponse> lstSupplierTransactionResponse = new List<SupplierTransactionResponse>();
            SupplierCommunityTransaction supplierCommunityTransaction;
            SupplierCommunityGroupTransaction supplierCommunityGroupTransaction;
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierTransactionSearch"))
            {
                objDb.AddInParameter(cmd, "in_ownerid", DbType.Int32, ownerId);
                objDb.AddInParameter(cmd, "in_suppliername", DbType.String, HttpUtility.UrlDecode(supplierName));
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, communityId);
                objDb.AddInParameter(cmd, "in_communitygroupid", DbType.Int32, communityGroupId);
                objDb.AddInParameter(cmd, "in_category", DbType.Int32, categoryId);
                objDb.AddInParameter(cmd, "in_rowindex", DbType.Int32, rowIndex);
                objDb.AddInParameter(cmd, "in_rowcount", DbType.Int32, rowCount);

                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    dataSet.Tables[0].TableName = "Supplier";
                    dataSet.Tables[1].TableName = "TotalRecords";
                    dataSet.Tables[2].TableName = "Community";
                    dataSet.Tables[3].TableName = "CommunityGroup";

                    foreach (DataRow drSupplier in dataSet.Tables["Supplier"].Rows)
                    {
                        supplierTransactionResponse = new SupplierTransactionResponse();
                        supplierTransactionResponse.SupplierID = Convert.ToInt32(drSupplier["supplierid"]);
                        supplierTransactionResponse.SupplierName = drSupplier["companyname"].ToString();
                        supplierTransactionResponse.AverageRating = Convert.ToDecimal(drSupplier["avgRating"]);
                        supplierTransactionResponse.ReviewCount = Convert.ToInt64(drSupplier["reviewcount"]);
                        supplierTransactionResponse.TotalRevenue = Convert.ToDecimal(drSupplier["totalrevenue"]);
                        supplierTransactionResponse.TotalIncome = Convert.ToDecimal(drSupplier["totalincome"]);
                        supplierTransactionResponse.CurrencyID = Convert.ToInt32(drSupplier["CurrencyID"]);
                        supplierTransactionResponse.CurrencyName = drSupplier["CurrencyName"].ToString();
                        supplierTransactionResponse.TotalRecords = Convert.ToInt32(dataSet.Tables["TotalRecords"].Rows[0]["TotalRecords"].ToString());

                        DataTable dtCommunity = dataSet.Tables["Community"];
                        IEnumerable<DataRow> result = from A in dtCommunity.AsEnumerable() select A;
                        IEnumerable<DataRow> communityResult = result.Where(A => A.Field<int>("supplierid") == supplierTransactionResponse.SupplierID &&  A.Field<int>("currencyid") == supplierTransactionResponse.CurrencyID);

                        supplierTransactionResponse.lstSupplierCommunityTransaction = new List<SupplierCommunityTransaction>();
                        foreach (var community in communityResult)
                        {
                            supplierCommunityTransaction = new SupplierCommunityTransaction();
                            supplierCommunityTransaction.SupplierID = community.Field<int>("supplierid");
                            supplierCommunityTransaction.CommunityID = community.Field<int>("communityid");
                            supplierCommunityTransaction.CommunityName = community.Field<string>("communityname");
                            supplierCommunityTransaction.Credit = community.Field<decimal>("credit");
                            supplierCommunityTransaction.TotalRevenue = community.Field<decimal>("totalrevenue");
                            supplierCommunityTransaction.TotalIncome = community.Field<decimal>("totalincome");
                            supplierCommunityTransaction.CurrencyID = community.Field<int>("CurrencyID");
                            supplierCommunityTransaction.CurrencyName = community.Field<string>("CurrencyName");

                            DataTable dtCommunityGroup = dataSet.Tables["CommunityGroup"];
                            IEnumerable<DataRow> query = from A in dtCommunityGroup.AsEnumerable() select A;
                            IEnumerable<DataRow> communityGroupResult = query.Where(A => A.Field<int>("supplierid") == supplierTransactionResponse.SupplierID && A.Field<int>("communityid") == supplierCommunityTransaction.CommunityID);

                            supplierCommunityTransaction.lstSupplierCommunityGroupTransaction = new List<SupplierCommunityGroupTransaction>();
                            foreach (var communityGroup in communityGroupResult)
                            {
                                supplierCommunityGroupTransaction = new SupplierCommunityGroupTransaction();
                                supplierCommunityGroupTransaction.SupplierID = communityGroup.Field<int>("supplierid");
                                supplierCommunityGroupTransaction.CommunityID = communityGroup.Field<int>("communityid");
                                supplierCommunityGroupTransaction.CommunityGroupID = communityGroup.Field<int>("communitygroupid");
                                supplierCommunityGroupTransaction.CommunityGroupName = communityGroup.Field<string>("communitygroupname");
                                supplierCommunityGroupTransaction.AverageRating = communityGroup.Field<decimal>("avgrating");
                                supplierCommunityGroupTransaction.ReviewCount = communityGroup.Field<Int64>("reviewcount");
                                supplierCommunityGroupTransaction.TotalRevenue = communityGroup.Field<decimal>("totalrevenue");
                                supplierCommunityGroupTransaction.TotalIncome = communityGroup.Field<decimal>("totalincome");
                                supplierCommunityGroupTransaction.ViewsCount = communityGroup.Field<Int64>("viewscount");
                                supplierCommunityGroupTransaction.TotalTransaction = communityGroup.Field<Int64>("totaltransaction");
                                supplierCommunityGroupTransaction.CurrencyID = community.Field<int>("CurrencyID");
                                supplierCommunityGroupTransaction.CurrencyName = community.Field<string>("CurrencyName");

                                supplierCommunityTransaction.lstSupplierCommunityGroupTransaction.Add(supplierCommunityGroupTransaction);
                            }

                            supplierTransactionResponse.lstSupplierCommunityTransaction.Add(supplierCommunityTransaction);
                        }

                        lstSupplierTransactionResponse.Add(supplierTransactionResponse);
                    }
                }
            }

            return lstSupplierTransactionResponse;
        }

        /// <summary>
        /// Retrieves list of CommunityID and Name for a particular owner.
        /// </summary>
        /// <param name="ownerId"></param>
        /// <returns></returns>
        public List<MenuItem> CommunityListMenu(int ownerId)
        {
            List<MenuItem> lstMenuItem = new List<MenuItem>();
            MenuItem menuItem;
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("communityselectbyowner"))
            {
                objDb.AddInParameter(cmd, "IN_ownerid", DbType.Int32, ownerId);
                using (IDataReader drCommunity = objDb.ExecuteReader(cmd))
                {
                    while (drCommunity.Read())
                    {
                        menuItem = new MenuItem();
                        menuItem.text = drCommunity["Name"].ToString();
                        menuItem.url = "OwnerCommunityDetail.aspx?cid=" + CommonDAC.EncryptIt(drCommunity["CommunityID"].ToString());
                        menuItem.id = drCommunity["CommunityID"].ToString();
                        lstMenuItem.Add(menuItem);
                    }
                }
            }

            return lstMenuItem;
        }

        /// <summary>
        /// The current virtual account balance for the community owner as associated to the relevant community and community currency.
        /// </summary>
        /// <param name="ownerId"></param>
        /// <returns></returns>
        public List<CommunityOwnerTransactionHistory> OwnerAccountSummary(int ownerId)
        {
            CommunityOwnerTransactionHistory communityOwnerTransactionHistory;
            List<CommunityOwnerTransactionHistory> lstCommunityOwnerTransactionHistory = new List<CommunityOwnerTransactionHistory>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("OwnerAccountSummary"))
            {
                objDb.AddInParameter(cmd, "in_ownerid", DbType.Int32, ownerId);
                using (IDataReader drAccount = objDb.ExecuteReader(cmd))
                {
                    while (drAccount.Read())
                    {
                        communityOwnerTransactionHistory = new CommunityOwnerTransactionHistory();
                        communityOwnerTransactionHistory.CommunityID = Convert.ToInt32(drAccount["CommunityID"].ToString());
                        communityOwnerTransactionHistory.CommunityName = drAccount["CommunityName"].ToString();
                        communityOwnerTransactionHistory.Balance = Convert.ToDecimal(drAccount["Balance"].ToString());
                        communityOwnerTransactionHistory.DateApplied = CommonDAC.MYSQLDateTime();
                        communityOwnerTransactionHistory.CurrencyID = Convert.ToInt32(drAccount["CurrencyID"]);
                        communityOwnerTransactionHistory.CurrencyName = drAccount["CurrencyName"].ToString();
                        lstCommunityOwnerTransactionHistory.Add(communityOwnerTransactionHistory);
                    }
                }
            }

            return lstCommunityOwnerTransactionHistory;
        }




        /// <summary>
        ///  Retrives owner transaction details based on the input parameters.
        /// </summary>
        /// <param name="communityOwnerTransactionHistory"></param>
        /// <returns></returns>
        public List<CommunityOwnerTransactionHistory> CommunityOwnerTransactionSelect(CommunityOwnerTransactionHistory communityOwnerTransactionHistory)
        {
            List<CommunityOwnerTransactionHistory> lstCommunityOwnerTransactionHistory = new List<CommunityOwnerTransactionHistory>();
            DbCommand cmd;
            DateTime? date = null;
            Common common = new Common();
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityOwnerTransactionSelect"))
            {
                objDb.AddInParameter(cmd, "in_ownerid", DbType.Int32, communityOwnerTransactionHistory.OwnerID);
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, communityOwnerTransactionHistory.CommunityID);
                objDb.AddInParameter(cmd, "in_communitygroupid", DbType.Int32, communityOwnerTransactionHistory.CommunityGroupID);
                objDb.AddInParameter(cmd, "in_fromdate", DbType.DateTime, communityOwnerTransactionHistory.FromDate == "null" ? date : common.ParseDate(communityOwnerTransactionHistory.FromDate, "dd/MM/yyyy"));
                objDb.AddInParameter(cmd, "in_todate", DbType.DateTime, communityOwnerTransactionHistory.ToDate == "null" ? date : common.ParseDate(communityOwnerTransactionHistory.ToDate, "dd/MM/yyyy"));
                objDb.AddInParameter(cmd, "in_rowindex", DbType.Int32, communityOwnerTransactionHistory.RowIndex);
                objDb.AddInParameter(cmd, "in_rowcount", DbType.Int32, communityOwnerTransactionHistory.RowCount);
                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    dataSet.Tables[0].TableName = "SupplierCommunity";
                    dataSet.Tables[1].TableName = "TotalRecords";

                    foreach (DataRow drSupplierCommunity in dataSet.Tables["SupplierCommunity"].Rows)
                    {
                        communityOwnerTransactionHistory = new CommunityOwnerTransactionHistory();
                        communityOwnerTransactionHistory.Description = drSupplierCommunity["description"].ToString();
                        communityOwnerTransactionHistory.CommunityName = drSupplierCommunity["communityname"].ToString();
                        communityOwnerTransactionHistory.CommunityGroupName = drSupplierCommunity["communitygroupname"].ToString();
                        communityOwnerTransactionHistory.SupplierName = drSupplierCommunity["suppliername"].ToString();
                        communityOwnerTransactionHistory.CustomerName = drSupplierCommunity["customername"].ToString();
                        communityOwnerTransactionHistory.DateApplied = Convert.ToDateTime(drSupplierCommunity["dateapplied"]);
                        communityOwnerTransactionHistory.Amount = Convert.ToDecimal(drSupplierCommunity["amount"]);
                        communityOwnerTransactionHistory.CurrencyID = Convert.ToInt32(drSupplierCommunity["CurrencyID"]);
                        communityOwnerTransactionHistory.CurrencyName = drSupplierCommunity["CurrencyName"].ToString();
                        communityOwnerTransactionHistory.TotalRecords = Convert.ToInt32(dataSet.Tables["TotalRecords"].Rows[0]["TotalRecords"].ToString());
                        lstCommunityOwnerTransactionHistory.Add(communityOwnerTransactionHistory);
                    }
                }
            }

            return lstCommunityOwnerTransactionHistory;
        }

        /// <summary>
        /// Checks application name is already exist. If exist return 1 else return 0.
        /// </summary>
        /// <param name="applicationName"></param>
        /// <returns></returns>
        public string CheckApplicationExist(string applicationName)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CheckApplicationExist"))
            {
                objDb.AddInParameter(cmd, "in_applicationname", DbType.String, applicationName);
                return (objDb.ExecuteScalar(cmd)).ToString();
            }
        }

        /// <summary>
        /// The owner current Virtual Community Account balance for the given community.
        /// </summary>
        /// <param name="ownerId"></param>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public decimal OwnerAccountBalanceByCommunity(int ownerId, int communityId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("owneraccountbalancebycommunity"))
            {
                objDb.AddInParameter(cmd, "in_ownerid", DbType.Int32, ownerId);
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, communityId);
                return Convert.ToDecimal(objDb.ExecuteScalar(cmd));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<Owner> OwnerSelectAll()
        {
            List<Owner> lstOwner = new List<Owner>();
            Owner owner;
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("ownerselectall"))
            {
                
                using (IDataReader drOwner = objDb.ExecuteReader(cmd))
                {
                    while (drOwner.Read())
                    {
                        owner = new Owner();
                        owner.OwnerID = Convert.ToInt32(drOwner["OwnerID"].ToString());
                        owner.CompanyName = drOwner["CompanyName"].ToString();
                        owner.Email = drOwner["Email"].ToString();
                        owner.DateAdded = DateTime.Now;//Dummy value added for API call

                        lstOwner.Add(owner);
                    }
                }
            }
            return lstOwner;
        }
    }
}
