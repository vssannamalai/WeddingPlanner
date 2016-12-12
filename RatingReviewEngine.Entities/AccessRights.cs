using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
   public class AccessRights
    {
       public int AccessRightID { get; set; }

       public int PageID { get; set; }

       public int UserRoleID { get; set; }

       public string PageName { get; set; }

       public bool IsAdminAllowed { get; set; }

       public bool IsOwnerAllowed { get; set; }

       public bool IsSupplierAllowed { get; set; }

    }
}
