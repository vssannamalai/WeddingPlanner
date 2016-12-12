using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class CustomerSupplierCommunication
    {
        public int CustomerId { get; set; }

        public int SupplierId { get; set; }

        public int CommunityId { get; set; }

        public int CommunityGroupId { get; set; }

        public int ActionId { get; set; }

        public string ActionName { get; set; }

        public string Message { get; set; }

        public int? ParentSupplierActionId { get; set; }

        public string CommunityName { get; set; }

        public string CommunityGroupName { get; set; }

        public int SupplierActionId { get; set; }

        #region Additional properties required for sending email 
            public string CustomerEmail { get; set; }
            public string CustomerFirstName { get; set; }
            public string CustomerLastName { get; set; }
            public string SupplierEmail { get; set; }
            public string SupplierName { get; set; }
            public int ReviewID { get; set; }
        #endregion

    }
}
