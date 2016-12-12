<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucMenu.ascx.cs" Inherits="RatingReviewEngine.Web.UserControl.ucMenu" %>
<%@ Register Src="~/UserControl/ucSupplierCommunityMenu.ascx" TagPrefix="uc1" TagName="ucSupplierCommunityMenu" %>

<div class="row">
    <div class="col-md-12" id="divMenu">
        <nav class="navbar navbar-default navbar-right" role="navigation">
            <div class="navbar-collapse custom-header" id="navbar-collapse-01">
                <ul class="nav navbar-nav navbar-left">
                    <li class="dropdown custom-hide" id="DynamicMenu">
                        <uc1:ucSupplierCommunityMenu runat="server" ID="ucSupplierCommunityMenu" />
                    </li>
                    <li class="dropdown" style="z-index: 9900;">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" id="AdminMenu" runat="server">Administrator Menu<b class="caret"></b></a>
                        <span class="dropdown-arrow"></span>
                        <ul class="dropdown-menu">
                            <li><a href="../ManageAPIToken.aspx">Manage API Tokens</a></li>
                            <li><a href="../ManageCurrencies.aspx">Manage Currencies</a></li>
                            <li><a href="../ManageTriggeredEvents.aspx">Manage Triggered Events</a></li>
                            <li><a href="../AdminAccount.aspx">Transaction History</a></li>
                            <li><a href="../ManageAccessRight.aspx">Manage Access Rights</a></li>
                        </ul>
                    </li>
                    <li class="dropdown" style="z-index: 9900;">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" id="CommuniyMenu" runat="server">Community Owner Menu<b class="caret"></b></a>
                        <span class="dropdown-arrow"></span>
                        <ul class="dropdown-menu">                            
                            <li><a href="../CommunityFeeManagement.aspx">Manage Fee Structures</a></li>
                            <li><a href="../CommunityRewardManagement.aspx">Manage Reward Structures</a></li>
                            <li><a href="../CommunityOwnerAccount.aspx">Manage Account</a></li>
                            <li><a href="../SupplierManagement.aspx">Manage Suppliers</a></li>
                            <li><a href="../ManageAPIToken.aspx">Manage My API Tokens</a></li>
                            <li class="divider"></li>
                            <li><a href="../CommunityOwnerDashboard.aspx">Community Dashboard</a></li>
                        </ul>
                    </li>
                    <li class="dropdown" style="z-index: 9900;">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" id="SupplierMenu" runat="server">Supplier Menu<b class="caret"></b></a>
                        <span class="dropdown-arrow"></span>
                        <ul class="dropdown-menu">
                            <li><a href="../ManageSupplierCommunities.aspx">Manage My Communities</a></li>
                            <li><a href="../ManageSupplierAccounts.aspx">Manage My Account</a></li>
                            <li><a href="../ManageSupplierCustomers.aspx">Manage My Customers</a></li>
                            <li class="divider"></li>
                            <li><a href="../SupplierDashboard.aspx">Supplier Dashboard</a></li>
                        </ul>
                    </li>
                    <li class="dropdown right" style="z-index: 9900;">
                        <a href="~/Settings.aspx" id="SettingsMenu" runat="server">Main Menu</a>
                    </li>
                </ul>
            </div>
        </nav>
    </div>
</div>
