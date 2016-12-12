using System;
using System.Web;
using RatingReviewEngine.Business.Shared;
using RatingReviewEngine.DAC;
using RatingReviewEngine.Entities;
using RatingReviewEngine.Entities.ServiceRequest;
using RatingReviewEngine.Entities.ServiceResponse;
using System.Collections.Generic;

namespace RatingReviewEngine.Business
{
    public class OwnerComponent
    {
        /// <summary>
        /// Create a new community owner record with the supplied details (Owner)
        /// Associate the newly created Owner record (Owner.OwnerID) with the supplied OAuth Account (OAuthAccount.OAuthAccountID) (EntityOAuthAccount)
        /// </summary>
        /// <param name="owner"></param>
        /// <returns></returns>
        public int RegisterNewCommunityOwner(Owner owner)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            return ownerDAC.RegisterNewCommunityOwner(owner);
        }

        /// <summary>
        /// Update the details of an existing community owner record (Owner.OwnerID) with the supplied details.
        /// </summary>
        /// <param name="owner"></param>
        public void OwnerUpdate(Owner owner)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            ownerDAC.OwnerUpdate(owner);
        }

        /// <summary>
        /// Get Owner information based on OwnerId 
        /// </summary>
        /// <param name="ownerId"></param>
        /// <returns></returns>
        public Owner OwnerSelect(int ownerId)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            return ownerDAC.OwnerSelect(ownerId);
        }

        /// <summary>
        /// Delete Owner information (Unit test purpose)
        /// </summary>
        /// <param name="ownerId"></param>
        public void OwnerDelete(int ownerId)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            ownerDAC.OwnerDelete(ownerId);
        }

        /// <summary>
        ///1. Save the given Application details (ApplicationAuthentication)
        ///2. Generate a new API Token and update the application record to save the token (ApplicationAuthentication.APIToken & ApplicationAuthentication.TokenGenerated)
        ///3. Activate the API Token (ApplicationAuthentication.IsActive = true)
        /// </summary>
        /// <param name="applicationAuthentication"></param>
        public ApplicationAuthentication APITokenActivate(ApplicationAuthentication applicationAuthentication)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            return ownerDAC.APITokenActivate(applicationAuthentication);
        }

        /// <summary>
        /// Update the application record and deactivate the API Token associated to the registered application (ApplicationAuthentication.IsActive = false)
        /// </summary>
        /// <param name="nApplicationID"></param>
        public ApplicationAuthentication APITokenDeactivate(int applicationID)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            return ownerDAC.APITokenDeactivate(applicationID);
        }

        /// <summary>
        /// Insert application record in ApplicationAuthentication table.
        /// </summary>
        /// <param name="applicationAuthentication"></param>
        public void ApplicationInsert(ApplicationAuthentication applicationAuthentication)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            ownerDAC.ApplicationInsert(applicationAuthentication);
        }

        /// <summary>
        /// 1. Generate a new API Token and update the application record to save the token (ApplicationAuthentication.APIToken & ApplicationAuthentication.TokenGenerated)
        /// 2. Activate the API Token (ApplicationAuthentication.IsActive = true)
        /// </summary>
        /// <param name="applicationAuthentication"></param>
        public ApplicationAuthentication APITokenReset(ApplicationAuthentication applicationAuthentication)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            return ownerDAC.APITokenReset(applicationAuthentication);
        }

        public ApplicationAuthentication APITokenResend(ApplicationAuthentication applicationAuthentication)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            return ownerDAC.APITokenResend(applicationAuthentication);
        }

        /// <summary>
        /// Check Owner email is already exist. If exist return 1 else return 0.
        /// For new record pass ownerId as 0
        /// </summary>
        /// <param name="ownerEmail"></param>
        /// <returns></returns>
        public string CheckOwnerEmailExist(int ownerId, string email)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            return ownerDAC.CheckOwnerEmailExist(ownerId, email);
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
            OwnerDAC ownerDAC = new OwnerDAC();
            return ownerDAC.CustomerTransactionSearch(searchText, ownerId, communityId, communityGroupId, rowIndex, rowCount);
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
            OwnerDAC ownerDAC = new OwnerDAC();
            return ownerDAC.SupplierTransactionSearch(supplierName, ownerId, communityId, communityGroupId, categoryId, rowIndex, rowCount);
        }

        /// <summary>
        /// Retrieves list of CommunityID and Name for a particular owner.
        /// </summary>
        /// <param name="ownerId"></param>
        /// <returns></returns>
        public List<MenuItem> CommunityListMenu(int ownerId)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            return ownerDAC.CommunityListMenu(ownerId);
        }

        /// <summary>
        /// The current virtual account balance for the community owner as associated to the relevant community and community currency.
        /// </summary>
        /// <param name="ownerId"></param>
        /// <returns></returns>
        public List<CommunityOwnerTransactionHistory> OwnerAccountSummary(int ownerId)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            return ownerDAC.OwnerAccountSummary(ownerId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="exportSupplierCommunityTransaction"></param>
        /// <returns>Temporary file name where data exported. Returns String.Empty if no data exist</returns>
        public string DownloadCommunityOwnerTransaction(ExportCommunityOwnerTransactionRequest exportRequest)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            var transactionFilter = new CommunityOwnerTransactionHistory()
            {
                OwnerID = exportRequest.OwnerID,
                CommunityID = exportRequest.CommunityID,
                CommunityGroupID = exportRequest.CommunityGroupID,
                FromDate=exportRequest.FromDate,
                ToDate=exportRequest.ToDate,
                RowIndex = 0,
                RowCount = 0
            };

            List<CommunityOwnerTransactionHistory> lstTransactionHistories = ownerDAC.CommunityOwnerTransactionSelect(transactionFilter);
            if (lstTransactionHistories.Count > 0)
            {
                string fileName = General.RandomString(10) + "." + exportRequest.ExportType;
                if (exportRequest.ExportType.ToLower() == "csv")
                {
                    lstTransactionHistories.ToCSV(HttpContext.Current.Server.MapPath("~/Assets/ExportedFiles/") + fileName, "CommunityName,CommunityGroupName,Description,SupplierName,CustomerName,DateApplied,Amount,CurrencyName", "Community,Community Group,Description,Supplier,Customer,Date,Transaction Amount,Currency");
                }
                else if (exportRequest.ExportType.ToLower() == "xml")
                {
                    //Extension method ToXML created in class RatingReviewEngine.Business.Shared.Export
                    lstTransactionHistories.ToXML(HttpContext.Current.Server.MapPath("~/Assets/ExportedFiles/") + fileName, "CommunityName,CommunityGroupName,Description,SupplierName,CustomerName,DateApplied,Amount,CurrencyName", "Community,Community Group,Description,Supplier,Customer,Date,Transaction Amount,Currency");
                }
                return fileName;
            }
            else
            {
                return String.Empty;
            }

        }
        /// <summary>
        ///  Retrives owner transaction details based on the input parameters.
        /// </summary>
        /// <param name="communityOwnerTransactionHistory"></param>
        /// <returns></returns>
        public List<CommunityOwnerTransactionHistory> CommunityOwnerTransactionSelect(CommunityOwnerTransactionHistory communityOwnerTransactionHistory)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            return ownerDAC.CommunityOwnerTransactionSelect(communityOwnerTransactionHistory);
        }

        /// <summary>
        /// Checks application name is already exist. If exist return 1 else return 0.
        /// </summary>
        /// <param name="applicationName"></param>
        /// <returns></returns>
        public string CheckApplicationExist(string applicationName)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            return ownerDAC.CheckApplicationExist(applicationName);
        }

        /// <summary>
        /// The owner current Virtual Community Account balance for the given community.
        /// </summary>
        /// <param name="ownerId"></param>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public decimal OwnerAccountBalanceByCommunity(int ownerId, int communityId)
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            return ownerDAC.OwnerAccountBalanceByCommunity(ownerId, communityId);
        }

         /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<Owner> OwnerSelectAll()
        {
            OwnerDAC ownerDAC = new OwnerDAC();
            return ownerDAC.OwnerSelectAll();
        }
    }
}
