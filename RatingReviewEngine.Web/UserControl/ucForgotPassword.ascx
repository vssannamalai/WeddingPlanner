<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucForgotPassword.ascx.cs" Inherits="RatingReviewEngine.Web.UserControl.ucForgotPassword" %>

<style type="text/css">
    #divForgotPasswordModal {
        position: absolute;
        top: 15% !important;
    }

    @media only screen and (min-width: 768px) and (max-width: 1195px) {
        #divForgotPasswordModal {
            position: absolute;
            top: 6% !important;
        }
    }
</style>
<script type="text/javascript">
    $(document).ready(function () {
        $("#txtEmailId").keypress(function (e) {
            if ($("#txtEmailId").is(":focus")) {
                if (e.which == 13) {    //Enter key press.
                    $("#btnEmailSubmit").click();
                    e.preventDefault();
                }
            }
        });
        $('#btnEmailSubmit').click(function (e) {

            ChangePassword()
            e.preventDefault();
        });
       
    });

    function EmailValidation() {
        var isEmailvalid = false;
        if ($("#txtEmailId").val() == '') {
            $("#spanEmail").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
            $("#txtEmailId").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
        }
        else {
            if (!validateEmail($("#txtEmailId").val())) {
                $("#spanEmail").text('Invalid email.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                $("#txtEmailId").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
            }
            else {
                $("#txtEmailId").closest('.form-group').removeClass('form-group has-error').css('color', 'black').addClass('form-group');
                $("#spanEmail").css('display', 'none');
                isEmailvalid = true;
            }
        }
        return isEmailvalid;
    }

    function ChangePassword() {
        if (EmailValidation()) {
            var Provider = "General";
            var postData = '{"Provider": "' + Provider + '", "ProviderUserID": "' + $("#txtEmailId").val() + '"}';
            PostRequest("SendForgotPasswordEmail", postData, CheckValidUserSuccess, FailureForgotPassword, ErrorHandlerForgotPassword);

        }
    }
    function CheckValidUserSuccess(response) {
        $("#loginModal").hide();
        $("#forgotPasswordModal").hide();
        if (response == 'valid') {
            ErrorWindow('Forgot Password', 'Sorry, your email doesn’t exist in our system. Please check your email address.', 'Home.aspx');
        }
        else {
            SuccessWindow('Forgot Password', 'Your password reset request has been received and we have sent you the reset password link to your email. Please check your email to reset password.', 'Home.aspx');
        }
    }

   

    //On ajax call failure, failure message will be showed in popup.
    function FailureForgotPassword(response) {
        FailureWindow('Forgot Password', response, '#');
    }

    //On ajax call error, error message will be showed in popup.
    function ErrorHandlerForgotPassword(response) {
        //Show error message in a user friendly window
        ErrorWindow('Forgot Password', response, '#');
    }

</script>
<div id="divForgotPasswordModal" class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header" style="background-color: #428BCA; color: white;">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true" id="btnClose" onclick="ClearLoginValidation()">&times;</button>
            <h4 class="modal-title" id="myModalLabel">Forgotten your password?</h4>
        </div>
        <div class="modal-body">
            <div class="form-horizontal col-md-12" role="form">
                <p style="font-size: 14px; font-weight: bold">
                    To reset your login password enter your email below and submit. Your reset password link will be sent to you by email if your email has already been registered with us.

                </p>
                <hr />
                <div class="col-md-12">
                    <div class="col-md-1"></div>
                    <div class="col-md-10">
                        <div class="form-group">
                            <div class="custom-field-div-textleft">
                                <label class="custom-field-label-fontstyle">Email</label>
                            </div>
                            <input id="txtEmailId" class="form-control" placeholder="Email" name="txtEmailId" maxlength="200" autofocus />
                            <span id="spanEmail" class="custom-login-email-validation-off"></span>
                        </div>
                        <div class="form-group">
                            <button type="button" id="btnEmailSubmit" value="Change Password" class="btn btn-block btn-lg btn-primary">Submit</button>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
        </div>

        <div class="modal-footer" style="border-top: none !important;">
        </div>
    </div>
</div>
