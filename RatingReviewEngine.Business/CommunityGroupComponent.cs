using RatingReviewEngine.DAC;
using RatingReviewEngine.Entities;
using System.Collections.Generic;

namespace RatingReviewEngine.Business
{
    public class CommunityGroupComponent
    {
        /// <summary>
        /// Update the existing community group record with the supplied details (CommunityGroup)
        /// </summary>
        public void CommunityGroupUpdate(CommunityGroup communityGroup)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            communityGroupDAC.CommunityGroupUpdate(communityGroup);
        }

        /// <summary>
        /// Insert a new community group for the given community with the supplied details (CommunityGroup)
        /// </summary>
        public int CommunityGroupInsert(CommunityGroup communityGroup)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            return communityGroupDAC.CommunityGroupInsert(communityGroup);
        }

        /// <summary>
        /// Link the given Supplier with the given Community Group (CommunityGroupSupplier) and set the DateJoined to 'now' and the IsActive flag to true
        /// </summary>
        public void CommunityGroupJoin(CommunityGroupSupplier communityGroupSupplier)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            communityGroupDAC.CommunityGroupJoin(communityGroupSupplier);
        }


        /// <summary>
        /// 1. Find the relevant CommunityGroupSupplier.CommunityGroupSupplierID from the supplied SupplierID, CommunityID and CommunityGroupID
        /// 2. Deactivate (CommunityGroupSupplier.IsActive = false) the relationship between the supplied Supplier - Community - Community Group (CommunityGroupSupplier)
        /// </summary>
        public void CommunityGroupLeave(CommunityGroupSupplier communityGroupSupplier)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            communityGroupDAC.CommunityGroupLeave(communityGroupSupplier);
        }

        /// <summary>
        /// 1. If the SearchTerm is not null, based on a wildcard search (prepending '%' and appending '%' and replacing any blanks with '%'),
        /// use the supplied search term to search across CommunityGroup.Name and CommunityGroup.Description
        /// 2. If a CommunityID is not null, then retrieve all community groups associated to the given community (communitygroup.CommunityID)
        /// 3. Return the results
        /// </summary>
        public CommunityGroup CommunityGroupSearch(string strSearchTerm, int nCommunityID)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            return communityGroupDAC.CommunityGroupSearch(strSearchTerm, nCommunityID);
        }

        /// <summary>
        /// 1. If the SearchTerm is not null, based on a wildcard search (prepending '%' and appending '%' and replacing any blanks with '%'),
        /// use the supplied search term to search across CommunityGroup.Name and CommunityGroup.Description
        /// 2. If a CommunityID is not null, then retrieve all community groups associated to the given community (communitygroup.CommunityID)
        /// 3. Return the results
        /// </summary>
        /// string searchTerm, string searchDistance, string searchDistanceUnit, string supplierId
        public List<CommunityGroup> CommunityGroupSearchByDistance(string searchTerm, decimal? searchDistance, decimal referenceLongitude, decimal referenceLatitude, int nCommunityId)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            return communityGroupDAC.CommunityGroupSearchByDistance(searchTerm, searchDistance, referenceLongitude, referenceLatitude, nCommunityId);
        }

        /// <summary>
        /// 1. Retrieve the community group record associated to the given CommunityGroupID (CommunityGroup.CommunityGroupID)
        /// 2. Return the results        
        /// </summary>
        public CommunityGroup CommunityGroupSelect(int nCommunityGroupID)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            return communityGroupDAC.CommunityGroupSelect(nCommunityGroupID);
        }

        /// <summary>
        /// 1. Retrieve the community group record associated to the given CommunityGroupID (CommunityGroup.CommunityGroupID)
        /// 2. Return the results        
        /// </summary>
        public CommunityGroup CommunityGroupSelectByIDAndOwner(int ownerId, int communityId, int communityGroupId)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            return communityGroupDAC.CommunityGroupSelectByIDAndOwner(ownerId, communityId, communityGroupId);
        }
        /// <summary>
        /// Delete Community group from table (Unit test purpose)
        /// </summary>
        /// <param name="nCommunityGroupId"></param>
        public void CommunityGroupDelete(int nCommunityGroupId)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            communityGroupDAC.CommunityGroupDelete(nCommunityGroupId);
        }

        /// <summary>
        /// Get all Community group list.
        /// </summary>
        /// <returns></returns>
        public List<CommunityGroup> SupplierCommunityCommunityGroupList(int nSupplierID)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            return communityGroupDAC.SupplierCommunityCommunityGroupList(nSupplierID);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public List<CommunityGroup> CommunityGroupSummaryByCommunity(int communityId, bool communityGroupActive)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            return communityGroupDAC.CommunityGroupSummaryByCommunity(communityId, communityGroupActive);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="communityGroupId"></param>
        /// <returns></returns>
        public CommunityGroup CommunityGroupSummary(int communityGroupId)
        {
            CommunityGroupDAC communityDAC = new CommunityGroupDAC();
            return communityDAC.CommunityGroupSummary(communityGroupId);
        }

        /// <summary>
        /// Get list of Community group by Community
        /// </summary>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public List<CommunityGroup> CommunityGroupSelectByCommunity(int communityId)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            return communityGroupDAC.CommunityGroupSelectByCommunity(communityId);
        }

        /// <summary>
        /// Update the given community group billing fee record with the supplied details (CommunityGroupBillingFee)
        /// </summary>
        public void CommunityGroupBillingFeeUpdate(CommunityGroupBillingFee communityGroupBillingFee)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            communityGroupDAC.CommunityGroupBillingFeeUpdate(communityGroupBillingFee);
        }

        /// <summary>
        /// Insert the given community group billing fee record with the supplied details (CommunityGroupBillingFee)
        /// </summary>
        public void CommunityGroupBillingFeeInsert(CommunityGroupBillingFee communityGroupBillingFee)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            communityGroupDAC.CommunityGroupBillingFeeInsert(communityGroupBillingFee);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="communityGroupId"></param>
        /// <returns></returns>
        public List<CommunityGroupBillingFee> CommunityGroupBillingFeeSelect(int communityGroupId)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            return communityGroupDAC.CommunityGroupBillingFeeSelect(communityGroupId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="communityGroupId"></param>
        /// <returns></returns>
        public List<CommunityGroupReward> CommunityGroupRewardSelect(int communityGroupId)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            return communityGroupDAC.CommunityGroupRewardSelect(communityGroupId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="communityGroupReward"></param>
        public void CommunityGroupRewardInsert(CommunityGroupReward communityGroupReward)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            communityGroupDAC.CommunityGroupRewardInsert(communityGroupReward);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="communityGroupReward"></param>
        public void CommunityGroupRewardUpdate(CommunityGroupReward communityGroupReward)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            communityGroupDAC.CommunityGroupRewardUpdate(communityGroupReward);
        }

        public List<CommunityGroup> SupplierCommunityGroupByCommunity(int supplierId, int communityId)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            return communityGroupDAC.SupplierCommunityGroupByCommunity(supplierId, communityId);
        }

        /// <summary>
        /// Retrieves list of community groups based on communityId.
        /// </summary>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public List<MenuItem> CommunityGroupListMenu(int communityId)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            return communityGroupDAC.CommunityGroupListMenu(communityId);
        }

        /// <summary>
        /// get all community group supplier
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public List<CommunityGroup> SupplierCommunityGroupSelectAllByCommunity(int supplierId, int communityId)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            return communityGroupDAC.SupplierCommunityGroupSelectAllByCommunity(supplierId, communityId);
        }

        /// <summary>
        /// Check Community group name is already exist. If exist return 1 else return 0.
        /// For create send communitygroupId as 0
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public string CheckCommunityGroupNameExist(int communityGroupId, int communityId, string name)
        {
            CommunityGroupDAC communityGroupDAC = new CommunityGroupDAC();
            return communityGroupDAC.CheckCommunityGroupNameExist(communityGroupId, communityId, name);
        }
    }
}
