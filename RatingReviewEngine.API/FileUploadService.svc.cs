using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.Web;
using RatingReviewEngine.Business;
using RatingReviewEngine.Business.Shared;
using RatingReviewEngine.Entities;
using System.ServiceModel.Web;
using System.Text;
using System.Drawing;

namespace RatingReviewEngine.API
{
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
    public class FileUploadService : IFileUploadService
    {
        #region Exception
        private void LogException(Exception ex)
        {
            ////Entity
            ErrorLogs errorLog = new ErrorLogs();
            errorLog.Description = ex.Message;
            errorLog.Details = ex.StackTrace;
            errorLog.Timestamp = CommonComponent.MYSQLDateTime();

            ////Component
            ErrorLogComponent errorLogComponent = new ErrorLogComponent();
            errorLogComponent.ErrorLog(errorLog);

            EmailDispatcher emailDispatcher = new EmailDispatcher();

            emailDispatcher.SendErrorEmail("MHJ-Error", "MHJ API-Error on-" + errorLog.Timestamp, "Message:" + ex.Message + "<br/> Description:" + ex.StackTrace, true);

        }
        #endregion
        public string UploadImage(Stream FileByteStream)
        {
            SaveFileHttpMultiPartParser(FileByteStream);
            return "Success";
        }

        private bool fooCallback()
        {
            return false;
        }

        private byte[] ResizeImage(Stream stream, int width, int height)
        {

            Image objImage = Image.FromStream(stream);
            objImage.RotateFlip(System.Drawing.RotateFlipType.Rotate270FlipY);
            int x = 0;
            int y = 0;
            int newX = 0;
            int newY = 0;

            x = objImage.Width;
            y = objImage.Height;

            if (x > height || y > width)
            {
                if (x * 1.0 / y >= height * 1.0 / width)
                {
                    newX = height;
                    newY = Convert.ToInt32(y * (height * 1.0 / x));
                }
                else
                {
                    newY = width;
                    newX = Convert.ToInt32(x * (width * 1.0 / y));
                }
            }
            else
            {
                newX = x;
                newY = y;
            }

            System.Drawing.Image.GetThumbnailImageAbort objCallback = new System.Drawing.Image.GetThumbnailImageAbort(fooCallback);
            System.Drawing.Image objNewImage = objImage.GetThumbnailImage(newX, newY, objCallback, IntPtr.Zero);
            objNewImage.RotateFlip(System.Drawing.RotateFlipType.Rotate270FlipY);

            var ms = new MemoryStream();
            objNewImage.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg);

            // objNewImage.Save(resizeImagePath, ImageFormat.Jpeg);

            objImage.Dispose();
            objNewImage.Dispose();

            return ms.ToArray();
        }
        public string SaveSupplierLogo(Stream FileByteStream)
        {
            HttpMultipartParser.MultipartFormDataParser parser = new HttpMultipartParser.MultipartFormDataParser(FileByteStream, Encoding.UTF8);
            try
            {

                byte[] buffer = ResizeImage(parser.Files[0].Data, 1024, 1024);
                string supplierid = parser.Parameters["supplierid"].Data;
                // int bufferLen = Convert.ToInt32(parser.Files[0].Data.Length);
                //  byte[] buffer = new byte[bufferLen];
                SupplierLogo supplierLogo = new SupplierLogo();
                // parser.Files[0].Data.Read(buffer, 0, bufferLen);
                //parser.Files[0].FileName
                supplierLogo.Logo = buffer;
                supplierLogo.SupplierID = Convert.ToInt32(supplierid);

                SupplierComponent supplierCommponent = new SupplierComponent();
                supplierCommponent.SupplierLogoInsert(supplierLogo);
            }
            catch (Exception ex)
            {
            //    RatingReviewEngineException ratingException = new RatingReviewEngineException("The file you have uploaded is invalid. This file appears to be damaged or corrupted.");
            //    throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
                return "Error";
            }
            return "Success";
        }

        public string SaveSupplierIcon(Stream FileByteStream)
        {
            HttpMultipartParser.MultipartFormDataParser parser = new HttpMultipartParser.MultipartFormDataParser(FileByteStream, Encoding.UTF8);
            try
            {
                string supplierid = parser.Parameters["supplierid"].Data;
                //int bufferLen = Convert.ToInt32(parser.Files[0].Data.Length);
                // byte[] buffer = new byte[bufferLen];
                byte[] buffer = ResizeImage(parser.Files[0].Data, 152, 152);
                SupplierIcon supplierIcon = new SupplierIcon();
                //   parser.Files[0].Data.Read(buffer, 0, bufferLen);
                supplierIcon.Icon = buffer;
                supplierIcon.SupplierID = Convert.ToInt32(supplierid);

                SupplierComponent supplierCommponent = new SupplierComponent();
                supplierCommponent.SupplierIconInsert(supplierIcon);
            }
            catch (Exception ex)
            {
                //RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                //throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
                return "Error";
            }
            return "Success";
        }

