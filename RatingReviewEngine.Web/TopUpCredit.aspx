<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="TopUpCredit.aspx.cs" Inherits="RatingReviewEngine.Web.TopUpCredit" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <style>
        .radio {
            line-height: 0.6;
        }

        .k-reset {
            font-size: 88% !important;
        }

        .k-list-container {
            width: auto !important;
            min-width: 280px;
        }

            .k-list-container .k-list .k-item {
                white-space: nowrap;
            }

        @media only screen and (min-width: 768px) and (max-width: 1024px) {

            .k-list-container {
                width: auto !important;
                min-width: 230px;
            }
        }

        #ddlCommunity-list ul {
            overflow-x: hidden !important;
        }
    </style>

    <script type="text/javascript">

        var paymentResponse;

        $(document).ready(function () {


            $('input[type=text]').bind('copy paste', function (e) {
                e.preventDefault();
            });


            $('input[type=password]').bind('copy paste', function (e) {
                e.preventDefault();
            });
            

            $("#frmRatingReviewEngine").validate({
                rules: {
                    txtCardnumber: { required: true, minlength: 10, maxlength: 22 },
                    txtCCV: { required: true, minlength: 3, maxlength: 4 }
                },
                messages: {
                    txtCardnumber: { required: 'You can\'t leave this empty.', minlength: "Please enter a valid credit card number.", maxlength: "Please enter a valid credit card number." },
                    txtCCV: { required: 'You can\'t leave this empty.', minlength: "Please enter a valid security code.", maxlength: "Please enter a valid security code." }
                },
                highlight: function (element) {
                    $(element).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                },
                unhighlight: function (element) {
                    $(element).closest('.form-group').removeClass('form-group has-error').css('color', 'black').addClass('form-group');
                },
                onfocusout: function (element) { $(element).valid(); }
            });
            BindCommunity();
            BindCCType();
            BindMonth();
            BindYear();

            $('input[name="txtAmount"]').keypress(function (e) {
                AllowDecimalKeyPress(e);
            });

            $('input[name="txtCardnumber"]').keypress(function (e) {
                AllowNumberKeyPress(e);
            });
            $('input[name="txtCCV"]').keypress(function (e) {
                AllowNumberKeyPress(e);
            });
        });

        function validatecardnumber(inputtxt) {
            var cardno = /^(?:3[47][0-9]{13})$/;
            var cardno = /^(?:4[0-9]{12}(?:[0-9]{3})?)$/;
            var cardno = /^(?:5[1-5][0-9]{14})$/;
            var cardno = /^(?:6(?:011|5[0-9][0-9])[0-9]{12})$/;
            var cardno = /^(?:3(?:0[0-5]|[68][0-9])[0-9]{11})$/;
            var cardno = /^(?:(?:2131|1800|35\d{3})\d{11})$/;

            if (inputtxt.value.match(cardno)) {
                return true;
            }
            else {
                alert("Not a valid Amercican Express credit card number!");
                return false;
            }
        }

        function BindCommunity() {
            var param = "/" + $("#hdnSupplierId").val();
            GetResponse("CommunityListBySupplier", param, BindCommunitySuccess, Failure, ErrorHandler);
        }

        function BindMonth() {
            $kendoJS("#ddlMonth").kendoDropDownList({
                dataTextField: "text",
                dataValueField: "value",
                index: 0,
                suggest: true,
                filter: "contains",
                dataSource: [
                    { text: "Jan", value: "01" },
                    { text: "Feb", value: "02" },
                    { text: "Mar", value: "03" },
                    { text: "Apr", value: "04" },
                    { text: "May", value: "05" },
                    { text: "Jun", value: "06" },
                    { text: "Jul", value: "07" },
                    { text: "Aug", value: "08" },
                    { text: "Sep", value: "09" },
                    { text: "Oct", value: "10" },
                    { text: "Nov", value: "11" },
                    { text: "Dec", value: "12" }
                ]
            });
        }

        function BindYear() {
            var d = new Date();
            var n = d.getFullYear();

            $kendoJS("#ddlYear").kendoDropDownList({
                dataTextField: "text",
                dataValueField: "value",
                index: 0,
                suggest: true,
                filter: "contains",
                dataSource: [
                    { text: n, value: n },
                    { text: n + 1, value: n + 1 },
                    { text: n + 2, value: n + 2 },
                    { text: n + 3, value: n + 3 },
                    { text: n + 4, value: n + 4 },
                    { text: n + 5, value: n + 5 },
                    { text: n + 6, value: n + 6 },
                    { text: n + 7, value: n + 7 },
                    { text: n + 8, value: n + 8 },
                    { text: n + 9, value: n + 9 },
                    { text: n + 10, value: n + 10 }
                ]
            });
        }

        function BindCCType() {
            $kendoJS("#ddlCardType").kendoDropDownList({
                dataTextField: "text",
                dataValueField: "value",
                index: 0,
                suggest: true,
                filter: "contains",
                dataSource: [
                    { text: "VISA", value: "1" },
                    { text: "MasterCard", value: "2" },
                    { text: "American Express", value: "3" }
                ]
            });
        }

        function BindCommunitySuccess(response) {
            $kendoJS("#ddlCommunity").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "CommunityID",
                index: 0,
                optionLabel: "Community",
                suggest: true,
                filter: "contains",
                dataSource: response,
                change: getCurrency
            });

            var cid = GetQueryStringParams('cid') == undefined ? "0" : GetQueryStringParams('cid');
            $kendoJS("#ddlCommunity").data("kendoDropDownList").value(cid);
            getCurrency();
        }

        function getCurrency() {
            validateCommunityDropdown();
            if ($("#ddlCommunity").val() != '') {
                var param = "/" + $("#ddlCommunity").val();
                GetResponse("GetCommunity", param, BindCommunityCurrencySuccess, Failure, ErrorHandler);
            }
            else {
                $("#lblCurrency").text('');
                $("#hdfMinTransAmt").val(0);
            }
        }

        function BindCommunityCurrencySuccess(response) {
            $("#lblCurrency").text(response.CurrencyName);
            $("#hdfMinTransAmt").val(response.CurrencyMinTransferAmount);
        }

        function validateCommunityDropdown() {
            if ($("#ddlCommunity").val() == '') {
                $("#spanCommunity").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                return false;
            }
            else {
                $("#spanCommunity").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                return true;
            }
        }

        function ValidateAmount() {
            if ($("#txtAmount").val() == '') {
                $("#spanAmount").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                $("#txtAmount").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                //$("#spanAmount").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                return false;
            }
            else {
                if (DecimalValidation($("#txtAmount").val())) {
                    if ($("#txtAmount").val() <= 99999.99) {
                        $("#spanAmount").css('display', 'none');
                        $("#txtAmount").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                        return true;
                    } else {
                        $("#txtAmount").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                        $("#spanAmount").text('Amount should be less than 100000.00.').css('display', 'block').css('color', '#E74C3C');
                        return false;
                    }
                }
                else {
                    $("#txtAmount").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                    $("#spanAmount").text('Please enter a valid amount.').css('display', 'block').css('color', '#E74C3C');
                    return false;
                }
                //$("#spanAmount").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                //return true;
            }
        }

        function ValidateCreditCardFileds() {
            var isValid = true;
            if ($("#txtCardnumber").val() == '') {
                //$("#spanCard").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                //$("#txtCardnumber").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                isValid = false;
            }
            else {
                $("#spanCard").css('display', 'none');
                $("#txtCardnumber").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
            }
            if ($("#txtCCV").val() == '') {
                //$("#spanCCV").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                //$("#txtCCV").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                isValid = false;
            }
            else {
                $("#spanCCV").css('display', 'none');
                $("#txtCCV").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
            }
            return isValid;
        }

        function PaypalProcess() {
            var cValid = validateCommunityDropdown();
            var amountValid = ValidateAmount();
            if (cValid && amountValid) {
                if (parseFloat($("#hdfMinTransAmt").val()) <= parseFloat($("#txtAmount").val())) {

                    var postData = '{"ID":"' + $("#hdnSupplierId").val() + '","Entity":"Supplier","CommunityID":"' + $("#ddlCommunity").val() + '","Description":"Topup","OAuthAccountID":"' + $("#hdnOAuthAccountID").val()
                        + '","Amount":"' + $("#txtAmount").val() + '","Currency":"' + $("#lblCurrency").text() + '","CommunityName":"' + encodeURIComponent($kendoJS("#ddlCommunity").data("kendoDropDownList").text()) + '"}';
                    PostRequest("PayflowPaypalPayment", postData, PayflowPaymentSuccess, Failure, ErrorHandler);
                }
                else {
                    ErrorWindow('TopUp Credit', "The amount must be greater than or equal to the  Minimum Transfer Amount value set within the Currency (" + $("#hdfMinTransAmt").val() + ")", '#');
                }
            }

        }

        function PaymentProcess() {
            var cValid = validateCommunityDropdown();
            var amountValid = ValidateAmount();
            if ($("#frmRatingReviewEngine").valid() && cValid && amountValid && ValidateCreditCardFileds()) {

                if (parseFloat($("#hdfMinTransAmt").val()) <= parseFloat($("#txtAmount").val())) {

                    var postData = '{"OAuthAccountID":"' + $("#hdnOAuthAccountID").val() + '","Cardnumber":"' + $("#txtCardnumber").val() + '","ExpiryDate":"' + $("#ddlMonth").val() + $.trim($("#ddlYear").val()).substring(2)
               + '","SecurityCode":"' + $("#txtCCV").val() + '","Currency":"' + $("#lblCurrency").text() + '","Amount":"' + $("#txtAmount").val() + '","Email":"' + $("#hdnUserName").val()
               + '","CommunityName":"' + encodeURIComponent($kendoJS("#ddlCommunity").data("kendoDropDownList").text()) + '"}';

                    PostRequest("PayflowPayment", postData, PaymentProcessSuccess, Failure, ErrorHandler);
                }
                else {
                    ErrorWindow('TopUp Credit', "The amount must be greater than or equal to the  Minimum Transfer Amount value set within the Currency (" + $("#hdfMinTransAmt").val() + ")", '#');
                }
            }
        }

        function PaymentSuccess(response) {
            $("#txtAmount").val('');
            $("#txtCardnumber").val('');
            $kendoJS("#ddlMonth").data("kendoDropDownList").value('');
            $kendoJS("#ddlYear").data("kendoDropDownList").value('');
            //$("#ddlMonth").val('');
            //$("#ddlYear").val('');
            $("#txtCCV").val('');

            SuccessWindow('Payment Process', 'Online topup transaction has been processed successfully.<br/> Reference Number: ' + paymentResponse, 'ManageSupplierAccounts.aspx');
        }

        function PaymentProcessSuccess(response) {
            if (response.Result == "0") {
                paymentResponse = response.TransactionID;
                var postData = '{"ID":"' + $("#hdnSupplierId").val() + '","Entity":"Supplier","CommunityID":"' + $("#ddlCommunity").val() + '","Description":"Topup","Amount":"' + $("#txtAmount").val()
                     + '"}';
                PostRequest("CreditVirtualCommunityAccount", postData, PaymentSuccess, Failure, ErrorHandler);
            }
            else {
                var msg = [];
                msg = response.ResponseMessage.split(':');
                if (msg[0] == 'Invalid expiration date')
                    ErrorWindow('TopUp Credit', "Payment transaction failed: " + 'Invalid expiration date', '#');
                else
                    ErrorWindow('TopUp Credit', "Payment transaction failed: " + response.ResponseMessage, '#');
            }
        }

        function PayflowPaymentSuccess(response) {
            if (!isNullOrEmpty(response.URL)) {
                window.location = response.URL;
                $("#progress").show();
                //var postData = '{"ID":"' + $("#hdnSupplierId").val() + '","Entity":"Supplier","CommunityID":"' + $("#ddlCommunity").val() + '","Description":"Topup","Amount":"' + $("#txtAmount").val() + '"}';
                //PostRequest("CreditVirtualCommunityAccount", postData, PaymentSuccess, Failure, ErrorHandler);
            }
            else {
                ErrorWindow('TopUp Credit', "Payment transaction failed: " + response.ResponseMessage, '#');
            }

        }

        function showPaypal() {
            $("#divPaypal").show();
            $("#divCredit").hide();
        }

        function showCreditcard() {
            $("#divPaypal").hide();
            $("#divCredit").show();
        }

        function Failure(response) {
            FailureWindow('TopUp Credit', response, '#');
        }

        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('TopUp Credit', response, '#');
        }

        function PageRedirect() {
            window.location = "ManageSupplierAccounts.aspx";

        }
        /*
        // right click disabled
        var tenth = '';

        function ninth() {
            if (document.all) {
                (tenth);
                return false;
            }
        }

        function twelfth(e) {
            if (document.layers || (document.getElementById && !document.all)) {
                if (e.which == 2 || e.which == 3) {
                    (tenth);
                    return false;
                }
            }
        }
        if (document.layers) {
            document.captureEvents(Event.MOUSEDOWN);
            document.onmousedown = twelfth;
        } else {
            document.onmouseup = twelfth;
            document.oncontextmenu = ninth;
        }
        document.oncontextmenu = new Function(' return false') */
    </script>

