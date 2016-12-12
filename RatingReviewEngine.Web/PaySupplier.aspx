<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="PaySupplier.aspx.cs" Inherits="RatingReviewEngine.Web.PaySupplier" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <script type="text/javascript">
        function testPayPal() {
            $.ajax({
                type: "POST",
                url: "https://www.sandbox.paypal.com/webapps/auth/protocol/openidconnect/v1/authorize?client_id={AU-VRBDWsjMyWspioRIHn47c2XKlqLomG1SxPrnhaIuMB5XEusaXCLTBdOkx}&response_type=code&scope=profile+email+address+phone+https%3A%2F%2Furi.paypal.com%2Fservices%2Fpaypalattributes&redirect_uri=https://localhost:44301/PaySupplier.aspx",
                withCredentials: true,
                contentType: "text/json; charset=utf-8",
                dataType: "json",
               
                success: function (response) {
                    alert(response);
                },
                failure: function (response) {
                    alert('failure');
                },
                error: function (response) {
                    alert(response);
                }
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <h2>Pay Supplier</h2>
    <div class="row">
        <div class="col-md-12">
            <div class="form-group">
                Supplier:<label id="lblSupplierName"></label>
            </div>
            <div class="form-group">
                Customer:<label id="lblCustomerName"></label>
            </div>
            <div class="form-group">
                Community:<label id="lblCommunityName"></label>
            </div>
        </div>
        <div class="col-md-12">
            <div class="form-group">
                Quote Ref:<label id="lblQuoteId"></label>

            </div>
            <div class="form-group">
                Detail:<label id="lblDetail"></label>
            </div>
            <div class="form-group">
                Amount:<input type="text" id="txtAmount" />
            </div>
            <div class="form-group">
                Payment Method<br />
                <input type="radio" value="PayPal" name="paymentMethod" /><label>PayPal</label><br />
                <input type="radio" value="Credit Card" name="paymentMethod" /><label>Credit Card</label>
            </div>
            <div class="form-group">
                Name on Card
                <input type="text" id="txtName" />

            </div>
            <div class="form-group">
                Card Type
                <select>
                    <option value="VISA">VISA</option>
                    <option value="MasterCard">MasterCard</option>
                    <option value="American Express">American Express</option>
                </select>
            </div>
            <div class="form-group">
                Expiry
                <select>
                    <option value="1">Jan</option>
                    <option value="2">Feb</option>
                </select>
                <select>
                    <option value="2014">2014</option>
                    <option value="2015">2015</option>
                </select>
            </div>
            <div class="form-group">
                Security Code
                <input type="text" id="txtSecurityCode" />
            </div>
            <div class="form-group">
                <input type="button" value="Process Payment" onclick="testPayPal()" />
            </div>
        </div>
    </div>
</asp:Content>
