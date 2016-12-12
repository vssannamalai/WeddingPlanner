<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="RegisterAsSupplier.aspx.cs" Inherits="RatingReviewEngine.Web.RegisterAsSupplier" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <style>
        #map-canvas {
            height: 497px;
            width: 100%;
        }

        .thumbnail > img, .thumbnail a > img {
            height: 100% !important;
        }

        .k-reset {
            font-size: 88% !important;
        }

        img {
            line-height: 50px;
            text-align: center;
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

    <script type="text/javascript" src="//maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&libraries=drawing"></script>

    <link rel="stylesheet" type="text/css" href="css/jquery-gmaps-latlon-picker.css" />
    <script src="js/jquery-gmaps-latlon-picker.js"></script>
     

    <script src="bootstrap/js/bootstrapValidator.js"></script>
    <script>
        var $JS10 = jQuery.noConflict();
    </script>
    <script type="text/javascript">
        var uploadIconError = false, uploadLogoError = false;
        var isBrokenLogo;
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

        //function to validate file extension
        function validateFileExtension(fld) {

            if (fld != "" && !/(\.jpeg|\.png|\.jpg)$/i.test(fld)) {
                return false;
            }
            return true;
        }
    </script>
    <script>
        function UploadSupplierLogo() {
            $("#progress").show();
            var urlUploadLogo = $("#hdnFileUploadUrl").val() + 'SaveSupplierLogo';
            $('#fileupload1').fileupload({
                dataType: 'text',
                // autoUpload: false,
                url: urlUploadLogo,
                always: function (e, data) {
                    if (data.result == "Error" ||
                           data.result.indexOf('Error') != -1) {
                        uploadLogoError = true;
                    }
                    UploadSupplierIcon();
                }
            });
            if ($('#fileupload1').val() == '') {
                UploadSupplierIcon();
            } else {
                $('#fileupload1').fileupload('add', {
                    fileInput: $('#fileupload1'),
                    formData: { supplierid: $("#hdnSupplierId").val() }
                });
            }
        }

        function UploadSupplierIcon() {
            var urlUploadLogo = $("#hdnFileUploadUrl").val() + 'SaveSupplierIcon';
            $('#fileupload2').fileupload({
                dataType: 'text',
                // autoUpload: false,
                url: urlUploadLogo,
                always: function (e, data) {
                    if (data.result == "Error" ||
                           data.result.indexOf('Error') != -1) {
                        uploadIconError = true;
                    }
                    $("#progress").hide();
                    ShowUpdateSuccess();
                }
            });
            if ($('#fileupload2').val() == '') {
                $("#progress").hide();
                ShowUpdateSuccess();
            } else {
                $('#fileupload2').fileupload('add', {
                    fileInput: $('#fileupload2'),
                    formData: { supplierid: $("#hdnSupplierId").val() }
                });
            }
        }

        function ShowUpdateSuccess() {
            var strErrorMessage = "";

            if (uploadLogoError == false && uploadIconError == false) {
                SuccessWindow('Supplier Dashboard', 'Supplier has been registered successfully.', 'SupplierDashboard.aspx');
            } else {
                if (uploadLogoError == true && uploadIconError == true) {
                    strErrorMessage = "<br><span style='color:#ff0000;'>The Logo and Icon were not updated since the uploaded image files appear to be damaged or corrupted.</span>";
                }
                else if (uploadLogoError == true) {
                    strErrorMessage = "<br><span style='color:#ff0000;'>The Logo is not updated since the uploaded image file appears to be damaged or corrupted.</span>";
                } else {
                    strErrorMessage = "<br><span style='color:#ff0000;'>The Icon is not updated since the uploaded image file appears to be damaged or corrupted.</span>";
                }
                FailureWindow('Supplier Dashboard', 'Supplier has been registered successfully.' + strErrorMessage, 'SupplierDashboard.aspx');
            }
        }
    </script>

    <script type="text/javascript">
        var emailExist = false;
        var companynameExist = false;
        
        $(document).ready(function () {
            SetDefaultValues();
            ControlValidation();
            BindCurrency();
            BindCountry();
            KeyDownEventOnLoad();
        });

        //Set static values for email, quote and deposit terms.
        function SetDefaultValues() {
            //Login email id will be shown by default in email field.
            $("#txtEmail").val($("#hdnUserName").val());
            $("#txtQuoteTerms").val('This quote is valid for 30 days from the date of issue.');
            $("#txtDepositTerms").val('Payment of the requested deposit amount confirms the Customer\'s intention to pay in full for the product/service as defined within the quote.');
            CheckSupplierEmail();
        }

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    txtSupplierName: { required: true },
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
                    txtSupplierName: { required: 'You can\'t leave this empty.' },
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
                change: function onChange() { LocationSearch(this) },
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

        //Registers a keydown event on page load.
        function KeyDownEventOnLoad() {
            $('input[name="txtDepositPercent"]').keydown(function (e) {
                AllowDecimal(e);
            });
        }

        //Based on the address entered, location will be set in map.
        function LocationSearch(id) {
            return;
            var address;
            address = $.trim($("#txtAddress1").val()) + ' ' + $.trim($("#txtCity").val()) + ' ' + $.trim($("#txtState").val()) + ' ' + $.trim($("#txtPostalCode").val()) + ' ' + ($kendoJS("#ddlCountry").data("kendoDropDownList").text() == "Country" ? ' ' : $kendoJS("#ddlCountry").data("kendoDropDownList").text());
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

            if (!isNullOrEmpty($.trim(address))) {
                $('.gllpSearchField').val(address);
                $('.gllpSearchButton').click();
            }
        }

        //Checks whether the email id is already exist.
        function CheckSupplierEmail() {
            if ($.trim($("#txtEmail").val()) != '') {
                //SupplierId is set as zero by default.
                var param = "/0/" + encodeURIComponent($.trim($("#txtEmail").val()));
                GetResponse("CheckSupplierEmail", param, CheckSupplierEmailSuccess, Failure, ErrorHandler);
            }
            else {
                $("#spanEmail").text('').css('display', 'none');
            }
        }

        //On ajax call success, checks response for existance.
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

        //Checks whether the supplier name already exist.
        function CheckSupplierCompanyName() {
            if ($.trim($("#txtSupplierName").val()) != '') {
                //SupplierId is set as zero by default.
                //var param = "/0/" + encodeURIComponent($.trim($("#txtSupplierName").val()));
                //GetResponse("CheckSupplierCompanyName", param, CheckSupplierCompanyNameSuccess, Failure, ErrorHandler);
                var postData = '{"ID":"0","Name":"' + encodeURIComponent($.trim($("#txtSupplierName").val())) + '"}';
                PostRequest("CheckSupplierCompanyName", postData, CheckSupplierCompanyNameSuccess, Failure, ErrorHandler);
            }
        }

        //On ajax call success, checks response for existance.
        function CheckSupplierCompanyNameSuccess(response) {
            if (response == "1") {
                $("#txtSupplierName").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#spanSupplierName").text('Supplier Name already exist.').css('display', 'block');
                companynameExist = true;
            }
            else {
                $("#spanSupplierName").text('').css('display', 'none');
                companynameExist = false;
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

        //Checks for control validation and calls RegisterSupplier() methed.
        function SubmitSupplier() {
            var isValidLatLon = LatitudeLongitudeValidation();
            if (isValidInput() && companynameExist == false && emailExist == false && !isValidLatLon) {
                $("btnRegister").prop('disabled', true);
                RegisterSupplier();
            }
        }

        //Service call to register a new supplier.
        function RegisterSupplier() {
            var postData = '{"OAuthAccountID":"' + $("#hdnOAuthAccountID").val() + '","CompanyName":"' + encodeURIComponent($.trim($("#txtSupplierName").val()))
                + '","Email":"' + $.trim($("#txtEmail").val()) + '","BusinessNumber":"' + encodeURIComponent($.trim($("#txtBusinessNumber").val()))
                + '","PrimaryPhone":"' + encodeURIComponent($.trim($("#txtPrimaryPhone").val())) + '","OtherPhone":"' + encodeURIComponent($.trim($("#txtOtherPhone").val()))
                + '","Website":"' + encodeURIComponent($.trim($("#txtWebsite").val())) + '","AddressLine1":"' + encodeURIComponent($.trim($("#txtAddress1").val())) + '","AddressLine2":"' + encodeURIComponent($.trim($("#txtAddress2").val()))
                + '","AddressCity":"' + encodeURIComponent($.trim($("#txtCity").val())) + '","AddressState":"' + encodeURIComponent($.trim($("#txtState").val())) + '","AddressPostalCode":"' + encodeURIComponent($.trim($("#txtPostalCode").val()))
                + '","AddressCountryID":"' + (isNullOrEmpty($("#ddlCountry").val().toString()) == true ? -1 : $("#ddlCountry").val()) + '","BillingName":"' + encodeURIComponent($.trim($("#txtBillingName").val()))
                + '","BillingAddressLine1":"' + encodeURIComponent($.trim($("#txtBillingAddress1").val())) + '","BillingAddressLine2":"' + encodeURIComponent($.trim($("#txtBillingAddress2").val()))
                + '","BillingAddressCity":"' + encodeURIComponent($.trim($("#txtBillingCity").val())) + '","BillingAddressState":"' + encodeURIComponent($.trim($("#txtBillingState").val()))
                + '","BillingAddressPostalCode":"' + $.trim($("#txtBillingPostalCode").val()) + '","BillingAddressCountryID":"' + (isNullOrEmpty($("#ddlBillingCountry").val().toString()) == true ? -1 : $("#ddlBillingCountry").val())
                + '","QuoteTerms":"' + encodeURIComponent($.trim($("#txtQuoteTerms").val())) + '","DepositPercent":"' + $.trim($("#txtDepositPercent").val()) + '","DepositTerms":"' + encodeURIComponent($.trim($("#txtDepositTerms").val()))
                + '","Latitude":"' + ($.trim($("#txtLatitude").val()) == "" ? 0 : $.trim($("#txtLatitude").val())) + '","Longitude": "' + ($.trim($("#txtLongitude").val()) == "" ? 0 : $.trim($("#txtLongitude").val()))
                + '","AddressCountryName":"' + ($kendoJS("#ddlCountry").data("kendoDropDownList").text() == "Country" ? "" : $kendoJS("#ddlCountry").data("kendoDropDownList").text())
                + '","BillingAddressCountryName":"' + ($kendoJS("#ddlBillingCountry").data("kendoDropDownList").text() == "Billing Country" ? "" : $kendoJS("#ddlBillingCountry").data("kendoDropDownList").text()) + '"}';

            PostRequest("RegisterSupplier", postData, RegisterSupplierSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, success message will be showed in popup.
        function RegisterSupplierSuccess(response) {
            //ClearControls('divRegisterSupplierControls');
            SetSupplierSession(response);
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Registration', response, '#');
            $("btnRegister").prop('disabled', false);
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window            
            ErrorWindow('Registration', response, '#');
            $("btnRegister").prop('disabled', false);
        }

        //Sets supplier values to sessoin variables.
        function SetSupplierSession(response) {
            $("#hdnSupplierId").val(response);

            var postData = "{IsSupplier:'" + true + "', SupplierId:'" + response + "'}";
            $.ajax({
                type: "POST",
                url: $("#hdnWebUrl").val() + "SetSupplierSession",
                data: postData,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    GetResponse("GetAllowedPagesByOAuthAccount", "/" + $("#hdnOAuthAccountID").val(), GetAllowedPagesSuccess, Failure, ErrorHandler);
                    // UploadSupplierLogo();
                    //SuccessWindow('Registration', 'Registered successfully.', 'SupplierDashboard.aspx');
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
                    UploadSupplierLogo();
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
                $("#txtBillingName").val($("#txtSupplierName").val());
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

        function ClearLogoValidation() {
            // Get plugin instance
            var bootstrapValidator = $JS10('#frmRatingReviewEngine').data('bootstrapValidator');
            bootstrapValidator.updateStatus('fileupload1', 'NOT_VALIDATED');
            setTimeout(function () { timerClearLogoValidation(); }, 500);
            $('#divLogoFormGroup').find('small.help-block').hide(); 
        }

        function ClearIconValidation() {
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
    <h2 class="h2">Supplier</h2>
    <div id="divRegisterSupplierControls">
        <div class="row">
            <div class="form-horizontal col-md-6" role="form">
                <h4>Register as Supplier</h4>
                <hr />
                <div class="col-md-8">
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Name</label>
                        </div>
                        <input type="hidden" id="hdnSupplierId" name="hdnSupplierId" value="11" />
                        <input type="text" id="txtSupplierName" name="txtSupplierName" class="form-control" placeholder="Name" onblur="CheckSupplierCompanyName()" maxlength="50" />
                        <span id="spanSupplierName" class="custom-register-email-span"></span>
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Email</label>
                        </div>
                        <input type="text" id="txtEmail" name="txtEmail" class="form-control" placeholder="Email" onblur="CheckSupplierEmail()" maxlength="200" />
                        <span id="spanEmail" class="custom-register-email-span" style="margin-left: 2px;"></span>
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Primary Phone</label>
                        </div>
                        <input type="text" id="txtPrimaryPhone" name="txtPrimaryPhone" class="form-control" placeholder="Primary Phone" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Other Phone</label>
                        </div>
                        <input type="text" id="txtOtherPhone" name="txtOtherPhone" class="form-control" placeholder="Other Phone" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Business Number</label>
                        </div>
                        <input type="text" id="txtBusinessNumber" name="txtBusinessNumber" class="form-control" placeholder="Business Number" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Website</label>
                        </div>
                        <input type="text" id="txtWebsite" name="txtWebsite" class="form-control" placeholder="Website" maxlength="200" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Quote Terms</label>
                        </div>
                        <textarea id="txtQuoteTerms" name="txtQuoteTerms" class="form-control" placeholder="Quote Terms" maxlength="250"></textarea>
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Deposit Percent</label>
                        </div>
                        <input type="text" id="txtDepositPercent" name="txtDepositPercent" class="form-control" placeholder="Deposit Percent" maxlength="6" onchange="CalculateDepositPercentageOwner()" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Deposit Terms</label>
                        </div>
                        <textarea id="txtDepositTerms" name="txtDepositTerms" class="form-control" placeholder="Deposit Terms" maxlength="250"></textarea>
                    </div>
                </div>
            </div>
            <div class="form-horizontal col-md-6" role="form">
                <h4>Logo</h4>
                <hr />
                <div class="col-md-11">
                    <div class="form-group1" id="divLogoFormGroup">
                        <div class="fileinput fileinput-new" data-provides="fileinput">
                            <div class="custom-regsupplier-remove-btn">
                                <a href="#" class="fileinput-exists fui-cross" data-dismiss="fileinput" onclick="ClearLogoValidation()"></a>
                            </div>
                            <div class="fileinput-preview thumbnail custom-regsupplier-logo_icon-size" ></div>
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
            <div class="form-horizontal col-md-6" role="form">
                <h4>Icon</h4>
                <hr />
                <div class="col-md-11">
                    <div class="form-group1" id="divIconFormGroup">
                        <div class="fileinput fileinput-new" data-provides="fileinput">
                            <div class="custom-regsupplier-remove-btn">
                                <a href="#" class="fileinput-exists fui-cross" data-dismiss="fileinput" onclick="ClearIconValidation()"></a>
                            </div>
                            <div class="fileinput-preview thumbnail custom-regsupplier-logo_icon-size"></div>
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
        <div class="row">
            <div class="form-horizontal col-md-6" role="form">
                <h4>Address</h4>
                <hr />
                <div class="col-md-8">
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Address 1</label>
                        </div>
                        <input type="text" id="txtAddress1" name="txtAddress1" class="form-control address1" placeholder="Address 1" onblur="LocationSearch(this)" maxlength="150" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Address 2</label>
                        </div>
                        <input type="text" id="txtAddress2" name="txtAddress2" class="form-control address2" placeholder="Address 2" onblur="LocationSearch(this)" maxlength="150" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">City</label>
                        </div>
                        <input type="text" id="txtCity" name="txtCity" class="form-control administrative_area_level_2" placeholder="City" onblur="LocationSearch(this)" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">State</label>
                        </div>
                        <input type="text" id="txtState" name="txtState" class="form-control administrative_area_level_1" placeholder="State" onblur="LocationSearch(this)" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Postal Code</label>
                        </div>
                        <input type="text" id="txtPostalCode" name="txtPostalCode" class="form-control postal_code" placeholder="Postal Code" onblur="LocationSearch(this)" maxlength="50" />
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
                        <input type="text" id="txtBillingName" name="txtBillingName" class="form-control" placeholder="Billing Name" maxlength="150" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Billing Address 1</label>
                        </div>
                        <input type="text" id="txtBillingAddress1" name="txtBillingAddress1" class="form-control" placeholder="Billing Address 1" maxlength="150" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Billing Address 2</label>
                        </div>
                        <input type="text" id="txtBillingAddress2" name="txtBillingAddress2" class="form-control" placeholder="Billing Address 2" maxlength="150" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Billing City</label>
                        </div>
                        <input type="text" id="txtBillingCity" name="txtBillingCity" class="form-control" placeholder="Billing City" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Billing State</label>
                        </div>
                        <input type="text" id="txtBillingState" name="txtBillingState" class="form-control" placeholder="Billing State" maxlength="50" />
                    </div>
                    <div class="form-group">
                        <div class="custom-field-div-textleft">
                            <label class="custom-field-label-fontstyle">Billing Postal Code</label>
                        </div>
                        <input type="text" id="txtBillingPostalCode" name="txtBillingPostalCode" class="form-control" placeholder="Billing Postal Code" maxlength="50" />
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
        <div class="row">
            <div class="col-md-3"></div>
            <div class="col-md-6">
                <fieldset class="gllpLatlonPicker">
                    <div class="form-group" style="margin-top: 15px;">
                        <input type="text" class="gllpSearchField form-control custom-regsupplier-search-textbox" placeholder="Search" />
                        <input type="button" class="gllpSearchButton btn btn-primary custom-regsupplier-search-button" value="Search by Location" />
                    </div>
                    <br />
                    <br />
                    <div class="gllpMap">Google Maps</div>
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
                    <div class="col-md-6" style="margin-left: -15px;">
                        <span id="latitudeVadiation" class="custom-supplierdashboard-email-validation-off"></span>
                    </div>
                    <div class="col-md-6" style="margin-left: -12px;">
                        <span id="longitudeVadiation" class="custom-supplierdashboard-email-validation-off"></span>
                    </div>
                    <div class="custom-regsupplier-updatemap-button">
                        <input type="button" class="gllpUpdateButton btn btn-primary" value="Search by Co-ordinate" />
                    </div>
                    <div style="display: none;">
                        zoom:
                            <input type="text" class="gllpZoom" value="3" />
                        <input type="text" class="gllpLocationName form-control custom-regsupplier-location-textbox" placeholder="Longitude" />
                    </div>
                </fieldset>
            </div>
            <div class="col-md-3"></div>
        </div>
        <div class="row custom-regsupplier-register-top">
            <div class="col-md-4"></div>
            <div class="col-md-4">
                <div class="form-group">
                    <input type="button" id="btnRegister" value="Register" class="btn btn-block btn-lg btn-primary" onclick="SubmitSupplier()" />
                </div>
            </div>
            <div class="col-md-4"></div>
        </div>
    </div>


</asp:Content>
