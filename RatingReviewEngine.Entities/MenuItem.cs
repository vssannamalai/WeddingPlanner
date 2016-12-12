using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class MenuItem
    {
        public string text { get; set; }

        public string cssClass { get; set; }

        public string url { get; set; }

        public string id { get; set; }

        public string CommunityID { get; set; }
        
        public string CommunityGroupID { get; set; }
    }
}