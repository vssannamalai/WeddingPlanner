using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Web;

using Microsoft.Practices.EnterpriseLibrary.Data;
using RatingReviewEngine.Entities;
using RatingReviewEngine.Entities.ServiceResponse;

namespace RatingReviewEngine.DAC
{
    public class SupplierDAC : DataAccessComponent
    {
        Database objDb = DatabaseFactory.CreateDatabase(CONNECTION_NAME);

        /// <summary>
        /// 1. Create a new supplier record with the supplied details (Supplier)
        /// 2. Associate the newly created Supplier record (Supplier.SupplierID) with the supplied OAuth Account (OAuthAccount.OAuthAccountID) (EntityOAuthAccount)
        /// </summary>
        /// <param name="supplier"></param>
        /// <returns></returns>
        public int RegisterNewSupplier(Supplier supplier)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("RegisterNewSupplier"))
            {
                objDb.AddInParameter(cmd, "IN_OAuthAccountID", DbType.String, supplier.OAuthAccountID);
                objDb.AddInParameter(cmd, "IN_CompanyName", DbType.String, HttpUtility.UrlDecode(supplier.CompanyName));
                objDb.AddInParameter(cmd, "IN_Email", DbType.String, supplier.Email);
                objDb.AddInParameter(cmd, "IN_BusinessNumber", DbType.String, HttpUtility.UrlDecode(supplier.BusinessNumber));
                objDb.AddInParameter(cmd, "IN_PrimaryPhone", DbType.String, HttpUtility.UrlDecode(supplier.PrimaryPhone));
                objDb.AddInParameter(cmd, "IN_OtherPhone", DbType.String, HttpUtility.UrlDecode(supplier.OtherPhone));
                objDb.AddInParameter(cmd, "IN_DateAdded", DbType.DateTime, supplier.DateAdded);
                objDb.AddInParameter(cmd, "IN_Website", DbType.String, HttpUtility.UrlDecode(supplier.Website));
                objDb.AddInParameter(cmd, "IN_AddressLine1", DbType.String, HttpUtility.UrlDecode(supplier.AddressLine1));
                objDb.AddInParameter(cmd, "IN_AddressLine2", DbType.String, HttpUtility.UrlDecode(supplier.AddressLine2));
                objDb.AddInParameter(cmd, "IN_AddressCity", DbType.String, HttpUtility.UrlDecode(supplier.AddressCity));
                objDb.AddInParameter(cmd, "IN_AddressState", DbType.String, HttpUtility.UrlDecode(supplier.AddressState));
                objDb.AddInParameter(cmd, "IN_AddressPostalCode", DbType.String, HttpUtility.UrlDecode(supplier.AddressPostalCode));
                objDb.AddInParameter(cmd, "IN_AddressCountryID", DbType.Int32, supplier.AddressCountryID == -1 ? null : supplier.AddressCountryID);
                objDb.AddInParameter(cmd, "IN_BillingName", DbType.String, HttpUtility.UrlDecode(supplier.BillingName));
                objDb.AddInParameter(cmd, "IN_BillingAddressLine1", DbType.String, HttpUtility.UrlDecode(supplier.BillingAddressLine1));
                objDb.AddInParameter(cmd, "IN_BillingAddressLine2", DbType.String, HttpUtility.UrlDecode(supplier.BillingAddressLine2));
                objDb.AddInParameter(cmd, "IN_BillingAddressCity", DbType.String, HttpUtility.UrlDecode(supplier.BillingAddressCity));
                objDb.AddInParameter(cmd, "IN_BillingAddressState", DbType.String, HttpUtility.UrlDecode(supplier.BillingAddressState));
                objDb.AddInParameter(cmd, "IN_BillingAddressPostalCode", DbType.String, HttpUtility.UrlDecode(supplier.BillingAddressPostalCode));
                objDb.AddInParameter(cmd, "IN_BillingAddressCountryID", DbType.String, supplier.BillingAddressCountryID == -1 ? null : supplier.BillingAddressCountryID);
                objDb.AddInParameter(cmd, "IN_Longitude", DbType.Decimal, supplier.Longitude);
                objDb.AddInParameter(cmd, "IN_Latitude", DbType.Decimal, supplier.Latitude);
                objDb.AddInParameter(cmd, "IN_ProfileCompletedDate", DbType.DateTime, supplier.ProfileCompletedDate);
                objDb.AddInParameter(cmd, "IN_QuoteTerms", DbType.String, HttpUtility.UrlDecode(supplier.QuoteTerms));
                objDb.AddInParameter(cmd, "IN_DepositPercent", DbType.Decimal, supplier.DepositPercent);
                objDb.AddInParameter(cmd, "IN_DepositTerms", DbType.String, HttpUtility.UrlDecode(supplier.DepositTerms));
                objDb.AddInParameter(cmd, "in_addresscountryname", DbType.String, HttpUtility.UrlDecode(supplier.AddressCountryName));
                objDb.AddInParameter(cmd, "in_billingcountryname", DbType.String, HttpUtility.UrlDecode(supplier.BillingAddressCountryName));

                return Convert.ToInt32(objDb.ExecuteScalar(cmd));
            }
        }

        /// <summary>
        ///  Create a new supplier record (Supplier) with the supplied details
        /// </summary>
        /// <param name="supplier"></param>
        /// <returns></returns>
        public int SupplierInsert(Supplier supplier)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierInsert"))
            {
                objDb.AddInParameter(cmd, "IN_CompanyName", DbType.String, supplier.CompanyName);
                objDb.AddInParameter(cmd, "IN_Email", DbType.String, supplier.Email);
                objDb.AddInParameter(cmd, "IN_Website", DbType.String, supplier.Website);
                objDb.AddInParameter(cmd, "IN_PrimaryPhone", DbType.String, supplier.PrimaryPhone);
                objDb.AddInParameter(cmd, "IN_OtherPhone", DbType.String, supplier.OtherPhone);
                objDb.AddInParameter(cmd, "IN_AddressLine1", DbType.String, supplier.AddressLine1);
                objDb.AddInParameter(cmd, "IN_AddressLine2", DbType.String, supplier.AddressLine2);
                objDb.AddInParameter(cmd, "IN_AddressCity", DbType.String, supplier.AddressCity);
                objDb.AddInParameter(cmd, "IN_AddressState", DbType.String, supplier.AddressState);
                objDb.AddInParameter(cmd, "IN_AddressPostalCode", DbType.String, supplier.AddressPostalCode);
                objDb.AddInParameter(cmd, "IN_AddressCountryID", DbType.Int32, supplier.AddressCountryID == -1 ? null : supplier.AddressCountryID);
                objDb.AddInParameter(cmd, "IN_BillingName", DbType.String, supplier.BillingName);
                objDb.AddInParameter(cmd, "IN_BillingAddressLine1", DbType.String, supplier.BillingAddressLine1);
                objDb.AddInParameter(cmd, "IN_BillingAddressLine2", DbType.String, supplier.BillingAddressLine2);
                objDb.AddInParameter(cmd, "IN_BillingAddressCity", DbType.String, supplier.BillingAddressCity);
                objDb.AddInParameter(cmd, "IN_BillingAddressState", DbType.String, supplier.BillingAddressState);
                objDb.AddInParameter(cmd, "IN_BillingAddressPostalCode", DbType.String, supplier.BillingAddressPostalCode);
                objDb.AddInParameter(cmd, "IN_BillingAddressCountryID", DbType.String, supplier.BillingAddressCountryID == -1 ? null : supplier.BillingAddressCountryID);
                objDb.AddInParameter(cmd, "IN_BusinessNumber", DbType.String, supplier.BusinessNumber);
                objDb.AddInParameter(cmd, "IN_Longitude", DbType.Decimal, supplier.Longitude);
                objDb.AddInParameter(cmd, "IN_Latitude", DbType.Decimal, supplier.Latitude);

                return Convert.ToInt32(objDb.ExecuteScalar(cmd));
            }
        }

        /// <summary>
        /// Update an existing supplier record (Supplier.SupplierID) with the supplied details (Supplier)
        /// </summary>
        /// <param name="supplier"></param>
        public void SupplierUpdate(Supplier supplier)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierUpdate"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplier.SupplierID);
                objDb.AddInParameter(cmd, "IN_CompanyName", DbType.String, HttpUtility.UrlDecode(supplier.CompanyName));
                objDb.AddInParameter(cmd, "IN_Email", DbType.String, supplier.Email);
                objDb.AddInParameter(cmd, "IN_BusinessNumber", DbType.String, HttpUtility.UrlDecode(supplier.BusinessNumber));
                objDb.AddInParameter(cmd, "IN_PrimaryPhone", DbType.String, HttpUtility.UrlDecode(supplier.PrimaryPhone));
                objDb.AddInParameter(cmd, "IN_OtherPhone", DbType.String, HttpUtility.UrlDecode(supplier.OtherPhone));
                objDb.AddInParameter(cmd, "IN_DateAdded", DbType.DateTime, supplier.DateAdded);
                objDb.AddInParameter(cmd, "IN_Website", DbType.String, supplier.Website);
                objDb.AddInParameter(cmd, "IN_AddressLine1", DbType.String, HttpUtility.UrlDecode(supplier.AddressLine1));
                objDb.AddInParameter(cmd, "IN_AddressLine2", DbType.String, HttpUtility.UrlDecode(supplier.AddressLine2));
                objDb.AddInParameter(cmd, "IN_AddressCity", DbType.String, HttpUtility.UrlDecode(supplier.AddressCity));
                objDb.AddInParameter(cmd, "IN_AddressState", DbType.String, HttpUtility.UrlDecode(supplier.AddressState));
                objDb.AddInParameter(cmd, "IN_AddressPostalCode", DbType.String, HttpUtility.UrlDecode(supplier.AddressPostalCode));
                objDb.AddInParameter(cmd, "IN_AddressCountryID", DbType.Int32, supplier.AddressCountryID == -1 ? null : supplier.AddressCountryID);
                objDb.AddInParameter(cmd, "IN_BillingName", DbType.String, HttpUtility.UrlDecode(supplier.BillingName));
                objDb.AddInParameter(cmd, "IN_BillingAddressLine1", DbType.String, HttpUtility.UrlDecode(supplier.BillingAddressLine1));
                objDb.AddInParameter(cmd, "IN_BillingAddressLine2", DbType.String, HttpUtility.UrlDecode(supplier.BillingAddressLine2));
                objDb.AddInParameter(cmd, "IN_BillingAddressCity", DbType.String, HttpUtility.UrlDecode(supplier.BillingAddressCity));
                objDb.AddInParameter(cmd, "IN_BillingAddressState", DbType.String, HttpUtility.UrlDecode(supplier.BillingAddressState));
                objDb.AddInParameter(cmd, "IN_BillingAddressPostalCode", DbType.String, HttpUtility.UrlDecode(supplier.BillingAddressPostalCode));
                objDb.AddInParameter(cmd, "IN_BillingAddressCountryID", DbType.String, supplier.BillingAddressCountryID == -1 ? null : supplier.BillingAddressCountryID);
                objDb.AddInParameter(cmd, "IN_Longitude", DbType.Decimal, supplier.Longitude);
                objDb.AddInParameter(cmd, "IN_Latitude", DbType.Decimal, supplier.Latitude);
                objDb.AddInParameter(cmd, "IN_ProfileCompletedDate", DbType.DateTime, supplier.ProfileCompletedDate);
                objDb.AddInParameter(cmd, "IN_QuoteTerms", DbType.String, HttpUtility.UrlDecode(supplier.QuoteTerms));
                objDb.AddInParameter(cmd, "IN_DepositPercent", DbType.Decimal, supplier.DepositPercent);
                objDb.AddInParameter(cmd, "IN_DepositTerms", DbType.String, HttpUtility.UrlDecode(supplier.DepositTerms));
                objDb.AddInParameter(cmd, "in_addresscountryname", DbType.String, HttpUtility.UrlDecode(supplier.AddressCountryName));
                objDb.AddInParameter(cmd, "in_billingcountryname", DbType.String, HttpUtility.UrlDecode(supplier.BillingAddressCountryName));

                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Retrieve the details of the given SupplierID from the Supplier table (Supplier.SupplierID)
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public Supplier SupplierSelect(int supplierId)
        {
            Supplier supplier = new Supplier();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierSelect"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                using (IDataReader drSupplier = objDb.ExecuteReader(cmd))
                {
                    while (drSupplier.Read())
                    {
                        supplier.SupplierID = Convert.ToInt32(drSupplier["SupplierID"].ToString());
                        supplier.CompanyName = drSupplier["CompanyName"].ToString();
                        supplier.Email = drSupplier["Email"].ToString();
                        supplier.Website = drSupplier["Website"].ToString();
                        supplier.PrimaryPhone = drSupplier["PrimaryPhone"].ToString();
                        supplier.OtherPhone = drSupplier["OtherPhone"].ToString();
                        supplier.AddressLine1 = drSupplier["AddressLine1"].ToString();
                        supplier.AddressLine2 = drSupplier["AddressLine2"].ToString();
                        supplier.AddressCity = drSupplier["AddressCity"].ToString();
                        supplier.AddressState = drSupplier["AddressState"].ToString();
                        supplier.AddressPostalCode = drSupplier["AddressPostalCode"].ToString();
                        if (drSupplier["AddressCountryID"] != DBNull.Value)
                            supplier.AddressCountryID = Convert.ToInt32(drSupplier["AddressCountryID"].ToString());
                        supplier.BillingName = drSupplier["BillingName"].ToString();
                        supplier.BillingAddressLine1 = drSupplier["BillingAddressLine1"].ToString();
                        supplier.BillingAddressLine2 = drSupplier["BillingAddressLine2"].ToString();
                        supplier.BillingAddressCity = drSupplier["BillingAddressCity"].ToString();
                        supplier.BillingAddressState = drSupplier["BillingAddressState"].ToString();
                        supplier.BillingAddressPostalCode = drSupplier["BillingAddressPostalCode"].ToString();
                        if (drSupplier["BillingAddressCountryID"] != DBNull.Value)
                            supplier.BillingAddressCountryID = Convert.ToInt32(drSupplier["BillingAddressCountryID"].ToString());
                        supplier.BusinessNumber = drSupplier["BusinessNumber"].ToString();
                        supplier.Longitude = Convert.ToDecimal(drSupplier["Longitude"].ToString());
                        supplier.Latitude = Convert.ToDecimal(drSupplier["Latitude"].ToString());
                        supplier.DateAdded = Convert.ToDateTime(drSupplier["DateAdded"].ToString());
                        if (drSupplier["ProfileCompletedDate"] != DBNull.Value)
                            supplier.ProfileCompletedDate = Convert.ToDateTime(drSupplier["ProfileCompletedDate"]);
                        supplier.QuoteTerms = drSupplier["QuoteTerms"].ToString();
                        supplier.DepositPercent = Convert.ToDecimal(drSupplier["DepositPercent"].ToString());
                        supplier.DepositTerms = drSupplier["DepositTerms"].ToString();
                        supplier.AddressCountryName = drSupplier["AddressCountryName"].ToString();
                        supplier.BillingAddressCountryName = drSupplier["BillingAddressCountryName"].ToString();
                    }

                    if (supplier.SupplierID == 0)
                    {
                        supplier.DateAdded = DateTime.Now;
                    }
                }
            }
            return supplier;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<Supplier> SupplierSelectAll()
        {
            List<Supplier> lstSupplier = new List<Supplier>();
            Supplier supplier;
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("supplierselectall"))
            {
                using (IDataReader drSupplier = objDb.ExecuteReader(cmd))
                {
                    while (drSupplier.Read())
                    {
                        supplier = new Supplier();
                        supplier.SupplierID = Convert.ToInt32(drSupplier["SupplierID"].ToString());
                        supplier.CompanyName = drSupplier["CompanyName"].ToString();
                        supplier.DateAdded = Convert.ToDateTime(drSupplier["dateadded"]);
                        lstSupplier.Add(supplier);
                    }
                }
            }

            return lstSupplier;
        }

        /// <summary>
        /// 1. If the Filter value = "All"
        /// a) retrieve all suppliers from the Supplier table where they are linked to the supplied Community (CommunitySupplier.CommunityID) and/or Community Group 
        /// (CommunityGroupSupplier.CommunityGroupID) that match the wildcard search term (SearchTerm with "%" prepended & appended and replacing blanks)
        /// 2. If the Filter value = "In Credit"
        /// a) retrieve all suppliers from the Supplier table where they are linked to the supplied Community (CommunitySupplier.CommunityID) and/or Community Group 
        /// (CommunityGroupSupplier.CommunityGroupID) that match the wildcard search term (SearchTerm with "%" prepended & appended and replacing blanks) 
        /// and that have a current balance for the associated CommunityID (SupplierCommunityTransactionHistory.Balance) greater than equal to the defined MinCredit amount (CommunityGroup.CreditMin)
        /// 3. If the Filter value = "Out of Credit"
        /// a) retrieve all suppliers from the Supplier table where they are linked to the supplied Community (CommunitySupplier.CommunityID) and/or Community Group 
        /// (CommunityGroupSupplier.CommunityGroupID) that match the wildcard search term (SearchTerm with "%" prepended & appended and replacing blanks) and that 
        /// 4. If the Filter value = "Below Min Credit"
        /// a) retrieve all suppliers from the Supplier table where they are linked to the supplied Community (CommunitySupplier.CommunityID) and/or Community Group 
        /// (CommunityGroupSupplier.CommunityGroupID) that match the wildcard search term (SearchTerm with "%" prepended & appended and replacing blanks) 
        /// and that have a current balance for the associated CommunityID (SupplierCommunityTransactionHistory.Balance) less than the defined MinCredit amount (CommunityGroup.CreditMin) and greater than 0.00
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<Supplier> SupplierSearch(string searchTerm, int communityId, int communityGroupId, string filter)
        {
            List<Supplier> lstSupplier = new List<Supplier>();
            Supplier supplier = new Supplier();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierSelect"))
            {
                objDb.AddInParameter(cmd, "IN_SearchTerm", DbType.String, searchTerm);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityId);
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, communityGroupId);
                objDb.AddInParameter(cmd, "IN_Filter", DbType.String, filter);

                using (IDataReader drSupplier = objDb.ExecuteReader(cmd))
                {
                    while (drSupplier.Read())
                    {
                        supplier = new Supplier();
                        supplier.SupplierID = Convert.ToInt32(drSupplier["SupplierID"].ToString());
                        supplier.CompanyName = drSupplier["CompanyName"].ToString();
                        supplier.Email = drSupplier["Email"].ToString();
                        supplier.Website = drSupplier["Website"].ToString();
                        supplier.PrimaryPhone = drSupplier["PrimaryPhone"].ToString();
                        supplier.OtherPhone = drSupplier["OtherPhone"].ToString();
                        supplier.AddressLine1 = drSupplier["AddressLine1"].ToString();
                        supplier.AddressLine2 = drSupplier["AddressLine2"].ToString();
                        supplier.AddressCity = drSupplier["AddressCity"].ToString();
                        supplier.AddressState = drSupplier["AddressState"].ToString();
                        supplier.AddressPostalCode = drSupplier["AddressPostalCode"].ToString();
                        if (drSupplier["AddressCountryID"] != DBNull.Value)
                            supplier.AddressCountryID = Convert.ToInt32(drSupplier["AddressCountryID"].ToString());
                        supplier.BillingName = drSupplier["BillingName"].ToString();
                        supplier.BillingAddressLine1 = drSupplier["BillingAddressLine1"].ToString();
                        supplier.BillingAddressLine2 = drSupplier["BillingAddressLine2"].ToString();
                        supplier.BillingAddressCity = drSupplier["BillingAddressCity"].ToString();
                        supplier.BillingAddressState = drSupplier["BillingAddressState"].ToString();
                        supplier.BillingAddressPostalCode = drSupplier["BillingAddressPostalCode"].ToString();
                        if (drSupplier["BillingAddressCountryID"] != DBNull.Value)
                            supplier.BillingAddressCountryID = Convert.ToInt32(drSupplier["BillingAddressCountryID"].ToString());
                        supplier.BusinessNumber = drSupplier["BusinessNumber"].ToString();
                        if (drSupplier["Longitude"] != DBNull.Value)
                            supplier.Longitude = Convert.ToDecimal(drSupplier["Longitude"].ToString());
                        if (drSupplier["Latitude"] != DBNull.Value)
                            supplier.Latitude = Convert.ToDecimal(drSupplier["Latitude"].ToString());
                        supplier.DateAdded = Convert.ToDateTime(drSupplier["DateAdded"]);
                        if (drSupplier["ProfileCompletedDate"] != DBNull.Value)
                            supplier.ProfileCompletedDate = Convert.ToDateTime(drSupplier["ProfileCompletedDate"]);
                        supplier.QuoteTerms = drSupplier["QuoteTerms"].ToString();
                        supplier.DepositPercent = Convert.ToDecimal(drSupplier["DepositPercent"].ToString());
                        supplier.DepositTerms = drSupplier["DepositTerms"].ToString();

                        lstSupplier.Add(supplier);

                    }
                }
            }
            return lstSupplier;
        }

        /// <summary>
        /// Delete Supplier from tabel (Unit test purpose)
        /// </summary>
        /// <param name="supplierId"></param>
        public void SupplierDelete(int supplierId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("UT_SupplierDelete"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Insert a new supplierIcon record with the supplied details (SuppliedIcon)
        /// If already exists then Update Icon
        /// </summary>
        /// <param name="supplierIcon"></param>
        public void SupplierIconInsert(SupplierIcon supplierIcon)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierIconInsert"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierIcon.SupplierID);
                objDb.AddInParameter(cmd, "IN_Icon", DbType.Binary, supplierIcon.Icon);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Get SupplierIcon based on SupplierId
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public SupplierIcon SupplierIconSelect(int supplierId)
        {
            SupplierIcon supplierIcon = new SupplierIcon();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierIconSelect"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                using (IDataReader drSupplier = objDb.ExecuteReader(cmd))
                {
                    while (drSupplier.Read())
                    {
                        supplierIcon.SupplierID = Convert.ToInt32(drSupplier["SupplierID"].ToString());
                        supplierIcon.Icon = (Byte[])drSupplier["Icon"];
                    }
                }
            }

            return supplierIcon;
        }

        /// <summary>
        /// Delete supplier icon
        /// </summary>
        /// <param name="supplierId"></param>
        public void SupplierIconDelete(int supplierId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("suppliericondelete"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Insert a new supplierLogo record with the supplied details (SuppliedIcon)
        /// If already exist then update Logo
        /// </summary>
        /// <param name="supplierLogo"></param>
        public void SupplierLogoInsert(SupplierLogo supplierLogo)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierLogoInsert"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierLogo.SupplierID);
                objDb.AddInParameter(cmd, "IN_Logo", DbType.Binary, supplierLogo.Logo);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Get SupplierLogo based on SupplierId
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public SupplierLogo SupplierLogoSelect(int supplierId)
        {
            SupplierLogo supplierLogo = new SupplierLogo();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierLogoSelect"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                using (IDataReader drSupplier = objDb.ExecuteReader(cmd))
                {
                    while (drSupplier.Read())
                    {
                        supplierLogo.SupplierID = Convert.ToInt32(drSupplier["SupplierID"].ToString());
                        supplierLogo.Logo = (Byte[])drSupplier["Logo"];
                    }
                }
            }

            return supplierLogo;
        }

        public void SupplierLogoDelete(int supplierId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("supplierlogodelete"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// If Add = "true", then add the supplier to the customer's shortlist for the given community - community group (SupplierShortlist)
        /// If Add = "false", then remove the supplier from the customer's shortlist for the given community - community group (SupplierShortlist)
        /// </summary>
        /// <param name="supplierShortlist"></param>
        public void ShortlistUpate(SupplierShortlist supplierShortlist)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("ShortlistUpdate"))
            {
                objDb.AddInParameter(cmd, "IN_CustomerID", DbType.Int32, supplierShortlist.CustomerID);
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierShortlist.SupplierID);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, supplierShortlist.CommunityID);
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, supplierShortlist.CommunityGroupID);
                objDb.AddInParameter(cmd, "IN_Add", DbType.Int32, supplierShortlist.Add);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// 1. Check if a record already exists for the given supplier-customer-community-community group relationship in the SupplierCustomerNote table and retieve the SupplierCustomerNote.SupplierCustomerNoteID if it does
        /// 2. If the returned SupplierCustomerNoteID is not null, update the existing record (SupplierCustomerNote.SupplierCustomerNoteID) with the updated Supplier Note text (SupplierCustomerNote.SupplierNote)
        /// 3. If the returned SupplierCustomerNoteID is null, create a new record for the given supplier-customer-community-community group relationship in the SupplierCustomerNote table, 
        /// populating the supplier note field (SupplierCustomerNote.SupplierNote)
        /// </summary>
        /// <param name="supplierCustomerNote"></param>
        public void SupplierNoteUpdate(SupplierCustomerNote supplierCustomerNote)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierNoteUpdate"))
            {
                objDb.AddInParameter(cmd, "IN_CustomerID", DbType.Int32, supplierCustomerNote.CustomerID);
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierCustomerNote.SupplierID);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, supplierCustomerNote.CommunityID);
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, supplierCustomerNote.CommunityGroupID);
                objDb.AddInParameter(cmd, "IN_NoteText", DbType.String, HttpUtility.UrlDecode(supplierCustomerNote.SupplierNote));

                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Insert a new social reference for the given supplier with the given details (SupplierSocialReference)
        /// </summary>
        /// <param name="supplierSocialReference"></param>
        public void SupplierSocialReferenceInsert(SupplierSocialReference supplierSocialReference)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierSocialReferenceInsert"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierSocialReference.SupplierID);
                objDb.AddInParameter(cmd, "IN_SocialMediaID", DbType.Int32, supplierSocialReference.SocialMediaID);
                objDb.AddInParameter(cmd, "IN_SocialMediaReference", DbType.String, supplierSocialReference.SocialMediaReference);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Updates an existing social reference record for a supplier with the given details (SupplierSocialReference)
        /// </summary>
        /// <param name="supplierSocialReference"></param>
        public void SupplierSocialReferenceUpdate(SupplierSocialReference supplierSocialReference)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierSocialReferenceUpdate"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierSocialReferenceID", DbType.Int32, supplierSocialReference.SupplierSocialReferenceID);
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierSocialReference.SupplierID);
                objDb.AddInParameter(cmd, "IN_SocialMediaID", DbType.Int32, supplierSocialReference.SocialMediaID);
                objDb.AddInParameter(cmd, "IN_SocialMediaReference", DbType.String, supplierSocialReference.SocialMediaReference);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Remove the given supplier's social reference (SupplierSocialReference)
        /// </summary>
        /// <param name="supplierSocialReferenceId"></param>
        public void SupplierSocialReferenceDelete(int supplierSocialReferenceId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierSocialReferenceDelete"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierSocialReferenceID", DbType.Int32, supplierSocialReferenceId);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// 1. Update the relevant bill free override record with the supplied details (SupplierCommunityBillFreeOverride) 
        /// (NB - if the supplied BillFreeEnd date is null/emtpy, then do not update this date - only update this field if a date is supplied.)
        /// </summary>
        /// <param name="supplierCommunityBillFreeOverride"></param>
        public void BillFreeOverRideUpdate(SupplierCommunityBillFreeOverride supplierCommunityBillFreeOverride)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("BillFreeOverRideUpdate"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierCommunityBillFreeOverrideID", DbType.Int32, supplierCommunityBillFreeOverride.SupplierCommunityBillFreeOverrideID);
                objDb.AddInParameter(cmd, "IN_IsActive", DbType.Boolean, supplierCommunityBillFreeOverride.IsActive);
                objDb.AddInParameter(cmd, "IN_BillFreeEnd", DbType.DateTime, supplierCommunityBillFreeOverride.BillFreeEnd);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Check Supplier email is already exist. If exist return 1 else return 0.
        /// For new record pass supplierId as 0
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public string CheckSupplierEmailExist(int supplierId, string email)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CheckSupplierEmailExist"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "IN_Email", DbType.String, HttpUtility.UrlDecode(email));
                return (objDb.ExecuteScalar(cmd)).ToString();
            }
        }

        /// <summary>
        /// Check Supplier Company name is already exist. If exist return 1 else return 0.
        /// For new record pass supplierId as 0
        /// </summary>
        /// <param name="companyName"></param>
        /// <returns></returns>
        public string CheckSupplierCompanyNameExist(int supplierId, string companyName)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CheckSupplierCompanyNameExist"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "IN_CompanyName", DbType.String, HttpUtility.UrlDecode(companyName));
                return (objDb.ExecuteScalar(cmd)).ToString();
            }
        }

        /// <summary>
        /// Get Supplier action by Customer & Supplier
        /// </summary>
        /// <param name="nCustomerID"></param>
        /// <param name="nSupplierID"></param>
        /// <returns></returns>
        public List<SupplierAction> SupplierActionSelectByCustomer(int nSupplierID, int nCustomerID)
        {
            SupplierAction supplierAction;
            List<SupplierAction> lstSupplierAction = new List<SupplierAction>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierActionSelectByCustomer"))
            {
                objDb.AddInParameter(cmd, "IN_CustomerID", DbType.Int32, nCustomerID);
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, nSupplierID);
                using (IDataReader drSupplierAction = objDb.ExecuteReader(cmd))
                {
                    while (drSupplierAction.Read())
                    {
                        supplierAction = new SupplierAction();
                        supplierAction.CustomerID = Convert.ToInt32(drSupplierAction["CustomerID"]);
                        supplierAction.CustomerName = drSupplierAction["FirstName"].ToString() + " " + drSupplierAction["LastName"].ToString() + " (" + drSupplierAction["Handle"].ToString() + ")";
                        supplierAction.CustomerEmail = drSupplierAction["Email"].ToString();
                        supplierAction.ActionName = drSupplierAction["ActionName"].ToString();
                        supplierAction.ActionDate = Convert.ToDateTime(drSupplierAction["ActionDate"]);
                        supplierAction.SupplierActionID = Convert.ToInt32(drSupplierAction["SupplierActionID"]);
                        supplierAction.ActionID = Convert.ToInt32(drSupplierAction["ActionID"]);
                        supplierAction.CommunityGroupName = drSupplierAction["CommunityCommunityGroupName"].ToString();
                        supplierAction.CommunityGroupID = Convert.ToInt32(drSupplierAction["CommunityGroupID"]);
                        supplierAction.CurrentAction = drSupplierAction["CurrentAction"].ToString();
                        supplierAction.CommunityID = Convert.ToInt32(drSupplierAction["CommunityID"]);
                        supplierAction.SupplierNote = drSupplierAction["SupplierNote"].ToString();
                        supplierAction.QuoteID = Convert.ToInt32(drSupplierAction["QuoteID"]);

                        lstSupplierAction.Add(supplierAction);
                    }
                }
            }

            return lstSupplierAction;
        }

        /// <summary>
        /// Get all Social Media
        /// </summary>
        /// <returns></returns>
        public List<SocialMedia> SocialMediaSelect()
        {
            SocialMedia socialMedia;
            List<SocialMedia> lstSocialMedia = new List<SocialMedia>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SocialMediaSelect"))
            {
                using (IDataReader drSocialMedia = objDb.ExecuteReader(cmd))
                {
                    while (drSocialMedia.Read())
                    {
                        socialMedia = new SocialMedia();
                        socialMedia.SocialMediaID = Convert.ToInt32(drSocialMedia["SocialMediaID"]);
                        socialMedia.Name = drSocialMedia["Name"].ToString();

                        lstSocialMedia.Add(socialMedia);
                    }
                }
            }

            return lstSocialMedia;
        }

        /// <summary>
        /// Retrieve the details of the given SupplierID from the SupplierSocialReference
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<SupplierSocialReference> SupplierSocialReferenceSelect(int supplierId)
        {
            SupplierSocialReference supplierSocialReference;
            List<SupplierSocialReference> lstSupplierSocialReference = new List<SupplierSocialReference>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierSocialReferenceSelect"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                using (IDataReader drSupplierSocialReference = objDb.ExecuteReader(cmd))
                {
                    while (drSupplierSocialReference.Read())
                    {
                        supplierSocialReference = new SupplierSocialReference();
                        supplierSocialReference.SupplierSocialReferenceID = Convert.ToInt32(drSupplierSocialReference["SupplierSocialReferenceID"]);
                        supplierSocialReference.SocialMediaID = Convert.ToInt32(drSupplierSocialReference["SocialMediaID"]);
                        supplierSocialReference.SocialMediaReference = drSupplierSocialReference["SocialMediaReference"].ToString();
                        supplierSocialReference.SocialMediaName = drSupplierSocialReference["SocialMediaName"].ToString();

                        lstSupplierSocialReference.Add(supplierSocialReference);
                    }
                }
            }

            return lstSupplierSocialReference;
        }

        /// <summary>
        /// Retrieves total count of active and inactive community from the CommunitySupplier table for a particular Supplier.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public SupplierCommunityCount SupplierCommunityMembershipCount(int supplierId)
        {
            SupplierCommunityCount supplierCommunityCount = new SupplierCommunityCount();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierCommunityMembershipCount"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                using (IDataReader drSupplierCommunityCount = objDb.ExecuteReader(cmd))
                {
                    while (drSupplierCommunityCount.Read())
                    {
                        supplierCommunityCount.Active = Convert.ToInt32(drSupplierCommunityCount["Active"]);
                        supplierCommunityCount.Inactive = Convert.ToInt32(drSupplierCommunityCount["Inactive"]);
                    }
                }
            }

            return supplierCommunityCount;
        }

        /// <summary>
        /// Retreives list of communities, active and inactive counts from each community and their total for a particular supplier.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="active"></param>
        /// <returns></returns>
        public List<SupplierCommunityGroupCount> CommunityListBySupplier(int supplierId, int active)
        {
            SupplierCommunityGroupCount supplierCommunityGroupCount;
            List<SupplierCommunityGroupCount> lstSupplierCommunityGroupCount = new List<SupplierCommunityGroupCount>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityListBySupplier"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "IN_IsActive", DbType.Int32, active);
                using (IDataReader drSupplierCommunityGroupCount = objDb.ExecuteReader(cmd))
                {
                    while (drSupplierCommunityGroupCount.Read())
                    {
                        supplierCommunityGroupCount = new SupplierCommunityGroupCount();
                        supplierCommunityGroupCount.CommunityName = drSupplierCommunityGroupCount["Name"].ToString();
                        supplierCommunityGroupCount.CommunityID = Convert.ToInt32(drSupplierCommunityGroupCount["CommunityID"]);
                        supplierCommunityGroupCount.Active = Convert.ToInt32(drSupplierCommunityGroupCount["Active"]);
                        supplierCommunityGroupCount.Inactive = Convert.ToInt32(drSupplierCommunityGroupCount["Inactive"]);
                        supplierCommunityGroupCount.Total = Convert.ToInt32(drSupplierCommunityGroupCount["Total"]);

                        lstSupplierCommunityGroupCount.Add(supplierCommunityGroupCount);
                    }
                }
            }

            return lstSupplierCommunityGroupCount;
        }

        /// <summary>
        /// Retrieves community detail and list of community groups associated with the community and supplier. 
        /// </summary>
        /// <param name="communityId"></param>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public CommunityDetailResponse CommunityDetailBySupplierId(int communityId, int supplierId)
        {
            CommunityDetailResponse communityDetailResponse;
            List<CommunityDetailChildResponse> lstCommunityDetailChildResponse = new List<CommunityDetailChildResponse>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityDetailBySupplierId"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityId);
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    dataSet.Tables[0].TableName = "Community";
                    dataSet.Tables[1].TableName = "CommunityChild";

                    communityDetailResponse = new CommunityDetailResponse();
                    communityDetailResponse.Description = dataSet.Tables["Community"].Rows[0]["Description"].ToString();
                    communityDetailResponse.CommunityGroupCount = Convert.ToInt32(dataSet.Tables["Community"].Rows[0]["CommunityGroupCount"].ToString());
                    communityDetailResponse.SupplierCount = Convert.ToInt32(dataSet.Tables["Community"].Rows[0]["SupplierCount"].ToString());
                    communityDetailResponse.IsMember = Convert.ToInt32(dataSet.Tables["Community"].Rows[0]["IsMember"].ToString());

                    foreach (DataRow drCommunityGroup in dataSet.Tables["CommunityChild"].Rows)
                    {
                        CommunityDetailChildResponse communityDetailChildResponse = new CommunityDetailChildResponse();
                        communityDetailChildResponse.CommunityGroupId = Convert.ToInt32(drCommunityGroup["CommunityGroupId"].ToString());
                        communityDetailChildResponse.Name = drCommunityGroup["Name"].ToString();
                        communityDetailChildResponse.Description = drCommunityGroup["Description"].ToString();
                        communityDetailChildResponse.SupplierCount = Convert.ToInt32(drCommunityGroup["SupplierCount"].ToString());
                        communityDetailChildResponse.AverageRating = (drCommunityGroup["AverageRating"] == DBNull.Value) ? 0 : Convert.ToDecimal(drCommunityGroup["AverageRating"]);
                        communityDetailChildResponse.MyRating = (drCommunityGroup["MyRating"] == DBNull.Value) ? 0 : Convert.ToDecimal(drCommunityGroup["MyRating"]);
                        communityDetailChildResponse.ReviewCount = Convert.ToInt32(drCommunityGroup["ReviewCount"].ToString());
                        communityDetailChildResponse.TotalIncome = (drCommunityGroup["TotalIncome"] == DBNull.Value) ? 0 : Convert.ToDecimal(drCommunityGroup["TotalIncome"]);
                        communityDetailChildResponse.CurrencyID = Convert.ToInt32(drCommunityGroup["CurrencyID"].ToString());
                        communityDetailChildResponse.CurrencyName = drCommunityGroup["CurrencyName"].ToString();
                        communityDetailChildResponse.IsActive = drCommunityGroup["Active"].ToString() == "1" ? "True" : "False";

                        lstCommunityDetailChildResponse.Add(communityDetailChildResponse);
                    }

                    communityDetailResponse.lstCommunityGroupDetail = lstCommunityDetailChildResponse;
                }
            }

            return communityDetailResponse;
        }

        /// <summary>
        /// Retrieves list of CommunityID and Name for a particular supplier.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<MenuItem> CommunityListActiveBySupplier(int supplierId)
        {
            List<MenuItem> lstMenuItem = new List<MenuItem>();
            MenuItem menuItem;
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityListActiveBySupplier"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                using (IDataReader drCommunity = objDb.ExecuteReader(cmd))
                {
                    while (drCommunity.Read())
                    {
                        menuItem = new MenuItem();
                        menuItem.text = drCommunity["Name"].ToString();
                        menuItem.url = "SupplierCommunityDetail.aspx?cid=" + CommonDAC.EncryptIt(drCommunity["CommunityID"].ToString());
                        menuItem.id = drCommunity["CommunityID"].ToString();
                        lstMenuItem.Add(menuItem);
                    }
                }
            }

            return lstMenuItem;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<MenuItem> ReviewCountBySupplier(int supplierId)
        {
            MenuItem menuItem;
            List<MenuItem> lstMenuItem = new List<MenuItem>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("ReviewCountBySupplier"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                using (IDataReader drMenuItem = objDb.ExecuteReader(cmd))
                {
                    while (drMenuItem.Read())
                    {
                        menuItem = new MenuItem();
                        menuItem.text = drMenuItem["menu"].ToString();
                        menuItem.url = "SupplierReviews.aspx?cid=" + CommonDAC.EncryptIt(drMenuItem["communityid"].ToString()) + "&gid=" + CommonDAC.EncryptIt(drMenuItem["communitygroupid"].ToString()) + "&sid=" + CommonDAC.EncryptIt(supplierId.ToString());
                        menuItem.CommunityID = drMenuItem["communityid"].ToString();
                        menuItem.CommunityGroupID = drMenuItem["communitygroupid"].ToString();
                        lstMenuItem.Add(menuItem);
                    }
                }
            }

            return lstMenuItem;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="communityId"></param>
        /// <param name="communityGroupId"></param>
        /// <param name="supplierId"></param>
        /// <param name="customerId"></param>
        /// <returns></returns>
        public SupplierReviewResponse SupplierReviewSelect(int ownerId, int communityId, int communityGroupId, int supplierId, int customerId)
        {
            SupplierReviewResponse supplierReviewResponse;
            ReviewResponse response;
            Review review;
            List<Review> lstReview = new List<Review>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierReviewSelect"))
            {
                objDb.AddInParameter(cmd, "in_ownerid", DbType.Int32, ownerId);
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, communityId);
                objDb.AddInParameter(cmd, "in_communitygroupid", DbType.Int32, communityGroupId);
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "in_customerid", DbType.Int32, customerId);
                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    dataSet.Tables[0].TableName = "SupplierName";
                    dataSet.Tables[1].TableName = "Review";

                    supplierReviewResponse = new SupplierReviewResponse();
                    if (dataSet.Tables["SupplierName"].Rows.Count > 0)
                        supplierReviewResponse.SupplierName = dataSet.Tables["SupplierName"].Rows[0]["CompanyName"].ToString();
                    foreach (DataRow drReview in dataSet.Tables["Review"].Rows)
                    {
                        review = new Review();
                        review.SupplierID = Convert.ToInt32(drReview["SupplierId"].ToString());
                        review.ReviewID = Convert.ToInt32(drReview["ReviewID"].ToString());
                        review.Rating = Convert.ToInt32(drReview["Rating"].ToString());
                        review.ReviewMessage = drReview["Review"].ToString();
                        review.ReviewDate = Convert.ToDateTime(drReview["ReviewDate"]);
                        review.HideReview = Convert.ToBoolean(drReview["HideReview"]);
                        review.CustomerHandle = drReview["Handle"].ToString();
                        review.ResponseCount = Convert.ToInt32(drReview["ResponseCount"].ToString());
                        review.CustomerID = Convert.ToInt32(drReview["CustomerID"].ToString());
                        review.CommunityName = drReview["CommunityName"].ToString();
                        review.CommunityGroupName = drReview["CommunityGroupName"].ToString();
                        review.SupplierActionID = Convert.ToInt32(string.IsNullOrEmpty(drReview["supplieractionid"].ToString()) ? "0" : drReview["supplieractionid"].ToString());
                        response = new ReviewResponse();
                        if (review.ResponseCount > 0)
                        {
                            response.Response = drReview["Response"].ToString();
                            response.ResponseDate = Convert.ToDateTime(drReview["ResponseDate"]);
                            response.HideResponse = Convert.ToBoolean(drReview["HideResponse"]);
                        }
                        else
                            response.ResponseDate = DateTime.Now;

                        review.Response = response;

                        lstReview.Add(review);
                    }

                    supplierReviewResponse.lstReview = lstReview;
                }
            }

            return supplierReviewResponse;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ownerId"></param>
        /// <param name="communityId"></param>
        /// <param name="communityGroupId"></param>
        /// <param name="supplierId"></param>
        /// <param name="customerId"></param>
        /// <param name="loggedinSupplierId"></param>
        /// <returns></returns>
        public SupplierReviewResponse SupplierReviewSelectBySupplier(int ownerId, int communityId, int communityGroupId, int supplierId, int customerId, int loggedinSupplierId)
        {
            SupplierReviewResponse supplierReviewResponse;
            ReviewResponse response;
            Review review;
            List<Review> lstReview = new List<Review>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("supplierreviewselectbysupplier"))
            {
                objDb.AddInParameter(cmd, "in_ownerid", DbType.Int32, ownerId);
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, communityId);
                objDb.AddInParameter(cmd, "in_communitygroupid", DbType.Int32, communityGroupId);
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "in_customerid", DbType.Int32, customerId);
                objDb.AddInParameter(cmd, "in_loggedinsupplierid", DbType.Int32, loggedinSupplierId);
                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    dataSet.Tables[0].TableName = "SupplierName";
                    dataSet.Tables[1].TableName = "Review";

                    supplierReviewResponse = new SupplierReviewResponse();
                    if (dataSet.Tables["SupplierName"].Rows.Count > 0)
                        supplierReviewResponse.SupplierName = dataSet.Tables["SupplierName"].Rows[0]["CompanyName"].ToString();
                    foreach (DataRow drReview in dataSet.Tables["Review"].Rows)
                    {
                        review = new Review();
                        review.SupplierID = Convert.ToInt32(drReview["SupplierId"].ToString());
                        review.ReviewID = Convert.ToInt32(drReview["ReviewID"].ToString());
                        review.Rating = Convert.ToInt32(drReview["Rating"].ToString());
                        review.ReviewMessage = drReview["Review"].ToString();
                        review.ReviewDate = Convert.ToDateTime(drReview["ReviewDate"]);
                        review.HideReview = Convert.ToBoolean(drReview["HideReview"]);
                        review.CustomerHandle = drReview["Handle"].ToString();
                        review.ResponseCount = Convert.ToInt32(drReview["ResponseCount"].ToString());
                        review.CustomerID = Convert.ToInt32(drReview["CustomerID"].ToString());
                        review.CommunityName = drReview["CommunityName"].ToString();
                        review.CommunityGroupName = drReview["CommunityGroupName"].ToString();
                        review.SupplierActionID = Convert.ToInt32(string.IsNullOrEmpty(drReview["supplieractionid"].ToString()) ? "0" : drReview["supplieractionid"].ToString());
                        review.CommunityOwnerID = Convert.ToInt32(string.IsNullOrEmpty(drReview["ownerid"].ToString()) ? "0" : drReview["ownerid"].ToString());
                        response = new ReviewResponse();
                        if (review.ResponseCount > 0)
                        {
                            response.Response = drReview["Response"].ToString();
                            response.ResponseDate = Convert.ToDateTime(drReview["ResponseDate"]);
                            response.HideResponse = Convert.ToBoolean(drReview["HideResponse"]);
                        }
                        else
                            response.ResponseDate = DateTime.Now;

                        review.Response = response;

                        lstReview.Add(review);
                    }

                    supplierReviewResponse.lstReview = lstReview;
                }
            }

            return supplierReviewResponse;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="reviewResponse"></param>
        public CustomerSupplierCommunication ReviewResponseInsert(ReviewResponse reviewResponse)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("ReviewResponseInsert"))
            {
                objDb.AddInParameter(cmd, "IN_ReviewID", DbType.Int32, reviewResponse.ReviewID);
                objDb.AddInParameter(cmd, "IN_Response", DbType.String, HttpUtility.UrlDecode(reviewResponse.Response));
                objDb.AddInParameter(cmd, "IN_ResPonseDate", DbType.DateTime, reviewResponse.ResponseDate);
                objDb.AddInParameter(cmd, "in_supplieractionid", DbType.Int32, reviewResponse.ReviewSupplierActionID);

                CustomerSupplierCommunication customerSupplierCommunication = new CustomerSupplierCommunication();
                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    DataTable dtMessageDetail = dataSet.Tables[dataSet.Tables.Count - 1];

                    foreach (DataRow drMessage in dtMessageDetail.Rows)
                    {
                        customerSupplierCommunication.SupplierActionId = Convert.ToInt32(drMessage["supplieractionid"].ToString());
                      //  customerSupplierCommunication.ReviewID = Convert.ToInt32(drMessage["reviewid"].ToString());
                        customerSupplierCommunication.CustomerEmail = drMessage["CustomerEmail"].ToString();
                        customerSupplierCommunication.CustomerFirstName = drMessage["CustomerFirstName"].ToString();
                        customerSupplierCommunication.CustomerLastName = drMessage["CustomerLastName"].ToString();
                        customerSupplierCommunication.SupplierEmail = drMessage["SupplierEmail"].ToString();
                        customerSupplierCommunication.SupplierName = drMessage["SupplierName"].ToString();

                        customerSupplierCommunication.CommunityName = drMessage["CommunityName"].ToString();
                        customerSupplierCommunication.CommunityGroupName = drMessage["CommunityGroupName"].ToString();
                    }
                }

                // objDb.ExecuteNonQuery(cmd);
                return customerSupplierCommunication;
            }
        }

        /// <summary>
        /// Retrieves community group detail and list of supplier details associated with the community group.
        /// </summary>
        /// <param name="communityGroupId"></param>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public CommunityGroupDetailResponse CommunityGroupDetailBySupplier(int communityGroupId, int supplierId)
        {
            CommunityGroupDetailResponse communityGroupDetailResponse = new CommunityGroupDetailResponse();
            List<CommunityGroupDetailChildResponse> lstCommunityGroupDetailChild = new List<CommunityGroupDetailChildResponse>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityGroupDetailBySupplier"))
            {
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, communityGroupId);
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    dataSet.Tables[0].TableName = "CommunityGroup";
                    dataSet.Tables[1].TableName = "CommunityGroupChild";

                    if (dataSet.Tables["CommunityGroup"].Rows.Count > 0)
                    {
                        communityGroupDetailResponse = new CommunityGroupDetailResponse();
                        communityGroupDetailResponse.CommunityID = Convert.ToInt32(dataSet.Tables["CommunityGroup"].Rows[0]["CommunityID"]);
                        communityGroupDetailResponse.CommunityGroupID = Convert.ToInt32(dataSet.Tables["CommunityGroup"].Rows[0]["CommunityGroupID"]);
                        communityGroupDetailResponse.SupplierCount = Convert.ToInt32(dataSet.Tables["CommunityGroup"].Rows[0]["SupplierCount"]);
                        communityGroupDetailResponse.IsMember = dataSet.Tables["CommunityGroup"].Rows[0]["IsMember"] == DBNull.Value ? 0 : Convert.ToInt32(dataSet.Tables["CommunityGroup"].Rows[0]["IsMember"]);
                        communityGroupDetailResponse.CommunityGroupRating = Convert.ToDecimal(dataSet.Tables["CommunityGroup"].Rows[0]["CommunityGroupRating"]);
                        communityGroupDetailResponse.HigherRatingSupplier = Convert.ToInt32(dataSet.Tables["CommunityGroup"].Rows[0]["HigherRatingSupplier"].ToString());
                        communityGroupDetailResponse.LowerRatingSupplier = Convert.ToInt32(dataSet.Tables["CommunityGroup"].Rows[0]["LowerRatingSupplier"].ToString());
                        communityGroupDetailResponse.EqualRatingSupplier = Convert.ToInt32(dataSet.Tables["CommunityGroup"].Rows[0]["EqualRatingSupplier"].ToString());
                        communityGroupDetailResponse.SupplierRating = Convert.ToDecimal(dataSet.Tables["CommunityGroup"].Rows[0]["SupplierRating"]);

                        foreach (DataRow drCommunityGroup in dataSet.Tables["CommunityGroupChild"].Rows)
                        {
                            CommunityGroupDetailChildResponse communityGroupDetailChildResponse = new CommunityGroupDetailChildResponse();
                            communityGroupDetailChildResponse.SupplierCommunityGroupRating = Convert.ToDecimal(drCommunityGroup["SupplierCommunityGroupRating"]);
                            communityGroupDetailChildResponse.SupplierID = Convert.ToInt32(drCommunityGroup["SupplierID"].ToString());
                            communityGroupDetailChildResponse.SupplierName = drCommunityGroup["SupplierName"].ToString();
                            communityGroupDetailChildResponse.Longitude = Convert.ToDecimal(drCommunityGroup["Longitude"]);
                            communityGroupDetailChildResponse.Latitude = Convert.ToDecimal(drCommunityGroup["Latitude"]);
                            communityGroupDetailChildResponse.Description = drCommunityGroup["Description"].ToString();
                            communityGroupDetailChildResponse.ReviewCount = Convert.ToInt32(drCommunityGroup["ReviewCount"].ToString());

                            lstCommunityGroupDetailChild.Add(communityGroupDetailChildResponse);
                        }

                        communityGroupDetailResponse.lstCommunityGroupDetailChild = lstCommunityGroupDetailChild;
                    }
                }
            }

            return communityGroupDetailResponse;
        }

        /// <summary>
        /// Retrieves list of CommunityGroupID and Name for a particular supplier.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<MenuItem> CommunityGroupListActiveBySupplier(int supplierId)
        {
            List<MenuItem> lstMenuItem = new List<MenuItem>();
            MenuItem menuItem;
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityGroupListActiveBySupplier"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                using (IDataReader drCommunity = objDb.ExecuteReader(cmd))
                {
                    while (drCommunity.Read())
                    {
                        menuItem = new MenuItem();
                        menuItem.text = drCommunity["CommunityName"].ToString() + " - " + drCommunity["CommunityGroupName"].ToString();
                        menuItem.url = "SupplierCommunityGroupDetail.aspx?gid=" + CommonDAC.EncryptIt(drCommunity["CommunityGroupID"].ToString());
                        menuItem.id = drCommunity["CommunityGroupID"].ToString();
                        lstMenuItem.Add(menuItem);
                    }
                }
            }

            return lstMenuItem;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<CommunitySupplier> SupplierCreditSummary(int supplierId)
        {
            CommunitySupplier communitySupplier;
            List<CommunitySupplier> lstCommunitySupplier = new List<CommunitySupplier>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SUPPLIERCREDITSUMMARY"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                using (IDataReader drCredit = objDb.ExecuteReader(cmd))
                {
                    while (drCredit.Read())
                    {
                        communitySupplier = new CommunitySupplier();
                        communitySupplier.CommunityID = Convert.ToInt32(drCredit["CommunityID"].ToString());
                        communitySupplier.CommunityName = drCredit["Name"].ToString();
                        communitySupplier.CreditAmount = Convert.ToDecimal(drCredit["CreditAmt"].ToString());

                        communitySupplier.Balance = Convert.ToDecimal(drCredit["Balance"].ToString());
                        communitySupplier.DateJoined = CommonDAC.MYSQLDateTime();
                        communitySupplier.CurrencyID = Convert.ToInt32(drCredit["CurrencyID"].ToString());
                        communitySupplier.CurrencyName = drCredit["CurrencyName"].ToString();
                        lstCommunitySupplier.Add(communitySupplier);
                    }
                }
            }
            return lstCommunitySupplier;
        }

        /// <summary>
        /// Retrieves list of supplier details associated with the community group.
        /// </summary>
        /// <param name="communityGroupId"></param>
        /// <param name="ratingType"></param>
        /// <returns></returns>
        public List<CommunityGroupDetailChildResponse> CommunityGroupReviewBySupplierRating(int communityGroupId, int supplierId, string ratingType)
        {
            CommunityGroupDetailChildResponse communityGroupDetailChildResponse;
            List<CommunityGroupDetailChildResponse> lstCommunityGroupDetailChildResponse = new List<CommunityGroupDetailChildResponse>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityGroupReviewBySupplierRating"))
            {
                objDb.AddInParameter(cmd, "in_communitygroupid", DbType.Int32, communityGroupId);
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "in_mode", DbType.String, ratingType);
                using (IDataReader drCommunityGroup = objDb.ExecuteReader(cmd))
                {
                    while (drCommunityGroup.Read())
                    {
                        communityGroupDetailChildResponse = new CommunityGroupDetailChildResponse();
                        communityGroupDetailChildResponse.SupplierCommunityGroupRating = Convert.ToDecimal(drCommunityGroup["SupplierCommunityGroupRating"]);
                        communityGroupDetailChildResponse.SupplierID = Convert.ToInt32(drCommunityGroup["SupplierID"].ToString());
                        communityGroupDetailChildResponse.SupplierName = drCommunityGroup["SupplierName"].ToString();
                        communityGroupDetailChildResponse.Longitude = Convert.ToDecimal(drCommunityGroup["Longitude"]);
                        communityGroupDetailChildResponse.Latitude = Convert.ToDecimal(drCommunityGroup["Latitude"]);
                        communityGroupDetailChildResponse.Description = drCommunityGroup["Description"].ToString();
                        communityGroupDetailChildResponse.ReviewCount = Convert.ToInt32(drCommunityGroup["ReviewCount"].ToString());

                        lstCommunityGroupDetailChildResponse.Add(communityGroupDetailChildResponse);
                    }
                }
            }

            return lstCommunityGroupDetailChildResponse;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="reviewResponse"></param>
        public void ReviewHideUpdate(Review review)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("ReviewHideUpdate"))
            {
                objDb.AddInParameter(cmd, "in_reviewid", DbType.Int32, review.ReviewID);
                objDb.AddInParameter(cmd, "in_hidereview", DbType.Boolean, review.HideReview);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<SupplierDashboardResponse> CommunityCommunityGroupBySupplier(int supplierId)
        {
            SupplierDashboardResponse supplierDashboardResponse;
            List<SupplierDashboardResponse> lstSupplierDashboardResponse = new List<SupplierDashboardResponse>();
            SupplierCommunityGroupResponse supplierCommunityGroupResponse;
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CommunityCommunityGroupBySupplier"))
            {
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierId);
                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    dataSet.Tables[0].TableName = "Community";
                    dataSet.Tables[1].TableName = "CommunityGroup";
                    dataSet.Tables[2].TableName = "PastMonthActivity";

                    foreach (DataRow drCommunity in dataSet.Tables["Community"].Rows)
                    {
                        supplierDashboardResponse = new SupplierDashboardResponse();
                        supplierDashboardResponse.CommunityID = Convert.ToInt32(drCommunity["communityid"]);
                        supplierDashboardResponse.CommunityName = drCommunity["name"].ToString();
                        supplierDashboardResponse.Credit = Convert.ToDecimal(drCommunity["credit"]);
                        supplierDashboardResponse.CurrencyID = Convert.ToInt32(drCommunity["CurrencyID"]);
                        supplierDashboardResponse.CurrencyName = drCommunity["CurrencyName"].ToString();
                        supplierDashboardResponse.IsActive = drCommunity["Active"].ToString() == "1" ? "True" : "False";

                        DataTable dtCommunityGroup = dataSet.Tables["CommunityGroup"];
                        IEnumerable<DataRow> result = from A in dtCommunityGroup.AsEnumerable() select A;
                        IEnumerable<DataRow> communityGroupResult = result.Where(A => A.Field<int>("communityid") == supplierDashboardResponse.CommunityID);

                        supplierDashboardResponse.lstSupplierCommunityGroupResponse = new List<SupplierCommunityGroupResponse>();
                        foreach (var communityGroup in communityGroupResult)
                        {
                            supplierCommunityGroupResponse = new SupplierCommunityGroupResponse();
                            supplierCommunityGroupResponse.CommunityID = communityGroup.Field<int>("communityid");
                            supplierCommunityGroupResponse.CommunityGroupID = communityGroup.Field<int>("communitygroupid");
                            supplierCommunityGroupResponse.CommunityGroupName = communityGroup.Field<string>("name");
                            supplierCommunityGroupResponse.AverageRating = communityGroup.Field<decimal>("avgrating");
                            supplierCommunityGroupResponse.ReviewCount = communityGroup.Field<Int64>("reviewcount");
                            supplierCommunityGroupResponse.ResponsePendingCount = communityGroup.Field<Int64>("responsependingcount");
                            supplierCommunityGroupResponse.ActionRequired = communityGroup.Field<Int64>("responsependingcount") > 0 ? "True" : "False";
                            supplierCommunityGroupResponse.IsActive = communityGroup["active"].ToString() == "1" ? "True" : "False";

                            DataTable dtPastMonthActivity = dataSet.Tables["PastMonthActivity"];
                            IEnumerable<DataRow> query = from A in dtPastMonthActivity.AsEnumerable() select A;
                            IEnumerable<DataRow> pastMonthResult = query.Where(A => A.Field<int>("communitygroupid") == supplierCommunityGroupResponse.CommunityGroupID);

                            string pastMonthActivity = string.Empty;
                            int count = 0;
                            foreach (var pastMonth in pastMonthResult)
                            {
                                count = count + 1;
                                pastMonthActivity = pastMonthActivity + pastMonth.Field<Int64>("actioncount") + " " + pastMonth.Field<string>("name");
                                if (count != pastMonthResult.Count())
                                {
                                    pastMonthActivity = pastMonthActivity + ", ";
                                }
                            }

                            supplierCommunityGroupResponse.PastMonthActivity = pastMonthActivity;
                            supplierDashboardResponse.lstSupplierCommunityGroupResponse.Add(supplierCommunityGroupResponse);
                        }

                        lstSupplierDashboardResponse.Add(supplierDashboardResponse);
                    }
                }
            }

            return lstSupplierDashboardResponse;
        }


        /// <summary>
        ///  Retrives supplier transaction details based on the input parameters.
        /// </summary>
        /// <param name="supplierCommunityTransactionHistory"></param>
        /// <returns></returns>
        public List<SupplierCommunityTransactionHistory> SupplierCommunityTransactionSelect(SupplierCommunityTransactionHistory supplierCommunityTransactionHistory)
        {
            List<SupplierCommunityTransactionHistory> lstSupplierCommunityTransactionHistory = new List<SupplierCommunityTransactionHistory>();
            DbCommand cmd;
            DateTime? date = null;
            Common common = new Common();
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierCommunityTransactionSelect"))
            {
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierCommunityTransactionHistory.SupplierID);
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, supplierCommunityTransactionHistory.CommunityID);
                objDb.AddInParameter(cmd, "in_communitygroupid", DbType.Int32, supplierCommunityTransactionHistory.CommunityGroupID);
                objDb.AddInParameter(cmd, "in_fromdate", DbType.Date, supplierCommunityTransactionHistory.FromDate == "null" ? date : common.ParseDate(supplierCommunityTransactionHistory.FromDate, "dd/MM/yyyy"));
                objDb.AddInParameter(cmd, "in_todate", DbType.Date, supplierCommunityTransactionHistory.ToDate == "null" ? date : common.ParseDate(supplierCommunityTransactionHistory.ToDate, "dd/MM/yyyy"));
                objDb.AddInParameter(cmd, "in_rowindex", DbType.Int32, supplierCommunityTransactionHistory.RowIndex);
                objDb.AddInParameter(cmd, "in_rowcount", DbType.Int32, supplierCommunityTransactionHistory.RowCount);
                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    dataSet.Tables[0].TableName = "SupplierCommunity";
                    dataSet.Tables[1].TableName = "TotalRecords";

                    foreach (DataRow drSupplierCommunity in dataSet.Tables["SupplierCommunity"].Rows)
                    {
                        supplierCommunityTransactionHistory = new SupplierCommunityTransactionHistory();
                        supplierCommunityTransactionHistory.Description = drSupplierCommunity["description"].ToString();
                        supplierCommunityTransactionHistory.CommunityName = drSupplierCommunity["communityname"].ToString();
                        supplierCommunityTransactionHistory.CommunityGroupName = drSupplierCommunity["communitygroupname"].ToString();
                        supplierCommunityTransactionHistory.CustomerName = drSupplierCommunity["customername"].ToString();
                        supplierCommunityTransactionHistory.DateApplied = Convert.ToDateTime(drSupplierCommunity["dateapplied"]);
                        supplierCommunityTransactionHistory.Amount = Convert.ToDecimal(drSupplierCommunity["amount"]);
                        supplierCommunityTransactionHistory.Balance = Convert.ToDecimal(drSupplierCommunity["balance"]);
                        supplierCommunityTransactionHistory.CurrencyID = Convert.ToInt32(drSupplierCommunity["CurrencyID"]);
                        supplierCommunityTransactionHistory.CurrencyName = drSupplierCommunity["CurrencyName"].ToString();
                        supplierCommunityTransactionHistory.TotalRecords = Convert.ToInt32(dataSet.Tables["TotalRecords"].Rows[0]["TotalRecords"].ToString());
                        lstSupplierCommunityTransactionHistory.Add(supplierCommunityTransactionHistory);
                    }
                }
            }

            return lstSupplierCommunityTransactionHistory;
        }

        public List<SupplierBillingResponse> SupplierMonthlyBilling(SupplierCommunityTransactionHistory supplierCommunityTransactionHistory)
        {
            List<SupplierBillingResponse> lstSupplierBillingReference = new List<SupplierBillingResponse>();
            SupplierBillingResponse supplierBillingReference = new SupplierBillingResponse();

            List<SupplierCommunityTransactionHistory> lstSupplierCommunityTransactionHistory = new List<SupplierCommunityTransactionHistory>();
            DbCommand cmd;
            DateTime? date = null;
            Common common = new Common();
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("suppliermonthlybilling"))
            {

                objDb.AddInParameter(cmd, "in_fromdate", DbType.Date, supplierCommunityTransactionHistory.FromDate == "null" ? date : common.ParseDate(supplierCommunityTransactionHistory.FromDate, "dd/MM/yyyy"));
                objDb.AddInParameter(cmd, "in_todate", DbType.Date, supplierCommunityTransactionHistory.ToDate == "null" ? date : common.ParseDate(supplierCommunityTransactionHistory.ToDate, "dd/MM/yyyy"));

                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    dataSet.Tables[0].TableName = "Supplier";
                    dataSet.Tables[1].TableName = "Transaction";

                    foreach (DataRow drSupplier in dataSet.Tables["Supplier"].Rows)
                    {
                        supplierBillingReference = new SupplierBillingResponse();
                        supplierBillingReference.SupplierID = Convert.ToInt32(drSupplier["supplierid"].ToString());
                        supplierBillingReference.SupplierName = drSupplier["companyname"].ToString();
                        supplierBillingReference.Email = drSupplier["email"].ToString();

                        DataRow[] drSeq = dataSet.Tables["Transaction"].Select("supplierid=" + drSupplier["supplierid"].ToString());

                        foreach (DataRow drSupplierCommunity in drSeq)
                        {
                            supplierCommunityTransactionHistory = new SupplierCommunityTransactionHistory();
                            supplierCommunityTransactionHistory.Description = drSupplierCommunity["description"].ToString();
                            supplierCommunityTransactionHistory.CommunityName = drSupplierCommunity["communityname"].ToString();
                            supplierCommunityTransactionHistory.CommunityGroupName = drSupplierCommunity["communitygroupname"].ToString();
                            supplierCommunityTransactionHistory.CustomerName = drSupplierCommunity["customername"].ToString();
                            supplierCommunityTransactionHistory.DateApplied = Convert.ToDateTime(drSupplierCommunity["dateapplied"]);
                            supplierCommunityTransactionHistory.Amount = Convert.ToDecimal(drSupplierCommunity["amount"]);
                            supplierCommunityTransactionHistory.Balance = Convert.ToDecimal(drSupplierCommunity["balance"]);
                            supplierCommunityTransactionHistory.CurrencyID = Convert.ToInt32(drSupplierCommunity["CurrencyID"]);
                            supplierCommunityTransactionHistory.CurrencyName = drSupplierCommunity["CurrencyName"].ToString();

                            lstSupplierCommunityTransactionHistory.Add(supplierCommunityTransactionHistory);
                        }

                        supplierBillingReference.listSupplierTransactionHistory = lstSupplierCommunityTransactionHistory;

                        lstSupplierBillingReference.Add(supplierBillingReference);
                    }
                }
            }

            return lstSupplierBillingReference;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="communityGroupId"></param>
        /// <returns></returns>
        public SupplierActivity SupplierActionSelectByCommunityGroup(int supplierId, int communityGroupId)
        {
            SupplierActivity supplierActivity = new SupplierActivity();
            SupplierAction supplierAction;
            AvailableAction availableAction;
            List<SupplierAction> lstSupplierAction = new List<SupplierAction>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("supplieractionselectbycommunitygroup"))
            {
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "in_communitygroupid", DbType.Int32, communityGroupId);
                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    dataSet.Tables[0].TableName = "Supplier";
                    dataSet.Tables[1].TableName = "Action";

                    foreach (DataRow drSupplierAction in dataSet.Tables["Supplier"].Rows)
                    {
                        supplierAction = new SupplierAction();
                        supplierAction.ActionDate = Convert.ToDateTime(drSupplierAction["ActionDate"]);
                        supplierAction.Detail = drSupplierAction["Detail"].ToString();
                        supplierAction.CustomerID = Convert.ToInt32(drSupplierAction["CustomerID"]);
                        supplierAction.CustomerName = drSupplierAction["CustomerName"].ToString();
                        supplierAction.ActionName = drSupplierAction["ActionName"].ToString();
                        supplierAction.SupplierActionID = Convert.ToInt32(drSupplierAction["SupplierActionID"]);
                        supplierAction.ActionID = Convert.ToInt32(drSupplierAction["ActionID"]);
                        supplierAction.CommunityID = Convert.ToInt32(drSupplierAction["communityid"].ToString());
                        supplierAction.CustomerQuoteID = Convert.ToInt32(drSupplierAction["CustomerQuoteID"].ToString());

                        DataTable dtAction = dataSet.Tables["Action"];
                        IEnumerable<DataRow> query = from A in dtAction.AsEnumerable() select A;
                        IEnumerable<DataRow> actionResult = query.Where(A => A.Field<int>("SupplierActionID") == supplierAction.SupplierActionID);

                        supplierAction.lstAvailableAction = new List<AvailableAction>();
                        foreach (var action in actionResult)
                        {
                            availableAction = new AvailableAction();
                            availableAction.ActionID = action.Field<int>("ActionID");
                            availableAction.ResponseID = action.Field<int>("ResponseID");
                            availableAction.SupplierActionID = action.Field<int>("SupplierActionID");
                            availableAction.ResponseName = action.Field<string>("ResponseName");

                            supplierAction.lstAvailableAction.Add(availableAction);
                        }

                        lstSupplierAction.Add(supplierAction);
                    }
                }
            }

            supplierActivity.RowIndex = 0;
            supplierActivity.lstSupplierAction = lstSupplierAction;
            return supplierActivity;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="communityGroupId"></param>
        /// <returns></returns>
        public SupplierActivity SupplierActionSelectByCommunityGroup(int supplierId, int communityGroupId, int supplierActionId)
        {
            SupplierActivity supplierActivity = new SupplierActivity();
            SupplierAction supplierAction;
            AvailableAction availableAction;
            List<SupplierAction> lstSupplierAction = new List<SupplierAction>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("supplieractionselectbycommunitygroup"))
            {
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "in_communitygroupid", DbType.Int32, communityGroupId);
                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    dataSet.Tables[0].TableName = "Supplier";
                    dataSet.Tables[1].TableName = "Action";

                    foreach (DataRow drSupplierAction in dataSet.Tables["Supplier"].Rows)
                    {
                        supplierAction = new SupplierAction();
                        supplierAction.ActionDate = Convert.ToDateTime(drSupplierAction["ActionDate"]);
                        supplierAction.Detail = drSupplierAction["Detail"].ToString();
                        supplierAction.CustomerID = Convert.ToInt32(drSupplierAction["CustomerID"]);
                        supplierAction.CustomerName = drSupplierAction["CustomerName"].ToString();
                        supplierAction.ActionName = drSupplierAction["ActionName"].ToString();
                        supplierAction.SupplierActionID = Convert.ToInt32(drSupplierAction["SupplierActionID"]);
                        supplierAction.ActionID = Convert.ToInt32(drSupplierAction["ActionID"]);
                        supplierAction.CommunityID = Convert.ToInt32(drSupplierAction["communityid"].ToString());
                        supplierAction.CustomerQuoteID = Convert.ToInt32(drSupplierAction["CustomerQuoteID"].ToString());

                        DataTable dtAction = dataSet.Tables["Action"];
                        IEnumerable<DataRow> query = from A in dtAction.AsEnumerable() select A;
                        IEnumerable<DataRow> actionResult = query.Where(A => A.Field<int>("SupplierActionID") == supplierAction.SupplierActionID);

                        supplierAction.lstAvailableAction = new List<AvailableAction>();
                        foreach (var action in actionResult)
                        {
                            availableAction = new AvailableAction();
                            availableAction.ActionID = action.Field<int>("ActionID");
                            availableAction.ResponseID = action.Field<int>("ResponseID");
                            availableAction.SupplierActionID = action.Field<int>("SupplierActionID");
                            availableAction.ResponseName = action.Field<string>("ResponseName");

                            supplierAction.lstAvailableAction.Add(availableAction);
                        }

                        lstSupplierAction.Add(supplierAction);
                    }
                }
            }

            if (lstSupplierAction.Count > 0)
            {
                SupplierAction sAction = new SupplierAction();
                var obj = lstSupplierAction.Where(A => A.SupplierActionID == supplierActionId);
                int index = lstSupplierAction.IndexOf(obj.FirstOrDefault());
                supplierActivity.RowIndex = index;
                supplierActivity.lstSupplierAction = lstSupplierAction;
            }
            return supplierActivity;
        }


        /// <summary>
        /// Retrieves social media reference details based on supplier id and social media id.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="socialMediaId"></param>
        /// <returns></returns>
        public SupplierSocialReference SupplierSocialReferenceSelectBySocialMedia(int supplierId, int socialMediaId)
        {
            SupplierSocialReference supplierSocialReference = new SupplierSocialReference();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierSocialReferenceSelectBySocialMedia"))
            {
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "in_mediaid", DbType.Int32, socialMediaId);
                using (IDataReader drSocialReference = objDb.ExecuteReader(cmd))
                {
                    while (drSocialReference.Read())
                    {
                        supplierSocialReference.SupplierSocialReferenceID = Convert.ToInt32(drSocialReference["SupplierSocialReferenceID"]);
                        supplierSocialReference.SupplierID = Convert.ToInt32(drSocialReference["SupplierID"]);
                        supplierSocialReference.SocialMediaID = Convert.ToInt32(drSocialReference["SocialMediaID"]);
                        supplierSocialReference.SocialMediaReference = drSocialReference["SocialMediaReference"].ToString();
                    }
                }
            }

            return supplierSocialReference;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<MenuItem> SupplierActionCount(int supplierId)
        {
            MenuItem menuItem;
            List<MenuItem> lstMenuItem = new List<MenuItem>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("supplieractioncount"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                using (DataSet ds = objDb.ExecuteDataSet(cmd))
                {
                    DataTable dtCommunity = ds.Tables[0];
                    DataTable dtAction = ds.Tables[1];
                    string menutext = string.Empty;
                    foreach (DataRow drComunity in dtCommunity.Rows)
                    {
                        menutext = string.Empty;
                        IEnumerable<DataRow> result = from A in dtAction.AsEnumerable() select A;
                        IEnumerable<DataRow> communityGroupResult = result.Where(A => A.Field<int>("communityid") == Convert.ToInt32(drComunity["communityid"].ToString()) && A.Field<int>("communitygroupid") == Convert.ToInt32(drComunity["communitygroupid"].ToString()));
                        foreach (var action in communityGroupResult)
                        {
                            menutext = menutext + action["actioncount"].ToString() + " " + action["actionname"].ToString() + ", ";
                        }
                        if (!string.IsNullOrEmpty(menutext))
                        {
                            menutext = menutext.Substring(0, menutext.Length - 2);
                            menutext = drComunity["communityname"].ToString() + " - " + drComunity["communitygroupname"].ToString() + "( " + menutext + " )";
                        }
                        menuItem = new MenuItem();
                        menuItem.text = menutext;
                        menuItem.url = "SupplierActivityTracker.aspx?gid=" + CommonDAC.EncryptIt(drComunity["communitygroupid"].ToString());
                        menuItem.CommunityID = drComunity["communityid"].ToString();
                        menuItem.CommunityGroupID = drComunity["communitygroupid"].ToString();
                        lstMenuItem.Add(menuItem);
                    }
                }
            }

            return lstMenuItem;
        }

        /// <summary>
        /// Retrieves supplier action detail based on supplier action id.
        /// </summary>
        /// <param name="supplierActionId"></param>
        /// <returns></returns>
        public SupplierAction SupplierActionSelect(int supplierActionId)
        {
            SupplierAction supplierAction = new SupplierAction();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierActionSelect"))
            {
                objDb.AddInParameter(cmd, "in_supplieractionid", DbType.Int32, supplierActionId);
                bool flag = false;
                using (IDataReader drSupplierAction = objDb.ExecuteReader(cmd))
                {
                    while (drSupplierAction.Read())
                    {
                        supplierAction.SupplierActionID = Convert.ToInt32(drSupplierAction["SupplierActionID"]);
                        supplierAction.CustomerID = Convert.ToInt32(drSupplierAction["CustomerID"]);
                        supplierAction.SupplierID = Convert.ToInt32(drSupplierAction["SupplierID"]);
                        supplierAction.CommunityID = Convert.ToInt32(drSupplierAction["CommunityID"]);
                        supplierAction.CommunityGroupID = Convert.ToInt32(drSupplierAction["CommunityGroupID"]);
                        supplierAction.ActionID = Convert.ToInt32(drSupplierAction["ActionID"]);
                        supplierAction.ActionDate = Convert.ToDateTime(drSupplierAction["ActionDate"]);
                        supplierAction.Detail = drSupplierAction["Detail"].ToString();
                        supplierAction.ResponseActionPerformed = Convert.ToBoolean(drSupplierAction["ResponseActionPerformed"]);
                        supplierAction.ParentSupplierActionId = drSupplierAction["ParentSupplierActionId"] == DBNull.Value ? 0 : Convert.ToInt32(drSupplierAction["ParentSupplierActionId"]);
                        supplierAction.CurrencyId = Convert.ToInt32(drSupplierAction["CurrencyId"]);
                        supplierAction.CurrencyName = drSupplierAction["CurrencyName"].ToString();
                        supplierAction.ActionName = drSupplierAction["ActionName"].ToString();
                        supplierAction.CustomerName = drSupplierAction["CustomerName"].ToString();
                        supplierAction.Message = drSupplierAction["message"].ToString();
                        supplierAction.IsAttachment = string.IsNullOrEmpty(drSupplierAction["CustomerSupplierActionAttachmentID"].ToString()) ? false : true;
                        supplierAction.FileName = drSupplierAction["filename"].ToString();
                        flag = true;
                    }

                    if (flag == false) { supplierAction.ActionDate = DateTime.Now; }
                }
            }

            return supplierAction;
        }

        /// <summary>
        /// Retrieves supplier action detail based on supplier action id.
        /// </summary>
        /// <param name="supplierActionId"></param>
        /// <returns></returns>
        public SupplierAction SupplierPArentActionSelect(int supplierActionId)
        {
            SupplierAction supplierAction = new SupplierAction();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierParentActionSelect"))
            {
                objDb.AddInParameter(cmd, "in_supplieractionid", DbType.Int32, supplierActionId);
                bool flag = false;
                using (IDataReader drSupplierAction = objDb.ExecuteReader(cmd))
                {
                    while (drSupplierAction.Read())
                    {
                        supplierAction.SupplierActionID = Convert.ToInt32(drSupplierAction["SupplierActionID"]);
                        supplierAction.CustomerID = Convert.ToInt32(drSupplierAction["CustomerID"]);
                        supplierAction.SupplierID = Convert.ToInt32(drSupplierAction["SupplierID"]);
                        supplierAction.CommunityID = Convert.ToInt32(drSupplierAction["CommunityID"]);
                        supplierAction.CommunityGroupID = Convert.ToInt32(drSupplierAction["CommunityGroupID"]);
                        supplierAction.ActionID = Convert.ToInt32(drSupplierAction["ActionID"]);
                        supplierAction.ActionDate = Convert.ToDateTime(drSupplierAction["ActionDate"]);
                        supplierAction.Detail = drSupplierAction["Detail"].ToString();
                        supplierAction.ResponseActionPerformed = Convert.ToBoolean(drSupplierAction["ResponseActionPerformed"]);
                        supplierAction.ParentSupplierActionId = drSupplierAction["ParentSupplierActionId"] == DBNull.Value ? 0 : Convert.ToInt32(drSupplierAction["ParentSupplierActionId"]);
                        supplierAction.CurrencyId = Convert.ToInt32(drSupplierAction["CurrencyId"]);
                        supplierAction.CurrencyName = drSupplierAction["CurrencyName"].ToString();
                        supplierAction.ActionName = drSupplierAction["ActionName"].ToString();
                        supplierAction.CustomerName = drSupplierAction["CustomerName"].ToString();
                        supplierAction.Message = drSupplierAction["message"].ToString();
                        supplierAction.IsAttachment = string.IsNullOrEmpty(drSupplierAction["CustomerSupplierActionAttachmentID"].ToString()) ? false : true;
                        supplierAction.FileName = drSupplierAction["filename"].ToString();
                        flag = true;
                    }

                    if (flag == false) { supplierAction.ActionDate = DateTime.Now; }
                }
            }

            return supplierAction;
        }

        /// <summary>
        /// Returns pending count based on supplier id and community group id.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="communityGroupId"></param>
        /// <returns></returns>
        public int SupplierReviewPendingCountByCommunityGroupId(int supplierId, int communityGroupId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierReviewPendingCountByCommunityGroupId"))
            {
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "in_communitygroupid", DbType.Int32, communityGroupId);
                return Convert.ToInt32(objDb.ExecuteScalar(cmd));
            }
        }

        /// <summary>
        /// Delete Supplier from supplier and action tables (Unit test purpose)
        /// </summary>
        /// <param name="supplierId"></param>
        public void SupplierActionDeleteBySupplier(int supplierId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("UT_SupplierActionDeleteBySupplier"))
            {
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierId);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Retrieves star, review and pending count based on communityId, communityGroupId and supplierId.
        /// </summary>
        /// <param name="communityId"></param>
        /// <param name="communityGroupId"></param>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public MenuItem SupplierReviewCountByCommunityGroup(int communityId, int communityGroupId, int supplierId, int ownerId, int loggedinSupplierId)
        {
            MenuItem menuItem = new MenuItem();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("SupplierReviewCountByCommunityGroup"))
            {
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, communityId);
                objDb.AddInParameter(cmd, "in_communitygroupid", DbType.Int32, communityGroupId);
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "in_ownerid", DbType.Int32, ownerId);
                objDb.AddInParameter(cmd, "in_loggedinsupplierid", DbType.Int32, loggedinSupplierId);

                using (IDataReader drSupplierReview = objDb.ExecuteReader(cmd))
                {
                    while (drSupplierReview.Read())
                    {
                        menuItem.text = drSupplierReview["Menu"].ToString();
                    }
                }
            }

            return menuItem;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="currentdate"></param>
        public void BillFreeEndDateUpdate(DateTime currentdate)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("billfreeenddateupdate"))
            {
                objDb.AddInParameter(cmd, "in_currentdate", DbType.DateTime, currentdate);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// The supplier current Virtual Community Account balance for the given community.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public decimal SupplierAccountBalanceByCommunity(int supplierId, int communityId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("supplieraccountbalancebycommunity"))
            {
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, communityId);
                return Convert.ToDecimal(objDb.ExecuteScalar(cmd));
            }
        }
    }
}