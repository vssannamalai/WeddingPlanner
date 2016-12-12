<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="ContactUs.aspx.cs" Inherits="RatingReviewEngine.Web.ContactUs" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>
<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <style>
        .radio {
            line-height: 0.6;
        }

        .k-reset {
            font-size: 100% !important;
        }

        body {
            font-size: 14px !important;
        }

        .k-list-container {
            width: auto !important;
            min-width: 374px;
        }

        @media only screen and (min-width: 768px) and (max-width: 1024px) {
            .k-list-container {
                width: auto !important;
                min-width: 308px;
            }
        }

        .col-md-2 {
            width: 20.6667% !important;
            float: left;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            ControlValidation();
            BindTitle();
        //    $("#rbEmail").radio('check');
            ButtonClickEventOnLoad();
        });

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    txtFirstName: { required: true },
                    txtLastName: { required: true },
                    txtEmail: { required: true, email: true },
                    txtSubject: { required: true },
                    txtComments: { required: true }
                },
                messages: {
                    txtFirstName: { required: 'You can\'t leave this empty.' },
                    txtLastName: { required: 'You can\'t leave this empty.' },
                    txtEmail: { required: 'You can\'t leave this empty.', email: 'Invalid email.' },
                    txtSubject: { required: 'You can\'t leave this empty.' },
                    txtComments: { required: 'You can\'t leave this empty.' }
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

        //This method binds static values to title dropdown.
        function BindTitle() {
            $kendoJS("#ddlTitle").kendoDropDownList({
                dataTextField: "text",
                dataValueField: "value",
                index: 0,
                suggest: true,
                filter: "contains",
                dataSource: [
                    { text: "Mr", value: "Mr" },
                    { text: "Mrs", value: "Mrs" },
                    { text: "Ms", value: "Ms" },
                    { text: "Miss", value: "Miss" }
                ]
            });
        }

        //Registers a button click event on page load.
        function ButtonClickEventOnLoad() {
            $('#btnSend').click(function (e) {
                if ($("#frmRatingReviewEngine").valid()) {
                    SendMail();
                }
                e.preventDefault();
            });
        }

        function SendMail() {
            var preferredContact;
            if ($("#rbEmail").is(':checked')) {
                preferredContact = "Email";
            }
            else {
                preferredContact = "Phone";
            }

            var postData = '{"SourceSystem":"Wedding Planner Ratings & Reviews Engine", "Title":"' + $("#ddlTitle").val()
                + '", "FirstName":"' + encodeURIComponent($.trim($("#txtFirstName").val())) + '", "LastName":"' + encodeURIComponent($.trim($("#txtLastName").val()))
                + '", "Email":"' + encodeURIComponent($.trim($("#txtEmail").val())) + '", "Phone":"' + encodeURIComponent($.trim($("#txtPhone").val()))
                + '", "PreferredContact":"' + preferredContact + '", "Subject":"' + encodeURIComponent($.trim($("#txtSubject").val())) + '", "Comment":"' + encodeURIComponent($.trim($("#txtComments").val())) + '"}';

            PostRequest("SendContactMail", postData, SendMailSuccess, Failure, ErrorHandler);
        }

        function SendMailSuccess(response) {
            ClearControls('contactControls');
            BindTitle();
            $("#rbEmail").attr('checked','');
            SuccessWindow('Contact Us', 'Your feedback has been sent successfully.', '#');
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Contact Us', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window            
            ErrorWindow('Contact Us', response, '#');
        }
    </script>
</asp:Content>
<asp:Content ID="conttentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Contact Us</h2>
    <div class="row">
        <div class="form-horizontal" role="form" id="contactControls">
            <hr />
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-contact-field-label-fontstyle">Title</label>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <input id="ddlTitle" name="ddlTitle" data-role="dropdownlist" class="custom-dropdown-width" />
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-contact-field-label-fontstyle">First Name</label>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <input type="text" id="txtFirstName" class="form-control" placeholder="First Name" name="txtFirstName" maxlength="50" />
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-contact-field-label-fontstyle">Last Name</label>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <input type="text" id="txtLastName" class="form-control" placeholder="Last Name" name="txtLastName" maxlength="50" />
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-contact-field-label-fontstyle">Email</label>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <input type="text" id="txtEmail" class="form-control" placeholder="Email" name="txtEmail" maxlength="50" />
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-contact-field-label-fontstyle">Phone</label>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <input type="text" id="txtPhone" class="form-control" placeholder="Phone" name="txtPhone" maxlength="50" />
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-contact-field-label-fontstyle">Preferred Contact Method</label>
                        </div>
                    </div>
                </div>
                <div class="col-md-4" style="margin-top: 10px;">
                    <div class="form-group">
                        <input type="radio" id="rbEmail" name="group1" value="1" checked >
                        <span style="font-size: 15px" for="rbEmail">Email</span>
                        <input type="radio" id="rbPhone" name="group1" value="2" >
                        <span style="font-size: 15px" for="rbPhone">Phone</span>

                    </div>
                    <%--<div style="float: left; margin-right: 20px; margin-left: -15px">
                        <label class="radio">
                            <input id="rbEmail" type="radio" data-toggle="radio" value="1" name="group1" />
                            Email
                        </label>
                    </div>
                    <div style="float: left;">
                        <label class="radio">
                            <input id="rbPhone" type="radio" data-toggle="radio" value="2" name="group1" />
                            Phone
                        </label>
                    </div>--%>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-contact-field-label-fontstyle">Subject</label>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <input type="text" id="txtSubject" class="form-control" placeholder="Subject" name="txtSubject" maxlength="50" />
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2">
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-contact-field-label-fontstyle">Comment</label>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <textarea id="txtComments" name="txtComments" class="form-control" maxlength="250"></textarea>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-3"></div>
                <div class="col-md-2"></div>
                <div class="col-md-4">
                    <div class="form-group">
                        <input type="button" id="btnSend" value="Send" name="btnSend" class="btn btn-block btn-lg btn-primary" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
