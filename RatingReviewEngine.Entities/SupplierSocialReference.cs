using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class SupplierSocialReference
    {
        #region Basic Properties

        public int SupplierSocialReferenceID { get; set; }

        public int SupplierID { get; set; }

        /// <summary>
        /// Reference to the unique identifier of the relevant social media type from the SocialMedia table
        /// </summary>
        public int SocialMediaID { get; set; }

        /// <summary>
        /// Supplier's social media reference id. I.e., if the supplier's Social Media is 'Facebook', then the 
        /// value of this field will be the unique Facebook reference for this supplier's Facebook account
        /// </summary>
        public string SocialMediaReference { get; set; }

        #endregion

        #region Relative Properties

        public string SocialMediaName { get; set; }

        #endregion
    }
}
