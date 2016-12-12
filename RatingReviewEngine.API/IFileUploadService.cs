using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;

namespace RatingReviewEngine.API
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IFileUploadService" in both code and config file together.
    [ServiceContract]
    public interface IFileUploadService
    {
        [OperationContract]
        [WebInvoke(UriTemplate = "/UploadImage",   Method = "POST")]
        string UploadImage(Stream uploadImageRequest);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SaveSupplierLogo",   Method = "POST")]
        string SaveSupplierLogo(Stream uploadImageRequest);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SaveSupplierIcon", Method = "POST")]
        string SaveSupplierIcon(Stream uploadImageRequest);

        [OperationContract]
        [WebInvoke(UriTemplate = "/SaveSupplierActionAttachment", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
        string SaveSupplierActionAttachment(Stream FileByteStream);

        [OperationContract]
        [WebGet(UriTemplate = "/DownloadFile/{fileName}")]
        Stream DownloadFile(string fileName);

        [OperationContract]
        [WebGet(UriTemplate = "/DownloadFileWithName/{fileName}")]
        Stream DownloadFileWithName(string fileName);

         [OperationContract]
         [WebGet(UriTemplate = "/DownloadCsv")]
        Stream DownloadCsv();

         [WebInvoke(UriTemplate = "/DeleteTempFiles", ResponseFormat = WebMessageFormat.Json, Method = "POST")]
         void DeleteTempFiles();

    }
}
