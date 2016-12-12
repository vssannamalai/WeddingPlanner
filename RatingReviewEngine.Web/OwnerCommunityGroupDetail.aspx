<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="OwnerCommunityGroupDetail.aspx.cs" Inherits="RatingReviewEngine.Web.OwnerCommunityGroupDetail" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <style>
        .k-reset {
            font-size: 88% !important;
        }

        .k-header {
            color: White;
            background-color: #34495E;
            font-size: 16px;
        }

        .k-label {
            font-size: 15px;
        }

        #tbody, tr {
            line-height: 1.42857;
            vertical-align: top;
            font-size: 15px;
        }

        .mapDisable {
            z-index: -1;
        }
    </style>
    <script type="text/javascript">
        var isValid = false;
        $(document).ready(function () {
            if (GetQueryStringParams('cid') == null || GetQueryStringParams('gid') == null) {
                ErrorWindow('Community Group Detail', "No data found", 'Nodata.aspx');
                return;
            }
            BindActiveDropDown();
            KeyDownEventOnLoad();
            GetCommunityGroupDetail()
            GetCommunityGroupSummary();
            ButtonClickEventOnLoad();
            SetPageNavigation();
            BindMenu();

            $('#txtCreditMin').blur(function () {
                var val = this.value;
                if (val != '') {
                    if (DecimalValidation(val)) {
                        $("#spanCreditMin").text('').css('display', 'none');
                        $("#txtCreditMin").closest('.form-group').removeClass('form-group has-error').addClass('form-group');

                        isValid = false;
                    }
                    else {

                        // this.value = '';
                        $("#txtCreditMin").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                        $("#spanCreditMin").text('Please enter a valid Min credit value.').css('display', 'block').css('color', '#E74C3C');
                        isValid = true;
                    }
                }
                else {
                    $("#spanCreditMin").text('').css('display', 'none');
                    $("#txtCreditMin").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                    isValid = false;
                }
            });

        });

        //Initializes dropdown on page load with static data.
        function BindActiveDropDown() {
            $kendoJS("#ddlActive").kendoDropDownList({
                dataTextField: "text",
                dataValueField: "value",
                index: 0,
                suggest: true,
                filter: "contains",
                dataSource: [
                    { text: "Active", value: "true" },
                    { text: "Inactive", value: "false" }
                ]
            });
        }

        //Registers a keyDown event on page load.
        function KeyDownEventOnLoad() {
            $('input[name="txtCreditMin"]').keydown(function (e) {
                AllowDecimal(e);
            });
        }

        //Registers a button click event on page load.
        function ButtonClickEventOnLoad() {
            $("#btnManageFee").click(function () {
                window.location = "/CommunityFeeManagement.aspx?cid=" + Encrypted(GetQueryStringParams('cid')) + "&gid=" + Encrypted(GetQueryStringParams('gid'));
            });

            $("#btnManageReward").click(function () {
                window.location = "/CommunityRewardManagement.aspx?cid=" + Encrypted(GetQueryStringParams('cid')) + "&gid=" + Encrypted(GetQueryStringParams('gid'));
            });
        }

        //Service call to fetch community group detail based on query string value.
        function GetCommunityGroupDetail() {
            var param = '/' + $("#hdnCommunityOwnerId").val() + '/' + GetQueryStringParams('cid') + '/' + GetQueryStringParams('gid');
            GetResponse("GetCommunityGroupByIDAndOwner", param, GetCommunityGroupSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, sets values to the corresponding controls.
        function GetCommunityGroupSuccess(response) {
            if (response.CommunityGroupID == 0) {
                window.location = 'nodata.aspx';
                return;
            }
            $("#lblCommunityGroupName").text(response.Name);
            $("#txtDescription").val(response.Description);
            $kendoJS("#ddlActive").data("kendoDropDownList").value(response.Active);
            $("#txtCreditMin").val(response.CreditMin);
            $("#currency").text(response.CurrencyName);
            $("#hdfCommunityID").val(response.CommunityID);
            $("#hdfCurrency").val(response.CurrencyID);
            $("#hdfCommunityGroupID").val(response.CommunityGroupID);
        }

        //Service call to fetch community group summary based on query string value.
        function GetCommunityGroupSummary() {
            var param = '/' + GetQueryStringParams('gid');
            GetResponse("GetCommunityGroupSummary", param, GetCommunityGroupSummarySuccess, Failure, ErrorHandler);
        }

        //On ajax call success, sets values to the corresponding controls.
        function GetCommunityGroupSummarySuccess(response) {
            $("#hlCreditSupplierNo").text(response.InCreditSuppliersCount);
            $("#hlOutCreditSupplierNo").text(response.OutofCreditSuppliersCount);
            $("#hlBelowCreditSupplierNo").text(response.BelowMinCreditSuppliersCount);
            $("#hlCustomerNo").text(response.CustomersCount);
            $("#lblRevenue").text("(" + response.CurrencyName + ") " + ((response.CurrentRevenue == null || response.CurrentRevenue == 0) ? "0.00" : (response.CurrentRevenue).toFixed(2)));
        }

        //Sets the navigation page to the anchor tags on page load.
        function SetPageNavigation() {
            $("#hlCreditSupplierNo").attr('href', 'SupplierManagement.aspx?cid=' + Encrypted(GetQueryStringParams('cid')) + '&gid=' + Encrypted(GetQueryStringParams('gid')) + '&cat=' + Encrypted(1) + '');
            $("#hlOutCreditSupplierNo").attr('href', 'SupplierManagement.aspx?cid=' + Encrypted(GetQueryStringParams('cid')) + '&gid=' + Encrypted(GetQueryStringParams('gid')) + '&cat=' + Encrypted(2) + '');
            $("#hlBelowCreditSupplierNo").attr('href', 'SupplierManagement.aspx?cid=' + Encrypted(GetQueryStringParams('cid')) + '&gid=' + Encrypted(GetQueryStringParams('gid')) + '&cat=' + Encrypted(3) + '');
            $("#hlCustomerNo").attr('href', 'CustomerManagement.aspx?cid=' + Encrypted(GetQueryStringParams('cid')) + '&gid=' + Encrypted(GetQueryStringParams('gid')));
        }

        //Service call to fetch list of community group detail based on communityid.
        function BindMenu() {
            var param = '/' + GetQueryStringParams('cid');
            GetResponse("GetCommunityGroupMenu", param, BindMenuSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds community list menu.
        function BindMenuSuccess(response) {
            var menuDataSource = new kendo.data.DataSource({
                data: response
            })

            menuDataSource.read();
            var menuCount = menuDataSource.total();
            for (var i = 0; i < menuCount; i++) {
                if (GetQueryStringParams('gid') == response[i].id) {
                    $("#SubTitle").text(response[i].text);
                    break;
                }
            }

            $("#menuHeader").text('Community - Community Group').append('<b class="caret"></b>');
            $("#DynamicMenu").removeClass('custom-hide').addClass('custom-visible');

            $kendoJS("#menu").kendoMenu({
                dataSource: response
            });

            $("#menu").removeClass('k-widget k-reset k-header k-menu k-menu-horizontal');
            $("#menu .k-link").each(function () {
                $(this).removeAttr('class');
                $(this).addClass('custom-menu-anchor');
            });
        }

        //Service call to update community group detail.
        function UpdateCommunityGroup() {
            if (!isValid) {
                var postData = '{"CommunityGroupID":"' + $("#hdfCommunityGroupID").val() + '","CommunityID":"' + $("#hdfCommunityID").val() + '","Name":"' + encodeURIComponent($.trim($("#lblCommunityGroupName").text()))
                    + '","Description":"' + encodeURIComponent($.trim($("#txtDescription").val())) + '","CurrencyId":"' + $("#hdfCurrency").val()
                    + '","CreditMin":"' + ($.trim($("#txtCreditMin").val()) == "" ? 0 : $("#txtCreditMin").val()) + '","Active":"' + $("#ddlActive").val() + '"}';

                PostRequest("UpdateCommunityGroup", postData, UpdateCommunityGroupSuccess, Failure, ErrorHandler);
            }
        }

        //On ajax call success, success message will be showed in popup.
        function UpdateCommunityGroupSuccess() {
            var param = '/' + GetQueryStringParams('gid');
            GetResponse("GetCommunityGroup", param, GetCommunityGroupSuccess, Failure, ErrorHandler);
            GetCommunityGroupSummary();
            SuccessWindow('Community Group', 'Updated successfully.', '#');
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Community Group Detail', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Community Group Detail', response, '#');
        }
    </script>
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Community Group Detail</h2>
    <div class="row">
        <div class="col-md-12">
            <h4 id="SubTitle"></h4>
            <hr />
        </div>
        <div class="col-md-12">
            <div>
                <label id="lblCommunityGroupName"></label>
                <input type="hidden" id="hdfCommunityGroupID" />
                <input type="hidden" id="hdfCommunityID" />
                <input type="hidden" id="hdfCurrency" />
            </div>
            <div id="divEdit">
                <div class="form-group">
                    <input type="text" id="txtDescription" class="form-control custom-ownercomgrpdetail-textbox-width" name="txtDescription" placeholder="Description" maxlength="200" />
                </div>
                <div class="form-group">
                    <div id="ddlActive" class="custom-ownercomgrpdetail-dropdown-width"></div>
                </div>
            </div>
            <h4>Statistics</h4>
            <div class="col-md-12">
                <div class="col-md-5">
                    <label class="custom-ownercomgrpdetail-statistics-label"># In Credit Suppliers:</label>
                    <div class="col-md-4 pull-right">
                        <a class="custom-anchor" id="hlCreditSupplierNo"></a>
                    </div>
                </div>
                <div class="col-md-7"></div>
            </div>
            <div class="col-md-12">
                <div class="col-md-5">
                    <label class="custom-ownercomgrpdetail-statistics-label"># Out of Credit Suppliers:</label>
                    <div class="col-md-4 pull-right">
                        <a class="custom-anchor" id="hlOutCreditSupplierNo"></a>
                    </div>
                </div>
                <div class="col-md-7"></div>
            </div>
            <div class="col-md-12">
                <div class="col-md-5">
                    <label class="custom-ownercomgrpdetail-statistics-label"># Below Min Credit Suppliers:</label>
                    <div class="col-md-4 pull-right">
                        <a class="custom-anchor" id="hlBelowCreditSupplierNo"></a>
                    </div>
                </div>
                <div class="col-md-7"></div>
            </div>
            <div class="col-md-12">
                <div class="col-md-5">
                    <label class="custom-ownercomgrpdetail-statistics-label"># Customers:</label>
                    <div class="col-md-4 pull-right">
                        <a class="custom-anchor" id="hlCustomerNo"></a>
                    </div>
                </div>
                <div class="col-md-3"></div>
                <div class="col-md-4 pull-right">
                    <input id="btnManageFee" type="button" value="Manage Fee Structures" class="btn btn-block btn-lg btn-primary custom-ownercomgrpdetail-managebutton-rightalign" />
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-5">
                    <label class="custom-ownercomgrpdetail-statistics-label">Current Revenue:</label>
                    <div class="col-md-4 pull-right">
                        <label id="lblRevenue" style="font-size: 14px;"></label>
                    </div>
                </div>
                <div class="col-md-3"></div>
                <div class="col-md-4 pull-right custom-default-top-margin">
                    <input id="btnManageReward" type="button" value="Manage Reward Structures" class="btn btn-block btn-lg btn-primary custom-ownercomgrpdetail-managebutton-rightalign" />
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <hr />
            <div class="form-group col-md-8">
                <div class="col-md-3">
                    <label>Credit Min:</label>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtCreditMin" name="txtCreditMin" placeholder="Credit Min" class="form-control custom-comownerdash-textbox-width " maxlength="10" />
                    <span id="spanCreditMin" class="custom-register-email-span"></span>
                </div>
                <div class="col-md-4">
                    <label id="currency"></label>
                </div>
            </div>
            <div id="divBtnEdit" class="col-md-2 pull-right">
                <input id="btnSave" type="button" value="Save" class="btn btn-block btn-lg btn-primary custom-comownerdash-managebutton-rightalign" onclick="UpdateCommunityGroup()" />
            </div>
        </div>
    </div>
</asp:Content>
