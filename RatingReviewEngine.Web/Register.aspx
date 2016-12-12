<%@ Page Language="C#" MasterPageFile="~/RatingReviewEngine.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="RatingReviewEngine.Web.Register" %>

<asp:Content ID="contentHead" runat="server" ContentPlaceHolderID="contentPlaceHolderHead">
    <style>
        #passstrength {
            color: #e74c3c;
            font-size: 15px;
            font-weight: normal;
            line-height: 2.4;
            float: left;
        }
    </style>

    <script type="text/javascript">
        var isValid = false;
        var emailExist = false;

        $(document).ready(function () {
            ControlValidation();
            ButtonClickEventOnLoad();

            $('#txtPassword').keyup(function (e) {
                var strongRegex = new RegExp("^(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$", "g");
                var mediumRegex = new RegExp("^(?=.{7,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$", "g");
                var enoughRegex = new RegExp("(?=.{6,}).*", "g");
                if (false == enoughRegex.test($(this).val())) {
                    $('#passstrength').html('Minimum 6 characters!');
                    isValid = true;
                } else if (strongRegex.test($(this).val())) {
                    $('#passstrength').className = 'ok';
                    $('#passstrength').html('Strong!');
                    $('#passstrength').css('color', '#4cae4c');
                    isValid = false;
                } else if (mediumRegex.test($(this).val())) {
                    $('#passstrength').className = 'alert';
                    $('#passstrength').html('Medium!');
                    $('#passstrength').css('color', '#f0ad4e');
                    isValid = false;
                } else {
                    $('#passstrength').className = 'error';
                    $('#passstrength').html('Weak!');
                    $('#passstrength').css('color', '#d9534f');
                    isValid = false;
                }

                if ($("#txtPassword").val() == "")
                    $('#passstrength').html('');

                return true;
            });
        });

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    txtEmail: { required: true, email: true },
                    txtVerifyEmail: { required: true, email: true, equalTo: '#txtEmail' },
                    txtPassword: { required: true },
                    txtVerifyPassword: { required: true, equalTo: '#txtPassword' }
                },
                messages: {
                    txtEmail: { required: 'You can\'t leave this empty.', email: 'Invalid email.' },
                    txtVerifyEmail: { required: 'Verify your email here.', email: 'Invalid verify email.', equalTo: 'Your emails do not match.' },
                    txtPassword: { required: 'You can\'t leave this empty.' }, txtVerifyPassword: { required: 'Verify your password here.', equalTo: 'Your passwords do not match.' }
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
            $('#btnRegister').click(function (e) {
                if ($("#frmRatingReviewEngine").valid() && !isValid && !emailExist) {
                    RegisterAccount();
                }
                e.preventDefault();
            });

            $('#btnCancel').click(function (e) {
                window.location = "Home.aspx";
                e.preventDefault();
            });
        }

        //Service call to check whether the email already exist.
        function CheckValidUserID() {
            if ($("#txtEmail").val() != '') {
                var Provider = "General";
                var postData = '{"Provider": "' + Provider + '", "ProviderUserID": "' + $("#txtEmail").val() + '", "APIToken": "' + $("#hdnApplicationAPIToken").val() + '"}';
                PostRequest("CheckValidUserID", postData, CheckValidUserSuccess, Failure, ErrorHandler);
            }
        }

        //On ajax call success, checks for valid or invalid from response.
        function CheckValidUserSuccess(response) {
            if (response == 'invalid') {
                $("#txtEmail").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#spanEmail").text('Email already exist.').css('display', 'block');
                emailExist = true;
            }
            else {
                $("#spanEmail").text('').css('display', 'none');
                emailExist = false;
            }
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Registration', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Registration', response, '#');
        }

        //New register service call.
        function RegisterAccount() {
            var Provider = "General";
            var postData = '{"Provider": "' + Provider + '", "ProviderUserID": "' + $("#txtEmail").val() + '", "Token": "' + $("#txtPassword").val() + '"}';
            PostRequest("RegisterAccount", postData, RegisterAccountSuccess, Failure, ErrorHandler);
        }

        //New register service success.
        function RegisterAccountSuccess(response) {
            var emailId = $("#txtEmail").val();
            ClearControls('divRegisterControls');
            SuccessWindow('Registration', 'Registered successfully. <br />An email has been sent to <b>' + emailId + '</b>. Open this email to activate your account.', 'Home.aspx');
        }
    </script>
</asp:Content>

<asp:Content ID="contentBody" runat="server" ContentPlaceHolderID="contentPlaceHolderBody">
    <h2>Register an Account</h2>
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <hr />
            <div class="row text-center" id="divRegisterControls">
                <div class="col-md-4"></div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Email</label>
                        </div>
                        <input id="txtEmail" class="form-control" placeholder="Email" onblur="CheckValidUserID()" name="txtEmail" maxlength="200" />
                        <span id="spanEmail" class="custom-register-email-span"></span>
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Verify Email</label>
                        </div>
                        <input id="txtVerifyEmail" class="form-control" placeholder="Verify Email" name="txtVerifyEmail" maxlength="200" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Password</label>
                        </div>
                        <input id="txtPassword" class="form-control" placeholder="Password" type="password" name="txtPassword" maxlength="12" />
                        <span id="passstrength"></span>
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Verify Password</label>
                        </div>
                        <input id="txtVerifyPassword" class="form-control" placeholder="Verify Password" type="password" name="txtVerifyPassword" maxlength="12" />
                    </div>
                    <div class="form-group">
                        <button type="submit" id="btnRegister" value="Register" class="btn btn-block btn-lg btn-primary">Register</button>
                    </div>
                    <div class="form-group">
                        <button type="submit" id="btnCancel" value="Cancel" class="btn btn-block btn-lg btn-default">Cancel</button>
                    </div>
                </div>
                <div class="col-md-4"></div>
            </div>
        </div>
    </div>
</asp:Content>