        public string SaveSupplierActionAttachment(Stream FileByteStream)
        {
            HttpMultipartParser.MultipartFormDataParser parser = new HttpMultipartParser.MultipartFormDataParser(FileByteStream, Encoding.UTF8);
            try
            {
                string supplieractionid = parser.Parameters["supplieractionid"].Data;
                int bufferLen = Convert.ToInt32(parser.Files[0].Data.Length);
                byte[] buffer = new byte[bufferLen];
                // byte[] buffer = ResizeImage(parser.Files[0].Data, 152, 152);
                CustomerSupplierActionAttachment customerSupplierActionAttachment = new CustomerSupplierActionAttachment();
                parser.Files[0].Data.Read(buffer, 0, bufferLen);
                customerSupplierActionAttachment.Attachment = buffer;
                customerSupplierActionAttachment.CustomerSupplierActionAttachmentID = Convert.ToInt32(supplieractionid);
                customerSupplierActionAttachment.FileName = parser.Files[0].FileName;
                CustomerComponent customerComponent = new CustomerComponent();
                customerComponent.CustomerSupplierActionAttachmentInsert(customerSupplierActionAttachment);

            }
            catch (Exception ex)
            {
                //LogException(ex);
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.InternalServerError);
            }
            return "Success";
        }
        private string SaveFileHttpMultiPartParser(Stream FileByteStream)
        {

            HttpMultipartParser.MultipartFormDataParser parser = new HttpMultipartParser.MultipartFormDataParser(FileByteStream, Encoding.UTF8);

            try
            {
                //string supplierid = HttpUtility.UrlDecode(parser.Parameters["supplierid"]);
                //string suppliername = HttpUtility.UrlDecode(parser.Parameters["supplierid"]);

                string supplierid = parser.Parameters["supplierid"].Data;
                string suppliername = parser.Parameters["suppliername"].Data;

                // Save the file somewhere
                //File.WriteAllBytes(folderPath + parser.Files[0].FileName, parser.Files[0].Data.to);
                SaveStream(parser.Files[0].Data, parser.Files[0].FileName);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return "Test";
        }

        private string SaveStream(Stream FileByteStream, string strFileName = "stream.txt")
        {

            string folderPath = "C:\\Logs\\";
            // string strFileName = "stream.txt";
            string filePath = Path.Combine(folderPath, strFileName);
            try
            {
                FileStream outstream = File.Open(filePath, FileMode.Create, FileAccess.Write);
                //read from the input stream in 4K chunks
                //and save to output stream
                const int bufferLen = 4096;
                byte[] buffer = new byte[bufferLen];
                int count = 0;
                while ((count = FileByteStream.Read(buffer, 0, bufferLen)) > 0)
                {
                    outstream.Write(buffer, 0, count);
                }
                outstream.Close();
                FileByteStream.Close();
            }
            catch (IOException ex)
            {

            }


            return "Success";
        }


        public Stream DownloadFile(string fileName)
        {
            string downloadFilePath = Path.Combine(HttpContext.Current.Server.MapPath("~/Assets/ExportedFiles/"), fileName);
            try
            {
                var fileInfo = new FileInfo(downloadFilePath);
                String headerInfo = "attachment; filename=" + "TransactionDetails" + fileInfo.Extension;
                if (WebOperationContext.Current != null)
                {
                    WebOperationContext.Current.OutgoingResponse.Headers["Content-Disposition"] = headerInfo;
                    WebOperationContext.Current.OutgoingResponse.ContentType = "application/octet-stream";
                }
                return File.OpenRead(downloadFilePath);
            }
            catch (Exception ex)
            {
                var ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.BadRequest);
            }
        }

        public Stream DownloadFileWithName(string fileName)
        {
            string downloadFilePath = Path.Combine(HttpContext.Current.Server.MapPath("~/Assets/ExportedFiles/"), fileName);
            try
            {
                var fileInfo = new FileInfo(downloadFilePath);
                String headerInfo = "attachment; filename=" + fileName;
                if (WebOperationContext.Current != null)
                {
                    WebOperationContext.Current.OutgoingResponse.Headers["Content-Disposition"] = headerInfo;
                    WebOperationContext.Current.OutgoingResponse.ContentType = "application/octet-stream";
                }
                return File.OpenRead(downloadFilePath);
            }
            catch (Exception ex)
            {
                var ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.BadRequest);
            }
        }
        public Stream DownloadCsv()
        {
            string downloadFilePath = Path.Combine(HttpContext.Current.Server.MapPath("~/Assets/"), "export.csv");
            try
            {
                String headerInfo = "attachment; filename=" + "newFile" + "." + "csv";
                WebOperationContext.Current.OutgoingResponse.Headers["Content-Disposition"] = headerInfo;
                WebOperationContext.Current.OutgoingResponse.ContentType = "application/octet-stream";

                return File.OpenRead(downloadFilePath);
            }
            catch (Exception ex)
            {
                RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid request");
                throw new WebFaultException<RatingReviewEngineException>(ratingException, System.Net.HttpStatusCode.BadRequest);
            }

        }

        public Stream DownloadXml()
        {
            string downloadFilePath = Path.Combine(HttpContext.Current.Server.MapPath("~/Assets/"), "export.csv");
            WebOperationContext.Current.OutgoingResponse.ContentType = "application/octet-stream";
            return File.OpenRead(downloadFilePath);
        }

        public void DeleteTempFiles()
        {
            try
            {
                DateTime lastCreatedTime = DateTime.Now.AddDays(-1);

                var files = new DirectoryInfo(HttpContext.Current.Server.MapPath("~/Assets/ExportedFiles/")).GetFiles()
                            .Where(f => f.LastWriteTime < lastCreatedTime)
                            .OrderBy(f => f.LastWriteTime)
                            .Select(f => new { f.FullName });

                foreach (var file in files)
                {
                    FileInfo fInfo = new FileInfo(file.FullName);
                    fInfo.Delete();
                }
            }
            catch (Exception ex)
            {
                LogException(ex);
            }
        }

    }
}
