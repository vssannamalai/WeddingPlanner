using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RatingReviewEngine.Entities
{
    public class Common
    {
        public DateTime? ParseDate(string strDate, string strFormat)
        {

            DateTime? dFormattedDate = null;
            System.Globalization.CultureInfo MyCultureInfo = new System.Globalization.CultureInfo("en-AU");
            System.Globalization.DateTimeFormatInfo dtfi = new System.Globalization.DateTimeFormatInfo();
            dtfi.ShortDatePattern = strFormat;
            MyCultureInfo.DateTimeFormat = dtfi;

            DateTime tmpDate;
            if (DateTime.TryParseExact(strDate, strFormat, MyCultureInfo, System.Globalization.DateTimeStyles.None, out tmpDate))
            { dFormattedDate = tmpDate; }
            return dFormattedDate;
        }
    }
}
