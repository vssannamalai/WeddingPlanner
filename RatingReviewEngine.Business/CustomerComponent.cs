using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using RatingReviewEngine.DAC;
using RatingReviewEngine.Entities;

namespace RatingReviewEngine.Business
{
    public class CustomerComponent
    {
        /// <summary>
        /// 1. Insert  Customer record with the supplied details (Customer)
        /// </summary>
        /// <param name="customer"></param>
        /// <returns></returns>
        public int CustomerInsert(Customer customer)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            return customerDAC.CustomerInsert(customer);
        }

        /// <summary>
        /// Update the existing Customer record (Customer.CustomerID) with the supplied details (Customer)
        /// </summary>
        /// <param name="customer"></param>
        public void CustomerUpdate(Customer customer)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            customerDAC.CustomerUpdate(customer);
        }

        /// <summary>
        /// Retrieve the details of the given CustomerID from the Customer table (Customer.CustomerID)
        /// </summary>
        /// <param name="customerId"></param>
        /// <returns></returns>
        public Customer CustomerSelect(int customerId)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            return customerDAC.CustomerSelect(customerId);
        }

        public List<Customer> CustomerSelectAll()
        {
            CustomerDAC customerDAC = new CustomerDAC();
            return customerDAC.CustomerSelectAll();
        }

        /// <summary>
        /// If the SearchTerm is not null, based on a wildcard search (prepending '%' and appending '%' and replacing any blanks with '%'), use the supplied search term to search across 
        /// Customer.FirstName, Customer.LastName and Customer.Handle) for the given CommunityID (CustomerCommunity.CommunityID) and SupplierID (SupplierShortlist.SupplierID) 
        /// - NB: if the SupplierID or SearchTerm is not supplied, then ignore from search filter
        /// </summary>
        /// <param name="searchTerm"></param>
        /// <param name="communityId"></param>
        /// <param name="supplierId"></param>
        /// <returns></returns>
        public List<Customer> CustomerSearch(string searchTerm, int communityId, int supplierId)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            return customerDAC.CustomerSearch(searchTerm, communityId, supplierId);
        }

        /// <summary>
        /// Delete Customer information from tabel(Customer) based on CustomerId (Unit test purpose)
        /// </summary>
        /// <param name="customerId"></param>
        public void CustomerDelete(int customerId)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            customerDAC.CustomerDelete(customerId);
        }

        /// <summary>
        /// Insert a new CustomerAvatar record with the supplied details (CustomerAvatar)
        /// If already exist then update Avatar
        /// </summary>
        /// <param name="customerAvatar"></param>
        public void CustomerAvatarInsert(CustomerAvatar customerAvatar)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            customerDAC.CustomerAvatarInsert(customerAvatar);
        }

        /// <summary>
        /// Create a new review record (Review) with the supplied details
        /// </summary>
        /// <param name="review"></param>
        public CustomerSupplierCommunication CustomerReviewInsert(Review review)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            return customerDAC.CustomerReviewInsert(review);
        }

        /// <summary>
        /// Retrieve the details of a review from the supplied ReviewID (Review)
        /// </summary>
        /// <param name="reviewId"></param>
        /// <returns></returns>
        public Review CustomerReviewSelect(int reviewId)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            return customerDAC.CustomerReviewSelect(reviewId);
        }

        /// <summary>
        /// Retrieve all the reviews for the given Supplier within the given Community - Community Group (Review)
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="communityId"></param>
        /// <param name="communityGroupId"></param>
        /// <returns></returns>
        public List<Review> CustomerReviewsSelect(int supplierId, int communityId, int communityGroupId)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            return customerDAC.CustomerReviewsSelect(supplierId, communityId, communityGroupId);
        }

        /// <summary>
        /// Delete Review from table (Unit test purpose)
        /// </summary>
        /// <param name="reviewId"></param>
        public void ReviewDelete(int reviewId)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            customerDAC.ReviewDelete(reviewId);
        }

        /// <summary>
        /// Insert a new 'review helpful' record (ReviewHelpful) with the supplied ReviewID and CustomerID
        /// </summary>
        /// <param name="reviewHelpful"></param>
        public void ReviewHelpfulInsert(ReviewHelpful reviewHelpful)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            customerDAC.ReviewHelpfulInsert(reviewHelpful);
        }

        /// <summary>
        /// Retrieve the response detail for the given Review (ReviewResponse.ReviewID)
        /// </summary>
        /// <param name="reviewId"></param>
        /// <returns></returns>
        public List<ReviewResponse> ReviewResponseSelect(int reviewId)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            return customerDAC.ReviewResponseSelect(reviewId);
        }

        /// <summary>
        /// 1. Check if a record already exists for the given supplier-customer-community-community group relationship in the SupplierCustomerNote table and retieve the SupplierCustomerNote.SupplierCustomerNoteID if it does
        /// 2. If the returned SupplierCustomerNoteID is not null, update the existing record (SupplierCustomerNote.SupplierCustomerNoteID) with the updated Customer Note text (SupplierCustomerNote.CustomerNote)
        /// 3. If the returned SupplierCustomerNoteID is null, create a new record for the given supplier-customer-community-community group relationship in the SupplierCustomerNote table, 
        /// populating the customer note field (SupplierCustomerNote.CustomerNote)
        /// </summary>
        /// <param name="supplierCustomerNote"></param>
        public void CustomerNoteUpdate(SupplierCustomerNote supplierCustomerNote)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            customerDAC.CustomerNoteUpdate(supplierCustomerNote);
        }

        /// <summary>
        /// Retrieve all the rewards for the given Customer - Community (CustomerRewards)
        /// </summary>
        /// <param name="customerId"></param>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public CustomerRewards RewardsSelect(int customerId, int communityId)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            return customerDAC.RewardsSelect(customerId, communityId);
        }

        /// <summary>
        /// Retrieve the current reward points tally for the given Customer in the context of the given Community (CustomerPointsTally)
        /// </summary>
        /// <param name="customerId"></param>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public CustomerPointsTally RewardsTallySelect(int customerId, int communityId)
        {
            CustomerComponent customerComponent = new CustomerComponent();
            return customerComponent.RewardsTallySelect(customerId, communityId);
        }

        /// <summary>
        /// The customers associated to the supplier via the SupplierAction table will be searched with the selected filters applied.
        /// </summary>
        /// <param name="nSupplierID"></param>
        /// <param name="strHandle"></param>
        /// <param name="strFirstName"></param>
        /// <param name="strLastName"></param>
        /// <param name="strEmail"></param>
        /// <param name="nCommunityGroupID"></param>
        /// <param name="nActionID"></param>
        /// <returns></returns>
        public List<Customer> CustomerSearchBySupplier(int nSupplierID, string strHandle, string strFirstName, string strLastName, string strEmail, int nCommunityGroupID, int nActionID, int customerID)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            return customerDAC.CustomerSearchBySupplier(nSupplierID, strHandle, strFirstName, strLastName, strEmail, nCommunityGroupID, nActionID, customerID);
        }

        public CustomerSupplierCommunication CustomerSupplierCommunicationInsert(CustomerSupplierCommunication customerSupplierCommunication)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            return customerDAC.CustomerSupplierCommunicationInsert(customerSupplierCommunication);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="customerQuote"></param>
        public CustomerQuote CustomerQuoteInsert(CustomerQuote customerQuote)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            return customerDAC.CustomerQuoteInsert(customerQuote);
        }

        /// <summary>
        /// Retrieves customer quote detail based on quote id.
        /// </summary>
        /// <param name="quoteId"></param>
        /// <returns></returns>
        public CustomerQuote CustomerQuoteSelect(int quoteId)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            return customerDAC.CustomerQuoteSelect(quoteId);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplieractionId"></param>
        /// <returns></returns>
        public CustomerQuote CustomerQuoteSelectByParentSupplierActionId(int supplieractionId)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            return customerDAC.CustomerQuoteSelectByParentSupplierActionId(supplieractionId);
        }

        /// <summary>
        /// Insert Customer Supplier action attachment
        /// </summary>
        /// <param name="supplieractionId"></param>
        /// <param name="attachment"></param>
        public void CustomerSupplierActionAttachmentInsert(CustomerSupplierActionAttachment customerActionAttachment)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            customerDAC.CustomerSupplierActionAttachmentInsert(customerActionAttachment);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplieractionId"></param>
        /// <returns></returns>
        public CustomerSupplierActionAttachment CustomerSupplieractionAttachmentSelect(int supplieractionId)
        {
            CustomerDAC customerDAC = new CustomerDAC();
            return customerDAC.CustomerSupplieractionAttachmentSelect(supplieractionId);

        }
    }
}
