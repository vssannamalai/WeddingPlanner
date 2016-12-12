<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="ManageScheduler.aspx.cs" Inherits="RatingReviewEngine.Web.ManageScheduler" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <h2>Manage Scheduler</h2>
    <fieldset>
        <legend>BillFree End Date Update </legend>
        <asp:Button ID="btnStart" runat="server" Text="Start" OnClick="btnStart_Click" CssClass="btn btn-primary" />
        <asp:Button ID="btnStop" runat="server" Text="Stop" OnClick="btnStop_Click" CssClass="btn btn-danger" />
    </fieldset>

</asp:Content>
