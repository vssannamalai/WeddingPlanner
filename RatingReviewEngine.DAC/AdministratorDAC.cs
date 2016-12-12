using System;
using System.Data;
using System.Data.Common;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Microsoft.Practices.EnterpriseLibrary.Data;
using RatingReviewEngine.Entities;
using System.Web;

namespace RatingReviewEngine.DAC
{
    public class AdministratorDAC : DataAccessComponent
    {
        Database objDb = DatabaseFactory.CreateDatabase(CONNECTION_NAME);

        /// <summary>
        /// Create a new currency within the system from the supplied details (Currency)
        /// </summary>
        /// <param name="ISOCode"></param>
        /// <param name="Description"></param>
        /// <param name="MinTrasferAmount"></param>
        /// <param name="IsActive"></param>
        public int CurrencyInsert(Currency currency)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CurrencyInsert"))
            {
                objDb.AddInParameter(cmd, "IN_ISOCode", DbType.String, HttpUtility.UrlDecode(currency.ISOCode));
                objDb.AddInParameter(cmd, "IN_Description", DbType.String, HttpUtility.UrlDecode(currency.Description));
                objDb.AddInParameter(cmd, "IN_MinTransferAmount", DbType.Decimal, currency.MinTransferAmount);
                objDb.AddInParameter(cmd, "IN_IsActive", DbType.Boolean, currency.IsActive);
                return Convert.ToInt32(objDb.ExecuteScalar(cmd));
            }
        }

        /// <summary>
        /// Update an existing currency record from the supplied CurrencyID with the supplied details (Currency)
        /// </summary>
        /// <param name="CurrencyId"></param>
        /// <param name="ISOCode"></param>
        /// <param name="Description"></param>
        /// <param name="MinTrasferAmount"></param>
        /// <param name="IsActive"></param>
        public void CurrencyUpdate(Currency currency)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CurrencyUpdate"))
            {
                objDb.AddInParameter(cmd, "IN_CurrencyID", DbType.Int32, currency.CurrencyID);
                objDb.AddInParameter(cmd, "IN_ISOCode", DbType.String, currency.ISOCode);
                objDb.AddInParameter(cmd, "IN_Description", DbType.String, currency.Description);
                objDb.AddInParameter(cmd, "IN_MinTransferAmount", DbType.Decimal, currency.MinTransferAmount);
                objDb.AddInParameter(cmd, "IN_IsActive", DbType.Boolean, currency.IsActive);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Get all currency from Currency
        /// </summary>
        /// <returns></returns>
        public List<Currency> CurrencySelectAll()
        {
            Currency currency;
            List<Currency> lstCurrency = new List<Currency>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CURRENCYSELECTALL"))
            {
                using (IDataReader drCurrency = objDb.ExecuteReader(cmd))
                {
                    while (drCurrency.Read())
                    {
                        currency = new Currency();
                        currency.CurrencyID = Convert.ToInt32(drCurrency["CurrencyID"].ToString());
                        currency.ISOCode = drCurrency["ISOCode"].ToString();
                        currency.Description = drCurrency["Description"].ToString();
                        if (drCurrency["MinTransferAmount"] != DBNull.Value)
                            currency.MinTransferAmount = Convert.ToDecimal(drCurrency["MinTransferAmount"].ToString());
                        currency.IsActive = Convert.ToBoolean(drCurrency["IsActive"]);
                        lstCurrency.Add(currency);
                    }
                }
            }
            return lstCurrency;
        }

        /// <summary>
        /// Get all Active currency
        /// </summary>
        /// <returns></returns>
        public List<Currency> CurrencySelectActive()
        {
            Currency currency;
            List<Currency> lstCurrency = new List<Currency>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CURRENCYSELECTACTIVE"))
            {
                using (IDataReader drCurrency = objDb.ExecuteReader(cmd))
                {
                    while (drCurrency.Read())
                    {
                        currency = new Currency();
                        currency.CurrencyID = Convert.ToInt32(drCurrency["CurrencyID"].ToString());
                        currency.ISOCode = drCurrency["ISOCode"].ToString();
                        currency.Description = drCurrency["Description"].ToString();
                        if (drCurrency["MinTransferAmount"] != DBNull.Value)
                            currency.MinTransferAmount = Convert.ToDecimal(drCurrency["MinTransferAmount"].ToString());
                        currency.IsActive = Convert.ToBoolean(drCurrency["IsActive"]);
                        lstCurrency.Add(currency);
                    }
                }
            }
            return lstCurrency;
        }


        /// <summary>
        /// Get Owner currency
        /// </summary>
        /// <returns></returns>
        public List<Currency> CurrencySelectByOwner(int ownerId)
        {
            Currency currency;
            List<Currency> lstCurrency = new List<Currency>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("currencyselectbyowner"))
            {
                objDb.AddInParameter(cmd, "in_ownerid", DbType.Int32, ownerId);
                using (IDataReader drCurrency = objDb.ExecuteReader(cmd))
                {
                    while (drCurrency.Read())
                    {
                        currency = new Currency();
                        currency.CurrencyID = Convert.ToInt32(drCurrency["CurrencyID"].ToString());
                        currency.ISOCode = drCurrency["currencyname"].ToString();
                        lstCurrency.Add(currency);
                    }
                }
            }
            return lstCurrency;
        }

