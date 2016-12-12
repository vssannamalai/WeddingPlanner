using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    class EntityOAuthAccount
    {
        #region Basic Properties

        public int EntityOAuthAccountID { get; set; }

        /// <summary>
        /// The entity type is the type of user. Entity types are given a name consistent with the table data that contains their data. 
        /// For example, an entity type of "Customer" will connect to the "customer" table to associate the given OAuth 2.0 Membership to the account. 
        /// Entity types will be either "Customer", "Supplier" or "CommunityOwner"
        /// </summary>
        public string EntityType { get; set; }

        public int EntityID { get; set; }

        public int OAuthAccountID { get; set; }

        #endregion

        #region Relative Properties

        #endregion
    }
}
