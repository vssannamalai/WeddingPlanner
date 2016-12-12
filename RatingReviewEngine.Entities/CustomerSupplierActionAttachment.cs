using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class CustomerSupplierActionAttachment
    {
        #region Basic Properties

        public int CustomerSupplierActionAttachmentID { get; set; }

        /// <summary>
        /// Any image or pdf file that is to be attached to an individual action. E.g., if the Action was a 'Quote Request', 
        /// then the customer may have attached an example image of the cake they want designed.
        /// </summary>
        public Byte[] Attachment { get; set; }

        public string FileName { get; set; }

        #endregion

        #region Relative Properties

        #endregion
    }
}
