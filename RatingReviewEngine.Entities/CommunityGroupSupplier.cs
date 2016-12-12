using System;

namespace RatingReviewEngine.Entities
{
    public class CommunityGroupSupplier
    {
        #region Basic Properties

        public int CommunityGroupSupplierID { get; set; }

        public int SupplierID { get; set; }

        public int CommunityID { get; set; }

        public int CommunityGroupID { get; set; }

        public DateTime DateJoined { get; set; }

        public bool IsActive { get; set; }

        #endregion
        
        #region Relative Properties

        #endregion
    }
}
