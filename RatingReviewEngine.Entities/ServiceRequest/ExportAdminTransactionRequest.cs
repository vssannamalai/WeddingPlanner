using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities.ServiceRequest
{
  public class ExportAdminTransactionRequest : ServiceRequestBase
    {
        /// <summary>
        /// Export file types (Ex: xml or csv)
        /// </summary>
        public string ExportType { get; set; }

        public int OwnerID { get; set; }

        public int CurrencyID { get; set; }

        public int RowIndex { get; set; }

        public int RowCount { get; set; }

        public int TotalRecords { get; set; }

        public string FromDate { get; set; }

        public string ToDate { get; set; }
    }
}
