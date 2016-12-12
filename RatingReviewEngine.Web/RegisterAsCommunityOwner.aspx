<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="RegisterAsCommunityOwner.aspx.cs" Inherits="RatingReviewEngine.Web.RegisterAsCommunityOwner" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <style>
        .col-md-8 {
            width: 68.6667% !important;
        }

        .k-reset {
            font-size: 88% !important;
        }
    </style>

    <script type="text/javascript">
        var emailExist = false;

        $(document).ready(function () {
            SetDefaultValues();
            ControlValidation();
            BindCurrency();
            BindCountry();
        });

        //Set static values for email.
        function SetDefaultValues() {
            //Login email id will be shown by default in email field.
            $("#txtEmail").val($("#hdnUserName").val());
            CheckOwnerEmail();
        }

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    txtBusinessName: { required: true },
                    txtEmail: { required: true, email: true },
                    txtPrimaryPhone: { required: true },
                    txtBusinessNumber: { required: true },
                    txtWebsite: { url: true }
                },
                messages: {
                    txtBusinessName: { required: 'You can\'t leave this empty.' },
                    txtEmail: { required: 'You can\'t leave this empty.', email: 'Invalid email.' },
                    txtPrimaryPhone: { required: 'You can\'t leave this empty.' },
                    txtBusinessNumber: { required: 'You can\'t leave this empty.' },
                    txtWebsite: { url: 'Invalid URL (http://example.com).' }
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

        //Bind currency list to dropdown.
        function BindCurrency() {
            $kendoJS("#ddlCurrency").kendoDropDownList({
                dataTextField: "Description",
                dataValueField: "CurrencyID",
                index: 0,
                suggest: true,
                optionLabel: "Currency",
                filter: "contains",
                dataSource: {
                    transport: {
                        read: {
                            dataType: "json",
                            beforeSend: setHeader,
                            url: $("#hdnAPIUrl").val() + "CurrencyActiveList"
                        }
                    }
                }
            });
        }

        //Bind country list to dropdown. 
        function BindCountry() {
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

        //Checks whether the email id is already exist.
        function CheckOwnerEmail() {
            if ($.trim($("#txtEmail").val()) != '') {
                var param = "/0/" + $("#txtEmail").val();
                GetResponse("CheckOwnerEmail", param, CheckOwnerEmailSuccess, Failure, ErrorHandler);
            }
            else {
                $("#spanEmail").text('').css('display', 'none');
            }
        }

        //On ajax call success, checks response for existance.
        function CheckOwnerEmailSuccess(response) {
            if (response == "1") {
                $("#txtEmail").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#spanEmail").text('Email already exist.').css('display', 'block').css('margin-left', '0px');
                emailExist = true;
            }
            else {
                $("#spanEmail").text('').css('display', 'none');
                emailExist = false;
            }
        }

        //Checks for control validation and calls RegisterOwner() methed.
        function RegisterCommunityOwner() {
            var dropDownValidation = false;
            if ($kendoJS("#ddlCurrency").data("kendoDropDownList").text() == 'Currency') {
                $("#spanCurrencyValidation").removeClass("custom-regcomowner-email-validation-off").addClass("custom-regcomowner-email-validation-on");
                dropDownValidation = true;
            }

            if ($("#frmRatingReviewEngine").valid() && dropDownValidation == false && emailExist == false) {
                $("btnRegister").prop('disabled', true);
                RegisterOwner();
            }
        }

        //Validates currency dropdown.
        function CurrencyValidation() {
            if ($kendoJS("#ddlCurrency").data("kendoDropDownList").text() != 'Currency') {
                $("#spanCurrencyValidation").removeClass("custom-regcomowner-email-validation-on").addClass("custom-regcomowner-email-validation-off");
            }
            else {
                $("#spanCurrencyValidation").removeClass("custom-regcomowner-email-validation-off").addClass("custom-regcomowner-email-validation-on");
            }
        }

        //Service call to register a new owner.
        function RegisterOwner() {
            var postData = '{"OAuthAccountID":"' + $("#hdnOAuthAccountID").val() + '","CompanyName":"' + encodeURIComponent($("#txtBusinessName").val()) +
                '","Email":"' + $("#txtEmail").val() + '","BusinessNumber":"' + encodeURIComponent($("#txtBusinessNumber").val()) + '","PreferredPaymentCurrencyID":"' + $("#ddlCurrency").val()
                + '","PrimaryPhone":"' + encodeURIComponent($("#txtPrimaryPhone").val()) + '","OtherPhone":"' + encodeURIComponent($("#txtOtherPhone").val())
                + '","Website":"' + encodeURIComponent($("#txtWebsite").val()) + '","AddressLine1":"' + encodeURIComponent($("#txtAddress1").val()) + '","AddressLine2":"' + encodeURIComponent($("#txtAddress2").val())
                + '","AddressCity":"' + encodeURIComponent($("#txtCity").val()) + '","AddressState":"' + encodeURIComponent($("#txtState").val()) + '","AddressPostalCode":"' + encodeURIComponent($("#txtPostalCode").val())
                + '","AddressCountryID":"' + (isNullOrEmpty($("#ddlCountry").val().toString()) == true ? -1 : $("#ddlCountry").val()) + '","BillingName":"' + encodeURIComponent($("#txtBillingName").val())
                + '","BillingAddressLine1":"' + encodeURIComponent($("#txtBillingAddress1").val()) + '","BillingAddressLine2":"' + encodeURIComponent($("#txtBillingAddress2").val())
                + '","BillingAddressCity":"' + encodeURIComponent($("#txtBillingCity").val()) + '","BillingAddressState":"' + encodeURIComponent($("#txtBillingState").val())
                + '","BillingAddressPostalCode":"' + encodeURIComponent($("#txtBillingPostalCode").val()) + '","BillingAddressCountryID":"' + (isNullOrEmpty($("#ddlBillingCountry").val().toString()) == true ? -1 : $("#ddlBillingCountry").val())
                + '"}';

            PostRequest("RegisterOwner", postData, RegisterOwnerSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, success message will be showed in popup.
        function RegisterOwnerSuccess(response) {
            ClearControls('divContainer');
            SetCommunityOwnerSession(response);
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Registration', response, '#');
            $("btnRegister").prop('disabled', false);
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //var jsonResponse = JSON.parse(response.responseText);
            ErrorWindow('Registration', response, '#');
            $("btnRegister").prop('disabled', false);
        }

        //Sets owner values to sessoin variables.
        function SetCommunityOwnerSession(response) {

            var postData = "{IsCommunityOwner:'" + true + "', CommunityOwnerId:'" + response + "'}";
            $.ajax({
                type: "POST",
                url: $("#hdnWebUrl").val() + "SetCommunityOwnerSession",
                data: postData,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    GetResponse("GetAllowedPagesByOAuthAccount", "/" + $("#hdnOAuthAccountID").val(), GetAllowedPagesSuccess, Failure, ErrorHandler);
                    //SuccessWindow('Registration', 'Registered successfully.', 'CommunityOwnerDashboard.aspx');
                },
                failure: function (response) {
                    console.log(response);
                },
                error: function (response) {
                    console.log(response);
                }
            });
        }

        function GetAllowedPagesSuccess(response) {
            var postData = "{pages:'" + response + "'}";
            $.ajax({
                type: "POST",
                url: $("#hdnWebUrl").val() + "SetAllowedPages",
                data: postData,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {

                    SuccessWindow('Registration', 'Registered successfully.', 'CommunityOwnerDashboard.aspx');
                },
                failure: function (response) {
                    console.log(response);
                },
                error: function (response) {
                    console.log(response);
                }
            });
        }
        //Sets address information to billing details.
        function ToggleAddress() {

            if ($("#chkUseSameAddress").is(':checked')) {
                $("#txtBillingName").val($("#txtBusinessName").val());
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
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Register as Community Owner</h2>
    <div id="divContainer">
        <div class="row">
            <div class="form-horizontal col-md-12" role="form">
                <hr />
                <div class="col-md-4">
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Business Name</label>
                        </div>
                        <asp:HiddenField ID="hdfDateAdded" runat="server" />
                        <input type="text" id="txtBusinessName" name="txtBusinessName" class="form-control" placeholder="Business Name" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Email</label>
                        </div>
                        <input type="text" id="txtEmail" name="txtEmail" class="form-control" placeholder="Email" onblur="CheckOwnerEmail()" maxlength="200" />
                        <span id="spanEmail" class="custom-register-email-span"></span>
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Primary Phone</label>
                        </div>
                        <input type="text" id="txtPrimaryPhone" class="form-control" name="txtPrimaryPhone" placeholder="Primary Phone" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Other Phone</label>
                        </div>
                        <input type="text" id="txtOtherPhone" class="form-control" name="txtOtherPhone" placeholder="Other Phone" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Business Number</label>
                        </div>
                        <input type="text" id="txtBusinessNumber" class="form-control" name="txtBusinessNumber" placeholder="Business Number" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Website</label>
                        </div>
                        <input type="text" id="txtWebsite" class="form-control" name="txtWebsite" placeholder="Website" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <input id="ddlCurrency" name="ddlCurrency" onchange="CurrencyValidation()" class="custom-dropdown-width" />
                        <span id="spanCurrencyValidation" class="custom-regcomowner-email-validation-off">You can't leave this empty.</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="form-horizontal col-md-6" role="form">
                <h4>Address</h4>
                <hr />
                <div class="col-md-8">
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Address 1</label>
                        </div>
                        <input type="text" id="txtAddress1" class="form-control" name="txtAddress1" placeholder="Address 1" maxlength="150" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Address 2</label>
                        </div>
                        <input type="text" id="txtAddress2" class="form-control" name="txtAddress2" placeholder="Address 2" maxlength="150" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">City</label>
                        </div>
                        <input type="text" id="txtCity" class="form-control" name="txtCity" placeholder="City" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">State</label>
                        </div>
                        <input type="text" id="txtState" class="form-control" name="txtState" placeholder="State" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Postal Code</label>
                        </div>
                        <input type="text" id="txtPostalCode" class="form-control" name="txtPostalCode" placeholder="Postal Code" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Country</label>
                        </div>
                        <div id="ddlCountry" class="custom-dropdown-width"></div>
                    </div>
                    <div class="form-group">
                        <label for="chkUseSameAddress" class="checkbox custom-checkbox-textalign">
                            <span class="icons"><span class="first-icon fui-checkbox-unchecked"></span><span class="second-icon fui-checkbox-checked"></span></span>
                            <input type="checkbox" value="" id="chkUseSameAddress" data-toggle="checkbox" onchange="ToggleAddress()" />
                            Use same address for billing
                        </label>
                    </div>
                </div>
            </div>
            <div class="form-horizontal col-md-6" role="form">
                <h4>Billing Address</h4>
                <hr />
                <div class="col-md-8">
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Billing Name</label>
                        </div>
                        <input type="text" id="txtBillingName" class="form-control" name="txtBillingName" placeholder="Billing Name" maxlength="150" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Billing Address 1</label>
                        </div>
                        <input type="text" id="txtBillingAddress1" class="form-control" name="txtBillingAddress1" placeholder="Billing Address 1" maxlength="150" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Billing Address 2</label>
                        </div>
                        <input type="text" id="txtBillingAddress2" class="form-control" name="txtBillingAddress2" placeholder="Billing Address 2" maxlength="150" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Billing City</label>
                        </div>
                        <input type="text" id="txtBillingCity" class="form-control" name="txtBillingCity" placeholder="Billing City" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Billing State</label>
                        </div>
                        <input type="text" id="txtBillingState" class="form-control" name="txtBillingState" placeholder="Billing State" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Billing Postal Code</label>
                        </div>
                        <input type="text" id="txtBillingPostalCode" class="form-control" name="txtBillingPostalCode" placeholder="Billing Postal Code" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Billing Country</label>
                        </div>
                        <div id="ddlBillingCountry" class="custom-dropdown-width"></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-12 custom-regcomowner-button-continer-top-align">
            <div class="col-md-4"></div>
            <div class="col-md-4">
                <div class="form-group">
                    <input type="button" id="btnRegister" value="Register" class="btn btn-block btn-lg btn-primary" onclick="RegisterCommunityOwner()" />
                </div>
            </div>
            <div class="col-md-4"></div>
        </div>
    </div>
</asp:Content>
