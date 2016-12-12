<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="PaymentResult.aspx.cs" Inherits="RatingReviewEngine.Web.PaymentResult" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <script type="text/javascript">
        //$(document).ready(function () {
        //    window.onbeforeunload = function (e) {
        //        //$("#contentPlaceHolderBody_hdfRefresh").val('1');
        //        window.location = "ManageSupplierAccounts.aspx";
        //        return false;
        //    }
        //});
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <asp:Label ID="lblMessage" runat="server"></asp:Label>
   <%-- <asp:HiddenField ID="hdfRefresh" runat="server" />--%>
</asp:Content>
