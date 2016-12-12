<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="AdminSettings.aspx.cs" Inherits="RatingReviewEngine.Web.AdminSettings" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <h2>Administrator Menu</h2>
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <hr />
            <div class="row text-center">
                <div class="col-md-4"></div>
                <div class="col-md-4">
                    <div class="form-group">
                        <a href="ManageAPIToken.aspx" class="custom-settings-anchor">Manage API Tokens</a>
                    </div>
                    <div class="form-group">
                        <a href="ManageCurrencies.aspx" class="custom-settings-anchor">Manage Currencies</a>
                    </div>
                    <div class="form-group">
                        <a href="ManageTriggeredEvents.aspx" class="custom-settings-anchor">Manage Triggered Events</a>
                    </div>
                    <div class="form-group">
                        <a href="AdminAccount.aspx" class="custom-settings-anchor">Transaction History</a>
                    </div>
                    <div class="form-group">
                        <a href="ManageAccessRight.aspx" class="custom-settings-anchor">Manage Access Rights</a>
                    </div>
                    <div class="form-group">
                        <a href="Settings.aspx" class="custom-settings-anchor">Return to Main Menu</a>
                    </div>
                </div>
                <div class="col-md-4"></div>
            </div>
        </div>
    </div>
</asp:Content>
