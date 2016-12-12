<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="NewCommunityGroup.aspx.cs" Inherits="RatingReviewEngine.Web.NewCommunityGroup" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <script type="text/javascript">
        var isValid = false;
        var exist = false;

        $(document).ready(function () {
            if (GetQueryStringParams('cid') == null)
            {
                ErrorWindow('Community Group Detail', "No data found", 'Nodata.aspx');
                return;
            }
            ControlValidation();
            KeyDownEventOnLoad();
            OnBlurEventOnLoad();


            $("#hdfCommunityId").val(GetQueryStringParams('cid'));
            $("#hdfCurrencyId").val(GetQueryStringParams('cuid'));

            GetCommunityDetail();

        });

        //Service call to fetch community details.
        function GetCommunityDetail() {
            var param = '/' + $("#hdnCommunityOwnerId").val() + '/' + GetQueryStringParams('cid');
            GetResponse("GetCommunityByIDAndOwner", param, GetCommunitySuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the data to the corresponding controls.
        function GetCommunitySuccess(response) {
            if (response.CommunityID == 0) {
                ErrorWindow('Community Group Detail', 'Unauthorized access', 'Nodata.aspx');
                // window.location = 'Communityownerdashboard.aspx.aspx';
                return;
            }
            $("#hdfCommunityId").val(response.CommunityID);
            $("#hdfCurrencyId").val(response.CurrencyId);
        }

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    txtName: { required: true }
                },
                messages: {
                    txtName: { required: 'You can\'t leave this empty.' }
                },
                highlight: function (element) {
                    $(element).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                },
                unhighlight: function (element) {
                    $(element).closest('.form-group').removeClass('form-group has-error').css('color', 'black').addClass('form-group');
                },
                onfocusout: function (element) { $(element).valid(); }
            });
        }

        //Registers a keydown event on page load.
        function KeyDownEventOnLoad() {
            $('input[name="txtCreditMin"]').keydown(function (e) {
                AllowDecimal(e);
            });
        }

        //Registers a onblur event on page load.
        function OnBlurEventOnLoad() {
            $('#txtCreditMin').blur(function () {
                var val = this.value;
                if (val != '') {
                    if (DecimalValidation(val)) {
                        $("#spanCreditMin").text('').css('display', 'none');
                        $("#txtCreditMin").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                        isValid = false;
                    }
                    else {

                        $("#txtCreditMin").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                        $("#spanCreditMin").text('Please enter a valid Min credit value.').css('display', 'block').css('color', '#E74C3C');
                        isValid = true;
                    }
                }
                else {
                    $("#spanCreditMin").text('').css('display', 'none');
                    isValid = false;
                }
            });
        }

        //Service call to check community group name already exist.
        function CheckCommunityGroupName() {
            if ($("#txtName").val() != '') {
                // var param = "/0/" + $("#hdfCommunityId").val() + "/" + encodeURIComponent($.trim($("#txtName").val()));
                //GetResponse("CheckCommunityGroupNameExist", param, CheckCommunityGroupNameSuccess, Failure, ErrorHandler);

                var postData = '{"ID":"' + "0" + '","ParentID":"' + $("#hdfCommunityId").val() + '","Name":"' + encodeURIComponent($.trim($("#txtName").val())) + '"}';
                PostRequest("CheckCommunityGroupNameExist", postData, CheckCommunityGroupNameSuccess, Failure, ErrorHandler);
            }
            else {
                $("#txtName").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                $("#spanName").text('').css('display', 'none');
            }
        }

        //On ajax call success, validates the corresponding field.
        function CheckCommunityGroupNameSuccess(response) {
            if (response == "1") {
                $("#txtName").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#spanName").text('Name already exist.').css('display', 'block');
                exist = true;
            }
            else {
                $("#txtName").closest('.form-group').removeClass('form-group has-error').addClass('form-group').removeAttr('style');
                $("#spanName").text('').css('display', 'none');
                exist = false;
            }

            if (!isValid && !exist) {
                var postData = '{"CommunityID":"' + $("#hdfCommunityId").val() + '","Name":"' + encodeURIComponent($.trim($("#txtName").val())) + '","Description":"' + encodeURIComponent($.trim($("#txtDescription").val()))
                                + '","CurrencyID":"' + $("#hdfCurrencyId").val() + '","CreditMin":"' + ($("#txtCreditMin").val() == "" ? "0.00" : $("#txtCreditMin").val()) + '","Active":"true"}';
                PostRequest("NewCommunityGroup", postData, AddCommunityGroupSuccess, Failure, ErrorHandler);
            }
        }

        //This method checks for form validation and calls CheckCommunityGroupName().
        function CreateCommunityGroup() {
            if ($("#frmRatingReviewEngine").valid()) {
                CheckCommunityGroupName();
            }
        }

        //On ajax call success, clears the controls and shows success message in popup.
        function AddCommunityGroupSuccess(response) {
            ClearControls('divCommunity');
            SuccessWindow('New Community Group', 'Community group created successfully.', 'OwnerCommunityDetail.aspx?cid=' + Encrypted(GetQueryStringParams('cid')));
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('New Community Group', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {            
            //Show error message in a user friendly window
            ErrorWindow('New Community Group', response, '#');
        }
    </script>

</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">New Community Group</h2>
    <div id="divCommunity">
        <div class="row" id="divLabel">
            <div class="form-horizontal col-md-12" role="form">
                <hr />
                <div class="row text-center">
                    <div class="col-md-4"></div>
                    <div class="col-md-4">
                        <input type="hidden" id="hdfCommunityId" />
                        <input type="hidden" id="hdfCurrencyId" />
                        <div class="form-group">
                            <div style="text-align: left;">
                                <label class="custom-field-label-fontstyle">Name</label>
                            </div>
                            <input type="text" id="txtName" name="txtName" class="form-control" placeholder="Name" maxlength="50" />
                            <span id="spanName" class="custom-register-email-span"></span>
                        </div>
                        <div class="form-group">
                            <div style="text-align: left;">
                                <label class="custom-field-label-fontstyle">Description</label>
                            </div>
                            <input type="text" id="txtDescription" name="txtDescription" class="form-control" placeholder="Description" maxlength="200" />
                        </div>
                        <div class="form-group">
                            <div style="text-align: left;">
                                <label class="custom-field-label-fontstyle">Credit Min</label>
                            </div>
                            <input type="text" id="txtCreditMin" name="txtCreditMin" class="form-control" placeholder="Credit Min" maxlength="10" />
                            <span id="spanCreditMin" class="custom-register-email-span"></span>
                        </div>
                        <div class="form-group">
                            <input type="button" id="btnCreate" value="Create" class="btn btn-block btn-lg btn-primary" onclick="CreateCommunityGroup()" />
                        </div>
                    </div>
                    <div class="col-md-4"></div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
