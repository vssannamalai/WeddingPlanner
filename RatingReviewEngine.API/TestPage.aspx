<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TestPage.aspx.cs" Inherits="RatingReviewEngine.API.TestPage" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <script type="text/javascript">
        function upload() {
            var request = new XMLHttpRequest();
            request.open('POST', 'http://localhost:44764/FileUploadService.svc/UploadImage/');
            request.send(filePicker.files[0]);
        }
        /*http://localhost:44764/FileUploadService.svc/UploadImage*/
        function uploadBlobOrFile(blobOrFile) {
            alert("test");
            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'http://localhost:44764/FileUploadService.svc/UploadImage/', true);

            // xhr.setRequestHeader('Content-length', blobOrFile.size);

            xhr.onload = function (e) {
                progressBar.value = 0;
                progressBar.textContent = progressBar.value;
            };

            // Listen to the upload progress.
            var progressBar = document.querySelector('progress');
            xhr.upload.onprogress = function (e) {
                if (e.lengthComputable) {
                    progressBar.value = (e.loaded / e.total) * 100;
                    progressBar.textContent = progressBar.value; // Fallback.
                }
            };
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    alert(xhr.responseText);
                }
            };

            xhr.send(blobOrFile);


        }

    </script>


</head>
<body>
    <form id="form1" runat="server">
        <input id="filePicker" type="file" name="Package" accept="image/*" />
        <br />
        <progress min="0" max="100" value="0">0% complete</progress>
        <br />
        <button title="upload"
            onclick="if (filePicker.files[0]) uploadBlobOrFile(filePicker.files[0]);return false;">
            <span>Upload</span>
        </button>

        <div>
            Test page
            <br />
            <br />
            <asp:Button ID="btnGetValue" runat="server" Text="Get Value" OnClick="btnGetValue_Click" Width="90" />
            <asp:Button ID="btnSendEmail" runat="server" Text="Send Test Email" OnClick="btnSendEmail_Click" />
            <asp:Button ID="btnApplicationRegister" runat="server" Text="Register Application" OnClick="btnApplicationRegister_Click" />
            <asp:Button ID="btnGenerateAPIToken" runat="server" Text="Generate API Token" OnClick="btnGenerateAPIToken_Click" />
             <asp:Button ID="btnReport" runat="server" Text="Report To PDF" OnClick="btnReport_Click" />
            <asp:Label ID="lblToken" runat="server"></asp:Label>
            
            <asp:TextBox runat="server" ID="txtEncrypt"></asp:TextBox>
            <asp:Button ID="btnEncrypt" runat="server" Text="Encrypt" OnClick="btnEncrypt_Click" />
            <asp:Button ID="btnDecrypt" runat="server" Text="Decrypt" OnClick="btnDecrypt_Click" />

            <asp:Button ID="btnPayment" runat="server" Text="Payflow" OnClick="btnPayment_Click" />
        </div>
      
    </form>

</body>
</html>
