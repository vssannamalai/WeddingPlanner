using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities.ServiceRequest
{
   public class CustomerSearchRequest
    {
       public string Handle { get; set; }

       public string FirstName { get; set; }

       public string LastName { get; set; }

       public string Email { get; set; }

       public int CommunityGroupID { get; set; }

       public int ActionID { get; set; }

       public int SupplierID { get; set; }

       public int CustomerID { get; set; }

    }
}
