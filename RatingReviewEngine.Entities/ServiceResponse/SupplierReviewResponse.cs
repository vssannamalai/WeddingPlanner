﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities.ServiceResponse
{
    public class SupplierReviewResponse
    {
        public string SupplierName { get; set; }

        public List<Review> lstReview { get; set; }
    }
}
