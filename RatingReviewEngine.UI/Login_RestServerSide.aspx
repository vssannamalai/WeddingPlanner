<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login_RestServerSide.aspx.cs" Inherits="Login_RestServerSide" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MICHAEL HILL - Login - Rest Server Side</title>
    <!-- Loading Bootstrap -->
    <link href="bootstrap/css/bootstrap.css" rel="stylesheet" />

    <!-- Loading Flat UI -->
    <link href="css/flat-ui.css" rel="stylesheet" />

    <!-- Custom styles -->
    <style>
        .custom-login-li-button
        {
            float: left;
            margin: 0px 0px 0px 50px;
        }

        .custom-login-li-anchor
        {
            float: left;
            margin: 0px 0px 0px 50px;
            text-decoration: underline;
            margin-top: -7px;
            color: #1ABC9C;
        }

        .custom-login-header-width
        {
            width: 50% !important;
        }

        .custom-login-checkbox-textalign
        {
            text-align: left;
        }

        .custom-login-ul-remove-bullets
        {
            list-style-type: none;
        }

        .custom-login-right-container-align
        {
            margin-left: 220px;
        }
    </style>

    <script src="js/jquery-1.8.3.min.js"></script>
    <script src="js/flatui-checkbox.js"></script>
    <script src="js/jquery.validate.min.js"></script>
    <script src="js/Cookie.js"></script>
    <script src="js/aes.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            if ($.cookie("un") != '' && $.cookie("pw") != '' && $.cookie("un") != undefined && $.cookie("pw") != undefined) {
                $("#txtEmail").val(decrypted($.cookie("un")));
                $("#txtPassword").val(decrypted($.cookie("pw")));
                $("#chkRememberMe").prop('checked', true);
                $("#chkRememberMe").closest('label').addClass('checked');
            }

            $("#loginForm").validate({

                event: "custom",

                rules: {
                    txtEmail: {
                        required: true,
                        email: true,
                    },
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
                    $(element).closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                },

                onfocusout: function (element) { jQuery(element).valid(); }

            });

        });

        function encrypted(data) {
            var key = CryptoJS.enc.Utf8.parse('9061737323313233');
            var iv = CryptoJS.enc.Utf8.parse('9061737323313233');
            var encrypted = CryptoJS.AES.encrypt(CryptoJS.enc.Utf8.parse(data), key,
                {
                    keySize: 128 / 8,
                    iv: iv,
                    mode: CryptoJS.mode.CBC,
                    padding: CryptoJS.pad.Pkcs7
                });
            return encrypted
        }

        function decrypted(data) {
            var key = CryptoJS.enc.Utf8.parse('9061737323313233');
            var iv = CryptoJS.enc.Utf8.parse('9061737323313233');
            var decrypted = CryptoJS.AES.decrypt(data, key, {
                keySize: 128 / 8,
                iv: iv,
                mode: CryptoJS.mode.CBC,
                padding: CryptoJS.pad.Pkcs7
            });
            return decrypted.toString(CryptoJS.enc.Utf8)
        }

        function SaveCookie(strLoginStatus) {

            if (strLoginStatus == 'valid') {
                if ($("#chkRememberMe").is(':checked')) {
                    var Email = encrypted($("#txtEmail").val());
                    var Password = encrypted($("#hdnPassword").val());

                    $.cookie("un", Email, { expires: 7 });
                    $.cookie("pw", Password, { expires: 7 });
                    $.cookie("rr", true, { expires: 7 });
                } else {
                    $.cookie("un", '')
                    $.cookie("pw", '');
                    $.cookie("rr", false);
                }

                window.location = "Settings.aspx";
            }
        }
    </script>
</head>
<body>
    <form id="loginForm" runat="server" autocomplete="off">
        <div class="container">
            <div class="row demo-row">
                <div class="row demo-row ">
                    <h3>Log in</h3>
                    <div class="row demo-row">
                        <div class="col-xs-12 custom-login-header-width">
                            <nav role="navigation" class="navbar navbar-inverse navbar-embossed">
                                <div id="navbar-collapse-01" class="collapse navbar-collapse">
                                    <ul class="nav navbar-nav navbar-left">
                                        <li><a>Use a local account to log in</a></li>
                                    </ul>
                                </div>
                            </nav>
                        </div>
                        <div class="col-xs-12 custom-login-header-width">
                            <nav role="navigation" class="navbar navbar-inverse navbar-embossed">
                                <div id="navbar-collapse-02" class="collapse navbar-collapse">
                                    <ul class="nav navbar-nav navbar-left">
                                        <li><a>Use another service to log in</a></li>
                                    </ul>
                                </div>
                            </nav>
                        </div>
                    </div>
                </div>
                <div class="col-xs-4">
                    <div class="form-group" id="emailDiv" runat="server">
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email"></asp:TextBox>
                    </div>
                    <div class="form-group" id="passwordDiv" runat="server">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Password" TextMode="Password"></asp:TextBox>
                        <span id="spanValidationMessage" runat="server" style="display: none;">The email or password you entered is incorrect. </span>
                    </div>
                    <div class="form-group">
                        <label for="chkRememberMe" class="checkbox custom-login-checkbox-textalign">
                            <span class="icons"><span class="first-icon fui-checkbox-unchecked"></span><span class="second-icon fui-checkbox-checked"></span></span>
                            <asp:CheckBox ID="chkRememberMe" runat="server" />
                            Remember me
                        </label>
                    </div>
                    <div class="form-group">
                        <ul class="custom-login-ul-remove-bullets">
                            <li class="custom-login-li-button">
                                <asp:Button ID="btnLogin" runat="server" Text="Log in" Style="height: 45px;" CssClass="btn btn-primary mrs" OnClick="btnLogin_Click" />
                            </li>
                            <li class="custom-login-li-anchor">
                                <h6><a href="Register.aspx">Register</a></h6>
                                <asp:HiddenField ID="hdnLoginStatus" runat="server" />
                                <asp:HiddenField ID="hdnPassword" runat="server" />
                            </li>
                        </ul>
                    </div>
                </div>
                <div class="row demo-row text-center">
                    <div class="col-xs-4 custom-login-right-container-align">
                        <div class="form-group">
                            <asp:Button ID="btnOAuth" runat="server" Text="OAuth 2.0 Provider(s)" Style="height: 45px;" CssClass="btn btn-block btn-lg btn-primary" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