        /// <summary>
        /// Get Currency information based on CurrencyId (Created for Unit test purpose)
        /// </summary>
        /// <param name="CurrencyId"></param>
        /// <returns></returns>
        public Currency GetCurrency(int CurrencyId)
        {
            DbCommand cmd;
            Currency currency = new Currency();
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("UT_GETCURRENCY"))
            {
                objDb.AddInParameter(cmd, "IN_CurrencyID", DbType.Int32, CurrencyId);
                using (IDataReader drCurrency = objDb.ExecuteReader(cmd))
                {
                    while (drCurrency.Read())
                    {
                        currency.CurrencyID = Convert.ToInt32(drCurrency["CurrencyID"].ToString());
                        currency.ISOCode = drCurrency["ISOCode"].ToString();
                        currency.Description = drCurrency["Description"].ToString();
                        if (drCurrency["MinTransferAmount"] != DBNull.Value)
                            currency.MinTransferAmount = Convert.ToDecimal(drCurrency["MinTransferAmount"].ToString());
                        currency.IsActive = Convert.ToBoolean(drCurrency["IsActive"]);
                    }
                }
            }
            return currency;
        }

        /// <summary>
        /// Delete Currency information from tabel (Created for Unit test purpose)
        /// </summary>
        /// <param name="CurrencyId"></param>
        public void DeleteCurrency(int CurrencyId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("UT_DELETECURRENCY"))
            {
                objDb.AddInParameter(cmd, "IN_CurrencyID", DbType.Int32, CurrencyId);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Get all Country list from Country table
        /// </summary>
        /// <returns></returns>
        public List<Country> CountrySelectAll()
        {
            Country country;
            List<Country> lstCountry = new List<Country>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("COUNTRYSELECTALL"))
            {
                using (IDataReader drCountry = objDb.ExecuteReader(cmd))
                {
                    while (drCountry.Read())
                    {
                        country = new Country();
                        country.CountryID = Convert.ToInt32(drCountry["CountryID"].ToString());
                        country.CountryName = drCountry["CountryName"].ToString();

                        lstCountry.Add(country);
                    }
                }
            }
            return lstCountry;
        }

        /// <summary>
        /// 1. Create a new action record from the supplied ActionName and ActionResponse and receive the returned ActionID
        /// 2. Creatae a new triggered event record from the returned ActionID and the supplied data (TriggeredEvent) - (NB: Newly created records will have a RecVer of 1).
        /// </summary>
        /// <param name="actionName"></param>
        /// <param name="actionResponse"></param>
        /// <param name="billingPercentageAdministrator"></param>
        /// <param name="billingPercentageOwner"></param>
        /// <param name="isActive"></param>
        public void TriggeredEventInsert(TriggeredEvent triggeredEvent)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("TriggeredEventInsert"))
            {
                objDb.AddInParameter(cmd, "IN_ActionName", DbType.String, triggeredEvent.ActionName);
                objDb.AddInParameter(cmd, "IN_ActionResponse", DbType.Int32, triggeredEvent.ActionResponseID);
                objDb.AddInParameter(cmd, "IN_BillingPercentageAdministrator", DbType.Int32, triggeredEvent.BillingPercentageAdministrator);
                objDb.AddInParameter(cmd, "IN_BillingPercentageOwner", DbType.Decimal, triggeredEvent.BillingPercentageOwner);
                objDb.AddInParameter(cmd, "IN_IsActive", DbType.Boolean, triggeredEvent.IsActive);
                objDb.AddInParameter(cmd, "IN_IsPercentFee", DbType.Boolean, triggeredEvent.IsPercentFee);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// 1. Update the action record (Actions) with the supplied Action Response (Actions.ActionResponse)
        /// 2. Update the existing triggered event record (TriggeredEvent.TriggeredEventID) with the supplied details (TriggeredEvent)
        /// </summary>
        /// <param name="actionId"></param>
        /// <param name="actionResponse"></param>
        /// <param name="recVer"></param>
        /// <param name="billingPercentageAdministrator"></param>
        /// <param name="billingPercentageOwner"></param>
        /// <param name="isActive"></param>
        public void TriggeredEventUpdate(TriggeredEvent triggeredEvent)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("TriggeredEventUpdate"))
            {
                objDb.AddInParameter(cmd, "in_actionid", DbType.String, triggeredEvent.ActionID);
                objDb.AddInParameter(cmd, "in_recver", DbType.Int32, 1);
                objDb.AddInParameter(cmd, "in_billingpercentageadministrator", DbType.Int32, triggeredEvent.BillingPercentageAdministrator);
                objDb.AddInParameter(cmd, "in_billingpercentageowner", DbType.Decimal, triggeredEvent.BillingPercentageOwner);
                objDb.AddInParameter(cmd, "in_isactive", DbType.Boolean, triggeredEvent.IsActive);
                objDb.AddInParameter(cmd, "in_ispercentfee", DbType.Boolean, triggeredEvent.IsPercentFee);
                objDb.AddInParameter(cmd, "in_response", DbType.String, triggeredEvent.ResponseId);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Get all Action list.
        /// </summary>
        /// <returns></returns>
        public List<Actions> ActionList()
        {
            Actions actions;
            List<Actions> lstActions = new List<Actions>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("ActionList"))
            {
                using (IDataReader drActions = objDb.ExecuteReader(cmd))
                {
                    while (drActions.Read())
                    {
                        actions = new Actions();
                        actions.ActionID = Convert.ToInt32(drActions["ActionID"].ToString());
                        actions.Name = drActions["Name"].ToString();

                        lstActions.Add(actions);
                    }
                }
            }

            return lstActions;
        }

        /// <summary>
        /// Get all active action list.
        /// </summary>
        /// <returns></returns>
        public List<Actions> ActiveActionList()
        {
            Actions actions;
            List<Actions> lstActions = new List<Actions>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("ActionSelectActive"))
            {
                using (IDataReader drActions = objDb.ExecuteReader(cmd))
                {
                    while (drActions.Read())
                    {
                        actions = new Actions();
                        actions.ActionID = Convert.ToInt32(drActions["ActionID"].ToString());
                        actions.Name = drActions["Name"].ToString();

                        lstActions.Add(actions);
                    }
                }
            }

            return lstActions;
        }

        /// <summary>
        /// Retrieves list of authentication details. Passing ownerId as zero will retrieve all the records.
        /// </summary>
        /// <param name="ownerId"></param>
        /// <returns></returns>
        public List<ApplicationAuthentication> ApplicationAuthenticationSelectAll(int ownerId)
        {
            ApplicationAuthentication applicationAuthentication;
            List<ApplicationAuthentication> lstApplicationAuthentication = new List<ApplicationAuthentication>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("ApplicationAuthenticationSelectAll"))
            {
                objDb.AddInParameter(cmd, "in_ownerid", DbType.Int32, ownerId);
                using (IDataReader drAuthentication = objDb.ExecuteReader(cmd))
                {
                    while (drAuthentication.Read())
                    {
                        applicationAuthentication = new ApplicationAuthentication();
                        applicationAuthentication.OwnerID = Convert.ToInt32(drAuthentication["OwnerID"]);
                        applicationAuthentication.OwnerName = drAuthentication["OwnerName"].ToString();
                        applicationAuthentication.CommunityID = Convert.ToInt32(drAuthentication["CommunityID"]);
                        applicationAuthentication.CommunityName = drAuthentication["CommunityName"].ToString();
                        applicationAuthentication.RegisteredEmail = drAuthentication["RegisteredEmail"].ToString();
                        applicationAuthentication.ApplicationID = Convert.ToInt32(drAuthentication["ApplicationID"]);
                        applicationAuthentication.ApplicationName = drAuthentication["ApplicationName"].ToString();
                        applicationAuthentication.APIToken = drAuthentication["APIToken"].ToString();
                        applicationAuthentication.CommunityActive = Convert.ToBoolean(drAuthentication["CommunityActive"]);
                        applicationAuthentication.IsActive = Convert.ToBoolean(drAuthentication["IsActive"]);

                        lstApplicationAuthentication.Add(applicationAuthentication);
                    }
                }
            }

            return lstApplicationAuthentication;
        }

        /// <summary>
        /// Get all triggered events
        /// </summary>
        /// <returns></returns>
        public List<TriggeredEvent> TriggeredEventSelectAll()
        {
            TriggeredEvent triggeredEvent;
            ActionResponse actionResponse;
            List<TriggeredEvent> lstTiggeredEvent = new List<TriggeredEvent>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("TriggeredEventSelectAll"))
            {
                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    dataSet.Tables[0].TableName = "TriggeredEvents";

                    foreach (DataRow drTriggeredEvents in dataSet.Tables["TriggeredEvents"].Rows)
                    {
                        triggeredEvent = new TriggeredEvent();
                        triggeredEvent.ActionName = drTriggeredEvents["ActionName"].ToString();
                        triggeredEvent.ActionID = Convert.ToInt32(drTriggeredEvents["ActionID"]);
                        triggeredEvent.TriggeredEventID = Convert.ToInt32(drTriggeredEvents["TriggeredEventID"]);
                        triggeredEvent.BillingPercentageAdministrator = Convert.ToDecimal(drTriggeredEvents["BillingPercentageAdministrator"]);
                        triggeredEvent.BillingPercentageOwner = Convert.ToDecimal(drTriggeredEvents["BillingPercentageOwner"]);
                        triggeredEvent.IsActive = Convert.ToBoolean(drTriggeredEvents["IsActive"]);
                        triggeredEvent.IsPercentFee = Convert.ToBoolean(drTriggeredEvents["IsPercentFee"]);

                        if (dataSet.Tables.Count > 1)
                        {
                            dataSet.Tables[1].TableName = "ActionResponse";
                            DataTable dtActionResponse = dataSet.Tables["ActionResponse"];
                            IEnumerable<DataRow> result = from A in dtActionResponse.AsEnumerable() select A;
                            IEnumerable<DataRow> actionResponseResult = result.Where(A => A.Field<int>("ActionID") == triggeredEvent.ActionID);

                            triggeredEvent.lstActionResponse = new List<ActionResponse>();
                            foreach (var row in actionResponseResult)
                            {
                                actionResponse = new ActionResponse();
                                actionResponse.ResponseID = row.Field<int>("ResponseID");
                                actionResponse.ActionID = row.Field<int>("ActionID");
                                actionResponse.ActionResponseID = row.Field<int>("ActionResponseID");

                                triggeredEvent.lstActionResponse.Add(actionResponse);
                            }
                        }

                        lstTiggeredEvent.Add(triggeredEvent);
                    }
                }
            }

            return lstTiggeredEvent;
        }

        /// <summary>
        /// Get Action response
        /// </summary>
        /// <param name="actionId"></param>
        /// <returns></returns>
        public List<ActionResponse> ActionResponseSelect(int actionId)
        {
            ActionResponse actionResponse;
            List<ActionResponse> lstActionResponse = new List<ActionResponse>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("actionresponseselect"))
            {
                objDb.AddInParameter(cmd, "in_actionid", DbType.Int32, actionId);
                using (IDataReader drActions = objDb.ExecuteReader(cmd))
                {
                    while (drActions.Read())
                    {
                        actionResponse = new ActionResponse();
                        actionResponse.ActionID = Convert.ToInt32(drActions["ActionID"].ToString());
                        actionResponse.ActionName = drActions["actionname"].ToString();
                        actionResponse.ActionResponseID = Convert.ToInt32(drActions["actionresponseid"].ToString());
                        actionResponse.ResponseID = Convert.ToInt32(drActions["responseid"].ToString());
                        actionResponse.ResponseActionName = drActions["responsename"].ToString();
                        lstActionResponse.Add(actionResponse);
                    }
                }
            }

            return lstActionResponse;
        }

        /// <summary>
        /// Get actionreponse without Request / Quote
        /// </summary>
        /// <param name="actionId"></param>
        /// <returns></returns>
        public List<ActionResponse> ActionResponseSelectWithoutRespondAndQuote(int actionId,int supplieractionId)
        {
            ActionResponse actionResponse;
            List<ActionResponse> lstActionResponse = new List<ActionResponse>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("actionresponseselectwithoutRespondAndQuote"))
            {
                objDb.AddInParameter(cmd, "in_actionid", DbType.Int32, actionId);
                objDb.AddInParameter(cmd, "in_supplieractionid", DbType.Int32, supplieractionId);
                using (IDataReader drActions = objDb.ExecuteReader(cmd))
                {
                    while (drActions.Read())
                    {
                        actionResponse = new ActionResponse();
                        actionResponse.ActionID = Convert.ToInt32(drActions["ActionID"].ToString());
                        actionResponse.ActionName = drActions["actionname"].ToString();
                        actionResponse.ActionResponseID = Convert.ToInt32(drActions["actionresponseid"].ToString());
                        actionResponse.ResponseID = Convert.ToInt32(drActions["responseid"].ToString());
                        actionResponse.ResponseActionName = drActions["responsename"].ToString();
                        lstActionResponse.Add(actionResponse);
                    }
                }
            }

            return lstActionResponse;
        }


        /// <summary>
        /// Checks currency isocode and description already exist. If exist return 1 else return 0.
        /// </summary>
        /// <param name="currencyId"></param>
        /// <param name="isoCode"></param>
        /// <param name="description"></param>
        /// <returns></returns>
        public string CheckCurrencyExist(int currencyId, string isoCode, string description)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CheckCurrencyExist"))
            {
                objDb.AddInParameter(cmd, "in_currencyid", DbType.Int32, currencyId);
                objDb.AddInParameter(cmd, "in_isocode", DbType.String, isoCode);
                objDb.AddInParameter(cmd, "in_description", DbType.String, description);
                return (objDb.ExecuteScalar(cmd)).ToString();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<AdminTransactionHistory> AdminTransactionSummary()
        {
            AdminTransactionHistory adminTransactionHistory;
            List<AdminTransactionHistory> lstAdminHistory = new List<AdminTransactionHistory>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("admintransactionsummary"))
            {
                using (IDataReader drHistory = objDb.ExecuteReader(cmd))
                {
                    while (drHistory.Read())
                    {
                        adminTransactionHistory = new AdminTransactionHistory();
                        adminTransactionHistory.OwnerID = Convert.ToInt32(drHistory["ownerid"].ToString());
                        adminTransactionHistory.OwnerName = drHistory["companyname"].ToString();
                        adminTransactionHistory.Balance = Convert.ToDecimal(drHistory["balance"].ToString());
                        adminTransactionHistory.CurrencyID = Convert.ToInt32(drHistory["currencyid"].ToString());
                        adminTransactionHistory.CurrencyName = drHistory["currencyname"].ToString();
                        adminTransactionHistory.DateApplied = DateTime.Now;//Dummy value added for API call
                        lstAdminHistory.Add(adminTransactionHistory);
                    }
                }
            }
            return lstAdminHistory;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="adminTransactionHistory"></param>
        /// <returns></returns>
        public List<AdminTransactionHistory> AdminTransactionSelect(AdminTransactionHistory adminTransactionHistory)
        {
            AdminTransactionHistory adminTransactionHistory1;
            List<AdminTransactionHistory> lstAdminHistory = new List<AdminTransactionHistory>();
            DbCommand cmd;
            DateTime? date = null;
            Common common = new Common();
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("admintransactionselect"))
            {
                objDb.AddInParameter(cmd, "in_ownerid", DbType.Int32, adminTransactionHistory.OwnerID);
                objDb.AddInParameter(cmd, "in_currencyid", DbType.Int32, adminTransactionHistory.CurrencyID);
                objDb.AddInParameter(cmd, "in_fromdate", DbType.DateTime, adminTransactionHistory.FromDate == "null" ? date : common.ParseDate(adminTransactionHistory.FromDate, "dd/MM/yyyy"));
                objDb.AddInParameter(cmd, "in_todate", DbType.DateTime, adminTransactionHistory.ToDate == "null" ? date : common.ParseDate(adminTransactionHistory.ToDate, "dd/MM/yyyy"));
                objDb.AddInParameter(cmd, "in_rowindex", DbType.Int32, adminTransactionHistory.RowIndex);
                objDb.AddInParameter(cmd, "in_rowcount", DbType.Int32, adminTransactionHistory.RowCount);
                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    dataSet.Tables[0].TableName = "AdminCommunity";
                    dataSet.Tables[1].TableName = "TotalRecords";

                    foreach (DataRow drHistory in dataSet.Tables["AdminCommunity"].Rows)
                    {
                        adminTransactionHistory1 = new AdminTransactionHistory();
                        adminTransactionHistory1.OwnerID = Convert.ToInt32(drHistory["ownerid"].ToString());
                        adminTransactionHistory1.OwnerName = drHistory["companyname"].ToString();
                        adminTransactionHistory1.Description = drHistory["description"].ToString();
                        adminTransactionHistory1.CommunityName = drHistory["communityname"].ToString();
                        adminTransactionHistory1.CommunityGroupName = drHistory["communitygroupname"].ToString();
                        adminTransactionHistory1.SupplierName = drHistory["suppliername"].ToString();
                        adminTransactionHistory1.CustomerName = drHistory["customername"].ToString();
                        adminTransactionHistory1.DateApplied = Convert.ToDateTime(drHistory["dateapplied"]);
                        adminTransactionHistory1.Amount = Convert.ToDecimal(drHistory["amount"]);
                        adminTransactionHistory1.CurrencyID = Convert.ToInt32(drHistory["CurrencyID"]);
                        adminTransactionHistory1.CurrencyName = drHistory["CurrencyName"].ToString();
                        adminTransactionHistory1.TotalRecords = Convert.ToInt32(dataSet.Tables["TotalRecords"].Rows[0]["TotalRecords"].ToString());

                        lstAdminHistory.Add(adminTransactionHistory1);
                    }
                }
            }

            return lstAdminHistory;
        }

        /// <summary>
        /// Get allowed pages for specific role
        /// </summary>
        /// <param name="userroleId"></param>
        /// <returns></returns>
        public string AccessRightSelectByRole(int userroleId)
        {
            DbCommand cmd;
            string pages = string.Empty;

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("accessrightselectbyrole"))
            {
                objDb.AddInParameter(cmd, "in_userroleid", DbType.Int32, userroleId);
                using (IDataReader drPages = objDb.ExecuteReader(cmd))
                {
                    while (drPages.Read())
                    {
                        pages = drPages["pagename"].ToString() + ",";

                    }
                }
            }
            if (!string.IsNullOrEmpty(pages))
                pages = pages.Substring(0, pages.Length - 1);
            return pages;
        }

        /// <summary>
        /// Get allowed pages for specific OAuthaccount
        /// </summary>
        /// <param name="OAuthaccountId"></param>
        /// <returns></returns>
        public string AccessRightSelectByOAuthaccount(int OAuthaccountId)
        {
            DbCommand cmd;
            string pages = string.Empty;

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("accessrightselectbyoauthaccount"))
            {
                objDb.AddInParameter(cmd, "in_oauthaccountid", DbType.Int32, OAuthaccountId);
                using (IDataReader drPages = objDb.ExecuteReader(cmd))
                {
                    while (drPages.Read())
                    {
                        pages += drPages["pagename"].ToString().ToLower() + ",";

                    }
                }
            }
            if (!string.IsNullOrEmpty(pages))
                pages = pages.Substring(0, pages.Length - 1);
            return pages;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<AccessRights> AccessRightSelectAll()
        {
            DbCommand cmd;

            List<AccessRights> lstAccessright = new List<AccessRights>();
            AccessRights accessRight = new AccessRights();

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("accessrightselectall"))
            {
                using (IDataReader drPages = objDb.ExecuteReader(cmd))
                {
                    while (drPages.Read())
                    {
                        accessRight = new AccessRights();
                        accessRight.PageID = Convert.ToInt32(drPages["pageid"].ToString());
                        accessRight.PageName = drPages["pagename"].ToString();
                        accessRight.IsAdminAllowed = Convert.ToBoolean(drPages["administrator"]);
                        accessRight.IsOwnerAllowed = Convert.ToBoolean(drPages["owner"]);
                        accessRight.IsSupplierAllowed = Convert.ToBoolean(drPages["supplier"]);

                        lstAccessright.Add(accessRight);
                    }
                }
            }
            return lstAccessright;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="accessRight"></param>
        public void AccessRightUpdate(AccessRights accessRight)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("accessrightupdate"))
            {
                objDb.AddInParameter(cmd, "in_pageid", DbType.Int32, accessRight.PageID);
                objDb.AddInParameter(cmd, "in_adminallowed", DbType.Boolean, accessRight.IsAdminAllowed);
                objDb.AddInParameter(cmd, "in_ownerallowed", DbType.Boolean, accessRight.IsOwnerAllowed);
                objDb.AddInParameter(cmd, "in_supplierallowed", DbType.Boolean, accessRight.IsSupplierAllowed);
                objDb.ExecuteNonQuery(cmd);
            }
        }
    }
}
