<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MICHAEL HILL - Register</title>
    <!-- Loading Bootstrap -->
    <link href="bootstrap/css/bootstrap.css" rel="stylesheet" />

    <!-- Loading Flat UI -->
    <link href="css/flat-ui.css" rel="stylesheet" />

    <style>
        .custom-register-email-span
        {
            display: none;
            font-size: 15px;
            font-weight: normal;
            line-height: 2.4;
        }        
    </style>

    <script src="js/jquery-1.8.3.min.js"></script>
    <script src="js/jquery.validate.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#form1").validate({

                event: "custom",

                rules: {
                    txtEmail: {
                        required: true,
                        email: true
                    },
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
                    $(element).closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                },

                onfocusout: function (element) { jQuery(element).valid(); }

            });

        });

        function CheckValidUserID() {
            if ($("#txtEmail").val() != '') {
                $.ajax({
                    type: 'POST',
                    url: 'Register.aspx/CheckValidUserID',
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    data: '{"strProvider": "General", "strProviderUserId": "' + $("#txtEmail").val() + '"}',
                    success: function (response) {
                        if (response.d == 'invalid') {
                            $(txtEmail).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                            $("#spanEmail").text('Email already exist.').css('display', 'block');
                        }
                        else {
                            $("#spanEmail").text('').css('display', 'none');
                        }
                    },
                    failure: function (response) {
                        console.log(response);
                    },
                    error: function (response) {
                        console.log(response);
                    }
                });
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="row demo-row">
                <div class="row demo-row ">
                    <h3>Register</h3>
                    <div class="row demo-row">
                        <div class="col-xs-12">
                            <nav role="navigation" class="navbar navbar-inverse navbar-embossed">
                                <div id="navbar-collapse-01" class="collapse navbar-collapse">
                                    <ul class="nav navbar-nav navbar-left">
                                        <li><a>Register an Account</a></li>
                                    </ul>
                                </div>
                            </nav>
                        </div>
                    </div>
                </div>
                <div class="row demo-row text-center">
                    <div class="col-xs-4"></div>
                    <div class="col-xs-4">
                        <div class="form-group">
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email" onblur="CheckValidUserID()"></asp:TextBox>
                            <span id="spanEmail" class="custom-register-email-span"></span>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtVerifyEmail" runat="server" CssClass="form-control" placeholder="Verify Email"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Password" TextMode="Password"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtVerifyPassword" runat="server" CssClass="form-control" placeholder="Verify Password" TextMode="Password"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-block btn-lg btn-primary" OnClick="btnRegister_Click" />
                        </div>
                    </div>
                    <div class="col-xs-4"></div>
                </div>
            </div>
        </div>
    </form>    
</body>
</html>
