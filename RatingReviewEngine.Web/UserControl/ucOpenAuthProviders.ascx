<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucOpenAuthProviders.ascx.cs" Inherits="RatingReviewEngine.Web.UserControl.ucOpenAuthProviders" %>
<link href="../css/font-awesome.min.css" rel="stylesheet" />

<script>
    $(document).ready(function () {
        $("#btntwitter").addClass('btn btn-info');
        $("#btnfacebook").addClass('btn btn-inverse');
        $("#btngoogle").addClass('btn btn-danger');

        $("#twitter").addClass('fa fa-twitter');
        $("#facebook").addClass('fa fa-facebook');
        $("#google").addClass('fa fa-google-plus');
    });

    function cancelValidate()
    {
        $("#frmRatingReviewEngine").validate().cancelSubmit = true;
    }
</script>

<fieldset class="open-auth-providers" style="text-align: center;">
    <asp:ListView runat="server" ID="providerDetails" ItemType="Microsoft.AspNet.Membership.OpenAuth.ProviderDetails"
        SelectMethod="GetProviderNames" ViewStateMode="Disabled">
        <ItemTemplate>
            <button id="btn<%#: Item.ProviderName %>" type="submit" name="provider" style="height: 41px;" class="cancel" value="<%#: Item.ProviderName %>" title="Log in using your <%#: Item.ProviderDisplayName %> account." onclick="cancelValidate()">
                <i id="<%#: Item.ProviderName %>">&nbsp;&nbsp;<%#: Item.ProviderDisplayName %></i>
            </button>
        </ItemTemplate>
        <EmptyDataTemplate>
            <div class="message-info">
                <p>There are no external authentication services configured. See <a href="http://go.microsoft.com/fwlink/?LinkId=252803">this article</a> for details on setting up this ASP.NET application to support logging in via external services.</p>
            </div>
        </EmptyDataTemplate>
    </asp:ListView>
</fieldset>
