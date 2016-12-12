using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.Common;
using System.Web;

using Microsoft.Practices.EnterpriseLibrary.Data;
using RatingReviewEngine.Entities;

namespace RatingReviewEngine.DAC
{
    public class CustomerDAC : DataAccessComponent
    {
        Database objDb = DatabaseFactory.CreateDatabase(CONNECTION_NAME);

        /// <summary>
        /// 1. Insert  Customer record with the supplied details (Customer)
        /// </summary>
        /// <param name="customer"></param>
        /// <returns></returns>
        public int CustomerInsert(Customer customer)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CUSTOMERINSERT"))
            {
                objDb.AddInParameter(cmd, "IN_Email", DbType.String, customer.Email);
                objDb.AddInParameter(cmd, "IN_MobilePhone", DbType.String, customer.MobilePhone);
                objDb.AddInParameter(cmd, "IN_FirstName", DbType.String, customer.FirstName);
                objDb.AddInParameter(cmd, "IN_LastName", DbType.String, customer.LastName);
                objDb.AddInParameter(cmd, "IN_Handle", DbType.String, customer.Handle);
                objDb.AddInParameter(cmd, "IN_Gender", DbType.String, customer.Gender);
                objDb.AddInParameter(cmd, "IN_DateJoined", DbType.DateTime, customer.DateJoined);
                return Convert.ToInt32(objDb.ExecuteScalar(cmd));
            }
        }

