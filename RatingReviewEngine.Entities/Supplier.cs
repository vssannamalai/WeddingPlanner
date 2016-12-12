using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class Supplier
    {
        #region Basic Properties

        public int SupplierID { get; set; }

        public string CompanyName { get; set; }

        public string Email { get; set; }

        /// <summary>
        /// Supplier's website
        /// </summary>
        public string Website { get; set; }

        public string PrimaryPhone { get; set; }

        public string OtherPhone { get; set; }

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

        public string BusinessNumber { get; set; }

        /// <summary>
        /// Longitude of the supplier's location for pinpointing on a map
        /// </summary>
        public decimal? Longitude { get; set; }

        /// <summary>
        /// Latitude of the supplier's location for pinpointing on a map
        /// </summary>
        public decimal? Latitude { get; set; }

        /// <summary>
        /// The datetime stamp indicating when the supplier was added to the system
        /// </summary>
        public DateTime DateAdded { get; set; }

        /// <summary>
        /// The datetime stamp indicating when the supplier finalised their profile
        /// </summary>
        public DateTime? ProfileCompletedDate { get; set; }

        /// <summary>
        /// The supplier's quote terms - the quote terms are to appear anywhere that a supplier's quote is displayed or issued.
        /// Field cannot be null and is pre-populated with a standard quote statement of "This quote is valid for 30 days from the date of issue."
        /// </summary>
        public string QuoteTerms { get; set; }

        /// <summary>
        /// The deposit percentage that the Supplier specifies in order to confirm a customer's intention to purchase.
        /// If the deposit percentage is "0", then the Supplier does not require a deposit to be paid.
        /// The default deposit percentage is set at 10% but can be altered by the Supplier.
        /// </summary>
        public decimal DepositPercent { get; set; }

        /// <summary>
        /// The supplier's deposit terms - the deposit terms are to appear anywhere that a supplier's quote or deposit details are displayed or issued.
        /// Field cannot be null and is pre-populated with a standard deposit statement of "Payment of the requested deposit amount confirms the 
        /// Customer's intention to pay in full for the product/service as defined within the quote."
        /// </summary>
        public string DepositTerms { get; set; }

        #endregion

        #region Relative Properties

        public int OAuthAccountID { get; set; }

        public string AddressCountryName { get; set; }

        public string BillingAddressCountryName { get; set; }

        #endregion
    }
}
