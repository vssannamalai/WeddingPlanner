<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="SupplierDashboard.aspx.cs" Inherits="RatingReviewEngine.Web.SupplierDashboard" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <%--<link rel="Stylesheet" type="text/css" href="http://ajax.microsoft.com/ajax/jquery.ui/1.8.5/themes/dark-hive/jquery-ui.css" />--%>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&libraries=drawing"></script>

    <link rel="stylesheet" type="text/css" href="css/jquery-gmaps-latlon-picker.css" />
    <script src="js/jquery-gmaps-latlon-picker.js"></script>

    <%--<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/jquery.bootstrapvalidator/0.5.0/css/bootstrapValidator.min.css"/>
        <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.bootstrapvalidator/0.5.0/js/bootstrapValidator.min.js"></script>--%>

    <style>
        .has-error .form-control-feedback {
            color: #E74C3C;
        }

        .has-success .form-control-feedback {
            color: #18BCA0;
        }

        .k-reset {
            font-size: 100% !important;
        }

        .k-header {
            color: White;
            background-color: #34495E;
            font-size: 16px;
        }

        .k-label {
            font-size: 15px;
        }

        .k-button {
            background-color: #1ABC9C !important;
            color: #FFFFFF !important;
        }

        #tbody, tr {
            vertical-align: top;
            font-size: 15px;
        }

        body {
            font-size: 14px !important;
        }

        .k-pager-numbers .k-link {
            line-height: 2.28em !important;
        }

        .thumbnail > img, .thumbnail a > img {
            height: 100% !important;
        }

        img {
            line-height: 50px;
            text-align: center;
        }

        .k-list-container {
            width: auto !important;
            min-width: 330px;
        }

        @media only screen and (min-width: 768px) and (max-width: 1024px) {

            .k-list-container {
                width: auto !important;
                min-width: 270px;
            }
        }

        .help-block {
            display: none !important;
        }

        .has-success .help-block {
            display: none !important;
        }

        .has-error .help-block {
            display: block !important;
        }
    </style>

    <%-- <script src="jQuery-File-Upload-master/js/jquery.min.js"></script>--%>
    <%-- <script src="js/jquery-1.11.1.min.js"></script>
    <script type="text/javascript">
        var $uploadJS = jQuery.noConflict();
    </script>--%>



    <script>
        var uploadIconError = false, uploadLogoError = false;


        function UploadSupplierLogo() {
            $("#progress").show();
            var urlUploadLogo = $("#hdnFileUploadUrl").val() + 'SaveSupplierLogo';
            //$uploadJS
            $('#fileupload1').fileupload({
                dataType: 'text',
                // autoUpload: false,
                url: urlUploadLogo,
                always: function (e, data) {
                    if (data.result == "Error"
                        ||
                        data.result.indexOf('Error') != -1) {
                        uploadLogoError = true;
                    }
                    UploadSupplierIcon();
                }
            });

            var img = $("#divImageLogo").find('img')[0];
            if (img == null) {
                var param = "/" + $("#hdnSupplierId").val();
                GetResponse("RemoveSupplierLogo", param, RemoveSupplierLogoSuccess, Failure, ErrorHandler);
            }

            if (getFileName('fileupload1') == '') {
                UploadSupplierIcon();
            } else {
                //$uploadJS
                $('#fileupload1').fileupload('add', {
                    dataType: 'text',
                    fileInput: $('#fileupload1'),
                    formData: { supplierid: $("#hdnSupplierId").val() }
                });
            }
        }

        function RemoveSupplierLogoSuccess(response) {
            GetSupplierLogo($("#hdnSupplierId").val());
        }

        function RemoveSupplierIconSuccess(response) {
            GetSupplierIcon($("#hdnSupplierId").val());
        }

        function ShowUpdateSuccess() {
            var strErrorMessage = "";

            if (uploadLogoError == false && uploadIconError == false) {
                SuccessWindow('Supplier Dashboard', 'Supplier information has been updated successfully.', '#');
            } else {
                if (uploadLogoError == true && uploadIconError == true) {
                    strErrorMessage = "<br><span style='color:#ff0000;'>The Logo and Icon were not updated since the uploaded image files appear to be damaged or corrupted.</span>";
                }
                else if (uploadLogoError == true) {
                    strErrorMessage = "<br><span style='color:#ff0000;'>The Logo is not updated since the uploaded image file appears to be damaged or corrupted.</span>";
                } else {
                    strErrorMessage = "<br><span style='color:#ff0000;'>The Icon is not updated since the uploaded image file appears to be damaged or corrupted.</span>";
                }
                FailureWindow('Supplier Dashboard', 'Supplier information has been updated successfully.' + strErrorMessage, '#');
            }
        }

        function UploadSupplierIcon() {
            var urlUploadLogo = $("#hdnFileUploadUrl").val() + 'SaveSupplierIcon';
            //$uploadJS
            $('#fileupload2').fileupload({
                dataType: 'text',
                // autoUpload: false,
                url: urlUploadLogo,
                always: function (e, data) {
                    if (data.result == "Error" ||
                            data.result.indexOf('Error') != -1
                    ) {
                        uploadIconError = true;
                    }

                    GetSupplier($("#hdnSupplierId").val());
                    GetSupplierIcon($("#hdnSupplierId").val());
                    GetSupplierLogo($("#hdnSupplierId").val());
                    HideEdit();
                    $("#progress").hide();
                    ShowUpdateSuccess();

                    //$.ajax({
                    //    url: "http://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&callback=MapApiLoaded",
                    //    dataType: "script",
                    //    timeout: 8000,
                    //    error: function () {
                    //        // Handle error here
                    //    }
                    //});
                }
            });

            var img = $("#divImageIcon").find('img')[0];
            if (img == null) {
                var param = "/" + $("#hdnSupplierId").val();
                GetResponse("RemoveSupplierIcon", param, RemoveSupplierIconSuccess, Failure, ErrorHandler);
            }

            if (getFileName('fileupload2') == '') {
                GetSupplier($("#hdnSupplierId").val());
                GetSupplierIcon($("#hdnSupplierId").val());
                GetSupplierLogo($("#hdnSupplierId").val());
                HideEdit();
                ShowUpdateSuccess();
                //$.ajax({
                //    url: "http://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&callback=MapApiLoaded",
                //    dataType: "script",
                //    timeout: 8000,
                //    error: function () {
                //        // Handle error here
                //    }
                //});
            } else {
                //$uploadJS
                $('#fileupload2').fileupload('add', {
                    dataType: 'text',
                    fileInput: $('#fileupload2'),
                    formData: { supplierid: $("#hdnSupplierId").val() }
                });
            }
        }

    </script>

    <script type="text/javascript">
        var companynameExist = false;
        var emailExist = false;

        $(document).ready(function () {
            ControlValidation();
            BindCountry();
            BindSocialMedia();
            GetSupplier($("#hdnSupplierId").val());
            GetSupplierSocialReference($("#hdnSupplierId").val());
            GetCommunityDetailBySupplier($("#hdnSupplierId").val());
            GetSupplierIcon($("#hdnSupplierId").val());
            GetSupplierLogo($("#hdnSupplierId").val());
            KeyDownEventOnLoad();
            $("#divEdit").hide();
        });

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    txtName: { required: true },
                    txtEmail: { required: true, email: true },
                    txtAddress1: { required: true },
                    txtCity: { required: true },
                    txtState: { required: true },
                    txtWebsite: { url: true },
                    txtQuoteTerms: { required: true },
                    txtDepositPercent: { required: true },
                    txtDepositTerms: { required: true }
                },
                messages: {
                    txtName: { required: 'You can\'t leave this empty.' },
                    txtEmail: { required: 'You can\'t leave this empty.', email: 'Invalid email.' },
                    txtAddress1: { required: 'You can\'t leave this empty.' },
                    txtCity: { required: 'You can\'t leave this empty.' },
                    txtState: { required: 'You can\'t leave this empty.' },
                    txtWebsite: { url: 'Invalid URL (http://example.com).' },
                    txtQuoteTerms: { required: 'You can\'t leave this empty.' },
                    txtDepositPercent: { required: 'You can\'t leave this empty.' },
                    txtDepositTerms: { required: 'You can\'t leave this empty.' }
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

        //Bind social media list to dropdown.
        function BindSocialMedia() {
            $kendoJS("#ddlSocialMedia").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "SocialMediaID",
                index: 0,
                suggest: true,
                optionLabel: "Social Media",
                filter: "contains",
                dataSource: {
                    transport: {
                        read: {
                            dataType: "json",
                            beforeSend: setHeader,
                            url: $("#hdnAPIUrl").val() + "GetSocialMedia"
                        }
                    }
                }
            });
        }

        //Registers a keydown event on page load.
        function KeyDownEventOnLoad() {
            $('input[name="txtDepositPercent"]').keydown(function (e) {
                AllowDecimal(e);
            });
        }

        //Service call to fetch supplier detail based on supplieId.
        function GetSupplier(supplierId) {
            var param = "/" + supplierId;
            GetResponse("GetSupplier", param, GetSupplierSuccess, Failure, ErrorHandler);
        }

        //Service call to fetch supplier icon based on supplieId.
        function GetSupplierIcon(supplierId) {
            $("#iconLoading").show();
            $('#imgIcon').attr('alt', 'Supplier Icon');
            var param = "/" + supplierId;
            GetResponse("SupplierIconSelect", param, GetSupplierIconSuccess, Failure, ErrorHandler);
        }

        //Service call to fetch supplier logo based on supplieId.
        function GetSupplierLogo(supplierId) {
            $("#logoLoading").show();
            $('#imgLogo').attr('alt', 'Supplier Logo');
            var param = "/" + supplierId;
            GetResponse("SupplierLogoSelect", param, GetSupplierLogoSuccess, Failure, ErrorHandler);
        }

        function encode(data) {
            var str = String.fromCharCode.apply(null, data);
            return btoa(str).replace(/.{76}(?=.)/g, '$&\n');
        }

        //On ajax call success, binds the icon to the respective control.
        function GetSupplierIconSuccess(response) {
            $("#iconLoading").hide();
            if (response.Base64String != null) {
                $('#imgIcon').attr('src', 'data:image/png' + ';base64,' + response.Base64String);
                var imageSrc = 'data:image/png;base64,' + response.Base64String;
                $("#hdnIcon").val(imageSrc);
            } else {
                $('#imgIcon').removeAttr('src');
                $('#imgIcon').attr('alt', 'No icon available');
                $("#hdnIcon").val('');
            }
        }

        //On ajax call success, binds the logo to the respective control.
        function GetSupplierLogoSuccess(response) {
            $("#logoLoading").hide();
            if (response.Base64String != null) {
                $('#imgLogo').attr('src', 'data:image/png' + ';base64,' + response.Base64String);
                var imageSrc = 'data:image/png;base64,' + response.Base64String;
                $("#hdnLogo").val(imageSrc);
            } else {
                $('#imgLogo').removeAttr('src');
                $('#imgLogo').attr('alt', 'No logo available');
                $("#hdnLogo").val('');
            }
        }

        //On ajax call success, binds supplier detail to the respective controls and calls MapApiLoaded() method.
        function GetSupplierSuccess(response) {
            $("#lblName").text(response.CompanyName);
            $("#lblEmail").text(response.Email);
            $("#lblPrimaryPhone").text(response.PrimaryPhone);
            $("#lblOtherPhone").text(response.OtherPhone);
            $("#lblBusinessNumber").text(response.BusinessNumber);
            $("#lblDepositPercent").text(response.DepositPercent);
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
            $("#lblQuoteTerms").html(htmlEncode(response.QuoteTerms).replace(/\n/g, "<br>"));
            $("#lblDepositTerms").html(htmlEncode(response.DepositTerms).replace(/\n/g, "<br>"));

            $("#hdfQuoteTerms").val(response.QuoteTerms);
            $("#hdfDepositTerms").val(response.DepositTerms);

            $("#lblWebsite").text(response.Website);
            $("#lblWebsite").attr('href', response.Website);

            $("#hdfDateAdded").val(response.DateAdded);
            $("#hdfCountryID").val(response.AddressCountryID);
            $("#hdfBillingCountryID").val(response.BillingAddressCountryID);
            $("#hdfLatitude").val(response.Latitude);
            $("#hdfLongitude").val(response.Longitude);

            $("#txtLatitude").val($("#hdfLatitude").val());
            $("#txtLongitude").val($("#hdfLongitude").val());

            $('.gllpUpdateButton').click();

            MapApiLoaded();
        }

        //Loads google map.
        function MapApiLoaded() {
            // Create google map

            $('.gllpMap1').each(function () {

                var lat = $("#hdfLatitude").val();
                var log = $("#hdfLongitude").val();

                map = new google.maps.Map(this, {
                    zoom: 8,
                    mapTypeId: google.maps.MapTypeId.ROADMAP,
                    panControl: false,
                    streetViewControl: false,
                    mapTypeControl: true
                });
                map.setCenter(new google.maps.LatLng(lat, log));
                var point = new google.maps.LatLng(lat, log);

                var marker = new google.maps.Marker({
                    position: point,
                    title: "Drag this Marker",
                    map: map,
                    draggable: false
                });

                // Add marker
                google.maps.event.addListener(marker, 'dragend', function (event) {
                    setPosition(point);
                });
                // Trigger resize to correctly display the map
                google.maps.event.trigger(map, "resize");

                // Map loaded trigger
                google.maps.event.addListenerOnce(map, 'idle', function () {
                    // Fire when map tiles are completly loaded
                });
            });
        }

        //Service call to check supplier name already exist.
        function CheckSupplierCompanyName() {
            if ($.trim($("#txtName").val()) != '') {
                //var param = "/" + $("#hdnSupplierId").val() + "/" + encodeURIComponent($.trim($("#txtName").val())).replace(/'/g, "%27").replace(/"/g, "%22");;
                //GetResponse("CheckSupplierCompanyName", param, CheckSupplierCompanyNameSuccess, Failure, ErrorHandler);
                var postData = '{"ID":"' + $("#hdnSupplierId").val() + '","Name":"' + encodeURIComponent($.trim($("#txtName").val())) + '"}';
                PostRequest("CheckSupplierCompanyName", postData, CheckSupplierCompanyNameSuccess, Failure, ErrorHandler);
            }
        }

        //On ajax call success, validates the corresponding field.
        function CheckSupplierCompanyNameSuccess(response) {
            if (response == "1") {
                $("#txtName").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#spanSupplierName").text('Supplier Name already exist.').css('display', 'block');
                companynameExist = true;
            }
            else {
                $("#spanSupplierName").text('').css('display', 'none');
                companynameExist = false;
            }
        }

        //Service call to check supplier email already exist.
        function CheckSupplierEmail() {
            if ($.trim($("#txtEmail").val()) != '') {
                var param = "/" + $("#hdnSupplierId").val() + "/" + encodeURIComponent($.trim($("#txtEmail").val()));
                GetResponse("CheckSupplierEmail", param, CheckSupplierEmailSuccess, Failure, ErrorHandler);
            }
        }

        //On ajax call success, validates the corresponding field.
        function CheckSupplierEmailSuccess(response) {
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

        //This method validated latitude and longitude fields for empty and decimal.
        function LatitudeLongitudeValidation() {
            var isValid = false;
            if ($.trim($("#txtLatitude").val()) == "") {
                $("#txtLatitude").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#latitudeVadiation").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                isValid = true;
            }
            else {
                if (DecimalValidation($.trim($("#txtLatitude").val()))) {
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

            if ($.trim($("#txtLongitude").val()) == "") {
                $("#txtLongitude").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#longitudeVadiation").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                isValid = true;
            }
            else {
                if (DecimalValidation($.trim($("#txtLongitude").val()))) {
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

        //Checks for validation and calls Supplierupdate() method.
        function UpdateSupplier() {
            if (isValidInput() && companynameExist == false && emailExist == false && !LatitudeLongitudeValidation()) {
                uploadIconError = false, uploadLogoError = false;
                SupplierUpdate();
            }
        }

        //Service call to update supplier information.
        function SupplierUpdate() {
            var postData = '{"OAuthAccountID":"' + $("#hdnOAuthAccountID").val() + '","SupplierID":"' + $("#hdnSupplierId").val() + '","CompanyName":"' + encodeURIComponent($.trim($("#txtName").val())) +
                '","Email":"' + $.trim($("#txtEmail").val()) + '","BusinessNumber":"' + encodeURIComponent($.trim($("#txtBusinessNumber").val())) + '","DateAdded":"' + $("#hdfDateAdded").val()
                + '","PrimaryPhone":"' + encodeURIComponent($.trim($("#txtPrimaryPhone").val())) + '","OtherPhone":"' + encodeURIComponent($.trim($("#txtOtherPhone").val()))
                + '","Website":"' + $.trim($("#txtWebsite").val()) + '","AddressLine1":"' + encodeURIComponent($.trim($("#txtAddress1").val())) + '","AddressLine2":"' + encodeURIComponent($.trim($("#txtAddress2").val()))
                + '","AddressCity":"' + encodeURIComponent($.trim($("#txtCity").val())) + '","AddressState":"' + encodeURIComponent($.trim($("#txtState").val())) + '","AddressPostalCode":"' + encodeURIComponent($.trim($("#txtPostalCode").val()))
                + '","AddressCountryID":"' + (isNullOrEmpty(($("#ddlCountry").val().toString())) == true ? -1 : $("#ddlCountry").val()) + '","BillingName":"' + encodeURIComponent($.trim($("#txtBillingName").val()))
                + '","BillingAddressLine1":"' + encodeURIComponent($.trim($("#txtBillingAddress1").val())) + '","BillingAddressLine2":"' + encodeURIComponent($.trim($("#txtBillingAddress2").val()))
                + '","BillingAddressCity":"' + encodeURIComponent($.trim($("#txtBillingCity").val())) + '","BillingAddressState":"' + encodeURIComponent($.trim($("#txtBillingState").val()))
                + '","BillingAddressPostalCode":"' + encodeURIComponent($.trim($("#txtBillingPostalCode").val())) + '","BillingAddressCountryID":"' + (isNullOrEmpty(($("#ddlBillingCountry").val().toString())) == true ? -1 : $("#ddlBillingCountry").val())
                + '","QuoteTerms":"' + encodeURIComponent($.trim($("#txtQuoteTerms").val())) + '","DepositPercent":"' + $.trim($("#txtDepositPercent").val()) + '","DepositTerms":"' + encodeURIComponent($.trim($("#txtDepositTerms").val()))
                + '","Latitude": "' + ($.trim($("#txtLatitude").val()) == "" ? 0 : $.trim($("#txtLatitude").val())) + '","Longitude": "' + ($.trim($("#txtLongitude").val()) == "" ? 0 : $.trim($("#txtLongitude").val()))
                + '","AddressCountryName":"' + ($kendoJS("#ddlCountry").data("kendoDropDownList").text() == "Country" ? "" : $kendoJS("#ddlCountry").data("kendoDropDownList").text())
                + '","BillingAddressCountryName":"' + ($kendoJS("#ddlBillingCountry").data("kendoDropDownList").text() == "Billing Country" ? "" : $kendoJS("#ddlBillingCountry").data("kendoDropDownList").text()) + '"}';

            PostRequest("UpdateSupplier", postData, UpdateSupplierSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, displays a success message on popup.
        function UpdateSupplierSuccess(response) {
            BindCountry();
            UploadSupplierLogo();
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            if ($.isEmptyObject(response)) {
                FailureWindow('Dashboard Failure', response, '#');
            }
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Dashboard Error', response, '#');
        }

        //Service call to fetch supplier social reference details.
        function GetSupplierSocialReference(supplierId) {
            var param = "/" + supplierId;
            GetResponse("GetSupplierSocialReference", param, GetSupplierSocialReferenceSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the details to listview.
        function GetSupplierSocialReferenceSuccess(response) {
            //ListView datasource bind.
            $kendoJS("#lsvSocialReference").kendoListView({
                dataSource: response,
                template: kendo.template($("#socialReferenceTemplate").html())
            });
        }

        //To display edit controls on edit mode.
        function ShowEdit() {
            isBrokenLogo = false;
            isBrokenIcon = false;

            $('#fileupload1').val("");
            $('#fileupload2').val("");

            $("#divLabel").hide();
            $("#divEdit").show();
            $("#txtName").val($("#lblName").text());
            $("#txtEmail").val($("#lblEmail").text());
            $("#txtPrimaryPhone").val($("#lblPrimaryPhone").text());
            $("#txtOtherPhone").val($("#lblOtherPhone").text());
            $("#txtBusinessNumber").val($("#lblBusinessNumber").text());
            $("#txtWebsite").val($("#lblWebsite").text());
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
            $("#txtDepositPercent").val($("#lblDepositPercent").text());
            $("#txtQuoteTerms").val($("#hdfQuoteTerms").val());
            $("#txtDepositTerms").val($("#hdfDepositTerms").val());

            $kendoJS("#ddlCountry").data("kendoDropDownList").value($("#hdfCountryID").val().toString());
            $kendoJS("#ddlBillingCountry").data("kendoDropDownList").value($("#hdfBillingCountryID").val().toString());

            $("#txtLatitude").val($("#hdfLatitude").val());
            $("#txtLongitude").val($("#hdfLongitude").val());

            google.maps.event.trigger($(".gllpMap")[0], 'resize');
            $('.gllpEditButton').click();

            if ($("#hdnIcon").val() != "") {
                $('#divImageIcon').prepend('<img src=' + $("#hdnIcon").val() + '>');
                $('#divIcon').removeClass('fileinput-new').addClass('fileinput-exists');
            }
            else {
                $('#divImageIcon').html('');
                $('#divIcon').addClass('fileinput-new').removeClass('fileinput-exists');
            }

            if ($("#hdnLogo").val() != "") {
                $('#divImageLogo').prepend('<img src=' + $("#hdnLogo").val() + '>');
                $('#divLogo').removeClass('fileinput-new').addClass('fileinput-exists');
            }
            else {
                $('#divImageLogo').html('');
                $('#divLogo').addClass('fileinput-new').removeClass('fileinput-exists');
            }

            $("#chkUseSameAddress").prop('checked', false);
            $("#chkUseSameAddress").closest('label').removeClass('checked');
        }

        //To hide edit controls on normal mode.
        function HideEdit() {
            ClearValidation();
            $("#txtLatitude").closest('.form-group').removeClass('has-error');
            $("#txtLongitude").closest('.form-group').removeClass('has-error');
            //$("#latitudeVadiation").removeClass("custom-supplierdashboard-email-validation-on").addClass("custom-supplierdashboard-email-validation-off");
            //$("#longitudeVadiation").removeClass("custom-supplierdashboard-email-validation-on").addClass("custom-supplierdashboard-email-validation-off");
            $("#longitudeVadiation").hide();
            $("#latitudeVadiation").hide()

            $("#divLabel").show();
            $("#divEdit").hide();

            $('#divImageIcon').html('');
            $('#divImageLogo').html('');
            //$uploadJS
            $('#fileupload1').fileupload('destroy');
            //$uploadJS
            $('#fileupload2').fileupload('destroy');
        }

        //Validated social media dropdown.
        function SocialMediaValidation() {
            if ($kendoJS("#ddlSocialMedia").data("kendoDropDownList").text() != 'Social Media') {
                $("#spanSocialMediaValidation").removeClass("custom-supplierdashboard-email-validation-on").addClass("custom-supplierdashboard-email-validation-off");
            }
            else {
                $("#spanSocialMediaValidation").removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on");
            }
        }

        //Validates social reference field.
        function SocialReferenceValidation() {
            if ($("#txtSocialReference").val() == '')
                $("#spanSocialReferenceValidation").removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on");

            else {
                $("#spanSocialReferenceValidation").removeClass("custom-supplierdashboard-email-validation-on").addClass("custom-supplierdashboard-email-validation-off");
            }
        }

        //Checks social media fields for validation and calls CheckSocialMediaExist() method.
        function AddSupplierSocial() {
            var dropDownValidation = false;
            if ($kendoJS("#ddlSocialMedia").data("kendoDropDownList").text() == 'Social Media') {
                $("#spanSocialMediaValidation").removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on");
                dropDownValidation = true;
            }

            var textValidation = false;
            if ($.trim($("#txtSocialReference").val()) == '') {
                $("#spanSocialReferenceValidation").removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on");
                textValidation = true;
            }

            if ($("#frmRatingReviewEngine").valid() && dropDownValidation == false && textValidation == false) {
                CheckSocialMediaExist();
            }
        }

        //Service call to check whether social media already exist for the supplier.
        function CheckSocialMediaExist() {
            var param = '/' + $("#hdnSupplierId").val() + '/' + (isNullOrEmpty(($("#ddlSocialMedia").val().toString())) == true ? -1 : $("#ddlSocialMedia").val());
            GetResponse("GetSupplierSocialReferenceBySocialMedia", param, CheckSocialMediaExistSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, validates the corresponding field.
        function CheckSocialMediaExistSuccess(response) {
            if (response.SupplierSocialReferenceID == 0) {
                $("#spanSocialMediaValidation").removeClass("custom-supplierdashboard-email-validation-on").addClass("custom-supplierdashboard-email-validation-off");
                SupplierSocialInsert();
            }
            else {
                $("#spanSocialMediaValidation").text('Social media already exist.');
                $("#spanSocialMediaValidation").removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on");
            }
        }

        //Service call to save social media information.
        function SupplierSocialInsert() {
            var postData = '{"SupplierID":"' + $("#hdnSupplierId").val() + '","SocialMediaID":"' + (isNullOrEmpty(($("#ddlSocialMedia").val().toString())) == true ? -1 : $("#ddlSocialMedia").val()) + '", "SocialMediaReference":"' + $.trim($("#txtSocialReference").val()) + '"}';
            PostRequest("AddSupplierSocial", postData, AddSupplierSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, displays success message and binds the listview.
        function AddSupplierSuccess(response) {
            ClearControls('divSocialMedia');
            $kendoJS("#ddlSocialMedia").data("kendoDropDownList").value(0);
            GetSupplierSocialReference($("#hdnSupplierId").val());
            SuccessWindow('Social Media', 'Saved successfully.', '#');
        }

        //Service call to remove social media based on reference id.
        function RemoveSupplierSocial(supplierSocialReferenceId) {
            var param = '/' + supplierSocialReferenceId;
            GetResponse("RemoveSupplierSocial", param, RemoveSupplierSocialSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, displays a success message on popup.
        function RemoveSupplierSocialSuccess(response) {
            GetSupplierSocialReference($("#hdnSupplierId").val());
            SuccessWindow('Dashboard', 'Deleted successfully.', '#');
        }

        //Service call to fetch supplier community detail.
        function GetCommunityDetailBySupplier(supplierId) {
            var param = "/" + supplierId;
            GetResponse("GetCommunityCommunityGroupBySupplier", param, GetCommunityDetailBySupplierSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the details to grid.
        function GetCommunityDetailBySupplierSuccess(response) {
            $kendoJS("#gvCommunityDetail").kendoGrid({
                dataSource: {
                    pageSize: 10,
                    data: response,
                    serverPaging: true,
                    serverSorting: true
                },
                pageable: true,
                scrollable: false,
                columns: [
                    { field: "Credit", width: 200, title: "Credit", template: '<a class="custom-anchor" href="ManageSupplierAccounts.aspx"><span id=${CurrencyID}>(${CurrencyName}) </span>#=(Credit).toFixed(2)#</a>' },
                    { field: "CommunityName", width: 600, title: "<a class='custom-gridheader-anchor' href='ManageSupplierCommunities.aspx'>My Communities</a>", template: '<a class="custom-anchor" href="SupplierCommunityDetail.aspx?cid=#=Encrypted(CommunityID)#">${CommunityName}</a>' },
                    { field: "IsActive", width: 100, title: "Active" }
                ],
                detailInit: CommunityGroupInit,
                dataBound: function () {
                    this.expandRow(this.tbody.find("tr.k-master-row").first());
                },
            }).data("kendoGrid");
        }

        function CommunityGroupInit(e) {
            $kendoJS("<div/>").appendTo(e.detailCell).kendoGrid({
                dataSource: {
                    data: e.data.lstSupplierCommunityGroupResponse,
                    filter: { field: "CommunityID", operator: "eq", value: e.data.CommunityID }
                },
                scrollable: false,
                pageable: false,
                columns: [
                    { field: "CommunityGroupName", width: 200, title: "Community Group", template: '<a class="custom-anchor" href="SupplierCommunityGroupDetail.aspx?gid=#=Encrypted(CommunityGroupID)#">${CommunityGroupName}</a>' },
                    { field: "AverageRating", width: 150, title: "Avg Rating", template: '<a class="custom-anchor" href="SupplierReviews.aspx?cid=#=Encrypted(CommunityID)#&gid=#=Encrypted(CommunityGroupID)#&sid=' + Encrypted($("#hdnSupplierId").val()) + '">#= (AverageRating).toFixed(1) # Star(s) from ${ReviewCount} Review(s)</a>' },
                    { field: "ResponsePendingCount", width: 150, title: "Responses", template: '${ResponsePendingCount} Response Pending' },
                    { field: "PastMonthActivity", width: 200, title: "Past Month Activity", template: '<a class="custom-anchor" href="SupplierActivityTracker.aspx?gid=#=Encrypted(CommunityGroupID)#">${PastMonthActivity}</a>' },
                    { field: "ActionRequired", width: 100, title: "Action Required" },
                    { field: "IsActive", width: 90, title: "Active" }
                ]
            });
        }

        //Displays a confirmation window while deleteing a social media.
        function DeleteConfirmation(data) {
            var socialReferenceId = data.id.substr(12);
            BootstrapDialog.show({
                title: 'Social Media',
                message: 'Are you sure you want to delete this record?',
                buttons: [{
                    label: 'Yes',
                    cssClass: 'btn-info',
                    action: function (dialog) {
                        RemoveSupplierSocial(socialReferenceId);
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

        //Enables social media fields to edit.
        function EditSocialMedia(data) {
            var socialReferenceId = data.id.substr(10);

            $('#hl' + socialReferenceId).addClass('custom-hide');
            $('#txt' + socialReferenceId).removeClass('custom-hide');
            $('#txt' + socialReferenceId).val($('#hl' + socialReferenceId).text());

            $('#btnEditRow' + socialReferenceId).addClass('custom-hide');
            $('#btnDeleteRow' + socialReferenceId).addClass('custom-hide');
            $('#btnUpdateRow' + socialReferenceId).removeClass('custom-hide');
            $('#btnCancelRow' + socialReferenceId).removeClass('custom-hide');
        }

        //Cancels the edit mode.
        function CancelSocialMediaEdit(data) {
            var socialReferenceId = data.id.substr(12);

            $('#txt' + socialReferenceId).val('');
            $('#hl' + socialReferenceId).removeClass('custom-hide');
            $('#txt' + socialReferenceId).addClass('custom-hide');

            $('#btnEditRow' + socialReferenceId).removeClass('custom-hide');
            $('#btnDeleteRow' + socialReferenceId).removeClass('custom-hide');
            $('#btnUpdateRow' + socialReferenceId).addClass('custom-hide');
            $('#btnCancelRow' + socialReferenceId).addClass('custom-hide');

            $('#txt' + socialReferenceId).closest('.form-group').removeClass('form-group has-error').addClass('form-group');
            $("#spanSocialReference" + socialReferenceId).removeClass("custom-supplierdashboard-email-validation-on").addClass("custom-supplierdashboard-email-validation-off");
        }

        //Service call to update the edited social media details.
        function UpdateSocialMedia(data) {
            var socialReferenceId = data.id.substr(12);
            var socialMediaId = $('#hdnSocialMediaId' + socialReferenceId).val();
            var socialMediaReference = $.trim($('#txt' + socialReferenceId).val());

            if (socialMediaReference == '') {
                $('#txt' + socialReferenceId).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#spanSocialReference" + socialReferenceId).removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on");
            }
            else {
                $('#txt' + socialReferenceId).closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                $("#spanSocialReference" + socialReferenceId).removeClass("custom-supplierdashboard-email-validation-on").addClass("custom-supplierdashboard-email-validation-off");
                var postData = '{"SupplierSocialReferenceID":"' + socialReferenceId + '", "SupplierID":"' + $("#hdnSupplierId").val() + '", "SocialMediaID":"' + socialMediaId + '", "SocialMediaReference":"' + socialMediaReference + '"}';
                PostRequest("UpdateSupplierSocial", postData, UpdateSupplierSocialSuccess, Failure, ErrorHandler);
            }
        }

        //On ajax call success, binds the social media listview.
        function UpdateSupplierSocialSuccess(response) {
            GetSupplierSocialReference($("#hdnSupplierId").val());
            SuccessWindow('Social Media', 'Updated successfully.', '#');
        }

        function CalculateDepositPercentageOwner() {
            if ($('#txtDepositPercent').val() > 100) {
                BootstrapDialog.show({
                    title: "Registration",
                    message: "Deposit percentage cannot be greater than 100",
                    buttons: [{
                        label: 'Ok',
                        action: function (dialogItself) {
                            dialogItself.close();
                            $('#txtDepositPercent').val('');
                        }
                    }],
                    type: BootstrapDialog.TYPE_WARNING
                });
            }
        }

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


        function ClearLogoValidation() {
            // Get plugin instance
            var bootstrapValidator = $JS10('#frmRatingReviewEngine').data('bootstrapValidator');
            bootstrapValidator.updateStatus('fileupload1', 'NOT_VALIDATED');
            setTimeout(function () { timerClearLogoValidation(); }, 500);
            $('#divLogoFormGroup').find('small.help-block').hide();
        }

        function AddValidation() {
            // Get plugin instance
            var bootstrapValidator = $JS10('#frmRatingReviewEngine').data('bootstrapValidator');
            // and then call method
            bootstrapValidator.addField($('#fileupload1'));

        }

        //function ClearLogoValidation() {
        //    //// Get plugin instance
        //    //var bootstrapValidator = $JS10('#frmRatingReviewEngine').data('bootstrapValidator');


        //    ////// and then call method
        //    ////bootstrapValidator.removeField($('#fileupload1'));

        //    //bootstrapValidator.addField($('#fileupload1'));
        //    //// and then call method
        //    //bootstrapValidator.updateStatus('fileupload1', 'VALID');

        //    //$('#divLogoFormGroup').find('small.help-block').hide();
        //}


        function ClearIconValidation() {
            //$('#divIcon').fileinput().fileinput('reset');

            var bootstrapValidator = $JS10('#frmRatingReviewEngine').data('bootstrapValidator');
            bootstrapValidator.updateStatus('fileupload2', 'NOT_VALIDATED');
            setTimeout(function () { timerClearLogoValidation(); }, 500);
            $('#divIconFormGroup').find('small.help-block').hide();
        }

        function timerClearLogoValidation() {
            // Get plugin instance
            var bootstrapValidator = $JS10('#frmRatingReviewEngine').data('bootstrapValidator');
            // and then call method
            bootstrapValidator.addField($('#fileupload1'));
            bootstrapValidator.revalidateField('fileupload1');
        }

        function timerClearIconValidation() {
            // Get plugin instance
            var bootstrapValidator = $JS10('#frmRatingReviewEngine').data('bootstrapValidator');
            // and then call method
            bootstrapValidator.addField($('#fileupload2'));
            bootstrapValidator.revalidateField('fileupload2');
        }
    </script>
</asp:Content>

<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Supplier Dashboard</h2>
    <div class="row">
        <hr />
        <div id="divLabel" class="col-md-12">
            <input type="hidden" id="hdfCountryID" />
            <input type="hidden" id="hdfBillingCountryID" />
            <input type="hidden" id="hdfWebsite" />
            <input type="hidden" id="hdfDateAdded" />
            <input type="hidden" id="hdfLatitude" />
            <input type="hidden" id="hdfLongitude" />
            <input type="hidden" id="hdnLogo" />
            <input type="hidden" id="hdnIcon" />
            <div class="col-md-2 custom-supplierdashboard-logo_icon-div">
                <div id="logoLoading" style="left: 70px; top: 77px; position: absolute;">
                    <img src="kendo_styles/BlueOpal/loading_2x.gif" />
                </div>
                <div class="fileinput fileinput-new" data-provides="fileinput">
                    <div class="fileinput-preview thumbnail custom-supplierdashboard-logo_icon-size" data-trigger="fileinput">
                        <img id="imgLogo" alt="Supplier Logo" />
                    </div>
                </div>
                <div id="iconLoading" style="left: 70px; top: 102px; position: inherit;">
                    <img src="kendo_styles/BlueOpal/loading_2x.gif" />
                </div>
                <div class="fileinput fileinput-new" data-provides="fileinput">
                    <div class="fileinput-preview thumbnail custom-supplierdashboard-logo_icon-size" data-trigger="fileinput">
                        <img id="imgIcon" alt="Supplier Icon" />
                    </div>
                </div>
                <div>
                    <fieldset class="gllpLatlonPicker1">
                        <div class="gllpMap1" style="height: 170px !important; width: 170px !important;">Google Maps</div>
                    </fieldset>
                </div>
            </div>
            <div class="col-md-3">
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Name</label>
                    </div>
                    <div>
                        <label id="lblName" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Email</label>
                    </div>
                    <div>
                        <label id="lblEmail" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Primary Phone</label>
                    </div>
                    <div>
                        <label id="lblPrimaryPhone" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Other Phone</label>
                    </div>
                    <div>
                        <label id="lblOtherPhone" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Business Number</label>
                    </div>
                    <div>
                        <label id="lblBusinessNumber" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Website</label>
                    </div>
                    <div style="word-break: break-all">
                        <a id="lblWebsite" class="custom-supplierdashboard-label-fontstyle custom-anchor" href="#" target="_blank"></a>
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Deposit Percentage</label>
                    </div>
                    <div>
                        <label id="lblDepositPercent" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Address 1</label>
                    </div>
                    <div>
                        <label id="lblAddress1" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Address 2</label>
                    </div>
                    <div>
                        <label id="lblAddress2" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">City</label>
                    </div>
                    <div>
                        <label id="lblCity" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">State </label>
                    </div>
                    <div>
                        <label id="lblState" class="custom-supplierdashboard-label-fontstyle"></label>

                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Postal Code</label>
                    </div>
                    <div>
                        <label id="lblPostalCode" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Country</label>
                    </div>
                    <div>
                        <label id="lblCountry" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
            </div>
            <div class="col-md-3">

                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Billing Address 1</label>
                    </div>
                    <div>
                        <label id="lblBillingAddress1" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Billing Address 2</label>
                    </div>
                    <div>
                        <label id="lblBillingAddress2" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Billing City</label>
                    </div>
                    <div>
                        <label id="lblBillingCity" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Billing State </label>
                    </div>
                    <div>
                        <label id="lblBillingState" class="custom-supplierdashboard-label-fontstyle"></label>

                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Billing Postal Code</label>
                    </div>
                    <div>
                        <label id="lblBillingPostalCode" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Billing Country</label>
                    </div>
                    <div>
                        <label id="lblBillingCountry" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Billing Name</label>
                    </div>
                    <div>
                        <label id="lblBillingName" class="custom-supplierdashboard-label-fontstyle"></label>
                    </div>
                </div>
            </div>
            <div class="col-md-2"></div>
            <div class="col-md-10 custom-supplierdashboard-quote-div">
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Quote Terms</label>
                    </div>
                    <div>
                        <label class="custom-supplierdashboard-label-fontstyle" id="lblQuoteTerms"></label>
                        <input type="hidden" id="hdfQuoteTerms" />
                    </div>
                </div>
                <div class="custom-supplierdashboard-innerdiv">
                    <div>
                        <label class="custom-supplierdashboard-label-lineheight">Deposit Terms</label>
                    </div>
                    <div>
                        <label class="custom-supplierdashboard-label-fontstyle" id="lblDepositTerms"></label>
                        <input type="hidden" id="hdfDepositTerms" />
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-2 pull-right">
                    <input id="btnEdit" type="button" value="Edit" name="btnEdit" class="btn btn-block btn-lg btn-primary custom-supplierdashboard-button-rightalign" onclick="ShowEdit()" />
                </div>
            </div>
        </div>
        <div id="divEdit" class="col-md-12" style="display: none;">
            <div class="col-md-12">
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Name</label>
                        </div>
                        <input type="text" id="txtName" class="form-control custom-supplierdashboard-textbox-width" name="txtName" placeholder="Name" onblur="CheckSupplierCompanyName()" maxlength="50" />
                        <span id="spanSupplierName" class="custom-register-email-span"></span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Address 1</label>
                        </div>
                        <input type="text" id="txtAddress1" class="form-control custom-supplierdashboard-textbox-width address1" name="txtAddress1" placeholder="Addr 1" maxlength="150" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Billing Address 1</label>
                        </div>
                        <input type="text" id="txtBillingAddress1" class="form-control custom-supplierdashboard-textbox-width" name="txtBillingAddress1" placeholder="Billing Addr 1" maxlength="150" />
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Email</label>
                        </div>
                        <input type="text" id="txtEmail" class="form-control custom-supplierdashboard-textbox-width" name="txtEmail" placeholder="Email" onblur="CheckSupplierEmail()" maxlength="200" />
                        <span id="spanEmail" class="custom-register-email-span"></span>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Address 2</label>
                        </div>
                        <input type="text" id="txtAddress2" class="form-control custom-supplierdashboard-textbox-width address2" name="txtAddress2" placeholder="Addr 2" maxlength="150" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Billing Address 2</label>
                        </div>
                        <input type="text" id="txtBillingAddress2" class="form-control custom-supplierdashboard-textbox-width" name="txtBillingAddress2" placeholder="Billing Addr 2" maxlength="150" />
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Primary Phone</label>
                        </div>
                        <input type="text" id="txtPrimaryPhone" class="form-control custom-supplierdashboard-textbox-width" name="txtPrimaryPhone" placeholder="Primary Phone" maxlength="50" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">City</label>
                        </div>
                        <input type="text" id="txtCity" class="form-control custom-supplierdashboard-textbox-width administrative_area_level_2" name="txtCity" placeholder="City" maxlength="50" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Billing City</label>
                        </div>
                        <input type="text" id="txtBillingCity" class="form-control custom-supplierdashboard-textbox-width" name="txtBillingCity" placeholder="Billing City" maxlength="50" />
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Other Phone</label>
                        </div>
                        <input type="text" id="txtOtherPhone" class="form-control custom-supplierdashboard-textbox-width" name="txtOtherPhone" placeholder="Other Phone" maxlength="50" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">State</label>
                        </div>
                        <input type="text" id="txtState" class="form-control custom-supplierdashboard-textbox-width administrative_area_level_1" name="txtState" placeholder="State" maxlength="50" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Billing State</label>
                        </div>
                        <input type="text" id="txtBillingState" class="form-control custom-supplierdashboard-textbox-width" name="txtBillingState" placeholder="Billing State" maxlength="50" />
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Business Number</label>
                        </div>
                        <input type="text" id="txtBusinessNumber" class="form-control custom-supplierdashboard-textbox-width" name="txtBusinessNumber" placeholder="Business Number" maxlength="50" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Postal Code</label>
                        </div>
                        <input type="text" id="txtPostalCode" class="form-control custom-supplierdashboard-textbox-width postal_code" name="txtPostalCode" placeholder="Postal Code" maxlength="50" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Billing Postal Code</label>
                        </div>
                        <input type="text" id="txtBillingPostalCode" class="form-control custom-supplierdashboard-textbox-width" name="txtBillingPostalCode" placeholder="Billing Postal Code" maxlength="50" />
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Website</label>
                        </div>
                        <input type="text" id="txtWebsite" class="form-control custom-supplierdashboard-textbox-width" name="txtWebsite" placeholder="Website" maxlength="200" />
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
            <div class="col-md-12">
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Deposit Percentage</label>
                        </div>
                        <input type="text" id="txtDepositPercent" class="form-control custom-supplierdashboard-textbox-width" name="txtDepositPercent" placeholder="Deposit Percent" maxlength="6" onchange="CalculateDepositPercentageOwner()" />
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <label for="chkUseSameAddress" class="checkbox custom-comownerdash-checkbox-textalign">
                            <span class="icons"><span class="first-icon fui-checkbox-unchecked"></span><span class="second-icon fui-checkbox-checked"></span></span>
                            <input type="checkbox" value="" id="chkUseSameAddress" data-toggle="checkbox" onchange="ToggleAddress()" />
                            Use same address for billing
                        </label>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="form-group">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Billing Name</label>
                        </div>
                        <input type="text" id="txtBillingName" class="form-control custom-supplierdashboard-textbox-width" name="txtBillingName" placeholder="Billing Name" maxlength="150" />
                    </div>
                </div>

            </div>
            <div class="col-md-12">
                <div class="col-md-12">
                    <div class="custom-supplierdashboard-innerdiv">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Quote Terms</label>
                        </div>
                        <div>
                            <textarea id="txtQuoteTerms" class="form-control" maxlength="250"></textarea>
                        </div>
                    </div>
                    <div class="custom-supplierdashboard-innerdiv">
                        <div>
                            <label class="custom-supplierdashboard-label-fontstyle">Deposit Terms</label>
                        </div>
                        <div class="form-group">
                            <textarea id="txtDepositTerms" class="form-control" maxlength="250"></textarea>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-5">
                    <div class="row">
                        <h4 class="custom-regsupplier-subtitle">Logo</h4>
                        <hr />
                        <div class="col-md-11">
                            <div class="form-group1" id="divLogoFormGroup">
                                <div class="fileinput fileinput-new" data-provides="fileinput" id="divLogo">
                                    <div class="custom-supplierdashboard-remove-btn">
                                        <a href="#" class="fileinput-exists fui-cross" data-dismiss="fileinput" onclick="ClearLogoValidation()"></a>
                                    </div>
                                    <div class="fileinput-preview thumbnail custom-supplierdashboard-image" id="divImageLogo"></div>
                                    <div>
                                        <span class="btn btn-default btn-primary btn-file" style="padding: 10px 0px 10px 0px; cursor: pointer;">
                                            <span class="fileinput-new" data-trigger="fileinput" style="padding: 10px 10px 10px 10px; cursor: pointer;">Add Logo</span>
                                            <span class="fileinput-exists" data-trigger="fileinput" style="padding: 10px 10px 10px 10px; cursor: pointer;">Change Logo</span>
                                            <input id="fileupload1" type="file" name="fileupload1" />
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <h4 class="custom-regsupplier-subtitle">Icon</h4>
                        <hr />
                        <div class="col-md-11">
                            <div class="form-group1" id="divIconFormGroup">
                                <div class="fileinput fileinput-new" data-provides="fileinput" id="divIcon">
                                    <div class="custom-supplierdashboard-remove-btn">
                                        <a href="#" class="fileinput-exists fui-cross" data-dismiss="fileinput" onclick="ClearIconValidation()"></a>
                                    </div>
                                    <div class="fileinput-preview thumbnail custom-supplierdashboard-image" id="divImageIcon"></div>
                                    <div>
                                        <span class="btn btn-default btn-primary btn-file" style="padding: 10px 0px 10px 0px; cursor: pointer;">
                                            <span class="fileinput-new" data-trigger="fileinput" style="padding: 10px 10px 10px 10px; cursor: pointer;">Add Icon</span>
                                            <span class="fileinput-exists" data-trigger="fileinput" style="padding: 10px 10px 10px 10px; cursor: pointer;">Change Icon</span>
                                            <input id="fileupload2" type="file" name="fileupload2" />
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-7">
                    <h4 class="custom-regsupplier-subtitle">Location Map</h4>
                    <hr />
                    <fieldset class="gllpLatlonPicker">
                        <div class="form-group">
                            <input type="text" class="gllpSearchField form-control custom-supplierdashboard-search-textbox" placeholder="Search" />
                            <input type="button" class="gllpSearchButton btn btn-primary custom-supplierdashboard-search-button" value="Search by Location" />
                        </div>
                        <br />
                        <br />
                        <div class="gllpMap">Google Maps</div>
                        <br />
                        <div id="divMapLatLon" style="margin-left: -13px;">
                            <div class="form-group">
                                <input type="text" class="gllpLatitude form-control custom-supplierdashboard-latlon-textbox" placeholder="Latitude" id="txtLatitude" name="txtLatitude" onblur="LatitudeLongitudeValidation()" value="0" />
                            </div>
                            <label class="custom-comownerdash-slash-align">/</label>
                            <div class="form-group">
                                <input type="text" class="gllpLongitude form-control custom-supplierdashboard-latlon-textbox" placeholder="Longitude" id="txtLongitude" name="txtLongitude" onblur="LatitudeLongitudeValidation()" value="0" />
                            </div>
                        </div>
                        <div class="col-md-5">
                            <span id="latitudeVadiation" class="custom-supplierdashboard-email-validation-off"></span>
                        </div>
                        <div class="col-md-6">
                            <span id="longitudeVadiation" class="custom-supplierdashboard-email-validation-off"></span>
                        </div>
                        <div class="custom-supplierdashboard-updatemap-button custom-default-bottom-margin">
                            <input type="button" class="gllpUpdateButton btn btn-primary" value="Search by Co-ordinate" />
                        </div>
                        <div style="display: none;">
                            zoom:
                            <input type="text" class="gllpZoom" value="3" />
                            <input type="button" class="gllpEditButton btn btn-primary" value="Dummy" />
                            <input type="text" class="gllpLocationName form-control custom-regsupplier-location-textbox" placeholder="Longitude" />

                        </div>
                    </fieldset>
                </div>
            </div>
            <div class="col-md-12">
                <div class="col-md-2 pull-right">
                    <input type="button" id="btnSave" value="Save" class="btn btn-block btn-lg btn-info custom-supplierdash-savecancelbutton-rightalign" onclick="UpdateSupplier()" />
                    <input type="button" id="btnCancel" value="Cancel" class="btn btn-block btn-lg btn-default custom-supplierdash-savecancelbutton-rightalign" onclick="HideEdit()" />
                </div>
            </div>
        </div>

        <div class="col-md-12">
            <hr />
        </div>
        <div class="col-md-12 custom-supplierdashboard-socialmedia-margin">
            <table role="grid" style="width: 100%;">
                <colgroup>
                    <col>
                    <col>
                    <col>
                </colgroup>
                <thead class="k-grid-header">
                    <tr>
                        <th data-title="Social Media" data-field="SocialMediaName" role="columnheader" class="k-header" style="width: 30%;">Social Media</th>
                        <th data-title="Social Reference" data-field="SocialMediaReference" role="columnheader" class="k-header" style="width: 50%;">Social Reference</th>
                        <th class="k-header" style="width: 20%;"></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="3">
                            <div id="lsvSocialReference" class="k-grid k-widget k-secondary"></div>
                        </td>
                    </tr>
                </tbody>
            </table>
            <script id="socialReferenceTemplate" type="text/x-kendo-tmpl">
                    <table>
                        <tr role="row">
                            <td role="gridcell" style="width: 30%;">                                    
                                <label>${SocialMediaName}</label>
                                <input type="hidden" id="hdnSocialMediaId${SupplierSocialReferenceID}" value="${SocialMediaID}" />
                            </td>
                            <td role="gridcell" style="width: 50%;" class="form-group">                                    
                                <a href="${SocialMediaReference}" class="custom-anchor" target="_blank" id="hl${SupplierSocialReferenceID}">${SocialMediaReference}</a>
                                <input type="text" id="txt${SupplierSocialReferenceID}" class="form-control custom-hide" style="height: 18px; width: 400px;" maxlength="200" />
                                <span id="spanSocialReference${SupplierSocialReferenceID}" class="custom-supplierdashboard-email-validation-off">You can't leave this empty.</span>
                            </td>
                            <td role="gridcell" style="width: 20%;">
                                <input type="button" value="Edit" id="btnEditRow${SupplierSocialReferenceID}" name="btnEditRow${SupplierSocialReferenceID}" class="btn btn-primary custom-supplierdashboard-button" onclick="EditSocialMedia(this)" />
                                <input type="button" value="Delete" id="btnDeleteRow${SupplierSocialReferenceID}" name="btnDeleteRow${SupplierSocialReferenceID}" class="btn btn-danger custom-supplierdashboard-button" onclick="DeleteConfirmation(this)" />
                                <input type="button" value="Update" id="btnUpdateRow${SupplierSocialReferenceID}" name="btnUpdateRow${SupplierSocialReferenceID}" class="btn btn-primary custom-hide custom-supplierdashboard-button" onclick="UpdateSocialMedia(this)" />
                                <input type="button" value="Cancel" id="btnCancelRow${SupplierSocialReferenceID}" name="btnCancelRow${SupplierSocialReferenceID}" class="btn btn-default custom-hide custom-supplierdashboard-button" onclick="CancelSocialMediaEdit(this)" />
                            </td>
                        </tr>
                    </table>
            </script>
        </div>
        <div id="divSocialMedia" class="col-md-12" style="margin-left: -1.3%;">
            <div class="custom-supplierdashboard-col-md-4">
                <div>
                    <div id="ddlSocialMedia" onchange="SocialMediaValidation()" class="custom-dropdown-width"></div>
                    <span id="spanSocialMediaValidation" class="custom-supplierdashboard-email-validation-off">You can't leave this empty.</span>
                </div>
            </div>
            <div class="col-md-4">
                <div class="form-group">
                    <input id="txtSocialReference" name="txtSocialReference" placeholder="Social Reference" class="form-control" onblur="SocialReferenceValidation()" maxlength="200" />
                    <span id="spanSocialReferenceValidation" class="custom-supplierdashboard-email-validation-off">You can't leave this empty.</span>
                </div>
            </div>
            <div class="col-md-2"></div>
            <div class="col-md-2 pull-right">
                <input type="button" id="btnSocialSave" value="Social Save" class="btn btn-block btn-lg btn-info custom-supplierdashboard-button-rightalign" onclick="AddSupplierSocial()" />
            </div>
        </div>
        <div class="col-md-12">
            <hr />
            <div id="gvCommunityDetail"></div>
        </div>
        <%--<div class="col-md-12">
     <br />
                    <input type="button" id="btnAddValidation" class="btn-primary" name="btnGetFileName" value="AddField" onclick="AddValidation();" />
        </div>--%>
    </div>



    <script src="bootstrap/js/bootstrapValidator.js"></script>
    <script>
        var $JS10 = jQuery.noConflict();
    </script>
    <script type="text/javascript">
        var isBrokenLogo;
        var isBrokenIcon;


        function getFileName(controlName) {
            return document.getElementById(controlName).value;
        }

        function isValidInput() {

            BrokenLogo();
            BrokenIcon();


            // Get plugin instance
            var bootstrapValidator = $JS10('#frmRatingReviewEngine').data('bootstrapValidator');
            // and then call method
            bootstrapValidator.addField($('#fileupload1'));
            bootstrapValidator.revalidateField('fileupload1');

            bootstrapValidator.addField($('#fileupload2'));
            bootstrapValidator.revalidateField('fileupload2');

            // and then call method
            var isValidLogo = bootstrapValidator.isValidField('fileupload1');
            var isValidIcon = bootstrapValidator.isValidField('fileupload2');


            if (isBrokenIcon || isBrokenLogo) {
                BootstrapDialog.show({
                    title: "Dashboard",
                    message: "The file you have uploaded is invalid.",
                    buttons: [{
                        label: 'Ok',
                        action: function (dialog) {
                            dialog.close();
                        }
                    }],
                    type: BootstrapDialog.TYPE_WARNING
                });
                return false;
            }



            var isValidLogoExt = validateFileExtension(document.getElementById('fileupload1').value);
            var isValidIconExt = validateFileExtension(document.getElementById('fileupload2').value);
            if (!isValidLogoExt || !isValidIconExt) {
                BootstrapDialog.show({
                    title: "Dashboard",
                    message: "The file you have uploaded is invalid. The file formats such as JPG, JPEG and PNG are allowed.",
                    buttons: [{
                        label: 'Ok',
                        action: function (dialog) {
                            dialog.close();
                        }
                    }],
                    type: BootstrapDialog.TYPE_WARNING
                });
                return false;
            }

            if ($("#frmRatingReviewEngine").valid() && (getFileName('fileupload1') == '' || isValidLogo) && (getFileName('fileupload2') == '' || isValidIcon)) {
                // if ($("#frmRatingReviewEngine").valid() && bootstrapValidator.isValid()) {
                return true;
            } else {
                return false;
            }
        }

        function BrokenLogo() {
            var logoImage = $("#divImageLogo").find('img')[0];
            if (logoImage != undefined) {

                var imgLogoSrc = logoImage.src;
                var imgLogo = new Image();

                imgLogo.onerror = function (evt) {
                    isBrokenLogo = true;
                };
                imgLogo.onload = function (evt) {
                    isBrokenLogo = false;
                };
                imgLogo.src = imgLogoSrc;
            }
            else {
                isBrokenLogo = false;
            }
        }

        function BrokenIcon() {
            var iconImage = $("#divImageIcon").find('img')[0];
            if (iconImage != undefined) {
                var imgIconSrc = iconImage.src;
                var imgIcon = new Image();

                imgIcon.onerror = function (evt) {
                    isBrokenIcon = true;
                };
                imgIcon.onload = function (evt) {
                    isBrokenIcon = false;
                };
                imgIcon.src = imgIconSrc;
            }
            else {
                isBrokenIcon = false;
            }
        }

        /*jslint unparam: true */
        /*global window, $ */
        //$(function () {
        //    'use strict';
        //});




        $(document).ready(function () {
            $('#fileupload1').on('change.bs.fileinput', function () {
                if (getFileName('fileupload1') != "") {
                    setTimeout(function () { BrokenLogo(); }, 500);
                }

            });
            $('#fileupload2').on('change.bs.fileinput', function () {
                if (getFileName('fileupload2') != "") {

                    setTimeout(function () { BrokenIcon(); }, 500);
                }
            });

            $('#fileupload1').on('clear.bs.fileinput', function () {
                setTimeout(function () { timerClearLogoValidation(); }, 500);
            });

            $('#fileupload2').on('clear.bs.fileinput', function () {
                setTimeout(function () { timerClearIconValidation(); }, 500);
            });



            $JS10('#frmRatingReviewEngine').bootstrapValidator({
                excluded: ':disabled',
                group: '.form-group1',
                message: 'This value is not valid',
                /* feedbackIcons: {
                        valid: 'glyphicon glyphicon-ok',
                        invalid: 'glyphicon glyphicon-remove',
                        validating: 'glyphicon glyphicon-refresh'
                   },*/
                fields: {
                    //Logo 
                    fileupload1: {
                        selector: '#fileupload1',    // ID selector
                        validators: {
                            feedbackIcons: {
                                valid: 'glyphicon glyphicon-ok',
                                invalid: 'glyphicon glyphicon-remove',
                                validating: 'glyphicon glyphicon-refresh'
                            },
                            file: {
                                extension: 'jpeg,png,jpg',
                                type: 'image/jpeg,image/png',
                                maxSize: 3145728, // 3 MB
                                message: 'The selected file is not valid. Maximum image size allowed is 3MB and the file formats such as JPG, JPEG and PNG are allowed.'
                            }
                        }
                    },
                    // Icon
                    fileupload2: {
                        selector: '#fileupload2',    // ID selector
                        validators: {
                            feedbackIcons: {
                                valid: 'glyphicon glyphicon-ok',
                                invalid: 'glyphicon glyphicon-remove',
                                validating: 'glyphicon glyphicon-refresh'
                            },
                            file: {
                                extension: 'jpeg,png,jpg',
                                type: 'image/jpeg,image/png',
                                maxSize: 1048576, // 1 MB
                                message: 'The selected file is not valid. Maximum image size allowed is 1MB and the file formats such as JPG, JPEG and PNG are allowed.'
                            }
                        }
                    }
                }
            });
        });
    </script>

    <script type="text/javascript">
        function CheckFileValid() {
            // Get plugin instance
            var bootstrapValidator = $JS10('#frmRatingReviewEngine').data('bootstrapValidator');
            // and then call method
            bootstrapValidator.updateStatus('fileupload1', 'NOT_VALIDATED');
            bootstrapValidator.updateStatus('fileupload2', 'NOT_VALIDATED');

            bootstrapValidator.revalidateField('fileupload1');
            bootstrapValidator.revalidateField('fileupload2');

        }

        //function to validate file extension
        function validateFileExtension(fld) {

            if (fld != "" && !/(\.jpeg|\.png|\.jpg)$/i.test(fld)) {
                return false;
            }
            return true;
        }

    </script>
</asp:Content>
