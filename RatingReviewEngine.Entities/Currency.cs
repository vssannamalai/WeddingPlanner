using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class Currency
    {
        public int CurrencyID { get; set; }

        public string ISOCode { get; set; }

        public string Description { get; set; }

        public decimal? MinTransferAmount { get; set; }

        public bool IsActive { get; set; }
    }
}
