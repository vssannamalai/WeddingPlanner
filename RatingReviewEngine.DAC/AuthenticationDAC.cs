using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Practices.EnterpriseLibrary.Data;
using RatingReviewEngine.Entities;
using RatingReviewEngine.Entities.ServiceRequest;
using RatingReviewEngine.Entities.ServiceResponse;
using System.Data;
using System.Data.Common;

namespace RatingReviewEngine.DAC
{
    public class AuthenticationDAC : DataAccessComponent
    {
        Database objDb = DatabaseFactory.CreateDatabase(CONNECTION_NAME);

        /// <summary>
        /// Check the given input Token 
        /// </summary>
        /// <param name="APIToken"></param>
        /// <returns></returns>
        public bool ValidateAPIToken(string APIToken)
        {
            DbCommand cmd;
            LoginResponse loginResponse = new LoginResponse();

            using (cmd = (DbCommand)objDb.GetStoredProcCommand("VALIDATEAPITOKEN"))
            {
                objDb.AddInParameter(cmd, "IN_APIToken", DbType.String, APIToken);
                string validAPIToken = objDb.ExecuteScalar(cmd).ToString();
                if (validAPIToken == "valid")
                {
                    return true;
                }
                else
                {
                    return false;
                }
            } 
        }
    }



}
