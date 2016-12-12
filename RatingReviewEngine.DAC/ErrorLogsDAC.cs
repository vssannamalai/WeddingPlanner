using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.Common;

using Microsoft.Practices.EnterpriseLibrary.Data;
using RatingReviewEngine.Entities;

namespace RatingReviewEngine.DAC
{
    public class ErrorLogsDAC : DataAccessComponent
    {
        Database objDb = DatabaseFactory.CreateDatabase(CONNECTION_NAME);

        public void ErrorLogInsert(ErrorLogs errorLog)
        {
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("ERRORLOGINSERT"))
            {
                objDb.AddInParameter(cmd, "IN_Description", DbType.String, errorLog.Description);
                objDb.AddInParameter(cmd, "IN_Details", DbType.String, errorLog.Details);
                objDb.AddInParameter(cmd, "IN_Timestamp", DbType.DateTime, errorLog.Timestamp);
                objDb.ExecuteNonQuery(cmd);
            }
        }
    }
}
