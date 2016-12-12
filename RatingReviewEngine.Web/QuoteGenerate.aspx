<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="QuoteGenerate.aspx.cs" Inherits="RatingReviewEngine.Web.QuoteGenerate" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>
<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">

    <style type="text/css">
        .modal-dialog {
            position: absolute;
            top: 15% !important;
        }

        .modal-footer {
            border-top: none !important;
        }

        .form-control[disabled], .checkbox.disabled, .radio.disabled {
            color: black;
        }
    </style>
    <script type="text/javascript">
        var quoteId = GetQueryStringParams('qid') == undefined ? "0" : GetQueryStringParams('qid');
        $(document).ready(function () {
            if (GetQueryStringParams('said') == null) {
                ErrorWindow('Quote Generate', "No data found", 'Nodata.aspx');
                return;
            }
            ControlValidation();
            ButtonClickEventOnLoad();
            KeyDownEventOnLoad();

            if (quoteId == 0) {
                GetQuote();
            }
            else {
                BindParentSupplierQuoteRequest();
                QuoteView();
            }
            SetReadOnly("txtNote");

        });

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    // txtQuoteAmt: { required: true },
                    txtNote: { required: true }
                },
                messages: {
                    // txtQuoteAmt: { required: 'You can\'t leave this empty.' },
                    txtNote: { required: 'You can\'t leave this empty.' }
                },
                highlight: function (element) {
                    $(element).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                },
                unhighlight: function (element) {
                    $(element).closest('.form-group').removeClass('form-group has-error').css('color', 'black').addClass('form-group');
                },
                onfocusout: function (element) { $(element).valid(); }
            });
        }

        //Registers a button click event on page load.
        function ButtonClickEventOnLoad() {
            $('#btnSend').click(function (e) {
                if ($("#frmRatingReviewEngine").valid() && ValidateQuoteAmount() && ValidateDepositAmount()) {
                    SendQuote();
                }
                e.preventDefault();
            });
        }

        //Registers a keydown event on page load.
        function KeyDownEventOnLoad() {
            $('input[name="txtQuoteAmt"]').keydown(function (e) {
                AllowDecimal(e);
            });

            $('input[name="txtDepositAmt"]').keydown(function (e) {
                AllowDecimal(e);
            });
        }

        function ValidateQuoteAmount() {
            if ($("#txtQuoteAmt").val() == '') {
                $("#spanQuoteAmount").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                $("#txtQuoteAmt").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                return false;
            }
            else {
                if (DecimalValidation($("#txtQuoteAmt").val())) {
                    $("#spanQuoteAmount").css('display', 'none');
                    $("#txtQuoteAmt").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                    return true;
                }
                else {
                    $("#txtQuoteAmt").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                    $("#spanQuoteAmount").text('Please enter a valid amount.').css('display', 'block').css('color', '#E74C3C');
                    return false;
                }

            }
        }

        function ValidateDepositAmount() {
            //if ($("#txtDepositAmt").val() == '') {
            //    $("#spanDepositAmount").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
            //    $("#txtDepositAmt").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
            //    return false;
            //}
            //else {
            if ($("#chkDeposit").is(':checked')) {
                if (DecimalValidation($("#txtDepositAmt").val())) {
                    $("#spanDepositAmount").css('display', 'none');
                    $("#txtDepositAmt").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                    return true;
                }
                else {
                    $("#txtDepositAmt").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                    $("#spanDepositAmount").text('Please enter a valid amount.').css('display', 'block').css('color', '#E74C3C');
                    return false;
                }
            }
            else
                return true;
            // }
        }

        function GetQuote() {
            var param = '/' + GetQueryStringParams('said');
            GetResponse("GetCustomerQuoteByParentSupplierActionId", param, GetQuoteSuccess, Failure, ErrorHandler);
        }
        //On ajax call success, sets values to controls.
        function GetQuoteSuccess(response) {

            if (response.CustomerQuoteID == 0) {
                BindSupplierQuoteRequest();
                return;
            }

            $("#subTitle").text('Quote Detail');
            quote = response.CustomerQuoteID;
            $("#txtQuoteAmt").val(response.QuoteAmount);
            $("#txtQuoteTerms").val(response.QuoteTerms);
            $("#txtNote").val(response.QuoteDetail);

            if (response.DepositSpecified) {
                $("#chkDeposit").checkbox('check');
                //$("#btnSend").attr('disabled', '');

                $("#txtDepositAmt").removeClass('custom-hide');
                $("#txtDepositTerms").removeClass('custom-hide');
                $("#txtDepositAmt").val(response.DepositAmount);
                $("#txtDepositTerms").val(response.DepositTerms);
            }
            else {
                $("#chkDeposit").checkbox('uncheck');
                //$("#btnSend").removeAttr('disabled');

                $("#txtDepositAmt").addClass('custom-hide');
                $("#txtDepositTerms").addClass('custom-hide');
                $("#txtDepositAmt").val('');
                $("#txtDepositTerms").val('');
            }
            BindSupplierQuoteRequest();
            SetControlsReadonly();
            $("#btnSend").attr('disabled', '');
        }

        //Service call to fetch supplier quote details.
        function BindSupplierQuoteRequest() {
            var param = '/' + GetQueryStringParams('said');
            GetResponse("GetSupplierActionByActionId", param, BindSupplierQuoteRequestSuccess, Failure, ErrorHandler);
        }

        //Service call to fetch supplier quote details.
        function BindParentSupplierQuoteRequest() {
            var param = '/' + GetQueryStringParams('said');
            GetResponse("GetSupplierParentActionByActionId", param, BindSupplierQuoteRequestSuccess, Failure, ErrorHandler);
        }

        function DownloadAttachment() {
            var param;
            //  var quoteId = GetQueryStringParams('qid') == undefined ? "0" : GetQueryStringParams('qid');
            if (quoteId == 0)
                param = '/' + GetQueryStringParams('said');
            else
                param = '/' + $("#hdfParentSupplierActionId").val();

            GetResponse("DownloadSupplierActionAttachment", param, DownloadAttachmentSuccess, Failure, ErrorHandler);
        }

        function DownloadAttachmentSuccess(response) {
            var urlDownloadFile = $("#hdnFileUploadUrl").val() + 'DownloadFileWithName/' + response;
            var myWin = window.open(urlDownloadFile, "_self");

            if (myWin == undefined)
                alert('Please disable your popup blocker to download the file.');
        }

        //On ajax call success, sets values to control on the page and fetches supplier detail.
        function BindSupplierQuoteRequestSuccess(response) {
            if (response != null) {
                if (response.Detail != 'Quote Request') {
                    ErrorWindow('Quote Generate', 'Unauthorized access', 'nodata.aspx');
                    return;
                }
                $("#lblRequestDetail").text(response.Message);
                $("#hdfSupplierId").val(response.SupplierID);
                $("#hdfCustomerId").val(response.CustomerID);
                $("#hdfCommunityId").val(response.CommunityID);
                $("#hdfCommunityGroupId").val(response.CommunityGroupID);
                $("#hdfCurrencyId").val(response.CurrencyId);
                $("#lblCurrency").text(response.CurrencyName);
                $("#hdfParentSupplierActionId").val(response.SupplierActionID);
                if (response.IsAttachment) {
                    $("#divAttachment").show();
                    $("#aAttachment").text(response.FileName);
                }
                else
                    $("#divAttachment").hide();

                //  var quoteId = GetQueryStringParams('qid') == undefined ? "0" : GetQueryStringParams('qid');
                if (quoteId == 0) {
                    var param = "/" + response.SupplierID;
                    GetResponse("GetSupplier", param, GetSupplierSuccess, Failure, ErrorHandler);

                    var param1 = "/" + response.SupplierID + "/" + response.CommunityGroupID;
                    GetResponse("GetSupplierReviewPendingCountByGroup", param1, GetSupplierReviewCountSuccess, Failure, ErrorHandler);
                }
            }
        }

        //On ajax call success, sets quote information.
        function GetSupplierSuccess(response) {
            if ($("#hdnSupplierId").val() != response.SupplierID) {
                ErrorWindow('Quote Generate', 'Unauthorized access', 'nodata.aspx');
                return;
            }
            $("#txtQuoteTerms").val(response.QuoteTerms);
            $("#hdfDepositPercentage").val(response.DepositPercent);
            $("#hdfDepositTerm").val(response.DepositTerms);
        }

        //On ajax call success, sets additional note detail.
        function GetSupplierReviewCountSuccess(response) {
            $("#txtNote").val('Response pending for ' + response + ' review(s)');
        }

        //Calculated deposit amount based on quote amount and deposit percentage.
        function CalculateDepositAmt() {
            if ($("#chkDeposit").is(':checked')) {
                $("#txtDepositAmt").removeClass('custom-hide');
                $("#txtDepositTerms").removeClass('custom-hide');

                if ($("#txtQuoteAmt").val() != "" && $("#txtQuoteAmt").val() > 0) {
                    var depositAmount = (($("#txtQuoteAmt").val() * $("#hdfDepositPercentage").val()) / 100).toFixed(2);
                    $("#txtDepositAmt").val(depositAmount);
                    $("#txtDepositTerms").val($("#hdfDepositTerm").val());

                    $("#spanDepositAmount").css('display', 'none');
                    $("#txtDepositAmt").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                }
            }
            else {
                $("#txtDepositAmt").addClass('custom-hide');
                $("#txtDepositTerms").addClass('custom-hide');
                $("#spanDepositAmount").css('display', 'none');
                $("#txtDepositAmt").closest('.form-group').removeClass('form-group has-error').addClass('form-group');

                $("#txtDepositAmt").val('');
                $("#txtDepositTerms").val('');
            }
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Quote Generate', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Quote Generate', response, '#');
        }

        //Service call to save quote information.
        function SendQuote() {
            var depositSpecified;
            if ($("#chkDeposit").is(':checked'))
                depositSpecified = true;
            else
                depositSpecified = false;

            var postData = '{"CustomerID": "' + $("#hdfCustomerId").val() + '", "CommunityID": "' + $("#hdfCommunityId").val() + '", "CommunityGroupID": "' + $("#hdfCommunityGroupId").val()
                + '", "SupplierID": "' + $("#hdfSupplierId").val() + '", "QuoteAmount": "' + $("#txtQuoteAmt").val()
                + '", "DepositSpecified": "' + depositSpecified + '", "DepositAmount": "' + ($.trim($("#txtDepositAmt").val()) == '' ? '0' : $("#txtDepositAmt").val()) + '", "QuoteTerms": "' + encodeURIComponent($("#txtQuoteTerms").val())
                + '", "DepositTerms": "' + encodeURIComponent($("#txtDepositTerms").val()) + '", "CurrencyID": "' + $("#hdfCurrencyId").val() + '", "QuoteDetail": "' + $("#txtNote").val()
                + '", "ParentSupplierActionID": "' + GetQueryStringParams('said') + '"}';

            PostRequest("SendCustomerQuote", postData, SendQuoteSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, redirect to supplier activity tracker page.
        function SendQuoteSuccess() {
            SuccessWindow('Quote Generate', "Saved successfully.", 'SupplierActivityTracker.aspx?gid=' + Encrypted($("#hdfCommunityGroupId").val()));
        }

        //If quote id already exist then this method will bind the details to the respective controls.
        function QuoteView() {
            //  var quoteId = GetQueryStringParams('qid') == undefined ? "0" : GetQueryStringParams('qid');
            if (quoteId > 0) {
                $("#subTitle").text('Quote Detail');
                SetControlsReadonly();
                var param = '/' + quoteId;
                GetResponse("GetCustomerQuote", param, GettCustomerQuoteSuccess, Failure, ErrorHandler);
            }
        }


        //On ajax call success, sets values to controls.
        function GettCustomerQuoteSuccess(response) {

            if (response.SupplierActionID != GetQueryStringParams('said') && quoteId > 0) {
                ErrorWindow("Quote Generate", "No data found", "nodata.aspx");
                return;
            }

            $("#txtQuoteAmt").val(response.QuoteAmount);
            $("#txtQuoteTerms").val(response.QuoteTerms);
            $("#txtNote").val(response.QuoteDetail);

            if (response.DepositSpecified) {
                $("#chkDeposit").checkbox('check');
              //  $("#btnSend").attr('disabled', '');

                $("#txtDepositAmt").removeClass('custom-hide');
                $("#txtDepositTerms").removeClass('custom-hide');
                $("#txtDepositAmt").val(response.DepositAmount);
                $("#txtDepositTerms").val(response.DepositTerms);
            }
            else {
                $("#chkDeposit").checkbox('uncheck');
              //  $("#btnSend").removeAttr('disabled');

                $("#txtDepositAmt").addClass('custom-hide');
                $("#txtDepositTerms").addClass('custom-hide');
                $("#txtDepositAmt").val('');
                $("#txtDepositTerms").val('');
            }

            $("#btnSend").attr('disabled', '');
        }

        //Sets all the controls to readyonly.
        function SetControlsReadonly() {
            SetReadOnly("txtQuoteAmt");
            SetReadOnly("txtQuoteTerms");
            SetReadOnly("txtNote");

            $("#txtQuoteAmt").attr('disabled', '');
            $("#txtQuoteTerms").attr('disabled', '');
            $("#txtNote").attr('disabled', '');
            $("#txtDepositAmt").attr('disabled', '');
            $("#txtDepositTerms").attr('disabled', '');

            $("#lblCheckBox").addClass('disabled');
            $("#chkDeposit").attr('disabled', '');
            SetReadOnly("txtDepositAmt");
            SetReadOnly("txtDepositTerms");
        }

        //This method shows the quote details in popup window.
        function PreviewQuote() {

            BootstrapDialog.show({
                title: 'Preview - Quote',
                message: $('<div style="height: 420px;"><div class="form-group col-md-12 custom-quotedetail-div-bottom"><label class="col-md-4 custom-quotedetail-lable-height"><b>Quote Amount:</b></label> <label class="col-md-8 custom-quotedetail-lable-height">' + $("#txtQuoteAmt").val() + '</label></div>'
                    + '<div class="form-group col-md-12 custom-quotedetail-div-bottom"><label class="col-md-4 custom-quotedetail-lable-height"><b>Quote Terms:</b></label> <label class="col-md-8 custom-quotedetail-lable-height">' + htmlEncode($("#txtQuoteTerms").val()) + '</label></div>'
                     + '<div class="form-group col-md-12 custom-quotedetail-div-bottom"><label class="col-md-4 custom-quotedetail-lable-height"><b>Additional Note:</b></label> <label class="col-md-8 custom-quotedetail-lable-height">' + htmlEncode($("#txtNote").val()) + '</label></div>'
                      + '<div class="form-group col-md-12 custom-quotedetail-div-bottom"><label class="col-md-4 custom-quotedetail-lable-height"><b>Specify Deposit:</b></label> <label class="col-md-8 custom-quotedetail-lable-height">' + ($("#chkDeposit").is(':checked') ? "Yes" : "No") + '</label></div>'
                       + '<div class="form-group col-md-12 custom-quotedetail-div-bottom"><label class="col-md-4 custom-quotedetail-lable-height"><b>Deposit Amount:</b></label> <label class="col-md-8 custom-quotedetail-lable-height">' + htmlEncode($("#txtDepositAmt").val()) + '</label></div>'
                        + '<div class="form-group col-md-12 custom-quotedetail-div-bottom"><label class="col-md-4 custom-quotedetail-lable-height"><b>Deposit Terms:</b></label> <label class="col-md-8 custom-quotedetail-lable-height">' + htmlEncode($("#txtDepositTerms").val()) + '</label></div>'
                    + '</div>'),
                buttons: [{
                    label: 'Close',
                    cssClass: 'btn-default',
                    action: function (dialog) {
                        dialog.close();
                    }
                }],
                type: BootstrapDialog.TYPE_INFO
            });
        }
    </script>
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2" id="subTitle">Generate Quote</h2>
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <input type="hidden" id="hdfCustomerId" />
            <input type="hidden" id="hdfCommunityId" />
            <input type="hidden" id="hdfCommunityGroupId" />
            <input type="hidden" id="hdfSupplierId" />
            <input type="hidden" id="hdfCurrencyId" />
            <input type="hidden" id="hdfDepositPercentage" />
            <input type="hidden" id="hdfDepositTerm" />
            <input type="hidden" id="hdfParentSupplierActionId" />
            <hr />
        </div>
        <div class="col-md-12">
            <div class="custom-quotedetail-innerdiv">
                <div>
                    <label class="custom-quotedetail-label-lineheight">Request Detail</label>
                </div>
                <div>
                    <label id="lblRequestDetail" class="custom-quotedetail-label-fontstyle"></label>
                </div>
            </div>
            <div class="form-group">
                <label>Attachment</label>
                <div id="divAttachment" style="display: none">
                    <a id="aAttachment" href="#" onclick="DownloadAttachment()">Downlad attachment</a>
                </div>
            </div>
            <div class="form-group">
                <h4>Quote Detail</h4>
            </div>
            <div class="col-md-12">
                <div class="col-md-4">
                    <div class="form-group">
                        <input type="text" id="txtQuoteAmt" placeholder="Quote Amount" class="form-control" name="txtQuoteAmt" maxlength="10" onblur=" ValidateQuoteAmount();CalculateDepositAmt()" />
                        <span id="spanQuoteAmount" class="custom-mangcurency-validation-off">You can't leave this empty.</span>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form-group">
                        <label id="lblCurrency">Currency</label>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-12">
                    <div class="form-group">
                        <textarea id="txtQuoteTerms" placeholder="Quote Terms" class="form-control" name="txtQuoteTerms" maxlength="250"></textarea>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <input type="text" id="txtNote" placeholder="Additional Note" class="form-control" name="txtNote" maxlength="200" />
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-6">
                    <div class="form-group">
                        <label for="chkDeposit" class="checkbox custom-quotedetail-checkbox-textalign" id="lblCheckBox">
                            <span class="icons"><span class="first-icon fui-checkbox-unchecked"></span><span class="second-icon fui-checkbox-checked"></span></span>
                            <input type="checkbox" value="" id="chkDeposit" data-toggle="checkbox" onchange="CalculateDepositAmt()" />
                            Specify Deposit
                        </label>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-4">
                    <div class="form-group">
                        <input type="text" id="txtDepositAmt" placeholder="Deposit Amount" class="form-control custom-hide" name="txtDepositAmt" maxlength="15" onblur=" ValidateDepositAmount()" />
                        <span id="spanDepositAmount" class="custom-mangcurency-validation-off">You can't leave this empty.</span>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-12">
                    <div class="form-group">
                        <textarea id="txtDepositTerms" placeholder="Deposit Terms" class="form-control custom-hide" name="txtDepositTerms" maxlength="250"></textarea>
                    </div>
                </div>
                <div class="form-group pull-right custom-quotedetail-button-align">
                    <input type="button" id="btnPreview" value="Preview" class="btn btn-primary" onclick="PreviewQuote()" />
                    <input type="button" id="btnSend" value="Send" class="btn btn-primary" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
