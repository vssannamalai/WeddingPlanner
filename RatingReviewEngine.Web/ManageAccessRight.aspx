<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="ManageAccessRight.aspx.cs" Inherits="RatingReviewEngine.Web.ManageAccessRight" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>
<asp:Content ID="Content1" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <style>
        .k-header {
            color: White;
            background-color: #34495E;
            font-size: 16px;
        }

        body {
            font-size: 14px !important;
        }
    </style>
    <script type="text/javascript">
        $(document).ready(function () {
            GetResponse("GetAllAccessRight", "", GetAccessRightSuccess, Failure, ErrorHandler);
        });

        //On ajax call success, binds the data to grid.
        function GetAccessRightSuccess(response) {
            $kendoJS("#gvAccessRight").kendoGrid({
                dataSource: {
                    //pageSize: 10,
                    data: response
                },
                pageable: false,
                scrollable: false,
                columns: [
                    { field: "PageName", title: "Page Name", template: '<span>${PageName}</span> <input type="hidden" id="hdfPageId" value=${PageID} />' },
                    { field: "IsAdminAllowed", title: "Administrator", template: '<input type="checkbox" id="chkAdmin" #=IsAdminAllowed ? "checked" : "" # />' },
                    { field: "IsOwnerAllowed", title: "Owner", template: '<input type="checkbox" id="chkOwner" #=IsOwnerAllowed ? "checked" : "" # />' },
                    { field: "IsSupplierAllowed", title: "Supplier", template: '<input type="checkbox" id="chkSupplier" #=IsSupplierAllowed ? "checked" : "" # />' }
                ]
            }).data("kendoGrid");
        }

        //Service call to update access rights.
        function UpdateAccessRight() {
            var div = $("#divReward");

            var postData = '{';
            $("#gvAccessRight").find('tr').each(function () {

                $(this).find('input').each(function () {
                    switch ($(this).attr('id')) {
                        case "hdfPageId":
                            postData += '"PageID":"' + $(this).val() + '",';
                            break;

                        case "chkAdmin":
                            postData += '"IsAdminAllowed":"' + ($(this).is(":checked") ? 1 : 0) + '",';
                            break;

                        case "chkOwner":
                            postData += '"IsOwnerAllowed":"' + ($(this).is(":checked") ? true : false) + '",';
                            break;

                        case "chkSupplier":
                            postData += '"IsSupplierAllowed":"' + ($(this).is(":checked") ? true : false) + '",';
                            break;
                    }

                });

                if (postData != '{') {
                    postData = postData.substring(0, postData.length - 1);
                    postData += '}';
                    PostRequest("UpdateAccessRight", postData, UpdateAccessRightSuccess, Failure, ErrorHandler);
                }
                postData = '{';
            });

            SuccessWindow('Access Rights', 'Access rights updated successfully.', '#');
        }

        //On ajax call success.
        function UpdateAccessRightSuccess(response) { }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Access Rights', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Access Rights', response, '#');
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Manage Access Rights</h2>
    <div class="row">
        <hr />
        <div class="col-md-12">
            <div class="form-group">
                <div id="gvAccessRight"></div>
            </div>
        </div>
        <div class="col-md-12" style="margin-top: 20px;">
            <div class="col-md-2 pull-right">
                <div class="form-group">
                    <input type="button" value="Apply" id="btnApply" class="col-md-2 btn btn-block btn-lg btn-primary custom-manaccrights-button-rightalign" onclick="UpdateAccessRight()" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
