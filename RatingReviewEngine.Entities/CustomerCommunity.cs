namespace RatingReviewEngine.Entities
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    class CustomerCommunity
    {
        #region Basic Properties

        public int CustomerCommunityID { get; set; }

        public int CommunityID { get; set; }

        public int CustomerID { get; set; }

        /// <summary>
        /// The datetime when the customer joined the community
        /// </summary>
        public DateTime DateJoined { get; set; }

        /// <summary>
        /// If the customer wishes to receive emails triggered from the community then the value is "true".
        /// If the customer does not wish to receive emails triggered from the community the value is "false".
        /// </summary>
        public bool EmailOptIn { get; set; }

        /// <summary>
        /// If the customers' membership to the community is active, then the value is "true".
        /// If the customers' membership to the community is not active, then the value is "false".
        /// </summary>
        public bool IsActive { get; set; }

        #endregion

        #region Relative Properties

        #endregion
    }
}