        /// <summary>
        /// Update the existing Customer record (Customer.CustomerID) with the supplied details (Customer)
        /// </summary>
        /// <param name="customer"></param>
        public void CustomerUpdate(Customer customer)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CUSTOMERUPDATE"))
            {
                objDb.AddInParameter(cmd, "IN_CustomerID", DbType.Int32, customer.CustomerID);
                objDb.AddInParameter(cmd, "IN_Email", DbType.String, customer.Email);
                objDb.AddInParameter(cmd, "IN_MobilePhone", DbType.String, customer.MobilePhone);
                objDb.AddInParameter(cmd, "IN_FirstName", DbType.String, customer.FirstName);
                objDb.AddInParameter(cmd, "IN_LastName", DbType.String, customer.LastName);
                objDb.AddInParameter(cmd, "IN_Handle", DbType.String, customer.Handle);
                objDb.AddInParameter(cmd, "IN_Gender", DbType.String, customer.Gender);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Retrieve the details of the given CustomerID from the Customer table (Customer.CustomerID)
        /// </summary>
        /// <param name="customerId"></param>
        /// <returns></returns>
        public Customer CustomerSelect(int customerId)
        {
            Customer customer = new Customer();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CUSTOMERSELECT"))
            {
                objDb.AddInParameter(cmd, "IN_CustomerID", DbType.Int32, customerId);
                using (IDataReader drCustomer = objDb.ExecuteReader(cmd))
                {
                    while (drCustomer.Read())
                    {
                        customer.CustomerID = customerId;
                        customer.Email = drCustomer["Email"].ToString();
                        customer.MobilePhone = drCustomer["MobilePhone"].ToString();
                        customer.FirstName = drCustomer["FirstName"].ToString();
                        customer.LastName = drCustomer["LastName"].ToString();
                        customer.Handle = drCustomer["Handle"].ToString();
                        customer.Gender = Convert.ToChar(drCustomer["Gender"].ToString());
                        customer.DateJoined = Convert.ToDateTime(drCustomer["DateJoined"]);
                    }
                }

                return customer;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<Customer> CustomerSelectAll()
        {
            Customer customer; ;
            List<Customer> lstCustomer = new List<Customer>();

            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("customerselectall"))
            {

                using (IDataReader drCustomer = objDb.ExecuteReader(cmd))
                {
                    while (drCustomer.Read())
                    {
                        customer = new Customer();
                        customer.CustomerID = Convert.ToInt32(drCustomer["customerid"].ToString());
                        customer.Email = drCustomer["Email"].ToString();
                        customer.MobilePhone = drCustomer["MobilePhone"].ToString();
                        customer.FirstName = drCustomer["FirstName"].ToString();
                        customer.LastName = drCustomer["LastName"].ToString();
                        customer.Handle = drCustomer["Handle"].ToString();
                        customer.Gender = Convert.ToChar(drCustomer["Gender"].ToString());
                        customer.DateJoined = Convert.ToDateTime(drCustomer["DateJoined"]);

                        lstCustomer.Add(customer);
                    }
                }

                return lstCustomer;
            }
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
            Customer customer = new Customer();
            List<Customer> lstCustomer = new List<Customer>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CUSTOMERSEARCH"))
            {
                objDb.AddInParameter(cmd, "IN_SearchTerm", DbType.Int32, searchTerm);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityId);
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                using (IDataReader drCustomer = objDb.ExecuteReader(cmd))
                {
                    while (drCustomer.Read())
                    {
                        customer = new Customer();
                        customer.CustomerID = Convert.ToInt32(drCustomer["CustomerID"].ToString());
                        customer.Email = drCustomer["Email"].ToString();
                        customer.MobilePhone = drCustomer["MobilePhone"].ToString();
                        customer.FirstName = drCustomer["FirstName"].ToString();
                        customer.LastName = drCustomer["LastName"].ToString();
                        customer.Handle = drCustomer["Handle"].ToString();
                        customer.Gender = Convert.ToChar(drCustomer["Gender"].ToString());
                        customer.DateJoined = Convert.ToDateTime(drCustomer["DateJoined"]);

                        lstCustomer.Add(customer);
                    }
                }

                return lstCustomer;
            }
        }

        /// <summary>
        /// Delete Customer information from tabel(Customer) based on CustomerId (Unit test purpose)
        /// </summary>
        /// <param name="customerId"></param>
        public void CustomerDelete(int customerId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("UT_CUSTOMERDELETE"))
            {
                objDb.AddInParameter(cmd, "IN_CustomerID", DbType.Int32, customerId);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Insert a new CustomerAvatar record with the supplied details (CustomerAvatar)
        /// If already exist then update Avatar
        /// </summary>
        /// <param name="customerAvatar"></param>
        public void CustomerAvatarInsert(CustomerAvatar customerAvatar)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CUSTOMERAVATARINSERT"))
            {
                objDb.AddInParameter(cmd, "IN_CustomerID", DbType.Int32, customerAvatar.CustomerID);
                objDb.AddInParameter(cmd, "IN_Avatar", DbType.Binary, customerAvatar.Avatar);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Create a new review record (Review) with the supplied details 
        /// </summary>
        /// <param name="review"></param>
        public CustomerSupplierCommunication CustomerReviewInsert(Review review)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CUSTOMERREVIEWINSERT"))
            {
                objDb.AddInParameter(cmd, "IN_CustomerID", DbType.Int32, review.CustomerID);
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, review.SupplierID);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, review.CommunityID);
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, review.CommunityGroupID);
                objDb.AddInParameter(cmd, "IN_Rating", DbType.Int32, review.Rating);
                objDb.AddInParameter(cmd, "IN_Review", DbType.String, HttpUtility.UrlDecode(review.ReviewMessage));
                objDb.AddInParameter(cmd, "IN_ReviewDate", DbType.DateTime, CommonDAC.MYSQLDateTime());
                objDb.AddOutParameter(cmd, "out_reviewId", DbType.Int32, 4);
               // objDb.ExecuteNonQuery(cmd);
               // return Convert.ToInt32(cmd.Parameters[7].Value);
                CustomerSupplierCommunication customerSupplierCommunication = new CustomerSupplierCommunication();
                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    DataTable dtMessageDetail = dataSet.Tables[dataSet.Tables.Count - 1];
                    
                    foreach (DataRow drMessage in dtMessageDetail.Rows)
                    {
                        customerSupplierCommunication.SupplierActionId = Convert.ToInt32(drMessage["supplieractionid"].ToString());
                        customerSupplierCommunication.ReviewID = Convert.ToInt32(drMessage["reviewid"].ToString());
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
        /// Retrieve the details of a review from the supplied ReviewID (Review)
        /// </summary>
        /// <param name="reviewId"></param>
        /// <returns></returns>
        public Review CustomerReviewSelect(int reviewId)
        {
            Review review = new Review();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CUSTOMERREVIEWSELECT"))
            {
                objDb.AddInParameter(cmd, "IN_ReviewID", DbType.Int32, reviewId);
                using (IDataReader drReview = objDb.ExecuteReader(cmd))
                {
                    while (drReview.Read())
                    {
                        review.ReviewID = reviewId;
                        review.CustomerID = Convert.ToInt32(drReview["CustomerID"].ToString());
                        review.SupplierID = Convert.ToInt32(drReview["SupplierID"].ToString());
                        review.CommunityID = Convert.ToInt32(drReview["CommunityID"].ToString());
                        review.CommunityGroupID = Convert.ToInt32(drReview["CommunityGroupID"].ToString());
                        review.Rating = Convert.ToInt32(drReview["Rating"].ToString());
                        review.ReviewMessage = drReview["Review"].ToString();
                        review.ReviewDate = Convert.ToDateTime(drReview["ReviewDate"]);
                        review.HideReview = Convert.ToBoolean(drReview["HideReview"]);
                    }
                }
            }
            return review;
        }

        /// <summary>
        /// Retrieve all the reviews for the given Supplier within the given Community - Community Group (Review)
        /// </summary>
        /// <param name="supplierId"></param>
        /// <param name="CommunityId"></param>
        /// <param name="communityGroupId"></param>
        /// <returns></returns>
        public List<Review> CustomerReviewsSelect(int supplierId, int CommunityId, int communityGroupId)
        {
            List<Review> lstReview = new List<Review>();
            Review review = new Review();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CUSTOMERREVIEWSSELECT"))
            {
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, supplierId);
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, supplierId);
                using (IDataReader drReview = objDb.ExecuteReader(cmd))
                {
                    while (drReview.Read())
                    {
                        review = new Review();
                        review.ReviewID = Convert.ToInt32(drReview["ReviewID"].ToString()); ;
                        review.CustomerID = Convert.ToInt32(drReview["CustomerID"].ToString());
                        review.SupplierID = Convert.ToInt32(drReview["SupplierID"].ToString());
                        review.CommunityID = Convert.ToInt32(drReview["CommunityID"].ToString());
                        review.CommunityGroupID = Convert.ToInt32(drReview["CommunityGroupID"].ToString());
                        review.Rating = Convert.ToInt32(drReview["Rating"].ToString());
                        review.ReviewMessage = drReview["Review"].ToString();
                        review.ReviewDate = Convert.ToDateTime(drReview["ReviewDate"]);
                        review.HideReview = Convert.ToBoolean(drReview["HideReview"]);

                        lstReview.Add(review);
                    }
                }
            }
            return lstReview;
        }

