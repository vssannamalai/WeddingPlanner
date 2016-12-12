<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="ManageAPIToken.aspx.cs" Inherits="RatingReviewEngine.Web.ManageAPIToken" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <style>
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

        .k-reset {
            font-size: 100% !important;
        }

        .k-grid tr td {
            padding: 0.4em 0.4em !important;
        }

        .k-list-container {
            width: auto !important;
            min-width: 250px;
        }

        @media only screen and (min-width: 768px) and (max-width: 1250px) {

            .k-list-container {
                width: auto !important;
                min-width: 200px;
            }

            .custom-mangcomown-btn {
                font-size: 12px !important;   
                float: left;
                margin-right: 1%; 
                margin-left: 1%;            
            }
        }

        #ddlCommunity-list ul {
            overflow-x: hidden !important;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            ControlValidation();
            ButtonClickEventOnLoad();
            BindApplicationAuthenticationList();
            BindCommunity();
        });

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    txtEmail: { required: true, email: true },
                    txtApplication: { required: true }
                },
                messages: {
                    txtEmail: { required: 'You can\'t leave this empty.', email: 'Invalid email.' },
                    txtApplication: { required: 'You can\'t leave this empty.' }
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
            $('#btnAdd').click(function (e) {
                var isValid = DropDownValidate();

                if ($("#frmRatingReviewEngine").valid() && !isValid) {
                    CheckApplicationName();
                }
                e.preventDefault();
            });
        }

        //Service call to fetch list of community based on owner id (owner id optional).
        function BindCommunity() {
            var ownerId = (isNullOrEmpty($("#hdnCommunityOwnerId").val().toString()) == true ? "0" : $("#hdnCommunityOwnerId").val())

            if (ownerId > 0) {
                var param = "/" + ownerId;
                GetResponse("GetCommunityListByOwner", param, BindCommunitySuccess, Failure, ErrorHandler);
            }
            else {
                GetResponse("CommunityList", "", BindCommunitySuccess, Failure, ErrorHandler);
            }
        }

        //On ajax call success, binds the date to dropdown.
        function BindCommunitySuccess(response) {
            $kendoJS("#ddlCommunity").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "CommunityID",
                index: 0,
                optionLabel: response.length == 0 ? null : "Select a Community",
                suggest: true,
                filter: "contains",
                dataSource: response.length == 0 ? [{ Name: "Select a Community", CommunityID: "0" }] : response,
                change: DropDownValidate
            });
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Manage API Tokens', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {            
            //Show error message in a user friendly window
            ErrorWindow('Manage API Tokens', response, '#');
        }

        //This method validates dropdown and returns a boolean value.
        function DropDownValidate() {
            var result = (isNullOrEmpty($("#ddlCommunity").val().toString()) == true ? true : false);

            if (result == true)
                $("#spanCommunity").text("You can\'t leave this empty.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
            else
                $("#spanCommunity").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");

            return result;
        }

        //Service call to fetch application authentication list based on owner id.
        function BindApplicationAuthenticationList() {
            var param = "/" + (isNullOrEmpty($("#hdnCommunityOwnerId").val().toString()) == true ? "0" : $("#hdnCommunityOwnerId").val());
            GetResponse("ApplicationAuthenticationList", param, BindApplicationAuthenticationSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the date to grid.
        function BindApplicationAuthenticationSuccess(response) {
            $kendoJS("#gvCommunityOwner").kendoGrid({
                dataSource: {
                    pageSize: 10,
                    data: response
                },
                pageable: true,
                scrollable: false,
                columns: [
                    { field: "OwnerName", width: 140, title: "Community Owner", template: '#= htmlEncode(OwnerName) #' },
                    { field: "CommunityName", width: 140, title: "Community", template: '<label style="color: #= CommunityActive == true ? "" : "\\#E74C3C" #; font-size: 13px !important; line-height: inherit;">#= htmlEncode(CommunityName) #</label>' },
                    { field: "RegisteredEmail", width: 140, title: "Email", template: '<a class="custom-anchor" href="mailto:${RegisteredEmail}">${RegisteredEmail}</a>' },
                    { field: "ApplicationName", width: 130, title: "Application", template: '<label style="font-size: 13px !important; line-height: inherit;">#= htmlEncode(ApplicationName) #</label>' },
                    { field: "APIToken", width: 350, title: "API Token", template: '<table><tr><td style="color: #= IsActive == true ? "" : "\\#E74C3C" #; border-style: none; font-size: 13px !important;"><label id="lbl${ApplicationID}" style="font-size: 13px !important; padding: 0px 4px;">${APIToken}</label></td></tr><tr><td align="center" style="border-style: none;"><input type="button" value="Deactivate Token" id="${ApplicationID}" class="btn btn-primary custom-mangcomown-btn" style="display: #= IsActive == true ? "block" : "none" #" onclick="DeactivateToken(this)" /><input type="button" value="Activate Token" id="${ApplicationID}" class="btn btn-primary custom-mangcomown-btn" style="display: #= IsActive == false && ' + $("#hdnCommunityOwnerId").val() + ' == 0 ? "block" : "none" #" onclick="ActivateToken(this)" /><input type="button" value="Reset Token" id="${ApplicationID}" style="display: #= IsActive == true ? "block" : "none" #" class="btn btn-primary custom-mangcomown-btn" onclick="ResetToken(this)" /><input type="button" value="Resend Token" id="${ApplicationID}" class="btn btn-primary custom-mangcomown-btn" style="display: #= IsActive == true ? "block" : "none" #" onclick="ResendToken(this)" /></td></tr></table>' }
                ]
            }).data("kendoGrid");
        }

        //Service call to check whether application name already exist.
        function CheckApplicationName() {
            if ($("#txtApplication").val() != '') {
                //var param = "/" + $("#txtApplication").val();
                //GetResponse("CheckApplicationName", param, CheckApplicationNameSuccess, Failure, ErrorHandler);

                var postData = '{"ID":"' + "0" + '","Name":"' + encodeURIComponent($.trim($("#txtApplication").val())) + '"}';
                PostRequest("CheckApplicationName", postData, CheckApplicationNameSuccess, Failure, ErrorHandler);
            }
            else {
                $("#spanApplication").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
            }
        }

        //On ajax success, validates the control and calls RegisterApplication() method.
        function CheckApplicationNameSuccess(response) {
            if (response == "1") {
                $("#spanApplication").text("Application name already exist.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
            }
            else if (response == "0") {
                $("#spanApplication").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                RegisterApplication();
            }
        }

        //Service call to register application.
        function RegisterApplication() {
            var postData = '{"ApplicationName": "' + encodeURIComponent($("#txtApplication").val()) + '", "RegisteredEmail": "' + $("#txtEmail").val() + '", "CommunityID": "' + $("#ddlCommunity").val() + '"}';
            PostRequest("RegisterApplication", postData, RegisterApplicationSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, calls ClearControls() & BindApplicationAuthenticationList() methods and success message will be showed in popup.
        function RegisterApplicationSuccess(response) {
            ClearControls('communityControls');
            $kendoJS("#ddlCommunity").data("kendoDropDownList").value(0);
            SuccessWindow('Manage API Tokens', "Saved successfully.", '#');
            BindApplicationAuthenticationList();
        }

        //Service call to activate API token.
        function ActivateToken(data) {
            var param = "/" + data.id;
            GetResponse("ActivateAPIToken", param, ActivateTokenSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, calls BindApplicationAuthenticationList() method and success message will be showed in popup.
        function ActivateTokenSuccess(response) {
            BindApplicationAuthenticationList();
            SuccessWindow('Manage API Tokens', "Your API token has been activated successfully.", '#');
        }

        //Service call to deactivate API token.
        function DeactivateToken(data) {
            var param = "/" + data.id;
            GetResponse("DeactivateAPIToken", param, DeactivateTokenSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, calls BindApplicationAuthenticationList() method and success message will be showed in popup.
        function DeactivateTokenSuccess(response) {
            BindApplicationAuthenticationList();
            SuccessWindow('Manage API Tokens', "Your API token has been deactivated successfully.", '#');
        }

        //Service call to reset API token.
        function ResetToken(data) {
            var param = "/" + data.id;
            GetResponse("ResetAPIToken", param, ResetTokenSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, calls BindApplicationAuthenticationList() method and success message will be showed in popup.
        function ResetTokenSuccess(response) {
            BindApplicationAuthenticationList();
            SuccessWindow('Manage API Tokens', "Your API token has been reset successfully.", '#');
        }

        //Service call to resend API token.
        function ResendToken(data) {
            var param = "/" + data.id + "/" + $("#lbl" + data.id).text();
            GetResponse("ResendAPIToken", param, ResendTokenSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, success message will be showed in popup.
        function ResendTokenSuccess(response) {
            SuccessWindow('Manage API Tokens', "Your API token has been resent successfully.", '#');
        }
    </script>
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Manage API Tokens</h2>
    <div class="row">
        <div class="form-horizontal col-md-12" role="form" id="communityControls">
            <hr />
            <div id="gvCommunityOwner"></div>
            <hr />
            <div class="col-md-3 form-group custom-mangcomown-margin-right">
                <input id="ddlCommunity" class="custom-dropdown-width" />
                <span id="spanCommunity" class="custom-mangcurency-validation-off"></span>
            </div>
            <div class="col-md-3 form-group custom-mangcomown-margin-right">
                <input type="text" id="txtEmail" name="txtEmail" placeholder="Email" class="form-control" maxlength="200" />
            </div>
            <div class="col-md-3 form-group custom-mangcomown-margin-right" style="margin-left: 0px;">
                <input type="text" id="txtApplication" name="txtApplication" placeholder="Application Name" class="form-control" maxlength="50" />
                <span id="spanApplication" class="custom-mangcurency-validation-off"></span>
            </div>
            <div class="col-md-2">
                <input type="button" value="Register App" id="btnAdd" class="btn btn-block btn-primary" />
            </div>
        </div>
    </div>
</asp:Content>
