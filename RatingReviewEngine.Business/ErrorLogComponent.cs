using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using RatingReviewEngine.DAC;
using RatingReviewEngine.Entities;

namespace RatingReviewEngine.Business
{
    public class ErrorLogComponent
    {
        public void ErrorLog(ErrorLogs errorLog)
        {
            ErrorLogsDAC errorLogDAC = new ErrorLogsDAC();
            errorLogDAC.ErrorLogInsert(errorLog);
        }
    }
}
