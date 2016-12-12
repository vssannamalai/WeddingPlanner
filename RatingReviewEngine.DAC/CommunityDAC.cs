using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.Common;
using Microsoft.Practices.EnterpriseLibrary.Data;
using RatingReviewEngine.Entities;
using System.Web;

namespace RatingReviewEngine.DAC
{
    public class CommunityDAC : DataAccessComponent
    {
        Database objDb = DatabaseFactory.CreateDatabase(CONNECTION_NAME);

        /// <summary>
        ///  Retrieve the details of the given CommunityID from the Community table 
        /// </summary>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public Community CommunitySelect(int communityId)
        {
            Community community = new Community();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunitySelect"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityId);
                using (IDataReader drCommunity = objDb.ExecuteReader(cmd))
                {
                    while (drCommunity.Read())
                    {
                        community.CommunityID = Convert.ToInt32(drCommunity["CommunityID"].ToString());
                        community.Name = drCommunity["Name"].ToString();
                        community.Description = (drCommunity["Description"] == null) ? null : drCommunity["Description"].ToString();
                        community.CurrencyId = Convert.ToInt32(drCommunity["CurrencyId"].ToString());
                        community.CountryID = Convert.ToInt32(drCommunity["CountryID"].ToString());
                        community.OwnerID = Convert.ToInt32(drCommunity["OwnerID"].ToString());
                        community.CentreLongitude = Convert.ToDecimal(drCommunity["CentreLongitude"].ToString());
                        community.CentreLatitude = Convert.ToDecimal(drCommunity["CentreLatitude"].ToString());
                        community.AreaRadius = Convert.ToDecimal(drCommunity["AreaRadius"].ToString());
                        community.AutoTransferAmtOwner = (drCommunity["AutoTransferAmtOwner"] == DBNull.Value) ? null : (decimal?)Convert.ToDecimal(drCommunity["AutoTransferAmtOwner"].ToString());
                        community.CurrencyName = drCommunity["CurrencyName"].ToString();
                        community.CurrencyMinTransferAmount = Convert.ToDecimal(drCommunity["mintransferamount"].ToString());
                        community.Active = Convert.ToBoolean(drCommunity["Active"]);
                    }
                }
            }
            return community;
        }

