using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
   public class ActionInsertRequest
    {
        public int CommunityId { get; set; }
        public int CommunityGroupId { get; set; }
        public int ActionId { get; set; }
        public int CommunityOwnerId { get; set; }
        public int SupplierId { get; set; }
        public int CustomerId { get; set; }
        public string ActionDetails { get; set; }
        public decimal ActionAmount { get; set; }
    }
}