        /// <summary>
        /// Delete Review from table (Unit test purpose)
        /// </summary>
        /// <param name="reviewId"></param>
        public void ReviewDelete(int reviewId)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("UT_REVIEWDELETE"))
            {
                objDb.AddInParameter(cmd, "IN_ReviewID", DbType.Int32, reviewId);
                objDb.ExecuteNonQuery(cmd);
            }
        }
        /// <summary>
        /// Insert a new 'review helpful' record (ReviewHelpful) with the supplied ReviewID and CustomerID
        /// </summary>
        /// <param name="reviewHelpful"></param>
        public void ReviewHelpfulInsert(ReviewHelpful reviewHelpful)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("REVIEWHELPFULINSERT"))
            {
                objDb.AddInParameter(cmd, "IN_ReviewID", DbType.Int32, reviewHelpful.ReviewID);
                objDb.AddInParameter(cmd, "IN_CustomerID", DbType.Int32, reviewHelpful.CustomerID);

                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Retrieve the response detail for the given Review (ReviewResponse.ReviewID)
        /// </summary>
        /// <param name="reviewId"></param>
        /// <returns></returns>
        public List<ReviewResponse> ReviewResponseSelect(int reviewId)
        {
            List<ReviewResponse> lstReviewResponse = new List<ReviewResponse>();
            ReviewResponse reviewResponse = new ReviewResponse();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("REVIEWRESPONSESELECT"))
            {
                objDb.AddInParameter(cmd, "IN_ReviewID", DbType.Int32, reviewId);
                using (IDataReader drReviewResponse = objDb.ExecuteReader(cmd))
                {
                    while (drReviewResponse.Read())
                    {
                        reviewResponse = new ReviewResponse();
                        reviewResponse.ReviewResponseID = Convert.ToInt32(drReviewResponse["ReviewResponseID"].ToString());
                        reviewResponse.ReviewID = Convert.ToInt32(drReviewResponse["ReviewID"].ToString());
                        reviewResponse.Response = drReviewResponse["Response"].ToString();
                        reviewResponse.ResponseDate = Convert.ToDateTime(drReviewResponse["ResponseDate"]);
                        reviewResponse.HideResponse = Convert.ToBoolean(drReviewResponse["HideResponse"]);

                        lstReviewResponse.Add(reviewResponse);
                    }
                }
            }
            return lstReviewResponse;
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
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CUSTOMERNOTEUPDATE"))
            {
                objDb.AddInParameter(cmd, "IN_CustomerID", DbType.Int32, supplierCustomerNote.CustomerID);
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, supplierCustomerNote.SupplierID);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, supplierCustomerNote.CommunityID);
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, supplierCustomerNote.CommunityGroupID);
                objDb.AddInParameter(cmd, "IN_NoteText", DbType.String, supplierCustomerNote.CustomerNote);

                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// Retrieve all the rewards for the given Customer - Community (CustomerRewards)
        /// </summary>
        /// <param name="customerId"></param>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public CustomerRewards RewardsSelect(int customerId, int communityId)
        {
            CustomerRewards customerRewards = new CustomerRewards();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("RewardSelect"))
            {
                objDb.AddInParameter(cmd, "IN_CustomerID", DbType.Int32, customerId);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityId);

                using (IDataReader drReward = objDb.ExecuteReader(cmd))
                {
                    while (drReward.Read())
                    {
                        customerRewards.CustomerRewardID = Convert.ToInt32(drReward["CustomerRewardID"].ToString());
                        customerRewards.CommunityID = Convert.ToInt32(drReward["CommunityID"].ToString());
                        customerRewards.CustomerID = Convert.ToInt32(drReward["CustomerID"].ToString());
                        if (drReward["RewardDate"] != DBNull.Value)
                            customerRewards.RewardDate = Convert.ToDateTime(drReward["RewardDate"]);
                        customerRewards.CommunityRewardID = Convert.ToInt32(drReward["CommunityRewardID"].ToString());
                        customerRewards.RewardName = drReward["RewardName"].ToString();
                        customerRewards.RewardDescription = drReward["RewardDescription"].ToString();
                        customerRewards.PointsApplied = Convert.ToInt32(drReward["PointsApplied"].ToString());
                        customerRewards.TriggeredEventsID = Convert.ToInt32(drReward["TiggeredEventsID"].ToString());
                    }
                }
            }
            return customerRewards;
        }

        /// <summary>
        /// Retrieve the current reward points tally for the given Customer in the context of the given Community (CustomerPointsTally)
        /// </summary>
        /// <param name="customerId"></param>
        /// <param name="communityId"></param>
        /// <returns></returns>
        public CustomerPointsTally RewardsTallySelect(int customerId, int communityId)
        {
            CustomerPointsTally customerPointsTally = new CustomerPointsTally();
            CustomerRewards customerRewards = new CustomerRewards();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("RewardsTallySelect"))
            {
                objDb.AddInParameter(cmd, "IN_CustomerID", DbType.Int32, customerId);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, communityId);

                using (IDataReader drReward = objDb.ExecuteReader(cmd))
                {
                    while (drReward.Read())
                    {
                        customerPointsTally.CustomerID = Convert.ToInt32(drReward["CustomerID"].ToString());
                        customerPointsTally.CommunityID = Convert.ToInt32(drReward["CommunityID"].ToString());
                        customerPointsTally.PointsTally = Convert.ToInt32(drReward["PointsTally"].ToString());

                    }
                }
            }
            return customerPointsTally;
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
        public List<Customer> CustomerSearchBySupplier(int nSupplierID, string strHandle = "", string strFirstName = "", string strLastName = "", string strEmail = "", int nCommunityGroupID = 0, int nActionID = 0, int customerId = 0)
        {
            Customer customer;
            List<Customer> lstCustomer = new List<Customer>();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CustomerSearchBySupplier"))
            {
                objDb.AddInParameter(cmd, "IN_Handle", DbType.String, HttpUtility.UrlDecode(strHandle));
                objDb.AddInParameter(cmd, "IN_FirstName", DbType.String, HttpUtility.UrlDecode(strFirstName));
                objDb.AddInParameter(cmd, "IN_LastName", DbType.String, HttpUtility.UrlDecode(strLastName));
                objDb.AddInParameter(cmd, "IN_Email", DbType.String, HttpUtility.UrlDecode(strEmail));
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, nCommunityGroupID);
                objDb.AddInParameter(cmd, "IN_ActionID", DbType.Int32, nActionID);
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, nSupplierID);
                objDb.AddInParameter(cmd, "IN_CustomerId", DbType.Int32, customerId);

                using (IDataReader drCustomer = objDb.ExecuteReader(cmd))
                {
                    while (drCustomer.Read())
                    {
                        customer = new Customer();
                        customer.CustomerID = Convert.ToInt32(drCustomer["CustomerID"].ToString());
                        customer.FirstName = drCustomer["FirstName"].ToString();
                        customer.LastName = drCustomer["LastName"].ToString();
                        customer.Handle = drCustomer["FirstName"].ToString() + " " + drCustomer["LastName"].ToString() + " " + "(" + drCustomer["Handle"].ToString() + ")";
                        customer.Email = drCustomer["Email"].ToString();
                        customer.DateJoined = Convert.ToDateTime(drCustomer["DateJoined"]);
                        customer.Gender = Convert.ToChar(drCustomer["Gender"]);
                        customer.CommunityGroup = drCustomer["CommunityCommunityGroupName"].ToString();
                        customer.ActionName = drCustomer["ActionName"].ToString();

                        lstCustomer.Add(customer);
                    }
                }
            }

            return lstCustomer;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="customerSupplierCommunication"></param>
        public CustomerSupplierCommunication CustomerSupplierCommunicationInsert(CustomerSupplierCommunication customerSupplierCommunication)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("customersuppliercommunicationinsert"))
            {
                objDb.AddInParameter(cmd, "IN_CustomerID", DbType.Int32, customerSupplierCommunication.CustomerId);
                objDb.AddInParameter(cmd, "IN_SupplierID", DbType.Int32, customerSupplierCommunication.SupplierId);
                objDb.AddInParameter(cmd, "IN_CommunityID", DbType.Int32, customerSupplierCommunication.CommunityId);
                objDb.AddInParameter(cmd, "IN_CommunityGroupID", DbType.Int32, customerSupplierCommunication.CommunityGroupId);
                objDb.AddInParameter(cmd, "IN_ActionId", DbType.Int32, customerSupplierCommunication.ActionId);
                objDb.AddInParameter(cmd, "in_actionname", DbType.String, customerSupplierCommunication.ActionName);
                objDb.AddInParameter(cmd, "in_message", DbType.String, HttpUtility.UrlDecode(customerSupplierCommunication.Message));
                objDb.AddInParameter(cmd, "in_parentsupplieractionid", DbType.Int32, customerSupplierCommunication.ParentSupplierActionId);

                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    DataTable dtMessageDetail = dataSet.Tables[dataSet.Tables.Count - 1];
                    foreach (DataRow drMessage in dtMessageDetail.Rows)
                    {
                        customerSupplierCommunication.SupplierActionId = Convert.ToInt32(drMessage["supplieractionid"].ToString());
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
        /// 
        /// </summary>
        /// <param name="customerQuote"></param>
        public CustomerQuote CustomerQuoteInsert(CustomerQuote customerQuote)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("customerquoteinsert"))
            {
                objDb.AddInParameter(cmd, "in_customerid", DbType.Int32, customerQuote.CustomerID);
                objDb.AddInParameter(cmd, "in_communityid", DbType.Int32, customerQuote.CommunityID);
                objDb.AddInParameter(cmd, "in_communitygroupid", DbType.Int32, customerQuote.CommunityGroupID);
                objDb.AddInParameter(cmd, "in_supplierid", DbType.Int32, customerQuote.SupplierID);
                //objDb.AddInParameter(cmd, "in_actionid", DbType.Int32, customerQuote.ActionID);
                objDb.AddInParameter(cmd, "in_quoteamount", DbType.Decimal, customerQuote.QuoteAmount);
                objDb.AddInParameter(cmd, "in_depositspecified", DbType.Boolean, customerQuote.DepositSpecified);
                objDb.AddInParameter(cmd, "in_depositamount", DbType.Decimal, customerQuote.DepositAmount);
                objDb.AddInParameter(cmd, "in_quoteterms", DbType.String, HttpUtility.UrlDecode(customerQuote.QuoteTerms));
                objDb.AddInParameter(cmd, "in_depositterms", DbType.String, HttpUtility.UrlDecode(customerQuote.DepositTerms));
                objDb.AddInParameter(cmd, "in_currencyid", DbType.Int32, customerQuote.CurrencyID);
                objDb.AddInParameter(cmd, "in_quotedetail", DbType.String, customerQuote.QuoteDetail);
                objDb.AddInParameter(cmd, "in_parentsupplieractionid", DbType.Int32, customerQuote.ParentSupplierActionID);

                using (DataSet dataSet = objDb.ExecuteDataSet(cmd))
                {
                    DataTable dtQuote = dataSet.Tables[dataSet.Tables.Count - 1];
                    foreach (DataRow drQuote in dtQuote.Rows)
                    {
                        customerQuote.CustomerEmail = drQuote["CustomerEmail"].ToString();
                        customerQuote.CustomerFirstName = drQuote["CustomerFirstName"].ToString();
                        customerQuote.CustomerLastName = drQuote["CustomerLastName"].ToString();
                        customerQuote.SupplierEmail = drQuote["SupplierEmail"].ToString();
                        customerQuote.SupplierName = drQuote["SupplierName"].ToString();

                        customerQuote.CommunityName = drQuote["CommunityName"].ToString();
                        customerQuote.CommunityGroupName = drQuote["CommunityGroupName"].ToString();
                        customerQuote.CurrencyCode = drQuote["ISOCode"].ToString();
                    }
                }

                return customerQuote;
            }
        }

        /// <summary>
        /// Retrieves customer quote detail based on quote id.
        /// </summary>
        /// <param name="quoteId"></param>
        /// <returns></returns>
        public CustomerQuote CustomerQuoteSelect(int quoteId)
        {
            CustomerQuote customerQuote = new CustomerQuote();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("CustomerQuoteSelect"))
            {
                objDb.AddInParameter(cmd, "in_quoteid", DbType.Int32, quoteId);
                using (IDataReader drQuote = objDb.ExecuteReader(cmd))
                {
                    while (drQuote.Read())
                    {
                        customerQuote.CustomerQuoteID = Convert.ToInt32(drQuote["CustomerQuoteID"]);
                        customerQuote.CustomerID = Convert.ToInt32(drQuote["CustomerID"]);
                        customerQuote.CommunityID = Convert.ToInt32(drQuote["CommunityID"]);
                        customerQuote.CommunityGroupID = Convert.ToInt32(drQuote["CommunityGroupID"]);
                        customerQuote.SupplierID = Convert.ToInt32(drQuote["SupplierID"]);
                        customerQuote.QuoteAmount = Convert.ToDecimal(drQuote["QuoteAmount"]);
                        customerQuote.DepositSpecified = Convert.ToBoolean(drQuote["DepositSpecified"]);
                        customerQuote.DepositAmount = Convert.ToDecimal(drQuote["DepositAmount"]);
                        customerQuote.QuoteTerms = drQuote["QuoteTerms"].ToString();
                        customerQuote.DepositTerms = drQuote["DepositTerms"].ToString();
                        customerQuote.CurrencyID = Convert.ToInt32(drQuote["CurrencyID"]);
                        customerQuote.QuoteDetail = drQuote["QuoteDetail"].ToString();
                        customerQuote.SupplierActionID = Convert.ToInt32(drQuote["SupplierActionID"]);
                    }
                }
            }

            return customerQuote;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplieractionId"></param>
        /// <returns></returns>
        public CustomerQuote CustomerQuoteSelectByParentSupplierActionId(int supplieractionId)
        {
            CustomerQuote customerQuote = new CustomerQuote();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("customerquoteselectbyparentsupplieractionid"))
            {
                objDb.AddInParameter(cmd, "in_parentsupplieractionid", DbType.Int32, supplieractionId);
                using (IDataReader drQuote = objDb.ExecuteReader(cmd))
                {
                    while (drQuote.Read())
                    {
                        customerQuote.CustomerQuoteID = Convert.ToInt32(drQuote["CustomerQuoteID"]);
                        customerQuote.CustomerID = Convert.ToInt32(drQuote["CustomerID"]);
                        customerQuote.CommunityID = Convert.ToInt32(drQuote["CommunityID"]);
                        customerQuote.CommunityGroupID = Convert.ToInt32(drQuote["CommunityGroupID"]);
                        customerQuote.SupplierID = Convert.ToInt32(drQuote["SupplierID"]);
                        customerQuote.QuoteAmount = Convert.ToDecimal(drQuote["QuoteAmount"]);
                        customerQuote.DepositSpecified = Convert.ToBoolean(drQuote["DepositSpecified"]);
                        customerQuote.DepositAmount = Convert.ToDecimal(drQuote["DepositAmount"]);
                        customerQuote.QuoteTerms = drQuote["QuoteTerms"].ToString();
                        customerQuote.DepositTerms = drQuote["DepositTerms"].ToString();
                        customerQuote.CurrencyID = Convert.ToInt32(drQuote["CurrencyID"]);
                        customerQuote.QuoteDetail = drQuote["QuoteDetail"].ToString();
                        customerQuote.SupplierActionID = Convert.ToInt32(drQuote["SupplierActionID"]);
                    }
                }
            }

            return customerQuote;
        }

        /// <summary>
        /// Insert Customer Supplier action attachment
        /// </summary>
        /// <param name="supplieractionId"></param>
        /// <param name="attachment"></param>
        public void CustomerSupplierActionAttachmentInsert(CustomerSupplierActionAttachment customerActionAttachment)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("customersupplieractionattachmentinsert"))
            {
                objDb.AddInParameter(cmd, "in_supplieractionid", DbType.Int32, customerActionAttachment.CustomerSupplierActionAttachmentID);
                objDb.AddInParameter(cmd, "in_attachment", DbType.Binary, customerActionAttachment.Attachment);
                objDb.AddInParameter(cmd, "in_filename", DbType.Binary, customerActionAttachment.FileName);
                objDb.ExecuteNonQuery(cmd);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="supplieractionId"></param>
        /// <returns></returns>
        public CustomerSupplierActionAttachment CustomerSupplieractionAttachmentSelect(int supplieractionId)
        {
            CustomerSupplierActionAttachment supplieractionattachment = new CustomerSupplierActionAttachment();
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("customersupplieractionattachmentselect"))
            {
                objDb.AddInParameter(cmd, "in_supplieractionid", DbType.Int32, supplieractionId);
                using (IDataReader drSupplier = objDb.ExecuteReader(cmd))
                {
                    while (drSupplier.Read())
                    {
                        supplieractionattachment.CustomerSupplierActionAttachmentID = Convert.ToInt32(drSupplier["CustomerSupplierActionAttachmentID"].ToString());
                        supplieractionattachment.Attachment = (Byte[])drSupplier["attachment"];
                        supplieractionattachment.FileName = drSupplier["filename"].ToString();
                    }
                }
            }

            return supplieractionattachment;
        }
    }
}
