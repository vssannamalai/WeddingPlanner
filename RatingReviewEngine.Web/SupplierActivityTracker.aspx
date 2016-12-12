<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="SupplierActivityTracker.aspx.cs" Inherits="RatingReviewEngine.Web.SupplierActivityTracker" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <style>
        body {
            font-size: 14px !important;
        }

        .k-header {
            color: White;
            background-color: #34495E;
            font-size: 16px;
        }

        .k-reset {
            font-size: 100% !important;
        }

        .k-pager-numbers .k-link {
            line-height: 2em !important;
        }
    </style>

    <script type="text/javascript">
        var actionId = 0;
        var actionlist;

        $(document).ready(function () {
            if (GetQueryStringParams('gid') == null) {
                ErrorWindow('Supplier Activity Tracker', "No data found", 'Nodata.aspx');
                return;
            }
            BindSupplierAction();
            $("#Panel").hide();
            var supplierActionId = GetQueryStringParams('said') == undefined ? "0" : GetQueryStringParams('said');
            if (supplierActionId > 0) {
                BindSupplierActionDetail(supplierActionId);
            }

            BindMenu();
            BindCommunityName();
        });

        //Service call to fetch community group details based on group id from query string.
        function BindCommunityName() {
            var param = '/' + GetQueryStringParams('gid');
            GetResponse("GetCommunityGroup", param, BindCommunityNameSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds community and group names to hidden field.
        function BindCommunityNameSuccess(response) {
            $("#hdfCommunityName").val(response.CommunityName);
            $("#hdfCommunityGroupName").val(response.Name);
        }

        //Service call to fetch supplier action detials based on supplierId, groupId and supplierActionId.
        function BindSupplierAction() {
            var param;
            var supplierActionId = GetQueryStringParams('said') == undefined ? "0" : GetQueryStringParams('said');
            if (supplierActionId > 0) {
                param = '/' + $("#hdnSupplierId").val() + '/' + GetQueryStringParams('gid') + '/' + supplierActionId;
                GetResponse("GetSupplierActionBySupplierActionId", param, BindSupplierActionSuccess, Failure, ErrorHandler);
            }
            else {
                param = '/' + $("#hdnSupplierId").val() + '/' + GetQueryStringParams('gid');
                GetResponse("GetSupplierAction", param, BindSupplierActionSuccess, Failure, ErrorHandler);
            }
        }

        //On ajax call success, binds the data to grid.
        function BindSupplierActionSuccess(response) {

            actionlist = response.lstSupplierAction;

            var grid = $kendoJS("#gvSupplierAction").data("kendoGrid");
            if (grid != null)
                grid.destroy();

            $kendoJS("#gvSupplierAction").kendoGrid({
                dataSource: {
                    pageSize: 10,
                    data: response.lstSupplierAction,
                    schema: { model: { fields: { ActionDate: { type: 'date' } } } },
                    page: parseInt((response.RowIndex / 10)) + 1
                },
                pageable: true,
                scrollable: false,
                columns: [
                    { field: "ActionDate", width: 200, title: "Date", template: '#= ActionDateString #' },
                    { field: "ActionName", width: 200, title: "Activity", template: '<a id="#=ActionID#" class="custom-anchor" onclick="SelectCustomer(this)">${ActionName}</a><input type="hidden" id="hdfQuoteId" value=#=CustomerQuoteID# /><input type="hidden" id="hdfSupplierActionID" value=#=SupplierActionID# /><input type="hidden" id="hdnDetail" value=${Detail} /><input type="hidden" id="hdnCommunityID" value=${CommunityID} /><input type="hidden" id="hdnSupplierActionID" value=${SupplierActionID} />' },
                    { field: "CustomerName", width: 250, title: "Customer", template: '<a id="#=CustomerID#" class="custom-anchor" href="ManageSupplierCustomers.aspx?cuid=#=Encrypted(CustomerID)#">${CustomerName}</a>' },
                    { field: "ActionName", width: 250, title: "Available Actions", template: $("#idTemplate").html() }
                ],
                dataBound: onDataBound
            }).data("kendoGrid");
        }

        //This method binds the data to list view inside grid.
        function onDataBound(arg) {
            var pageSize = $kendoJS("#gvSupplierAction").data("kendoGrid").dataSource.pageSize();
            var pageNo = $kendoJS("#gvSupplierAction").data("kendoGrid").dataSource.page();

            var i = (pageNo - 1) * pageSize;
            $(".responseaction").each(function (index, element) {
                var dataitem = actionlist[i].lstAvailableAction;
                var dataSourceAvailableAction = new kendo.data.DataSource({
                    data: dataitem
                });

                i++;

                $kendoJS(element).kendoListView({
                    dataSource: dataSourceAvailableAction,
                    template: '<a id="#=SupplierActionID#" class="custom-anchor" style="float: left;" onclick="responseclick(this,#= ResponseID #)">#= ResponseName # </a><span style="float: left;">;</span>  '
                });

                $(element).removeClass('k-listview k-widget');
            });
        }

        //Service call to fetch supplier quote details.
        function BindSupplierActionDetail(supplierActionId) {
            var param = '/' + supplierActionId;
            GetResponse("GetSupplierActionByActionId", param, BindSupplierActionDetailSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the data to the corresponding controls.
        function BindSupplierActionDetailSuccess(response) {
            if (response.SupplierID != $("#hdnSupplierId").val()) {
                ErrorWindow("Supplier Activity Tracker", "No data found", "nodata.aspx");
                return;
            }

            var strDate = [];
            strDate = response.ActionDate.replace(/\/Date/g, '').replace('/', '').replace('(', '').replace(')', '').split('+');
            var actionDate = new Date(parseFloat(strDate[0]) + parseFloat(strDate[1]));
            $("#Panel").show();
            // $("#lblHeader").text(kendo.toString(actionDate, "dd/MM/yyyy hh:mm tt") + ' - ' + response.ActionName);
            $("#lblHeader").text(response.ActionDateString + ' - ' + response.ActionName);
            $("#lblCustomerName").text(response.CustomerName);
            $("#hdfCustomerId").val(response.CustomerID);
            $("#hdfCommunityId").val(response.CommunityID);
            $("#hdfSupplierActionId").val(response.SupplierActionID);
            $("#lblDetail").text(response.Detail);
            $("#txtDetail").val('');
            GetResponse("GetActionResponseWithoutRespondAndQuote", "/" + response.ActionID + "/" + response.SupplierActionID, BindAvilableAction, Failure, ErrorHandler);
        }

        //Service call to fetch supplier action menu details based on supplier id.
        function BindMenu() {
            var param = '/' + $("#hdnSupplierId").val();
            GetResponse("SupplierActionCountMenu", param, BindMenuSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the menu.
        function BindMenuSuccess(response) {

            $("#menuHeader").text('Communities').append('<b class="caret"></b>');
            $("#DynamicMenu").removeClass('custom-hide').addClass('custom-visible');

            $kendoJS("#menu").kendoMenu({
                dataSource: response
            });

            $("#menu").removeClass('k-widget k-reset k-header k-menu k-menu-horizontal');
            $("#menu .k-link").each(function () {
                $(this).removeAttr('class');
                $(this).addClass('custom-menu-anchor');
            });
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Supplier Activity Tracker', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Supplier Activity Tracker', response, '#');
        }

        //This method binds the panel and other controls based on the activity selected.
        function SelectCustomer(data) {
            // actionId = $(data).attr('id');
            $("#spanDetail").removeClass("custom-supplierdashboard-email-validation-on").addClass("custom-supplierdashboard-email-validation-off");
            var actionDetail = $(data).parent();
            var action = $(data).parent().siblings()[0];
            var td = $(data).parent().siblings()[1];

            var detail;
            var cmid;
            var said;
            $(actionDetail).find('input').each(function () {
                switch ($(this).attr('id')) {
                    case "hdnDetail":
                        detail = $(this).val();
                        break;

                    case "hdnCommunityID":
                        cmid = $(this).val();
                        break;

                    case "hdnSupplierActionID":
                        said = $(this).val();
                        break;
                }
            });

            //var detailtd = $(data).parent().siblings()[3];
            //var community = $(data).parent().siblings()[4];
            //var supaction = $(data).parent().siblings()[5];

            var customer = $(td).find('a').text();
            var cid = $(td).find('a').attr('id');

            //var detail = $(detailtd).find('input').val();
            //var cmid = $(community).text();
            //var said = $(supaction).text();

            var qid;
            var said;
            $(data).siblings('input').each(function () {
                if ($(this).attr('id') == 'hdfQuoteId')
                    qid = $(this).val();

                if ($(this).attr('id') == 'hdfSupplierActionID')
                    said = $(this).val();
            });

            if ($.trim($(data).text()).toLowerCase() == 'quote') {
                window.location = "QuoteGenerate.aspx?said=" + Encrypted(said) + "&qid=" + Encrypted(qid);
                return;
            }
            $("#Panel").show();
            $("#lblHeader").text($(action).text() + ' - ' + $(data).text());
            $("#lblCustomerName").text(customer);
            $("#hdfCustomerId").val(cid);
            $("#hdfCommunityId").val(cmid);
            $("#hdfSupplierActionId").val(said);
            $("#lblDetail").text(detail);
            $("#txtDetail").val('');
            GetResponse("GetActionResponseWithoutRespondAndQuote", "/" + $(data).attr('id') + "/" + said, BindAvilableAction, Failure, ErrorHandler);
        }

        //This method binds available action dropdown.
        function BindAvilableAction(response) {
            $("#spanAction").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
            $kendoJS("#ddlAvilableAction").kendoDropDownList({
                dataTextField: "ResponseActionName",
                dataValueField: "ResponseID",
                index: 0,
                suggest: true,
                optionLabel: response.length == 0 ? null : "Available Action",
                filter: "contains",
                dataSource: response.length == 0 ? [{ ResponseID: "", ResponseActionName: "Available Action" }] : response,
                change: validateAvailabelAction
            });

            if (actionId > 0)
                $kendoJS("#ddlAvilableAction").data("kendoDropDownList").value(actionId);

            if (response.length == 0) {
                $("#divCustomerDetail").removeClass("custom-visible").addClass("custom-hide");
                $("#divPerformAction").removeClass("custom-visible").addClass("custom-hide");
                $("#divNoAction").removeClass("custom-hide").addClass("custom-visible");
            }
            else {
                $("#divCustomerDetail").removeClass("custom-hide").addClass("custom-visible");
                $("#divPerformAction").removeClass("custom-hide").addClass("custom-visible");
                $("#divNoAction").removeClass("custom-visible").addClass("custom-hide");
            }
        }

        //This method performs action based on the response clicked.
        function responseclick(ctl, actid) {
            actionId = actid;
            switch ($.trim($(ctl).text()).toLowerCase()) {
                case "quote":
                    window.location = "QuoteGenerate.aspx?said=" + Encrypted(ctl.id) + "&aid=" + Encrypted(actid);
                    break;
                case "respond":
                    respond(ctl.id);
                    break;
                case "more information":

                    var td = $(ctl).parent().parent().siblings()[1];
                    var a = $(td).find('a');
                    SelectCustomer(a);
                    $("#txtDetail").val('Not enough detail has been supplied to enable an accurate quote. Could you please provide the following further information:');
                    break;
                default:
                    var td = $(ctl).parent().parent().siblings()[1];
                    var a = $(td).find('a');
                    SelectCustomer(a);
                    break;
            }

        }

        //Service call to fetch supplier action details.
        function respond(id) {
            var param = '/' + id;
            GetResponse("GetSupplierActionByActionId", param, BindSupplierActionSelectSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, the page is redirected to supplier review page.
        function BindSupplierActionSelectSuccess(response) {
            window.location = "SupplierReviews.aspx?cid=" + Encrypted(response.CommunityID) + "&gid=" + Encrypted(response.CommunityGroupID) + "&sid=" + Encrypted(response.SupplierID) + "&cuid=" + Encrypted(response.CustomerID);
        }

        //This method validates available action dropdown.
        function validateAvailabelAction() {
            if ($("#ddlAvilableAction").val() == '') {
                $("#spanAction").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                return false;
            }
            else {
                $("#spanAction").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                return true;
            }
        }

        //This method validates detail textbox.
        function ValidateDetail() {
            var isValid = false;

            if ($.trim($("#txtDetail").val()) == "") {
                $("#spanDetail").removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on");
                isValid = true;
            }
            else {
                $("#spanDetail").removeClass("custom-supplierdashboard-email-validation-on").addClass("custom-supplierdashboard-email-validation-off");
                isValid = false;
            }

            return isValid;
        }

        //Service call to perform action based on the response selected.
        function performAction() {
            var isValid = ValidateDetail();
            if (validateAvailabelAction() && !isValid) {

                var postData = '{"CustomerId":"' + $("#hdfCustomerId").val() + '","SupplierId":"' + $("#hdnSupplierId").val() + '","CommunityId":"' + $("#hdfCommunityId").val() + '","CommunityGroupId":"' + GetQueryStringParams('gid')
                + '","ActionId":"' + $("#ddlAvilableAction").val() + '","ActionName":"' + $kendoJS("#ddlAvilableAction").data("kendoDropDownList").text()
                + '","Message":"' + encodeURIComponent($("#txtDetail").val()) + '","ParentSupplierActionId":"' + $("#hdfSupplierActionId").val()
                + '","CommunityName":"' + encodeURIComponent($("#hdfCommunityName").val()) + '","CommunityGroupName":"' + encodeURIComponent($("#hdfCommunityGroupName").val()) + '"}';

                switch ($.trim($kendoJS("#ddlAvilableAction").data("kendoDropDownList").text()).toLowerCase()) {
                    case "quote":
                        PostRequest("SendCustomerQuoteDetail", postData, customerSupplierCommunicationSuccess, Failure, ErrorHandler);
                        break;
                    case "message response":
                        PostRequest("SendCustomerMessage", postData, customerSupplierCommunicationSuccess, Failure, ErrorHandler);
                        break;
                    case "answer":
                        PostRequest("SendCustomerAnswer", postData, customerSupplierCommunicationSuccess, Failure, ErrorHandler);
                        break;
                    case "more information":
                        PostRequest("SendCustomerMoreInfo", postData, customerSupplierCommunicationSuccess, Failure, ErrorHandler);
                        break;
                    default:
                        PostRequest("AddCustomerSupplierCommunication", postData, customerSupplierCommunicationSuccess, Failure, ErrorHandler);
                        break;
                }
            }
        }

        //On ajax call success, success message will be displayed in popup and BindSupplierAction() method is called.
        function customerSupplierCommunicationSuccess() {
            SuccessWindow('Customer Supplier Communication', 'Action performed successfully.', '#');
            $("#Panel").hide();
            $("#txtDetail").val('');
            BindSupplierAction();
        }

    </script>
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Supplier Activity Tracker</h2>
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <hr />
            <div class="col-md-12">
                <div id="gvSupplierAction"></div>
            </div>
            <script id="idTemplate" type="text/x-kendo-tmpl">
                <div id="divAction${SupplierActionID}" class ="responseaction"></div>
            </script>
        </div>
        <div class="col-md-12" id="customerDiv">
            <hr />
            <div class="panel-dark" id="Panel">
                <div class="row custom-visible" id="divCustomerDetail">
                    <div class="col-md-6">
                        <h4 id="lblHeader">Header</h4>
                    </div>
                    <div class="col-md-6">
                        <h4 id="lblCustomerName">Customer Name</h4>
                    </div>
                    <div class="form-group col-md-12">
                        <label id="lblDetail">Action Detail</label>
                        <input type="hidden" id="hdfCustomerId" />
                        <input type="hidden" id="hdfCommunityId" />
                        <input type="hidden" id="hdfSupplierActionId" />
                        <input type="hidden" id="hdfCommunityName" />
                        <input type="hidden" id="hdfCommunityGroupName" />
                    </div>
                    <div class="form-group col-md-3">
                        <div id="ddlAvilableAction" class="custom-dropdown-width"></div>
                        <span id="spanAction" class="custom-mangcurency-validation-off">You can't leave this empty.</span>
                    </div>
                    <div class="form-group col-md-12">
                        <textarea id="txtDetail" placeholder="Detail" rows="4" class="form-control" name="txtDetail" onkeyup="ValidateDetail()"></textarea>
                        <span id="spanDetail" class="custom-supplierdashboard-email-validation-off">You can't leave this empty.</span>
                    </div>
                </div>
                <div class="row custom-hide" id="divNoAction">
                    <div class="col-md-12" style="text-align: center;">
                        <h4>There is no action available.</h4>
                    </div>
                </div>
                <div class="row custom-visible" id="divPerformAction">
                    <div class="col-md-2 pull-right">
                        <input id="btnPerformAction" value="Perform Action" class="btn btn-block btn-lg btn-info" name="btnPerformAction" type="button" onclick="performAction()" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
