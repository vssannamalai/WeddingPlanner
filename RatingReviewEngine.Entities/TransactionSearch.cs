namespace RatingReviewEngine.Entities
{
    public class TransactionSearch
    {
        public string SearchText { get; set; }

        public int OwnerId { get; set; }

        public int CommunityId { get; set; }

        public int CommunityGroupId { get; set; }

        public int CategoryId { get; set; }

        public int RowIndex { get; set; }

        public int RowCount { get; set; }       

    }
}
