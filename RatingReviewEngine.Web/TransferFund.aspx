<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="TransferFund.aspx.cs" Inherits="RatingReviewEngine.Web.TransferFund" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>
<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">

    <style>
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
        var supplierId;
        var ownerId;

        $(document).ready(function () {
            supplierId = GetQueryStringParams('sid') == undefined ? "0" : GetQueryStringParams('sid');
            ownerId = GetQueryStringParams('oid') == undefined ? "0" : GetQueryStringParams('oid');

            if (supplierId != "0") {
                if (supplierId == $("#hdnSupplierId").val()) {
                    BindSupplierCommunity(supplierId);
                    BindSupplierBankDetail(supplierId);
                }
                else {
                    ErrorWindow("Fund Transfer", "No data found.", "ManageSupplierAccounts.aspx");
                }
            }
            else if (ownerId != "0") {
                if (ownerId == $("#hdnCommunityOwnerId").val()) {
                    BindOwnerCommunity(ownerId);
                    BindOwnerBankDetail(ownerId);
                }
                else {
                    ErrorWindow("Fund Transfer", "No data found.", "CommunityOwnerAccount.aspx");
                }
            }
            else {
                ErrorWindow("Fund Transfer", "No data found.", "nodata.aspx");
            }

            $('input[name="txtAmount"]').keydown(function (e) {
                AllowDecimal(e);
            });

        });

        function BindSupplierAccountBalance(supplierId) {
            var param = "/" + supplierId + "/" + $("#ddlCommunity").val();
            GetResponse("GetSupplierAccountBalance", param, BindAccountBalanceSuccess, Failure, ErrorHandler);
        }

        function BindOwnerAccountBalance(OwnerId) {
            var param = "/" + OwnerId + "/" + $("#ddlCommunity").val();
            GetResponse("GetOwnerAccountBalance", param, BindAccountBalanceSuccess, Failure, ErrorHandler);
        }

        function BindAccountBalanceSuccess(response) {
            $("#lblBalance").text((response).toFixed(2));
        }

        function BindSupplierCommunity(supplierId) {
            var param = "/" + supplierId;
            GetResponse("CommunityListBySupplier", param, BindCommunitySuccess, Failure, ErrorHandler);
        }

        function BindOwnerCommunity(ownerId) {
            var param = "/" + ownerId;
            GetResponse("GetCommunityListByOwner", param, BindCommunitySuccess, Failure, ErrorHandler);
        }

        function BindCommunitySuccess(response) {
            $kendoJS("#ddlCommunity").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "CommunityID",
                index: 0,
                optionLabel: "Select a Community",
                suggest: true,
                filter: "contains",
                dataSource: response,
                change: GetCurrency
            });

            var cid = GetQueryStringParams('cid') == undefined ? "0" : GetQueryStringParams('cid');
            $kendoJS("#ddlCommunity").data("kendoDropDownList").value(cid);
            if (cid != "0") {
                GetCurrency();
                if ($("#ddlCommunity").val() != '') {
                    if (supplierId != "0")

                        BindSupplierAccountBalance(supplierId);
                    else if (ownerId != "0")
                        BindOwnerAccountBalance(ownerId);
                }
            }
        }

        function GetCurrency() {
            ValidateCommunityDropdown();
            if ($("#ddlCommunity").val() != '') {
                var param = "/" + $("#ddlCommunity").val();
                GetResponse("GetCommunity", param, BindCommunityCurrencySuccess, Failure, ErrorHandler);
                if (supplierId != "0")
                    BindSupplierAccountBalance(supplierId);
                else if (ownerId != "0")
                    BindOwnerAccountBalance(ownerId);
            }
            else {
                $("#lblBCurrency").text('');
                $("#lblACurrency").text('');
                $("#lblBalance").text('');
            }
        }

        //On ajax call success, binds currency values to labels.
        function BindCommunityCurrencySuccess(response) {
            $("#lblBCurrency").text("(" + response.CurrencyName + ")");
            $("#lblACurrency").text(response.CurrencyName);
        }

        //Service call to fetch supplier bank detail.
        function BindSupplierBankDetail(supplierId) {
            var param = '/' + supplierId + '/Supplier';
            GetResponse("GetBankingDetails", param, GetBankingDetailsSuccess, Failure, ErrorHandler);
        }

        //Service call to fetch owner bank detail.
        function BindOwnerBankDetail(ownerId) {
            var param = '/' + ownerId + '/community owner';
            GetResponse("GetBankingDetails", param, GetBankingDetailsSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, sets the corresponding values to controls.
        function GetBankingDetailsSuccess(response) {
            $("#lblBank").text(isNullOrEmpty(response.Bank) == true ? '' : response.Bank);
            $("#lblAccountName").text(isNullOrEmpty(response.AccountName) == true ? '' : response.AccountName);
            $("#lblBSB").text(isNullOrEmpty(response.BSB) == true ? '' : response.BSB);
            $("#lblAccountNumber").text(isNullOrEmpty(response.AccountNumber) == true ? '' : response.AccountNumber);
        }

        //This method validates community dropdown.
        function ValidateCommunityDropdown() {
            if ($("#ddlCommunity").val() == '') {
                $("#spanCommunity").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                return false;
            }
            else {
                $("#spanCommunity").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                return true;
            }
        }

        //This method validates amount field.
        function ValidateAmount() {
            if ($("#txtAmount").val() == '') {
                $("#spanAmount").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                $("#txtAmount").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                //$("#spanAmount").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                return false;
            }
            else {
                if (DecimalValidation($("#txtAmount").val())) {
                    $("#spanAmount").css('display', 'none');
                    $("#txtAmount").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                    return true;
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

        //This method validates community dropdown & amount and makes service call to transfer fund.
        function TransferFund() {
            var cValid = ValidateCommunityDropdown();
            var amountValid = ValidateAmount();
            if (cValid && amountValid) {
                if (parseInt($("#lblBalance").text()) > parseInt($("#txtAmount").val())) {
                    if (supplierId != "0") {
                        var postData = '{"ID":"' + supplierId + '","Entity":"Supplier","CommunityID":"' + $("#ddlCommunity").val() + '","Description":"Transfer to Bank","Amount":"' + $("#txtAmount").val() + '"}';
                        PostRequest("DebitVirtualCommunityAccount", postData, PaymentSuccess, Failure, ErrorHandler);
                    }
                    else if (ownerId != "0") {
                        var postData = '{"ID":"' + ownerId + '","Entity":"community owner","CommunityID":"' + $("#ddlCommunity").val() + '","Description":"Transfer to Bank","Amount":"' + $("#txtAmount").val() + '"}';
                        PostRequest("DebitVirtualCommunityAccount", postData, PaymentSuccess, Failure, ErrorHandler);
                    }
                }
                else {
                    ErrorWindow('Transfer Fund', "The amount must be lesser than or equal to the Balance ", '#');
                }
            }
        }

        //On ajax call success, success message will be showed in popup.
        function PaymentSuccess(response) {
            SuccessWindow('Payment Process', 'Fund transfered successfully.', '#');
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Transfer Fund', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Transfer Fund', response, '#');
        }

        function PageRedirect() {
            if (supplierId != "0") {
                window.location = "ManageSupplierAccounts.aspx";
            }
            else if (ownerId != "0") {
                window.location = "CommunityOwnerAccount.aspx";
            }
        }
    </script>
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <h4>Transfer Funds</h4>
            <hr />
            <div class="col-md-12">
                <div class="col-md-2 pull-right">
                    <input id="btnBack" class="btn btn-block btn-lg btn-primary custom-transfund-backbutton-rightalign" value="Back" type="button" onclick="PageRedirect()" />
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label>Community</label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <div id="ddlCommunity"></div>
                        <span id="spanCommunity" class="custom-mangcurency-validation-off">You can't leave this empty.</span>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label>Current Balance</label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label id="lblBCurrency" class="custom-transfund-currenry-label"></label>
                        <label id="lblBalance" class="custom-transfund-ammount-label"></label>
                    </div>
                </div>                
            </div>
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label>Transfer Amount</label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <input type="text" id="txtAmount" name="txtAmount" placeholder="Amount" class="form-control" onblur="ValidateAmount()" />
                        <span id="spanAmount" class="custom-mangcurency-validation-off">You can't leave this empty.</span>
                    </div>
                </div>
                <div class="col-md-1">
                    <label id="lblACurrency"></label>
                </div>
            </div>

        </div>
        <div class="form-horizontal col-md-12" role="form">
            <h4>Transfer To</h4>
            <hr />
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label>Bank</label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label id="lblBank"></label>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label>Account Name</label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label id="lblAccountName"></label>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label>BSB</label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label id="lblBSB"></label>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <label>Account Number</label>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <label id="lblAccountNumber"></label>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <input type="button" value="Transfer" onclick="TransferFund()" class="btn btn-primary" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
