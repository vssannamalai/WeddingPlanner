using System;

namespace RatingReviewEngine.Entities
{
    public class ApplicationAuthentication
    {

        #region Basic Properties
        public int ApplicationID { get; set; }

        public string ApplicationName { get; set; }

        public DateTime? TokenGenerated { get; set; }

        public string APIToken { get; set; }

        public DateTime? LastConnection { get; set; }

        public bool IsActive { get; set; }

        public string RegisteredEmail { get; set; }

        public int CommunityID { get; set; }

        #endregion


        #region Relative Properties
        public string CommunityName { get; set; }

        public int OwnerID { get; set; }

        public string OwnerName { get; set; }

        public bool CommunityActive { get; set; }        

        #endregion

    }
}
