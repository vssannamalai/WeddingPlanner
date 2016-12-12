using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    class CommunityReward
    {
        #region Basic Properties

        public int CommunityRewardID { get; set; }

        public int CommunityID { get; set; }

        public int TriggeredEventsID { get; set; }

        public int Points { get; set; }
 
        #endregion


        #region Relative Properties

        #endregion
    }
}
