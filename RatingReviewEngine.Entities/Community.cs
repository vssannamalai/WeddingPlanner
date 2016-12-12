using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class Community
    {
        #region Basic Properties

        public int CommunityID { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        public int CurrencyId { get; set; }

        public int CountryID { get; set; }

        public int OwnerID { get; set; }

        /// <summary>
        /// Specifies the longitude coordinate of the area centre to which this community applies
        /// </summary>
        public decimal CentreLongitude { get; set; }

        /// <summary>
        /// Specifies the latitude coordinate of the area centre to which this community applies
        /// </summary>
        public decimal CentreLatitude { get; set; }

        /// <summary>
        /// Specifies the radius out from the centre (based on CentreLongitude & CentreLatitude) that covers the primary area of this community.
        /// </summary>
        public decimal AreaRadius { get; set; }

        /// <summary>
        /// The auto-transfer amount is the amount of money that the community owner wants automatically transferred from their virtual 
        /// account to their designated account. I.e., if the community owner sets the auto-transfer amount for the given community to 
        /// be "100.00", then once the balance within the community owner's account community balance reaches $100.00, the community 
        /// owner will have $100.00 transferred out of their virtual account and into their specified bank account.
        /// </summary>
        public decimal? AutoTransferAmtOwner { get; set; }

        /// <summary>
        /// If the community is active within the system, then the value is "1"
        /// If the community is not active within the system, then the value is "0"
        /// </summary>
        public bool Active { get; set; }

        #endregion

        #region Relative Properties
        public int CommunityGroupCount { get; set; }

        public int InCreditSuppliersCount { get; set; }

        public int OutofCreditSuppliersCount { get; set; }

        public int BelowMinCreditSuppliersCount { get; set; }

        public int CustomersCount { get; set; }

        public decimal CurrentRevenue { get; set; }

        public string CurrencyName { get; set; }

        public string CountryName { get; set; }

        public decimal CurrencyMinTransferAmount { get; set; }
        #endregion
    }
}
