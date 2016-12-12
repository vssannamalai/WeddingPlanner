<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="NewCommunity.aspx.cs" Inherits="RatingReviewEngine.Web.NewCommunity" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <link rel="Stylesheet" type="text/css" href="http://ajax.microsoft.com/ajax/jquery.ui/1.8.5/themes/dark-hive/jquery-ui.css" />
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&libraries=drawing"></script>

    <link rel="stylesheet" type="text/css" href="css/jquery-gmaps-latlon-picker.css" />
    <script src="js/jquery-gmaps-latlon-picker.js"></script>

    <style>
        .k-reset {
            font-size: 88% !important;
        }

        .col-md-2 {
            width: 14.4%;
            float: left;
        }
    </style>

    <script type="text/javascript">
        var exist = false;

        $(document).ready(function () {
            ControlValidation();
            ButtonClickEventOnLoad();
            BindCurrency();
            BindCountry();
            KeyDownEventOnLoad();
            OnBlurEventOnLoad();
        });

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    txtName: { required: true },
                    txtAreaRadius: { required: true }
                },
                messages: {
                    txtName: { required: 'You can\'t leave this empty.' },
                    txtAreaRadius: { required: 'You can\'t leave this empty.' }
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

        //Registers a button click event on page load.
        function ButtonClickEventOnLoad() {
            $('#btnRegister').click(function (e) {
                var dropDownValidation = false;
                if ($kendoJS("#ddlCurrency").data("kendoDropDownList").text() == 'Currency') {
                    $("#spanCurrencyValidation").removeClass("custom-login-email-validation-off").addClass("custom-login-email-validation-on");
                    dropDownValidation = true;
                }

                if ($kendoJS("#ddlCountry").data("kendoDropDownList").text() == 'Country') {
                    $("#spanCountryValidation").removeClass("custom-login-email-validation-off").addClass("custom-login-email-validation-on");
                    dropDownValidation = true;
                }

                var isValid = LatitudeLongitudeValidation();
                if ($("#frmRatingReviewEngine").valid() && !dropDownValidation && !isValid) {
                    CreateCommunity();
                }

                e.preventDefault();
            });
        }

        //Registers a keydown event on page load.
        function KeyDownEventOnLoad() {
            $('input[name="txtAreaRadius"]').keydown(function (e) {
                AllowDecimal(e);
            });

            //$('input[name="txtLatitude"]').keydown(function (e) {
            //    AllowDecimal(e);
            //});

            //$('input[name="txtLongitude"]').keydown(function (e) {
            //    AllowDecimal(e);
            //});
        }

        //Registers a onblur event on page load.
        function OnBlurEventOnLoad() {
            $('#txtAreaRadius').blur(function () {
                var val = this.value;
                if (val != '') {
                    if (DecimalValidation(val)) {
                        $("#spanAreaRadius").text('').css('display', 'none');
                        $("#txtAreaRadius").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                        isValid = false;
                    }
                    else {

                        $("#txtAreaRadius").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                        $("#spanAreaRadius").text('Please enter a valid AreaRadius value.').css('display', 'block').css('color', '#E74C3C');
                        isValid = true;
                    }
                }
                else {
                    $("#spanAreaRadius").text('').css('display', 'none');
                    isValid = true;
                }

            });
        }

        //Service call to bind currency list to dropdown.
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

        //Service call to bind country list to dropdown.
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
                // change: function onChange() { LocationSearch(this) },
                dataSource: countryDataSource
            });
        }

        //This method validated currency dropdown for empty value.
        function CurrencyValidation() {
            if ($kendoJS("#ddlCurrency").data("kendoDropDownList").text() != 'Currency') {
                $("#spanCurrencyValidation").removeClass("custom-login-email-validation-on").addClass("custom-login-email-validation-off");
            }
            else {
                $("#spanCurrencyValidation").removeClass("custom-login-email-validation-off").addClass("custom-login-email-validation-on");
            }
        }

        //This method validated country dropdown for empty value.
        function CountryValidation() {
            if ($kendoJS("#ddlCountry").data("kendoDropDownList").text() != 'Country') {
                $("#spanCountryValidation").removeClass("custom-login-email-validation-on").addClass("custom-login-email-validation-off");
            }
            else {
                $("#spanCountryValidation").removeClass("custom-login-email-validation-off").addClass("custom-login-email-validation-on");
            }
        }

        //This method will search google map based on address fields.
        function LocationSearch(id) {
            var address;
            address = $("#txtAddress1").val() + ' ' + $("#txtCity").val() + ' ' + $("#txtState").val() + ' ' + $("#txtPostalCode").val() + ' ' + ($kendoJS("#ddlCountry").data("kendoDropDownList").text() == "Country" ? ' ' : $kendoJS("#ddlCountry").data("kendoDropDownList").text());
            if (!isNullOrEmpty($.trim(address))) {
                $('.gllpSearchField').val(address);
                $('.gllpSearchButton').click();
            }
            switch (id.id) {
                case "txtAddress1":
                    $("#txtAddress2").focus();
                    break;
                case "txtCity":
                    $("#txtState").focus();
                    break;
                case "txtState":
                    $("#txtPostalCode").focus();
                    break;
                case "txtPostalCode":
                    $("#ddlCountry").focus();
                    break;
            }
        }

        //Service call to check community name already exist.
        function CheckCommunityName() {
            if ($("#txtName").val() != '') {
                //var param = "/0/" + $("#txtName").val();
                //GetResponse("CheckCommunityNameExist", param, CheckCommunityNameSuccess, Failure, ErrorHandler);
                var postData = '{"ID":"' + "0" + '","Name":"' + encodeURIComponent($.trim($("#txtName").val())) + '"}';
                PostRequest("CheckCommunityNameExist", postData, CheckCommunityNameSuccess, Failure, ErrorHandler);
            }
            else {
                $("#txtName").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                $("#spanName").text('').css('display', 'none');
            }
        }

        //On ajax call success, validates the corresponding field.
        function CheckCommunityNameSuccess(response) {
            if (response == "1") {
                $("#txtName").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#spanName").text('Name already exist.').css('display', 'block');
                exist = true;
            }
            else {
                $("#txtName").closest('.form-group').removeClass('form-group has-error').addClass('form-group').removeAttr('style');
                $("#spanName").text('').css('display', 'none');
                exist = false;
                AddCommunity();
            }
        }

        //This method validated latitude and longitude fields for empty and decimal.
        function LatitudeLongitudeValidation() {
            var isValid = false;
            if ($("#txtLatitude").val() == "") {
                $("#txtLatitude").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#latitudeVadiation").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                isValid = true;
            }
            else {
                if (DecimalValidation($("#txtLatitude").val())) {
                    $("#latitudeVadiation").css('display', 'none');
                    $("#txtLatitude").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                    isValid = false;
                }
                else {
                    $("#txtLatitude").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                    $("#latitudeVadiation").text('Please enter a valid latitude value.').css('display', 'block').css('color', '#E74C3C');
                    isValid = true;
                }
            }

            if ($("#txtLongitude").val() == "") {
                $("#txtLongitude").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#longitudeVadiation").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                isValid = true;
            }
            else {
                if (DecimalValidation($("#txtLongitude").val())) {
                    $("#longitudeVadiation").css('display', 'none');
                    $("#txtLongitude").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                    isValid = false;
                }
                else {
                    $("#txtLongitude").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                    $("#longitudeVadiation").text('Please enter a valid longitude value.').css('display', 'block').css('color', '#E74C3C');
                    isValid = true;
                }
            }

            return isValid;
        }

        //This method checks form validation and calls AddCommunity() method.
        function CreateCommunity() {
            if ($("#frmRatingReviewEngine").valid() && !LatitudeLongitudeValidation()) {
                CheckCommunityName();
            }
        }

        //Service call to save community details.
        function AddCommunity() {
            var postData = '{"Name":"' + encodeURIComponent($.trim($("#txtName").val())) + '","Description":"' + encodeURIComponent($.trim($("#txtDescription").val())) + '","CurrencyId":"' + (isNullOrEmpty($("#ddlCurrency").val().toString()) == true ? -1 : $("#ddlCurrency").val())
            + '","CountryName" : "' + ($kendoJS("#ddlCountry").data("kendoDropDownList").text() == "Country" ? "" : $kendoJS("#ddlCountry").data("kendoDropDownList").text()) + '", "CountryID":"' + (isNullOrEmpty($("#ddlCountry").val().toString()) == true ? -1 : $("#ddlCountry").val()) + '","OwnerID":"' + $("#hdnCommunityOwnerId").val() + '","CentreLongitude":"' + $("#txtLongitude").val()
            + '","CentreLatitude":"' + $("#txtLatitude").val() + '","AreaRadius":"' + $("#txtAreaRadius").val() + '","Active":"true"}';

            PostRequest("NewCommunity", postData, AddCommunitySuccess, Failure, ErrorHandler);
        }

        //On ajax call success, success message will be showed in popup.
        function AddCommunitySuccess(response) {
            ClearControls('divCommunity');
            SuccessWindow('New Community', 'Community created successfully.', 'CommunityOwnerDashboard.aspx');
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('New Community', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('New Community', response, '#');
        }
    </script>
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">New Community </h2>
    <div id="divCommunity" class="row">
        <hr />
        <div class="col-md-12">
            <div class="form-horizontal col-md-4" role="form">
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">Name</label>
                    </div>
                    <input type="text" id="txtName" name="txtName" class="form-control" placeholder="Name" maxlength="50" />
                    <span id="spanName" class="custom-register-email-span"></span>
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">Description</label>
                    </div>
                    <input type="text" id="txtDescription" name="txtDescription" class="form-control" placeholder="Description" maxlength="200" />
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">Currency</label>
                    </div>
                    <input id="ddlCurrency" name="ddlCurrency" onchange="CurrencyValidation()" class="custom-dropdown-width" />
                    <span id="spanCurrencyValidation" class="custom-login-email-validation-off">You can't leave this empty.</span>
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">Country</label>
                    </div>
                    <input id="ddlCountry" name="ddlCountry" onchange="CountryValidation()" class="custom-dropdown-width" />
                    <span id="spanCountryValidation" class="custom-login-email-validation-off">You can't leave this empty.</span>
                </div>
                <div class="form-group">
                    <div>
                        <label class="custom-field-label-fontstyle">Approximate Area Radius (Km)</label>
                    </div>
                    <input type="text" id="txtAreaRadius" name="txtAreaRadius" class="form-control" placeholder="Approximate Area Radius" maxlength="10" />
                    <span id="spanAreaRadius" class="custom-register-email-span"></span>
                </div>
            </div>
            <div class="col-md-2"></div>
            <div class="col-md-6">
                <fieldset class="gllpLatlonPicker">
                    <div class="form-group" id="divMapSearch">
                        <input type="text" class="gllpSearchField form-control custom-newcommunity-search-textbox" placeholder="Search" style="margin-left: 0px !important;" />
                        <input type="button" class="gllpSearchButton btn btn-primary custom-newcommunity-search-button" value="Search by Location" />
                    </div>
                    <br />
                    <br />
                    <div class="gllpMap mapDisable" id="gllpMap">Google Maps</div>
                    <br />
                    <div class="col-md-12">
                        <div class="col-md-6" style="margin-left: -31px;">
                            <label class="custom-field-label-fontstyle">Latitude</label>
                        </div>
                        <div class="col-md-6" style="margin-left: 8px;">
                            <label class="custom-field-label-fontstyle">Longitude</label>
                        </div>
                    </div>
                    <div id="divMapLatLon" style="margin-left: -13px;">
                        <div class="form-group">
                            <input type="text" class="gllpLatitude form-control custom-newcommunity-latlon-textbox" placeholder="Latitude" id="txtLatitude" name="txtLatitude" onblur="LatitudeLongitudeValidation()" />
                            <input type="hidden" id="hdftLatitude" />
                        </div>
                        <label class="custom-comownerdash-slash-align">/</label>
                        <div class="form-group">

                            <input type="text" class="gllpLongitude form-control custom-newcommunity-latlon-textbox" placeholder="Longitude" id="txtLongitude" name="txtLongitude" onblur="LatitudeLongitudeValidation()" />
                            <input type="hidden" id="hdfLongitude" />
                        </div>
                    </div>
                    <div class="col-md-6" style="margin-left: -14px;">
                        <span id="latitudeVadiation" class="custom-supplierdashboard-email-validation-off"></span>
                    </div>
                    <div class="col-md-6" style="margin-left: -5px;">
                        <span id="longitudeVadiation" class="custom-supplierdashboard-email-validation-off"></span>
                    </div>
                    <div class="custom-comownerdash-updatemap-button" id="divMapUpdate">
                        <input type="button" class="gllpUpdateButton btn btn-primary" value="Search by Co-ordinate" onclick="LatitudeLongitudeValidation()" />
                    </div>
                    <div style="display: none;">
                        zoom:
                            <input type="text" class="gllpZoom" value="3" />
                        <input type="text" class="gllpLocationName form-control custom-regsupplier-location-textbox" placeholder="Longitude" />
                    </div>
                </fieldset>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4"></div>
            <div class="col-md-4">
                <div class="form-group custom-newcommunity-create-top">
                    <input type="button" id="btnRegister" value="Create" class="btn btn-block btn-lg btn-primary" />
                </div>
            </div>
            <div class="col-md-4"></div>
        </div>
    </div>
</asp:Content>
