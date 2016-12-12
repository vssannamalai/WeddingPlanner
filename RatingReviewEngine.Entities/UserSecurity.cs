using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    class UserSecurity
    {
        #region Basic Properties

        public int OAuthAccountID { get; set; }

        /// <summary>
        /// 0 = no - the account does not have Administrator security
        /// 1 = yes - the account does have Administrator security
        /// </summary>
        public char Administrator { get; set; }

        /// <summary>
        /// 0 = no - the account does not have Community Owner security
        /// 1 = yes - the account does have Community Owner security
        /// </summary>
        public char CommunityOwner { get; set; }

        /// <summary>
        /// 0 = no - the account does not have Supplier security
        /// 1 = yes - the account does have Supplier security
        /// </summary>
        public char Supplier { get; set; }

        /// <summary>
        /// 0 = no - the account does not have Customer security
        /// 1 = yes - the account does have Customer security
        /// </summary>
        public char Customer { get; set; }

        #endregion

        #region Relative Properties

        #endregion
    }
}
