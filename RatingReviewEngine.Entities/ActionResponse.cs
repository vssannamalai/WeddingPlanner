namespace RatingReviewEngine.Entities
{
    public class ActionResponse
    {
        #region Basic Properties

        public int ActionResponseID { get; set; }

        public int ActionID { get; set; }

        public int ResponseID { get; set; }

        #endregion


        #region Relative Properties
        public string ActionName { get; set; }

        public string ResponseActionName { get; set; }

        #endregion
    }
}
