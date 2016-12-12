using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using RatingReviewEngine.Entities.ServiceRequest;

namespace RatingReviewEngine.Entities
{
    public class Owner : ServiceRequestBase
    {
        #region Basic Properties

        public int OwnerID { get; set; }

        public string CompanyName { get; set; }

        public string Email { get; set; }

        public string BusinessNumber { get; set; }

        /// <summary>
        /// Will be defaulted to the currency of the community that the owner is owner of
        /// </summary>
        public int PreferredPaymentCurrencyID { get; set; }

        public string PrimaryPhone { get; set; }

        public string OtherPhone { get; set; }

        public DateTime DateAdded { get; set; }

        public string Website { get; set; }

        public string AddressLine1 { get; set; }

        public string AddressLine2 { get; set; }

        public string AddressCity { get; set; }

        public string AddressState { get; set; }

        public string AddressPostalCode { get; set; }

        public int? AddressCountryID { get; set; }

        public string BillingName { get; set; }

        public string BillingAddressLine1 { get; set; }

        public string BillingAddressLine2 { get; set; }

        public string BillingAddressCity { get; set; }

        public string BillingAddressState { get; set; }

        public string BillingAddressPostalCode { get; set; }

        public int? BillingAddressCountryID { get; set; }

        #endregion

        #region Relative Properties

        public int OAuthAccountID { get; set; }

        public string AddressCountryName { get; set; }

        public string BillingAddressCountryName { get; set; }

        #endregion
    }
}
