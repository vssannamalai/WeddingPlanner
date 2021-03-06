﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    class SupplierTransactions
    {
        #region Basic Properties

        public int SupplierActionID { get; set; }

        public int CustomerID { get; set; }

        public int SupplierID { get; set; }

        public int CommunityID { get; set; }

        public int CommunityGroupID { get; set; }

        public decimal TransactionAmount { get; set; }

        /// <summary>
        /// If the transaction is a quote, then the value will be "true". If the transaction is not a quote (i.e., a purchase), then the value will be "false".
        /// </summary>
        public bool IsQuote { get; set; }

        /// <summary>
        /// The receipt id of the transaction as generated by the payment gateway upon finalisation of a successful transaction.
        /// </summary>
        public string ReceiptID { get; set; }

        /// <summary>
        /// The datetime stamp of when the transaction was successfully finalised by the payment gateway.
        /// </summary>
        public DateTime? TransactionDate { get; set; }

        /// <summary>
        /// The currency that this transaction has been transacted in.
        /// </summary>
        public int CurrencyID { get; set; }

        #endregion

        #region Relative Properties

        #endregion
    }
}
