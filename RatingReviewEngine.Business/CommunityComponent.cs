using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using RatingReviewEngine.DAC;
using RatingReviewEngine.Entities;

namespace RatingReviewEngine.Business
{
    public class CommunityComponent
    {
        /// <summary>
        /// 1. Insert a new community record with the supplied details (Community)
        /// </summary>
        /// <param name="community"></param>
        /// <returns></returns>
        public Community CommunityInsert(Community community)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            //Assign the community id property from the newly inserted record
            community.CommunityID = communityDAC.CommunityInsert(community);
            return community;
        }

        /// <summary>
        /// 1. Update the existing community record with the supplied details (Community)
        /// </summary>
        /// <param name="community"></param>
        public void CommunityUpdate(Community community)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            communityDAC.CommunityUpdate(community);
        }

        public void CommunityDelete(int communityId)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            communityDAC.CommunityDelete(communityId);
        }

        /// <summary>
        ///  RRetrieve the details of the given CommunityID from the Community table 
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public Community CommunitySelect(int communityId)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            return communityDAC.CommunitySelect(communityId);
        }

        /// <summary>
        /// Retrieve the details of the given OwnerID and CommunityID from the Community table 
        /// </summary>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public Community CommunitySelectByIdAndOwner(int ownerId, int communityId)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            return communityDAC.CommunitySelectByIdAndOwner(ownerId, communityId);
        }
        /// <summary>
        /// 1. If the SearchTerm is not null, based on a wildcard search (prepending '%' and appending '%' and replacing any blanks with '%'), use the supplied search term to search across Community.Name and Community.Description)
        /// 2. If SearchDistance is not null, using the ReferenceLongitude, ReferenceLatitude & SearchDistance, retrieve communities that have a Community.CentreLongitude 
        /// and Community.CentreLatitude point no further away than the supplied SearchDistance.
        /// </summary>
        /// <param name="searchTerm"></param>
        /// <param name="searchDistance"></param>
        /// <param name="referenceLongitude"></param>
        /// <param name="referenceLatitude"></param>
        /// <returns></returns>
        public List<Community> CommunitySearch(string searchTerm, decimal? searchDistance, decimal referenceLongitude, decimal referenceLatitude)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            return communityDAC.CommunitySearch(searchTerm, searchDistance, referenceLongitude, referenceLatitude);
        }

        /// <summary>
        /// Link the given Supplier with the given Community (CommunitySupplier) and set the DateJoined to 'now' and the IsActive flag to true
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="communityId"></param>
        /// <param name="autoTransferAmtSupplier"></param>
        /// <param name="autoTopUp"></param>
        /// <param name="minCredit"></param>
        public void CommunityJoin(CommunitySupplier communitySupplier)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            communityDAC.CommunityJoin(communitySupplier);
            return;
        }

        /// <summary>
        /// 1. Find the relevant CommunitySupplier.CommunitySupplierID from the supplied SupplierID and CommunityID
        /// 2. Deactivate (CommunitySupplier.IsActive = false) the relationship between the supplied Supplier - Community (CommunitySupplier)
        /// </summary>
        /// <param name="id"></param>
        /// <param name="entity"></param>
        /// <param name="communityId"></param>
        public void CommunityLeave(int id, string entity, int communityId)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            communityDAC.CommunityLeave(id, entity, communityId);
            return;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ownerId"></param>
        /// <returns></returns>
        public List<Community> CommunitySummaryByOwner(int ownerId, bool communityActive)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            return communityDAC.CommunitySummaryByOwner(ownerId, communityActive);
        }

        /// <summary>
        /// Check Community name is already exist. If exist return 1 else return 0.
        /// For create send communityId as 0
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public string CheckCommunityNameExist(int communityId, string name)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            return communityDAC.CheckCommunityNameExist(communityId, name);
        }

        public Community CommunitySummary(int communityId)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            return communityDAC.CommunitySummary(communityId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ownerId"></param>
        /// <param name="communityID"></param>
        /// <returns></returns>
        public Community CommunitySummaryByIDAndOwner(int ownerId, int communityId)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            return communityDAC.CommunitySummaryByIDAndOwner(ownerId, communityId);
        }

        /// <summary>
        /// Get list of Community by Owner
        /// </summary>
        /// <param name="ownerId"></param>
        /// <returns></returns>
        public List<Community> CommunitySelectByOwner(int ownerId)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            return communityDAC.CommunitySelectByOwner(ownerId);
        }

        /// <summary>
        /// Retrieves list of all communities.
        /// </summary>
        /// <returns></returns>
        public List<Community> CommunitySelectAll()
        {
            CommunityDAC communityDAC = new CommunityDAC();
            return communityDAC.CommunitySelectAll();
        }

        /// <summary>
        /// Retrieves community details based on supplierId and communityId.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public CommunitySupplier CommunitySupplierSelect(int supplierId, int communityId)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            return communityDAC.CommunitySupplierSelect(supplierId, communityId);
        }

        /// <summary>
        /// Get list of community by supplier
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<Community> CommunitySelectBySupplier(int supplierId)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            return communityDAC.CommunitySelectBySupplier(supplierId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="currencyId"></param>
        /// <returns></returns>
        public List<Community> CommunitySelectByCurrency(int currencyId)
        {
            CommunityDAC communityDAC = new CommunityDAC();
            return communityDAC.CommunitySelectByCurrency(currencyId);
        }
    }
}
