using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class CustomerPointsTally
    {
        #region Basic Properties

        public int CustomerID { get; set; }

        public int CommunityID { get; set; }

        /// <summary>
        /// The current number of points that a customer has accrued.
        /// </summary>
        public int PointsTally { get; set; }

        #endregion

        #region Relative Properties

        #endregion
    }
}
