using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class ReviewHelpful
    {
        #region Basic Properties

        public int ReviewID { get; set; }

        public int CustomerID { get; set; }

        /// <summary>
        /// The datetime stamp of when the customer selected the 'i found this review helpful' option
        /// </summary>
        public DateTime? ReviewHelpfulDate { get; set; }

        #endregion

        #region Relative Properties

        #endregion
    }
}
