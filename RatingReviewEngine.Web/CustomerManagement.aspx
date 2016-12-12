<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="CustomerManagement.aspx.cs" Inherits="RatingReviewEngine.Web.CustomerManagement" %>

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

        $(document).ready(function () {
            RegisterKeypressOnLoad();
            BindOwnerCommunity();
            BindCommunityGroup(null);
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

        //This method binds the response data to dropdown.
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
            if (communityGroupId > 0) {
                Search("");
            }
        }

        //Service call to fetch community list based on owner id.
        function BindOwnerCommunity() {
            var param = "/" + $("#hdnCommunityOwnerId").val();
            GetResponse("GetCommunityListByOwner", param, GetCommunityListSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the data to dropdown and calls getCommunityGroup() & Search() methods.
        function GetCommunityListSuccess(response) {
            $kendoJS("#ddlCommunity").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "CommunityID",
                index: 0,
                suggest: true,
                optionLabel: "All",
                filter: "contains",
                dataSource: response,
                change: getCommunityGroup
            });

            communityId = GetQueryStringParams('cid') == undefined ? "0" : GetQueryStringParams('cid');
            $kendoJS("#ddlCommunity").data("kendoDropDownList").value(communityId);
            if (communityId > 0) {
                getCommunityGroup();
                Search("");
            }
        }

        //Service call to fetch community group list based on community id.
        function getCommunityGroup() {
            var param = "/" + ($("#ddlCommunity").val() == '' ? "0" : $("#ddlCommunity").val());
            GetResponse("GetCommunityGroupListByCommunity", param, GetCommunityGroupListSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, calls BindCommunityGroup() method.
        function GetCommunityGroupListSuccess(response) {
            BindCommunityGroup(response);
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Customer Management', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {         
            //Show error message in a user friendly window
            ErrorWindow('Customer Management', response, '#');
        }

        //Service call to search customer transaction based on filter value.
        function Search(data) {
            if (data.id != "btnShowMore") {
                pageSize = 10;
                totalRecords = 0;
            }
            else {
                pageCount = pageCount + 1;
                pageSize = pageCount * pageSize;
            }

            //var param = "/" + ($("#txtNameHandle").val() == '' ? 'nullstring' : $("#txtNameHandle").val()) + "/" + $("#hdnCommunityOwnerId").val() + "/" + ($("#ddlCommunity").val() == '' ? "0" : $("#ddlCommunity").val()) + "/" + ($("#ddlCommunityGroup").val() == '' ? "0" : $("#ddlCommunityGroup").val()) + "/" + 0 + "/" + pageSize;
            //GetResponse("FindCustomerTransaction", param, SearchSuccess, Failure, ErrorHandler);

            var Name = encodeURIComponent(($("#txtNameHandle").val() == '' ? 'nullstring' : $("#txtNameHandle").val()));
            var postData = '{"SearchText": "' + Name + '", "OwnerId": "' + $("#hdnCommunityOwnerId").val() + '", "CommunityId": "' + (communityId > 0 ? communityId : ($("#ddlCommunity").val() == '' ? "0" : $("#ddlCommunity").val())) + '", "CommunityGroupId": "' + ($("#ddlCommunityGroup").val() == '' ? "0" : $("#ddlCommunityGroup").val()) + '", "RowIndex": "' + 0 + '", "RowCount": "' + pageSize + '"}';
            PostRequest("FindCustomerTransaction", postData, SearchSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the data to grid.
        function SearchSuccess(response) {
            if (response.length > 0) {
                totalRecords = response[0].TotalRecords;
            }

            if (totalRecords <= pageSize)
                $("#btnShowMore").attr('disabled', '');
            else
                $("#btnShowMore").removeAttr('disabled');

            var grid = $kendoJS("#gvCustomerDetails").data("kendoGrid");
            if (grid != null)
                grid.destroy();

            $kendoJS("#gvCustomerDetails").kendoGrid({
                dataSource: {
                    data: response,
                    serverPaging: true,
                    serverSorting: true
                },
                pageable: false,
                scrollable: false,
                columns: [
                    { field: "FirstName", title: "Customer Name", template: '<span>${FirstName} ${LastName}</span>' },
                    { field: "Handle", title: "Customer Handle" },
                    { field: "TotalRevenue", title: "Total Revenue", template: '<span>(${CurrencyName}) #=(TotalRevenue).toFixed(2)#</span>' },
                    { field: "TotalSpend", title: "Total Spend", template: '<span>(${CurrencyName}) #=(TotalSpend).toFixed(2)#</span>' }],
                detailInit: CommunityInit,
                dataBound: function () {
                    this.expandRow(this.tbody.find("tr.k-master-row").first());
                },
            }).data("kendoGrid");
        }

        //Binds child grid.
        function CommunityInit(e) {
            $kendoJS("<div/>").appendTo(e.detailCell).kendoGrid({
                dataSource: {
                    data: e.data.lstCommunityTransaction,
                    filter: { field: "CustomerID", operator: "eq", value: e.data.CustomerID }
                },
                scrollable: false,
                pageable: false,
                columns: [
                    { field: "CommunityName", title: "Community" },
                    { field: "ReviewCount", title: "# R & R: Count", template: '$ R&R: ${ReviewCount}' },
                    { field: "TotalRevenue", title: "Total Revenue", template: 'Total Revenue: (${CurrencyName}) #=(TotalRevenue).toFixed(2)#' },
                    { field: "TotalSpend", title: "Total Spend", template: 'Total Spend: (${CurrencyName}) #=(TotalSpend).toFixed(2)#' }
                ],
                detailInit: CommunityGroupInit,
                dataBound: function () {
                    this.expandRow(this.tbody.find("tr.k-master-row").first());
                },
            });
            $(".k-grid tbody .k-grid .k-grid-header").hide();
        }

        //Binds grand child grid.
        function CommunityGroupInit(e) {
            $kendoJS("<div/>").appendTo(e.detailCell).kendoGrid({
                dataSource: {
                    data: e.data.lstCommunityGroupTransaction
                },
                scrollable: false,
                pageable: false,
                columns: [
                    { field: "CommunityGroupName", title: "Community Group" },
                    { field: "ReviewCount", title: "# R & R: Count", template: '$ R&R: ${ReviewCount}' },
                    { field: "ViewsCount", title: "Customer Views", template: 'Views: ${ViewsCount}' },
                    { field: "TotalRevenue", title: "Transaction", template: 'Transactions: ${TotalRevenue}' },
                    { field: "TotalSpend", title: "Total Revenue", template: 'Total Spend: (${CurrencyName}) #=(TotalSpend).toFixed(2)#' }
                ]
            });
            $(".k-grid tbody .k-grid .k-grid-header").hide();
        }

        //This method sets communityId to zero.
        function SetCommunityIdZero() {
            communityId = 0;
        }
    </script>
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Customer Management</h2>
    <div class="row">
        <div class="col-md-12">
            <div class="form-horizontal" role="form">
                <hr />
                <div class="col-md-4"></div>
                <div class="col-md-4">                    
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Name / Handle</label>
                        </div>
                        <input type="text" id="txtNameHandle" class="form-control" placeholder="Name / Handle" name="txtNameHandle" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Community</label>
                        </div>
                        <input id="ddlCommunity" name="ddlCommunity" class="custom-dropdown-width" data-role="dropdownlist" onchange="SetCommunityIdZero()" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Community Group</label>
                        </div>
                        <input id="ddlCommunityGroup" name="ddlCommunityGroup" class="custom-dropdown-width" data-role="dropdownlist" />
                    </div>
                    <div class="form-group">
                        <input type="button" id="btnSearch" value="Search" name="btnSearch" class="btn btn-block btn-lg btn-primary" onclick="Search(this)" />
                    </div>
                </div>
                <div class="col-md-4"></div>
            </div>
            <div class="col-md-12">
                <div id="gvCustomerDetails"></div>
            </div>
            <div class="col-md-12 custom-custmang-top-margin">
                <div class="col-md-5"></div>
                <div class="col-md-2">
                    <input type="button" id="btnShowMore" value="Show More" name="btnShowMore" class="btn btn-block btn-lg btn-primary" onclick="Search(this)" />
                </div>
                <div class="col-md-5"></div>
            </div>
        </div>
    </div>
</asp:Content>
