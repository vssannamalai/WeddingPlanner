using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;

namespace RatingReviewEngine.Entities
{

    public class ReviewResponse
    {
        #region Basic Properties

        public int ReviewResponseID { get; set; }

        public int ReviewID { get; set; }

        public string Response { get; set; }

        public DateTime ResponseDate { get; set; }

        /// <summary>
        /// If the response is able to be viewed publicly, then the value will be "false".
        /// If the response is required to be hidden, then the value will be "false".
        /// If a response has been marked as hidden, then any reward or billing fee associated to that response is to be reversed.
        /// </summary>
        /// 
        public bool HideResponse { get; set; }

        public int SupplierActionID { get; set; }

        #endregion

        #region Relative Properties

        public int CustomerID { get; set; }

        public string CommunityName { get; set; }

        public string CommunityGroupName { get; set; }

        public string ResponseDateString { get { return ResponseDate.ToString("dd/MM/yyyy hh:mm:tt").Replace("-", "/"); } set { /* NOOP */ } }

        // public string ResponseDateString { get; set; }

        public int ReviewSupplierActionID { get; set; }
        #endregion
    }
}
