using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

using RatingReviewEngine.DAC;
using RatingReviewEngine.Entities;
using RatingReviewEngine.Entities.ServiceRequest;
using RatingReviewEngine.Business.Shared;

namespace RatingReviewEngine.Business
{
    public class AdministratorComponent
    {
        /// <summary>
        /// Create a new currency
        /// </summary>
        /// <param name="currency"></param>
        public int CurrencyInsert(Currency currency)
        {
            AdministratorDAC administratorDAC = new AdministratorDAC();
            return administratorDAC.CurrencyInsert(currency);
        }

        /// <summary>
        /// Update an existing currency
        /// </summary>
        /// <param name="currency"></param>
        public void CurrencyUpdate(Currency currency)
        {
            AdministratorDAC administratorDAC = new AdministratorDAC();
            administratorDAC.CurrencyUpdate(currency);
        }

        /// <summary>
        /// Get all Currency
        /// </summary>
        /// <returns></returns>
        public List<Currency> CurrencySelectAll()
        {
            AdministratorDAC administrativeDAC = new AdministratorDAC();
            return administrativeDAC.CurrencySelectAll();
        }

        /// <summary>
        /// Get Active Currency
        /// </summary>
        /// <returns></returns>
        public List<Currency> CurrencySelectActive()
        {
            AdministratorDAC administrativeDAC = new AdministratorDAC();
            return administrativeDAC.CurrencySelectActive();
        }

        /// <summary>
        ///  Get Currency information based on Currency ID (Created for Unit test purpose)
        /// </summary>
        /// <param name="CurrencyId"></param>
        /// <returns></returns>
        public Currency GetCurrency(int CurrencyId)
        {
            AdministratorDAC administratorDAC = new AdministratorDAC();
            return administratorDAC.GetCurrency(CurrencyId);
        }

        /// <summary>
        /// Get Owner currency
        /// </summary>
        /// <returns></returns>
        public List<Currency> CurrencySelectByOwner(int ownerId)
        {
            AdministratorDAC administratorDAC = new AdministratorDAC();
            return administratorDAC.CurrencySelectByOwner(ownerId);
        }
        /// <summary>
        /// Delete Currency from tabel ( Created for Unit test purpose)
        /// </summary>
        /// <param name="CurrencyId"></param>
        public void DeleteCurrency(int CurrencyId)
        {
            AdministratorDAC administratorDAC = new AdministratorDAC();
            administratorDAC.DeleteCurrency(CurrencyId);
        }

        /// <summary>
        /// Get all Country list from Country table
        /// </summary>
        /// <returns></returns>
        public List<Country> CountrySelectAll()
        {
            AdministratorDAC administratorDAC = new AdministratorDAC();
            return administratorDAC.CountrySelectAll();
        }

        // <summary>
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
            AdministratorDAC administratorDAC = new AdministratorDAC();
            administratorDAC.TriggeredEventInsert(triggeredEvent);
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
            AdministratorDAC adminstratorDAC = new AdministratorDAC();
            adminstratorDAC.TriggeredEventUpdate(triggeredEvent);
        }

        /// <summary>
        /// Get all active action list.
        /// </summary>
        /// <returns></returns>
        public List<Actions> ActiveActionList()
        {
            AdministratorDAC adminstratorDAC = new AdministratorDAC();
            return adminstratorDAC.ActiveActionList();
        }

        /// <summary>
        /// Get all action list.
        /// </summary>
        /// <returns></returns>
        public List<Actions> ActionList()
        {
            AdministratorDAC adminstratorDAC = new AdministratorDAC();
            return adminstratorDAC.ActionList();
        }

        /// <summary>
        /// Retrieves list of authentication details. Passing ownerId as zero will retrieve all the records.
        /// </summary>
        /// <param name="ownerId"></param>
        /// <returns></returns>
        public List<ApplicationAuthentication> ApplicationAuthenticationSelectAll(int ownerId)
        {
            AdministratorDAC adminstratorDAC = new AdministratorDAC();
            return adminstratorDAC.ApplicationAuthenticationSelectAll(ownerId);
        }

