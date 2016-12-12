using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    class CreditAllocationTypes
    {
        #region Basic Properties

        public int CreditAllocationTypeID { get; set; }

        /// <summary>
        /// Options include: "Credit", "Allocation", "Debit"
        /// </summary>
        public string Name { get; set; }

        #endregion

        #region Relative Properties

        #endregion
    }
}
