<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="CommunityRewardManagement.aspx.cs" Inherits="RatingReviewEngine.Web.CommunityRewardManagement" %>

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
        var valid = true;

        $(document).ready(function () {
            $("#divCommunityGroup").hide();
            $("#btnApplyTop").hide();

            GetOwnerCommunityList();
        });

        //Service call to fetch community list based on owner id.
        function GetOwnerCommunityList() {
            var param = "/" + $("#hdnCommunityOwnerId").val();
            GetResponse("GetCommunityListByOwner", param, GetCommunityListSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the data to dropdown.
        function GetCommunityListSuccess(response) {
            $kendoJS("#ddlCommunity").kendoDropDownList({
                dataTextField: "Name",
                dataValueField: "CommunityID",
                index: 0,
                suggest: true,
                optionLabel: response.length == 0 ? null : "Select a Community",
                filter: "contains",
                dataSource: response.length == 0 ? [{ Name: "Select a Community", CommunityID: "0" }] : response,
                change: getCommunityGroup
            });

            var communityId = GetQueryStringParams('cid') == undefined ? "0" : GetQueryStringParams('cid');
            if (communityId != "0") {
                $kendoJS("#ddlCommunity").data("kendoDropDownList").value(communityId);
                getCommunityGroupLoad();
            }
        }

        //Service call to fetch community group list based on owner id and community id.
        function getCommunityGroupLoad() {
            var param = "/" + ($("#ddlCommunity").val() == '' ? "0" : $("#ddlCommunity").val());
            GetResponse("GetCommunityGroupListByCommunity", param, GetCommunityGroupListLoadSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the data to listview.
        function GetCommunityGroupListLoadSuccess(response) {
            $kendoJS("#lsvCommunityGroup").kendoListView({
                dataSource: response,
                template: kendo.template($("#myTemplate").html())
            });

            $("#lsvCommunityGroup").removeClass('k-listview k-widget');

            $("#divCommunityGroup").show();

            if ($("#lsvCommunityGroup").find("input").length == 0)
                $('#divReward').html('');

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
        }

        //Service call to fetch community group list based on owner id and community id.
        function getCommunityGroup() {
            $('#divReward').html('');
            var param = "/" + ($("#ddlCommunity").val() == '' ? "0" : $("#ddlCommunity").val());
            GetResponse("GetCommunityGroupListByCommunity", param, GetCommunityGroupListSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the data to listview.
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

            if ($("#lsvCommunityGroup").find("input").length == 0)
                $('#divReward').html('');

            $("#lsvCommunityGroup").find("input").each(function () {
                var param = "/" + $(this).attr('id');
                $(this).checkbox('check');
            });
        }

        function BindReward(id) {
            valid = true;
            if ($(id).is(':checked')) {
                var param = "/" + $(id).attr('id');
                GetResponse("GetCommunityGroupRewardList", param, GetBillFeeSuccess, Failure, ErrorHandler);
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


            $('#divReward').find('.emptTD').each(function (e) {
                $(this).hide();
            });

            $('#divReward').find('.actionName').each(function (e) {
                $(this).hide();
            });

            $('#divReward').find('.divAction').each(function (e) {
                $(this).css('clear', 'none');
            });


            var cnt = 0;
            $('#divReward').find('.divAction').each(function (e) {

                if ((cnt % 3) == 0) {
                    var div = $('#divReward').find('.divAction')[cnt];
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

        //On ajax call success, binds the data to listview.
        function GetBillFeeSuccess(response) {

            $kendoJS("#lsvReward").kendoListView({
                dataSource: response,
                template: kendo.template($("#rewardrowTemplate").html())
            });

            if ($('#divReward').find('.divAction')[0] != null) {
                $('#lsvReward').find('.actionName').each(function (e) {
                    $(this).hide();
                });
            }

            var div = '<div class="divAction" style="float:left;padding-top: 10px;" id="div' + response[0].CommunityGroupID + '"><table><tr><td class="emptTD" style="padding: 0 0 0 10px;">Action</td>' //+ ($('#divReward').find('div')[0] != null ? '' : '<td></td>')
                + '<td style="background-color: \#34495E; width: 2px;"></td><td  style="padding: 10px;height:144px"><div style="width:230px"><a class="custom-anchor" href="OwnerCommunityGroupDetail.aspx?gid=' + Encrypted(response[0].CommunityGroupID) + '&cid=' + Encrypted(response[0].CommunityID) + '">' + htmlEncode(response[0].CommunityGroupName)
                + '</a></div></td></tr><tr><td colspan="6" style="background-color: #34495E; height: 2px;"></<td></tr>' + $('#lsvReward').html() + '</table></div>'
            $('#divReward').append(div);

            if ($('#divReward').find('.divAction')[0] != null) {

                $('#divReward').find('.emptTD').each(function (e) {
                    $(this).hide();
                });

                $('#divReward').find('.actionName').each(function (e) {
                    $(this).hide();
                });

                var cnt = 0;
                $('#divReward').find('.divAction').each(function (e) {
                    if ((cnt % 3) == 0) {
                        var div = $('#divReward').find('.divAction')[cnt];
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
        //This method validates the controls inside listview.
        function Validation() {
            valid = true;
            $("#divReward").find('div').each(function () {
                $(this).find('.tr').each(function () {
                    $(this).find('input').each(function () {
                        switch ($(this).attr('id')) {
                            case "txtPoint":
                                if (!PointValidation(this))
                                    valid = false;
                                break;
                        }
                    });

                });
            });
            return valid;
        }

        //Service call to update reward details.
        function updateReward() {
            if (Validation()) {
                valid = true;
                var div = $("#divReward");
                var id = 0;
                var lst = [];
                var postData = '{';
                $("#divReward").find('div').each(function () {
                    $(this).find('.tr').each(function () {
                        $(this).find('input').each(function () {
                            switch ($(this).attr('id')) {
                                case "hdfId":
                                    postData += '"CommunityGrouprewardID":"' + $(this).val() + '",';
                                    id = $(this).val();
                                    break;

                                case "txtPoint":
                                    postData += '"Points":"' + $(this).val() + '",';
                                    break;

                                case "hdfTriggeredEventId":
                                    postData += '"TriggeredEventsID":"' + $(this).val() + '",';
                                    break;

                                case "hdfCommunityGroupId":
                                    postData += '"CommunityGroupID":"' + $(this).val() + '",';
                                    break;

                            }
                        });

                        postData = postData.substring(0, postData.length - 1);
                        postData += '}';

                        lst.push(postData);
                        //if (id > 0)
                        //    PostRequest("UpdateCommunityGroupRewardPoint", postData, CommunityGroupRewardSuccess, Failure, ErrorHandler);
                        //else
                        //    PostRequest("AddCommunityGroupRewardPoint", postData, CommunityGroupRewardSuccess, Failure, ErrorHandler);

                        postData = '{';
                        id = 0;
                    });
                });

                var pdata = '{"lstCommunityGroupReward":[' + lst + ']}';
                PostRequest("UpdateCommunityGroupRewardList", pdata, CommunityGroupRewardSuccess, Failure, ErrorHandler);

            }
        }

        //On ajax call success, calls BindReward() method and success message will be showed in popup.
        function CommunityGroupRewardSuccess(response) {
            $('#divReward').html('');
            $("#lsvCommunityGroup").find("input").each(function () {
                BindReward(this);
            });

            SuccessWindow('Reward management', 'Community group reward points updated successfully.', '#');
        }

        //This method validates the point and returns a boolean value.
        function PointValidation(ctl) {
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
                    $(lbl).text("Please enter a valid point.").removeClass("custom-mangcurency-validation-off").addClass("custom-mangcurency-validation-on");
                    return false;
                }
            }
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Reward Management', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Reward Management', response, '#');
        }
    </script>
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Community Reward Management</h2>
    <div class="row">
        <hr />
        <div class="col-md-12">
            <div class="col-md-3">
                <label>Community:</label>
            </div>
            <div class="custom-comrewmang-col-md-5">
                <div class="form-group">
                    <div id="ddlCommunity"></div>
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="col-md-3" id="divCommunityGroup">
                <label>Community Groups:</label>
            </div>
            <div class="custom-comrewmang-col-md-5">
                <div class="form-group">
                    <span id="spanNoItems" style="display: none; font-weight: bold; font-size: 15px; padding-top: 3px; color: #bdc3c7;">No community groups available</span>
                    <div id="lsvCommunityGroup" class="k-listview"></div>
                </div>
                <script type="text/x-kendo-tmpl" id="myTemplate">    
                    <div  data="${CommunityGroupID}">
                        <label for="#:CommunityGroupID#" class="checkbox custom-comrewmang-checkbox-align">
                            <span class="icons"><span class="first-icon fui-checkbox-unchecked"></span><span class="second-icon fui-checkbox-checked"></span></span>
                            <input type="checkbox" value="" id="#:CommunityGroupID#" data-toggle="checkbox" onchange="BindReward(this)" />
                            <span >#:Name#</span>
                        </label>                        
                    </div>
                </script>
            </div>
        </div>
        <div class="col-md-12 custom-comrewmang-button-top">
            <div class="col-md-2 pull-right">
                <div class="form-group">
                    <input type="button" value="Apply" id="btnApplyTop" class="col-md-2 btn btn-block btn-lg btn-primary" onclick="updateReward()" disabled />
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="form-group" style="display: none">
                <div id="lsvReward" class="k-listview"></div>
            </div>
            <script id="rewardrowTemplate" type="text/x-kendo-tmpl">
	            <tr class='tr'>
		            <td class="actionName" style="padding: 10px 5px 10px; width: 165px; line-height: 1em;">
                        <span class="title" style="font-size: 14px; word-wrap: break-word;">#: ActionName #</span>
		            </td>
                    <td style="background-color: \#34495E; width: 2px;"></td>
                    <td class="form-group" style="padding: 13px 5px 13px; width: 105px; height: 70px; float: left; margin-bottom: 0px;">
			            <input class="Point form-control" id="txtPoint" onkeydown="AllowNumber(event)" type="text" style="width: 100px;" value="#: Points #" maxlength="3" onblur="PointValidation(this)" />
                        <span id="spanPoint${CommunityGroupID}${TriggeredEventsID}" class="custom-mangcurency-validation-off" style="width: 178px; font-size: 13px;"></span>
                        <input type="hidden" id='hdfId' value=#: CommunityGrouprewardID # />
                        <input type="hidden" id='hdfTriggeredEventId' value=#: TriggeredEventsID # />
                        <input type="hidden" id='hdfCommunityGroupId' value=#: CommunityGroupID # />
                    </td>
                </tr>                
            </script>
        </div>
        <div id="divReward" class="col-md-12">
        </div>
        <div class="col-md-12 custom-comrewmang-button-top">
            <div class="col-md-2 pull-right">
                <div class="form-group">
                    <input type="button" value="Apply" id="btnApply" class="col-md-2 btn btn-block btn-lg btn-primary" onclick="updateReward()" disabled />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
