<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RegisterAsCommunityOwner.aspx.cs" Inherits="RegisterAsCommunityOwner" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MICHAEL HILL - Register as Community Owner</title>
    <!-- Loading Bootstrap -->
    <link href="bootstrap/css/bootstrap.css" rel="stylesheet" />

    <!-- Loading Flat UI -->
    <link href="css/flat-ui.css" rel="stylesheet" />

    <!-- Custom styles -->
    <style> 

       
    </style>

    <script src="js/jquery-1.8.3.min.js"></script>
    <script src="js/jquery.validate.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#registerOwnerForm").validate({

                event: "custom",

                rules: {
                    txtBusinessName: { required: true },
                    txtEmail: { required: true, email: true },
                    txtPrimaryPhone: { required: true },
                    txtBusinessNumber: { required: true }
                },

                messages: {
                    txtBusinessName: { required: 'You can\'t leave this empty.' },
                    txtEmail: { required: 'You can\'t leave this empty.', email: 'Invalid email.' },
                    txtPrimaryPhone: { required: 'You can\'t leave this empty.' },
                    txtBusinessNumber: { required: 'You can\'t leave this empty.' }
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

    </script>
</head>
<body>
    <form id="registerOwnerForm" runat="server">
        <div class="container">
            <div class="row demo-row">
                <div class="row demo-row ">
                    <h3>Register as Community Owner</h3>
                    <div class="row demo-row">
                        <div class="col-xs-12">
                            <nav role="navigation" class="navbar navbar-inverse navbar-embossed">
                                <div id="navbar-collapse-01" class="collapse navbar-collapse">
                                    <ul class="nav navbar-nav navbar-left">
                                        <li><a>Register as Community Owner</a></li>
                                    </ul>
                                </div>
                            </nav>
                        </div>
                    </div>
                </div>
                <div class="row demo-row text-center">
                    <div class="col-xs-4">
                        <div class="form-group">
                            <asp:TextBox ID="txtBusinessName" runat="server" class="form-control" placeholder="Business Name"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtEmail" runat="server" class="form-control" placeholder="Email"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtPrimaryPhone" runat="server" class="form-control" placeholder="Primary Phone"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtOtherPhone" runat="server" class="form-control" placeholder="Other Phone"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtBusinessNumber" runat="server" class="form-control" placeholder="Business Number"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtWebsite" runat="server" class="form-control" placeholder="Website"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="row demo-row ">
                    <div class="row demo-row">
                        <div class="col-xs-12">
                            <nav role="navigation" class="navbar navbar-inverse navbar-embossed">
                                <div id="Div1" class="collapse navbar-collapse">
                                    <ul class="nav navbar-nav navbar-left">
                                        <li><a>Address</a></li>
                                    </ul>
                                </div>
                            </nav>
                        </div>
                        <div class="col-xs-12">
                            <nav role="navigation" class="navbar navbar-inverse navbar-embossed">
                                <div id="navbar-collapse-02" class="collapse navbar-collapse">
                                    <ul class="nav navbar-nav navbar-left">
                                        <li><a>Billing Address</a></li>
                                    </ul>
                                </div>
                            </nav>
                        </div>
                    </div>
                </div>
                <div class="row demo-row text-center">
                    <div class="col-xs-4">
                        <div class="form-group">
                            <asp:TextBox ID="txtAddress1" runat="server" class="form-control" placeholder="Addr 1"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtAddress2" runat="server" class="form-control" placeholder="Addr 2"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtCity" runat="server" class="form-control" placeholder="City"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtState" runat="server" class="form-control" placeholder="State"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtPostalCode" runat="server" class="form-control" placeholder="Postal Code"></asp:TextBox>
                        </div>
                        <br /><br />
                        <div class="dropdown">
                            <asp:DropDownList ID="ddlCountry" runat="server" CssClass="btn btn-primary dropdown-toggle" data-toggle="dropdown">
                                <asp:ListItem>Country</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="col-xs-4">
                        <div class="form-group">
                            <asp:TextBox ID="txtBillingName" runat="server" class="form-control" placeholder="Billing Name"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtBillingAddress1" runat="server" class="form-control" placeholder="Billing Addr 1"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtBillingAddress2" runat="server" class="form-control" placeholder="Billing Addr 2"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtBillingCity" runat="server" class="form-control" placeholder="Billing City"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtBillingState" runat="server" class="form-control" placeholder="Billing State"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtBillingPostalCode" runat="server" class="form-control" placeholder="Billing Postal Code"></asp:TextBox>
                        </div>
                        <br /><br />
                        <div class="dropdown">
                            <asp:DropDownList ID="ddlBillingCountry" runat="server" CssClass="btn btn-primary dropdown-toggle" data-toggle="dropdown">
                                <asp:ListItem>Country</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="row demo-row ">
                    <div class="row demo-row text-center">
                        <div class="col-xs-4"></div>
                        <div class="col-xs-4">
                            <div class="form-group">
                                <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-block btn-lg btn-primary" OnClick="btnRegister_Click" />
                            </div>
                        </div>
                        <div class="col-xs-4"></div>
                    </div>
                </div>
            </div>
        </div>
    </form>    
</body>
</html>
