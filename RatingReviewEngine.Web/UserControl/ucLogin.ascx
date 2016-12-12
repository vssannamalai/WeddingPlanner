<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucLogin.ascx.cs" Inherits="RatingReviewEngine.Web.UserControl.ucLogin" %>

<%@ Register Src="~/UserControl/ucOpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>

<style type="text/css">
    #divLoginModal {
        position: absolute;
        top: 15% !important;
    }

    @media only screen and (min-width: 768px) and (max-width: 1195px) {
        #divLoginModal {
            position: absolute;
            top: 6% !important;
        }
    }
</style>

<script type="text/javascript">
    $(document).ready(function () {
        CheckCookie();
        //LoginControlValidation();
        ButtonLoginClickEventOnLoad();
        LoginKeyPressEventOnLoad();


        $('#loginModal').on('shown.bs.modal', function () {
            $('#txtUserEmailId').focus();
        });
    });

    //Checks and retrieve values from cookie file.
    function CheckCookie() {
        if ($.cookie("un") != '' && $.cookie("pw") != '' && $.cookie("un") != undefined && $.cookie("pw") != undefined) {
            $("#txtUserEmailId").val(Decrypted($.cookie("un")));
            $("#txtPassword").val(Decrypted($.cookie("pw")));
            $("#chkRememberMe").prop('checked', true);
            $("#chkRememberMe").closest('label').addClass('checked');
        }
    }

    function EmailValidation() {
        if ($("#txtUserEmailId").val() == '') {
            $("#spanEmailValidation").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
            $("#txtUserEmailId").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
        }
        else {
            if (!validateEmail($("#txtUserEmailId").val())) {
                $("#spanEmailValidation").text('Invalid email.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                $("#txtUserEmailId").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
            }
            else {
                $("#spanEmailValidation").css('display', 'none');
                //isEmailvalid = true;
            }
        }
    }

    function PasswordValidation() {
        if ($("#txtPassword").val() == '') {
            $("#spanValidationMessage").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
            $("#txtPassword").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
        }
        else {
            $("#spanValidationMessage").css('display', 'none');
            // isPasswordValid = true;
        }
    }

    //JQuery validation for controls.
    function LoginControlValidation() {
        //$("#frmRatingReviewEngine").validate({
        //    event: "custom",
        //    rules: {
        //        txtUserEmailId: { required: true, email: true },
        //        txtPassword: { required: true }
        //    },
        //    messages: {
        //        txtUserEmailId: { required: 'You can\'t leave this empty.', email: 'Invalid email.' },
        //        txtPassword: { required: 'You can\'t leave this empty.' }
        //    },
        //    highlight: function (element) {
        //        $(element).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
        //    },
        //    unhighlight: function (element) {
        //        $(element).closest('.form-group').removeClass('form-group has-error').css('color', 'black').addClass('form-group');
        //    },
        //    onfocusout: function (element) { $(element).valid(); }
        //});

        var isEmailvalid = false;
        var isPasswordValid = false;

        if ($("#txtUserEmailId").val() == '') {
            $("#spanEmailValidation").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
            $("#txtUserEmailId").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
        }
        else {
            if (!validateEmail($("#txtUserEmailId").val())) {
                $("#spanEmailValidation").text('Invalid email.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                $("#txtUserEmailId").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
            }
            else {
                $("#spanEmailValidation").css('display', 'none');
                isEmailvalid = true;
            }
        }
        if ($("#txtPassword").val() == '') {
            $("#spanValidationMessage").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
            $("#txtPassword").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
        }
        else {
            $("#spanValidationMessage").css('display', 'none');
            isPasswordValid = true;
        }

        if (isEmailvalid && isPasswordValid)
            return true;
        else
            return false;
    }

    //Registers a button click event on page load.
    function ButtonLoginClickEventOnLoad() {
        $('#btnLogin').click(function (e) {
            //if ($("#frmRatingReviewEngine").valid()) {
            if (LoginControlValidation()) {
                Login();
            }
            e.preventDefault();
        });
    }

    function validateEmail(email) {
        var emailReg = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
        var valid = emailReg.test(email);

        if (!valid) {
            return false;
        } else {
            return true;
        }
    }

    //Registers a keypress event on page load.
    function LoginKeyPressEventOnLoad() {
        $("#txtPassword").keypress(function (e) {
            if ($("#txtPassword").is(":focus")) {
                if (e.which == 13) {    //Enter key press.
                    $("#btnLogin").click();
                }
            }
        });
    }

    //Login service call.
    function Login() {
        if ($("#txtUserEmailId").val() != "" && $("#txtPassword").val() != "") {
            var Provider = "General";
            var postData = '{"Provider": "' + Provider + '", "ProviderUserID": "' + $("#txtUserEmailId").val() + '", "Token": "' + $("#txtPassword").val() + '"}';
            $("#progress").show();
            PostRequest("Login", postData, LoginSuccess, FailureLogin, ErrorHandlerLogin);
        }
    }

    //On ajax call success, sets values to cookie and calls SetLoginSession() method.
    function LoginSuccess(response) {
        if (response.strOut == 'valid') {
            if (response.Active == true) {
                if ($("#chkRememberMe").is(':checked')) {
                    var Email = Encrypted($("#txtUserEmailId").val());
                    var Password = Encrypted($("#txtPassword").val());

                    $.cookie("un", Email, { expires: 7 });
                    $.cookie("pw", Password, { expires: 7 });
                    $.cookie("rr", true, { expires: 7 });
                }
                else {
                    $.cookie("un", '')
                    $.cookie("pw", '');
                    $.cookie("rr", false);
                }

                $("#divLogin").hide();
                $("#divRegister").hide();

                SetLoginSession(response);
            }
            else {
                $("#emailDiv").addClass("form-group has-error");
                $("#passwordDiv").addClass("form-group has-error");
                $("#spanValidationMessage").css('display', 'block');
                $("#spanValidationMessage").text("Please activate your account.").removeClass("custom-login-email-validation-off").addClass("custom-login-email-validation-on");
            }
        }
        else {
            $("#emailDiv").addClass("form-group has-error");
            $("#passwordDiv").addClass("form-group has-error");
            $("#spanValidationMessage").css('display', 'block');
            $("#spanValidationMessage").text("The email or password you entered is incorrect.").removeClass("custom-login-email-validation-off").addClass("custom-login-email-validation-on");
        }

        $("#progress").hide();
    }

    //Sets values to sessoin variables.
    function SetLoginSession(response) {
        var Provider = "General";
        var postData = "{OAuthAccountId:'" + response.OAuthAccountID + "', UserName:'" + response.UserName + "', Provider:'" + Provider + "', IsValid:'" + true + "', IsCommunityOwner:'" + response.IsCommunityOwner
            + "', IsSupplier:'" + response.IsSupplier + "', IsCustomer:'" + response.IsCustomer + "', IsAdministrator:'" + response.IsAdministrator
            + "', CommunityOwnerId:'" + response.CommunityOwnerID + "', SupplierId:'" + response.SupplierID + "', CustomerId:'" + response.CustomerID + "', AdministratorId:'" + response.AdministratorID + "',AllowedPages:'" + response.AllowedPages + "'}";
        $.ajax({
            type: "POST",
            url: $("#hdnWebUrl").val() + "SetLoginSession",
            data: postData,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                var redirect = false;
                if (response.IsCommunityOwner && response.IsSupplier) {
                    window.location = "Settings.aspx";
                    redirect = true;
                }

                if (response.IsCommunityOwner && !redirect) {
                    window.location = "CommunityOwnerDashboard.aspx";
                }

                if (response.IsSupplier && !redirect) {
                    window.location = "SupplierDashboard.aspx";
                }

                if (response.IsAdministrator && !redirect) {
                    window.location = "ManageAPIToken.aspx";
                }

                if (!response.IsCommunityOwner && !response.IsSupplier && !response.IsAdministrator && !redirect) {
                    window.location = "Settings.aspx";
                }

                $("#divLogout").removeClass("custom-hide").addClass("custom-visible");
            },
            failure: function (response) {
                console.log(response);
            },
            error: function (response) {
                console.log(response);
            }
        });
    }

    //On ajax call failure, failure message will be showed in popup.
    function FailureLogin(response) {
        $("#progress").hide();
        if ($.isEmptyObject(response)) {
            FailureWindow('Login', response, '#');
        }
    }

    //To avoid XML error in I.E (The below code wont throw 'indexOf' error in I.E.) 
    if (!String.prototype.indexOf) {
        // alert("Indec of override");
        String.prototype.indexOf = function (elt /*, from*/) {
            var len = this.length >>> 0;
            var from = Number(arguments[1]) || 0;
            from = (from < 0) ? Math.ceil(from) : Math.floor(from);
            if (from < 0) from += len;

            for (; from < len; from++) {
                if (from in this && this[from] === elt) return from;
            }
            return -1;
        };
    }

    //On ajax call error, error message will be showed in popup.
    function ErrorHandlerLogin(response) {
        $("#progress").hide();
        //Show error message in a user friendly window
        ErrorWindow('Login', response, '#');
    }

    //This method clears custom validation for email field.
    function ClearCustomValidation() {
        if ($("#txtUserEmailId").val() == "" || $("#txtPassword").val() == "")
            $("#spanValidationMessage").removeClass("custom-login-email-validation-on").addClass("custom-login-email-validation-off");
    }

    //This method clears the custom validation messages.
    function ClearLoginValidation() {
        $("#spanEmailValidation").css('display', 'none');
        $("#txtUserEmailId").closest('.form-group').removeClass('form-group has-error').css('color', 'black').addClass('form-group');
        $("#spanValidationMessage").css('display', 'none');
        $("#txtPassword").closest('.form-group').removeClass('form-group has-error').css('color', 'black').addClass('form-group');
    }

    function closepopup() {
        $('#loginModal').modal('toggle');

        $('#forgotPasswordModal').on('shown.bs.modal', function () {
            $('#txtEmailId').focus();
        })
    }
</script>

<div id="divLoginModal" class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header" style="background-color: #428BCA; color: white;">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true" id="btnClose" onclick="ClearLoginValidation()">&times;</button>
            <h4 class="modal-title" id="myModalLabel">Log in</h4>
        </div>
        <div class="modal-body">
            <div class="form-horizontal col-md-12" role="form">
                <h4>
                    <asp:Localize runat="server" ID="locLoginGeneral" Text="Use a local account to log in" meta:resourcekey="locLoginGeneralResource1" />
                </h4>
                <hr />
                <div class="col-md-12">
                    <div class="col-md-1"></div>
                    <div class="col-md-10">
                        <div class="form-group">
                            <div class="custom-field-div-textleft">
                                <label class="custom-field-label-fontstyle">Email</label>
                            </div>
                            <input id="txtUserEmailId" class="form-control" placeholder="Email" name="txtUserEmailId" maxlength="200" onkeyup="ClearCustomValidation()" autofocus />
                            <span id="spanEmailValidation" class="custom-login-email-validation-off"></span>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
                <div class="col-md-12">
                    <div class="col-md-1"></div>
                    <div class="col-md-10">
                        <div class="form-group">
                            <div class="custom-field-div-textleft">
                                <label class="custom-field-label-fontstyle">Password</label>
                            </div>
                            <input id="txtPassword" class="form-control" placeholder="Password" type="password" name="txtPassword" maxlength="12" onkeyup="ClearCustomValidation()" />
                            <span id="spanValidationMessage" class="custom-login-email-validation-off"></span>
                        </div>
                        <div class="form-group">
                            <label for="chkRememberMe" class="checkbox" style="line-height: 0.7 !important; text-align: left;">
                                <span class="icons"><span class="first-icon fui-checkbox-unchecked"></span><span class="second-icon fui-checkbox-checked"></span></span>
                                <input type="checkbox" value="" id="chkRememberMe" data-toggle="checkbox" />
                                Remember me
                            </label>
                        </div>
                        <div class="form-group">
                            <button type="submit" id="btnLogin" value="Log in" class="btn btn-block btn-lg btn-primary">Log in</button>
                        </div>
                        <div class="form-group">
                            <p class="custom-login-register-font" style="margin: 0 0 0px;">
                                <a id="fp" style="cursor: pointer" class="a" data-target="#forgotPasswordModal" onclick="closepopup()" data-toggle="modal">Forgotten your password?</a>
                            </p>
                        </div>
                        <div class="form-group">
                            <p class="custom-login-register-font"><a href="Register.aspx" class="a">Register</a> if you don't have a local account.</p>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
                <h4 class="custom-login-subtitle">
                    <asp:Localize runat="server" ID="locLoginOAuth" Text="Use another service to log in" meta:resourcekey="locLoginOAuthResource1" /></h4>
                <hr />
                <div class="col-md-12">
                    <div class="col-md-1"></div>
                    <div class="col-md-10">
                        <p>
                            <uc:OpenAuthProviders runat="server" ID="OpenAuthLogin" />
                        </p>
                    </div>
                    <div class="col-md-1"></div>
                </div>
            </div>
        </div>
        <div class="modal-footer" style="border-top: none !important;">
        </div>
    </div>
</div>
