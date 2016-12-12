<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="CustomerTest.aspx.cs" Inherits="RatingReviewEngine.Web.CustomerTest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <style>
        .k-reset {
            font-size: 88% !important;
        }
    </style>
    <script src="bootstrap/js/bootstrapValidator.js"></script>
    <script>
        var $JS10 = jQuery.noConflict();
    </script>
    <script src="jQuery-File-Upload-master/js/jquery.min.js"></script>
    <script>
        var $uploadJS = jQuery.noConflict();
    </script>
    <!-- The jQuery UI widget factory, can be omitted if jQuery UI is already included -->
    <script src="jQuery-File-Upload-master/js/vendor/jquery.ui.widget.js"></script>
    <!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
    <script src="jQuery-File-Upload-master/js/jquery.iframe-transport.js"></script>
    <!-- The basic File Upload plugin -->
    <script src="jQuery-File-Upload-master/js/jquery.fileupload.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            RegisterKeyDownOnLoad();

            GetResponse("GetAllSupplier", "", GetAllSupplierSuccess, Failure, ErrorHandler);
            GetResponse("GetAllCustomer", "", GetCustomerListSuccess, Failure, ErrorHandler);
            GetResponse("GetActiveActionList", "", GetActionListSuccess, Failure, ErrorHandler);
            //GetResponse("GetCommunityListBySupplier", param, GetCommunityListBySupplierSuccess, Failure, ErrorHandler);

            getCommunity();
            getCommunityGroup();
        });

        //Registers a keydown event on load.
        function RegisterKeyDownOnLoad() {
            $('input[name="txtRating"]').keydown(function (e) {
                AllowNumber(e);
            });
        }

        //On ajax call success, binds the data to dropdown.
        function GetCustomerListSuccess(response) {
            $kendoJS("#ddlCustomer").kendoDropDownList({
                dataTextField: "FirstName",
                dataValueField: "CustomerID",
                index: 0,
                suggest: true,
                optionLabel: "Customer",
                filter: "contains",
                dataSource: response
            });
        }

        //On ajax call success, binds the data to dropdown.
        function GetActionListSuccess(response) {
            $kendoJS("#ddlAction").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "ActionID",
                index: 0,
                suggest: true,
                optionLabel: "Action",
                filter: "contains",
                dataSource: response
            });
        }

        //On ajax call success, binds the data to dropdown.
        function GetAllSupplierSuccess(response) {
            $kendoJS("#ddlSupplier").kendoDropDownList({
                dataTextField: "CompanyName",
                dataValueField: "SupplierID",
                index: 0,
                suggest: true,
                optionLabel: "Supplier",
                filter: "contains",
                dataSource: response,
                change: getCommunity
            });
        }

        //Service call to community list based on supplier id.
        function getCommunity() {
            var param = "/" + ($("#ddlSupplier").val() == '' ? "0" : $("#ddlSupplier").val());
            GetResponse("CommunityListBySupplier", param, GetCommunityListSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the data to dropdown.
        function GetCommunityListSuccess(response) {
            $kendoJS("#ddlCommunity").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "CommunityID",
                index: 0,
                suggest: true,
                optionLabel: "Community",
                filter: "contains",
                dataSource: response == null ? null : response,
                change: getCommunityGroup
            });
        }

        //Service call to community group list based on supplier id and community id.
        function getCommunityGroup() {
            $('#divBillFee').html('');
            var param = "/" + ($("#ddlSupplier").val() == '' ? "0" : $("#ddlSupplier").val()) + '/' + ($("#ddlCommunity").val() == '' ? "0" : $("#ddlCommunity").val());
            GetResponse("GetSupplierCommunityGroupByCommunity", param, GetCommunityGroupListSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the data to dropdown.
        function GetCommunityGroupListSuccess(response) {
            $kendoJS("#ddlCommunityGroup").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "CommunityGroupID",
                index: 0,
                suggest: true,
                optionLabel: "Community Group",
                filter: "contains",
                dataSource: response == null ? null : response
            });
        }

        //Service call add a review.
        function addReview() {
            var currentDate = new Date();
            var postData = '{"CustomerID":"' + $("#ddlCustomer").val() + '","SupplierID":"' + $("#ddlSupplier").val() + '","CommunityID":"' + $("#ddlCommunity").val() + '","CommunityGroupID":"' + $("#ddlCommunityGroup").val()
                + '","Rating":"' + $("#txtRating").val() + '","ReviewMessage":"' + encodeURIComponent($("#txtReview").val()) + '"}';

            PostRequest("SubmitCustomerReview", postData, ReviewSuccess, Failure, ErrorHandler);
        }

        //Service call add a message.
        function addMessage() {
            var currentDate = new Date();
            var postData = '{"CustomerId":"' + $("#ddlCustomer").val() + '","SupplierId":"' + $("#ddlSupplier").val() + '","CommunityId":"' + $("#ddlCommunity").val() + '","CommunityGroupId":"' + $("#ddlCommunityGroup").val()
                + '","ActionId":"' + $("#ddlAction").val() + '","Message":"' + encodeURIComponent($("#txtMessage").val()) + '","ActionName":"' + $kendoJS("#ddlAction").data("kendoDropDownList").text() + '"}';

            PostRequest("SendMessage", postData, MessageSuccess, Failure, ErrorHandler);
        }

        //Service call add a question.
        function addQuestion() {
            var currentDate = new Date();
            var postData = '{"CustomerId":"' + $("#ddlCustomer").val() + '","SupplierId":"' + $("#ddlSupplier").val() + '","CommunityId":"' + $("#ddlCommunity").val() + '","CommunityGroupId":"' + $("#ddlCommunityGroup").val()
                + '","ActionId":"' + $("#ddlAction").val() + '","Message":"' + encodeURIComponent($("#txtQuestion").val()) + '","ActionName":"' + $kendoJS("#ddlAction").data("kendoDropDownList").text() + '"}';

            PostRequest("SendSupplierQuestion", postData, QuestionSuccess, Failure, ErrorHandler);
        }

        //Service call add a quote request.
        function addQuoteRequest() {
            var currentDate = new Date();
            var postData = '{"CustomerId":"' + $("#ddlCustomer").val() + '","SupplierId":"' + $("#ddlSupplier").val() + '","CommunityId":"' + $("#ddlCommunity").val() + '","CommunityGroupId":"' + $("#ddlCommunityGroup").val()
                + '","ActionId":"' + $("#ddlAction").val() + '","Message":"' + encodeURIComponent($("#txtQuote").val()) + '","ActionName":"' + $kendoJS("#ddlAction").data("kendoDropDownList").text() + '"}';

            PostRequest("SendQuoteRequest", postData, QuoteRequestSuccess, Failure, ErrorHandler);
        }

        function UploadAttachment(supplieractionid) {
            $("#progress").show();
            var urlUploadLogo = $("#hdnFileUploadUrl").val() + 'SaveSupplierActionAttachment';
            $uploadJS('#fileupload1').fileupload({
                // autoUpload: false,
                url: urlUploadLogo,
                done: function (e, data) {
                    $("#progress").hide();
                    SuccessWindow('Message', 'Requested quote successfully.', '#');
                }
            });
            if ($('#fileupload1').val() == '') {
                $("#progress").hide();
                SuccessWindow('Message', 'Requested quote successfully.', '#');
            } else {
                $uploadJS('#fileupload1').fileupload('add', {
                    fileInput: $('#fileupload1'),
                    formData: { supplieractionid: supplieractionid }
                });
            }
        }

        //Service call add a payment.
        function addPayment() {
            var currentDate = new Date();
            var postData = '{"CustomerID":"' + $("#ddlCustomer").val() + '","SupplierID":"' + $("#ddlSupplier").val() + '","CommunityID":"' + $("#ddlCommunity").val() + '","CommunityGroupID":"' + $("#ddlCommunityGroup").val()
                + '","ActionID":"' + $("#ddlAction").val() + '","Amount":"' + $("#txtAmount").val() + '"}';

            PostRequest("NewCustomerTransaction", postData, PaymentSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, success message will be showed in popup.
        function ReviewSuccess() {
            SuccessWindow('Review', 'Review added successfully.', '#');
        }

        //On ajax call success, success message will be showed in popup.
        function MessageSuccess() {
            SuccessWindow('Message', 'Message added successfully.', '#');
        }

        //On ajax call success, success message will be showed in popup.
        function QuestionSuccess() {
            SuccessWindow('Message', 'Message added successfully.', '#');
        }

        //On ajax call success, success message will be showed in popup.
        function QuoteRequestSuccess(response) {
            UploadAttachment(response.SupplierActionId)

        }

        //On ajax call success, success message will be showed in popup.
        function PaymentSuccess() {
            SuccessWindow('Message', 'Payment sent successfully.', '#');
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Customer', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Customer', response, '#');
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $JS10('#frmRatingReviewEngine').bootstrapValidator({
                excluded: ':disabled',
                group: '.form-group1',
                message: 'This value is not valid',
                /* feedbackIcons: {
                        valid: 'glyphicon glyphicon-ok',
                        invalid: 'glyphicon glyphicon-remove',
                        validating: 'glyphicon glyphicon-refresh'
                   },*/
                fields: {
                    //Logo 
                    fileupload1: {
                        validators: {
                            feedbackIcons: {
                                valid: 'glyphicon glyphicon-ok',
                                invalid: 'glyphicon glyphicon-remove',
                                validating: 'glyphicon glyphicon-refresh'
                            },
                            file: {
                                //  extension: 'jpeg,png,jpg',
                                //  type: 'image/jpeg,image/png',
                                maxSize: 3145728, // 3 MB
                                message: 'The selected file is not valid. Maximum image size allowed is 3MB.'
                            }
                        }
                    }
                }
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <h2>Customer Test</h2>
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <hr />
            <div class="col-md-12">
                <div class="col-md-2">
                    <div class="form-group">
                        <label>Customer</label>
                    </div>
                    <div class="form-group">
                        <label>Supplier</label>
                    </div>
                    <div class="form-group">
                        <label>Community</label>
                    </div>
                    <div class="form-group">
                        <label>Community Group</label>
                    </div>
                    <div class="form-group">
                        <label>Action</label>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div id="ddlCustomer" class="custom-dropdown-width"></div>
                    </div>
                    <div class="form-group">
                        <div id="ddlSupplier" class="custom-dropdown-width"></div>
                    </div>
                    <div class="form-group">
                        <div id="ddlCommunity" class="custom-dropdown-width"></div>
                    </div>
                    <div class="form-group">
                        <div id="ddlCommunityGroup" class="custom-dropdown-width"></div>
                    </div>
                    <div class="form-group">
                        <div id="ddlAction" class="custom-dropdown-width"></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="col-md-2">
                <div class="form-group">
                    <label>Review</label>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group">
                    <input type="text" id="txtReview" class="form-control" placeholder="Review" />
                </div>
            </div>
            <div style="float: left; width: 5%;">
                <div class="form-group">
                    <label>Rating</label>
                </div>
            </div>
            <div style="float: left; width: 10.4%; margin-right: 14px;">
                <div class="form-group">
                    <input type="text" id="txtRating" class="form-control" name="txtRating" placeholder="Rating" />
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <input type="button" value="Add Review" id="btnReview" onclick="addReview()" class="btn btn-block btn-lg btn-primary" />
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="col-md-2">
                <div class="form-group">
                    <label>Message</label>
                </div>
            </div>
            <div class="col-md-8">
                <div class="form-group">
                    <input type="text" id="txtMessage" class="form-control" placeholder="Message" />
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <input type="button" id="btnAddMessage" value="Add message" onclick="addMessage()" class="btn btn-block btn-lg btn-primary" />
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="col-md-2">
                <div class="form-group">
                    <label>Question</label>
                </div>
            </div>
            <div class="col-md-8">
                <div class="form-group">
                    <input type="text" id="txtQuestion" class="form-control" placeholder="Question" />
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <input type="button" id="btnQuestion" value="Add Question" onclick="addQuestion()" class="btn btn-block btn-lg btn-primary" />
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="col-md-2">
                <div class="form-group">
                    <label>Quote Request</label>
                </div>
            </div>
            <div class="col-md-6">
                <div class="form-group">
                    <textarea id="txtQuote" placeholder="Detail" rows="4" class="form-control" name="txtDetail"></textarea>
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group1">
                    <div class="fileinput fileinput-new" data-provides="fileinput">
                        <div class="custom-regsupplier-remove-btn">
                            <a href="#" class="fileinput-exists fui-cross" data-dismiss="fileinput"></a>
                        </div>
                        <div class="fileinput-preview thumbnail" data-trigger="fileinput" style="width: 125px; height: 125px;"></div>
                        <div>
                            <span class="btn btn-default btn-primary btn-file"><span class="fileinput-new">Add File</span>
                                <span class="fileinput-exists">Change File</span>
                                <input id="fileupload1" type="file" name="fileupload1" />
                            </span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <input type="button" id="btnQuote" value="Quote Request" onclick="addQuoteRequest()" class="btn btn-block btn-lg btn-primary" />
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="col-md-2">
                <div class="form-group">
                    <label>Payment</label>
                </div>
            </div>
            <div class="col-md-8">
                <div class="form-group">
                    <input type="text" id="txtAmount" class="form-control" placeholder="Payment" />
                </div>
            </div>
            <div class="col-md-2">
                <div class="form-group">
                    <input type="button" id="btnPayment" value="Payment" onclick="addPayment()" class="btn btn-block btn-lg btn-primary" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
