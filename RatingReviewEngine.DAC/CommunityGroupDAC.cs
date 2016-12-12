using System;
using System.Data;
using System.Data.Common;
using Microsoft.Practices.EnterpriseLibrary.Data;
using RatingReviewEngine.Entities;
using System.Collections.Generic;
using System.Web;

namespace RatingReviewEngine.DAC
{
    public class CommunityGroupDAC : DataAccessComponent
    {
        Database objDb = DatabaseFactory.CreateDatabase(CONNECTION_NAME);

        /// <summary>
        /// Insert a new community group for the given community with the supplied details (CommunityGroup)
        /// </summary>
        public int CommunityGroupInsert(CommunityGroup communityGroup)
        {
            DbCommand cmd;

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityGroupInsert"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityGroup.CommunityID);
                objDb.AddInParameter(cmd, "IN_Name", DbType.String, HttpUtility.UrlDecode(communityGroup.Name));
                objDb.AddInParameter(cmd, "IN_Description", DbType.String, HttpUtility.UrlDecode(communityGroup.Description));
                objDb.AddInParameter(cmd, "IN_CreditMin", DbType.Decimal, communityGroup.CreditMin);
                objDb.AddInParameter(cmd, "IN_CurrencyID", DbType.Int32, communityGroup.CurrencyID);
                objDb.AddInParameter(cmd, "IN_Active", DbType.Boolean, communityGroup.Active);
                return Convert.ToInt32(objDb.ExecuteScalar(cmd));
            }
        }

