using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class CommunityGroupReward
    {
        #region Basic Properties
        public int CommunityGrouprewardID { get; set; }

        public int CommunityGroupID { get; set; }

        public int TriggeredEventsID { get; set; }

        public int Points { get; set; }

        #endregion

        #region Relative Properties

        public string ActionName { get; set; }

        public string CommunityGroupName { get; set; }

        public int CommunityID { get; set; }

        #endregion
    }
}
