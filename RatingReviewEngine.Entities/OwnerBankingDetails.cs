using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    class OwnerBankingDetails
    {
        #region Basic Properties

        public int OwnerID { get; set; }

        public string Bank { get; set; }

        public string AccountName { get; set; }

        public string BSB { get; set; }

        public string AccountNumber { get; set; }

        #endregion

        #region Relative Properties

        #endregion
    }
}