        /// <summary>
        /// Update the existing community group record with the supplied details (CommunityGroup)
        /// </summary>
        public void CommunityGroupUpdate(CommunityGroup communityGroup)
        {
            DbCommand cmd;

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityGroupUpdate"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, communityGroup.CommunityGroupID);
                objDb.AddInParameter(cmd, "IN_Name", DbType.String, HttpUtility.UrlDecode(communityGroup.Name));
                objDb.AddInParameter(cmd, "IN_Description", DbType.String, HttpUtility.UrlDecode(communityGroup.Description));
                objDb.AddInParameter(cmd, "IN_CreditMin", DbType.Decimal, communityGroup.CreditMin);
                objDb.AddInParameter(cmd, "IN_CurrencyID", DbType.Int32, communityGroup.CurrencyID);
                objDb.AddInParameter(cmd, "IN_Active", DbType.Boolean, communityGroup.Active);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Link the given Supplier with the given Community Group (CommunityGroupSupplier) and set the DateJoined to 'now' and the IsActive flag to true
        /// </summary>
        public void CommunityGroupJoin(CommunityGroupSupplier communityGroupSupplier)
        {
            DbCommand cmd;

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityGroupJoin"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, communityGroupSupplier.SupplierID);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityGroupSupplier.CommunityID);
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, communityGroupSupplier.CommunityGroupID);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// 1. Find the relevant CommunityGroupSupplier.CommunityGroupSupplierID from the supplied SupplierID, CommunityID and CommunityGroupID
        /// 2. Deactivate (CommunityGroupSupplier.IsActive = false) the relationship between the supplied Supplier - Community - Community Group (CommunityGroupSupplier)
        /// </summary>
        public void CommunityGroupLeave(CommunityGroupSupplier communityGroupSupplier)
        {
            DbCommand cmd;

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityGroupLeave"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, communityGroupSupplier.SupplierID);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityGroupSupplier.CommunityID);
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, communityGroupSupplier.CommunityGroupID);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// 1. If the SearchTerm is not null, based on a wildcard search (prepending '%' and appending '%' and replacing any blanks with '%'),
        /// use the supplied search term to search across CommunityGroup.Name and CommunityGroup.Description
        /// 2. If a CommunityID is not null, then retrieve all community groups associated to the given community (communitygroup.CommunityID)
        /// 3. Return the results
        /// </summary>
        public CommunityGroup CommunityGroupSearch(string strSearchTerm, int nCommunityID)
        {
            CommunityGroup communityGroup = new CommunityGroup();
            DbCommand cmd;

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityGroupSearch"))
            {
                objDb.AddInParameter(cmd, "IN_SearchTerm", DbType.String, strSearchTerm);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, nCommunityID);
                using (IDataReader drCommunityGroup = objDb.ExecuteReader(cmd))
                {
                    while (drCommunityGroup.Read())
                    {
                        communityGroup.CommunityGroupID = Convert.ToInt32(drCommunityGroup["CommunityGroupID"].ToString());
                        communityGroup.CommunityID = Convert.ToInt32(drCommunityGroup["CommunityID"].ToString());
                        communityGroup.Name = drCommunityGroup["Name"].ToString();
                        communityGroup.Description = drCommunityGroup["Description"].ToString();
                        communityGroup.CreditMin = Convert.ToDecimal(drCommunityGroup["CreditMin"].ToString());
                        communityGroup.CurrencyID = Convert.ToInt32(drCommunityGroup["CurrencyID"].ToString());
                        communityGroup.Active = Convert.ToBoolean(drCommunityGroup["Active"]);
                    }
                }
            }

            return communityGroup;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="searchTerm"></param>
        /// <param name="searchDistance"></param>
        /// <param name="referenceLongitude"></param>
        /// <param name="referenceLatitude"></param>
        /// <param name="nCommunityID"></param>
        /// <returns></returns>
        public List<CommunityGroup> CommunityGroupSearchByDistance(string searchTerm, decimal? searchDistance, decimal referenceLongitude, decimal referenceLatitude, int nCommunityID)
        {
            DbCommand cmd;
            List<CommunityGroup> lstCommunityGroup = new List<CommunityGroup>();
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityGroupSearchByDistance"))
            {
                objDb.AddInParameter(cmd, "IN_SearchTerm", DbType.String,HttpUtility.UrlDecode(searchTerm));
                objDb.AddInParameter(cmd, "IN_SearchDistance", DbType.Decimal, searchDistance);
                objDb.AddInParameter(cmd, "IN_ReferenceLongitude", DbType.Decimal, referenceLongitude);
                objDb.AddInParameter(cmd, "IN_ReferenceLatitude", DbType.Decimal, referenceLatitude);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, nCommunityID);
                using (IDataReader drCommunityGroup = objDb.ExecuteReader(cmd))
                {
                    while (drCommunityGroup.Read())
                    {
                        CommunityGroup communityGroup = new CommunityGroup();

                        communityGroup.CommunityGroupID = Convert.ToInt32(drCommunityGroup["CommunityGroupID"].ToString());
                        communityGroup.CommunityID = Convert.ToInt32(drCommunityGroup["CommunityID"].ToString());
                        communityGroup.Name = drCommunityGroup["Name"].ToString();
                        communityGroup.Description = drCommunityGroup["Description"].ToString();
                        communityGroup.CreditMin = Convert.ToDecimal(drCommunityGroup["CreditMin"].ToString());
                        communityGroup.CurrencyID = Convert.ToInt32(drCommunityGroup["CurrencyID"].ToString());
                        communityGroup.Active = Convert.ToBoolean(drCommunityGroup["Active"]);
                        communityGroup.CommunityName = drCommunityGroup["CommunityName"].ToString();

                        lstCommunityGroup.Add(communityGroup);
                    }
                }
            }

            return lstCommunityGroup;
        }

        /// <summary>
        /// 1. Retrieve the community group record associated to the given CommunityGroupID (CommunityGroup.CommunityGroupID)
        /// 2. Return the results        
        /// </summary>
        public CommunityGroup CommunityGroupSelect(int nCommunityGroupID)
        {
            CommunityGroup communityGroup = new CommunityGroup();
            DbCommand cmd;

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityGroupSelect"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, nCommunityGroupID);
                using (IDataReader drCommunityGroup = objDb.ExecuteReader(cmd))
                {
                    while (drCommunityGroup.Read())
                    {
                        communityGroup.CommunityGroupID = Convert.ToInt32(drCommunityGroup["CommunityGroupID"].ToString());
                        communityGroup.CommunityID = Convert.ToInt32(drCommunityGroup["CommunityID"].ToString());
                        communityGroup.Name = drCommunityGroup["Name"].ToString();
                        communityGroup.Description = drCommunityGroup["Description"].ToString();
                        communityGroup.CreditMin = Convert.ToDecimal(drCommunityGroup["CreditMin"].ToString());
                        communityGroup.CurrencyID = Convert.ToInt32(drCommunityGroup["CurrencyID"].ToString());
                        communityGroup.Active = Convert.ToBoolean(drCommunityGroup["Active"]);
                        communityGroup.CommunityName = drCommunityGroup["communityname"].ToString();
                        communityGroup.CurrencyName = drCommunityGroup["currencyname"].ToString();
                    }
                }
            }

