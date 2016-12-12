<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="CommunityOwnerDashboard.aspx.cs" Inherits="RatingReviewEngine.Web.CommunityOwnerDashboard" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="Menu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">

    <style>
        .k-reset {
            font-size: 100% !important;
        }

        .k-header {
            color: White;
            background-color: #34495E;
            font-size: 15px;
        }

        .k-label {
            font-size: 15px;
        }

        #tbody, tr {
            line-height: 1.42857;
            vertical-align: top;
            font-size: 15px;
        }

        body {
            font-size: 14px !important;
        }

        .k-pager-numbers .k-link {
            line-height: 2em !important;
        }
    </style>

    <script type="text/javascript">
        var emailExist = false;
        var active = 1;

        $(document).ready(function () {
            ControlValidation();
            BindCountryDropDown();
            BindOwnerDetail();
            BindOwnerAndSummaryDetail('true');
        });

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    txtName: { required: true },
                    txtEmail: { required: true, email: true },
                    txtPrimaryPhone: { required: true },
                    txtBusinessNumber: { required: true }
                },
                messages: {
                    txtName: { required: 'You can\'t leave this empty.' },
                    txtEmail: { required: 'You can\'t leave this empty.', email: 'Invalid email.' },
                    txtPrimaryPhone: { required: 'You can\'t leave this empty.' },
                    txtBusinessNumber: { required: 'You can\'t leave this empty.' }
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

        //Service call to bind country dropdown.
        function BindCountryDropDown() {
            var countryDataSource = new kendo.data.DataSource({
                transport: {
                    read: {
                        dataType: "json",
                        beforeSend: setHeader,
                        url: $("#hdnAPIUrl").val() + "CountryList"
                    }
                }
            });

            $kendoJS("#ddlCountry").kendoDropDownList({
                dataTextField: "CountryName",
                dataValueField: "CountryID",
                index: 0,
                suggest: true,
                optionLabel: "Country",
                filter: "contains",
                dataSource: countryDataSource
            });

            $kendoJS("#ddlBillingCountry").kendoDropDownList({
                dataTextField: "CountryName",
                dataValueField: "CountryID",
                index: 0,
                suggest: true,
                optionLabel: "Billing Country",
                filter: "contains",
                dataSource: countryDataSource
            });
        }

        //Service call to fetch owner details.
        function BindOwnerDetail() {
            var param = "/" + $("#hdnCommunityOwnerId").val();
            GetResponse("GetOwner", param, GetOwnerSuccess, Failure, ErrorHandler);
        }

        //Service call to fetch owner details and owner community summary list.
        function BindOwnerAndSummaryDetail(data) {
            active = (data == 'true' ? 1 : 0);
            var param = "/" + $("#hdnCommunityOwnerId").val() + "/" + data;
            GetResponse("GetCommunitySummaryListByOwner", param, GetSummarySuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the values to the respective controls.
        function GetOwnerSuccess(response) {
            $("#lblName").text(response.CompanyName);
            $("#lblEmail").text(response.Email);
            $("#lblPrimaryPhone").text(response.PrimaryPhone);
            $("#lblOtherPhone").text(response.OtherPhone);
            $("#lblBusinessNumber").text(response.BusinessNumber);
            $("#lblAddress1").text(response.AddressLine1);
            $("#lblAddress2").text(response.AddressLine2);
            $("#lblCity").text(response.AddressCity);
            $("#lblState").text(response.AddressState);
            $("#lblCountry").text(response.AddressCountryName);
            $("#lblPostalCode").text(response.AddressPostalCode);
            $("#lblBillingName").text(response.BillingName);
            $("#lblBillingAddress1").text(response.BillingAddressLine1);
            $("#lblBillingAddress2").text(response.BillingAddressLine2);
            $("#lblBillingCity").text(response.BillingAddressCity);
            $("#lblBillingState").text(response.BillingAddressState);
            $("#lblBillingPostalCode").text(response.BillingAddressPostalCode);
            $("#lblBillingCountry").text(response.BillingAddressCountryName);
            $("#hdfCurrencyID").val(response.PreferredPaymentCurrencyID);
            $("#hdfCountryID").val(response.AddressCountryID);
            $("#hdfBillingCountryID").val(response.BillingAddressCountryID);
            $("#hdfWebsite").val(response.Website);
            $("#hdfDateAdded").val(response.DateAdded);
        }

        //On ajax call success, bind the details to grid.
        function GetSummarySuccess(response) {
            var grid = $kendoJS("#gvCommunitySummary").data("kendoGrid");
            if (grid != null)
                grid.destroy();
            $kendoJS("#gvCommunitySummary").kendoGrid({
                dataSource: {
                    pageSize: 10,
                    data: response
                },
                pageable: true,
                scrollable: false,
                columns: [
                    { field: "Name", width: 300, title: "Community", template: '<a id="#=CommunityID#" href="OwnerCommunityDetail.aspx?cid=#=Encrypted(CommunityID)#" class="custom-anchor" >${Name}</a>' },
                    { field: "CommunityGroupCount", width: 100, title: "# Community Groups" },
                    { field: "InCreditSuppliersCount", width: 80, title: "# In Credit Suppliers", template: '<a id="#=CommunityID#" class="custom-anchor" href="SupplierManagement.aspx?cid=#=Encrypted(CommunityID)#&cat=' + Encrypted(1) + '">${InCreditSuppliersCount}</a>' },
                    { field: "OutofCreditSuppliersCount", width: 105, title: "# Out of Credit Suppliers", template: '<a id="#=CommunityID#" class="custom-anchor" href="SupplierManagement.aspx?cid=#=Encrypted(CommunityID)#&cat=' + Encrypted(2) + '">${OutofCreditSuppliersCount}</a>' },
                    { field: "BelowMinCreditSuppliersCount", width: 110, title: "# Below Min Credit Suppliers", template: '<a id="#=CommunityID#" class="custom-anchor" href="SupplierManagement.aspx?cid=#=Encrypted(CommunityID)#&cat=' + Encrypted(3) + '">${BelowMinCreditSuppliersCount}</a>' },
                    { field: "CustomersCount", width: 90, title: "# Customers", template: '<a id="#=CommunityID#" class="custom-anchor" href="CustomerManagement.aspx?cid=#=Encrypted(CommunityID)#">${CustomersCount}</a>' },
                    { field: "CurrentRevenue", width: 130, title: "Current Revenue", template: '<a id="#=CommunityID#" class="custom-anchor"><span id=${CurrencyId}>(${CurrencyName}) </span>#=(CurrentRevenue).toFixed(2)#</a>' }]
            }).data("kendoGrid");

            if (active == 1)
                $("#gvCommunitySummary th[data-field=Name]").html("Active Community");
            else
                $("#gvCommunitySummary th[data-field=Name]").html("Inactive Community");
        }

        //This method allows to edit owner information.
        function ShowEdit() {
            $("#txtName").val($("#lblName").text());
            $("#txtEmail").val($("#lblEmail").text());
            $("#txtPrimaryPhone").val($("#lblPrimaryPhone").text());
            $("#txtOtherPhone").val($("#lblOtherPhone").text());
            $("#txtBusinessNumber").val($("#lblBusinessNumber").text());
            $("#txtAddress1").val($("#lblAddress1").text());
            $("#txtAddress2").val($("#lblAddress2").text());
            $("#txtCity").val($("#lblCity").text());
            $("#txtState").val($("#lblState").text());
            $("#txtPostalCode").val($("#lblPostalCode").text());
            $("#txtBillingName").val($("#lblBillingName").text());
            $("#txtBillingAddress1").val($("#lblBillingAddress1").text());
            $("#txtBillingAddress2").val($("#lblBillingAddress2").text());
            $("#txtBillingCity").val($("#lblBillingCity").text());
            $("#txtBillingState").val($("#lblBillingState").text());
            $("#txtBillingPostalCode").val($("#lblBillingPostalCode").text());
            $kendoJS("#ddlCountry").data("kendoDropDownList").value($("#hdfCountryID").val().toString());
            $kendoJS("#ddlBillingCountry").data("kendoDropDownList").value($("#hdfBillingCountryID").val().toString());
            $("#divLabel").hide();
            $("#divEdit").show();

            $("#chkUseSameAddress").prop('checked', false);
            $("#chkUseSameAddress").closest('label').removeClass('checked');
        }

        //This method disable edit and displays the detail in view mode.
        function HideEdit() {
            $("#divLabel").show();
            $("#divEdit").hide();

            ClearValidation();
            $("#spanEmail").text('').css('display', 'none');
        }

        //This method validates form control and on success calls UpdateOwner() method.
        function UpdateCommunityOwner() {
            if ($("#frmRatingReviewEngine").valid() && emailExist == false) {
                UpdateOwner();
            }
        }

        //Service call to update owner information.
        function UpdateOwner() {
            var postData = '{"OwnerID":"' + $("#hdnCommunityOwnerId").val() + '","CompanyName":"' + encodeURIComponent($("#txtName").val()) +
               '","Email":"' + $("#txtEmail").val() + '","BusinessNumber":"' + encodeURIComponent($("#txtBusinessNumber").val()) + '","PreferredPaymentCurrencyID":"' + $("#hdfCurrencyID").val()
               + '","DateAdded":"' + $("#hdfDateAdded").val() + '","PrimaryPhone":"' + encodeURIComponent($("#txtPrimaryPhone").val()) + '","OtherPhone":"' + encodeURIComponent($("#txtOtherPhone").val())
               + '","Website":"' + $("#hdfWebsite").val() + '","AddressLine1":"' + encodeURIComponent($("#txtAddress1").val()) + '","AddressLine2":"' + encodeURIComponent($("#txtAddress2").val())
               + '","AddressCity":"' + encodeURIComponent($("#txtCity").val()) + '","AddressState":"' + encodeURIComponent($("#txtState").val()) + '","AddressPostalCode":"' + encodeURIComponent($("#txtPostalCode").val())
               + '","AddressCountryID":"' + (($("#ddlCountry").val().toString() == '') ? -1 : $("#ddlCountry").val()) + '","BillingName":"' + encodeURIComponent($("#txtBillingName").val()) + '","BillingAddressLine1":"' + encodeURIComponent($("#txtBillingAddress1").val())
               + '","BillingAddressLine2":"' + encodeURIComponent($("#txtBillingAddress2").val()) + '","BillingAddressCity":"' + encodeURIComponent($("#txtBillingCity").val()) + '","BillingAddressState":"' + encodeURIComponent($("#txtBillingState").val())
               + '","BillingAddressPostalCode":"' + encodeURIComponent($("#txtBillingPostalCode").val()) + '","BillingAddressCountryID":"' + (($("#ddlBillingCountry").val().toString() == '') ? -1 : $("#ddlBillingCountry").val())
               + '"}';

            PostRequest("UpdateOwner", postData, UpdateOwnerSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, rebinds the updated data and shows success message in popup.
        function UpdateOwnerSuccess() {
            var param = "/" + $("#hdnCommunityOwnerId").val();
            GetResponse("GetOwner", param, GetOwnerSuccess, Failure, ErrorHandler);
            HideEdit();
            SuccessWindow('Dashboard', "Updated successfully.", '#');
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Dashboard', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Dashboard', response, '#');
        }

        //Service call to check whether the owner email already exist.
        function CheckOwnerEmail() {
            if ($.trim($("#txtEmail").val()) != '') {
                var param = "/" + $("#hdnCommunityOwnerId").val() + "/" + $.trim($("#txtEmail").val());
                GetResponse("CheckOwnerEmail", param, CheckOwnerEmailSuccess, Failure, ErrorHandler);
            }
        }

        //On ajax call success, validates the corresponding field.
        function CheckOwnerEmailSuccess(response) {
            if (response == "1") {
                $("#txtEmail").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#spanEmail").text('Email already exist.').css('display', 'block');
                emailExist = true;
            }
            else {
                $("#spanEmail").text('').css('display', 'none');
                emailExist = false;
            }
        }

        //Sets address information to billing details.
        function ToggleAddress() {

            if ($("#chkUseSameAddress").is(':checked')) {
                $("#txtBillingName").val($("#txtName").val());
                $("#txtBillingAddress1").val($("#txtAddress1").val());
                $("#txtBillingAddress2").val($("#txtAddress2").val());
                $("#txtBillingCity").val($("#txtCity").val());
                $("#txtBillingState").val($("#txtState").val());
                $("#txtBillingPostalCode").val($("#txtPostalCode").val());
                $kendoJS("#ddlBillingCountry").data('kendoDropDownList').value($("#ddlCountry").val());
            }
            else {
                $("#txtBillingName").val('');
                $("#txtBillingAddress1").val('');
                $("#txtBillingAddress2").val('');
                $("#txtBillingCity").val('');
                $("#txtBillingState").val('');
                $("#txtBillingPostalCode").val('');
                $kendoJS("#ddlBillingCountry").data('kendoDropDownList').value(0);
            }
        }
    </script>

</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:Menu runat="server" ID="Menu" />
    <h2 class="h2">Community Owner Dashboard</h2>
    <div class="row">
        <div class="col-md-12">
            <hr />
        </div>
        <div id="divLabel" class="col-md-12">
            <div class="col-md-4">
                <asp:HiddenField ID="hdfOwnerId" runat="server" />
                <input type="hidden" id="hdfCurrencyID" />
                <input type="hidden" id="hdfCountryID" />
                <input type="hidden" id="hdfBillingCountryID" />
                <input type="hidden" id="hdfWebsite" />
                <input type="hidden" id="hdfDateAdded" />
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Name</label>
                    </div>
                    <div>
                        <label id="lblName" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Email</label>
                    </div>
                    <div>
                        <label id="lblEmail" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Primary Phone</label>
                    </div>
                    <div>
                        <label id="lblPrimaryPhone" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Other Phone</label>
                    </div>
                    <div>
                        <label id="lblOtherPhone" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Business Number</label>
                    </div>
                    <div>
                        <label id="lblBusinessNumber" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Billing Name</label>
                    </div>
                    <div>
                        <label id="lblBillingName" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Address 1</label>
                    </div>
                    <div>
                        <label id="lblAddress1" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Address 2</label>
                    </div>
                    <div>
                        <label id="lblAddress2" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">City</label>
                    </div>
                    <div>
                        <label id="lblCity" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">State</label>
                    </div>
                    <div>
                        <label id="lblState" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Postal Code</label>
                    </div>
                    <div>
                        <label id="lblPostalCode" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Country</label>
                    </div>
                    <div>
                        <label id="lblCountry" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Billing Address1</label>
                    </div>
                    <div>
                        <label id="lblBillingAddress1" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Billing Address2</label>
                    </div>
                    <div>
                        <label id="lblBillingAddress2" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Billing City</label>
                    </div>
                    <div>
                        <label id="lblBillingCity" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Billing State</label>
                    </div>
                    <div>
                        <label id="lblBillingState" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Billing Postal Code</label>
                    </div>
                    <div>
                        <label id="lblBillingPostalCode" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-comownerdash-innerdiv">
                    <div>
                        <label class="custom-comownerdash-label-lineheight">Billing Country</label>
                    </div>
                    <div>
                        <label id="lblBillingCountry" class="custom-comownerdash-label-fontstyle"></label>
                    </div>
                </div>
            </div>
            <div class="col-md-2 pull-right">
                <input type="button" value="Edit" id="btnEdit" class="btn btn-block btn-lg btn-primary custom-comownerdash-button-rightalign" onclick="ShowEdit()" />
            </div>
        </div>
        <div id="divEdit" style="display: none" class="col-md-12">
            <div class="col-md-10">
                <div class="col-md-4">
                    <asp:HiddenField ID="HiddenField1" runat="server" />
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Name</label>
                        </div>
                        <input type="text" id="txtName" class="form-control custom-comownerdash-textbox-width" name="txtName" placeholder="Name" maxlength="50" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Address 1</label>
                        </div>
                        <input type="text" id="txtAddress1" class="form-control custom-comownerdash-textbox-width" name="txtAddress1" placeholder="Addr 1" maxlength="150" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Billing Address 1</label>
                        </div>
                        <input type="text" id="txtBillingAddress1" class="form-control custom-comownerdash-textbox-width" name="txtBillingAddress1" placeholder="Billing Addr 1" maxlength="150" />
                    </div>
                </div>
            </div>
            <div class="col-md-2 pull-right">
                <input type="button" id="btnSave" value="Save" class="btn btn-block btn-lg btn-info custom-comownerdash-button-rightalign" onclick="UpdateCommunityOwner()" />
                <input type="button" id="btnCancel" value="Cancel" class="btn btn-block btn-lg btn-default custom-comownerdash-button-rightalign" onclick="HideEdit()" />
            </div>
            <div class="col-md-10">
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Email</label>
                        </div>
                        <input type="text" id="txtEmail" class="form-control custom-comownerdash-textbox-width" name="txtEmail" placeholder="Email" maxlength="200" onblur="CheckOwnerEmail()" />
                        <span id="spanEmail" class="custom-register-email-span"></span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Address 2</label>
                        </div>
                        <input type="text" id="txtAddress2" class="form-control custom-comownerdash-textbox-width" name="txtAddress2" placeholder="Addr 2" maxlength="150" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Billing Address 2</label>
                        </div>
                        <input type="text" id="txtBillingAddress2" class="form-control custom-comownerdash-textbox-width" name="txtBillingAddress2" placeholder="Billing Addr 2" maxlength="150" />
                    </div>
                </div>
            </div>
            <div class="col-md-10">
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Primary Phone</label>
                        </div>
                        <input type="text" id="txtPrimaryPhone" class="form-control custom-comownerdash-textbox-width" name="txtPrimaryPhone" placeholder="Primary Phone" maxlength="50" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">City</label>
                        </div>
                        <input type="text" id="txtCity" class="form-control custom-comownerdash-textbox-width" name="txtCity" placeholder="City" maxlength="50" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Billing City</label>
                        </div>
                        <input type="text" id="txtBillingCity" class="form-control custom-comownerdash-textbox-width" name="txtBillingCity" placeholder="Billing City" maxlength="50" />
                    </div>
                </div>
            </div>
            <div class="col-md-10">
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Other Phone</label>
                        </div>
                        <input type="text" id="txtOtherPhone" class="form-control custom-comownerdash-textbox-width" name="txtOtherPhone" placeholder="Other Phone" maxlength="50" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">State</label>
                        </div>
                        <input type="text" id="txtState" class="form-control custom-comownerdash-textbox-width" name="txtState" placeholder="State" maxlength="50" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Billing State</label>
                        </div>
                        <input type="text" id="txtBillingState" class="form-control custom-comownerdash-textbox-width" name="txtBillingState" placeholder="Billing State" maxlength="50" />
                    </div>
                </div>
            </div>
            <div class="col-md-10">
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Business Number</label>
                        </div>
                        <input type="text" id="txtBusinessNumber" class="form-control custom-comownerdash-textbox-width" name="txtBusinessNumber" placeholder="Business Number" maxlength="50" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Postal Code</label>
                        </div>
                        <input type="text" id="txtPostalCode" class="form-control custom-comownerdash-textbox-width" name="txtPostalCode" placeholder="Postal Code" maxlength="50" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Billing Postal Code</label>
                        </div>
                        <input type="text" id="txtBillingPostalCode" class="form-control custom-comownerdash-textbox-width" name="txtBillingPostalCode" placeholder="Postal Code" maxlength="50" />
                    </div>
                </div>
            </div>
            <div class="col-md-10">
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Billing Name</label>
                        </div>
                        <input type="text" id="txtBillingName" class="form-control custom-comownerdash-textbox-width" name="txtBillingName" placeholder="Billing Name" maxlength="150" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Country</label>
                        </div>
                        <div id="ddlCountry" class="custom-dropdown-width"></div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Billing Country</label>
                        </div>
                        <div id="ddlBillingCountry" class="custom-dropdown-width"></div>
                    </div>
                </div>
            </div>
            <div class="col-md-10">
                <div class="col-md-4"></div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="chkUseSameAddress" class="checkbox custom-comownerdash-checkbox-textalign">
                            <span class="icons"><span class="first-icon fui-checkbox-unchecked"></span><span class="second-icon fui-checkbox-checked"></span></span>
                            <input type="checkbox" value="" id="chkUseSameAddress" data-toggle="checkbox" onchange="ToggleAddress()" />
                            Use same address for billing
                        </label>
                    </div>
                </div>
                <div class="col-md-4"></div>
            </div>
        </div>
        <div class="form-horizontal col-md-12" role="form">
            <hr />
            <a href="#" class="custom-anchor custom-comownerdash-actinact-anchor" id="hlActiveCommunity" onclick="BindOwnerAndSummaryDetail('true')">Active Communities</a>
            <div class="col-md-2"></div>
            <a href="#" class="custom-anchor custom-comownerdash-actinact-anchor" id="hlInactiveCommunity" onclick="BindOwnerAndSummaryDetail('false')">Inactive Communities</a>
        </div>
        <div class="col-md-12">
            <div id="gvCommunitySummary"></div>
            <div class="col-md-12 custom-comownerdash-newcom-anchor">
                <a href="NewCommunity.aspx" class="custom-anchor">New Community</a>
            </div>
        </div>
    </div>
</asp:Content>
