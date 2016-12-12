using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class ContactUs
    {
        #region Basic Properties
        public string SourceSystem { get; set; }

        public string Title { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string Email { get; set; }

        public string Phone { get; set; }

        public string PreferredContact { get; set; }

        public string Subject { get; set; }

        public string Comment { get; set; }
        #endregion
    }
}
