using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class SocialMedia
    {
        #region Basic Properties

        public int SocialMediaID { get; set; }

        /// <summary>
        /// The name of the relevant social media outlet. E.g., "Facebook", "Twitter", "Pinterest", "FourSquare", "Instagram", "Google+", "LinkedIn", etc.
        /// </summary>
        public string Name { get; set; }

        #endregion

        #region Relative Properties

        #endregion
    }
}
