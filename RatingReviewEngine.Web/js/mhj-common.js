
$(document).ready(function () {

    function isIE() {
        var myNav = navigator.userAgent.toLowerCase();
        return (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
    }

    $.ajax({
        type: "POST",
        url: $("#hdnWebUrl").val() + "GetSession",
        data: "{strSessionName:'UserName'}",
        contentType: "application/json; charset=utf-8",
        global: false, /* if global option set to false, the .ajaxStart() method will not fire. */
        dataType: "json",
        success: function (response) {
            if (response.d == "") {

                if (isIE() == 8) {
                    $("#divEmailId").removeClass("col-md-6").addClass("col-md-5");
                    $("#divRegister").css('margin-right', '20px');
                } else {
                    $("#divEmailId").removeClass("col-md-5").addClass("col-md-4");
                }

                $("#divLogout").removeClass("custom-visible").addClass("custom-hide");
            }
            else {

                if (isIE() == 8) {
                    $("#divEmailId").removeClass("col-md-5").addClass("col-md-6");
                    $("#divRegister").css('margin-right', '0px');
                } else {
                    $("#divEmailId").removeClass("col-md-4").addClass("col-md-5");
                }

                $("#divLogout").removeClass("custom-hide").addClass("custom-visible");
            }
        },
        failure: function (response) {
            console.log(response);
        },
        error: function (response) {
            console.log(response);
        }
    });

    $('#logout').click(function (e) {
        //$("#hdnUserName").val('');
        //$("#divEmailId").text('');
        $.ajax({
            type: "POST",
            url: $("#hdnWebUrl").val() + "ClearSession",
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                if (response.d == "") {
                    window.location = "Home.aspx";
                    //$("#divLogout").removeClass("custom-visible").addClass("custom-hide");
                    //$("#divEmailId").removeClass("col-md-5").addClass("col-md-4");
                }
            },
            failure: function (response) {
                console.log(response);
            },
            error: function (response) {
                console.log(response);
            }
        });
    });

});


/*Encrypt the give data. Used for encrypting user information stored in cookie*/
function Encrypted(data) {
    var key = CryptoJS.enc.Utf8.parse('9061737323313233');
    var iv = CryptoJS.enc.Utf8.parse('9061737323313233');
    var encrypted = CryptoJS.AES.encrypt(CryptoJS.enc.Utf8.parse(data), key,
        {
            keySize: 128 / 8,
            iv: iv,
            mode: CryptoJS.mode.CBC,
            padding: CryptoJS.pad.Pkcs7
        });
    return encrypted;
}

/*Decrypt the give encrypted value to its original value. */
function Decrypted(data) {
    var key = CryptoJS.enc.Utf8.parse('9061737323313233');
    var iv = CryptoJS.enc.Utf8.parse('9061737323313233');
    var decrypted = CryptoJS.AES.decrypt(data, key, {
        keySize: 128 / 8,
        iv: iv,
        mode: CryptoJS.mode.CBC,
        padding: CryptoJS.pad.Pkcs7
    });
    return decrypted.toString(CryptoJS.enc.Utf8);
}

// restore behavior of .cancel from jquery validate to allow submit button 
// to automatically bypass all jquery validation
$(document).on('click', 'input[type=image].cancel,input[type=submit].cancel', function (evt) {
    // find parent form, cancel validation and submit it
    // cancelSubmit just prevents jQuery validation from kicking in
    $(this).closest('loginForm').data("validator").cancelSubmit = true;
    $(this).closest('loginForm').submit();
    return false;
});


function SuccessWindow(strTitle, strMessage, strLocation) {
    BootstrapDialog.show({
        title: strTitle,
        message: strMessage,
        buttons: [{
            label: 'Ok',
            action: function (dialogItself) {
                dialogItself.close();
                window.location = strLocation;
            }
        }],
        type: BootstrapDialog.TYPE_SUCCESS
        ,
        onhidden: function (dialogRef) {
            dialogRef.close();
            window.location = strLocation;
        }
    });
}


function ErrorWindow(strTitle, response, strLocation) {

    var strMessage = response;
    if (strMessage == "Internal Server Error")
        strMessage = "Invalid request";

    /*//If error response in xml format
    if (response.responseText.indexOf("<") == 0) {
        var xmlResponse = $.parseXML(response.responseText)
        strMessage = $(xmlResponse).find('ErrorMessage').text();
    }
        //If error response is json format
    else if (response.responseText.indexOf("{") == 0) {
        jsonResponse = JSON.parse(response.responseText);
        strMessage = jsonResponse.ErrorMessage;
    }
    */

    BootstrapDialog.show({
        title: strTitle,
        message: strMessage,
        buttons: [{
            label: 'Ok',
            action: function (dialogItself) {
                dialogItself.close();
                window.location = strLocation;
            }
        }],
        type: BootstrapDialog.TYPE_DANGER
        ,
        onhidden: function (dialogRef) {
            dialogRef.close();
            window.location = strLocation;
        }
    });
}

function FailureWindow(strTitle, strMessage, strLocation) {
    BootstrapDialog.show({
        title: strTitle,
        message: strMessage,
        buttons: [{
            label: 'Ok',
            action: function (dialogItself) {
                dialogItself.close();
                window.location = strLocation;
            }
        }],
        type: BootstrapDialog.TYPE_WARNING
    });
}

