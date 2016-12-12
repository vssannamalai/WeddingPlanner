using System.Collections.Generic;

namespace RatingReviewEngine.Entities
{
    public class SupplierActivity
    {
        public int RowIndex { get; set; }

        public List<SupplierAction> lstSupplierAction { get; set; }
    }
}
