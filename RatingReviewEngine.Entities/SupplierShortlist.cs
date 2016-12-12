using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class SupplierShortlist
    {
        #region Basic Properties

        public int SupplierShortlistID { get; set; }

        public int CustomerID { get; set; }

        public int CommunityID { get; set; }

        public int CommunityGroupID { get; set; }

        public int SupplierID { get; set; }

        #endregion

        #region Relative Properties

        public bool Add { get; set; }

        #endregion
    }
}
