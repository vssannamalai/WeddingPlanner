<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="ManageCurrencies.aspx.cs" Inherits="RatingReviewEngine.Web.ManageCurrencies" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <style>
        .k-reset {
            font-size: 88% !important;
        }

        .k-header {
            color: White;
            background-color: #34495E;
            font-size: 16px;
        }

        body {
            font-size: 13px !important;
        }

        .k-pager-numbers .k-link {
            line-height: 2em !important;
        }

        .k-reset {
            font-size: 100% !important;
        }

        .k-grid tbody tr td {
            vertical-align: top;
        }

        .k-list-container {
            width: auto !important;
            min-width: 193px;
        }

        @media only screen and (min-width: 768px) and (max-width: 1024px) {

            .k-list-container {
                width: auto !important;
                min-width: 192px;
            }
        }
    </style>

    <script type="text/javascript">
        var isExist = false;
        var currencyIdFromList;
        var ddl;

        $(document).ready(function () {
            ControlValidation();
            ButtonClickEventOnLoad();
            KeyDownEventOnLoad();
            BindCurrencyList();
            BindDropDown();
        });

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    txtCurrency: { required: true },
                    txtISOCode: { required: true },
                    txtMinTransferAmt: { required: true }
                },
                messages: {
                    txtCurrency: { required: 'You can\'t leave this empty.' },
                    txtISOCode: { required: 'You can\'t leave this empty.' },
                    txtMinTransferAmt: { required: 'You can\'t leave this empty.' }
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
            $('#btnAdd').click(function (e) {
                var isValid = DropDownValidate();
                var isVaidDecimal = ValidatedAmount();
                if ($("#frmRatingReviewEngine").valid() && !isValid && !isExist && !isVaidDecimal) {
                    $('#btnAdd').css("margin-top", "18px");
                    SaveCurrency();
                }
                else {
                    $('#btnAdd').css("margin-top", "-20px");
                }
                e.preventDefault();
            });
        }

        //Registers a keydown event on page load.
        function KeyDownEventOnLoad() {
            $('#txtMinTransferAmt').keydown(function (e) {
                AllowDecimal(e);
            });
        }

        //Service call to get list of currencies.
        function BindCurrencyList() {
            GetResponse("CurrencyList", "", CurrencyListSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the currency information to grid and calls BindDropDownList() method.
        function CurrencyListSuccess(response) {
            $kendoJS("#gvCurrency").kendoGrid({
                dataSource: {
                    //pageSize: 10,
                    data: response
                },
                pageable: false,
                scrollable: false,
                columns: [
                    { field: "Description", width: 260, title: "Currency", template: '<input type="hidden" id="hdnCurrencyId" value=${CurrencyID} /><input type="text" id="txtCurrency${CurrencyID}" maxlength="50" placeholder="Currency" class="form-control" style="height: 23px; width: 87%" value="${Description}" onblur="CheckCurrencyOnListView(this, ${CurrencyID});UpdateValidation()" /><span id="spanCurrency${CurrencyID}" class="custom-mangcurency-validation-off"></span>' },
                    { field: "ISOCode", width: 190, title: "ISO Code", template: '<input type="text" id="txtISOCode${CurrencyID}" maxlength="3" placeholder="ISO Code" class="form-control" style="height: 23px; width: 80%;" value="${ISOCode}" onblur="CheckCurrencyOnListView(this, ${CurrencyID});UpdateValidation()" onkeydown="return onlyAlphabets(event);" /><span id="spanISOCode${CurrencyID}" class="custom-mangcurency-validation-off"></span>' },
                    { field: "MinTransferAmount", width: 180, title: "Min Transfer Amount", template: '<input type="text" id="txtMinTransferAmt${CurrencyID}" placeholder="Min Transfer Amount" maxlength="8" class="form-control" style="height: 23px; width:80%;" value="${MinTransferAmount}" onblur="UpdateValidation()" onkeydown="AllowDecimal(event)"  /><span id="spanMinTransferAmt${CurrencyID}" class="custom-mangcurency-validation-off"></span>' },
                    { width: 220, title: "Is Active", template: '<input id="ddlIsActive${CurrencyID}" onchange="GetActiveCommunity(this)" style="margin-right: 2%;" /><span id="spanIsActive${CurrencyID}" class="custom-mangcurency-validation-off"></span>' }
                ],
            }).data("kendoGrid");

            var responseDataSource = new kendo.data.DataSource({
                data: response
            })

            responseDataSource.read();
            var count = responseDataSource.total();
            for (var i = 0; i < count; i++) {
                BindDropDownList(response[i].CurrencyID, response[i].IsActive);
            }
        }

        //Binds activity dropdown based on static values.
        function BindDropDown() {
            $kendoJS("#ddlIsActive").kendoDropDownList({
                dataTextField: "text",
                dataValueField: "value",
                index: 0,
                optionLabel: "Is Active",
                suggest: true,
                filter: "contains",
                dataSource: [
                    { text: "Yes", value: "1" },
                    { text: "No", value: "0" }
                ],
                change: DropDownValidate
            });
        }

        //Binds activit dropdown list to listview.
        function BindDropDownList(id, isActive) {
            $kendoJS("#ddlIsActive" + id).kendoDropDownList({
                dataTextField: "text",
                dataValueField: "value",
                index: 0,
                suggest: true,
                filter: "contains",
                dataSource: [
                    { text: "Yes", value: "1" },
                    { text: "No", value: "0" }
                ]
            });

            $kendoJS("#ddlIsActive" + id).data('kendoDropDownList').value(isActive == true ? "1" : "0");
        }

        //Validates activity dropdown.
        function DropDownValidate() {
            var result = (isNullOrEmpty($("#ddlIsActive").val().toString()) == true ? true : false);

            if (result == true)
                $("#spanIsActive").text("You can\'t leave this empty.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
            else
                $("#spanIsActive").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");

            return result;
        }

        //Service call to save new currency.
        function SaveCurrency() {
            var postData = '{"ISOCode":"' + encodeURIComponent($("#txtISOCode").val()) + '", "Description":"' + encodeURIComponent($("#txtCurrency").val()) + '", "MinTransferAmount":"' + $("#txtMinTransferAmt").val() + '", "IsActive":"' + $("#ddlIsActive").val() + '"}';
            PostRequest("NewCurrency", postData, SaveCurrencySuccess, Failure, ErrorHandler);
        }

        //On ajax call success, success message will be shown in popup and BindCurrencyList() method will be called.
        function SaveCurrencySuccess(response) {
            ClearControls('divCurrency');
            SuccessWindow('Manage Currency', "Saved successfully.", '#');
            BindCurrencyList();
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Manage Currency', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Manage Currency', response, '#');
        }

        //Updates all the currency information from listview on 'Apply' button click.
        function UpdateCurrencies() {
            var isValid = UpdateValidation();
            if (isValid == false && isExist == false) {
                var div = $("#gvCurrency");
                var lst = [];
                var id = 0;
                var postData = '{';
                var currencyId = 0;
                $("#gvCurrency").find('tr').each(function () {
                    //$(this).find('.tr').each(function () {
                    $(this).find('input').each(function () {
                        switch ($(this).attr('id')) {
                            case "hdnCurrencyId":
                                postData += '"CurrencyID":"' + $(this).val() + '",';
                                id = $(this).val();
                                currencyId = $(this).val();
                                break;

                            case "txtCurrency" + currencyId:
                                postData += '"Description":"' + $(this).val() + '",';
                                id = $(this).val();
                                break;

                            case "txtISOCode" + currencyId:
                                postData += '"ISOCode":"' + $(this).val() + '",';
                                break;

                            case "txtMinTransferAmt" + currencyId:
                                postData += '"MinTransferAmount":"' + $(this).val() + '",';
                                break;

                            case "ddlIsActive" + currencyId:
                                postData += '"IsActive":"' + $(this).val() + '",';
                                break;
                        }
                    });

                    if (postData != '{') {
                        postData = postData.substring(0, postData.length - 1);
                        postData += '}';
                        lst.push(postData);
                        postData = '{';
                        id = 0;
                        // PostRequest("UpdateCurrency", postData, UpdateCurrencySuccess, Failure, ErrorHandler);
                    }

                    // postData = '{';
                });
                //});

                var pdata = '{"lstCurrency":[' + lst + ']}';
                PostRequest("UpdateCurrencyList", pdata, UpdateCurrencySuccess, Failure, ErrorHandler);


            }
        }

        //Ajax call success method (empty). 
        function UpdateCurrencySuccess(response) {
            SuccessWindow('Manage Currency', 'Updated successfully.', '#');
        }

        //Validates all the controls in listview.
        function UpdateValidation() {
            var div = $("#gvCurrency");
            var id = 0;
            var currencyId = 0;
            var isValid = false;
            $("#gvCurrency").find('tr').each(function () {
                //$(this).find('.tr').each(function () {
                $(this).find('input').each(function () {
                    switch ($(this).attr('id')) {
                        case "hdnCurrencyId":
                            id = $(this).val();
                            currencyId = $(this).val();
                            break;

                        case "txtCurrency" + currencyId:
                            id = $(this).val();
                            if (id == "") {
                                $("#txtCurrency" + currencyId).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                                $("#spanCurrency" + currencyId).text("You can\'t leave this empty.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                                isValid = true;
                            }
                            else {
                                $("#spanCurrency" + currencyId).removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                            }
                            break;

                        case "txtISOCode" + currencyId:
                            id = $(this).val();
                            if (id == "") {
                                $("#txtISOCode" + currencyId).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                                $("#spanISOCode" + currencyId).text("You can\'t leave this empty.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                                isValid = true;
                            }
                            else {
                                $("#spanISOCode" + currencyId).removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                            }
                            break;

                        case "txtMinTransferAmt" + currencyId:
                            id = $(this).val();
                            if (id == "") {
                                $("#txtMinTransferAmt" + currencyId).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                                $("#spanMinTransferAmt" + currencyId).text("You can\'t leave this empty.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                                isValid = true;
                            }
                            else {
                                if (DecimalValidation($("#txtMinTransferAmt" + currencyId).val())) {
                                    $("#txtMinTransferAmt" + currencyId).closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                                    $("#spanMinTransferAmt" + currencyId).removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                                }
                                else {
                                    $("#txtMinTransferAmt" + currencyId).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                                    $("#spanMinTransferAmt" + currencyId).text("Please enter a valid amount.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                                    isValid = true;
                                }
                            }
                            break;

                        case "ddlIsActive" + currencyId:
                            break;
                    }
                });
                //});
            });

            return isValid;
        }

        //Service call to check whether the currency already exist.
        function CheckCurrency() {
            var currencyId = 0;
            if ($("#txtCurrency").val() != '' || $("#txtISOCode").val() != '') {
                //var param = "/" + currencyId + "/" + (isNullOrEmpty($("#txtISOCode").val()) == true ? "nullstring" : $("#txtISOCode").val()) + "/" + (isNullOrEmpty($("#txtCurrency").val()) == true ? "nullstring" : $("#txtCurrency").val());
                //GetResponse("CheckCurrency", param, CheckCurrencySuccess, Failure, ErrorHandler);

                var postData = '{"CurrencyID":"' + currencyId + '", "ISOCode":"' + encodeURIComponent(isNullOrEmpty($("#txtISOCode").val()) == true ? "nullstring" : $("#txtISOCode").val()) + '", "Description":"' + encodeURIComponent(isNullOrEmpty($("#txtCurrency").val()) == true ? "nullstring" : $("#txtCurrency").val()) + '"}';
                PostRequest("CheckCurrency", postData, CheckCurrencySuccess, Failure, ErrorHandler);
            }
        }

        //On ajax call success, validates the controls and returns a boolean value.
        function CheckCurrencySuccess(response) {
            if (response == "1") {
                $("#spanISOCode").text("ISO Code already exist.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                $("#spanCurrency").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                isExist = true;
            }
            else if (response == "2") {
                $("#spanCurrency").text("Currency already exist.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                $("#spanISOCode").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                isExist = true;
            }
            else if (response == "3") {
                $("#spanISOCode").text("ISO Code already exist.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                $("#spanCurrency").text("Currency already exist.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                isExist = true;
            }
            else if (response == "0") {
                $("#spanCurrency").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                $("#spanISOCode").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                isExist = false;
            }
        }

        //Service call to check whether the currency already exist inside listview.
        function CheckCurrencyOnListView(ctrl, currencyId) {
            //var param;
            var postData;
            if ($(ctrl).val() != "") {
                currencyIdFromList = currencyId;
                if (ctrl.id == ('txtCurrency' + currencyId)) {
                    //param = "/" + currencyId + "/" + (isNullOrEmpty($("#txtISOCode" + currencyId).val()) == true ? "nullstring" : $("#txtISOCode" + currencyId).val()) + "/" + (isNullOrEmpty($(ctrl).val()) == true ? "nullstring" : $(ctrl).val());
                    postData = '{"CurrencyID":"' + currencyId + '", "ISOCode":"' + encodeURIComponent(isNullOrEmpty($("#txtISOCode" + currencyId).val()) == true ? "nullstring" : $("#txtISOCode" + currencyId).val()) + '", "Description":"' + encodeURIComponent(isNullOrEmpty($(ctrl).val()) == true ? "nullstring" : $(ctrl).val()) + '"}';
                }
                else {
                    //param = "/" + currencyId + "/" + (isNullOrEmpty($(ctrl).val()) == true ? "nullstring" : $(ctrl).val()) + "/" + (isNullOrEmpty($("#txtCurrency" + currencyId).val()) == true ? "nullstring" : $("#txtCurrency" + currencyId).val());
                    postData = '{"CurrencyID":"' + currencyId + '", "ISOCode":"' + encodeURIComponent(isNullOrEmpty($(ctrl).val()) == true ? "nullstring" : $(ctrl).val()) + '", "Description":"' + encodeURIComponent(isNullOrEmpty($("#txtCurrency" + currencyId).val()) == true ? "nullstring" : $("#txtCurrency" + currencyId).val()) + '"}';
                }

                //GetResponse("CheckCurrency", param, CheckCurrencyOnListViewSuccess, Failure, ErrorHandler);
                PostRequest("CheckCurrency", postData, CheckCurrencyOnListViewSuccess, Failure, ErrorHandler);
            }
        }

        //On ajax call success, validates the controls in listview and returns a boolean value.
        function CheckCurrencyOnListViewSuccess(response) {
            if (response == "1") {
                $("#spanISOCode" + currencyIdFromList).text("ISO Code already exist.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                $("#spanCurrency" + currencyIdFromList).removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                isExist = true;
            }
            else if (response == "2") {
                $("#spanCurrency" + currencyIdFromList).text("Currency already exist.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                $("#spanISOCode" + currencyIdFromList).removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                isExist = true;
            }
            else if (response == "3") {
                $("#spanISOCode" + currencyIdFromList).text("ISO Code already exist.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                $("#spanCurrency" + currencyIdFromList).text("Currency already exist.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                isExist = true;
            }
            else if (response == "0") {
                $("#spanCurrency" + currencyIdFromList).removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                $("#spanISOCode" + currencyIdFromList).removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                isExist = false;
            }
        }

        //Service call to check whether any active community is associated with the currency. 
        function GetActiveCommunity(ctl) {
            if (ctl.value == 0) {
                ddl = ctl;
                var param = "/" + ctl.id.substr(11);
                GetResponse("GetCommunityListByCurrency", param, GetActiveCommunitySuccess, Failure, ErrorHandler);
            }
        }

        //On ajax call success, validation message will be displayed.
        function GetActiveCommunitySuccess(response) {
            if (response.length > 0) {
                FailureWindow('Manage Currency', 'Currency cannot be set to inactive if an active community is associated with that currency.', '#');
                ddl.value = 1;
                $(ddl).val('1');
                $kendoJS(ddl).data("kendoDropDownList").value(1);
            }
        }

        function ValidatedAmount() {
            if ($("#txtMinTransferAmt").val() != "") {
                var isValidDecimal;
                if (DecimalValidation($("#txtMinTransferAmt").val())) {
                    $("#txtMinTransferAmt").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                    $("#spanMinTransferAmt").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                    isValidDecimal = false;
                }
                else {
                    $("#txtMinTransferAmt").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                    $("#spanMinTransferAmt").text("Please enter a valid amount.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                    isValidDecimal = true;
                }

                return isValidDecimal;
            }
            else {
                $("#spanMinTransferAmt").removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
            }
        }

        function onlyAlphabets(e) {
            if (e.shiftKey || e.ctrlKey || e.altKey) {
                e.preventDefault();
            } else {
                var key = e.keyCode;
                if (!((key == 8) || (key == 32) || (key == 46) || (key >= 35 && key <= 40) || (key >= 65 && key <= 90))) {
                    e.preventDefault();
                }
            }
        }


        function lettersOnly(evt) {
            evt = (evt) ? evt : event;
            var charCode = (evt.charCode) ? evt.charCode : ((evt.keyCode) ? evt.keyCode :
              ((evt.which) ? evt.which : 0));
            if (charCode > 31 && (charCode < 65 || charCode > 90) &&
              (charCode < 97 || charCode > 122)) {
                return false;
            }
            else
                return true;
        };
    </script>
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Manage Currencies</h2>
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <hr />
            <div class="col-md-12">
                <div id="gvCurrency"></div>
                <div class="col-md-2 pull-right" style="margin-top: 20px;">
                    <div class="form-group">
                        <input type="button" value="Apply" id="btnApply" class="col-md-2 btn btn-block btn-lg btn-primary" onclick="UpdateCurrencies()" />
                    </div>
                </div>
            </div>
            <div class="col-md-12">
                <h4>Add new currency</h4>
                <hr />
            </div>
            <div class="col-md-12" id="divCurrency">
                <div class="col-md-3" style="margin-right: 1%;">
                    <div class="form-group">
                        <div>
                            <label class="custom-field-label-fontstyle">Currency</label>
                        </div>
                        <input type="text" id="txtCurrency" name="txtCurrency" placeholder="Currency" class="form-control" onchange="CheckCurrency()" maxlength="50" />
                        <span id="spanCurrency" class="custom-mangcurency-validation-off"></span>
                    </div>
                </div>
                <div class="custom-mangcurency-col-md-2" style="margin-right: 2%;">
                    <div class="form-group">
                        <div>
                            <label class="custom-field-label-fontstyle">ISO Code</label>
                        </div>
                        <input type="text" id="txtISOCode" name="txtISOCode" placeholder="ISO Code" class="form-control" maxlength="3" onchange="CheckCurrency()" onkeydown="return onlyAlphabets(event);" />
                        <span id="spanISOCode" class="custom-mangcurency-validation-off"></span>
                    </div>
                </div>
                <div class="col-md-3" style="margin-right: 1%;">
                    <div class="form-group">
                        <div>
                            <label class="custom-field-label-fontstyle">Min Transfer Amount</label>
                        </div>
                        <input type="text" id="txtMinTransferAmt" name="txtMinTransferAmt" placeholder="Min Transfer Amount" class="form-control" maxlength="8" onblur="ValidatedAmount()" onkeydown="AllowDecimal(event)" />
                        <span id="spanMinTransferAmt" class="custom-mangcurency-validation-off"></span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="form-group">
                        <div>
                            <label class="custom-field-label-fontstyle">Is Active</label>
                        </div>
                        <input id="ddlIsActive" />
                        <span id="spanIsActive" class="custom-mangcurency-validation-off"></span>
                    </div>
                </div>
            </div>
            <div class="col-md-12 custom-default-top-margin">
                <div class="col-md-2 pull-right">
                    <div class="form-group">
                        <input type="button" value="Add" class="btn btn-block btn-lg btn-primary" id="btnAdd" style="margin-top: 18px;" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
