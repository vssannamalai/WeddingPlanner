<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngine.Master" AutoEventWireup="true" CodeBehind="ActivateAccount.aspx.cs" Inherits="RatingReviewEngine.Web.ActivateAccount" %>
<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <script type="text/javascript" >
        $(document).ready(function () {
            ActivateAccount();
        });

        //This method returns the values from querystring.
        function GetQueryStrings() {
            var urlParams;
            (window.onpopstate = function () {
                var match,
                    pl = /\+/g,
                    search = /([^&=]+)=?([^&]*)/g,
                    decode = function (s) { return decodeURIComponent(s.replace(pl, " ")); },
                    query = window.location.search.substring(1);

                urlParams = {};
                while (match = search.exec(query))
                    urlParams[decode(match[1])] = decode(match[2]);
            })();

            return urlParams;
        }

        //Service call to activate user account.
        function ActivateAccount() {
            var urlParams = GetQueryStrings();
            accountId = urlParams.id;

            if (accountId != undefined && accountId != "") {
                var Provider = "General";
                var postData = '{"ProviderUserID": "' + accountId + '"}';
                PostRequest("ActivateAccount", postData, ActivateSuccess, ActivateFailure, ActivateError);
            } else {
                FailureWindow('Activation', 'Invalid input.', 'Home.aspx');
            }
        }
        
        //On ajax failure
        function ActivateFailure(response) { }

        //On ajax error
        function ActivateError(response) { }

        //On ajax success, based on response value page will be redirected.
        function ActivateSuccess(response) {
            if (response.ActivationMessage == 'valid') {
                SuccessWindow('Activation', 'Your account has been activated successfully. Please login to continue.', 'Home.aspx');
            } else if (response.ActivationMessage == 'invalid') {
                FailureWindow('Activation', 'Sorry, No account exist for your email id. Please register as a new user.', 'Register.aspx');
            }
        }

    </script>
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <h4 class="custom-login-subtitle">Account Activation</h4>
</asp:Content>
