using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace RatingReviewEngine.Entities.ServiceResponse
{
    public class RegisterAccountResponse : ServiceResponseBase
    {
        public int OAuthAccountId { get; set; }
    }
}
