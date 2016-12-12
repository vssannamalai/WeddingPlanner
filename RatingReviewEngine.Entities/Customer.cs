using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class Customer
    {
        #region Basic Properties

        public int CustomerID { get; set; }

        public string Email { get; set; }

        public string MobilePhone { get; set; }

        /// <summary>
        /// Displayed only to a specifically recommended or selected supplier within communications
        /// </summary>
        public string FirstName { get; set; }

        /// <summary>
        /// Displayed only to a specifically recommended or selected supplier within communications
        /// </summary>
        public string LastName { get; set; }

        /// <summary>
        /// Public handle viewable by a Customer or Supplier. E.g., '<Handle> is a 3-Star Reviewer'
        /// </summary>
        public string Handle { get; set; }

        /// <summary>
        /// "M" for male, "F" for female
        /// </summary>
        public char Gender { get; set; }

        /// <summary>
        /// The datetime stamp of when the customer signed up to the system
        /// </summary>
        public DateTime DateJoined { get; set; }

        #endregion

        #region Relative Properties
        
        public string CommunityGroup { get; set; }
                
        public string ActionName { get; set; }
        #endregion
    }
}
