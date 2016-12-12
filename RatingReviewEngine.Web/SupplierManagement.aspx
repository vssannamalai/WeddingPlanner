<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="SupplierManagement.aspx.cs" Inherits="RatingReviewEngine.Web.SupplierManagement" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>
<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
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
            min-width: 374px;
        }

            .k-list-container .k-list .k-item {
                white-space: nowrap;
            }

        @media only screen and (min-width: 768px) and (max-width: 1024px) {

            .k-list-container {
                width: auto !important;
                min-width: 313px;
            }
        }

        #ddlCommunity-list ul {
            overflow-x: hidden !important;
        }
    </style>

    <script type="text/javascript">
        var pageCount = 1;
        var pageSize = 10;
        var totalRecords = 0;
        var communityId;
        var categoryId;

        $(document).ready(function () {
            RegisterKeypressOnLoad();
            BindOwnerCommunity();
            BindCommunityGroup(null);
            BindSupplierCategory();
        });

        //Registers a keypress event on page load.
        function RegisterKeypressOnLoad() {
            $(document).keypress(function (event) {
                var keycode = (event.keyCode ? event.keyCode : event.which);
                if (keycode == '13') {
                    Search(this);
                }
            });
        }

        //Service call to community detail based on owner id.
        function BindOwnerCommunity() {
            var param = "/" + $("#hdnCommunityOwnerId").val();
            GetResponse("GetCommunityListByOwner", param, GetCommunityListSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the detail to community dropdown and call getCommunityGroup() method.
        function GetCommunityListSuccess(response) {
            $kendoJS("#ddlCommunity").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "CommunityID",
                index: 0,
                suggest: true,
                optionLabel: response.length == 0 ? null : "All",
                filter: "contains",
                dataSource: response.length == 0 ? [{ CommunityID: "", Name: "All" }] : response,
                change: getCommunityGroup
            });

            communityId = GetQueryStringParams('cid') == undefined ? "0" : GetQueryStringParams('cid');
            $kendoJS("#ddlCommunity").data("kendoDropDownList").value(communityId);

            if (communityId > 0) {
                getCommunityGroup();
            }

            ////if (categoryId > 0 && communityId > 0) {
            ////    Search("");
            ////}

            pageSize = 10;
            var supplierName = encodeURIComponent(($("#txtSupplierName").val() == '' ? 'nullstring' : $("#txtSupplierName").val().replace(/\*/g, '%')));
            var groupId = GetQueryStringParams('gid') == undefined ? "0" : GetQueryStringParams('gid');
            categoryId = GetQueryStringParams('cat') == undefined ? "0" : GetQueryStringParams('cat');
            var postData = '{"SearchText": "' + supplierName + '", "OwnerId": "' + $("#hdnCommunityOwnerId").val() + '", "CommunityId": "' + communityId + '", "CommunityGroupId": "' + groupId + '", "CategoryId": "' + categoryId + '", "RowIndex": "' + 0 + '", "RowCount": "' + pageSize + '"}';
            PostRequest("FindSupplierTransaction", postData, SearchSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the detail to community group dropdown.
        function BindCommunityGroup(response) {
            $kendoJS("#ddlCommunityGroup").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "CommunityGroupID",
                index: 0,
                suggest: true,
                optionLabel: response == null ? null : "All",
                filter: "contains",
                dataSource: response == null ? [{ Name: "All", CommunityGroupID: "0" }] : response
            });

            var communityGroupId = GetQueryStringParams('gid') == undefined ? "0" : GetQueryStringParams('gid');
            $kendoJS("#ddlCommunityGroup").data("kendoDropDownList").value(communityGroupId);
        }

        //Initializes supplier category dropdown with static values on load.
        function BindSupplierCategory() {
            $kendoJS("#ddlSupplierCategory").kendoDropDownList({
                dataTextField: "text",
                dataValueField: "value",
                index: 0,
                suggest: true,
                filter: "contains",
                dataSource: [
                    { text: "All", value: "0" },
                    { text: "In Credit", value: "1" },
                    { text: "Out of Credit", value: "2" },
                    { text: "Below 'Min Credit'", value: "3" }
                ]
            });

            categoryId = GetQueryStringParams('cat') == undefined ? "0" : GetQueryStringParams('cat');
            $kendoJS("#ddlSupplierCategory").data("kendoDropDownList").value(categoryId);
        }

        //Service call to fetch community group list based on selected community value.
        function getCommunityGroup() {
            var param = "/" + ($("#ddlCommunity").val() == '' ? "0" : $("#ddlCommunity").val());
            GetResponse("GetCommunityGroupListByCommunity", param, GetCommunityGroupListSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, BindCommunityGroup() method is called.
        function GetCommunityGroupListSuccess(response) {
            BindCommunityGroup(response);
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Supplier Management', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Supplier Management', response, '#');
        }

        //Service call to seach.
        function Search(data) {
            if (data.id != "btnShowMore") {
                pageSize = 10;
                totalRecords = 0;
            }
            else {
                pageCount = pageCount + 1;
                pageSize = pageCount * pageSize;
            }

            var supplierName = encodeURIComponent(($("#txtSupplierName").val() == '' ? 'nullstring' : $("#txtSupplierName").val().replace(/\*/g, '%')));
            var postData = '{"SearchText": "' + supplierName + '", "OwnerId": "' + $("#hdnCommunityOwnerId").val() + '", "CommunityId": "' + ($("#ddlCommunity").val() == '' ? "0" : $("#ddlCommunity").val()) + '", "CommunityGroupId": "' + ($("#ddlCommunityGroup").val() == '' ? "0" : $("#ddlCommunityGroup").val()) + '", "CategoryId": "' + ($("#ddlSupplierCategory").val() == '' ? "0" : $("#ddlSupplierCategory").val()) + '", "RowIndex": "' + 0 + '", "RowCount": "' + pageSize + '"}';
            PostRequest("FindSupplierTransaction", postData, SearchSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the values to grid.
        function SearchSuccess(response) {
            if (response.length > 0) {
                totalRecords = response[0].TotalRecords;
                $("#btnShowMore").removeClass("custom-hide");
            }
            else {
                $("#btnShowMore").addClass("custom-hide");
            }

            if (totalRecords <= pageSize)
                $("#btnShowMore").attr('disabled', '');
            else
                $("#btnShowMore").removeAttr('disabled');

            var grid = $kendoJS("#gvSupplierDetails").data("kendoGrid");
            if (grid != null)
                grid.destroy();

            $kendoJS("#gvSupplierDetails").kendoGrid({
                dataSource: {
                    data: response,
                    serverPaging: true,
                    serverSorting: true
                },
                pageable: false,
                scrollable: false,
                columns: [
                    { field: "SupplierName", width: 300, title: "Supplier Name", template: '<a id="#=SupplierID#" class="custom-anchor" href="SupplierSnapshot.aspx?sid=#=Encrypted(SupplierID)#">${SupplierName}</a>' },
                    { field: "AverageRating", width: 200, title: "Avg Rating", template: '<a class="custom-anchor" href="SupplierReviews.aspx?oid=' + Encrypted($("#hdnCommunityOwnerId").val()) + '&sid=#=Encrypted(SupplierID)#">#= AverageRating.toFixed(1)# Star(s) from ${ReviewCount} Review(s)</a>' },
                    { field: "TotalRevenue", width: 190, title: "Total Revenue", template: '<span>(${CurrencyName}) #=(TotalRevenue).toFixed(2)#</span>' },
                    { field: "TotalIncome", width: 190, title: "Total Income", template: '<span>(${CurrencyName}) #=(TotalIncome).toFixed(2)#</span>' }],
                detailInit: CommunityInit,
                dataBound: function () {
                    this.expandRow(this.tbody.find("tr.k-master-row").first());
                    //Get the number of Columns in the grid
                    var colCount = $("#gvSupplierDetails").find('colgroup > col').length;

                    //If There are no results place an indicator row
                    if (response.length == 0) {
                        $("#gvSupplierDetails").find('tbody')
                            .append('<tr class="kendo-data-row"><td colspan="' +
                                colCount +
                                '" style="text-align:right;color: #a5a5a5;">No items to display</td></tr>');
                    }

                    //Get visible row count
                    var rowCount = $("#gvSupplierDetails").find('tbody tr').length;
                },
            }).data("kendoGrid");
        }

        function CommunityInit(e) {

            $kendoJS("<div/>").appendTo(e.detailCell).kendoGrid({
                dataSource: {
                    data: e.data.lstSupplierCommunityTransaction,
                    filter: { field: "SupplierID", operator: "eq", value: e.data.SupplierID }
                },
                scrollable: false,
                pageable: false,

                columns: [
                    { field: "CommunityName", width: 300, title: "Community" },                         ////headerAttributes: { style: "display: none;" } -  To hide individual column header.
                    { field: "Credit", width: 180, title: "Credit", template: 'Credit: (${CurrencyName}) #=(Credit).toFixed(2)#' },
                    { field: "TotalRevenue", width: 178, title: "Total Revenue", template: 'Total Revenue: (${CurrencyName}) #=(TotalRevenue).toFixed(2)#' },
                    { field: "TotalIncome", width: 178, title: "Total Income", template: 'Total Income: (${CurrencyName}) #=(TotalIncome).toFixed(2)#' }
                ],
                detailInit: CommunityGroupInit,
                dataBound: function () {
                    this.expandRow(this.tbody.find("tr.k-master-row").first());
                },
            });
            //var childGrid = $(e.detailRow).find(".k-grid").data("kendoGrid");
            //childGrid.dataSource.read();
            $(".k-grid tbody .k-grid .k-grid-header").hide();
        }

        function CommunityGroupInit(e) {
            $kendoJS("<div/>").appendTo(e.detailCell).kendoGrid({
                dataSource: {
                    data: e.data.lstSupplierCommunityGroupTransaction
                },
                scrollable: false,
                pageable: false,
                columns: [
                    { field: "CommunityGroupName", width: 200, title: "Community Group" },
                    { field: "ReviewCount", width: 150, title: "# R & R: Count", template: '<a class="custom-anchor" href="SupplierReviews.aspx?oid=' + Encrypted($("#hdnCommunityOwnerId").val()) + '&cid=#=Encrypted(CommunityID)#&gid=#=Encrypted(CommunityGroupID)#&sid=#=Encrypted(SupplierID)#">#= AverageRating.toFixed(1)# Star(s) from ${ReviewCount} Review(s)</a>' },
                    { field: "ViewsCount", width: 100, title: "Customer Views", template: '\\# Views: ${ViewsCount}' },
                    { field: "TotalRevenue", width: 120, title: "Transaction", template: '\\# Transactions: ${TotalTransaction}' },
                    { field: "TotalIncome", width: 150, title: "Total", template: 'Total: (${CurrencyName}) #=(TotalIncome).toFixed(2)#' }
                ]
            });
            $(".k-grid tbody .k-grid .k-grid-header").hide();
        }

        function SetCommunityIdZero() {
            communityId = 0;
        }
    </script>
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Supplier Management</h2>
    <div class="row">
        <div class="col-md-12">
            <div class="form-horizontal" role="form">
                <hr />
                <div class="col-md-4"></div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Supplier Name</label>
                        </div>
                        <input type="text" id="txtSupplierName" class="form-control" placeholder="Supplier Name" name="txtSupplierName" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Community</label>
                        </div>
                        <input id="ddlCommunity" name="ddlCommunity" data-role="dropdownlist" onchange="SetCommunityIdZero()" class="custom-dropdown-width" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Community Group</label>
                        </div>
                        <input id="ddlCommunityGroup" name="ddlCommunityGroup" data-role="dropdownlist" class="custom-dropdown-width" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Supplier Categories</label>
                        </div>
                        <input id="ddlSupplierCategory" name="ddlSupplierCategory" data-role="dropdownlist" class="custom-dropdown-width" />
                    </div>
                    <div class="form-group">
                        <input type="button" id="btnSearch" value="Search" name="btnSearch" class="btn btn-block btn-lg btn-primary" onclick="Search(this)" />
                    </div>
                </div>
                <div class="col-md-4"></div>
            </div>
            <div class="col-md-12">
                <div id="gvSupplierDetails"></div>
            </div>
            <div class="col-md-12 custom-default-top-margin">
                <div class="col-md-5"></div>
                <div class="col-md-2">
                    <input type="button" id="btnShowMore" value="Show More" name="btnShowMore" class="btn btn-block btn-lg btn-primary custom-hide" onclick="Search(this)" />
                </div>
                <div class="col-md-5"></div>
            </div>
        </div>
    </div>
</asp:Content>
