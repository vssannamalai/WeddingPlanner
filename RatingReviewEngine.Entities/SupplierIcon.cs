using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class SupplierIcon
    {
        #region Basic Properties

        public int SupplierID { get; set; }

        public Byte[] Icon { get; set; }

        public string Base64String { get; set; }  
        #endregion

        #region Relative Properties

        #endregion
    }
}
