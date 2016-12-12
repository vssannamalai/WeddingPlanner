<%@ Page Language="C#" MasterPageFile="~/RatingReviewEngine.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="RatingReviewEngine.Web.Login" culture="auto" meta:resourcekey="PageResource1" uiculture="auto" %>

<%@ Register Src="~/UserControl/ucOpenAuthProviders.ascx" TagPrefix="uc" TagName="OpenAuthProviders" %>

<asp:Content ID="contentHead" runat="server" ContentPlaceHolderID="contentPlaceHolderHead">
    <script type="text/javascript">
        $(document).ready(function () {
            CheckCookie();
            ControlValidation();
            ButtonClickEventOnLoad();
            KeyPressEventOnLoad();
        });

        //Checks and retrieve values from cookie file.
        function CheckCookie() {
            if ($.cookie("un") != '' && $.cookie("pw") != '' && $.cookie("un") != undefined && $.cookie("pw") != undefined) {
                $("#txtEmail").val(Decrypted($.cookie("un")));
                $("#txtPassword").val(Decrypted($.cookie("pw")));
                $("#chkRememberMe").prop('checked', true);
                $("#chkRememberMe").closest('label').addClass('checked');
            }
        }

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    txtEmail: { required: true, email: true },
                    txtPassword: { required: true }
                },
                messages: {
                    txtEmail: { required: 'You can\'t leave this empty.', email: 'Invalid email.' },
                    txtPassword: { required: 'You can\'t leave this empty.' }
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
            $('#btnLogin').click(function (e) {
                if ($("#frmRatingReviewEngine").valid()) {
                    Login();
                }
                e.preventDefault();
            });
        }

        //Registers a keypress event on page load.
        function KeyPressEventOnLoad() {
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
            if ($("#txtEmail").val() != "" && $("#txtPassword").val() != "") {
                var Provider = "General";
                var postData = '{"Provider": "' + Provider + '", "ProviderUserID": "' + $("#txtEmail").val() + '", "Token": "' + $("#txtPassword").val() + '"}';
                $("#progress").show();
                PostRequest("Login", postData, LoginSuccess, Failure, ErrorHandler);
            }
        }

        //On ajax call success, sets values to cookie and calls SetLoginSession() method.
        function LoginSuccess(response) {
            if (response.strOut == 'valid') {
                if (response.Active == true) {
                    if ($("#chkRememberMe").is(':checked')) {
                        var Email = Encrypted($("#txtEmail").val());
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

                    SetLoginSession(response);
                }
                else {
                    $("#emailDiv").addClass("form-group has-error");
                    $("#passwordDiv").addClass("form-group has-error");
                    $("#spanValidationMessage").text("Please activate your account.").removeClass("custom-login-email-validation-off").addClass("custom-login-email-validation-on");
                }
            }
            else {
                $("#emailDiv").addClass("form-group has-error");
                $("#passwordDiv").addClass("form-group has-error");
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
        function Failure(response) {
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
        function ErrorHandler(response) {
            $("#progress").hide();
            //Show error message in a user friendly window
            ErrorWindow('Login', response, '#');
        }

        //This method clears custom validation for email field.
        function ClearCustomValidation() {
            if ($("#txtEmail").val() == "" || $("#txtPassword").val() == "")
                $("#spanValidationMessage").removeClass("custom-login-email-validation-on").addClass("custom-login-email-validation-off");
        }
    </script>
</asp:Content>

<asp:Content ID="contentBody" runat="server" ContentPlaceHolderID="contentPlaceHolderBody">
    <h2><asp:Localize runat="server"  ID="locLoginHead" Text="Log in" meta:resourcekey="locLoginHeadResource1" /> </h2>
     
    <div class="row">
        <div class="form-horizontal col-md-6" role="form">
            <h4><asp:Localize runat="server"  ID="locLoginGeneral" Text="Use a local account to log in" meta:resourcekey="locLoginGeneralResource1" /> </h4>
            <hr />
            <div class="col-md-8">
                <div class="form-group">
                    <div class="custom-field-div-textleft">
                        <label class="custom-field-label-fontstyle">Email</label>
                    </div>
                    <input id="txtEmail" class="form-control" placeholder="Email" name="txtEmail" maxlength="200" onkeyup="ClearCustomValidation()" />
                </div>
                <div class="form-group">
                    <div class="custom-field-div-textleft">
                        <label class="custom-field-label-fontstyle">Password</label>
                    </div>
                    <input id="txtPassword" class="form-control" placeholder="Password" type="password" name="txtPassword" maxlength="12" onkeyup="ClearCustomValidation()" />
                    <span id="spanValidationMessage" class="custom-login-email-validation-off"></span>
                </div>
                <div class="form-group">
                    <label for="chkRememberMe" class="checkbox custom-checkbox-textalign">
                        <span class="icons"><span class="first-icon fui-checkbox-unchecked"></span><span class="second-icon fui-checkbox-checked"></span></span>
                        <input type="checkbox" value="" id="chkRememberMe" data-toggle="checkbox" />
                        Remember me
                    </label>
                </div>
                <div class="form-group">
                    <button type="submit" id="btnLogin" value="Log in" class="btn btn-block btn-lg btn-primary">Log in</button>
                </div>
                <div class="form-group">
                    <p class="custom-login-register-font"><a href="Register.aspx" class="a">Register</a> if you don't have a local account.</p>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <h4 class="custom-login-subtitle"><asp:Localize runat="server"  ID="locLoginOAuth" Text="Use another service to log in" meta:resourcekey="locLoginOAuthResource1" /></h4>
            <hr />
            <p>
                <uc:OpenAuthProviders runat="server" ID="OpenAuthLogin" />
            </p>
        </div>
    </div>
</asp:Content>
