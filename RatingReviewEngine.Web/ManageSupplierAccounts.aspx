<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="ManageSupplierAccounts.aspx.cs" Inherits="RatingReviewEngine.Web.ManageSupplierAccounts" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>
<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <script src="js/jquery.generateFile.js"></script>

    <style>
        .k-header {
            color: White;
            background-color: #34495E;
            font-size: 16px;
        }

        body {
            font-size: 14px !important;
        }

        .k-pager-numbers .k-link {
            line-height: 2.28em !important;
        }

        .k-reset {
            font-size: 100% !important;
        }

        .k-list-container {
            width: auto !important;
            min-width: 391px;
        }

        .custom-supplieracc-date-validation {
            padding: 0px 50px;
        }

        @media only screen and (min-width: 768px) and (max-width: 1195px) {

            .k-list-container {
                width: auto !important;
                min-width: 320px;
            }

            .custom-supplieracc-date-validation {
                padding: 0px 40px;
            }

            .custom-supplieracc-col-md-1 {
                margin-left: 4%;
            }
        }

        #ddlCommunity-list ul {
            overflow-x: hidden !important;
        }

            #ddlCommunity-list ul li {
                padding-right: 30px;
            }


        #ddlCommunityGroup-list ul {
            overflow-x: hidden !important;
        }

            #ddlCommunityGroup-list ul li {
                padding-right: 30px;
            }
    </style>

    <script type="text/javascript">
        var communityId = 0;
        var jsonResponse;
        var pageCount = 1;
        var pageSize = 10;
        var totalRecords = 0;

        $(document).ready(function () {
            ControlValidation();
            BindBankDetail();
            BindCommunity();
            BindCreditSummary();
            BindDatePicker();
        });

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    txtBank: { required: true },
                    txtAccountName: { required: true },
                    txtBSB: { required: true },
                    txtAccountNumber: { required: true }
                },
                messages: {
                    txtBank: { required: 'You can\'t leave this empty.' },
                    txtAccountName: { required: 'You can\'t leave this empty.' },
                    txtBSB: { required: 'You can\'t leave this empty.' },
                    txtAccountNumber: { required: 'You can\'t leave this empty.' }
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

        //Service call to fetch supplier bank detail.
        function BindBankDetail() {
            var param = '/' + $("#hdnSupplierId").val() + '/Supplier';
            GetResponse("GetBankingDetails", param, GetBankingDetailsSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, sets the corresponding values to controls.
        function GetBankingDetailsSuccess(response) {
            $("#lblBank").text(isNullOrEmpty(response.Bank) == true ? '' : response.Bank);
            $("#lblAccountName").text(isNullOrEmpty(response.AccountName) == true ? '' : response.AccountName);
            $("#lblBSB").text(isNullOrEmpty(response.BSB) == true ? '' : response.BSB);
            $("#lblAccountNumber").text(isNullOrEmpty(response.AccountNumber) == true ? '' : response.AccountNumber);
        }

        //Service call to fetch supplier credit summary details.
        function BindCreditSummary() {
            var param = '/' + $("#hdnSupplierId").val();
            GetResponse("GetSupplierCredit", param, GetSupplierCreditSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the credit information to grid.
        function GetSupplierCreditSuccess(response) {
            $kendoJS("#gvCreditSummary").kendoGrid({
                dataSource: {
                    pageSize: 10,
                    data: response
                },
                pageable: true,
                scrollable: false,
                columns: [
                    { field: "CommunityName", width: 400, title: "Community", template: '<a id="#=CommunityID#" class="custom-anchor" onclick="BindTransactionDetail(this)">${CommunityName}</a>' },
                    { field: "CreditAmount", width: 150, title: "Credit", template: '<a id="#=CommunityID#" href="TopupCredit.aspx?cid=#=Encrypted(CommunityID)#" class="custom-anchor"><span id=${CurrencyID}>(${CurrencyName}) </span>#=(CreditAmount).toFixed(2)#</a>' },
                    { field: "CurrentRevenue", width: 150, title: "Current Revenue", template: '<span id=${CurrencyID}>(${CurrencyName}) #=(CurrentRevenue).toFixed(2)#</span>' },
                    { field: "Balance", width: 200, title: "Current Account Balance", template: '<a id="#=CommunityID#"  href="TransferFund.aspx?sid=' + Encrypted($("#hdnSupplierId").val()) + '&cid=#=Encrypted(CommunityID)#" class="custom-anchor"><span id=${CurrencyID}>(${CurrencyName}) </span>#=(Balance).toFixed(2)#</a>' }
                ]

            }).data("kendoGrid");
        }

        //Initializes the date picker and sets it to readonly..
        function BindDatePicker() {
            $kendoJS("#dtpFromDate").kendoDatePicker({
                animation: {
                    close: {
                        effects: "fadeOut zoom:out",
                        duration: 300
                    },
                    open: {
                        effects: "fadeIn zoom:in",
                        duration: 300
                    }
                },
                format: 'dd/MM/yyyy'
            });

            $kendoJS("#dtpToDate").kendoDatePicker({
                animation: {
                    close: {
                        effects: "fadeOut zoom:out",
                        duration: 300
                    },
                    open: {
                        effects: "fadeIn zoom:in",
                        duration: 300
                    }
                },
                format: 'dd/MM/yyyy'
            });

            SetReadOnly("dtpFromDate");
            SetReadOnly("dtpToDate");
        }

        //This method enables edit mode.
        function ShowEdit() {
            $("#txtBank").val($("#lblBank").text());
            $("#txtAccountName").val($("#lblAccountName").text());
            $("#txtBSB").val($("#lblBSB").text());
            $("#txtAccountNumber").val($("#lblAccountNumber").text());

            $("#divLabel").hide();
            $("#divEdit").show();
        }

        //This method disables edit mode.
        function HideEdit() {
            $("#divLabel").show();
            $("#divEdit").hide();

            ClearValidation();
        }

        //This method checks for form validation, on success calls UpdateBankAccount() method.
        function UpdateBankDetail() {
            if ($("#frmRatingReviewEngine").valid()) {
                UpdateBankAccount();
            }
        }

        //Service call to update bank information.
        function UpdateBankAccount() {
            var postData = '{"Entity":"Supplier","EnitiyID":"' + $("#hdnSupplierId").val() + '","Bank":"' + $("#txtBank").val() + '","AccountName":"' + $("#txtAccountName").val() + '","BSB":"' + $("#txtBSB").val()
                + '","AccountNumber":"' + $("#txtAccountNumber").val() + '"}';

            PostRequest("UpdateBankAccount", postData, UpdateBankAccountSuccess, Failure, ErrorHandler);
            SuccessWindow('Bank Details', 'Updated successfully.', '#');
            HideEdit();
        }

        //On ajax call success, binds bank information to corresponding field.
        function UpdateBankAccountSuccess() {
            var param = '/' + $("#hdnSupplierId").val() + '/Supplier';
            GetResponse("GetBankingDetails", param, GetBankingDetailsSuccess, Failure, ErrorHandler);
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Account Detail', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Account Detail', response, '#');
        }

        //This method compares from & to date and returns a boolean value.
        function DateCompare(fDate, tDate) {
            var dateComponentsfrom = fDate.split("/");
            var fromdate = new Date(dateComponentsfrom[2], dateComponentsfrom[1] - 1, dateComponentsfrom[0]);
            var dateComponentsto = tDate.split("/");
            var todate = new Date(dateComponentsto[2], dateComponentsto[1] - 1, dateComponentsto[0]);
            if (fromdate > todate)
                return false;
            else
                return true;
        }

        //Service call to export data to csv or xml file.
        function DownloadTransactionHistory(exportType) {
            var communityGroupId;
            var fromDate;
            var toDate;
            communityGroupId = ($("#ddlCommunityGroup").val() == '' ? "0" : $("#ddlCommunityGroup").val());
            fromDate = ($("#dtpFromDate").val() == '' ? null : $("#dtpFromDate").val());
            toDate = ($("#dtpToDate").val() == '' ? null : $("#dtpToDate").val());
            communityId = $("#ddlCommunity").val() == '' ? "0" : $("#ddlCommunity").val();

            if (fromDate != null && toDate != null) {
                if (!DateCompare(fromDate, toDate)) {
                    $("#dtpFromDate").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                    $("#dateVadiation").text('From date cannot be greater than To date.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                    return;
                }
                else {
                    $("#dateVadiation").css('display', 'none');
                    $("#dtpFromDate").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                }
            }

            var postData = '{ "ExportType" : "' + exportType + '" ,  "SupplierID": "' + $("#hdnSupplierId").val() + '", "CommunityID": "' + communityId + '", "CommunityGroupID": "' + communityGroupId + '", "FromDate": "' + fromDate + '", "ToDate": "' + toDate + '", "RowIndex": "' + 0 + '", "RowCount": "' + pageSize + '"}';
            PostRequest("DownloadSupplierCommunityTransaction", postData, DownloadTransactionHistorySuccess, Failure, ErrorHandler);
        }

        //On ajax call success, file will be downloaded (.csv or .xml).
        function DownloadTransactionHistorySuccess(response) {
            var urlDownloadFile = $("#hdnFileUploadUrl").val() + 'DownloadFile/' + response;
            var myWin = window.open(urlDownloadFile, "_self");

            if (myWin == undefined)
                alert('Please disable your popup blocker to download the file.');
        }

        //Service call to fetch transaction information.
        function BindTransactionDetail(data) {

            $("#dateVadiation").css('display', 'none');
            $("#dtpFromDate").closest('.form-group').removeClass('form-group has-error').addClass('form-group');

            var communityGroupId;
            var fromDate;
            var toDate;

            if (data.id != "btnApply" && data.id != "btnMore") {
                communityId = data.id;
                pageCount = 1;
                pageSize = 10;
                totalRecords = 0;
                communityGroupId = 0;
                fromDate = null;
                toDate = null;
                $("#dtpFromDate").val('');
                $("#dtpToDate").val('');

                $kendoJS("#ddlCommunity").data("kendoDropDownList").value(communityId);
               // GetCommunityGroup();

            }
            else {
                if (data.id != "btnMore") {
                    pageSize = 10;
                    pageCount = 1;
                }
                communityGroupId = ($("#ddlCommunityGroup").val() == '' ? "0" : $("#ddlCommunityGroup").val());
                fromDate = ($("#dtpFromDate").val() == '' ? null : $("#dtpFromDate").val());
                toDate = ($("#dtpToDate").val() == '' ? null : $("#dtpToDate").val());
            }

            //GetCommunityGroup(communityId);
            communityId = $("#ddlCommunity").val() == '' ? "0" : $("#ddlCommunity").val();

            if (fromDate != null && toDate != null) {
                if (!DateCompare(fromDate, toDate)) {
                    $("#dtpFromDate").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                    $("#dateVadiation").text('From date cannot be greater than To date.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                    return;
                }
                else {
                    $("#dateVadiation").css('display', 'none');
                    $("#dtpFromDate").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                }
            }
            if (data.id == "btnMore") {
                pageCount = pageCount + 1;
                pageSize = pageCount * 10;
            }

            var postData = '{"SupplierID": "' + $("#hdnSupplierId").val() + '", "CommunityID": "' + communityId + '", "CommunityGroupID": "' + communityGroupId + '", "FromDate": "' + fromDate + '", "ToDate": "' + toDate + '", "RowIndex": "' + 0 + '", "RowCount": "' + pageSize + '"}';
            PostRequest("GetSupplierCommunityTransaction", postData, BindTransactionDetailSuccess, Failure, ErrorHandler);

        }

        //This method clears the form controls and makes a service call to bind transaction grid.
        function ClearFilter(ctl) {

            $("#dtpFromDate").val('');
            $("#dtpToDate").val('');

            $("#dateVadiation").css('display', 'none');
            $("#dtpFromDate").closest('.form-group').removeClass('form-group has-error').addClass('form-group');

            $kendoJS("#ddlCommunity").data("kendoDropDownList").value(0);

           // GetCommunityGroup();
            var postData = '{"SupplierID": "' + $("#hdnSupplierId").val() + '", "CommunityID": "' + 0 + '", "CommunityGroupID": "' + 0 + '", "FromDate": "' + null + '", "ToDate": "' + null + '", "RowIndex": "' + 0 + '", "RowCount": "' + 10 + '"}';
            PostRequest("GetSupplierCommunityTransaction", postData, BindTransactionDetailSuccess, Failure, ErrorHandler);
        }

        //Service call to fetch community information.
        function BindCommunity() {
            var param = '/' + $("#hdnSupplierId").val()
            GetResponse("CommunityListBySupplier", param, GetCommunityListSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the list to dropdown.
        function GetCommunityListSuccess(response) {
            $kendoJS("#ddlCommunity").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "CommunityID",
                index: 0,
                suggest: true,
                optionLabel: response.length == 0 ? null : "All",
                filter: "contains",
                change: GetCommunityGroup,
                dataSource: response.length == 0 ? [{ Name: "All", CommunityID: "0" }] : response
            });
        }

        //Service call to fetch community group information.
        function GetCommunityGroup() {
            var param = "/" + $("#hdnSupplierId").val() + "/" + ($("#ddlCommunity").val() == '' ? "0" : $("#ddlCommunity").val());
            GetResponse("GetAllSupplierCommunityGroupByCommunity", param, GetCommunityGroupListSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the list to dropdown.
        function GetCommunityGroupListSuccess(response) {

            $kendoJS("#ddlCommunityGroup").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "CommunityGroupID",
                index: 0,
                suggest: true,
                optionLabel: response.length == 0 ? null : "All",
                filter: "contains",
                dataSource: response.length == 0 ? [{ Name: "All", CommunityGroupID: "0" }] : response
            });

        }

        //Deletes unwanted columns from json response before export to file.
        function DeleteJsonColumns(response) {
            var dataSource = new kendo.data.DataSource({
                data: response
            })

            dataSource.read();
            var count = dataSource.total();
            for (var i = 0; i < count; i++) {
                delete response[i].CommunityGroupID;
                delete response[i].CommunityID;
                delete response[i].CustomerID;
                delete response[i].FromDate;
                delete response[i].SupplierCommunityTransactionHistoryID;
                delete response[i].SupplierID;
                delete response[i].ToDate;
                delete response[i].CurrencyID;
                delete response[i].RowIndex;
                delete response[i].RowCount;
                delete response[i].TotalRecords;
            }

            return response;
        }

        //On ajax call success, binds the data to grid.
        function BindTransactionDetailSuccess(response) {
            GetCommunityGroup();
            if (response.length > 0) {
                totalRecords = response[0].TotalRecords;
                $("#btnExport").removeAttr('disabled');
            }
            else {
                $("#btnExport").attr('disabled', '');
            }

            if (totalRecords <= pageSize)
                $("#btnMore").attr('disabled', '');
            else
                $("#btnMore").removeAttr('disabled');

            //To delete unwanted column from the json response object (Export to .csv)
            jsonResponse = DeleteJsonColumns(response);

            $("#divTransaction").removeClass('custom-hide');

            $kendoJS("#gvSupplierTransaction").kendoGrid({
                dataSource: {
                    data: response,
                    schema: { model: { fields: { DateApplied: { type: 'date' } } } }
                },
                columns: [
                    { field: "CommunityName", width: 150, title: "Community", template: '#= htmlEncode(CommunityName) #' },
                    { field: "CommunityGroupName", width: 150, title: "Community Group", template: '#= htmlEncode(CommunityGroupName) #' },
                    { field: "Description", width: 150, title: "Description", template: '#= htmlEncode(Description) #' },
                    { field: "CustomerName", width: 110, title: "Customer", template: '#= htmlEncode(CustomerName) #' },
                    { field: "DateApplied", width: 95, title: "Date", template: '#= DateAppliedString.substr(0,10) #' },
                    { field: "Amount", width: 125, title: "Amount", template: '<span>(${CurrencyName}) </span>#=(Amount).toFixed(2)#' },
                    { field: "Balance", width: 125, title: "Balance", template: '<span>(${CurrencyName}) </span>#=(Balance).toFixed(2)#' }
                ],

                dataBound: function () {
                    //Get the number of Columns in the grid
                    var colCount = $("#gvSupplierTransaction").find('colgroup > col').length;

                    //If There are no results place an indicator row
                    if (response.length == 0) {
                        $("#gvSupplierTransaction").find('tbody')
                            .append('<tr class="kendo-data-row"><td colspan="' +
                                colCount +
                                '" style="text-align:right;color: #a5a5a5;">No items to display</td></tr>');
                    }

                    //Get visible row count
                    var rowCount = $("#gvSupplierTransaction").find('tbody tr').length;

                },
                pageable: false,
                scrollable: false
            }).data("kendoGrid");
        }

        //This method calls DownloadTransactionHistory() method (csv).
        function ExportToCSV(data) {
            DownloadTransactionHistory("csv");
        }

        //This method calls DownloadTransactionHistory() method (xml).
        function ExportToXML(data) {
            DownloadTransactionHistory("xml");
        }
    </script>

</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Where do you want your money to go?</h2>
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <hr />
            <div class="col-md-4"></div>
            <div id="divLabel" class="col-md-4">
                <div class="form-group">
                    <div>
                        <label class="custom-supplieracc-lable">Bank</label>
                    </div>
                    <div>
                        <label id="lblBank" class="custom-supplieracc-lable-content"></label>
                    </div>
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-supplieracc-lable">Account Name</label>
                    </div>
                    <div>
                        <label id="lblAccountName" class="custom-supplieracc-lable-content"></label>
                    </div>
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-supplieracc-lable">BSB</label>
                    </div>
                    <div>
                        <label id="lblBSB" class="custom-supplieracc-lable-content"></label>
                    </div>
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-supplieracc-lable">Account Number</label>
                    </div>
                    <div>
                        <label id="lblAccountNumber" class="custom-supplieracc-lable-content"></label>
                    </div>
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-supplieracc-lable">Auto-Transfer Amount</label>
                    </div>
                    <div>
                        <label id="lblAmount" class="custom-supplieracc-lable-content"></label>
                    </div>
                </div>
                <div class="form-group">
                    <input type="button" id="btnEdit" value="Edit" name="btnEdit" class="btn btn-block btn-lg btn-primary" onclick="ShowEdit()" />
                </div>
            </div>
            <div id="divEdit" class="col-md-4" style="display: none">
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">Bank</label>
                    </div>
                    <input type="text" id="txtBank" class="form-control" placeholder="Bank" name="txtBank" maxlength="50" />
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">Account Name</label>
                    </div>
                    <input type="text" id="txtAccountName" class="form-control" placeholder="Account Name" name="txtAccountName" maxlength="50" />
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">BSB</label>
                    </div>
                    <input type="text" id="txtBSB" class="form-control" placeholder="BSB" name="txtBSB" maxlength="10" />
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">Account Number</label>
                    </div>
                    <input type="text" id="txtAccountNumber" class="form-control" placeholder="Account Number" name="txtAccountNumber" maxlength="20" />
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">Auto-Transfer Amount</label>
                    </div>
                    <input type="text" id="txtAmount" class="form-control" placeholder="Auto-Transfer Amount" name="txtAmount" />
                </div>
                <div class="form-group">
                    <input type="button" id="btnSave" value="Save" name="btnSave" class="btn btn-block btn-lg btn-info" onclick="UpdateBankDetail()" />
                    <input type="button" id="btnCancel" value="Cancel" name="btnCancel" class="btn btn-block btn-lg btn-default" onclick="HideEdit()" />
                </div>
            </div>
            <div class="col-md-4"></div>
        </div>
        <div class="col-md-12">
            <hr />
            <h4>Credit Summary</h4>
            <div id="gvCreditSummary" style="margin-bottom: 10px;"></div>
            <div>
                <!-- id is set as 0. This 0 will be passed as community id wile binding tranasaction details. -->
                <a class="custom-anchor" id="0" onclick="BindTransactionDetail(this)">All Transactions</a>
            </div>
        </div>
        <div class="col-md-12 custom-hide" id="divTransaction">
            <hr />
            <h4>Transactions</h4>
            <div class="col-md-12 custom-default-bottom-margin">
                <div class="custom-supplieracc-col-md-3">
                    <label>Community</label>
                </div>
                <div class="custom-supplieracc-col-md-4">
                    <div id="ddlCommunity" class="custom-dropdown-width"></div>
                </div>
            </div>
            <div class="col-md-12 custom-default-bottom-margin">
                <div class="custom-supplieracc-col-md-3">
                    <label>Community Group</label>
                </div>
                <div class="custom-supplieracc-col-md-4">
                    <div id="ddlCommunityGroup" class="custom-dropdown-width"></div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="custom-supplieracc-col-md-3">
                    <label>Filter transactions between</label>
                </div>
                <div class="col-md-2">
                    <input id="dtpFromDate" />
                </div>
                <div class="custom-supplieracc-col-md-1">
                    <label>and</label>
                </div>
                <div class="col-md-2">
                    <input id="dtpToDate" />
                </div>
                <div class="col-md-2" style="margin-left: 2%;">
                    <input type="button" id="btnApply" value="Apply" name="btnApply" class="btn btn-block btn-lg btn-info" onclick="BindTransactionDetail(this);" />
                </div>
                <div class="col-md-2">
                    <input type="button" id="btnClear" value="Clear" name="btnClear" class="btn btn-block btn-lg btn-default" onclick="ClearFilter(this)" />
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-2">
                </div>
                <div class="col-md-10">
                    <span id="dateVadiation" class="custom-supplierdashboard-email-validation-off custom-supplieracc-date-validation"></span>
                </div>
            </div>
            <div class="col-md-12 custom-default-top-margin">
                <div id="gvSupplierTransaction"></div>
            </div>
            <div class="col-md-12 custom-default-top-margin">
                <div class="col-md-5"></div>
                <div class="col-md-2">
                    <input type="button" id="btnMore" value="More" name="btnMore" class="btn btn-block btn-lg btn-primary" onclick="BindTransactionDetail(this)" />
                </div>
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <input type="button" id="btnExport" value="Export" name="btnExport" class="btn btn-block btn-lg btn-info" data-target="#myModal" data-toggle="modal" />
                    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header" style="background-color: #428BCA; color: white;">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 class="modal-title" id="myModalLabel">Manage Supplier Accounts</h4>
                                </div>
                                <div class="modal-body">
                                    Please choose a file option to export.
                                </div>
                                <div class="modal-footer">
                                    <a class="btn btn-warning" id="csv" onclick="ExportToCSV(this)">Export to csv</a>
                                    <a class="btn btn-success" id="xml" onclick="ExportToXML(this)">Export to xml</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
