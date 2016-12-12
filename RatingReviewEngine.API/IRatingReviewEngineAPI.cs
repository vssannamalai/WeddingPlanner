using RatingReviewEngine.Entities;
using RatingReviewEngine.Entities.ServiceRequest;
using RatingReviewEngine.Entities.ServiceResponse;
using RatingReviewEngine.WorldPay;

using System.Collections.Generic;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System;

namespace RatingReviewEngine.API
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IRatingReviewEngineAPI" in both code and config file together.
    [ServiceContract]
    public interface IRatingReviewEngineAPI
    {
        #region User
        //[FaultContract(typeof(RatingReviewEngineException))]
        /// <summary>
        /// Login method with parameter.
        /// </summary>
        /// <param name="loginServiceRequest"></param>        
        /// <returns></returns>
        [OperationContract]
        [WebInvoke(UriTemplate = "/Login", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        LoginResponse Login(LoginRequest loginRequest);

        /// <summary>
        /// Login method with object as parameter.
        /// </summary>
        /// <param name="oauthAccount"></param>
        /// <returns></returns>
        ////[OperationContract]
        ////[WebInvoke(UriTemplate = "/UserLogin", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        ////string UserLogin(OAuthAccount oauthAccount);

        [OperationContract]
        [WebInvoke(UriTemplate = "/RegisterAccount", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        RegisterAccountResponse RegisterAccount(OAuthAccount oauthAccount);

        [OperationContract]
        [WebInvoke(UriTemplate = "/ActivateAccount", ResponseFormat = WebMessageFormat.Json, Method = "POST")]

        AccountActivationResponse ActivateAccount(AccountActivationRequest activationRequest);

        [OperationContract]
        [WebInvoke(UriTemplate = "/CheckValidUserID", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        string CheckValidUserID(OAuthAccount oauthAccount);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SendForgotPasswordEmail", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        string SendForgotPasswordEmail(OAuthAccount oauthAccount);

        [OperationContract]
        [WebGet(UriTemplate = "/ValidateForgotPasswordLink/{lnkDate}", ResponseFormat = WebMessageFormat.Json)]
        string ValidateForgotPasswordLink(string lnkDate);

        [OperationContract]
        [WebInvoke(UriTemplate = "/ChangePassword", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        string ChangePassword(OAuthAccount oauthAccount);

        #endregion

        #region Administrator

        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateAccessRight", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateAccessRight(AccessRights accessRight);

        [OperationContract]
        [WebGet(UriTemplate = "/GetAllAccessRight", ResponseFormat = WebMessageFormat.Json)]
        List<AccessRights> GetAllAccessRight();

        [OperationContract]
        [WebGet(UriTemplate = "/GetAllowedPagesByOAuthAccount/{OAuthaccountId}", ResponseFormat = WebMessageFormat.Json)]
        string GetAllowedPagesByOAuthAccount(string OAuthaccountId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetAllowedPages/{userroleId}", ResponseFormat = WebMessageFormat.Json)]
        string GetAllowedPages(string userroleId);

        [OperationContract]
        [WebGet(UriTemplate = "/CountryList", ResponseFormat = WebMessageFormat.Json)]
        List<Country> CountryList();

        [OperationContract]
        [WebGet(UriTemplate = "/CurrencyActiveList", ResponseFormat = WebMessageFormat.Json)]
        List<Currency> CurrencyActiveList();

        [OperationContract]
        [WebGet(UriTemplate = "/CurrencyList", ResponseFormat = WebMessageFormat.Json)]
        List<Currency> CurrencyList();

        [OperationContract]
        [WebGet(UriTemplate = "/OwnerCurrencyList/{ownerId}", ResponseFormat = WebMessageFormat.Json)]
        List<Currency> OwnerCurrencyList(string ownerId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/NewCurrency", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        int NewCurrency(Currency currency);

        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateCurrency", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateCurrency(Currency currency);

        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateCurrencyList", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateCurrencyList(CurrencyList currencyList);

        [OperationContract]
        [WebInvoke(UriTemplate = "/NewTriggeredEvent", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void NewTriggeredEvent(TriggeredEvent triggeredEvent);

        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateTriggeredEvent", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateTriggeredEvent(TriggeredEvent triggeredEvent);

        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateTriggeredEventList", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateTriggeredEventList(TriggeredEventList triggeredEventList);

        [OperationContract]
        [WebGet(UriTemplate = "/GetActionList", ResponseFormat = WebMessageFormat.Json)]
        List<Actions> GetActionList();

        [OperationContract]
        [WebGet(UriTemplate = "/GetActiveActionList", ResponseFormat = WebMessageFormat.Json)]
        List<Actions> GetActiveActionList();

        [OperationContract]
        [WebGet(UriTemplate = "/GetActionResponse/{actionId}", ResponseFormat = WebMessageFormat.Json)]
        List<ActionResponse> GetActionResponse(string actionId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetActionResponseWithoutRespondAndQuote/{actionId}/{supplieractionId}", ResponseFormat = WebMessageFormat.Json)]
        List<ActionResponse> GetActionResponseWithoutRespondAndQuote(string actionId, string supplieractionId);

        [OperationContract]
        [WebGet(UriTemplate = "/ApplicationAuthenticationList/{ownerId}", ResponseFormat = WebMessageFormat.Json)]
        List<ApplicationAuthentication> ApplicationAuthenticationList(string ownerId);

        [OperationContract]
        [WebGet(UriTemplate = "/TriggeredEventList", ResponseFormat = WebMessageFormat.Json)]
        List<TriggeredEvent> TriggeredEventList();

        [OperationContract]
        [WebInvoke(UriTemplate = "/CheckCurrency", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        string CheckCurrency(Currency currency);

        [OperationContract]
        [WebGet(UriTemplate = "/GetAdminTrasactionSummary", ResponseFormat = WebMessageFormat.Json)]
        List<AdminTransactionHistory> GetAdminTrasactionSummary();

        [OperationContract]
        [WebInvoke(UriTemplate = "/GetAdminTransaction", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        List<AdminTransactionHistory> GetAdminTransaction(AdminTransactionHistory adminTransactionHistory);

        [OperationContract]
        [WebInvoke(UriTemplate = "/DownloadAdminTransaction", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        string DownloadAdminTransaction(ExportAdminTransactionRequest exportOwnerTransaction);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SendContactMail", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void SendContactMail(ContactUs contactUs);
        #endregion

        #region Community Owner
        [OperationContract]
        [WebInvoke(UriTemplate = "/RegisterOwner", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        int RegisterOwner(Owner owner);

        [OperationContract]
        [WebGet(UriTemplate = "/CheckOwnerEmail/{ownerId}/{email}", ResponseFormat = WebMessageFormat.Json)]
        string CheckOwnerEmail(string ownerId, string email);

        [OperationContract]
        [WebGet(UriTemplate = "/GetOwner/{ownerId}", ResponseFormat = WebMessageFormat.Json)]
        Owner GetOwner(string ownerId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateOwner", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateOwner(Owner owner);

        [OperationContract]
        [WebGet(UriTemplate = "/ActivateAPIToken/{applicationId}", ResponseFormat = WebMessageFormat.Json)]
        void ActivateAPIToken(string applicationId);

        [OperationContract]
        [WebGet(UriTemplate = "/DeactivateAPIToken/{applicationId}", ResponseFormat = WebMessageFormat.Json)]
        void DeactivateAPIToken(string applicationId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/RegisterApplication", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void RegisterApplication(ApplicationAuthentication applicationAuthentication);

        [OperationContract]
        [WebGet(UriTemplate = "/ResetAPIToken/{applicationId}", ResponseFormat = WebMessageFormat.Json)]
        void ResetAPIToken(string applicationId);

        [OperationContract]
        [WebGet(UriTemplate = "/ResendAPIToken/{applicationId}/{apiToken}", ResponseFormat = WebMessageFormat.Json)]
        void ResendAPIToken(string applicationId, string apiToken);

        [OperationContract]
        [WebInvoke(UriTemplate = "/FindCustomerTransaction", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        List<CustomerTransactionResponse> FindCustomerTransaction(TransactionSearch transactionSearch);

        [OperationContract]
        [WebInvoke(UriTemplate = "/FindSupplierTransaction", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        List<SupplierTransactionResponse> FindSupplierTransaction(TransactionSearch transactionSearch);

        [OperationContract]
        [WebGet(UriTemplate = "/GetOwnerCommunityMenu/{ownerId}", ResponseFormat = WebMessageFormat.Json)]
        List<MenuItem> GetOwnerCommunityMenu(string ownerId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetOwnerAccountSummary/{ownerId}", ResponseFormat = WebMessageFormat.Json)]
        List<CommunityOwnerTransactionHistory> GetOwnerAccountSummary(string ownerId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/DownloadCommunityOwnerTransaction", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        string DownloadCommunityOwnerTransaction(ExportCommunityOwnerTransactionRequest exportOwnerTransaction);

        [OperationContract]
        [WebInvoke(UriTemplate = "/GetCommunityOwnerTransaction", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        List<CommunityOwnerTransactionHistory> GetCommunityOwnerTransaction(CommunityOwnerTransactionHistory communityOwnerTransactionHistory);

        [OperationContract]
        // [WebGet(UriTemplate = "/CheckApplicationName/{applicationName}", ResponseFormat = WebMessageFormat.Json)]
        [WebInvoke(UriTemplate = "/CheckApplicationName", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        string CheckApplicationName(SearchRequest searchRequest);

        [OperationContract]
        [WebGet(UriTemplate = "/GetOwnerAccountBalance/{ownerId}/{communityId}", ResponseFormat = WebMessageFormat.Json)]
        decimal GetOwnerAccountBalance(string ownerId, string communityId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetAllOwner", ResponseFormat = WebMessageFormat.Json)]
        List<Owner> GetAllOwner();
        #endregion

        #region Community Group
        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateCommunityGroup", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateCommunityGroup(CommunityGroup communityGroup);

        //[OperationContract]
        //void UpdateCommunityGroupBillingFee(CommunityGroupBillingFee communityGroupBillingFee);

        [OperationContract]
        [WebInvoke(UriTemplate = "/NewCommunityGroup", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        int NewCommunityGroup(CommunityGroup communityGroup);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SupplierJoinCommunityGroup", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void SupplierJoinCommunityGroup(CommunityGroupSupplier communityGroupSupplier);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SupplierLeaveCommunityGroup", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void SupplierLeaveCommunityGroup(CommunityGroupSupplier communityGroupSupplier);

        //[OperationContract]
        //CommunityGroup FindCommunityGroup(string strSerachTerm, int communityId);


        [OperationContract]
        [WebInvoke(UriTemplate = "/FindCommunityGroupBySupplier", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        List<CommunityGroup> FindCommunityGroupBySupplier(CommunitySearchRequest communitySearchRequest);


        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityGroup/{communityGroupId}", ResponseFormat = WebMessageFormat.Json)]
        CommunityGroup GetCommunityGroup(string communityGroupId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityGroupByIDAndOwner/{ownerId}/{communityId}/{communityGroupId}", ResponseFormat = WebMessageFormat.Json)]
        CommunityGroup GetCommunityGroupByIDAndOwner(string ownerId, string communityId, string communityGroupId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierCommunityCommunityGroupList/{strSupplierID}", ResponseFormat = WebMessageFormat.Json)]
        List<CommunityGroup> GetSupplierCommunityCommunityGroupList(string strSupplierID);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityGroupSummaryByCommunity/{communityId}/{communityGroupActive}", ResponseFormat = WebMessageFormat.Json)]
        List<CommunityGroup> GetCommunityGroupSummaryByCommunity(string communityId, string communityGroupActive);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityGroupSummary/{communityGroupId}", ResponseFormat = WebMessageFormat.Json)]
        CommunityGroup GetCommunityGroupSummary(string communityGroupId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityGroupListByCommunity/{communityId}", ResponseFormat = WebMessageFormat.Json)]
        List<CommunityGroup> GetCommunityGroupListByCommunity(string communityId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityGroupBillingFeeList/{communityGroupId}", ResponseFormat = WebMessageFormat.Json)]
        List<CommunityGroupBillingFee> GetCommunityGroupBillingFeeList(string communityGroupId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/AddCommunityGroupBillingFee", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void AddCommunityGroupBillingFee(CommunityGroupBillingFee communityGroupBillingFee);

        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateCommunityGroupBillingFee", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateCommunityGroupBillingFee(CommunityGroupBillingFee communityGroupBillingFee);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityGroupRewardList/{communityGroupId}", ResponseFormat = WebMessageFormat.Json)]
        List<CommunityGroupReward> GetCommunityGroupRewardList(string communityGroupId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/AddCommunityGroupRewardPoint", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void AddCommunityGroupRewardPoint(CommunityGroupReward communityGroupReward);

        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateCommunityGroupRewardPoint", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateCommunityGroupRewardPoint(CommunityGroupReward communityGroupReward);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierCommunityGroupByCommunity/{supplierId}/{communityId}", ResponseFormat = WebMessageFormat.Json)]
        List<CommunityGroup> GetSupplierCommunityGroupByCommunity(string supplierId, string communityId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityGroupMenu/{communityId}", ResponseFormat = WebMessageFormat.Json)]
        List<MenuItem> GetCommunityGroupMenu(string communityId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateCommunityGroupRewardList", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateCommunityGroupRewardList(CommunityGroupRewardList rewardList);

        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateCommunityGroupBillingFeeList", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateCommunityGroupBillingFeeList(CommunityGroupFeeList billingFeeList);

        [OperationContract]
        [WebGet(UriTemplate = "/GetAllSupplierCommunityGroupByCommunity/{supplierId}/{communityId}", ResponseFormat = WebMessageFormat.Json)]
        List<CommunityGroup> GetAllSupplierCommunityGroupByCommunity(string supplierId, string communityId);

        [OperationContract]
        //  [WebGet(UriTemplate = "/CheckCommunityGroupNameExist/{communityGroupId}/{communityId}/{name}", ResponseFormat = WebMessageFormat.Json)]
        [WebInvoke(UriTemplate = "/CheckCommunityGroupNameExist", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        string CheckCommunityGroupNameExist(SearchRequest searchRequest);

        #endregion

        #region Community
        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunity/{communityId}", ResponseFormat = WebMessageFormat.Json)]
        Community GetCommunity(string communityId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityByIDAndOwner/{ownerId}/{communityId}", ResponseFormat = WebMessageFormat.Json)]
        Community GetCommunityByIDAndOwner(string ownerId, string communityId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/NewCommunity", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        Community NewCommunity(Community community);

        [OperationContract]
        [WebInvoke(UriTemplate = "/CheckCommunityNameExist", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        string CheckCommunityNameExist(SearchRequest searchRequest);

        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateCommunity", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateCommunity(Community community);

        [OperationContract]
        [WebGet(UriTemplate = "/FindCommunity/{searchTerm}/{searchDistance}/{referenceLongitude}/{referenceLatitude}", ResponseFormat = WebMessageFormat.Json)]
        List<Community> FindCommunity(string searchTerm, string searchDistance, string referenceLongitude, string referenceLatitude);

        [OperationContract]
        [WebInvoke(UriTemplate = "/FindCommunityBySupplier", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        List<Community> FindCommunityBySupplier(CommunitySearchRequest communitySearchRequest);

        [OperationContract]
        [WebGet(UriTemplate = "/CancelSupplierCommunityMembership/{id}/{entity}/{communityId}", ResponseFormat = WebMessageFormat.Json)]
        void CancelSupplierCommunityMembership(string id, string entity, string communityId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunitySummaryListByOwner/{ownerId}/{communityActive}", ResponseFormat = WebMessageFormat.Json)]
        List<Community> GetCommunitySummaryListByOwner(string ownerId, string communityActive);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunitySummary/{communityId}", ResponseFormat = WebMessageFormat.Json)]
        Community GetCommunitySummary(string communityId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunitySummaryByIDAndOwner/{ownerId}/{communityId}", ResponseFormat = WebMessageFormat.Json)]
        Community GetCommunitySummaryByIDAndOwner(string ownerId, string communityId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityListByOwner/{ownerId}", ResponseFormat = WebMessageFormat.Json)]
        List<Community> GetCommunityListByOwner(string ownerId);

        [OperationContract]
        [WebGet(UriTemplate = "/CommunityList", ResponseFormat = WebMessageFormat.Json)]
        List<Community> CommunityList();

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunitySupplier/{supplierId}/{communityId}", ResponseFormat = WebMessageFormat.Json)]
        CommunitySupplier GetCommunitySupplier(string supplierId, string communityId);

        [OperationContract]
        [WebGet(UriTemplate = "/CommunityListBySupplier/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        List<Community> CommunityListBySupplier(string supplierId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityListByCurrency/{currencyId}", ResponseFormat = WebMessageFormat.Json)]
        List<Community> GetCommunityListByCurrency(string currencyId);
        #endregion

        #region Supplier
        [OperationContract]
        [WebInvoke(UriTemplate = "/RegisterSupplier", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        int RegisterSupplier(Supplier supplier);

        [OperationContract]
        [WebGet(UriTemplate = "/CheckSupplierEmail/{supplierId}/{email}", ResponseFormat = WebMessageFormat.Json)]
        string CheckSupplierEmail(string supplierId, string email);

        [OperationContract]
        // [WebGet(UriTemplate = "/CheckSupplierCompanyName/{supplierId}/{companyName}", ResponseFormat = WebMessageFormat.Json)]
        [WebInvoke(UriTemplate = "/CheckSupplierCompanyName", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        string CheckSupplierCompanyName(SearchRequest searchRequest);

        //[OperationContract]
        //int NewCustomerSupplier(Supplier supplier);

        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateSupplier", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        bool UpdateSupplier(Supplier supplier);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplier/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        Supplier GetSupplier(string supplierId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetAllSupplier", ResponseFormat = WebMessageFormat.Json)]
        List<Supplier> GetAllSupplier();

        //[OperationContract]
        //List<Supplier> FindSupplier(string searchTerm, int communityId, int communityGroupId, string filter);        

        #region Supplier Icon
        [OperationContract]
        [WebInvoke(UriTemplate = "/SupplierIconInsert", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void SupplierIconInsert(SupplierIcon supplierIcon);

        [OperationContract]
        [WebGet(UriTemplate = "/SupplierIconSelect/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        SupplierIcon SupplierIconSelect(string supplierId);

        [OperationContract]
        [WebGet(UriTemplate = "/RemoveSupplierIcon/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        void RemoveSupplierIcon(string supplierId);

        #endregion

        #region Supplier Logo
        //[OperationContract]
        //void SupplierLogoInsert(SupplierLogo supplierLogo);

        [OperationContract]
        [WebGet(UriTemplate = "/SupplierLogoSelect/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        SupplierLogo SupplierLogoSelect(string supplierId);

        [OperationContract]
        [WebGet(UriTemplate = "/RemoveSupplierLogo/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        void RemoveSupplierLogo(string supplierId);
        #endregion

        //[OperationContract]
        //void UpdateShortList(SupplierShortlist supplierShortlist);

        [OperationContract]
        [WebInvoke(UriTemplate = "/AddSupplierSocial", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void AddSupplierSocial(SupplierSocialReference supplierSocialReference);

        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateSupplierSocial", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateSupplierSocial(SupplierSocialReference supplierSocialReference);

        [OperationContract]
        [WebInvoke(UriTemplate = "/InsertSupplierNote", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void InsertSupplierNote(SupplierCustomerNote supplierCustomerNote);

        [OperationContract]
        [WebGet(UriTemplate = "/RemoveSupplierSocial/{supplierSocialReferenceId}", ResponseFormat = WebMessageFormat.Json)]
        void RemoveSupplierSocial(string supplierSocialReferenceId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierActionByCustomer/{strSupplierID}/{strCustomerID}", ResponseFormat = WebMessageFormat.Json)]
        List<SupplierAction> GetSupplierActionByCustomer(string strSupplierID, string strCustomerID);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSocialMedia", ResponseFormat = WebMessageFormat.Json)]
        List<SocialMedia> GetSocialMedia();

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierSocialReference/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        List<SupplierSocialReference> GetSupplierSocialReference(string supplierId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierCommunityMembershipCount/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        SupplierCommunityCount GetSupplierCommunityMembershipCount(string supplierId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityListBySupplier/{supplierId}/{isActive}", ResponseFormat = WebMessageFormat.Json)]
        List<SupplierCommunityGroupCount> GetCommunityListBySupplier(string supplierId, string isActive);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityDetailBySupplierId/{communityId}/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        CommunityDetailResponse GetCommunityDetailBySupplierId(string communityId, string supplierId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/NewSupplierCommunityMembership", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void NewSupplierCommunityMembership(CommunitySupplier communitySupplier);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityListActiveBySupplier/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        List<MenuItem> GetCommunityListActiveBySupplier(string supplierId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierReviewCount/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        List<MenuItem> GetSupplierReviewCount(string supplierId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierReview/{ownerId}/{communityId}/{communityGroupId}/{supplierId}/{customerId}", ResponseFormat = WebMessageFormat.Json)]
        SupplierReviewResponse GetSupplierReview(string ownerId, string communityId, string communityGroupId, string supplierId, string customerId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierReviewBySupplier/{ownerId}/{communityId}/{communityGroupId}/{supplierId}/{customerId}/{loggedinSupplierId}", ResponseFormat = WebMessageFormat.Json)]
        SupplierReviewResponse GetSupplierReviewBySupplier(string ownerId, string communityId, string communityGroupId, string supplierId, string customerId, string loggedinSupplierId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/AddReviewResponse", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void AddReviewResponse(ReviewResponse reviewResponse);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityGroupDetailBySupplier/{communityGroupId}/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        CommunityGroupDetailResponse GetCommunityGroupDetailBySupplier(string communityGroupId, string supplierId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityGroupListActiveBySupplier/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        List<MenuItem> GetCommunityGroupListActiveBySupplier(string supplierId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierCredit/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        List<CommunitySupplier> GetSupplierCredit(string supplierId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityGroupReviewListBySupplierRating/{communityGroupId}/{supplierId}/{ratingType}", ResponseFormat = WebMessageFormat.Json)]
        List<CommunityGroupDetailChildResponse> GetCommunityGroupReviewListBySupplierRating(string communityGroupId, string supplierId, string ratingType);

        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateReviewHide", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateReviewHide(Review review);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCommunityCommunityGroupBySupplier/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        List<SupplierDashboardResponse> GetCommunityCommunityGroupBySupplier(string supplierId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/DownloadSupplierCommunityTransaction", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        string DownloadSupplierCommunityTransaction(ExportSupplierCommunityTransactionRequest exportSupplierCommunityTransaction);

        [OperationContract]
        [WebInvoke(UriTemplate = "/GetSupplierCommunityTransaction", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        List<SupplierCommunityTransactionHistory> GetSupplierCommunityTransaction(SupplierCommunityTransactionHistory supplierCommunityTransactionHistory);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierSocialReferenceBySocialMedia/{supplierId}/{socialMediaId}", ResponseFormat = WebMessageFormat.Json)]
        SupplierSocialReference GetSupplierSocialReferenceBySocialMedia(string supplierId, string socialMediaId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierAction/{supplierId}/{communityGroupId}", ResponseFormat = WebMessageFormat.Json)]
        SupplierActivity GetSupplierAction(string supplierId, string communityGroupId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierActionBySupplierActionId/{supplierId}/{communityGroupId}/{supplierActionId}", ResponseFormat = WebMessageFormat.Json)]
        SupplierActivity GetSupplierActionBySupplierActionId(string supplierId, string communityGroupId, string supplierActionId);

        [OperationContract]
        [WebGet(UriTemplate = "/SupplierActionCountMenu/{supplierId}", ResponseFormat = WebMessageFormat.Json)]
        List<MenuItem> SupplierActionCountMenu(string supplierId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SendCustomerQuote", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void SendCustomerQuote(CustomerQuote customerQuote);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierActionByActionId/{supplierActionId}", ResponseFormat = WebMessageFormat.Json)]
        SupplierAction GetSupplierActionByActionId(string supplierActionId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierParentActionByActionId/{supplierActionId}", ResponseFormat = WebMessageFormat.Json)]
        SupplierAction GetSupplierParentActionByActionId(string supplierActionId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SendCustomerQuoteDetail", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void SendCustomerQuoteDetail(CustomerSupplierCommunication customerSupplierCommunication);

        //[OperationContract]
        //[WebInvoke(UriTemplate = "/SendCustomerReply", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        //void SendCustomerReply(CustomerSupplierCommunication customerSupplierCommunication);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SendCustomerAnswer", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void SendCustomerAnswer(CustomerSupplierCommunication customerSupplierCommunication);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierReviewPendingCountByGroup/{supplierId}/{communityGroupId}", ResponseFormat = WebMessageFormat.Json)]
        int GetSupplierReviewPendingCountByGroup(string supplierId, string communityGroupId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierReviewHeader/{communityId}/{communityGroupId}/{supplierId}/{ownerId}/{loggedinSupplierId}", ResponseFormat = WebMessageFormat.Json)]
        MenuItem GetSupplierReviewHeader(string communityId, string communityGroupId, string supplierId, string ownerId, string loggedinSupplierId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateBillFreeEndDate", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateBillFreeEndDate();

        [OperationContract]
        [WebGet(UriTemplate = "/GetSupplierAccountBalance/{supplierId}/{communityId}", ResponseFormat = WebMessageFormat.Json)]
        decimal GetSupplierAccountBalance(string supplierId, string communityId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SupplierMonthlyBill", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void SupplierMonthlyBill(SupplierCommunityTransactionHistory supplierTransactionHistoryRequest);
        #endregion

        #region Bank Account
        [OperationContract]
        [WebInvoke(UriTemplate = "/UpdateBankAccount", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void UpdateBankAccount(BankAccount bankAccount);

        [OperationContract]
        [WebGet(UriTemplate = "/GetBankingDetails/{id}/{entity}", ResponseFormat = WebMessageFormat.Json)]
        BankAccount GetBankingDetails(string id, string entity);

        [OperationContract]
        [WebInvoke(UriTemplate = "/DebitVirtualCommunityAccount", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        VirtualCommunityAccount DebitVirtualCommunityAccount(VirtualCommunityAccount virtualCommunityAccount);

        [OperationContract]
        [WebInvoke(UriTemplate = "/CreditVirtualCommunityAccount", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        VirtualCommunityAccount CreditVirtualCommunityAccount(VirtualCommunityAccount virtualCommunityAccount);

        //[OperationContract]
        //VirtualCommunityAccount GetTransactionHistory(int transactionHistoryId, string entity);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SendCustomerMessage", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void SendCustomerMessage(CustomerSupplierCommunication customerSupplierCommunication);


        [OperationContract]
        [WebInvoke(UriTemplate = "/SendCustomerMoreInfo", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void SendCustomerMoreInfo(CustomerSupplierCommunication customerSupplierCommunication);

        [OperationContract]
        [WebInvoke(UriTemplate = "/NewCustomerTransaction", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void NewCustomerTransaction(VirtualCommunityAccount virtualCommunityAccount);

        [OperationContract]
        [WebGet(UriTemplate = "/GetPaypalTransaction/{transactionId}", ResponseFormat = WebMessageFormat.Json)]
        PaypalTransaction GetPaypalTransaction(string transactionId);

        #endregion

        #region Customer

        [OperationContract]
        [WebGet(UriTemplate = "/GetAllCustomer", ResponseFormat = WebMessageFormat.Json)]
        List<Customer> GetAllCustomer();

        //[OperationContract]
        //void UpdateCustomer(Customer customer);

        //[OperationContract]
        //Customer GetCustomer(int customerId);

        //[OperationContract]
        //List<Customer> FindCustomer(string searchTerm, int communityId, int supplierId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SubmitCustomerReview", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        int SubmitCustomerReview(Review review);

        //[OperationContract]
        //Review GetCustomerReview(int reviewId);

        //[OperationContract]
        //List<Review> GetCustomerReviews(int supplierId, int communityId, int communityGroupId);

        //[OperationContract]
        //void ReviewHelpful(ReviewHelpful reviewHelpful);

        //[OperationContract]
        //List<ReviewResponse> GetReviewResponse(int reviewId);

        //[OperationContract]
        //void InsertCustomerNote(SupplierCustomerNote supplierCustomerNote);

        //[OperationContract]
        //void CustomerJoinCommunity(CommunitySupplier communitySupplier);

        //[OperationContract]
        //CustomerRewards GetCustomerRewards(int customerId, int communityId);

        //[OperationContract]
        //CustomerPointsTally GetCustomerRewardsTally(int customerId, int communityId);

        [OperationContract]
        [WebInvoke(UriTemplate = "/FindCustomerBySupplier", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        List<Customer> FindCustomerBySupplier(CustomerSearchRequest customerSearchRequest);

        [OperationContract]
        [WebInvoke(UriTemplate = "/AddCustomerSupplierCommunication", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void AddCustomerSupplierCommunication(CustomerSupplierCommunication customerSupplierCommunication);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SendSupplierQuestion", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void SendSupplierQuestion(CustomerSupplierCommunication customerSupplierCommunication);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SendMessage", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void SendMessage(CustomerSupplierCommunication customerSupplierCommunication);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SendQuoteRequest", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        CustomerSupplierCommunication SendQuoteRequest(CustomerSupplierCommunication customerSupplierCommunication);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCustomerQuote/{quoteId}", ResponseFormat = WebMessageFormat.Json)]
        CustomerQuote GetCustomerQuote(string quoteId);

        [OperationContract]
        [WebGet(UriTemplate = "/GetCustomerQuoteByParentSupplierActionId/{supplierActionId}", ResponseFormat = WebMessageFormat.Json)]
        CustomerQuote GetCustomerQuoteByParentSupplierActionId(string supplierActionId);

        [OperationContract]
        [WebGet(UriTemplate = "/DownloadSupplierActionAttachment/{supplierActionId}", ResponseFormat = WebMessageFormat.Json)]
        string DownloadSupplierActionAttachment(string supplierActionId);
        #endregion

        #region TestMethods
        [WebGet(UriTemplate = "/SampleGetMethod", ResponseFormat = WebMessageFormat.Json)]
        [RequireUserAuthentication]
        ServiceResponseBase SampleGetMethod();

        [OperationContract]
        [WebInvoke(UriTemplate = "/SamplePostMethod", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        [RequireUserAuthentication]
        ServiceResponseBase SamplePostMethod(ServiceRequestBase request);

        #endregion

        [OperationContract]
        [WebInvoke(UriTemplate = "/PaymentTransaction", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        void PaymentTransaction(PaymentRequest paymentRequest);

        [OperationContract]
        [WebInvoke(UriTemplate = "/PayflowPayment", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        PaypalTransaction PayflowPayment(PaymentProcessRequest paymentProcess);

        [OperationContract]
        [WebInvoke(UriTemplate = "/PayflowPaypalPayment", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        PaypalTransaction PayflowPaypalPayment(PaymentProcessRequest paymentProcess);

        [OperationContract]
        [WebInvoke(UriTemplate = "/PayflowPaypalPaymentConfirm", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        PaypalTransaction PayflowPaypalPaymentConfirm(PaymentProcessRequest paymentProcess);

    }

    [DataContract]
    public class RatingReviewEngineException
    {
        private string strErrorMessage = string.Empty;

        public RatingReviewEngineException(string strMessage)
        {
            this.strErrorMessage = strMessage;
        }

        [DataMember]
        public string ErrorMessage
        {
            get { return this.strErrorMessage; }
            set { this.strErrorMessage = value; }
        }
    }
}
