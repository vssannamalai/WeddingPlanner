using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class SupplierAction
    {
        #region Basic Properties

        public int SupplierActionID { get; set; }

        public int CustomerID { get; set; }

        public int SupplierID { get; set; }

        public int? CommunityID { get; set; }

        public int CommunityGroupID { get; set; }

        public int ActionID { get; set; }

        /// <summary>
        /// Datetime the action occurred
        /// </summary>
        public DateTime ActionDate { get; set; }

        /// <summary>
        /// Content of the action. I.e., if the action is a 'message received', then the value of this field will be the content of the message. 
        /// If the action is a 'quote', then the value of this field will be the content of the quote. If the action is a 'question', then the 
        /// value of this field will be the content of the message. This field can be null as not all action types have associated detail.
        /// </summary>
        public string Detail { get; set; }

        /// <summary>
        /// If the action is of a type that requires some sort of response action (derived from Actions.ResponseActionResponse), then this field 
        /// is used to indicate if that response has been actioned. I.e., if the Action is of type "Quote Request", and the required response action 
        /// is "Quote", then upon first creation of this "Quote Request", the "ResponseActionPerformed" field is to be set to "true" to indicate that 
        /// a response action is required. Once the Quote is generated (as associated to this action), the "ResponseActionPerformed" value is to be 
        /// set to "false" to indicate that the action has been performed.
        /// </summary>
        public bool? ResponseActionPerformed { get; set; }

        public bool IsAttachment { get; set; }

        public string FileName { get; set; }

        #endregion

        #region Relative Properties

        public string CustomerName { get; set; }

        public string CustomerEmail { get; set; }

        public string ActionName { get; set; }

        public string CommunityGroupName { get; set; }

        public string CurrentAction { get; set; }

        public List<AvailableAction> lstAvailableAction { get; set; }

        public int ParentSupplierActionId { get; set; }

        public int CurrencyId { get; set; }

        public string CurrencyName { get; set; }

        public int CustomerQuoteID { get; set; }

        public string SupplierNote { get; set; }
        
        public int QuoteID { get; set; }

        public string ActionDateString { get { return ActionDate.ToString("dd/MM/yyyy hh:mm:tt").Replace("-", "/"); } set { /* NOOP */ } }

        public string Message { get; set; }

        #endregion
    }

    public class AvailableAction
    {
        public int ActionID { get; set; }

        public int ResponseID { get; set; }

        public int SupplierActionID { get; set; }

        public string ResponseName { get; set; }

      
    }
}
