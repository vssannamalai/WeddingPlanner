using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    class SupplierCreditAllocations
    {
        #region Basic Properties

        public int SupplierCreditAllocationID { get; set; }

        public int RecVer { get; set; }

        public int SupplierID { get; set; }

        public int CreditAllocationTypeID { get; set; }

        public string Description { get; set; }

        /// <summary>
        /// CommunityID from which the allocation is comming.
        /// NB: "0" is a new credit - has not come from a community;
        /// "0001" is an 'unallocated' community - i.e., a repository of unallocated credit that is pending 
        /// the supplier allocating out to each community they're associated with
        /// </summary>
        public int AllocateFrom { get; set; }

        /// <summary>
        /// CommunityID that the allocation is being allocated to.
        /// NB: "0001" is an 'unallocated' community - i.e., a repository of unallocated credit that is pending 
        /// the supplier allocating out to each community they're associated with. In this instance, it would mean 
        /// that allocated credit is being 'unallocated' from the community and brought back into the general repository.
        /// </summary>
        public int AllocateTo { get; set; }

        public decimal Amount { get; set; }

        /// <summary>
        /// The datetime stamp of when the allocation was processed
        /// </summary>
        public DateTime Date { get; set; }

        #endregion

        #region Relative Properties

        #endregion
    }
}
