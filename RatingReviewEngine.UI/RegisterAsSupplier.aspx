<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RegisterAsSupplier.aspx.cs" Inherits="RegisterAsSupplier" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MICHAEL HILL - Register as Supplier</title>
    <!-- Loading Bootstrap -->
    <link href="bootstrap/css/bootstrap.css" rel="stylesheet" />

    <!-- Loading Flat UI -->
    <link href="css/flat-ui.css" rel="stylesheet" />

    <!-- Custom styles -->
    <style>
        .custom-regsupplier-header-width
        {
            width: 50% !important;
        }

        .custom-regsupplier-state-control
        {
            float: left;
            width: 170px;
        }

        .custom-regsupplier-postalcode-control
        {
            float: left;
            width: 170px;
            margin-left: 30px;
        }

        .custom-regsupplier-country-control
        {
            width: 368px;
            text-align: left !important;
        }

        .custom-regsupplier-right-container-align
        {
            margin-left: 220px;
        }

        .prev_container
        {
            overflow: auto;
            width: 300px;
            height: 175px;
        }

        .prev_thumb
        {
            margin: 10px;
            height: 152px;
        }
    </style>
</head>
<body>
    <form id="registerSupplierForm" runat="server">
        <div class="container">
            <div class="row demo-row">
                <div class="row demo-row ">
                    <h3>Register as Supplier</h3>
                    <div class="row demo-row">
                        <div class="col-xs-12">
                            <nav role="navigation" class="navbar navbar-inverse navbar-embossed">
                                <div id="navbar-collapse-01" class="collapse navbar-collapse">
                                    <ul class="nav navbar-nav navbar-left">
                                        <li><a>Register as Supplier</a></li>
                                    </ul>
                                </div>
                            </nav>
                        </div>
                    </div>
                </div>
                <div class="row demo-row text-center">
                    <div class="col-xs-4">
                        <div class="form-group">
                            <asp:TextBox ID="txtSupplierName" runat="server" class="form-control" placeholder="Supplier Name"></asp:TextBox>
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
                    <div class="col-xs-4 custom-regsupplier-right-container-align">
                        <div class="demo-type-example" style="height: 120px;">
                            <span class="demo-text-note" style="float: left;">Logo</span>
                            <asp:Image ID="imgLogo" runat="server" CssClass="img-rounded img-responsive" ImageUrl="~/images/example-image.jpg" Height="100" Width="100" Style="float: right;" />
                        </div>
                        <div class="demo-type-example" style="height: 210px;">
                            <span class="demo-text-note" style="float: left;">Icon</span>
                            <asp:Image ID="Image1" runat="server" CssClass="img-rounded img-responsive" ImageUrl="~/images/example-image.jpg" Height="100" Width="100" Style="float: right;" />
                            <%--<div id="prev_file1">
                            </div>
                            <input class="icon" id="file1" name="file1" type='file' title="Icon" runat="server" />--%>                            
                        </div>
                    </div>
                </div>
                <div class="row demo-row ">
                    <div class="row demo-row">
                        <div class="col-xs-12 custom-regsupplier-header-width">
                            <nav role="navigation" class="navbar navbar-inverse navbar-embossed">
                                <div id="navbar-collapse-02" class="collapse navbar-collapse">
                                    <ul class="nav navbar-nav navbar-left">
                                        <li><a>Address</a></li>
                                    </ul>
                                </div>
                            </nav>
                        </div>
                        <div class="col-xs-12 custom-regsupplier-header-width">
                            <nav role="navigation" class="navbar navbar-inverse navbar-embossed">
                                <div id="navbar-collapse-03" class="collapse navbar-collapse">
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
                            <asp:TextBox ID="txtState" runat="server" class="form-control custom-regsupplier-state-control" placeholder="State"></asp:TextBox><asp:TextBox ID="txtPostalCode" runat="server" class="form-control custom-regsupplier-postalcode-control" placeholder="Postal Code"></asp:TextBox>
                        </div>
                        <div class="form-group">
                        </div>
                        <br />
                        <br />
                        <div class="dropdown">
                            <button class="btn btn-primary dropdown-toggle custom-regsupplier-country-control" data-toggle="dropdown">Country<span class="caret" style="margin-left: 270px;"></span></button>
                            <span class="dropdown-arrow dropdown-arrow-inverse"></span>
                            <ul class="dropdown-menu dropdown-inverse" style="width: 360px; text-align: left !important;">
                                <li><a href="#fakelink">Sub Menu Element</a></li>
                                <li><a href="#fakelink">Sub Menu Element</a></li>
                                <li><a href="#fakelink">Sub Menu Element</a></li>
                            </ul>
                        </div>
                    </div>

                    <div class="col-xs-4 custom-regsupplier-right-container-align">
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
                            <asp:TextBox ID="txtBillingState" runat="server" class="form-control custom-regsupplier-state-control" placeholder="Billing State"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:TextBox ID="txtBillingPostalCode" runat="server" class="form-control custom-regsupplier-postalcode-control" placeholder="Billing Postal Code"></asp:TextBox>
                        </div>
                        <br />
                        <br />
                        <div class="form-group">
                            <div class="dropdown">
                                <button class="btn btn-primary dropdown-toggle custom-regsupplier-country-control" data-toggle="dropdown">Billing Country<span class="caret" style="margin-left: 237px;"></span></button>
                                <span class="dropdown-arrow dropdown-arrow-inverse"></span>
                                <ul class="dropdown-menu dropdown-inverse" style="width: 368px; text-align: left !important;">
                                    <li><a href="#fakelink">Sub Menu Element</a></li>
                                    <li><a href="#fakelink">Sub Menu Element</a></li>
                                    <li><a href="#fakelink">Sub Menu Element</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row demo-row" style="height: 250px;">
                    <div class="row demo-row text-center">
                        <div class="demo-type-example" style="height: 120px;">
                            <span class="demo-text-note">Location Map</span>
                            <asp:Image ID="imgLocation" runat="server" CssClass="img-rounded img-responsive" ImageUrl="~/images/example-image.jpg" Height="200" Width="200" Style="margin-left: 500px;" />
                        </div>
                    </div>
                </div>
                <div class="row demo-row">
                    <div class="row demo-row text-center">
                        <div class="col-xs-4"></div>
                        <div class="col-xs-4">
                            <div class="form-group">
                                <asp:Button ID="btnRegister" runat="server" Text="Register" Style="height: 45px;" CssClass="btn btn-block btn-lg btn-primary" />
                            </div>
                        </div>
                        <div class="col-xs-4"></div>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <script src="js/jquery-1.8.3.min.js"></script>
    <script src="js/jquery.validate.min.js"></script>
    <%--<script src="js/jquery.preimage.js"></script>--%>
    <script type="text/javascript">
        $(document).ready(function () {

            $("#registerSupplierForm").validate({

                event: "custom",

                rules: {
                    txtSupplierName: { required: true },
                    txtEmail: { required: true, email: true },
                    txtAddress1: { required: true },
                    txtCity: { required: true },
                    txtState: { required: true }
                },

                messages: {
                    txtSupplierName: { required: 'You can\'t leave this empty.' },
                    txtEmail: { required: 'You can\'t leave this empty.', email: 'Invalid email.' },
                    txtAddress1: { required: 'You can\'t leave this empty.' },
                    txtCity: { required: 'You can\'t leave this empty.' },
                    txtState: { required: 'You can\'t leave this empty.' }
                },

                highlight: function (element) {
                    $(element).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                },

                unhighlight: function (element) {
                    $(element).closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                },

                onfocusout: function (element) { jQuery(element).valid(); }

            });


            ////$('.icon').preimage();
        });

    </script>
</body>
</html>
