using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class Review
    {
        #region Basic Properties

        public int ReviewID { get; set; }

        public int CustomerID { get; set; }

        public int SupplierID { get; set; }

        public int CommunityID { get; set; }

        public int CommunityGroupID { get; set; }

        /// <summary>
        /// Minimum bound = 0, Maximum bound = 5
        /// </summary>
        public int Rating { get; set; }

        /// <summary>
        /// Review written by the Customer
        /// </summary>
        public string ReviewMessage { get; set; }

        /// <summary>
        /// Datetime stamp when the review was created.
        /// </summary>
        public DateTime ReviewDate { get; set; }

        /// <summary>
        /// If the review is able to be viewed publicly, then the value will be "false".
        /// If the review is required to be hidden, then the value will be "false".
        /// </summary>
        public bool HideReview { get; set; }

        public int SupplierActionID { get; set; }

        #endregion

        #region Relative Proprties

        public int ReviewsCount { get; set; }

        public int PendingCount { get; set; }

        public string CommunityGroupName { get; set; }

        public string CustomerHandle { get; set; }

        public int ResponseCount { get; set; }

        public ReviewResponse Response { get; set; }

        public string CommunityName { get; set; }

        public int CommunityOwnerID { get; set; }

        public string SupplierName { get; set; }

        public string ReviewDateString { get { return ReviewDate.ToString("dd/MM/yyyy hh:mm:tt").Replace("-", "/"); } set { /* NOOP */ } }

        #endregion
    }
}
