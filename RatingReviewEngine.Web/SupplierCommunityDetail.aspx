<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="SupplierCommunityDetail.aspx.cs" Inherits="RatingReviewEngine.Web.SupplierCommunityDetail" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">

    <style>
        .k-header {
            color: White;
            background-color: #34495E;
            font-size: 16px;
        }

        #tbody, tr {
            line-height: 1.42857;
            vertical-align: top;
            font-size: 15px;
        }

        .modal-dialog {
            width: 400px !important;
        }

        body {
            font-size: 14px !important;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            if (GetQueryStringParams('cid') == null) {
                ErrorWindow('Community Detail', "No data found", 'Nodata.aspx');
                return;
            }
            $("#hlJoinCommunity").hide();
            $("#hlLeaveCommunity").hide();
            GetCommunityDetail();
        });

        //Service call to fetch community details based on community id from query string.
        function GetCommunityDetail() {
            var param = '/' + GetQueryStringParams('cid');
            GetResponse("GetCommunity", param, GetCommunityDetailSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, sets values to corresponding fields and calls BindCommunityDetail() & BindMenu() methods.
        function GetCommunityDetailSuccess(response) {
            if (response.CommunityID == 0) {
                window.location = 'nodata.aspx';
                return;
            }

            $("#hdnCommunityName").val(response.Name);
            $("#SubTitle").text(response.Name);

            $('#hlJoinCommunity').text('Join ' + $('#hdnCommunityName').val());
            $('#hlLeaveCommunity').text('Leave ' + $('#hdnCommunityName').val());

            BindCommunityDetail();
            BindMenu();
        }

        //Service call to fetch community details based on community id from query string and supplier id.
        function BindCommunityDetail() {
            var param = '/' + GetQueryStringParams('cid') + '/' + $("#hdnSupplierId").val();
            GetResponse("GetCommunityDetailBySupplierId", param, GetCommunitySuccess, Failure, ErrorHandler);
        }

        //Service call to fetch list of communities to bind the menu based on supplier id.
        function BindMenu() {
            var param = '/' + $("#hdnSupplierId").val();
            GetResponse("GetCommunityListActiveBySupplier", param, BindMenuSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the menu.
        function BindMenuSuccess(response) {
            var menuDataSource = new kendo.data.DataSource({
                data: response
            })

            menuDataSource.read();
            var menuCount = menuDataSource.total();
            for (var i = 0; i < menuCount; i++) {
                if (GetQueryStringParams('cid') == response[i].id) {
                    $("#SubTitle").text(response[i].text);
                    break;
                }
            }

            if (menuCount > 0) {
                $("#menuHeader").text('Communities').append('<b class="caret"></b>');
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
        }

        //On ajax call success, sets values to corresponding fields and binds the grid.
        function GetCommunitySuccess(response) {
            $("#lblDescription").text(response.Description);
            $("#lblCommunityGroup").text(response.CommunityGroupCount);
            $("#lblTotalSuppliers").text(response.SupplierCount);

            if (response.IsMember == "1") {
                $("#hlJoinCommunity").hide();
                $("#hlLeaveCommunity").show();
            }
            else {
                $("#hlLeaveCommunity").hide();
                $("#hlJoinCommunity").show();
            }

            $kendoJS("#gvCommunityGroup").kendoGrid({
                dataSource: {
                    pageSize: 10,
                    data: response.lstCommunityGroupDetail
                },
                pageable: true,
                scrollable: false,
                columns: [
                    { field: "Name", title: "My Community Groups", template: '<a id="#=CommunityGroupId#" class="custom-anchor" href="SupplierCommunityGroupDetail.aspx?gid=#=Encrypted(CommunityGroupId)#">${Name}</a>' },
                    { field: "SupplierCount", title: "Supplier Count", template: '<label>${SupplierCount} Supplier(s)</label>' },
                    { field: "AverageRating", title: "Avg Group Rating", template: '<label>#= (AverageRating).toFixed(1) # Star(s)</label>' },
                    { field: "MyRating", title: "My Avg Rating", template: '<a class="custom-anchor" href="SupplierReviews.aspx?cid=' + Encrypted(GetQueryStringParams('cid')) + '&gid=#=Encrypted(CommunityGroupId)#&sid=' + Encrypted($("#hdnSupplierId").val()) + '">#= (MyRating).toFixed(1) # Star(s) from ${ReviewCount} Review(s)</a>' },
                    { field: "TotalIncome", title: "Total Income", template: '<span id=${CurrencyID}>(${CurrencyName}) #=(TotalIncome).toFixed(2)#</span>' },
                    { field: "IsActive", title: "Active" }
                ]
            }).data("kendoGrid");
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Community Detail', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Community Detail', response, '#');
        }

        //This method shows a confirmation popup to leave the community.
        function CommunityLeave() {
            BootstrapDialog.show({
                title: 'Leave Community',
                message: 'Do you want to leave this community?',
                buttons: [{
                    label: 'Yes',
                    cssClass: 'btn-info',
                    action: function (dialog) {
                        var param = "/" + $("#hdnSupplierId").val() + "/Supplier/" + GetQueryStringParams('cid');
                        GetResponse("CancelSupplierCommunityMembership", param, CancelSupplierSuccess, Failure, ErrorHandler);

                        dialog.close();
                    }
                }, {
                    label: 'No',
                    cssClass: 'btn-default',
                    action: function (dialog) {
                        dialog.close();
                    }
                }],
                type: BootstrapDialog.TYPE_INFO
            });
        }

        //On ajax call success, success message is showed in popup and calls BindCommunityDetail() & BindMenu() methods.
        function CancelSupplierSuccess(response) {
            $("#hlLeaveCommunity").hide();
            $("#hlJoinCommunity").show();

            BindCommunityDetail();
            BindMenu();
            SuccessWindow('Community Detail', 'You have left this community.', '#');
        }

        //This method shows a popup and on confirmation calls CommunityJoin() method. 
        function CommunityJoinPopup(data) {
            BootstrapDialog.show({
                title: 'Join Community',
                message: $('<div><div class="form-group"><input id="txtAutoTransferAmtSupplier" name="txtAutoTransferAmtSupplier" placeholder="Auto Transfer Amount Supplier" class="form-control" onblur="CommunityJoinValidation()" onkeydown="AllowDecimal(event);" /><span id="spanTransferAmount" class="custom-communitydetail-validation"></span></div>'
                           + '<div class="form-group"><label for="chkAutoTopUp" class="checkbox custom-communitydetail-checkbox-textalign">'
                           + '<span class="icons"><span class="first-icon fui-checkbox-unchecked"></span><span class="second-icon fui-checkbox-checked"></span></span>'
                           + '<input type="checkbox" value="" id="chkAutoTopUp" data-toggle="checkbox" />Auto Top Up</label></div>'
                           + '<div class="form-group"><input id="txtMinCredit" name="txtMinCredit" placeholder="Minimum Credit" class="form-control" onblur="CommunityJoinValidation()" onkeydown="AllowDecimal(event);" /><span id="spanMinCredit" class="custom-communitydetail-validation"></span></div></div>'),
                buttons: [{
                    label: 'Save',
                    cssClass: 'btn-info',
                    action: function (dialog) {
                        CommunityJoin(dialog);
                    }
                }, {
                    label: 'Cancel',
                    cssClass: 'btn-default',
                    action: function (dialog) {
                        dialog.close();
                    }
                }],
                type: BootstrapDialog.TYPE_INFO
            });
        }

        //This method validates the controls in join community popup.
        function CommunityJoinValidation() {
            var isValid = false;

            if ($("#txtAutoTransferAmtSupplier").val() == "") {
                $("#txtAutoTransferAmtSupplier").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#spanTransferAmount").text('You can\'t leave this empty.').css('display', 'block');
                isValid = true;
            }
            else {
                $("#spanTransferAmount").text('').css('display', 'none');
                $("#txtAutoTransferAmtSupplier").closest('.form-group').removeClass('has-error');
            }

            if ($("#chkAutoTopUp").is(':checked')) {
                if ($("#txtMinCredit").val() == "") {
                    $("#txtMinCredit").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                    $("#spanMinCredit").text('You can\'t leave this empty.').css('display', 'block');
                    isValid = true;
                }
                else {
                    $("#spanMinCredit").text('').css('display', 'none');
                    $("#txtMinCredit").closest('.form-group').removeClass('has-error');
                }
            }
            else {
                $("#spanMinCredit").text('').css('display', 'none');
                $("#txtMinCredit").closest('.form-group').removeClass('has-error');
            }

            return isValid;
        }

        //Service call to join a community.
        function CommunityJoin(dialog) {
            var isValid = CommunityJoinValidation();

            if (isValid == false) {
                var autoTopUp;
                var minCredit;
                if ($("#chkAutoTopUp").is(':checked')) {
                    autoTopUp = true;
                    minCredit = $("#txtMinCredit").val();
                }
                else {
                    autoTopUp = false;
                    minCredit = "0";
                }

                var postData = '{"SupplierID": "' + $("#hdnSupplierId").val() + '", "CommunityID": "' + GetQueryStringParams('cid') + '", "IsActive": "' + 1 + '", "AutoTransferAmtSupplier": "' + $("#txtAutoTransferAmtSupplier").val() + '", "AutoTopUp": "' + autoTopUp + '", "MinCredit": "' + minCredit + '"}';
                PostRequest("NewSupplierCommunityMembership", postData, CommunityJoinSuccess, Failure, ErrorHandler);

                dialog.close();
            }
        }

        //On ajax call success, success message is showed in popup and calls BindCommunityDetail() method.
        function CommunityJoinSuccess() {
            SuccessWindow('Community Detail', 'You have joined this community.', '#');
            BindCommunityDetail();
        }
    </script>
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Community Detail</h2>
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <input type="hidden" id="hdnCommunityName" />
            <h4 id="SubTitle"></h4>
            <hr />
            <div class="col-md-5 custom-communitydetail-description-container">
                <div class="form-group">
                    <label>Description :</label><label id="lblDescription" class="custom-communitydetail-label-fontstyle"></label>
                </div>
                <div class="form-group">
                    <label class="custom-communitydetail-label-width">Total Community Groups :</label><label id="lblCommunityGroup" class="custom-communitydetail-label-fontstyle custom-communitydetail-labelcount-width"></label><label class="custom-communitydetail-label-width">Total Suppliers :</label><label id="lblTotalSuppliers" class="custom-communitydetail-label-fontstyle custom-communitydetail-labelcount-width"></label>
                </div>
            </div>
            <div class="col-md-5 custom-communitydetail-link-container pull-right">
                <a id="hlJoinCommunity" class="custom-anchor" href="#" onclick="CommunityJoinPopup(this)">Join Community</a><a id="hlLeaveCommunity" class="custom-anchor" href="#" onclick="CommunityLeave()">Leave Community</a>
            </div>
            <div class="col-md-12">
                <div id="gvCommunityGroup"></div>
            </div>
        </div>
    </div>
</asp:Content>
