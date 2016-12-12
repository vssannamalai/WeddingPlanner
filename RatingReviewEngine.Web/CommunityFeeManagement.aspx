<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="CommunityFeeManagement.aspx.cs" Inherits="RatingReviewEngine.Web.CommunityFeeManagement" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>
<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">

    <style>
        .k-reset {
            font-size: 88% !important;
        }

        .k-dropdown {
            width: auto;
        }

        .k-list-container {
            width: auto !important;
        }

            .k-list-container .k-list .k-item {
                white-space: nowrap;
            }

        #ddlCommunity-list ul {
            overflow-x: hidden !important;
        }

            #ddlCommunity-list ul li {
                padding-right: 30px;
            }
    </style>

    <script type="text/javascript">
        var communitygroupId;
        var valid = true;

        $(document).ready(function () {
            $("#divCommunityGroup").hide();
            $("#btnApplyTop").hide();

            var param = "/" + $("#hdnCommunityOwnerId").val();
            GetResponse("GetCommunityListByOwner", param, GetCommunityListSuccess, Failure, ErrorHandler);
        });

        function BindBillFee(id) {
            if ($(id).is(':checked')) {
                var param = "/" + $(id).attr('id');
                GetResponse("GetCommunityGroupBillingFeeList", param, GetBillFeeSuccess, Failure, ErrorHandler);
                $("#btnApply").removeAttr('disabled');
                $("#btnApplyTop").removeAttr('disabled');
                $("#btnApplyTop").show();
            }
            else {

                $("#div" + $(id).attr('id')).remove();
                if ($('#divBillFee').find('div')[0] != null) {

                }
                else {

                    var valid = false;
                    $("#lsvCommunityGroup").find("input").each(function () {
                        if ($(this).is(":checked")) {
                            valid = true;
                        }
                    });

                    if (!valid) {
                        $("#btnApply").attr('disabled', 'disabled');
                        $("#btnApplyTop").attr('disabled', 'disabled');
                        $("#btnApplyTop").hide();
                    }
                }
            }


            $('#divBillFee').find('.emptTD').each(function (e) {
                $(this).hide();
            });

            $('#divBillFee').find('.actionName').each(function (e) {
                $(this).hide();
            });

            $('#divBillFee').find('.divAction').each(function (e) {
                $(this).css('clear', 'none');
            });


            var cnt = 0;
            $('#divBillFee').find('.divAction').each(function (e) {

                if ((cnt % 2) == 0) {
                    var div = $('#divBillFee').find('.divAction')[cnt];
                    $(div).css('clear', 'both');
                    $(div).find('.actionName').each(function (e) {
                        $(this).show();
                    });
                    $(div).find('.emptTD').each(function (e) {
                        $(this).show();
                    });
                }
                cnt = cnt + 1;
            });
        }

        //On ajax call success, binds the listview.
        function GetBillFeeSuccess(response) {
            $kendoJS("#lsvBillFee").kendoListView({
                dataSource: response,
                template: kendo.template($("#feerowTemplate").html())
            });

            if ($('#divBillFee').find('div')[0] != null) {
                $('#lsvBillFee').find('.actionName').each(function (e) {
                    $(this).hide();
                });
            }

            var elem = $('#lsvBillFee').html();
            var div = '<div class="divAction" style="float: left; padding-top: 10px;" id="div' + response[0].CommunityGroupID + '"><table><tr><td class="emptTD" style="padding: 0 0 0 10px;">Action</td><td style="background-color: \#34495E; width: 2px;"></td><td colspan="4" style="padding: 10px;height:82px"><div style="width:365px"><a class="custom-anchor" href="OwnerCommunityGroupDetail.aspx?gid='
                + Encrypted(response[0].CommunityGroupID) + '&cid=' + Encrypted(response[0].CommunityID) + '">' + htmlEncode(response[0].CommunityGroupName) + '</a></div></td></tr><tr><td colspan="6" style="background-color: #34495E; height: 2px;"></<td></tr>' + $('#lsvBillFee').html() + '</table></div>'
            //$('#divBillFee').append(elem);
            $('#divBillFee').append(div);

            if ($('#divBillFee').find('div')[0] != null) {
                $('#divBillFee').find('.emptTD').each(function (e) {
                    $(this).hide();
                });

                $('#divBillFee').find('.actionName').each(function (e) {
                    $(this).hide();
                });

                var cnt = 0;
                $('#divBillFee').find('.divAction').each(function (e) {
                    if ((cnt % 2) == 0) {
                        var div = $('#divBillFee').find('.divAction')[cnt];
                        $(div).css('clear', 'both');
                        $(div).find('.emptTD').each(function (e) {
                            $(this).show();
                        });

                        $(div).find('.actionName').each(function (e) {
                            $(this).show();
                        });
                    }
                    cnt = cnt + 1;
                });
            }
        }

        //On ajax call success, binds the dropdown.
        function GetCommunityListSuccess(response) {
            $kendoJS("#ddlCommunity").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "CommunityID",
                index: 0,
                suggest: true,
                optionLabel: response.length == 0 ? null : "Select a Community",
                filter: "contains",
                dataSource: response.length == 0 ? [{ Name: "Select a Community", CommunityID: "0" }] : response,
                change: GetCommunityGroup
            });

            var communityId = GetQueryStringParams('cid') == undefined ? "0" : GetQueryStringParams('cid');
            if (communityId != "0") {
                $kendoJS("#ddlCommunity").data("kendoDropDownList").value(communityId);
                GetCommunityGroupLoad();
            }
        }

        //Service call to fetch community group details.
        function GetCommunityGroupLoad() {
            var param = "/" + ($("#ddlCommunity").val() == '' ? "0" : $("#ddlCommunity").val());
            GetResponse("GetCommunityGroupListByCommunity", param, GetCommunityGroupListLoadSuccess, Failure, ErrorHandler);
        }

        //Service call to fetch community group details.
        function GetCommunityGroup() {
            $('#divBillFee').html('');
            var param = "/" + ($("#ddlCommunity").val() == '' ? "0" : $("#ddlCommunity").val());
            GetResponse("GetCommunityGroupListByCommunity", param, GetCommunityGroupListSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds listview with the response data.
        function GetCommunityGroupListLoadSuccess(response) {
            $kendoJS("#lsvCommunityGroup").kendoListView({
                dataSource: response,
                template: kendo.template($("#myTemplate").html())
            });

            $("#lsvCommunityGroup").removeClass('k-listview k-widget');
            $("#divCommunityGroup").show();
            communitygroupId = GetQueryStringParams('gid') == undefined ? "0" : GetQueryStringParams('gid');

            $("#lsvCommunityGroup").find("input").each(function () {
                var param = "/" + $(this).attr('id');
                if (communitygroupId != "0") {
                    if (communitygroupId == $(this).attr('id'))
                        $(this).checkbox('check');
                }
                else
                    $(this).checkbox('check');
            });

            communitygroupId = 0;
            $('.Fee').keydown(function (e) {
                AllowDecimal(e);
            });
        }

        //On ajax call success, binds listview with the response data.
        function GetCommunityGroupListSuccess(response) {

            $("#btnApply").attr('disabled', 'disabled');
            $("#btnApplyTop").attr('disabled', 'disabled');
            $("#btnApplyTop").hide();

            if (response.length == 0) {
                $("#spanNoItems").css('display', 'block');
            }
            else {
                $("#spanNoItems").css('display', 'none');
            }

            $kendoJS("#lsvCommunityGroup").kendoListView({
                dataSource: response,
                template: kendo.template($("#myTemplate").html())
            });

            $("#lsvCommunityGroup").removeClass('k-listview k-widget');
            $("#divCommunityGroup").show();
            communitygroupId = GetQueryStringParams('gid') == undefined ? "0" : GetQueryStringParams('gid');

            $("#lsvCommunityGroup").find("input").each(function () {
                var param = "/" + $(this).attr('id');
                $(this).checkbox('check');
            });

            communitygroupId = 0;
            $('.Fee').keydown(function (e) {
                AllowDecimal(e);
            });
        }

        //This method validates the fees and returns a boolean value.
        function FeeValidation(ctl) {
            var lbl = $(ctl).parent().find('span')
            if ($(ctl).val() == '') {
                $(ctl).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $(lbl).text("You can\'t leave this empty.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                return false;
            }
            else {
                if (DecimalValidation($(ctl).val())) {
                    $(ctl).closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                    $(lbl).removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                    return true;
                }
                else {
                    $(ctl).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                    $(lbl).text("Please enter a valid fee.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                    return false;
                }
            }
        }

        //This method validates the day and returns a boolean value.
        function DayValidation(ctl) {
            var lbl = $(ctl).parent().find('span')
            if ($(ctl).val() == '') {
                $(ctl).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $(lbl).text("You can\'t leave this empty.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                return false;
            }
            else {
                if (IntegerValidation($(ctl).val())) {
                    $(ctl).closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                    $(lbl).removeClass("custom-mangcurency-validation-on").addClass("custom-mangcurency-validation-off");
                    return true;
                }
                else {
                    $(ctl).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                    $(lbl).text("Please enter a valid day.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                    return false;
                }
            }
        }

        //This method validates the controls inside listview.
        function Validation() {
            var valid = true;
            $("#divBillFee").find('div').each(function () {
                $(this).find('.tr').each(function () {
                    $(this).find('input').each(function () {
                        switch ($(this).attr('id')) {

                            case "txtFee":
                                if (!FeeValidation(this))
                                    valid = false;
                                break;

                            case "txtBillfree":
                                if (!DayValidation(this))
                                    valid = false;
                                break;
                        }
                    });

                });
            });
            return valid;
        }

        //Service call to update fee details.
        function UpdateFee() {
            if (Validation()) {
                var div = $("#divBillFee");
                var id = 0;
                var lst = [];
                var postData = '{';
                $("#divBillFee").find('div').each(function () {
                    $(this).find('.tr').each(function () {
                        $(this).find('input').each(function () {
                            switch ($(this).attr('id')) {
                                case "hdfId":
                                    postData += '"CommunityGroupBillingFeeID":"' + $(this).val() + '",';
                                    id = $(this).val();
                                    break;

                                case "txtFee":
                                    postData += '"Fee":"' + $(this).val() + '",';
                                    break;

                                case "hdfTriggeredEventId":
                                    postData += '"TriggeredEventID":"' + $(this).val() + '",';
                                    break;

                                case "txtBillfree":
                                    postData += '"BillFreeDays":"' + $(this).val() + '",';
                                    break;

                                case "hdfCommunityGroupId":
                                    postData += '"CommunityGroupID":"' + $(this).val() + '",';
                                    break;

                                case "hdfFeeCurrencyID":
                                    postData += '"FeeCurrencyID":"' + $(this).val() + '",';
                                    break;
                            }
                        });

                        postData = postData.substring(0, postData.length - 1);
                        postData += '}';

                        lst.push(postData);

                        //if (id > 0)
                        //    PostRequest("UpdateCommunityGroupBillingFee", postData, CommunityGroupBillingFeeSuccess, Failure, ErrorHandler);
                        //else
                        //    PostRequest("AddCommunityGroupBillingFee", postData, CommunityGroupBillingFeeSuccess, Failure, ErrorHandler);

                        postData = '{';
                        id = 0;
                    });
                });

                var pdata = '{"lstGroupBillingFee":[' + lst + ']}';
                PostRequest("UpdateCommunityGroupBillingFeeList", pdata, CommunityGroupBillingFeeSuccess, Failure, ErrorHandler);
            }
        }

        //On ajax call succees, calls BindBillFee() method.
        function CommunityGroupBillingFeeSuccess(response) {
            $('#divBillFee').html('');
            $("#lsvCommunityGroup").find("input").each(function () {
                BindBillFee(this);
            });

            SuccessWindow('Community Fee management', 'Updated successfully.', '#');
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Fee Management', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Fee Management', response, '#');
        }
    </script>
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Community Fee Management</h2>
    <div class="row">
        <hr />
        <div class="col-md-12">
            <div class="col-md-3">
                <label>Community:</label>
            </div>
            <div class="col-md-9">
                <div class="form-group">
                    <div id="ddlCommunity"></div>
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="col-md-3" id="divCommunityGroup">
                <label>Community Groups:</label>
            </div>
            <div class="col-md-9">
                <div class="form-group">
                    <span id="spanNoItems" style="display: none; font-weight: bold; font-size: 15px; padding-top: 3px; color: #bdc3c7;">No community groups available</span>
                    <div id="lsvCommunityGroup" class="k-listview"></div>
                </div>
                <script type="text/x-kendo-tmpl" id="myTemplate">    
                    <div data="${CommunityGroupID}">
                        <label for="#:CommunityGroupID#" class="checkbox custom-comfeemang-checkbox-align">
                            <span class="icons"><span class="first-icon fui-checkbox-unchecked"></span><span class="second-icon fui-checkbox-checked"></span></span>
                            <input type="checkbox" value="" id="#:CommunityGroupID#" data-toggle="checkbox" onchange="BindBillFee(this)" />
                            <span>#:Name#</span>
                        </label>                        
                    </div>
                </script>
            </div>
        </div>
        <div class="col-md-12 custom-comfeemang-button-top">
            <div class="col-md-2 pull-right">
                <div class="form-group">
                    <input type="button" value="Apply" id="btnApplyTop" class="col-md-2 btn btn-block btn-lg btn-primary" onclick="UpdateFee()" disabled />
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="form-group" style="display: none">
                <div id="lsvBillFee" class="k-listview"></div>
            </div>
            <script id="feerowTemplate" type="text/x-kendo-tmpl">
	            <tr class='tr'>
		            <td class="actionName" style="padding: 10px 5px 10px; width: 165px; line-height: 1em;">
                        <span class="title" style="font-size: 14px; word-wrap: break-word;">#: ActionName #</span>
		            </td>
                    <td style="background-color: \#34495E; width: 2px;"></td>
                    <td class="form-group" style="padding: 13px 5px 13px; width: 105px; height: 70px; float: left; margin-bottom: 0px;">
			            <input class="Fee form-control" id="txtFee" onkeydown="AllowDecimal(event)" type="text" style="width:100px;" value="#: Fee #" maxlength="10" onblur="FeeValidation(this)"/>
                        <span id="spanFee" class="custom-mangcurency-validation-off" style="width: 178px; font-size: 13px;"></span>
                        <input type="hidden" id='hdfId' value=#: CommunityGroupBillingFeeID # />
                        <input type="hidden" id='hdfTriggeredEventId' value=#: TriggeredEventID # />
                        <input type="hidden" id='hdfCommunityGroupId' value=#: CommunityGroupID # />
                        <input type="hidden" id='hdfFeeCurrencyID' value=#: FeeCurrencyID # />
                    </td>
                    <td class="form-group" style="padding: 16px 5px 16px; width: 15px; float: left; margin-bottom: 0px"><span style="font-size: 14px;">#= IsPercentFee == 1 ? '%' : '$' #</span></td>
                    <td class="form-group" style="padding: 16px 5px 16px; width: 110px; float: left; margin-bottom: 0px"><span style="font-size: 14px; margin-left: 8px;">Bill-Free Days:</span></td>
		            <td class="form-group" style="padding: 13px 5px 13px; width: 100px; float: left; height: 70px; margin-bottom: 0px">		                
                        <input class="form-control" type="text" id="txtBillfree" onkeydown="AllowNumber(event)" style="width:100px" value="#: BillFreeDays #" maxlength="3" onblur="DayValidation(this)" />
                        <span id="spanDay" class="custom-mangcurency-validation-off" style="width: 178px; font-size: 13px; margin-left: -5px;"></span>
		            </td>
                    <td class="form-group" style="padding: 5px; margin-bottom: 0px"></td>
                </tr>
            </script>
        </div>
        <div id="divBillFee" class="col-md-12">
        </div>
        <div class="col-md-12 custom-comfeemang-button-top">
            <div class="col-md-2 pull-right">
                <div class="form-group">
                    <input type="button" value="Apply" id="btnApply" class="col-md-2 btn btn-block btn-lg btn-primary" onclick="UpdateFee()" disabled />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
