using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities.ServiceRequest
{

    public class AccountActivationRequest : ServiceRequestBase
    {
        public string ProviderUserID { get; set; }
    }
}
