using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class CustomerRewards
    {
        #region Basic Properties

        public int CustomerRewardID { get; set; }

        /// <summary>
        /// The community that these customer reward points are associated to.
        /// </summary>
        public int CommunityID { get; set; }

        public int CustomerID { get; set; }

        /// <summary>
        /// The datetime stamp of when the reward was applied
        /// </summary>
        public DateTime? RewardDate { get; set; }

        public int CommunityRewardID { get; set; }

        public string RewardName { get; set; }

        public string RewardDescription { get; set; }

        /// <summary>
        /// The number of points that were applied at the time the reward was given.
        /// NB: If points have been revoked (e.g. for a review that has been 'hidden' by the community owner, then this field must cater for a negative PointsApplied value
        /// </summary>
        public int PointsApplied { get; set; }

        public int TriggeredEventsID { get; set; }

        #endregion

        #region Relative Properties

        #endregion
    }
}
