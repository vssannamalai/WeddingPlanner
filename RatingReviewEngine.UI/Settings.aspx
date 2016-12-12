<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Settings.aspx.cs" Inherits="Settings" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>MICHAEL HILL - Settings</title>
    <!-- Loading Bootstrap -->
    <link href="bootstrap/css/bootstrap.css" rel="stylesheet" />

    <!-- Loading Flat UI -->
    <link href="css/flat-ui.css" rel="stylesheet" />

    <!-- Custom styles -->
    <style>
        .custom-settings-anchor
        {
            text-decoration: underline;
            color: #1ABC9C;
        }

        .custom-settings-logout-align
        {
            margin-left: 1000px;
        }
    </style>       
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="row demo-row">
                <div class="row demo-row ">
                    <h3>Settings</h3>
                    <div class="row demo-row">
                        <div class="col-xs-12">
                            <nav role="navigation" class="navbar navbar-inverse navbar-embossed">
                                <div id="navbar-collapse-01" class="collapse navbar-collapse">
                                    <ul class="nav navbar-nav navbar-left">
                                        <li><a>Name</a></li>
                                        <li class="custom-settings-logout-align">
                                            <a href="Login.aspx">Logout</a>                                            
                                        </li>
                                    </ul>
                                </div>
                            </nav>
                        </div>
                    </div>
                </div>
                <div class="row demo-row text-center">
                    <div class="col-xs-4"></div>
                    <div class="col-xs-4 custom-settings-anchor">
                        <div class="form-group">
                            <a href="RegisterAsCommunityOwner.aspx">Register as Community Owner</a>
                        </div>
                        <div class="form-group">
                            <a href="#">Community Owner Dashboard</a>
                        </div>
                        <div class="form-group">
                            <a href="RegisterAsSupplier.aspx">Register as Supplier</a>
                        </div>
                        <div class="form-group">
                            <a href="SupplierDashboard.aspx">Supplier Dashboard</a>
                        </div>
                        <div class="form-group">
                            <a href="#">Administrator Menu</a>
                        </div>
                    </div>
                    <div class="col-xs-4"></div>
                </div>
            </div>
        </div>
    </form>    
</body>
</html>
