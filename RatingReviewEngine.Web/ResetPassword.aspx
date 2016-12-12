<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="ResetPassword.aspx.cs" Inherits="RatingReviewEngine.Web.ResetPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
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
        $(document).ready(function () {
            var dt = GetQueryStringParamAsString("d");
            if (dt == undefined || dt == "") {
                window.location = "Home.aspx";
            }
            dt = Decrypted(dt);
            //var dNow = new Date();
            //var utc = new Date(dNow.getTime() + dNow.getTimezoneOffset() * 60000)
            //var utcdate = ((utc.getDate() < 10) ? '0' : '') + utc.getDate() + ' ' + ((utc.getMonth() + 1) < 10 ? '0' + (utc.getMonth() + 1) : (utc.getMonth() + 1)) + ' ' + utc.getFullYear();

            GetResponse("ValidateForgotPasswordLink", "/" + encodeURI(dt), PasswordlinkSuccess, Failure, ErrorHandler);

            //if (dt != utcdate) {
            //    ErrorWindow("Change Password", "We're sorry, but this reset code has expired. Please request a new one.", "Home.aspx");
            //    return;
            //}

        });

        function PasswordlinkSuccess(response) {
            if (response == "1") {
                ErrorWindow("Change Password", "We're sorry, but this reset code has expired. Please request a new one.", "Home.aspx");
                return;
            }
            else {
                var urlParams = GetQueryStrings();
                accountId = urlParams.id;

                if (accountId == undefined || accountId == "") {
                    window.location = "Home.aspx";
                }

                ControlValidation();
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
                $('#btnPasswordSubmit').click(function (e) {
                    if ($("#frmRatingReviewEngine").valid() && !isValid) {
                        UpdatePassword();
                    }
                    e.preventDefault();
                });

                $('#btnCancel').click(function (e) {
                    window.location = "Home.aspx";
                    e.preventDefault();
                });
            }
        }
        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {

                    txtPassword: { required: true },
                    txtVerifyPassword: { required: true, equalTo: '#txtPassword' }
                },
                messages: {
                    txtPassword: { required: 'You can\'t leave this empty.' },
                    txtVerifyPassword: { required: 'Verify your password here.', equalTo: 'Your passwords do not match.' }
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

        //This method returns the values from querystring.
        function GetQueryStrings() {
            var urlParams;
            (window.onpopstate = function () {
                var match,
                    pl = /\+/g,
                    search = /([^&=]+)=?([^&]*)/g,
                    decode = function (s) { return decodeURIComponent(s.replace(pl, " ")); },
                    query = window.location.search.substring(1);

                urlParams = {};
                while (match = search.exec(query))
                    urlParams[decode(match[1])] = decode(match[2]);
            })();

            return urlParams;
        }

        //Service call to activate user account.
        function UpdatePassword() {
            var urlParams = GetQueryStrings();
            accountId = urlParams.id;

            if (accountId != undefined && accountId != "") {
                var Provider = "General";
                var postData = '{"Provider": "' + Provider + '", "ProviderUserID": "' + accountId + '","Token":"' + $("#txtPassword").val() + '"}';
                PostRequest("ChangePassword", postData, UpdateSuccess, UpdateFailure, UpdateError);
            } else {
                FailureWindow('Change Password', 'Invalid input.', 'Home.aspx');
            }
        }

        //On ajax failure
        function UpdateFailure(response) { }

        //On ajax error
        function UpdateError(response) { }

        //On ajax success, based on response value page will be redirected.
        function UpdateSuccess(response) {
            if (response == "1")
                ErrorWindow('Change Password', 'The new password should not be same as your previous password.', '#');
            else
                SuccessWindow('Change Password', 'Your password updated successfully.', 'Home.aspx');
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Change Password', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Change Password', response, '#');
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <h2>Reset Password</h2>
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <hr />
            <div class="row text-center" id="divRegisterControls">
                <div class="col-md-4"></div>
                <div class="col-md-4">

                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">New Password</label>
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
                        <button type="submit" id="btnPasswordSubmit" value="Submit" class="btn btn-block btn-lg btn-primary">Submit</button>
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