            return communityGroup;
        }

        /// <summary>
        /// 1. Retrieve the community group record associated to the given CommunityGroupID (CommunityGroup.CommunityGroupID)
        /// 2. Return the results        
        /// </summary>
        public CommunityGroup CommunityGroupSelectByIDAndOwner(int ownerId,int communityId, int communityGroupId)
        {
            CommunityGroup communityGroup = new CommunityGroup();
            DbCommand cmd;

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("communiygroupselectbyidandowner"))
            {
                objDb.AddInParameter(cmd, "in_ownerid", DbType.Int32, ownerId);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityId);
                objDb.AddInParameter(cmd, "in_communitygroupid", DbType.Int32, communityGroupId);
                using (IDataReader drCommunityGroup = objDb.ExecuteReader(cmd))
                {
                    while (drCommunityGroup.Read())
                    {
                        communityGroup.CommunityGroupID = Convert.ToInt32(drCommunityGroup["CommunityGroupID"].ToString());
                        communityGroup.CommunityID = Convert.ToInt32(drCommunityGroup["CommunityID"].ToString());
                        communityGroup.Name = drCommunityGroup["Name"].ToString();
                        communityGroup.Description = drCommunityGroup["Description"].ToString();
                        communityGroup.CreditMin = Convert.ToDecimal(drCommunityGroup["CreditMin"].ToString());
                        communityGroup.CurrencyID = Convert.ToInt32(drCommunityGroup["CurrencyID"].ToString());
                        communityGroup.Active = Convert.ToBoolean(drCommunityGroup["Active"]);
                        communityGroup.CommunityName = drCommunityGroup["communityname"].ToString();
                        communityGroup.CurrencyName = drCommunityGroup["currencyname"].ToString();
                    }
                }
            }

            return communityGroup;
        }

        /// <summary>
        /// Update the given community group billing fee record with the supplied details (CommunityGroupBillingFee)
        /// </summary>
        public void CommunityGroupBillingFeeUpdate(CommunityGroupBillingFee communityGroupBillingFee)
        {
            DbCommand cmd;

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("communitygroupbillingfeeupdate"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityGroupBillingFeeID", DbType.Int32, communityGroupBillingFee.CommunityGroupBillingFeeID);
                objDb.AddInParameter(cmd, "IN_Fee", DbType.Decimal, communityGroupBillingFee.Fee);
                objDb.AddInParameter(cmd, "IN_FeeCurrencyID", DbType.Int32, communityGroupBillingFee.FeeCurrencyID);

                objDb.AddInParameter(cmd, "IN_BillFreeDays", DbType.Int32, communityGroupBillingFee.BillFreeDays);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Insert the given community group billing fee record with the supplied details (CommunityGroupBillingFee)
        /// </summary>
        public void CommunityGroupBillingFeeInsert(CommunityGroupBillingFee communityGroupBillingFee)
        {
            DbCommand cmd;

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("communitygroupbillingfeeinsert"))
            {
                objDb.AddInParameter(cmd, "IN_TriggeredEventId", DbType.Int32, communityGroupBillingFee.TriggeredEventID);
                objDb.AddInParameter(cmd, "IN_Communitygroupid", DbType.Int32, communityGroupBillingFee.CommunityGroupID);
                objDb.AddInParameter(cmd, "IN_Fee", DbType.Decimal, communityGroupBillingFee.Fee);
                objDb.AddInParameter(cmd, "IN_FeeCurrencyID", DbType.Int32, communityGroupBillingFee.FeeCurrencyID);

                objDb.AddInParameter(cmd, "IN_BillFreeDays", DbType.Int32, communityGroupBillingFee.BillFreeDays);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Delete Community group from table (Unit test purpose)
        /// </summary>
        /// <param name="nCommunityGroupId"></param>
        public void CommunityGroupDelete(int nCommunityGroupId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("UT_CommunityGroupDelete"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, nCommunityGroupId);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Get all Community group list.
        /// </summary>
        /// <returns></returns>
        public List<CommunityGroup> SupplierCommunityCommunityGroupList(int nSupplierID)
        {
            CommunityGroup communityGroup;
            List<CommunityGroup> lstCommunityGroup = new List<CommunityGroup>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierCommunityCommunityGroupList"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, nSupplierID);

                using (IDataReader drCommunityGroup = objDb.ExecuteReader(cmd))
                {
                    while (drCommunityGroup.Read())
                    {
                        communityGroup = new CommunityGroup();
                        communityGroup.CommunityGroupID = Convert.ToInt32(drCommunityGroup["CommunityGroupID"].ToString());
                        communityGroup.Description = drCommunityGroup["CommunityCommunityGroup"].ToString();

                        lstCommunityGroup.Add(communityGroup);
                    }
                }
            }

            return lstCommunityGroup;
        }

       /// <summary>
       /// 
       /// </summary>
       /// <param name="communityId"></param>
       /// <param name="communitygroupActive"></param>
       /// <returns></returns>
        public List<CommunityGroup> CommunityGroupSummaryByCommunity(int communityId,bool communitygroupActive)
        {
            CommunityGroup communityGroup;
            List<CommunityGroup> lstCommunityGroup = new List<CommunityGroup>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("COMMUNITYGROUPSUMMARYBYCOMMUNITY"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityId);
                objDb.AddInParameter(cmd, "in_communitygroupactive", DbType.Boolean, communitygroupActive);

                using (IDataReader drCommunityGroup = objDb.ExecuteReader(cmd))
                {
                    while (drCommunityGroup.Read())
                    {
                        communityGroup = new CommunityGroup();
                        communityGroup.CommunityGroupID = Convert.ToInt32(drCommunityGroup["CommunityGroupID"].ToString());
                        communityGroup.Name = drCommunityGroup["CommunityGroupName"].ToString();
                        communityGroup.InCreditSuppliersCount = Convert.ToInt32(drCommunityGroup["InCreditCount"].ToString());
                        communityGroup.OutofCreditSuppliersCount = Convert.ToInt32(drCommunityGroup["OutCreditCount"].ToString());
                        communityGroup.BelowMinCreditSuppliersCount = Convert.ToInt32(drCommunityGroup["BelowMinCreditCount"].ToString());
                        communityGroup.CustomersCount = Convert.ToInt32(drCommunityGroup["CustomerCount"].ToString());
                        communityGroup.CurrentRevenue = Convert.ToDecimal(drCommunityGroup["CurrentRevenue"].ToString());
                        communityGroup.CurrencyID = Convert.ToInt32(drCommunityGroup["CurrencyID"].ToString());
                        communityGroup.CurrencyName = drCommunityGroup["CurrencyName"].ToString();

                        lstCommunityGroup.Add(communityGroup);
                    }
                }
            }
            return lstCommunityGroup;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="communityGroupId"></param>
        /// <returns></returns>
        public CommunityGroup CommunityGroupSummary(int communityGroupId)
        {
            CommunityGroup communityGroup = new CommunityGroup();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("COMMUNITYGROUPSUMMARY"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, communityGroupId);

                using (IDataReader drCommunityGroup = objDb.ExecuteReader(cmd))
                {
                    while (drCommunityGroup.Read())
                    {
                        communityGroup.CommunityGroupID = Convert.ToInt32(drCommunityGroup["CommunityGroupID"].ToString());
                        communityGroup.Name = drCommunityGroup["CommunityGroupName"].ToString();
                        communityGroup.InCreditSuppliersCount = Convert.ToInt32(drCommunityGroup["InCreditCount"].ToString());
                        communityGroup.OutofCreditSuppliersCount = Convert.ToInt32(drCommunityGroup["OutCreditCount"].ToString());
                        communityGroup.BelowMinCreditSuppliersCount = Convert.ToInt32(drCommunityGroup["BelowMinCreditCount"].ToString());
                        communityGroup.CustomersCount = Convert.ToInt32(drCommunityGroup["CustomerCount"].ToString());
                        communityGroup.CurrentRevenue = Convert.ToDecimal(drCommunityGroup["CurrentRevenue"].ToString());
                        communityGroup.CurrencyID = Convert.ToInt32(drCommunityGroup["CurrencyID"].ToString());
                        communityGroup.CurrencyName = drCommunityGroup["CurrencyName"].ToString();
                    }
                }
            }
            return communityGroup;
        }

        /// <summary>
        /// Get list of Community group by Community
        /// </summary>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public List<CommunityGroup> CommunityGroupSelectByCommunity(int communityId)
        {
            CommunityGroup communityGroup;
            List<CommunityGroup> lstCommunityGroup = new List<CommunityGroup>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("COMMUNITYGROUPSELECTBYCOMMUNITY"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityId);

                using (IDataReader drCommunityGroup = objDb.ExecuteReader(cmd))
                {
                    while (drCommunityGroup.Read())
                    {
                        communityGroup = new CommunityGroup();
                        communityGroup.CommunityGroupID = Convert.ToInt32(drCommunityGroup["CommunityGroupID"].ToString());
                        communityGroup.CommunityID = Convert.ToInt32(drCommunityGroup["CommunityID"].ToString());
                        communityGroup.Name = drCommunityGroup["Name"].ToString();
                        lstCommunityGroup.Add(communityGroup);
                    }
                }
            }
            return lstCommunityGroup;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="communityGroupId"></param>
        /// <returns></returns>
        public List<CommunityGroupBillingFee> CommunityGroupBillingFeeSelect(int communityGroupId)
        {
            CommunityGroupBillingFee communityGroupbillingFee;
            List<CommunityGroupBillingFee> lstCommunityGroupBillingFee = new List<CommunityGroupBillingFee>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("COMMUNITYGROUPBILLINGFEESELECT"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, communityGroupId);
                using (IDataReader drCommunityGroupBill = objDb.ExecuteReader(cmd))
                {
                    while (drCommunityGroupBill.Read())
                    {
                        communityGroupbillingFee = new CommunityGroupBillingFee();
                        communityGroupbillingFee.CommunityGroupID = communityGroupId;
                        communityGroupbillingFee.CommunityGroupBillingFeeID = Convert.ToInt32(drCommunityGroupBill["communitygroupbillingfeeid"].ToString());
                        communityGroupbillingFee.CommunityGroupName = drCommunityGroupBill["CommunityGroupName"].ToString();
                        communityGroupbillingFee.ActionName = drCommunityGroupBill["Name"].ToString();
                        communityGroupbillingFee.Fee = Convert.ToDecimal(drCommunityGroupBill["Fee"].ToString());
                        if (drCommunityGroupBill["IsPercentFee"] == DBNull.Value)
                            communityGroupbillingFee.IsPercentFee = false;
                        else
                            communityGroupbillingFee.IsPercentFee = Convert.ToBoolean(drCommunityGroupBill["IsPercentFee"]);
                        communityGroupbillingFee.BillFreeDays = Convert.ToInt32(drCommunityGroupBill["BillFreeDays"].ToString());
                        communityGroupbillingFee.TriggeredEventID = Convert.ToInt32(drCommunityGroupBill["TriggeredEventID"].ToString());
                        communityGroupbillingFee.DateUpdated = Convert.ToDateTime(drCommunityGroupBill["DateUpdated"]);
                        communityGroupbillingFee.FeeCurrencyID = Convert.ToInt32(drCommunityGroupBill["feecurrencyid"].ToString());
                        communityGroupbillingFee.CommunityID = Convert.ToInt32(drCommunityGroupBill["communityid"].ToString());
                        lstCommunityGroupBillingFee.Add(communityGroupbillingFee);
                    }
                }
            }
            return lstCommunityGroupBillingFee;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="communityGroupId"></param>
        /// <returns></returns>
        public List<CommunityGroupReward> CommunityGroupRewardSelect(int communityGroupId)
        {
            CommunityGroupReward communityGroupReward;
            List<CommunityGroupReward> lstCommunityGroupReward = new List<CommunityGroupReward>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("communitygrouprewardselect"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, communityGroupId);
                using (IDataReader drCommunityGroupReward = objDb.ExecuteReader(cmd))
                {
                    while (drCommunityGroupReward.Read())
                    {
                        communityGroupReward = new CommunityGroupReward();
                        communityGroupReward.CommunityGroupID = communityGroupId;
                        communityGroupReward.CommunityGroupName = drCommunityGroupReward["communitygroupname"].ToString();
                        communityGroupReward.CommunityGrouprewardID = Convert.ToInt32(drCommunityGroupReward["communitygrouprewardid"].ToString());
                        communityGroupReward.Points = Convert.ToInt32(drCommunityGroupReward["Points"].ToString());
                        communityGroupReward.TriggeredEventsID = Convert.ToInt32(drCommunityGroupReward["triggeredeventid"].ToString());
                        communityGroupReward.ActionName = drCommunityGroupReward["ActionName"].ToString();
                        communityGroupReward.CommunityID = Convert.ToInt32(drCommunityGroupReward["communityid"].ToString());

                        lstCommunityGroupReward.Add(communityGroupReward);
                    }
                }
            }
            return lstCommunityGroupReward;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="communityGroupReward"></param>
        public void CommunityGroupRewardInsert(CommunityGroupReward communityGroupReward)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("communitygrouprewardinsert"))
            {
                objDb.AddInParameter(cmd, "IN_Communitygroupid", DbType.Int32, communityGroupReward.CommunityGroupID);
                objDb.AddInParameter(cmd, "IN_TriggeredEventId", DbType.Int32, communityGroupReward.TriggeredEventsID);
                objDb.AddInParameter(cmd, "IN_Points", DbType.Int32, communityGroupReward.Points);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="communityGroupReward"></param>
        public void CommunityGroupRewardUpdate(CommunityGroupReward communityGroupReward)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("communitygrouprewardupdate"))
            {
                objDb.AddInParameter(cmd, "IN_Communitygrouprewardid", DbType.Int32, communityGroupReward.CommunityGrouprewardID);
                objDb.AddInParameter(cmd, "IN_Points", DbType.Int32, communityGroupReward.Points);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Get active communitygroup supplier
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public List<CommunityGroup> SupplierCommunityGroupByCommunity(int supplierId, int communityId)
        {
            CommunityGroup communityGroup;
            List<CommunityGroup> lstCommunityGroup = new List<CommunityGroup>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("suppliercommunitygroupbycommunity"))
            {
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, communityId);

                using (IDataReader drCommunityGroup = objDb.ExecuteReader(cmd))
                {
                    while (drCommunityGroup.Read())
                    {
                        communityGroup = new CommunityGroup();
                        communityGroup.CommunityGroupID = Convert.ToInt32(drCommunityGroup["CommunityGroupID"].ToString());
                        communityGroup.Name = drCommunityGroup["CommunityGroupname"].ToString();

                        lstCommunityGroup.Add(communityGroup);
                    }
                }
            }

            return lstCommunityGroup;
        }

        /// <summary>
        /// Retrieves list of community groups based on communityId.
        /// </summary>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public List<MenuItem> CommunityGroupListMenu(int communityId)
        {
            List<MenuItem> lstMenuItem = new List<MenuItem>();
            MenuItem menuItem;
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityGroupSelectByCommunity"))
            {
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, communityId);
                using (IDataReader drCommunityGroup = objDb.ExecuteReader(cmd))
                {
                    while (drCommunityGroup.Read())
                    {
                        menuItem = new MenuItem();
                        menuItem.text = drCommunityGroup["CommunityCommunityGroupName"].ToString();
                        menuItem.url = "OwnerCommunityGroupDetail.aspx?cid=" + CommonDAC.EncryptIt(drCommunityGroup["CommunityID"].ToString()) + "&gid=" + CommonDAC.EncryptIt(drCommunityGroup["CommunityGroupID"].ToString());
                        menuItem.id = drCommunityGroup["CommunityGroupID"].ToString();
                        lstMenuItem.Add(menuItem);
                    }
                }
            }

            return lstMenuItem;
        }

        /// <summary>
        /// get all community group supplier
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public List<CommunityGroup> SupplierCommunityGroupSelectAllByCommunity(int supplierId, int communityId)
        {
            CommunityGroup communityGroup;
            List<CommunityGroup> lstCommunityGroup = new List<CommunityGroup>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("suppliercommunitygroupselectallbycommunity"))
            {
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, communityId);

                using (IDataReader drCommunityGroup = objDb.ExecuteReader(cmd))
                {
                    while (drCommunityGroup.Read())
                    {
                        communityGroup = new CommunityGroup();
                        communityGroup.CommunityGroupID = Convert.ToInt32(drCommunityGroup["CommunityGroupID"].ToString());
                        communityGroup.Name = drCommunityGroup["CommunityGroupname"].ToString();

                        lstCommunityGroup.Add(communityGroup);
                    }
                }
            }

            return lstCommunityGroup;
        }

        /// <summary>
        /// Check Community group name is already exist. If exist return 1 else return 0.
        /// For create send communitygroupId as 0
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public string CheckCommunityGroupNameExist(int communityGroupId,int communityId, string name)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("checkcommunitygroupnameexist"))
            {
                objDb.AddInParameter(cmd, "in_communitygroupid", DbType.Int32, communityGroupId);
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, communityId);
                objDb.AddInParameter(cmd, "in_name", DbType.String, HttpUtility.UrlDecode(name));
                return (objDb.ExecuteScalar(cmd)).ToString();
            }
        }
    }
}
