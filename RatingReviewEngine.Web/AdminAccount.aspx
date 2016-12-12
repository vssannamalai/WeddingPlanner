<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="AdminAccount.aspx.cs" Inherits="RatingReviewEngine.Web.AdminAccount" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">

    <style>
        .k-header {
            color: White;
            background-color: #34495E;
            font-size: 16px;
        }

        body {
            font-size: 14px !important;
        }

        .k-reset {
            font-size: 100% !important;
        }

        .k-list-container {
            width: auto !important;
            min-width: 391px;
        }

        @media only screen and (min-width: 768px) and (max-width: 1195px) {

            .k-list-container {
                width: auto !important;
                min-width: 320px;
            }

            .custom-transhistory-span-padding {
                padding: 0 38px;
            }

            .custom-transhistory-col-md-1 {
                margin-left: 4%;
            }
        }

        #ddlOwner-list ul {
            overflow-x: hidden !important;
        }
    </style>

    <script type="text/javascript">
        var ownerId = 0;
        var jsonResponse;
        var pageCount = 1;
        var pageSize = 10;
        var totalRecords = 0;
        var currencyid = 0;

        $(document).ready(function () {
            BindOwner();
            BindAccountSummary();
            BindDatePickers();
        });

        //Service call to fetch owner information.
        function BindOwner() {
            GetResponse("GetAllOwner", "", GetOwnerListSuccess, Failure, ErrorHandler);
        }

        //Service call to fetch owner currency
        function BindOwnerCurrency() {
            var param = "/" + ($("#ddlOwner").val() == "" ? "0" : $("#ddlOwner").val());
            GetResponse("OwnerCurrencyList", param, GetOwnerCurrencySuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the list to dropdown.
        function GetOwnerListSuccess(response) {
            $kendoJS("#ddlOwner").kendoDropDownList({
                dataTextField: "CompanyName",
                dataValueField: "OwnerID",
                index: 0,
                suggest: true,
                optionLabel: response.length == 0 ? null : "All",
                filter: "contains",
                dataSource: response.length == 0 ? [{ CompanyName: "All", OwnerID: "0" }] : response
            });
        }

        //On ajax call success, binds the list to dropdown.
        function GetOwnerCurrencySuccess(response) {
            $kendoJS("#ddlCurrency").kendoDropDownList({
                dataTextField: "ISOCode",
                dataValueField: "CurrencyID",
                index: 0,
                suggest: true,
                optionLabel: response.length == 0 ? null : "All",
                filter: "contains",
                dataSource: response.length == 0 ? [{ ISOCode: "All", CurrencyID: "0" }] : response
            });

            $kendoJS("#ddlCurrency").data("kendoDropDownList").value(currencyid);
        }

        //Service call to fetch admin account summary .
        function BindAccountSummary() {
            GetResponse("GetAdminTrasactionSummary", "", GetAdminAccountSummarySuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the values to the grid.
        function GetAdminAccountSummarySuccess(response) {
            $kendoJS("#gvAccountSummary").kendoGrid({
                dataSource: {
                    pageSize: 10,
                    data: response
                },
                pageable: true,
                scrollable: false,
                columns: [
                    { field: "OwnerName", title: "Owner", template: '<a id="#=OwnerID#" class="custom-anchor" onclick="BindTransactionDetail(this,${CurrencyID})">${OwnerName}</a>' },
                    { field: "Balance", title: "Current Account Balance", template: '<a id="#=CommunityID#" class="custom-anchor"><span id=${CurrencyID}>(${CurrencyName}) </span>#=(Balance).toFixed(2)#</a>' }
                ]
            }).data("kendoGrid");
        }

        //Service call to fetch transaction information. 
        function BindTransactionDetail(data, cur) {
            $("#dateVadiation").css('display', 'none');
            $("#dtpFromDate").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
            var ownerId;
            var fromDate;
            var toDate;

            if (data.id != "btnApply" && data.id != "btnMore") {
                ownerId = data.id;
                pageSize = 10;
                totalRecords = 0;
                communityGroupId = 0;
                fromDate = null;
                toDate = null;
                $("#dtpFromDate").val('');
                $("#dtpToDate").val('');

                $kendoJS("#ddlOwner").data("kendoDropDownList").value(ownerId);
                currencyid = cur;
            }
            else {
                if (data.id != "btnMore") {
                    pageSize = 10;
                    pageCount = 1;
                }
                ownerId = ($("#ddlOwner").val() == '' ? "0" : $("#ddlOwner").val());
                currencyid = ($("#ddlCurrency").val() == '' ? "0" : $("#ddlCurrency").val());
                fromDate = ($("#dtpFromDate").val() == '' ? null : $("#dtpFromDate").val());
                toDate = ($("#dtpToDate").val() == '' ? null : $("#dtpToDate").val());
            }

            // communityId = $("#ddlCommunity").val() == '' ? "0" : $("#ddlCommunity").val();
            // GetCommunityGroup(communityId);
          //  BindOwnerCurrency();

            if (fromDate != null && toDate != null) {
                if (!DateCompare(fromDate, toDate)) {
                    $("#dtpFromDate").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                    $("#dateVadiation").text('From date cannot be greater than To date.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                    return
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

            var postData = '{"OwnerID": "' + ownerId + '","CurrencyID":"' + currencyid + '", "FromDate": "' + fromDate + '", "ToDate": "' + toDate + '", "RowIndex": "' + 0 + '", "RowCount": "' + pageSize + '"}';
            PostRequest("GetAdminTransaction", postData, BindTransactionDetailSuccess, Failure, ErrorHandler);
        }

        //This method clears the form controls and makes a service call to bind transaction grid.
        function ClearFilter(ctl) {
            $("#dtpFromDate").val('');
            $("#dtpToDate").val('');

            $("#dateVadiation").css('display', 'none');
            $("#dtpFromDate").closest('.form-group').removeClass('form-group has-error').addClass('form-group');

            $kendoJS("#ddlOwner").data("kendoDropDownList").value(0);
            var ownerId = 0;
            currencyid = 0;
            //GetCommunityGroup();
           // BindOwnerCurrency();


            var postData = '{"OwnerID": "' + ownerId + '","CurrencyID":"' + currencyid + '", "FromDate": "' + null + '", "ToDate": "' + null + '", "RowIndex": "' + 0 + '", "RowCount": "' + pageSize + '"}';
            PostRequest("GetAdminTransaction", postData, BindTransactionDetailSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the data to grid.
        function BindTransactionDetailSuccess(response) {
            BindOwnerCurrency();
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
                    { field: "OwnerName", width: 120, title: "Owner", template: '#= htmlEncode(OwnerName) #' },
                    { field: "CommunityName", width: 120, title: "Community", template: '#= htmlEncode(CommunityName) #' },
                    { field: "CommunityGroupName", width: 120, title: "Community Group", template: '#= htmlEncode(CommunityGroupName) #' },
                    { field: "Description", width: 120, title: "Description", template: '#= htmlEncode(Description) #' },
                    { field: "SupplierName", width: 100, title: "Supplier", template: '#= htmlEncode(SupplierName) #' },
                    { field: "CustomerName", width: 100, title: "Customer", template: '#= htmlEncode(CustomerName) #' },
                    { field: "DateApplied", width: 100, title: "Date", template: '#= DateAppliedString.substr(0,10) #' },
                    { field: "Amount", width: 120, title: "Transaction Amount", template: '<span>(${CurrencyName}) #=(Amount).toFixed(2)#</span>' }
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

        //Initializes the date picker on load for "From" and "To" date controls.
        function BindDatePickers() {
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

        //This method compares from and to date and returns a boolean value.
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
            $("#dateVadiation").css('display', 'none');
            $("#dtpFromDate").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
            var communityGroupId;
            var fromDate;
            var toDate;

            fromDate = ($("#dtpFromDate").val() == '' ? null : $("#dtpFromDate").val());
            toDate = ($("#dtpToDate").val() == '' ? null : $("#dtpToDate").val());

            if (fromDate != null && toDate != null) {
                if (!DateCompare(fromDate, toDate)) {
                    $("#dtpFromDate").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                    $("#dateVadiation").text('From date cannot be greater than To date.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                    return
                }
                else {
                    $("#dateVadiation").css('display', 'none');
                    $("#dtpFromDate").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                }
            }

            var ownerId = ($("#ddlOwner").val() == '' ? "0" : $("#ddlOwner").val());
            var postData = '{"ExportType" : "' + exportType + '","OwnerID": "' + ownerId + '","CurrencyID":"' + currencyid + '", "FromDate": "' + fromDate + '", "ToDate": "' + toDate + '", "RowIndex": "' + 0 + '", "RowCount": "' + pageSize + '"}';
            PostRequest("DownloadAdminTransaction", postData, DownloadTransactionHistorySuccess, Failure, ErrorHandler);
        }

        //On ajax call success, file will be downloaded (.csv or .xml).
        function DownloadTransactionHistorySuccess(response) {
            var urlDownloadFile = $("#hdnFileUploadUrl").val() + 'DownloadFile/' + response;
            var myWin = window.open(urlDownloadFile, "_self");

            if (myWin == undefined) {
                BootstrapDialog.show({
                    title: 'Account Detail',
                    message: 'Please disable your popup blocker to download the file.',
                    buttons: [{
                        label: 'Ok',
                        cssClass: 'btn-info',
                        action: function (dialog) {
                            dialog.close();
                        }
                    }],
                    type: BootstrapDialog.TYPE_INFO
                });
            }
        }

        //This method deletes unwanted columns from json response.
        function DeleteJsonColumns(response) {

            var dataSource = new kendo.data.DataSource({
                data: response
            })

            dataSource.read();
            var count = dataSource.total();
            for (var i = 0; i < count; i++) {
                delete response[i].CommunityGroupID;
                delete response[i].CommunityID;
                delete response[i].CommunityOwnerTransactionHistoryID;
                delete response[i].CurrencyID;
                delete response[i].FromDate;
                delete response[i].OwnerID;
                delete response[i].ToDate;
                delete response[i].Balance;
                delete response[i].RowIndex;
                delete response[i].RowCount;
                delete response[i].TotalRecords;
            }

            return response;
        }

        //This method calls DownloadTransactionHistory() method (csv).
        function ExportToCSV(data) {
            DownloadTransactionHistory("csv");
        }

        //This method calls DownloadTransactionHistory() method (xml).
        function ExportToXML(data) {
            DownloadTransactionHistory("xml");
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
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Account Summary</h2>
    <div class="row">
        <div class="col-md-12">
            <hr />
            <h4>Account Summary</h4>
            <div id="gvAccountSummary" class="custom-transhistory-grid-bottom-margin"></div>
            <div>
                <a class="custom-anchor" id="0" onclick="BindTransactionDetail(this,0)">All Transactions</a>
            </div>
        </div>
        <div class="col-md-12 custom-hide" id="divTransaction">
            <hr />
            <h4>Transactions</h4>
            <div class="col-md-12 custom-default-bottom-margin">
                <div class="custom-transhistory-col-md-3">
                    <label>Owner</label>
                </div>
                <div class="custom-transhistory-col-md-4">
                    <div id="ddlOwner" class="custom-dropdown-width"></div>
                </div>
            </div>

            <div class="col-md-12 custom-default-bottom-margin">
                <div class="custom-transhistory-col-md-3">
                    <label>Currency</label>
                </div>
                <div class="custom-transhistory-col-md-4">
                    <div id="ddlCurrency" class="custom-dropdown-width"></div>
                </div>
            </div>

            <div class="col-md-12">
                <div class="custom-transhistory-col-md-3">
                    <label>Filter transactions between</label>
                </div>
                <div class="col-md-2">
                    <input id="dtpFromDate" />
                </div>
                <div class="custom-transhistory-col-md-1">
                    <label>and</label>
                </div>
                <div class="col-md-2">
                    <input id="dtpToDate" />
                </div>
                <div class="col-md-2 custom-transhistory-apply-button">
                    <input type="button" id="btnApply" value="Apply" name="btnApply" class="btn btn-block btn-lg btn-info" onclick="BindTransactionDetail(this, 0)" />
                </div>
                <div class="col-md-2">
                    <input type="button" id="btnClear" value="Clear" name="btnClear" class="btn btn-block btn-lg btn-default" onclick="ClearFilter(this, 0)" />
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-2">
                </div>
                <div class="col-md-10">
                    <span id="dateVadiation" class="custom-supplierdashboard-email-validation-off custom-transhistory-span-padding"></span>
                </div>
            </div>
            <div class="col-md-12 custom-default-top-margin">
                <div id="gvSupplierTransaction"></div>
            </div>
            <div class="col-md-12 custom-default-top-margin">
                <div class="col-md-5"></div>
                <div class="col-md-2">
                    <input type="button" id="btnMore" value="More" name="btnMore" class="btn btn-block btn-lg btn-primary" onclick="BindTransactionDetail(this, 0)" />
                </div>
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <input type="button" id="btnExport" value="Export" name="btnExport" class="btn btn-block btn-lg btn-info" data-target="#myModal" data-toggle="modal" />
                    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header custom-transhistory-modalpopup-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                    <h4 class="modal-title" id="myModalLabel">Manage Community Owner Account</h4>
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
