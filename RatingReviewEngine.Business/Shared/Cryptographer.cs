using System;
using System.Security.Cryptography;
using System.Text;

namespace RatingReviewEngine.Business.Shared
{
    public class Cryptographer
    {
        #region Public Static Methods
        /// <summary>
        /// Encrypt secure data with the enryption key for Review Rating Engine
        /// </summary>
        /// <param name="strToEncrypt"></param>
        /// <returns></returns>
        public static string Encrypt(string strToEncrypt)
        {
            try
            {
                String strEncryptedText = Encrypt(strToEncrypt, "MHJ_RatingEngine");
                return strEncryptedText;
            }
            catch
            {
                return String.Empty;
            }
        }

        /// <summary>
        /// Decrypt encryted information which is encrypted using enryption key for Review Rating Engine
        /// </summary>
        /// <param name="strEncrypted"></param>
        /// <returns></returns>
        public static string Decrypt(string strEncrypted)
        {
            try
            {
                // The character '+' was converted to ' ' while passing it in query string. So the empty space was replace with '+'
                strEncrypted = strEncrypted.Replace(" ", "+");
                String strText = Decrypt(strEncrypted, "MHJ_RatingEngine");
                return strText;
            }
            catch
            {
                return String.Empty;
            }
        }

        public static string GenerateAuthToken()
        {
            return RNGCharacterMask();
        }

        private static string RNGCharacterMask()
        {
            try
            {
                int maxSize = 32;
                int minSize = 24;
                char[] chars = new char[62];
                string a;
                a = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
                chars = a.ToCharArray();
                int size = maxSize;
                byte[] data = new byte[1];
                RNGCryptoServiceProvider crypto = new RNGCryptoServiceProvider();
                crypto.GetNonZeroBytes(data);
                size = maxSize;
                data = new byte[size];
                crypto.GetNonZeroBytes(data);
                StringBuilder result = new StringBuilder(size);
                foreach (byte b in data)
                { 
                    result.Append(chars[b % (chars.Length - 1)]); 
                }

                return result.ToString();
            }
            catch
            {
                return String.Empty;
            }
        }

        #endregion
        
        #region Private Member Function
        /// <summary>
        /// Encrypt secure data with encryption key using Cryptography
        /// </summary>
        /// <param name="strToEncrypt">Text data to encrypt </param>
        /// <param name="strEncryptKey">Encryption key which is required for decryption.</param>
        /// <returns>Return Encrypted data. On Error : Return empty string</returns>
        private static string Encrypt(string strToEncrypt, string strEncryptKey)
        {
            try
            {
                TripleDESCryptoServiceProvider objDESCrypto = new TripleDESCryptoServiceProvider();
                MD5CryptoServiceProvider objHashMD5 = new MD5CryptoServiceProvider();

                byte[] byteHash, byteBuff;
                string strTempKey = strEncryptKey;

                byteHash = objHashMD5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(strTempKey));
                objHashMD5 = null;
                objDESCrypto.Key = byteHash;
                objDESCrypto.Mode = CipherMode.ECB; //CBC, CFB

                byteBuff = ASCIIEncoding.ASCII.GetBytes(strToEncrypt);
                return Convert.ToBase64String(objDESCrypto.CreateEncryptor().TransformFinalBlock(byteBuff, 0, byteBuff.Length));
            }
            catch
            {
                return String.Empty;
            }
        }

        /// <summary>
        /// Decrypt the encrypted information
        /// </summary>
        /// <param name="strEncrypted">Encrypted data</param>
        /// <param name="strEncryptKey">Encryption Key which is used while encrypting</param>
        /// <returns>Return decrypted data. On Error : Return empty string</returns>
        private static string Decrypt(string strEncrypted, string strEncryptKey)
        {
            try
            {
                TripleDESCryptoServiceProvider objDESCrypto = new TripleDESCryptoServiceProvider();
                MD5CryptoServiceProvider objHashMD5 = new MD5CryptoServiceProvider();

                byte[] byteHash, byteBuff;
                string strTempKey = strEncryptKey;

                byteHash = objHashMD5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(strTempKey));
                objHashMD5 = null;
                objDESCrypto.Key = byteHash;
                objDESCrypto.Mode = CipherMode.ECB; //CBC, CFB

                byteBuff = Convert.FromBase64String(strEncrypted);
                string strDecrypted = ASCIIEncoding.ASCII.GetString(objDESCrypto.CreateDecryptor().TransformFinalBlock(byteBuff, 0, byteBuff.Length));
                objDESCrypto = null;

                return strDecrypted;
            }
            catch
            {
                return String.Empty;
            }
        }
        #endregion
    }
}
