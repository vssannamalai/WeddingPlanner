using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities.ServiceRequest
{
    public class CommunitySearchRequest
    {
        public string Term { get; set; }

        public string Distance { get; set; }

        public string DistanceUnit { get; set; }

        public int SupplierID { get; set; }
    }
}
