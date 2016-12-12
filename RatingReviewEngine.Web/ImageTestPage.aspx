<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="ImageTestPage.aspx.cs" Inherits="RatingReviewEngine.Web.ImageTestPage" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <div class="container">
        <h1>jQuery File Upload Demo</h1>

        <!-- The fileinput-button span is used to style the file input field as button -->
        <span class="btn btn-success fileinput-button">
            <i class="glyphicon glyphicon-plus"></i>
            <span>Select files...</span>
            <!-- The file input field used as target for the file upload widget -->
            <input id="fileupload" type="file" name="files[]" multiple />
            <br />
            <br />
        </span>
        <br>
        <br>
        <input type="button" title="Upload" text="Upload" value="Upload" id="btnUploadLogo" />
        <!-- The global progress bar -->
        <div id="progress" class="progress">
            <div class="progress-bar progress-bar-success"></div>
        </div>
        <!-- The container for the uploaded files -->
        <div id="files" class="files"></div>
        <br>
    </div>
    <script src="jQuery-File-Upload-master/js/jquery.min.js"></script>
    <!-- The jQuery UI widget factory, can be omitted if jQuery UI is already included -->
    <script src="jQuery-File-Upload-master/js/vendor/jquery.ui.widget.js"></script>
    <!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
    <script src="jQuery-File-Upload-master/js/jquery.iframe-transport.js"></script>
    <!-- The basic File Upload plugin -->
    <script src="jQuery-File-Upload-master/js/jquery.fileupload.js"></script>
    <!-- Bootstrap JS is not required, but included for the responsive demo navigation -->
    <script src="jQuery-File-Upload-master/js/bootstrap.min.js"></script>
    <script>
        /*jslint unparam: true */
        /*global window, $ */
        $(function () {
            'use strict';
            // Change this to the location of your server-side upload handler:
            var url = 'https://localhost:44300/FileUploadService.svc/UploadImage';
            $('#fileupload').fileupload({
                autoUpload: false,
                url: url,
                //headers: data.headers = { 'X-Session-Id': "TEST-HEADER" },
                add: function (e, data) {
                    data.headers = { 'APIToken': 'SZUP14ZSbwMbWXb1gBY5t1nAXXaqEK4i' };

                    data.context = $('#btnUploadLogo')
                        .click(function () {
                            //data.context = $('<p/>').text('Uploading...').replaceAll($(this));
                            data.submit();
                        });
                },
                formData: { supplierid: 1, suppliername: 'Hems', customerid: 12, filename: 'test.jpg' },
                dataType: 'json'
                /*,done: function (e, data) {
                    $.each(data.result.files, function (index, file) {
                        $('<p/>').text(file.name).appendTo('#files');
                    });
                }
                ,
                progressall: function (e, data) {
                    var progress = parseInt(data.loaded / data.total * 100, 10);
                    $('#progress .progress-bar').css(
                        'width',
                        progress + '%'
                    );
                }*/
            }).prop('disabled', !$.support.fileInput)
                .parent().addClass($.support.fileInput ? undefined : 'disabled');
        });
    </script>
     
    <asp:Label runat="server" ID="Label1" meta:resourcekey="Label1Resource1" ></asp:Label>
    <asp:Label runat="server" ID="Label2" Text="Hello" meta:resourcekey="Label2Resource1"></asp:Label>
      <div class="form-horizontal" role="form">
                <h4>Results</h4>
                <div id="communityDiv">
                    <h4>   <asp:Localize runat=server 
          ID="WelcomeMessage" 
          Text="" meta:resourcekey="Literal1" /> </h4>
                    
                       <h4> h4 
                              <asp:Localize runat="server"  ID="Localize1" Text="<%$ Resources: Lit1 %>" /> 
                       </h4>
                 
                    <div id="gvCommunityDetails"></div>
                </div>
                <div id="communityGroupDiv">
                    <h4>Community Group</h4>
                    <div id="gvCommunityGroupDetails"></div>
                </div>
            </div>
</asp:Content>
