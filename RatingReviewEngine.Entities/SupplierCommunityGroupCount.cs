using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class SupplierCommunityGroupCount
    {
        public int CommunityID { get; set; }

        public string CommunityName { get; set; }

        public int Active { get; set; }

        public int Inactive { get; set; }

        public int Total { get; set; }
    }
}