        /// <summary>
        /// Get all triggered events
        /// </summary>
        /// <returns></returns>
        public List<TriggeredEvent> TriggeredEventSelectAll()
        {
            AdministratorDAC adminstratorDAC = new AdministratorDAC();
            return adminstratorDAC.TriggeredEventSelectAll();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="actionId"></param>
        /// <returns></returns>
        public List<ActionResponse> ActionResponseSelect(int actionId)
        {
            AdministratorDAC administratorDAC = new AdministratorDAC();
            return administratorDAC.ActionResponseSelect(actionId);
        }

        /// <summary>
        /// Get actionreponse without Request / Quote
        /// </summary>
        /// <param name="actionId"></param>
        /// <returns></returns>
        public List<ActionResponse> ActionResponseSelectWithoutRespondAndQuote(int actionId, int supplieractionId)
        {
            AdministratorDAC administratorDAC = new AdministratorDAC();
            return administratorDAC.ActionResponseSelectWithoutRespondAndQuote(actionId, supplieractionId);
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
            AdministratorDAC administratorDAC = new AdministratorDAC();
            return administratorDAC.CheckCurrencyExist(currencyId, isoCode, description);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<AdminTransactionHistory> AdminTransactionSummary()
        {
            AdministratorDAC administratorDAC = new AdministratorDAC();
            return administratorDAC.AdminTransactionSummary();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="adminTransactionHistory"></param>
        /// <returns></returns>
        public List<AdminTransactionHistory> AdminTransactionSelect(AdminTransactionHistory adminTransactionHistory)
        {
            AdministratorDAC administratorDAC = new AdministratorDAC();
            return administratorDAC.AdminTransactionSelect(adminTransactionHistory);
        }

        public string DownloadAdminTransaction(ExportAdminTransactionRequest exportRequest)
        {
            AdministratorDAC administratorDAC = new AdministratorDAC();
            var transactionFilter = new AdminTransactionHistory()
            {
                OwnerID = exportRequest.OwnerID,
                CurrencyID = exportRequest.CurrencyID,
                FromDate = exportRequest.FromDate,
                ToDate = exportRequest.ToDate,
                RowIndex = 0,
                RowCount = 0
            };

            List<AdminTransactionHistory> lstTransactionHistories = administratorDAC.AdminTransactionSelect(transactionFilter);
            if (lstTransactionHistories.Count > 0)
            {
                string fileName = General.RandomString(10) + "." + exportRequest.ExportType;
                if (exportRequest.ExportType.ToLower() == "csv")
                {
                    lstTransactionHistories.ToCSV(HttpContext.Current.Server.MapPath("~/Assets/ExportedFiles/") + fileName, "OwnerName,CommunityName,CommunityGroupName,Description,SupplierName,CustomerName,DateApplied,Amount,CurrencyName", "Owner,Community,Community Group,Description,Supplier,Customer,Date,Transaction Amount,Currency");
                }
                else if (exportRequest.ExportType.ToLower() == "xml")
                {
                    //Extension method ToXML created in class RatingReviewEngine.Business.Shared.Export
                    lstTransactionHistories.ToXML(HttpContext.Current.Server.MapPath("~/Assets/ExportedFiles/") + fileName, "OwnerName,CommunityName,CommunityGroupName,Description,SupplierName,CustomerName,DateApplied,Amount,CurrencyName", "Owner,Community,Community Group,Description,Supplier,Customer,Date,Transaction Amount,Currency");
                }
                return fileName;
            }
            else
            {
                return String.Empty;
            }

        }

        /// <summary>
        /// Get allowed pages for specific role
        /// </summary>
        /// <param name="userroleId"></param>
        /// <returns></returns>
        public string AccessRightSelectByRole(int userroleId)
        {
            AdministratorDAC administratorDAC = new AdministratorDAC();
            return administratorDAC.AccessRightSelectByRole(userroleId);
        }

        /// <summary>
        /// Get allowed pages for specific OAuthaccount
        /// </summary>
        /// <param name="OAuthaccountId"></param>
        /// <returns></returns>
        public string AccessRightSelectByOAuthaccount(int OAuthaccountId)
        {
            AdministratorDAC administratorDAC = new AdministratorDAC();
            return administratorDAC.AccessRightSelectByOAuthaccount(OAuthaccountId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<AccessRights> AccessRightSelectAll()
        {
            AdministratorDAC administratorDAC = new AdministratorDAC();
            return administratorDAC.AccessRightSelectAll();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="accessRight"></param>
        public void AccessRightUpdate(AccessRights accessRight)
        {
            AdministratorDAC administratorDAC = new AdministratorDAC();
            administratorDAC.AccessRightUpdate(accessRight);
        }
    }
}
