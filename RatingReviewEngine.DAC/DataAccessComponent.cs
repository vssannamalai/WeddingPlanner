using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace RatingReviewEngine.DAC
{
    /// <summary>
    /// Base data access component class.
    /// </summary>
    public abstract class DataAccessComponent
    {
        protected const string CONNECTION_NAME = "RatingReviewEngineConnection";
        protected const string ERRORCONNECTION_NAME = "RatingReviewEngineConnection";  


        protected T GetDataValue<T>(IDataReader dr, string columnName) 
        {
            // NOTE: GetOrdinal() is used to automatically determine where the column
            //       is physically located in the database table. This allows the
            //       schema to be changed without affecting this piece of code.
            //       This of course sacrifices a little performance for maintainability.
            T value = default(T);
            try
            {
                int i = dr.GetOrdinal(columnName);

                if (!dr.IsDBNull(i))
                    value = (T)dr.GetValue(i);
                else
                    value = default(T);
            }
            catch (Exception  )
            {
                //TODO:Implement Error Handling Function
            }
            return value;
        }
    }
}
