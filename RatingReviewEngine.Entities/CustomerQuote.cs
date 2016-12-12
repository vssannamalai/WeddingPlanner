using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class CustomerQuote
    {
        #region Basic Properties

        public int CustomerQuoteID { get; set; }

        public int CustomerID { get; set; }

        public int CommunityID { get; set; }

        public int CommunityGroupID { get; set; }

        public int SupplierID { get; set; }

        public decimal QuoteAmount { get; set; }

        /// <summary>
        /// If a deposit was specified as part of the quote, then the value will be "true". 
        /// If no deposit was specified as part of the quote, then the value will be "false".
        /// </summary>
        public bool DepositSpecified { get; set; }

        /// <summary>
        /// The amount of the deposit that was specified as part of the quote. If no deposit was specified, then this value will be "0".
        /// </summary>
        public decimal DepositAmount { get; set; }

        /// <summary>
        /// The supplier's quote terms at the time of generating the quote.
        /// </summary>
        public string QuoteTerms { get; set; }

        /// <summary>
        /// The supplier's deposit terms at the time of generating the quote.
        /// </summary>
        public string DepositTerms { get; set; }

        /// <summary>
        /// Reference to the unique id of the currency that this quote was specified in
        /// </summary>
        public int CurrencyID { get; set; }

        /// <summary>
        /// The detail associated with the quote.
        /// </summary>
        public string QuoteDetail { get; set; }

        /// <summary>
        /// Reference to the relevant SupplierActionID for the "Quote" action that this Quote relates to.
        /// </summary>
        public int SupplierActionID { get; set; }

        #endregion

        #region Relative Properties

        public int ActionID { get; set; }

        public int ParentSupplierActionID { get; set; }
        #endregion




        #region Additional properties required for sending email
        public string CustomerEmail { get; set; }
        public string CustomerFirstName { get; set; }
        public string CustomerLastName { get; set; }
        public string SupplierEmail { get; set; }
        public string SupplierName { get; set; }
        public string CommunityName { get; set; }
        public string CommunityGroupName { get; set; }
        public string CurrencyCode { get; set; }
        #endregion
    }
}
