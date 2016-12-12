
function setHeader(xhr) {
    xhr.setRequestHeader('APIToken', $("#hdnApplicationAPIToken").val());
    xhr.setRequestHeader('AuthToken', $("#hdnAuthToken").val());
}

//To ignore the error on page redirection Reference : http://stackoverflow.com/questions/4807572/jquery-ajax-error-handling-to-ignore-aborted
var globalVars = {
    unloaded: false, errorShown: false
};

$(window).bind('beforeunload', function(){
    globalVars.unloaded = true;
});
 
 

function PostRequest(methodName, postData, successCallback, failureCallback, errorCallback) {
    $("#progress").show();

    $.ajax({
        type: "POST",
        cache: false,
        url: $("#hdnAPIUrl").val() + methodName,
        data: postData,
        //beforeSend: function (request) { request.withCredentials = true; request.setRequestHeader('APIToken', 'WBf2Pve1Hf6Aa5Sa3KWUeZWLdhKX12Q6'); alert('test2'); },
        withCredentials : true,
        beforeSend: setHeader,
        contentType: "text/json; charset=utf-8",
        //contentType: "text/json; charset=utf-8",
        //dataType: "json",

        success: function (response) {
            $("#progress").hide();
            if (successCallback) {
                successCallback(response);
               
            }
        },
        failure: function (response) {
            $("#progress").hide();
            if (failureCallback) {
                failureCallback(response);
            } else {
                console.log(response);
            }
        },
        error: function ( xhr, errorType, exception ) { //Triggered if an error communicating with server  
             
            $("#progress").hide();
            var errorMessage = xhr.responseJSON.ErrorMessage || exception || xhr.statusText; //If exception null, then default to xhr.statusText  
            if (globalVars.unloaded)
                return;
            console.log(errorMessage);
            if (xhr.status != "0" && xhr.status != "400") {
                if (errorCallback) {
                    errorCallback(errorMessage);
                } else {
                    console.log(errorMessage);
                }
            } else {
                if (errorMessage == undefined) {
                    if (globalVars.errorShown == false) {
                        globalVars.errorShown = true;
                        ErrorWindow('Network Error', "Please check your internet connection", '#');
                    }
                } else {
                    if (errorCallback) {
                        errorCallback('Invalid request');
                    } else {
                        console.log(errorMessage);
                    }
                    
                }
                
            }
            
 
        }
        
    });
}

function GetResponse(methodName, param, successCallback, failureCallback, errorCallback) {
    $("#progress").show();
    $.ajax({
        type: "GET",
        cache: false,
        url: $("#hdnAPIUrl").val() + methodName + param,
        contentType: "application/json; charset=utf-8",
        //beforeSend: function (xhr) { xhr.setRequestHeader('APIToken', 'WBf2Pve1Hf6Aa5Sa3KWUeZWLdhKX12Q6'); },
        withCredentials: true,
        beforeSend: setHeader,
        //dataType: "json",
        success: function (response) {
            $("#progress").hide();
            if (successCallback) {
                successCallback(response);
            }
           
        },
        failure: function (response) {
            $("#progress").hide();
            if (failureCallback) {
                failureCallback(response);
            } else {
                console.log(response);
            }
        },
            error: function ( xhr, errorType, exception ) { //Triggered if an error communicating with server  
                $("#progress").hide();
                var errorMessage = xhr.responseJSON.ErrorMessage || exception || xhr.statusText; //If exception null, then default to xhr.statusText  

                if (globalVars.unloaded)
                    return;
                console.log(errorMessage);
                if (xhr.status != "0" && xhr.status != "400") {
                    if (errorCallback) {
                        errorCallback(errorMessage);
                    } else {
                        console.log(errorMessage);
                    }
                }
                else
                {
                    if (errorMessage == undefined) {
                        if (globalVars.errorShown == false) {
                            globalVars.errorShown = true;
                            ErrorWindow('Network Error', "Please check your internet connection", '#');
                        }
                    } else {
                        if (errorCallback) {
                            errorCallback('Invalid request');
                        } else {
                            console.log(errorMessage);
                        }
                    }
                    
                }

        }
    });
}