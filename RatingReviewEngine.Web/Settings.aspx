<%@ Page Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="RatingReviewEngine.Web.Settings" %>

<asp:Content ID="contentHead" runat="server" ContentPlaceHolderID="contentPlaceHolderHead">
</asp:Content>
<asp:Content ID="contentBody" runat="server" ContentPlaceHolderID="contentPlaceHolderBody">
    <h2>Main Menu</h2>
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <hr />
            <div class="row text-center">
                <div class="col-md-4"></div>
                <div class="col-md-4">
                    <div class="form-group" runat="server" id="lblRegisterCommunityOwner">
                        <a href="RegisterAsCommunityOwner.aspx" class="custom-settings-anchor">Register as Community Owner</a>
                    </div>
                    <div class="form-group" runat="server" id="lblCommunityOwnerDashboard">
                        <a href="CommunityOwnerDashboard.aspx" class="custom-settings-anchor">Community Owner Dashboard</a>
                    </div>
                    <div class="form-group" runat="server" id="lblRegisterSupplier">
                        <a href="RegisterAsSupplier.aspx" class="custom-settings-anchor">Register as Supplier</a>
                    </div>
                    <div class="form-group" runat="server" id="lblSupplierDashboard">
                        <a href="SupplierDashboard.aspx" class="custom-settings-anchor">Supplier Dashboard</a>
                    </div>
                    <div class="form-group" runat="server" id="lblAdministratorMenu">
                        <a href="AdminSettings.aspx" class="custom-settings-anchor">Administrator Menu</a>
                    </div>
                </div>
                <div class="col-md-4"></div>
            </div>
        </div>
    </div>
</asp:Content>
