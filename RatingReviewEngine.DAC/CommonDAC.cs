using System;
using System.Data;
using System.Data.Common;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

using Microsoft.Practices.EnterpriseLibrary.Data;
using RatingReviewEngine.Entities;


namespace RatingReviewEngine.DAC
{
    public class CommonDAC : DataAccessComponent
    {
        public static DateTime MYSQLDateTime()
        {
            Database objDb = DatabaseFactory.CreateDatabase(CONNECTION_NAME);
            DbCommand cmd;
            using (cmd = (DbCommand)objDb.GetStoredProcCommand("getdatetime"))
            {
                return Convert.ToDateTime(objDb.ExecuteScalar(cmd));
            }
        }

        public static String EncryptIt(string strEncrypt)
        {
            String result;
            var key = Encoding.UTF8.GetBytes("9061737323313233");
            var IV = Encoding.UTF8.GetBytes("9061737323313233");

            RijndaelManaged rijn = new RijndaelManaged();
            rijn.Mode = CipherMode.CBC;
            rijn.Padding = PaddingMode.PKCS7;

            using (MemoryStream msEncrypt = new MemoryStream())
            {
                using (ICryptoTransform encryptor = rijn.CreateEncryptor(key, IV))
                {
                    using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                    {
                        using (StreamWriter swEncrypt = new StreamWriter(csEncrypt))
                        {
                            swEncrypt.Write(strEncrypt);
                        }
                    }
                }

                result = Convert.ToBase64String(msEncrypt.ToArray());
            }

            rijn.Clear();
            return result;
        }

        public static String DecryptIt(string strDecrypt)
        {
            String result;
            var key = Encoding.UTF8.GetBytes("9061737323313233");
            var IV = Encoding.UTF8.GetBytes("9061737323313233");
            RijndaelManaged rijn = new RijndaelManaged();
            rijn.Mode = CipherMode.CBC;
            rijn.Padding = PaddingMode.PKCS7;

            using (MemoryStream msDecrypt = new MemoryStream(Convert.FromBase64String(strDecrypt)))
            {
                using (ICryptoTransform decryptor = rijn.CreateDecryptor(key, IV))
                {
                    using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                    {
                        using (StreamReader swDecrypt = new StreamReader(csDecrypt))
                        {
                            result = swDecrypt.ReadToEnd();
                        }
                    }
                }
            }

            rijn.Clear();
            return result;
        }
    
    }
}