function ClearControls(containerName) {
    ////$('#' + containerName + ' input').attr('value', '').attr('checked', '');

    $(':input', '#' + containerName).each(function () {
        var type = this.type;
        var tag = this.tagName.toLowerCase();

        if (type == 'text' || type == 'password' || tag == 'textarea')
            this.value = "";

        else if (type == 'checkbox' || type == 'radio')
            this.checked = false;

        else if (tag == 'select')
            this.selectedIndex = -1;
    });
}

var formatUTCDate = function (d) {
    var str = Date.UTC(d.getFullYear(), d.getMonth(), d.getDate(), d.getHours(), d.getMinutes(), d.getSeconds(), 0);
    return str;
}

function AllowDecimalKeyPress(e) {

    var charCode = (e.which) ? e.which : event.keyCode;
    if (e.which != 8 && e.which != 0 && charCode != 45 && (charCode != 46 || $(this).val().indexOf('.') != -1) &&
                (charCode < 48 || charCode > 57)) {
        e.preventDefault();
    }
    
}

function AllowDecimal(e) {
   
    var keyCode = e.which; // Capture the event

    //190 is the key code of decimal if you dont want decimals remove this condition keyCode != 190
    if (keyCode != 8 && keyCode != 9 && keyCode != 13 && keyCode != 37 && keyCode != 38 && keyCode != 39 && keyCode != 40 && keyCode != 46 && keyCode != 110 && keyCode != 190) {
        if (keyCode < 48) {
            e.preventDefault();
        }
        else if (keyCode > 57 && keyCode < 96) {
            e.preventDefault();
        }
        else if (keyCode > 105) {
            e.preventDefault();
        }
    }
}


function AllowNumberKeyPress(e) {

    if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
        e.preventDefault();
    }
    
}

function AllowNumber(e) {

    var keyCode = e.which; // Capture the event

    if (keyCode != 8 && keyCode != 9 && keyCode != 13 && keyCode != 37 && keyCode != 38 && keyCode != 39 && keyCode != 40 && keyCode != 46) {  // && keyCode != 110 (Numpad Del Key (.))
        if (keyCode < 48) {
            e.preventDefault();
        }
        else if (keyCode > 57 && keyCode < 96) {
            e.preventDefault();
        }
        else if (keyCode > 105) {
            e.preventDefault();
        }
    }
}
function GetQueryStringParams(sParam) {
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i < sURLVariables.length; i++) {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == sParam) {
            var value = Decrypted(sParameterName[1]);
            if (isInteger(value) && value != '') {
                return value;
            } else {
                return -1;
            }
        }
    }
}

function isInteger(x) {
    return ((x % 1 === 0));
}

/*
 To retreive string value in 
*/
function GetQueryStringParamAsString(sParam) {
    var sPageURL = window.location.search.substring(1);
    var sURLVariables = sPageURL.split('&');
    for (var i = 0; i < sURLVariables.length; i++) {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == sParam) {
            return sParameterName[1];
        }
    }
}

function Encode(controlValue) {
    return encodeURIComponent(controlValue);
}

function SetReadOnly(id) {
    $("#" + id).keypress(function (evt) {
        var keycode = evt.charCode || evt.keyCode;
        if (keycode == 9) { //allow Tab through
            return true;
        } else {
            return false;
        }
    });
}

function ClearValidation() {
    var formValidator = $("#frmRatingReviewEngine").validate();
    formValidator.resetForm();
    $('div').removeClass('has-error');
    $('label').css('color', '#34495e');
    $('.error').css('color', '#E74C3C');
}

function DecimalValidation(val) {
    //if (val.match(/^[+-]?[0-9,]+$/) || val.match(/^[+-]?[0-9,]+\.\d{1,}$/))
    if (val.match(/^[+-]?[0-9]{1,}(?:\.[0-9]{1,})?$/))
        return true;
    else
        return false;
}

function IntegerValidation(val) {
    //if (val.match(/^[+-]?[0-9,]+$/) || val.match(/^[+-]?[0-9,]+\.\d{1,}$/))
    if (val.match(/^[+-]?[0-9,]+$/))
        return true;
    else
        return false;
}

function htmlEncode(value) {
    if (value) {
        return jQuery('<div />').text(value).html();
    } else {
        return '';
    }
}

function htmlReplace(value) {
    if (value) {
        var val = '';
        val = value.replace(/\</g, '<\\');
        val = val.replace(/\>/g, '>\\');
        val = val.replace(/\n/g, '\\n');
        val = val.replace(/"/g, '\"');
        val = val.replace(/'/g, '\'');
        return val;
    }
    else {
        return '';
    }
}

/*
*  Converts \n newline chars into <br> chars s.t. they are visible
*  inside HTML
*/
function convertToHTMLVisibleNewline(value) {
    if (value != null && value != "") {
        return value.replace(/\n/g, "<br/>");
    } else {
        return value;
    }
}

/*
*  Converts <br> chars into \n newline chars s.t. they are visible
*  inside text edit boxes
*/
function convertToTextVisibleNewLine(value) {
    if (value != null && value != "") {
        return value.replace(/\<br\>/g, "\n");
    } else {
        return value;
    }
}

/*
*  Escape newline chars for being transmitted with JSON over the wire
*/
function escapeNewLineChars(valueToEscape) {
    if (valueToEscape != null && valueToEscape != "") {
        return valueToEscape.replace(/\n/g, "\\n");
    } else {
        return valueToEscape;
    }
}

/*
*  Check is empty string
*/
function isNullOrEmpty(value) {
    return !(typeof value === "string" && value.length > 0);
}