</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <h4>TopUp Credit</h4>
            <hr />
            <div class="col-md-12">
                <div class="col-md-2 pull-right">
                    <input id="btnBack" class="btn btn-block btn-lg btn-primary custom-transfund-backbutton-rightalign" value="Back" type="button" onclick="PageRedirect()" />
                </div>
            </div>
            <div class="form-horizontal col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label>Community</label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <div id="ddlCommunity" class="custom-dropdown-width"></div>
                        <span id="spanCommunity" class="custom-mangcurency-validation-off">You can't leave this empty.</span>
                    </div>
                </div>
            </div>

            <div class="form-horizontal col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label>TopUp Amount</label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <input type="text" id="txtAmount" name="txtAmount" placeholder="Amount" class="form-control" onblur="ValidateAmount()" />
                        <span id="spanAmount" class="custom-mangcurency-validation-off">You can't leave this empty.</span>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="form-group" style="margin-left: 0px">
                        <label id="lblCurrency"></label>
                        <input type="hidden" id="hdfMinTransAmt" />
                    </div>
                </div>
            </div>

            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label>Payment method</label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">


                        <input type="radio" id="radio1" name="payment" value="P" onclick="showPaypal()">
                        <label style="font-size: 15px;margin-right:10px;padding-right:5px;display:inline;" for="radio1">PayPal</label>

                        <input type="radio" id="radio2" name="payment" value="C" onclick="showCreditcard()">
                        <label style="font-size: 15px;padding-right:5px;display:inline;" for="radio2">Credit Card</label>

                    </div>
                </div>
            </div>

            <div class="col-md-12" id="divPaypal" style="display: none">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label>PayPal</label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <a href="#" onclick="PaypalProcess()">
                            <img src="images/btn_xpressCheckout.gif" align="left" style="margin-right: 7px;" />
                        </a>
                    </div>
                </div>
            </div>

            <div id="divCredit" style="display: none">
                <div class="col-md-12">
                    <div class="col-md-3"></div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>Card number</label>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <input type="text" id="txtCardnumber" name="txtCardnumber" placeholder="Card number" class="form-control" maxlength="22" />
                            <span id="spanCard" class="custom-mangcurency-validation-off">You can't leave this empty.</span>
                        </div>
                    </div>
                </div>

                <div class="col-md-12">
                    <div class="col-md-3"></div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>Expiry Month</label>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <div id="ddlMonth" class="custom-default-bottom-margin custom-dropdown-width"></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-12">
                    <div class="col-md-3"></div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>Expiry Year</label>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <div id="ddlYear" class="custom-dropdown-width"></div>
                        </div>
                    </div>
                </div>
                <div class="col-md-12">
                    <div class="col-md-3"></div>
                    <div class="col-md-2">
                        <div class="form-group">
                            <label>Security Code</label>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <input type="password" id="txtCCV" name="txtCCV" placeholder="CVV" class="form-control" maxlength="4" />
                            <span id="spanCCV" class="custom-mangcurency-validation-off">You can't leave this empty.</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-12">
                    <div class="col-md-3"></div>
                    <div class="col-md-2"></div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <input type="button" id="btnSave" value="Process" class="btn btn-block btn-lg btn-info" onclick="PaymentProcess()" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</asp:Content>
