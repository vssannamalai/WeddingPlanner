using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities.ServiceRequest
{
    public class SupplierTransactionHistoryRequest
    {

        public string ReportName { get; set; }

        public string PDFFileName { get; set; }

        public List<SupplierCommunityTransactionHistory> lstSupplierTransactionHistory { get; set; }

    }
}
