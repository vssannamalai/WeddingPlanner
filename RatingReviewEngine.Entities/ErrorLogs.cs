using System;

namespace RatingReviewEngine.Entities
{
    public class ErrorLogs
    {
        public int ErrorLogID { get; set; }

        public string Description { get; set; }

        public string Details { get; set; }

        public DateTime Timestamp { get; set; }
    }
}
