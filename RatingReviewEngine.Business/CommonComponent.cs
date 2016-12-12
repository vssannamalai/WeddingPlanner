using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Security.Cryptography;

using RatingReviewEngine.DAC;
using RatingReviewEngine.Entities;

namespace RatingReviewEngine.Business
{
    public class CommonComponent
    {
        public static DateTime MYSQLDateTime()
        {
            return CommonDAC.MYSQLDateTime();
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
