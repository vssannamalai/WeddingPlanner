using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class CommunitySupplier
    {
        #region Basic Properties

        public int CommunitySupplierID { get; set; }

        public int SupplierID { get; set; }

        public int CommunityID { get; set; }

        /// <summary>
        /// The date the supplier joined the community
        /// </summary>
        public DateTime DateJoined { get; set; }

        /// <summary>
        /// If the supplier is a current member of a community, then the value of this field will be "true"
        /// If the supplier is not a current member of this community, then the value will be "false"
        /// </summary>
        public int IsActive { get; set; }

        /// <summary>
        /// The auto-transfer amount is the amount of money that the supplier wants automatically transferred from their virtual account to their designated account. I.e., if the supplier sets the auto-transfer amount for the given community to be "100.00", then once the balance within the supplier's virtual community account reaches $100.00, the supplier will have $100.00 transferred out of their virtual account and into their specified bank account.
        /// </summary>
        public decimal? AutoTransferAmtSupplier { get; set; }

        public bool AutoTopUp { get; set; }

        public decimal? MinCredit { get; set; }


        #endregion

        #region Relative Properties

        public decimal CreditAmount { get; set; }

        public decimal CurrentRevenue { get; set; }

        public decimal Balance { get; set; }
        
        public string CommunityName { get; set; }

        public int CurrencyID { get; set; }

        public string CurrencyName { get; set; }

        #endregion
    }
}
