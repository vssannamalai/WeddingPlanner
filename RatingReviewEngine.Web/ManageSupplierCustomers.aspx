<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="ManageSupplierCustomers.aspx.cs" Inherits="RatingReviewEngine.Web.ManageSupplierCustomers" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <style>
        .k-reset {
            font-size: 100% !important;
        }

        .k-header {
            color: White;
            background-color: #34495E;
            font-size: 16px;
        }

        .k-label {
            font-size: 15px;
        }

        #tbody, tr {
            line-height: 1.42857;
            vertical-align: top;
            font-size: 15px;
        }

        body {
            font-size: 14px !important;
        }

        .k-pager-numbers .k-link {
            line-height: 2em !important;
        }

        .k-list-container {
            width: auto !important;
            min-width: 374px;
            max-width: 740px;
        }

            .k-list-container .k-list .k-item {
                /*white-space: nowrap;*/
            }

        /*.k-list-container ul li {
                word-wrap: break-word;
            }*/

        @media only screen and (min-width: 768px) and (max-width: 1024px) {

            .k-list-container {
                width: auto !important;
                min-width: 313px;
            }
        }

        #ddlCommunityGroup-list ul {
            overflow-x: hidden !important;
        }
    </style>

    <script type="text/javascript">

        var showAction = false;

        $(document).ready(function () {
            RegisterKeypressOnLoad();
            ControlValidation();
            ButtonClickEventOnLoad();

            $("#resultDiv").addClass("custom-hide");
            $("#historyDiv").addClass("custom-hide");

            BindCommunityGroup();
            BindAction();

            var customerid = GetQueryStringParams('cuid') == undefined ? "0" : GetQueryStringParams('cuid');

            if (customerid > 0) {
                var handle = isNullOrEmpty($("#txtHandle").val()) == true ? 'nullstring' : $("#txtHandle").val();
                var firstName = isNullOrEmpty($("#txtFirstName").val()) == true ? 'nullstring' : $("#txtFirstName").val();
                var lastName = isNullOrEmpty($("#txtLastName").val()) == true ? 'nullstring' : $("#txtLastName").val();
                var email = isNullOrEmpty($("#txtEmail").val()) == true ? 'nullstring' : $("#txtEmail").val();
                var communityGroupId = isNullOrEmpty($("#ddlCommunityGroup").val()) == true ? 0 : $("#ddlCommunityGroup").val();
                var actionId = isNullOrEmpty($("#ddlAction").val()) == true ? 0 : $("#ddlAction").val();

                //var param = "/" + $("#hdnSupplierId").val() + "/" + handle + "/" + firstName + "/" + lastName + "/" + email + "/" + communityGroupId + "/" + actionId + "/" + customerid;
                //GetResponse("FindCustomerBySupplier", param, SearchSuccess, Failure, ErrorHandler);

                var post = '{"SupplierID":"' + $("#hdnSupplierId").val() + '","Handle":"' + encodeURIComponent(handle) + '","FirstName":"' + encodeURIComponent(firstName) + '","LastName":"' + encodeURIComponent(lastName)
               + '","Email":"' + encodeURIComponent(email) + '","CommunityGroupID":"' + communityGroupId + '","ActionID":"' + actionId + '","CustomerID":"' + customerid + '"}';
                PostRequest("FindCustomerBySupplier", post, SearchSuccess, Failure, ErrorHandler);
            }

        });

        //Registers a keypress event on page load.
        function RegisterKeypressOnLoad() {
            $(document).keypress(function (event) {
                var keycode = (event.keyCode ? event.keyCode : event.which);
                if (keycode == '13') {
                    Search();
                }
            });
        }

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    txtNotes: { required: true }
                },
                messages: {
                    txtNotes: { required: 'You can\'t leave this empty.' }
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
            $('#btnSave').click(function (e) {
                if ($("#frmRatingReviewEngine").valid()) {
                    SaveSupplierNote();
                }
                e.preventDefault();
            });
        }

        //Service call to bind community group list to dropdown.
        function BindCommunityGroup() {
            var param = '/' + $("#hdnSupplierId").val();
            GetResponse("GetSupplierCommunityCommunityGroupList", param, BindCommunityGroupSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the community group list to dropdown.
        function BindCommunityGroupSuccess(response) {
            $kendoJS("#ddlCommunityGroup").kendoDropDownList({
                dataTextField: "Description",
                dataValueField: "CommunityGroupID",
                index: 0,
                suggest: true,
                optionLabel: response.length == 0 ? null : "Community - Community Group",
                filter: "contains",
                dataSource: response.length == 0 ? [{ Description: "Community - Community Group", CommunityGroupID: "0" }] : response
            });
        }

        //Service call to bind action list to dropdown.
        function BindAction() {
            GetResponse("GetActionList", "", BindActionSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the action list to dropdown.
        function BindActionSuccess(response) {
            $kendoJS("#ddlAction").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "ActionID",
                index: 0,
                suggest: true,
                optionLabel: response.length == 0 ? null : "Action",
                filter: "contains",
                dataSource: response.length == 0 ? [{ Name: "Action", ActionID: "0" }] : response
            });
        }

        function Search() {
            var handle = isNullOrEmpty($("#txtHandle").val()) == true ? 'nullstring' : $("#txtHandle").val();
            var firstName = isNullOrEmpty($("#txtFirstName").val()) == true ? 'nullstring' : $("#txtFirstName").val();
            var lastName = isNullOrEmpty($("#txtLastName").val()) == true ? 'nullstring' : $("#txtLastName").val();
            var email = isNullOrEmpty($("#txtEmail").val()) == true ? 'nullstring' : $("#txtEmail").val();
            var communityGroupId = isNullOrEmpty($("#ddlCommunityGroup").val()) == true ? 0 : $("#ddlCommunityGroup").val();
            var actionId = isNullOrEmpty($("#ddlAction").val()) == true ? 0 : $("#ddlAction").val();

            //  var param = "/" + $("#hdnSupplierId").val() + "/" + handle + "/" + firstName + "/" + lastName + "/" + email + "/" + communityGroupId + "/" + actionId + "/0";
            var post = '{"SupplierID":"' + $("#hdnSupplierId").val() + '","Handle":"' + encodeURIComponent(handle) + '","FirstName":"' + encodeURIComponent(firstName) + '","LastName":"' + encodeURIComponent(lastName)
                + '","Email":"' + encodeURIComponent(email) + '","CommunityGroupID":"' + communityGroupId + '","ActionID":"' + actionId + '","CustomerID":"0"}';
            //GetResponse("FindCustomerBySupplier", param, SearchSuccess, Failure, ErrorHandler);
            PostRequest("FindCustomerBySupplier", post, SearchSuccess, Failure, ErrorHandler);
        }

        function SearchSuccess(response) {
            $("#historyDiv").addClass("custom-hide");

            $kendoJS("#gvCustomerResults").kendoGrid({
                dataSource: {
                    pageSize: 10,
                    data: response
                },
                pageable: true,
                scrollable: false,
                columns: [
                    { field: "Handle", width: 200, title: "Customer", template: '<a id="#=CustomerID#" class="custom-anchor" onclick="SelectCustomer(this)">${Handle}</a>' },
                    { field: "Email", width: 200, title: "Email" },
                    { field: "CommunityGroup", width: 400, title: "Community Group" },
                    { field: "ActionName", width: 130, title: "Current Action" }]
            }).data("kendoGrid");

            $("#resultDiv").removeClass("custom-hide").addClass("custom-visible");
        }

        function Failure(response) {
            FailureWindow('Search', response, '#');
        }

        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Search', response, '#');
        }

        function SelectCustomer(data) {
            $("#txtNotes").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
            $("#txtNotes").parent().find('.error').hide();
            var customerId = data.id;
            var param = "/" + $("#hdnSupplierId").val() + "/" + customerId;
            GetResponse("GetSupplierActionByCustomer", param, SelectCustomerSuccess, Failure, ErrorHandler);
        }

        function SelectCustomerSuccess(response) {
            $("#divActionList").addClass("custom-hide");
            $("#spanMinMax").removeClass("glyphicon glyphicon-minus").addClass("glyphicon glyphicon-plus");
            showAction = false;

            $("#lblCustomerName").text(response[0].CustomerName);
            $("#lblEmail").text(response[0].CustomerEmail);
            $("#lblCurrentAction").text(response[0].CurrentAction);
            $("#hdnCustomerID").val(response[0].CustomerID);
            $("#hdnCommunityID").val(response[0].CommunityID);
            $("#hdnCommunityGroupID").val(response[0].CommunityGroupID);
            $("#txtNotes").val(response[0].SupplierNote);

            $kendoJS("#gvCustomerActions").kendoGrid({
                dataSource: {
                    pageSize: 10,
                    data: response,
                    schema: { model: { fields: { ActionDate: { type: 'date' } } } }
                },
                pageable: true,
                scrollable: false,
                columns: [
                    { field: "ActionDate", width: 200, title: "Date", template: '#= ActionDateString #' },
                    { field: "ActionName", width: 200, title: "Activity", template: '<a id="${SupplierActionID}_${QuoteID}" class="custom-anchor" onclick="ActionClick(this, ${CommunityGroupID})">${ActionName}</a>' },
                    { field: "CommunityGroupName", width: 498, title: "Community Group", template: '<a class="custom-anchor" href="SupplierCommunityGroupDetail.aspx?gid=' + Encrypted('#=CommunityGroupID#') + '">${CommunityGroupName}</a>' }]
            }).data("kendoGrid");

            $("#historyDiv").removeClass("custom-hide").addClass("custom-visible");
        }

        function ShowActionList(e) {
            if (showAction == false) {
                showAction = true;
                $("#divActionList").removeClass("custom-hide").addClass("custom-visible");
                $("#spanMinMax").removeClass("glyphicon glyphicon-plus").addClass("glyphicon glyphicon-minus");
            }
            else if (showAction == true) {
                showAction = false;
                $("#divActionList").removeClass("custom-visible").addClass("custom-hide");
                $("#spanMinMax").removeClass("glyphicon glyphicon-minus").addClass("glyphicon glyphicon-plus");
            }

            e.preventDefault();
        }

        function SaveSupplierNote() {
            var postData = '{"CustomerID": "' + $("#hdnCustomerID").val() + '", "CommunityID": "' + $("#hdnCommunityID").val() + '", "CommunityGroupID": "' + $("#hdnCommunityGroupID").val() + '", "SupplierID": "' + $("#hdnSupplierId").val() + '", "SupplierNote": "' + encodeURIComponent($("#txtNotes").val()) + '"}';
            PostRequest("InsertSupplierNote", postData, SupplierNoteSuccess, SupplierNoteFailure, SupplierNoteErrorHandler);
        }

        function SupplierNoteSuccess() {
            SuccessWindow('Supplier Note', 'Saved successfully.', '#');
        }

        function SupplierNoteFailure(response) {
            FailureWindow('Supplier Note', response, '#');
        }

        function SupplierNoteErrorHandler(response) {
            var errorMessage;
            //If error response in xml format
            if (response.responseText.indexOf("<") == 0) {
                var xmlResponse = $.parseXML(response.responseText)
                errorMessage = $(xmlResponse).find('ErrorMessage').text();
            }
                //If error response is json format
            else if (response.responseText.indexOf("{") == 0) {
                jsonResponse = JSON.parse(response.responseText);
                errorMessage = jsonResponse.ErrorMessage;
            }
            //Show error message in a user friendly window
            ErrorWindow('Supplier Note', errorMessage, '#');
        }

        function ActionClick(data, groupId) {
            var id = data.id;
            var strId = [];
            strId = id.split('_');

            switch ($.trim($(data).text()).toLowerCase()) {
                case "quote":
                    window.location = "QuoteGenerate.aspx?said=" + Encrypted(strId[0]) + "&qid=" + Encrypted(strId[1]);
                    break;
                default:
                    window.location = "SupplierActivityTracker.aspx?gid=" + Encrypted(groupId) + "&said=" + Encrypted(strId[0]);
                    break;
            }
        }
    </script>

</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">My Customers</h2>
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <hr />
            <div class="col-md-4"></div>
            <div class="col-md-4">
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">Handle</label>
                    </div>
                    <input type="text" id="txtHandle" class="form-control" placeholder="Handle" name="txtHandle" maxlength="50" />
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">First Name</label>
                    </div>
                    <input type="text" id="txtFirstName" class="form-control" placeholder="First Name" name="txtFirstName" maxlength="50" />
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">Last Name</label>
                    </div>
                    <input type="text" id="txtLastName" class="form-control" placeholder="Last Name" name="txtLastName" maxlength="50" />
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">Email</label>
                    </div>
                    <input type="text" id="txtEmail" class="form-control" placeholder="Email" name="txtEmail" maxlength="100" />
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">Community Group</label>
                    </div>
                    <input id="ddlCommunityGroup" name="ddlCommunityGroup" data-role="dropdownlist" class="custom-dropdown-width" />
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">Current Action</label>
                    </div>
                    <input id="ddlAction" name="ddlAction" data-role="dropdownlist" class="custom-dropdown-width" />
                </div>
                <div class="form-group">
                    <input type="button" id="btnSearch" value="Search" name="btnSearch" class="btn btn-block btn-lg btn-primary" onclick="Search()" />
                </div>
            </div>
            <div class="col-md-4"></div>
        </div>
        <div class="col-md-12" id="resultDiv">
            <h4>Results</h4>
            <div id="gvCustomerResults"></div>
            <input type="hidden" id="hdnCustomerID" />
            <input type="hidden" id="hdnCommunityID" />
            <input type="hidden" id="hdnCommunityGroupID" />
        </div>
        <div class="col-md-12" id="historyDiv">
            <hr />
            <div class="panel-dark">
                <div class="row">
                    <div class="col-md-4">
                        <label id="lblCustomerName"></label>
                    </div>
                    <div class="col-md-4">
                        <label id="lblEmail"></label>
                    </div>
                    <div class="col-md-4">
                        <label id="lblCurrentAction"></label>
                    </div>
                    <div class="form-group col-md-12">
                        <textarea id="txtNotes" placeholder="Notes" rows="4" class="form-control" name="txtNotes"></textarea>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-2 pull-right">
                        <input id="btnSave" value="Save" class="btn btn-block btn-lg btn-info" name="btnSave" type="button" />
                    </div>
                </div>
            </div>
            <div class="panel-light">
                <div class="row">
                    <div class="col-md-3">
                        <div class="btn-toolbar">
                            <div class="btn-group">
                                <a class="btn btn-primary" href="#" onclick="ShowActionList(event)"><span id="spanMinMax" class="glyphicon glyphicon-plus"></span>&nbsp;&nbsp;History</a>
                            </div>
                        </div>
                    </div>
                </div>

                <br />
                <div id="divActionList">
                    <div id="gvCustomerActions"></div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