        /// <summary>
        /// Retrieve the details of the given OwnerID and CommunityID from the Community table 
        /// </summary>
        /// <param name="ownerId"></param>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public Community CommunitySelectByIdAndOwner(int ownerId, int communityId)
        {
            Community community = new Community();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("communityselectbyidandowner"))
            {
                objDb.AddInParameter(cmd, "in_ownerid", DbType.Int32, ownerId);
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, communityId);
                using (IDataReader drCommunity = objDb.ExecuteReader(cmd))
                {
                    while (drCommunity.Read())
                    {
                        community.CommunityID = Convert.ToInt32(drCommunity["CommunityID"].ToString());
                        community.Name = drCommunity["Name"].ToString();
                        community.Description = (drCommunity["Description"] == null) ? null : drCommunity["Description"].ToString();
                        community.CurrencyId = Convert.ToInt32(drCommunity["CurrencyId"].ToString());
                        community.CountryID = Convert.ToInt32(drCommunity["CountryID"].ToString());
                        community.OwnerID = Convert.ToInt32(drCommunity["OwnerID"].ToString());
                        community.CentreLongitude = Convert.ToDecimal(drCommunity["CentreLongitude"].ToString());
                        community.CentreLatitude = Convert.ToDecimal(drCommunity["CentreLatitude"].ToString());
                        community.AreaRadius = Convert.ToDecimal(drCommunity["AreaRadius"].ToString());
                        community.AutoTransferAmtOwner = (drCommunity["AutoTransferAmtOwner"] == DBNull.Value) ? null : (decimal?)Convert.ToDecimal(drCommunity["AutoTransferAmtOwner"].ToString());
                        community.CurrencyName = drCommunity["CurrencyName"].ToString();
                        community.CurrencyMinTransferAmount = Convert.ToDecimal(drCommunity["mintransferamount"].ToString());
                        community.Active = Convert.ToBoolean(drCommunity["Active"]);
                    }
                }
            }
            return community;
        }

        /// <summary>
        /// 1. Insert a new community record with the supplied details (Community)
        /// </summary>
        /// <param name="community"></param>
        /// <returns></returns>
        public int CommunityInsert(Community community)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityInsert"))
            {
                objDb.AddInParameter(cmd, "IN_Name", DbType.String, HttpUtility.UrlDecode(community.Name));
                objDb.AddInParameter(cmd, "IN_Description", DbType.String, HttpUtility.UrlDecode(community.Description));
                objDb.AddInParameter(cmd, "IN_CurrencyID", DbType.Int32, community.CurrencyId);
                objDb.AddInParameter(cmd, "IN_CountryID", DbType.Int32, community.CountryID);
                objDb.AddInParameter(cmd, "IN_OwnerID", DbType.Int32, community.OwnerID);
                objDb.AddInParameter(cmd, "IN_CentreLongitude", DbType.Decimal, community.CentreLongitude);
                objDb.AddInParameter(cmd, "IN_CentreLatitude", DbType.Decimal, community.CentreLatitude);
                objDb.AddInParameter(cmd, "IN_AreaRadius", DbType.Decimal, community.AreaRadius);
                objDb.AddInParameter(cmd, "IN_AutoTransferAmtOwner", DbType.Decimal, community.AutoTransferAmtOwner);
                objDb.AddInParameter(cmd, "IN_Active", DbType.Boolean, community.Active);
                objDb.AddInParameter(cmd, "in_countryname", DbType.String, community.CountryName);
                 
                int i = Convert.ToInt32(objDb.ExecuteScalar(cmd));
                return i;
            }
        }

        /// <summary>
        /// 1. Update the existing community record with the supplied details (Community)
        /// </summary>
        /// <param name="community"></param>
        public void CommunityUpdate(Community community)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityUpdate"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, community.CommunityID);
                objDb.AddInParameter(cmd, "IN_Name", DbType.String, HttpUtility.UrlDecode(community.Name));
                objDb.AddInParameter(cmd, "IN_Description", DbType.String, HttpUtility.UrlDecode(community.Description));
                objDb.AddInParameter(cmd, "IN_CurrencyID", DbType.Int32, community.CurrencyId);
                objDb.AddInParameter(cmd, "IN_CountryID", DbType.Int32, community.CountryID);
                objDb.AddInParameter(cmd, "IN_CentreLongitude", DbType.Decimal, community.CentreLongitude);
                objDb.AddInParameter(cmd, "IN_CentreLatitude", DbType.Decimal, community.CentreLatitude);
                objDb.AddInParameter(cmd, "IN_AreaRadius", DbType.Decimal, community.AreaRadius);
                objDb.AddInParameter(cmd, "IN_AutoTransferAmtOwner", DbType.Decimal, community.AutoTransferAmtOwner);
                objDb.AddInParameter(cmd, "IN_Active", DbType.Boolean, community.Active);

                objDb.ExecuteNonQuery(cmd);

            }
        }

        /// <summary>
        /// Delete Community from table (Unit test purpose)
        /// </summary>
        /// <param name="communityId"></param>
        public void CommunityDelete(int communityId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("UT_COMMUNITYDELETE"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityId);
                objDb.ExecuteNonQuery(cmd);
            }
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
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityJoin"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, communitySupplier.SupplierID);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communitySupplier.CommunityID);
                objDb.AddInParameter(cmd, "IN_AutoTransferAmtSupplier", DbType.Decimal, communitySupplier.AutoTransferAmtSupplier);
                objDb.AddInParameter(cmd, "IN_AutoTopUp", DbType.Boolean, communitySupplier.AutoTopUp);
                objDb.AddInParameter(cmd, "IN_MinCredit", DbType.Decimal, communitySupplier.MinCredit);
                objDb.ExecuteNonQuery(cmd);
            }
            return;
        }

        /// <summary>
        /// Deactivate (CommunitySupplier.IsActive = false) the relationship between the supplied Community - (Supplier or CustomerCommunity )
        /// </summary>
        /// <param name="id"> Supplier Id/ Customer Id</param>
        /// <param name="entity">Option of either "Supplier" or "Customer"</param>
        /// <param name="communityId"></param>
        public void CommunityLeave(int id, string entity, int communityId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityLeave"))
            {
                objDb.AddInParameter(cmd, "IN_ID", DbType.Int32, id);
                objDb.AddInParameter(cmd, "IN_Entity", DbType.String, entity);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityId);
                objDb.ExecuteNonQuery(cmd);
            }
            return;
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
            List<Community> lstCommunity = new List<Community>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunitySearch"))
            {
                objDb.AddInParameter(cmd, "IN_SearchTerm", DbType.String,HttpUtility.UrlDecode(searchTerm));
                objDb.AddInParameter(cmd, "IN_SearchDistance", DbType.Decimal, searchDistance);
                objDb.AddInParameter(cmd, "IN_ReferenceLongitude", DbType.Decimal, referenceLongitude);
                objDb.AddInParameter(cmd, "IN_ReferenceLatitude", DbType.Decimal, referenceLatitude);

                using (IDataReader drCommunity = objDb.ExecuteReader(cmd))
                {
                    while (drCommunity.Read())
                    {
                        //Add Community Detail from data reader to community list
                        lstCommunity.Add(BindCommunityDetails(drCommunity));
                    }
                }
            }
            return lstCommunity;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ownerId"></param>
        /// <returns></returns>
        public List<Community> CommunitySummaryByOwner(int ownerId,bool communityActive)
        {
            List<Community> lstCommunity = new List<Community>();
            Community community;
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("COMMUNITYSUMMARYBYOWNER"))
            {
                objDb.AddInParameter(cmd, "IN_OwnerID", DbType.Int32, ownerId);
                objDb.AddInParameter(cmd, "in_communityactive", DbType.Boolean, communityActive);
                using (IDataReader drCommunity = objDb.ExecuteReader(cmd))
                {
                    while (drCommunity.Read())
                    {
                        community = new Community();
                        community.CommunityID = Convert.ToInt32(drCommunity["CommunityID"].ToString());
                        community.Name = drCommunity["CommunityName"].ToString();
                        community.CommunityGroupCount = Convert.ToInt32(drCommunity["CommunityGroupCount"].ToString());
                        community.InCreditSuppliersCount = Convert.ToInt32(drCommunity["InCreditCount"].ToString());
                        community.OutofCreditSuppliersCount = Convert.ToInt32(drCommunity["OutCreditCount"].ToString());
                        community.BelowMinCreditSuppliersCount = Convert.ToInt32(drCommunity["BelowMinCreditCount"].ToString());
                        community.CustomersCount = Convert.ToInt32(drCommunity["CustomerCount"].ToString());
                        community.CurrentRevenue = Convert.ToDecimal(drCommunity["CurrentRevenue"].ToString());
                        community.CurrencyId = Convert.ToInt32(drCommunity["CurrencyId"]);
                        community.CurrencyName = drCommunity["CurrencyName"].ToString();
                        lstCommunity.Add(community);
                    }
                }
            }
            return lstCommunity;
        }
        /// <summary>
        /// Bind the community details from the data reader
        /// </summary>
        /// <param name="drCommunity"></param>
        /// <returns></returns>
        private Community BindCommunityDetails(IDataReader drCommunity)
        {
            Community community = new Community();
            community.CommunityID = Convert.ToInt32(drCommunity["CommunityID"].ToString());
            community.Name = drCommunity["Name"].ToString();
            community.Description = (drCommunity["Description"] == null) ? null : drCommunity["Description"].ToString();
            community.CurrencyId = Convert.ToInt32(drCommunity["CurrencyId"]);
            community.CountryID = Convert.ToInt32(drCommunity["CountryID"]);
            community.OwnerID = Convert.ToInt32(drCommunity["OwnerID"]);
            community.CentreLongitude = Convert.ToDecimal(drCommunity["CentreLongitude"]);
            community.CentreLatitude = Convert.ToDecimal(drCommunity["CentreLatitude"]);
            community.AreaRadius = Convert.ToDecimal(drCommunity["AreaRadius"]);
            community.AutoTransferAmtOwner = (drCommunity["AutoTransferAmtOwner"] == DBNull.Value) ? null : (decimal?)Convert.ToDecimal(drCommunity["AutoTransferAmtOwner"]);
            community.Active = Convert.ToBoolean(drCommunity["Active"]);
            return community;
        }

        /// <summary>
        /// Check Community name is already exist. If exist return 1 else return 0.
        /// For create send communityId as 0
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public string CheckCommunityNameExist(int communityId, string name)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CHECKCOMMUNITYNAMEEXIST"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityId);
                objDb.AddInParameter(cmd, "IN_Name", DbType.String, HttpUtility.UrlDecode(name));
                return (objDb.ExecuteScalar(cmd)).ToString();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="communityID"></param>
        /// <returns></returns>
        public Community CommunitySummary(int communityID)
        {
            Community community = new Community();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("COMMUNITYSUMMARY"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityID);
                using (IDataReader drCommunity = objDb.ExecuteReader(cmd))
                {
                    while (drCommunity.Read())
                    {
                        community.CommunityID = Convert.ToInt32(drCommunity["CommunityID"].ToString());
                        community.Name = drCommunity["CommunityName"].ToString();
                        community.CommunityGroupCount = Convert.ToInt32(drCommunity["CommunityGroupCount"].ToString());
                        community.InCreditSuppliersCount = Convert.ToInt32(drCommunity["InCreditCount"].ToString());
                        community.OutofCreditSuppliersCount = Convert.ToInt32(drCommunity["OutCreditCount"].ToString());
                        community.BelowMinCreditSuppliersCount = Convert.ToInt32(drCommunity["BelowMinCreditCount"].ToString());
                        community.CustomersCount = Convert.ToInt32(drCommunity["CustomerCount"].ToString());
                        community.CurrentRevenue = Convert.ToDecimal(drCommunity["CurrentRevenue"].ToString());
                        community.CurrencyName = drCommunity["CurrencyName"].ToString();
                    }
                }
            }
            return community;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ownerId"></param>
        /// <param name="communityID"></param>
        /// <returns></returns>
        public Community CommunitySummaryByIDAndOwner(int ownerId, int communityID)
        {
            Community community = new Community();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("communitysummarybyidandowner"))
            {
                objDb.AddInParameter(cmd, "in_ownerid", DbType.Int32, ownerId);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityID);
                using (IDataReader drCommunity = objDb.ExecuteReader(cmd))
                {
                    while (drCommunity.Read())
                    {
                        community.CommunityID = Convert.ToInt32(drCommunity["CommunityID"].ToString());
                        community.Name = drCommunity["CommunityName"].ToString();
                        community.CommunityGroupCount = Convert.ToInt32(drCommunity["CommunityGroupCount"].ToString());
                        community.InCreditSuppliersCount = Convert.ToInt32(drCommunity["InCreditCount"].ToString());
                        community.OutofCreditSuppliersCount = Convert.ToInt32(drCommunity["OutCreditCount"].ToString());
                        community.BelowMinCreditSuppliersCount = Convert.ToInt32(drCommunity["BelowMinCreditCount"].ToString());
                        community.CustomersCount = Convert.ToInt32(drCommunity["CustomerCount"].ToString());
                        community.CurrentRevenue = Convert.ToDecimal(drCommunity["CurrentRevenue"].ToString());

                    }
                }
            }
            return community;
        }

        /// <summary>
        /// Get list of Community by Owner
        /// </summary>
        /// <param name="ownerId"></param>
        /// <returns></returns>
        public List<Community> CommunitySelectByOwner(int ownerId)
        {
            List<Community> lstCommunity = new List<Community>();
            Community community;
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("COMMUNITYSELECTBYOWNER"))
            {
                objDb.AddInParameter(cmd, "IN_OwnerID", DbType.Int32, ownerId);
                using (IDataReader drCommunity = objDb.ExecuteReader(cmd))
                {
                    while (drCommunity.Read())
                    {
                        community = new Community();
                        community.CommunityID = Convert.ToInt32(drCommunity["CommunityID"].ToString());
                        community.Name = drCommunity["Name"].ToString();
                        lstCommunity.Add(community);
                    }
                }
            }

            return lstCommunity;
        }

        /// <summary>
        /// Retrieves list of all communities.
        /// </summary>
        /// <returns></returns>
        public List<Community> CommunitySelectAll()
        {
            List<Community> lstCommunity = new List<Community>();
            Community community;
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunitySelectAll"))
            {
                using (IDataReader drCommunity = objDb.ExecuteReader(cmd))
                {
                    while (drCommunity.Read())
                    {
                        community = new Community();
                        community.CommunityID = Convert.ToInt32(drCommunity["CommunityID"].ToString());
                        community.Name = drCommunity["Name"].ToString();
                        lstCommunity.Add(community);
                    }
                }
            }

            return lstCommunity;
        }

        /// <summary>
        /// Retrieves community details based on supplierId and communityId.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public CommunitySupplier CommunitySupplierSelect(int supplierId, int communityId)
        {
            CommunitySupplier communitySupplier = new CommunitySupplier();
            DbCommand cmd;

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunitySupplierSelect"))
            {
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, communityId);
                using (IDataReader drCommunitySupplier = objDb.ExecuteReader(cmd))
                {
                    while (drCommunitySupplier.Read())
                    {
                        communitySupplier.SupplierID = Convert.ToInt32(drCommunitySupplier["SupplierId"]);
                        communitySupplier.CommunityID = Convert.ToInt32(drCommunitySupplier["CommunityID"]);
                        communitySupplier.DateJoined = Convert.ToDateTime(drCommunitySupplier["DateJoined"]);
                        communitySupplier.IsActive = Convert.ToInt32(drCommunitySupplier["IsActive"]);
                        communitySupplier.AutoTransferAmtSupplier = Convert.ToDecimal(drCommunitySupplier["AutoTransferAmtSupplier"]);
                        communitySupplier.AutoTopUp = Convert.ToBoolean(drCommunitySupplier["AutoTopUp"]);
                        communitySupplier.MinCredit = Convert.ToDecimal(drCommunitySupplier["MinCredit"]);
                    }
                }
            }

            return communitySupplier;
        }

        /// <summary>
        /// Get list of community by supplier
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<Community> CommunitySelectBySupplier(int supplierId)
        {
            List<Community> lstCommunity = new List<Community>();
            Community community;
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("communityselectbysupplier"))
            {
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierId);
                using (IDataReader drCommunity = objDb.ExecuteReader(cmd))
                {
                    while (drCommunity.Read())
                    {
                        community = new Community();
                        community.CommunityID = Convert.ToInt32(drCommunity["CommunityID"].ToString());
                        community.Name = drCommunity["Name"].ToString();
                        lstCommunity.Add(community);
                    }
                }
            }

            return lstCommunity;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="currencyId"></param>
        /// <returns></returns>
        public List<Community> CommunitySelectByCurrency(int currencyId)
        {
            List<Community> lstCommunity = new List<Community>();
            Community community;
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("communityselectbycurrency"))
            {
                objDb.AddInParameter(cmd, "in_currencyid", DbType.Int32, currencyId);
                using (IDataReader drCommunity = objDb.ExecuteReader(cmd))
                {
                    while (drCommunity.Read())
                    {
                        community = new Community();
                        community.CommunityID = Convert.ToInt32(drCommunity["CommunityID"].ToString());
                        community.Name = drCommunity["Name"].ToString();
                        community.Description = drCommunity["Description"].ToString();
                        community.CurrencyId = Convert.ToInt32(drCommunity["Currencyid"].ToString());
                        community.CountryID = Convert.ToInt32(drCommunity["CountryId"].ToString());
                        community.OwnerID = Convert.ToInt32(drCommunity["Ownerid"].ToString());
                        community.Active = Convert.ToBoolean(drCommunity["Active"]);
                        lstCommunity.Add(community);
                    }
                }
            }

            return lstCommunity;
        }
    }
}
