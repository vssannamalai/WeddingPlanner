using System;
using System.Collections.Generic;
using System.Runtime.Remoting.Channels;
using System.Web;
using RatingReviewEngine.Business.Shared;
using RatingReviewEngine.DAC;
using RatingReviewEngine.Entities;
using RatingReviewEngine.Entities.ServiceRequest;
using RatingReviewEngine.Entities.ServiceResponse;

//using iTextSharp.text;
//using iTextSharp.text.pdf;
//using iTextSharp.text.html.simpleparser;


namespace RatingReviewEngine.Business
{
    public class SupplierComponent
    {
        /// <summary>
        /// 1. Create a new supplier record with the supplied details (Supplier)
        /// 2. Associate the newly created Supplier record (Supplier.SupplierID) with the supplied OAuth Account (OAuthAccount.OAuthAccountID) (EntityOAuthAccount) 
        /// </summary>
        /// <param name="supplier"></param>
        /// <returns></returns>
        public int RegisterNewSupplier(Supplier supplier)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.RegisterNewSupplier(supplier);
        }

        /// <summary>
        ///  Create a new supplier record (Supplier) with the supplied details
        /// </summary>
        /// <param name="supplier"></param>
        /// <returns></returns>
        public int SupplierInsert(Supplier supplier)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierInsert(supplier);
        }

        /// <summary>
        /// Update an existing supplier record (Supplier.SupplierID) with the supplied details (Supplier)
        /// </summary>
        /// <param name="supplier"></param>
        public void SupplierUpdate(Supplier supplier)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            supplierDAC.SupplierUpdate(supplier);
        }

        /// <summary>
        /// Get all Supplier
        /// </summary>
        /// <returns></returns>
        public List<Supplier> SupplierSelectAll()
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierSelectAll();
        }

        /// <summary>
        ///  Retrieve the details of the given SupplierID from the Supplier table (Supplier.SupplierID)
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public Supplier SupplierSelect(int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierSelect(supplierId);
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
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierSearch(searchTerm, communityId, communityGroupId, filter);
        }

        /// <summary>
        /// Delete Supplier from tabel (Unit test purpose)
        /// </summary>
        /// <param name="supplierId"></param>
        public void SupplierDelete(int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            supplierDAC.SupplierDelete(supplierId);
        }

        /// <summary>
        /// Insert a new supplierIcon record with the supplied details (SuppliedIcon)
        /// If already exists then Update Icon
        /// </summary>
        /// <param name="supplierIcon"></param>
        public void SupplierIconInsert(SupplierIcon supplierIcon)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            supplierDAC.SupplierIconInsert(supplierIcon);
        }

        /// <summary>
        /// Get Supplier Icon based on SupplierId
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public SupplierIcon SupplierIconSelect(int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierIconSelect(supplierId);
        }

        /// <summary>
        /// Delete Supplier Icon
        /// </summary>
        /// <param name="supplierId"></param>
        public void SupplierIconDelete(int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            supplierDAC.SupplierIconDelete(supplierId);
        }

        /// <summary>
        /// Insert a new supplierLogo record with the supplied details (SuppliedIcon)
        /// If already exist then update Logo
        /// </summary>
        /// <param name="supplierLogo"></param>
        public void SupplierLogoInsert(SupplierLogo supplierLogo)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            supplierDAC.SupplierLogoInsert(supplierLogo);
        }

        /// <summary>
        /// Get Supplier Logo based on SupplierId
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public SupplierLogo SupplierLogoSelect(int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierLogoSelect(supplierId);
        }

        /// <summary>
        /// Delete Supplier logo
        /// </summary>
        /// <param name="supplierId"></param>
        public void SupplierLogoDelete(int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            supplierDAC.SupplierLogoDelete(supplierId);
        }

        /// <summary>
        /// If Add = "true", then add the supplier to the customer's shortlist for the given community - community group (SupplierShortlist)
        /// If Add = "false", then remove the supplier from the customer's shortlist for the given community - community group (SupplierShortlist)
        /// </summary>
        /// <param name="supplierShortlist"></param>
        public void ShortlistUpate(SupplierShortlist supplierShortlist)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            supplierDAC.ShortlistUpate(supplierShortlist);
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
            SupplierDAC supplierDAC = new SupplierDAC();
            supplierDAC.SupplierNoteUpdate(supplierCustomerNote);
        }

        /// <summary>
        /// Insert a new social reference for the given supplier with the given details (SupplierSocialReference)
        /// </summary>
        /// <param name="supplierSocialReference"></param>
        public void SupplierSocialReferenceInsert(SupplierSocialReference supplierSocialReference)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            supplierDAC.SupplierSocialReferenceInsert(supplierSocialReference);
        }

        // <summary>
        /// Updates an existing social reference record for a supplier with the given details (SupplierSocialReference)
        /// </summary>
        /// <param name="supplierSocialReference"></param>
        public void SupplierSocialReferenceUpdate(SupplierSocialReference supplierSocialReference)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            supplierDAC.SupplierSocialReferenceUpdate(supplierSocialReference);
        }

        /// <summary>
        /// Remove the given supplier's social reference (SupplierSocialReference)
        /// </summary>
        /// <param name="supplierSocialReferenceId"></param>
        public void SupplierSocialReferenceDelete(int supplierSocialReferenceId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            supplierDAC.SupplierSocialReferenceDelete(supplierSocialReferenceId);
        }

        /// <summary>
        /// 1. Update the relevant bill free override record with the supplied details (SupplierCommunityBillFreeOverride) 
        /// (NB - if the supplied BillFreeEnd date is null/emtpy, then do not update this date - only update this field if a date is supplied.)
        /// </summary>
        /// <param name="supplierCommunityBillFreeOverride"></param>
        public void BillFreeOverRideUpdate(SupplierCommunityBillFreeOverride supplierCommunityBillFreeOverride)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            supplierDAC.BillFreeOverRideUpdate(supplierCommunityBillFreeOverride);
        }

        /// <summary>
        /// Check Supplier email is already exist. If exist return 1 else return 0.
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public string CheckSupplierEmailExist(int supplierId, string email)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.CheckSupplierEmailExist(supplierId, email);
        }

        /// <summary>
        /// Check Supplier Company name is already exist. If exist return 1 else return 0.
        /// For new record pass supplierId as 0
        /// </summary>
        /// <param name="companyName"></param>
        /// <returns></returns>
        public string CheckSupplierCompanyNameExist(int supplierId, string companyName)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.CheckSupplierCompanyNameExist(supplierId, companyName);
        }

        /// <summary>
        /// Get Supplier action by Customer & Supplier
        /// </summary>
        /// <param name="nCustomerID"></param>
        /// <param name="nSupplierID"></param>
        /// <returns></returns>
        public List<SupplierAction> SupplierActionSelectByCustomer(int supplierID, int customerID)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierActionSelectByCustomer(supplierID, customerID);
        }

        /// <summary>
        /// Get all Social Media
        /// </summary>
        /// <returns></returns>
        public List<SocialMedia> SocialMediaSelect()
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SocialMediaSelect();
        }

        /// <summary>
        /// Retrieve the details of the given SupplierID from the SupplierSocialReference
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<SupplierSocialReference> SupplierSocialReferenceSelect(int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierSocialReferenceSelect(supplierId);
        }

        /// <summary>
        /// Retrieves total count of active and inactive community from the CommunitySupplier table for a particular Supplier.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public SupplierCommunityCount SupplierCommunityMembershipCount(int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierCommunityMembershipCount(supplierId);
        }

        /// <summary>
        /// Retreives list of communities, active and inactive counts from each community and their total for a particular supplier.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<SupplierCommunityGroupCount> CommunityListBySupplier(int supplierId, int active)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.CommunityListBySupplier(supplierId, active);
        }

        /// <summary>
        /// Retrieves community detail and list of community groups associated with the community and supplier.
        /// </summary>
        /// <param name="communityId"></param>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public CommunityDetailResponse CommunityDetailBySupplierId(int communityId, int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.CommunityDetailBySupplierId(communityId, supplierId);
        }

        /// <summary>
        /// Retrieves list of CommunityID and Name for a particular supplier.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<MenuItem> CommunityListActiveBySupplier(int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.CommunityListActiveBySupplier(supplierId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<MenuItem> ReviewCountBySupplier(int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.ReviewCountBySupplier(supplierId);
        }

        /// <summary>
        /// Customer ID as optional(customerId=0)
        /// </summary>
        /// <param name="communityId"></param>
        /// <param name="communityGroupId"></param>
        /// <param name="supplierId"></param>
        /// <param name="customerId"></param>
        /// <returns></returns>
        public SupplierReviewResponse SupplierReviewSelect(int ownerId, int communityId, int communityGroupId, int supplierId, int customerId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierReviewSelect(ownerId, communityId, communityGroupId, supplierId, customerId);
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
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierReviewSelectBySupplier(ownerId, communityId, communityGroupId, supplierId, customerId, loggedinSupplierId);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="reviewResponse"></param>
        public CustomerSupplierCommunication ReviewResponseInsert(ReviewResponse reviewResponse)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
          return  supplierDAC.ReviewResponseInsert(reviewResponse);
        }

        /// <summary>
        /// Retrieves community group detail and list of supplier details associated with the community group.
        /// </summary>
        /// <param name="communityGroupId"></param>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public CommunityGroupDetailResponse CommunityGroupDetailBySupplier(int communityGroupId, int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.CommunityGroupDetailBySupplier(communityGroupId, supplierId);
        }

        /// <summary>
        /// Retrieves list of CommunityGroupID and Name for a particular supplier.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<MenuItem> CommunityGroupListActiveBySupplier(int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.CommunityGroupListActiveBySupplier(supplierId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<CommunitySupplier> SupplierCreditSummary(int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierCreditSummary(supplierId);
        }

        /// <summary>
        /// Retrieves list of supplier details associated with the community group.
        /// </summary>
        /// <param name="communityGroupId"></param>
        /// <param name="ratingType"></param>
        /// <returns></returns>
        public List<CommunityGroupDetailChildResponse> CommunityGroupReviewBySupplierRating(int communityGroupId, int supplierId, string ratingType)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.CommunityGroupReviewBySupplierRating(communityGroupId, supplierId, ratingType);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="reviewResponse"></param>
        public void ReviewHideUpdate(Review review)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            supplierDAC.ReviewHideUpdate(review);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<SupplierDashboardResponse> CommunityCommunityGroupBySupplier(int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.CommunityCommunityGroupBySupplier(supplierId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="exportSupplierCommunityTransaction"></param>
        /// <returns>Temporary file name where data exported. Returns String.Empty if no data exist</returns>
        public string DownloadSupplierCommunityTransaction(ExportSupplierCommunityTransactionRequest exportRequest)
        {
            var supplierDAC = new SupplierDAC();
            var transactionFilter = new SupplierCommunityTransactionHistory()
            {
                SupplierID = exportRequest.SupplierID,
                CommunityID = exportRequest.CommunityID,
                CommunityGroupID = exportRequest.CommunityGroupID,
                FromDate = exportRequest.FromDate,
                ToDate = exportRequest.ToDate,
                RowIndex = 0,
                RowCount = 0
            };

            List<SupplierCommunityTransactionHistory> lstTransactionHistories = supplierDAC.SupplierCommunityTransactionSelect(transactionFilter);
            if (lstTransactionHistories.Count > 0)
            {
                string fileName = General.RandomString(10) + "." + exportRequest.ExportType;
                if (exportRequest.ExportType.ToLower() == "csv")
                {
                    lstTransactionHistories.ToCSV(HttpContext.Current.Server.MapPath("~/Assets/ExportedFiles/") + fileName, "CommunityName,CommunityGroupName,Description,CustomerName,DateApplied,Amount,Balance,CurrencyName", "Community,Community Group,Description,Customer,Date,Amount,Balance,Currency");
                }
                else if (exportRequest.ExportType.ToLower() == "xml")
                {
                    //Extension method ToXML created in class RatingReviewEngine.Business.Shared.Export
                    lstTransactionHistories.ToXML(HttpContext.Current.Server.MapPath("~/Assets/ExportedFiles/") + fileName, "CommunityName,CommunityGroupName,Description,CustomerName,DateApplied,Amount,Balance,CurrencyName", "Community,Community Group,Description,Customer,Date,Amount,Balance,Currency");
                }


                return fileName;
            }
            else
            {
                return String.Empty;
            }

        }


        //public string DownloadSupplierTransactionPDF(ExportSupplierCommunityTransactionRequest exportRequest)
        //{
        //    var supplierDAC = new SupplierDAC();
        //    var transactionFilter = new SupplierCommunityTransactionHistory()
        //    {
        //        SupplierID = exportRequest.SupplierID,
        //        CommunityID = exportRequest.CommunityID,
        //        CommunityGroupID = exportRequest.CommunityGroupID,
        //        FromDate = exportRequest.FromDate,
        //        ToDate = exportRequest.ToDate,
        //        RowIndex = 0,
        //        RowCount = 0
        //    };

        //    List<SupplierCommunityTransactionHistory> lstTransactionHistories = supplierDAC.SupplierCommunityTransactionSelect(transactionFilter);
        //    if (lstTransactionHistories.Count > 0)
        //    {
        //        string fileName = General.RandomString(10) + ".pdf";
        //        iTextSharp.text.Table table = new iTextSharp.text.Table(5,lstTransactionHistories.Count);

        //        //Transfer rows from GridView to table

        //        string cellText = "Community";
        //        iTextSharp.text.Cell cell = new iTextSharp.text.Cell(cellText);
        //       // cell.BackgroundColor = new Color(System.Drawing.ColorTranslator.FromHtml("#93a31d"));
        //        table.AddCell(cell);

        //        cell = new iTextSharp.text.Cell("Community Group");
        //       // cell.BackgroundColor = new Color(System.Drawing.ColorTranslator.FromHtml("#93a31d"));
        //        table.AddCell(cell);

        //        cell = new iTextSharp.text.Cell("Customer");
        //       // cell.BackgroundColor = new Color(System.Drawing.ColorTranslator.FromHtml("#93a31d"));
        //        table.AddCell(cell);

        //        cell = new iTextSharp.text.Cell("Date");
        //      //  cell.BackgroundColor = new Color(System.Drawing.ColorTranslator.FromHtml("#93a31d"));
        //        table.AddCell(cell);

        //        cell = new iTextSharp.text.Cell("Amount");
        //       // cell.BackgroundColor = new Color(System.Drawing.ColorTranslator.FromHtml("#93a31d"));
        //        table.AddCell(cell);

        //        for (int i = 0; i < lstTransactionHistories.Count; i++)
        //        {

        //            cell = new iTextSharp.text.Cell(lstTransactionHistories[i].CommunityName);
        //            //cell.BackgroundColor = new Color(System.Drawing.ColorTranslator.FromHtml("#93a31d"));
        //            table.AddCell(cell);

        //            cell = new iTextSharp.text.Cell(lstTransactionHistories[i].CommunityGroupName);
        //            //cell.BackgroundColor = new Color(System.Drawing.ColorTranslator.FromHtml("#93a31d"));
        //            table.AddCell(cell);

        //            cell = new iTextSharp.text.Cell(lstTransactionHistories[i].CustomerName);
        //            //cell.BackgroundColor = new Color(System.Drawing.ColorTranslator.FromHtml("#93a31d"));
        //            table.AddCell(cell);

        //            cell = new iTextSharp.text.Cell(lstTransactionHistories[i].DateAppliedString);
        //            //cell.BackgroundColor = new Color(System.Drawing.ColorTranslator.FromHtml("#93a31d"));
        //            table.AddCell(cell);

        //            cell = new iTextSharp.text.Cell(lstTransactionHistories[i].CurrencyName + " " + lstTransactionHistories[i].Amount.ToString());
        //           // cell.BackgroundColor = new Color(System.Drawing.ColorTranslator.FromHtml("#93a31d"));
        //            table.AddCell(cell);


        //        }

        //        Document pdfDoc = new Document(PageSize.A4, 10f, 10f, 10f, 0f);
        //        PdfWriter.GetInstance(pdfDoc, new System.IO.FileStream(HttpContext.Current.Server.MapPath("~/Assets/ExportedFiles/") + fileName, System.IO.FileMode.Create));
        //        pdfDoc.Open();
        //        pdfDoc.Add(new Paragraph("Supplier Transactions"));

        //        pdfDoc.Add(table);
        //        pdfDoc.Close();

        //        return fileName;
        //    }
        //    else
        //    {
        //        return String.Empty;
        //    }
        //}

        /// <summary>
        ///  Retrives supplier transaction details based on the input parameters.
        /// </summary>
        /// <param name="supplierCommunityTransactionHistory"></param>
        /// <returns></returns>
        public List<SupplierCommunityTransactionHistory> SupplierCommunityTransactionSelect(SupplierCommunityTransactionHistory supplierCommunityTransactionHistory)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierCommunityTransactionSelect(supplierCommunityTransactionHistory);
        }

        public List<SupplierBillingResponse> SupplierMonthlyBilling(SupplierCommunityTransactionHistory supplierCommunityTransactionHistory)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierMonthlyBilling(supplierCommunityTransactionHistory);
        }
        /// <summary>
        /// Retrieves social media reference details based on supplier id and social media id.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="socialMediaId"></param>
        /// <returns></returns>
        public SupplierSocialReference SupplierSocialReferenceSelectBySocialMedia(int supplierId, int socialMediaId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierSocialReferenceSelectBySocialMedia(supplierId, socialMediaId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="communityGroupId"></param>
        /// <returns></returns>
        public SupplierActivity SupplierActionSelectByCommunityGroup(int supplierId, int communityGroupId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierActionSelectByCommunityGroup(supplierId, communityGroupId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="communityGroupId"></param>
        /// <returns></returns>
        public SupplierActivity SupplierActionSelectByCommunityGroup(int supplierId, int communityGroupId, int supplierActionId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierActionSelectByCommunityGroup(supplierId, communityGroupId, supplierActionId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<MenuItem> SupplierActionCount(int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierActionCount(supplierId);
        }

        /// <summary>
        /// Retrieves supplier action detail based on supplier action id.
        /// </summary>
        /// <param name="supplierActionId"></param>
        /// <returns></returns>
        public SupplierAction SupplierActionSelect(int supplierActionId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierActionSelect(supplierActionId);
        }

        /// <summary>
        /// Retrieves supplier action detail based on supplier action id.
        /// </summary>
        /// <param name="supplierActionId"></param>
        /// <returns></returns>
        public SupplierAction SupplierPArentActionSelect(int supplierActionId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierPArentActionSelect(supplierActionId);
        }

        /// <summary>
        /// Returns pending count based on supplier id and community group id.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="communityGroupId"></param>
        /// <returns></returns>
        public int SupplierReviewPendingCountByCommunityGroupId(int supplierId, int communityGroupId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierReviewPendingCountByCommunityGroupId(supplierId, communityGroupId);
        }

        /// <summary>
        /// Delete Supplier from supplier and action tables (Unit test purpose)
        /// </summary>
        /// <param name="supplierId"></param>
        public void SupplierActionDeleteBySupplier(int supplierId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            supplierDAC.SupplierActionDeleteBySupplier(supplierId);
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
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierReviewCountByCommunityGroup(communityId, communityGroupId, supplierId, ownerId, loggedinSupplierId);
        }

        public void BillFreeEndDateUpdate(DateTime currentdate)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            supplierDAC.BillFreeEndDateUpdate(currentdate);
        }

        /// <summary>
        /// The supplier current Virtual Community Account balance for the given community.
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public decimal SupplierAccountBalanceByCommunity(int supplierId, int communityId)
        {
            SupplierDAC supplierDAC = new SupplierDAC();
            return supplierDAC.SupplierAccountBalanceByCommunity(supplierId, communityId);
        }
    }
}