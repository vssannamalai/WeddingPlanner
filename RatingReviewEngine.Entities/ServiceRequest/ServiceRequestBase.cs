using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities.ServiceRequest
{
    public class ServiceRequestBase
    {
        /// <summary>
        /// API token generated while registering the application. Need to Activate the Token through Community Owner Dashboard.
        /// </summary>
        public string APIToken { get; set; }
    }
}
