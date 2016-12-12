<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="ManageTriggeredEvents.aspx.cs" Inherits="RatingReviewEngine.Web.ManageTriggeredEvents" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <style>
        .k-dropdown-wrap {
            width: auto !important;
        }

        .k-reset {
            font-size: 100% !important;
        }

        .k-header {
            color: White;
            background-color: #34495E;
            font-size: 16px;
        }

        body {
            font-size: 13px !important;
        }

        .k-pager-numbers .k-link {
            line-height: 2em !important;
        }

        .k-grid td {
            line-height: 0.5em;
        }

        .k-grid tbody tr td {
            vertical-align: top;
        }
    </style>

    <script type="text/javascript">
        var isValidPercent = false;

        $(document).ready(function () {
            ControlValidation();
            KeyDownEventOnLoad();
            ButtonClickEventOnLoad();
            BindTriggeredEventList();
            BindAction();
            BindIsActive();
            BindPercentFee();
        });

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    txtAction: { required: true },
                    txtBillingAdmin: { required: true },
                    txtBillingCommunityOwner: { required: true }
                },
                messages: {
                    txtAction: { required: 'You can\'t leave this empty.' },
                    txtBillingAdmin: { required: 'You can\'t leave this empty.' },
                    txtBillingCommunityOwner: { required: 'You can\'t leave this empty.' }
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

        //Registers a keydown event on page load.
        function KeyDownEventOnLoad() {
            $('#txtBillingAdmin').keydown(function (e) {
                AllowDecimal(e);
            });

            $('#txtBillingCommunityOwner').keydown(function (e) {
                AllowDecimal(e);
            });
        }

        //Registers a button click event on page load.
        function ButtonClickEventOnLoad() {
            $('#btnAdd').click(function (e) {
                var isValid = DropDownValidate();
                if ($("#frmRatingReviewEngine").valid() && !isValid && !isValidPercent) {
                    NewTriggeredEvent();
                }
                e.preventDefault();
            });
        }

        //Service call to fetch trigger event list.
        function BindTriggeredEventList() {
            GetResponse("TriggeredEventList", "", BindTriggeredEventListSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the listview and dropdowns inside listview
        function BindTriggeredEventListSuccess(response) {

            $kendoJS("#gvTriggeredEvents").kendoGrid({
                dataSource: {
                    //pageSize: 10,
                    data: response
                },
                pageable: false,
                scrollable: false,
                columns: [
                    { field: "ActionName", width: 126, title: "Action", template: '<input type="hidden" id="hdnActionId" value=${ActionID} /><label id="lblAction${ActionID}">${ActionName}</label>' },
                    { title: "Action Response", width: 260, template: '<table style="margin-top: -4px;"><tr><td id="dropdown${ActionID}" class="form-group" style="border-style: none;"></td></tr></table>' },
                    { field: "BillingPercentageAdministrator", width: 120, title: "Billing % Administrator", template: '<input type="text" id="txtBillingAdmin${ActionID}" maxlength="10" placeholder="Billing % Admin" class="form-control custom-mangtrigevent-textbox" value="${BillingPercentageAdministrator}" onchange="CalculateBillingPercentageAdmin(this)" onkeydown="AllowDecimal(event)" /><span id="spanBillingAdmin${ActionID}" class="custom-mangcurency-validation-off"></span>' },
                    { field: "BillingPercentageOwner", width: 120, title: "Billing % Community Owner", template: '<input type="text" id="txtBillingCommunityOwner${ActionID}" maxlength="10" placeholder="Billing % Owner" class="form-control custom-mangtrigevent-textbox" value="${BillingPercentageOwner}" onchange="CalculateBillingPercentageOwner(this)" onkeydown="AllowDecimal(event)" /><span id="spanBillingCommunityOwner${ActionID}" class="custom-mangcurency-validation-off"></span>' },
                    { title: "Is Active", width: 137, template: '<input id="ddlIsActive${ActionID}" class="custom-mangtrigevent-dropdown-bool" /><span id="spanIsActive${ActionID}" class="custom-mangcurency-validation-off"></span>' },
                    { title: "Is % Fee", width: 137, template: '<input id="ddlIsPercentFee${ActionID}" class="custom-mangtrigevent-dropdown-bool" /><span id="spanIsPercentFee${ActionID}" class="custom-mangcurency-validation-off"></span>' }
                ]
            }).data("kendoGrid");

            //Binds IsActive DropDown inside ListView.
            var isActiveDataSource = new kendo.data.DataSource({
                data: response
            })
            isActiveDataSource.read();
            var count = isActiveDataSource.total();
            for (var i = 0; i < count; i++) {
                BindIsActiveList(response[i].ActionID, response[i].IsActive);
            }

            //Binds IsPercentFee DropDown inside ListView.
            var isActiveDataSource = new kendo.data.DataSource({
                data: response
            })
            isActiveDataSource.read();
            var count = isActiveDataSource.total();
            for (var i = 0; i < count; i++) {
                BindIsPercentFeeList(response[i].ActionID, response[i].IsPercentFee);
            }

            //Binds Action DropDown inside ListView.
            for (var j = 0; j < count; j++) {
                var actionDataSource = new kendo.data.DataSource({
                    data: response[j].lstActionResponse
                })

                actionDataSource.read();
                var actionCount = actionDataSource.total();

                //When there is no action response
                if (actionCount == 0) {
                    $("#dropdown" + response[j].ActionID).append('<input class="actionresponse" id="ddlActionResponse' + response[j].ActionID + '_0" style="width: 11.5em !important;" /><input type="button" id="btnAddDropDown' + response[j].ActionID + '_0" value="A" class="btn btn-primary" style="margin-left: 5px;" onclick="AddDynamicDropDown(' + response[j].ActionID + ')" /><span id="spanAction' + response[j].ActionID + '_0" class="custom-mangcurency-validation-off"></span>');
                    BindDefauleActionList(response[j].ActionID + "_0");
                }

                for (var k = 0; k < actionCount; k++) {

                    var id = response[j].ActionID + '_' + response[j].lstActionResponse[k].ResponseID;

                    if (k != 0)
                        $("#dropdown" + response[j].ActionID).append('<br /><br />');

                    $("#dropdown" + response[j].ActionID).append('<input class="actionresponse" id="ddlActionResponse' + id + '" style="width: 11.5em !important;" /><span id="spanAction' + id + '" class="custom-mangcurency-validation-off"></span>');

                    if (k == 0)
                        $("#dropdown" + response[j].ActionID).append('<input type="button" id="btnAddDropDown' + id + '" value="A" class="btn btn-primary" style="margin-left: 5px;" onclick="AddDynamicDropDown(' + response[j].ActionID + ')" />');

                    BindActionList(response[j].ActionID, response[j].lstActionResponse[k].ResponseID);
                }
            }
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Manage Triggered Events', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Manage Triggered Events', response, '#');
        }

        //Service call to binds action dropdown.
        function BindAction() {
            $kendoJS("#ddlAction").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "ActionID",
                index: 0,
                suggest: true,
                optionLabel: "Action Response",
                filter: "contains",
                dataSource: {
                    transport: {
                        read: {
                            dataType: "json",
                            beforeSend: setHeader,
                            cache: false,
                            url: $("#hdnAPIUrl").val() + "GetActionList"
                        }
                    }
                },
                change: DropDownValidate
            });
        }

        //This method binds percent fee dropdown with static data.
        function BindPercentFee() {
            $kendoJS("#ddlIsPercentFee").kendoDropDownList({
                dataTextField: "text",
                dataValueField: "value",
                index: 0,
                optionLabel: "Is % Fee",
                suggest: true,
                filter: "contains",
                dataSource: [
                    { text: "Yes", value: "1" },
                    { text: "No", value: "0" }
                ],
                change: DropDownValidate
            });
        }

        //Service call to binds action dropdown in listview.
        function BindActionList(actionId, responseId) {
            $kendoJS("#ddlActionResponse" + actionId + '_' + responseId).kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "ActionID",
                index: 0,
                suggest: true,
                optionLabel: "Action Response",
                filter: "contains",
                dataSource: {
                    transport: {
                        read: {
                            dataType: "json",
                            beforeSend: setHeader,
                            cache: false,
                            url: $("#hdnAPIUrl").val() + "GetActionList"
                        }
                    }
                }
            });

            $kendoJS("#ddlActionResponse" + actionId + '_' + responseId).data('kendoDropDownList').value(responseId);
        }

        //Service call to binds action response dropdown in listview.
        function BindDefauleActionList(id) {
            $kendoJS("#ddlActionResponse" + id).kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "ActionID",
                index: 0,
                suggest: true,
                optionLabel: "Action Response",
                filter: "contains",
                dataSource: {
                    transport: {
                        read: {
                            dataType: "json",
                            beforeSend: setHeader,
                            cache: false,
                            url: $("#hdnAPIUrl").val() + "GetActionList"
                        }
                    }
                }
            });
        }

        //This method binds isactive dropdown with static data.
        function BindIsActive() {
            $kendoJS("#ddlIsActive").kendoDropDownList({
                dataTextField: "text",
                dataValueField: "value",
                index: 0,
                optionLabel: "Is Active",
                suggest: true,
                filter: "contains",
                dataSource: [
                    { text: "Yes", value: "1" },
                    { text: "No", value: "0" }
                ],
                change: DropDownValidate
            });
        }

        //This method binds isactive dropdown with static data in listview.
        function BindIsActiveList(id, isActive) {
            $kendoJS("#ddlIsActive" + id).kendoDropDownList({
                dataTextField: "text",
                dataValueField: "value",
                index: 0,
                suggest: true,
                filter: "contains",
                dataSource: [
                    { text: "Yes", value: "1" },
                    { text: "No", value: "0" }
                ]
            });

            $kendoJS("#ddlIsActive" + id).data('kendoDropDownList').value(isActive == true ? "1" : "0");
        }

        //This method binds percent fee dropdown with static data in listview.
        function BindIsPercentFeeList(id, isPercentFee) {
            $kendoJS("#ddlIsPercentFee" + id).kendoDropDownList({
                dataTextField: "text",
                dataValueField: "value",
                index: 0,
                suggest: true,
                filter: "contains",
                dataSource: [
                    { text: "Yes", value: "1" },
                    { text: "No", value: "0" }
                ]
            });

            $kendoJS("#ddlIsPercentFee" + id).data('kendoDropDownList').value(isPercentFee == true ? "1" : "0");
        }

        //This method validates isactive & percent fee dropdowns and returns a boolean value.
        function DropDownValidate() {

            var result;

            //var resultAction = (isNullOrEmpty($("#ddlAction").val().toString()) == true ? true : false);
            //result = resultAction;
            //if (result == true)
            //    $("#spanAction").text("You can\'t leave this empty.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
            //else
            //    $("#spanAction").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");


            var resultActive = (isNullOrEmpty($("#ddlIsActive").val().toString()) == true ? true : false);
            result = resultActive;
            if (result == true)
                $("#spanIsActive").text("You can\'t leave this empty.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
            else
                $("#spanIsActive").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");


            var resultPercentFee = (isNullOrEmpty($("#ddlIsPercentFee").val().toString()) == true ? true : false);
            result = resultPercentFee;
            if (result == true)
                $("#spanIsPercentFee").text("You can\'t leave this empty.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
            else
                $("#spanIsPercentFee").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");

            return result;
        }

        //Service call to save a new trigger event.
        function NewTriggeredEvent() {
            var postData = '{"ActionName":"' + $("#txtAction").val() + '", "ActionResponseID":"' + (isNullOrEmpty($("#ddlAction").val().toString()) == true ? 0 : $("#ddlAction").val()) + '", "BillingPercentageAdministrator":"' + $("#txtBillingAdmin").val() + '", "BillingPercentageOwner":"' + $("#txtBillingCommunityOwner").val() + '", "IsActive":"' + $("#ddlIsActive").val() + '", "IsPercentFee":"' + $("#ddlIsPercentFee").val() + '"}';
            PostRequest("NewTriggeredEvent", postData, NewTriggeredEventSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, success message will be showed in popup and BindTriggeredEventList() method is called.
        function NewTriggeredEventSuccess(response) {
            ClearControls('actionControls');
            SuccessWindow('Manage Triggered Events', "Saved successfully.", '#');
            BindTriggeredEventList();
        }

        //This method adds a dynamic dropdown inside the listview.
        function AddDynamicDropDown(id) {
            var controlCount = $("#dropdown" + id).find('input').length - 1;
            var controlId = id + "_" + (controlCount + 1);
            $("#dropdown" + id).append('<br /><br /><input class="actionresponse" id="ddlActionResponse' + controlId + '" style="width: 11.5em !important;" /><span id="spanAction' + controlId + '" class="custom-mangcurency-validation-off"></span>')
            BindDefauleActionList(controlId);
        }

        //This method updates all the triggered events in listview.
        function UpdateTriggeredEvents() {
            var div = $("#gvTriggeredEvents");
            var lst = [];
            var id = 0;
            var postData = '{';
            var actionID = 0;
            $("#gvTriggeredEvents").find('tr').each(function () {
                //$(this).find('.tr').each(function () {
                $(this).find('input').each(function () {
                    switch ($(this).attr('id')) {

                        case "hdnActionId":
                            postData += '"ActionID":"' + $(this).val() + '",';
                            id = $(this).val();
                            actionID = $(this).val();
                            break;

                        case "txtBillingAdmin" + actionID:
                            postData += '"BillingPercentageAdministrator":"' + $(this).val() + '",';
                            break;

                        case "txtBillingCommunityOwner" + actionID:
                            postData += '"BillingPercentageOwner":"' + $(this).val() + '",';
                            break;

                        case "ddlIsActive" + actionID:
                            postData += '"IsActive":"' + $(this).val() + '",';
                            break;

                        case "ddlIsPercentFee" + actionID:
                            postData += '"IsPercentFee":"' + $(this).val() + '",';
                            break;
                    }
                });

                if (postData != '{') {
                    //Get list of action response id based on number of dropdown.
                    var responseId = '';
                    $(this).find('.actionresponse').each(function () {
                        if ($(this).is('input') && $(this).val() != '') {
                            responseId = responseId + $(this).val() + ',';
                        }
                    });

                    if (responseId != '')
                        responseId = responseId.substring(0, responseId.length - 1);

                    postData += '"ResponseId":"' + responseId + '",';

                    postData = postData.substring(0, postData.length - 1);
                    postData += '}';

                    lst.push(postData);

                    //  PostRequest("UpdateTriggeredEvent", postData, UpdateTriggeredEventSuccess, Failure, ErrorHandler);
                    postData = '{';
                }

                //});
            });

            var pdata = '{"lstTriggeredEvent":[' + lst + ']}';
            PostRequest("UpdateTriggeredEventList", pdata, UpdateTriggeredEventSuccess, Failure, ErrorHandler);
           
        }

        //On ajax call success.
        function UpdateTriggeredEventSuccess(response) {
            SuccessWindow('Manage Triggered Events', 'Updated successfully.', '#');
        }

        //This nethod calculates billing percentage for admin.
        function CalculateBillingPercentageAdmin(data) {
            var id = data.id.substring(15);

            if (DecimalValidation($.trim($('#' + data.id).val()))) {
                $("#billingAdminVadiation").css('display', 'none');
                $('#' + data.id).closest('.form-group').removeClass('form-group has-error').addClass('form-group');

                if ($('#' + data.id).val() > 100) {
                    BootstrapDialog.show({
                        title: "Manage Triggered Events",
                        message: "Percentage cannot be greater than 100.",
                        buttons: [{
                            label: 'Ok',
                            action: function (dialogItself) {
                                dialogItself.close();
                                $('#' + data.id).val('');

                                var percentage = (100 - $("#txtBillingCommunityOwner" + id).val()).toFixed(2);
                                $('#' + data.id).val(percentage);
                                if ($("#txtBillingCommunityOwner" + id).val() == '')
                                    $('#' + data.id).val('0.00');
                            }
                        }],
                        type: BootstrapDialog.TYPE_WARNING
                    });
                }
                else {
                    var percentage = (100 - $('#' + data.id).val()).toFixed(2);
                    $("#txtBillingCommunityOwner" + id).val(percentage);
                    $("#billingOwnerVadiation").css('display', 'none');
                    if ($('#' + data.id).val() == '')
                        $('#' + data.id).val('0.00');
                }

                $("#txtBillingCommunityOwner" + id).closest('.form-group').removeClass('form-group has-error').css('color', 'black').addClass('form-group');
                $("#txtBillingCommunityOwner" + id).valid();
                isValidPercent = false;
            }
            else {
                if ($.trim($('#' + data.id).val()) != "") {
                    $('#' + data.id).closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                    $("#billingAdminVadiation").text('Please enter a valid percentage.').css('display', 'block').css('color', '#E74C3C');
                    isValidPercent = true;
                }
            }
        }

        //This method calculates billing percentage for owner.
        function CalculateBillingPercentageOwner(data) {
            var id = data.id.substring(24);

            if (DecimalValidation($.trim($('#' + data.id).val()))) {
                $("#billingOwnerVadiation").css('display', 'none');
                $('#' + data.id).closest('.form-group').removeClass('form-group has-error').addClass('form-group');

                if ($('#' + data.id).val() > 100) {
                    BootstrapDialog.show({
                        title: "Manage Triggered Events",
                        message: "Percentage cannot be greater than 100.",
                        buttons: [{
                            label: 'Ok',
                            action: function (dialogItself) {
                                dialogItself.close();
                                $('#' + data.id).val('');

                                var percentage = (100 - $("#txtBillingAdmin" + id).val()).toFixed(2);
                                $('#' + data.id).val(percentage);
                                if ($("#txtBillingAdmin" + id).val() == '')
                                    $('#' + data.id).val('0.00');
                            }
                        }],
                        type: BootstrapDialog.TYPE_WARNING
                    });
                }
                else {
                    var percentage = (100 - $('#' + data.id).val()).toFixed(2);
                    $("#txtBillingAdmin" + id).val(percentage);
                    $("#billingAdminVadiation").css('display', 'none');
                    if ($('#' + data.id).val() == '')
                        $('#' + data.id).val('0.00');
                }

                $("#txtBillingAdmin" + id).closest('.form-group').removeClass('form-group has-error').css('color', 'black').addClass('form-group');
                $("#txtBillingAdmin" + id).valid();
                isValidPercent = false;
            }
            else {
                if ($.trim($('#' + data.id).val()) != "") {
                    $('#' + data.id).closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                    $("#billingOwnerVadiation").text('Please enter a valid percentage.').css('display', 'block').css('color', '#E74C3C');
                    isValidPercent = true;
                }
            }
        }
    </script>

</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Manage Triggered Events</h2>
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <hr />
            <div class="col-md-12">
                <div id="gvTriggeredEvents"></div>
                <div class="col-md-2 pull-right" style="margin-top: 20px;">
                    <div class="form-group">
                        <input type="button" value="Apply" id="btnApply" class="col-md-2 btn btn-block btn-lg btn-primary" onclick="UpdateTriggeredEvents()" />
                    </div>
                </div>
            </div>
            <div class="col-md-12" id="actionControls">
                <h4>Add new trigger event</h4>
                <hr />
                <div class="col-md-12">
                    <div class="col-md-1"></div>
                    <div class="col-md-3" style="margin-right: 2%;">
                        <div class="form-group">
                            <div>
                                <label class="custom-field-label-fontstyle" style="float: none;">Action</label>
                            </div>
                            <input type="text" id="txtAction" name="txtAction" placeholder="Action" class="form-control" maxlength="50" />
                        </div>
                    </div>
                    <div class="col-md-3" style="margin-right: 2%;">
                        <div class="form-group">
                            <div>
                                <label class="custom-field-label-fontstyle" style="float: none;">Billing % Admin</label>
                            </div>
                            <input type="text" id="txtBillingAdmin" name="txtBillingAdmin" placeholder="Billing % Admin" class="form-control" onblur="CalculateBillingPercentageAdmin(this)" maxlength="10" />
                            <span id="billingAdminVadiation" class="custom-mangcurency-validation-off"></span>
                        </div>
                    </div>
                    <div class="col-md-3" style="margin-right: 2%;">
                        <div class="form-group">
                            <div>
                                <label class="custom-field-label-fontstyle" style="float: none;">Billing % Owner</label>
                            </div>
                            <input type="text" id="txtBillingCommunityOwner" name="txtBillingCommunityOwner" placeholder="Billing % Owner" class="form-control" onblur="CalculateBillingPercentageOwner(this)" maxlength="10" />
                            <span id="billingOwnerVadiation" class="custom-mangcurency-validation-off"></span>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
                <div class="col-md-12">
                    <div class="col-md-1"></div>
                    <div class="col-md-3" style="margin-right: 2%;">
                        <div class="form-group">
                            <div>
                                <label class="custom-field-label-fontstyle" style="float: none;">Action Response</label>
                            </div>
                            <input id="ddlAction" style="width: 100% !important;" />
                            <span id="spanAction" class="custom-mangcurency-validation-off"></span>
                        </div>
                    </div>
                    <div class="col-md-3" style="margin-right: 2%;">
                        <div class="form-group">
                            <div>
                                <label class="custom-field-label-fontstyle" style="float: none;">Is Active</label>
                            </div>
                            <input id="ddlIsActive" class="custom-mangtrigevent-dropdown-bool" style="width: 100% !important;" />
                            <span id="spanIsActive" class="custom-mangcurency-validation-off"></span>
                        </div>
                    </div>
                    <div class="col-md-3" style="margin-right: 2%;">
                        <div class="form-group">
                            <div>
                                <label class="custom-field-label-fontstyle" style="float: none;">Is % Fee</label>
                            </div>
                            <input id="ddlIsPercentFee" class="custom-mangtrigevent-dropdown-bool" style="width: 100% !important;" />
                            <span id="spanIsPercentFee" class="custom-mangcurency-validation-off"></span>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-2 pull-right">
                    <div class="form-group">
                        <input type="button" value="Add" class="col-md-2 btn btn-block btn-lg btn-primary" id="btnAdd" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
