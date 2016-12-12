using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities.ServiceResponse
{
  public  class SupplierBillingResponse
    {
      public int SupplierID { get; set; }

      public string SupplierName { get; set; }

      public string Email { get; set; }

      public List<SupplierCommunityTransactionHistory> listSupplierTransactionHistory { get; set; }
    }
}
