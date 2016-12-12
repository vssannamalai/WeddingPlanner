<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="ManageSupplierCommunities.aspx.cs" Inherits="RatingReviewEngine.Web.ManageSupplierCommunities" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <style>
        .k-reset {
            font-size: 100% !important;
        }

        .k-header {
            color: White;
            background-color: #34495E;
            font-size: 16px;
        }

        #tbody, tr {
            line-height: 1.42857;
            vertical-align: top;
            font-size: 15px;
        }

        body {
            font-size: 14px !important;
        }

        .form-group {
            top: 8px !important;
        }

        .k-pager-numbers .k-link {
            line-height: 2em !important;
        }

        .k-list-container {
            width: auto !important;
            min-width: 200px;
        }

        @media only screen and (min-width: 768px) and (max-width: 1024px) {

            .k-list-container {
                width: auto !important;
                min-width: 165px;
            }
        }
    </style>

    <script type="text/javascript">
        var communityStatus;
        $(document).ready(function () {
            SetValuesOnLoad();
            GetCommunityMembershipCount($("#hdnSupplierId").val());
            BindCommunity('active');
            BindDistancFilter();
            BindUnits();
            DisableDropDown();
            RegisterKeypressOnLoad();
        });

        //This method the result div and sets true for community and community group checkboxes.
        function SetValuesOnLoad() {
            $("#result").hide();
            $("#communityDiv").hide();
            $("#communityGroupDiv").hide();
            $("#chkCommunities").checkbox('check');
            $("#chkCommunityGroups").checkbox('check');
            $("#txtSearchTerm").attr('disabled', '');
        }

        //This method binds static values to unit dropdown.
        function BindUnits() {
            $kendoJS("#ddlUnits").kendoDropDownList({
                dataTextField: "text",
                dataValueField: "value",
                index: 0,
                suggest: true,
                filter: "contains",
                dataSource: [
                    { text: "KM (kilometers)", value: "KM" },
                    { text: "Mi. (miles)", value: "Mi" }
                ]
            });
        }

        //Registers a keypress event on page load.
        function RegisterKeypressOnLoad() {
            $("#txtSearchTerm").keypress(function (e) {
                if ($("#txtSearchTerm").is(":focus")) {
                    if (e.which == 13) {    //Enter key press.
                        Search();
                        e.preventDefault();
                    }
                }
            });
        }

        //Service request to get active and inactive community count.
        function GetCommunityMembershipCount(supplierId) {
            var param = "/" + supplierId;
            GetResponse("GetSupplierCommunityMembershipCount", param, CommunityMembershipCountSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, assigns values to active and inactive anchor control.
        function CommunityMembershipCountSuccess(response) {
            $("#hlActiveCommunityMembership").text(response.Active);
            $("#hlInactiveCommunityMembership").text(response.Inactive);
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('My Community', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('My Community', response, '#');
        }

        //This method binds static values to distance filter dropdown.
        function BindDistancFilter() {
            $kendoJS("#ddlDistanceFilter").kendoDropDownList({
                dataTextField: "text",
                dataValueField: "value",
                index: 0,
                optionLabel: "Distance Filter",
                suggest: true,
                filter: "contains",
                change: CheckValidation,
                dataSource: [
                    { text: "100", value: "100" },
                    { text: "75", value: "75" },
                    { text: "50", value: "50" },
                    { text: "25", value: "25" },
                    { text: "10", value: "10" }
                ]
            });
        }

        //Service call to fetch community list based on isActive value.
        function BindCommunity(isActive) {
            communityStatus = isActive;
            var param = "/" + $("#hdnSupplierId").val() + "/" + isActive;
            GetResponse("GetCommunityListBySupplier", param, BindCommunitySuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the list to grid.
        function BindCommunitySuccess(response) {

            if (communityStatus == 'active') {
                $kendoJS("#gvCommunityActiveMembership").show();
                $kendoJS("#gvCommunityInactiveMembership").hide();

                var columnSchema = [];
                columnSchema.push({ field: "CommunityName", width: 400, title: "My Active Communities", template: '<a id="#=CommunityID#" class="custom-anchor" href="SupplierCommunityDetail.aspx?cid=#=Encrypted(CommunityID)#">${CommunityName}</a>' });
                columnSchema.push({ field: "Active", width: 120, title: "# Active Groups" });
                columnSchema.push({ field: "Inactive", width: 120, title: "# Inactive Groups" });
                columnSchema.push({ field: "Total", width: 120, title: "Total # Groups" });
                columnSchema.push({ field: "", width: 100, title: "Leave", template: '<a id="#=CommunityID#" class="custom-anchor" onclick="CommunityLeave(this)">Leave</a>' });

                $kendoJS("#gvCommunityActiveMembership").kendoGrid({
                    dataSource: {
                        pageSize: 10,
                        data: response
                    },
                    pageable: true,
                    scrollable: false,
                    columns: columnSchema
                }).data("kendoGrid");
            }
            else {
                $kendoJS("#gvCommunityActiveMembership").hide();
                $kendoJS("#gvCommunityInactiveMembership").show();

                $kendoJS("#gvCommunityInactiveMembership").kendoGrid({
                    dataSource: {
                        pageSize: 10,
                        data: response
                    },
                    pageable: true,
                    scrollable: false,
                    columns: [
                        { field: "CommunityName", width: 400, title: "My Inactive Communities", template: '<a id="#=CommunityID#" class="custom-anchor" href="SupplierCommunityDetail.aspx?cid=#=Encrypted(CommunityID)#">${CommunityName}</a>' },
                        { field: "Active", width: 120, title: "# Active Groups" },
                        { field: "Inactive", width: 120, title: "# Inactive Groups" },
                        { field: "Total", width: 120, title: "Total # Groups" },
                        { field: "", width: 100, title: "Leave", template: '<a id="#=CommunityID#" class="custom-anchor" onclick="CommunityLeave(this)">Leave</a>' }
                    ]
                }).data("kendoGrid");
            }
        }

        //Service call to leave from community.
        function CommunityLeave(data) {
            var param = "/" + $("#hdnSupplierId").val() + "/Supplier/" + data.id;
            GetResponse("CancelSupplierCommunityMembership", param, CancelSupplierSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, calls GetCommunityMembershipCount() & BindCommunity() methods.
        function CancelSupplierSuccess(response) {
            GetCommunityMembershipCount($("#hdnSupplierId").val());
            BindCommunity('active');
        }

        //This method validates community and community group checkboxes.
        function CheckValidation() {
            var isValid = false;
            if (!$("#chkCommunities").is(':checked') && !$("#chkCommunityGroups").is(':checked')) {
                $("#chkCommunities").closest('.form-group').removeClass('has-error').css('color', '#E74C3C');
                $("#chkCommunityGroups").closest('.form-group').removeClass('has-error').css('color', '#E74C3C');
                $("#spanOptionValidation").text('Choose any one option.').css('display', 'block');
                isValid = true;
            }
            else {
                $("#chkCommunities").closest('.form-group').removeClass('has-error').css('color', '#34495E');
                $("#chkCommunityGroups").closest('.form-group').removeClass('has-error').css('color', '#34495E');
                $("#spanOptionValidation").text('').css('display', 'none');
                isValid = false;
            }

            if ($("#chkApplyDistanceFilter").is(':checked')) {

                var distance = (isNullOrEmpty($("#ddlDistanceFilter").val().toString()) == true ? 0 : $("#ddlDistanceFilter").val());

                if (distance == 0) {
                    $("#spanDropDownValidation").text('You can\'t leave distance filter empty.').css('display', 'block');
                    isValid = true;
                }
                else {
                    $("#spanDropDownValidation").text('').css('display', 'none');
                    isValid = false;
                }
            }

            return isValid;
        }

        //Service call to perform search based on filter conditions.
        function Search() {
            var isValid = CheckValidation();

            if (isValid == false) {

                $("#spanOptionValidation").text('').css('display', 'none');
                $("#chkCommunities").closest('.form-group').removeClass('has-error');
                $("#chkCommunityGroups").closest('.form-group').removeClass('has-error');

                var searchTerm = (isNullOrEmpty($("#txtSearchTerm").val().toString()) == true ? "nullstring" : $("#txtSearchTerm").val());
                var distance = (isNullOrEmpty($("#ddlDistanceFilter").val().toString()) == true ? 0 : $("#ddlDistanceFilter").val());
                var unit = (isNullOrEmpty($("#ddlUnits").val().toString()) == true ? 0 : $("#ddlUnits").val());

                // var param = '/' + searchTerm + '/' + distance + '/' + unit + '/' + $("#hdnSupplierId").val();
                var post = '{"Term":"' + encodeURIComponent(searchTerm) + '","Distance":"' + distance + '","DistanceUnit":"' + unit + '","SupplierID":"' + $("#hdnSupplierId").val() + '"}';
                if ($("#chkCommunities").is(':checked')) {
                    $("#result").show();
                    $("#communityDiv").show();
                    // GetResponse("FindCommunityBySupplier", param, SearchCommunitySuccess, Failure, ErrorHandler);
                    PostRequest("FindCommunityBySupplier", post, SearchCommunitySuccess, Failure, ErrorHandler);
                }
                else {
                    $("#communityDiv").hide();

                    if ($("#chkCommunityGroups").is(':checked')) {
                        $("#result").show();
                        $("#communityGroupDiv").show();
                        //  GetResponse("FindCommunityGroupBySupplier", param, SearchCommunityGroupSuccess, Failure, ErrorHandler);
                        PostRequest("FindCommunityGroupBySupplier", post, SearchCommunityGroupSuccess, Failure, ErrorHandler);
                    }
                    else {
                        $("#communityGroupDiv").hide();
                    }
                }

            }
        }

        //On ajax call success, binds the data to community grid.
        function SearchCommunitySuccess(response) {
            $kendoJS("#gvCommunityDetails").kendoGrid({
                dataSource: {
                    pageSize: 10,
                    data: response
                },
                pageable: true,
                scrollable: false,
                columns: [
                    { field: "", width: 350, title: "Community", template: '<a id="#=CommunityID#" class="custom-anchor" href="SupplierCommunityDetail.aspx?cid=#=Encrypted(CommunityID)#">${Name}</a>' },
                    { field: "Description", width: 550, title: "Description", template: '#= htmlEncode(Description) #' }]
            }).data("kendoGrid");

            var searchTerm = (isNullOrEmpty($("#txtSearchTerm").val().toString()) == true ? "nullstring" : $("#txtSearchTerm").val());
            var distance = (isNullOrEmpty($("#ddlDistanceFilter").val().toString()) == true ? 0 : $("#ddlDistanceFilter").val());
            var unit = (isNullOrEmpty($("#ddlUnits").val().toString()) == true ? 0 : $("#ddlUnits").val());

            // var param = '/' + searchTerm + '/' + distance + '/' + unit + '/' + $("#hdnSupplierId").val();
            var post = '{"Term":"' + encodeURIComponent(searchTerm) + '","Distance":"' + distance + '","DistanceUnit":"' + unit + '","SupplierID":"' + $("#hdnSupplierId").val() + '"}';

            if ($("#chkCommunityGroups").is(':checked')) {
                $("#result").show();
                $("#communityGroupDiv").show();
                //  GetResponse("FindCommunityGroupBySupplier", param, SearchCommunityGroupSuccess, Failure, ErrorHandler);
                PostRequest("FindCommunityGroupBySupplier", post, SearchCommunityGroupSuccess, Failure, ErrorHandler);
            }
            else {
                $("#communityGroupDiv").hide();
            }
        }

        //On ajax call success, binds the data to community group grid.
        function SearchCommunityGroupSuccess(response) {

            $kendoJS("#gvCommunityGroupDetails").kendoGrid({
                dataSource: {
                    pageSize: 10,
                    data: response
                },
                pageable: true,
                scrollable: false,
                columns: [
                    { field: "", width: 250, title: "Community", template: '<a id="#=CommunityID#" class="custom-anchor" href="SupplierCommunityDetail.aspx?cid=#=Encrypted(CommunityID)#">${CommunityName}</a>' },
                    { field: "", width: 250, title: "Community Group", template: '<a id="#=CommunityGroupID#" class="custom-anchor" href="SupplierCommunityGroupDetail.aspx?gid=#=Encrypted(CommunityGroupID)#">${Name}</a>' },
                    { field: "Description", width: 400, title: "Description", template: '#= htmlEncode(Description) #' }]
            }).data("kendoGrid");
        }

        //This method disables distance and unit filter dropdown.
        function DisableDropDown() {
            var distanceDropDown = $kendoJS("#ddlDistanceFilter").data("kendoDropDownList");
            distanceDropDown.value(0);
            distanceDropDown.enable(false);

            var unitDropDown = $kendoJS("#ddlUnits").data("kendoDropDownList");
            unitDropDown.value(0);
            unitDropDown.enable(false);
        }

        //This method enables distance and unit filter dropdown.
        function EnableDropDown() {
            var distanceDropDown = $kendoJS("#ddlDistanceFilter").data("kendoDropDownList");
            distanceDropDown.enable();

            var unitDropDown = $kendoJS("#ddlUnits").data("kendoDropDownList");
            unitDropDown.enable();
        }

        //This method enables and disables dropdown based on checkbox condition.
        function ToggleDropDown() {
            if ($("#chkApplyDistanceFilter").is(':checked')) {
                EnableDropDown();
            }
            else {
                DisableDropDown();
                $("#spanDropDownValidation").text('').css('display', 'none');
            }
        }

        //This method enables and disables search textbox.
        function EnableSearchTerm() {
            if ($("#chkApplyTermFilter").is(':checked')) {
                $("#txtSearchTerm").removeAttr('disabled');
            }
            else {
                $("#txtSearchTerm").val('');
                $("#txtSearchTerm").attr('disabled', '');
            }
        }
    </script>
</asp:Content>
<asp:Content ID="conttentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">My Communities</h2>
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <hr />
            <h4>Overview</h4>
            <div class="col-md-4">
                <label class="custom-managemycomm-label-width">Active Community Memberships : </label>
                <a href="#" class="custom-anchor" id="hlActiveCommunityMembership" onclick="BindCommunity('active')"></a>
            </div>
            <div class="col-md-4">
                <label class="custom-managemycomm-label-width">Inactive Community Memberships : </label>
                <a href="#" class="custom-anchor" id="hlInactiveCommunityMembership" onclick="BindCommunity('inactive')"></a>
            </div>
            <div class="col-md-12">
                <div id="gvCommunityActiveMembership"></div>
                <div id="gvCommunityInactiveMembership"></div>
            </div>
        </div>
        <div class="col-md-12">
            <hr />
            <div class="form-horizontal" role="form">
                <h4>Community Search</h4>
                <div class="custom-managemycomm-col-md-2">
                    <div class="form-group custom-managemycomm-form-group-padding">
                        <label for="chkCommunities" class="checkbox custom-checkbox-textalign">
                            <span class="icons"><span class="first-icon fui-checkbox-unchecked"></span><span class="second-icon fui-checkbox-checked"></span></span>
                            <input type="checkbox" value="" id="chkCommunities" data-toggle="checkbox" onchange="CheckValidation()" />
                            Communities
                        </label>
                    </div>
                </div>
                <div class="custom-managemycomm-col-md-2">
                    <div class="form-group custom-managemycomm-form-group-padding">
                        <label for="chkCommunityGroups" class="checkbox custom-checkbox-textalign">
                            <span class="icons"><span class="first-icon fui-checkbox-unchecked"></span><span class="second-icon fui-checkbox-checked"></span></span>
                            <input type="checkbox" value="" id="chkCommunityGroups" data-toggle="checkbox" onchange="CheckValidation()" />
                            Community Groups
                        </label>
                    </div>
                </div>
                <div class="col-md-6">
                    <span id="spanOptionValidation" class="custom-managemycomm-validation" style="margin-left: 0px;"></span>
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="form-horizontal" role="form">
                <div class="custom-managemycomm-col-md-2">
                    <div class="form-group custom-managemycomm-form-group-padding">
                        <label for="chkApplyDistanceFilter" class="checkbox custom-checkbox-textalign">
                            <span class="icons"><span class="first-icon fui-checkbox-unchecked"></span><span class="second-icon fui-checkbox-checked"></span></span>
                            <input type="checkbox" value="" id="chkApplyDistanceFilter" data-toggle="checkbox" onchange="ToggleDropDown()" />
                            Apply distance filter
                        </label>
                    </div>
                </div>
                <div class="custom-managemycomm-col-md-2">
                    <label>Communities within</label>
                </div>
                <div class="custom-managemycomm-col-md-3">
                    <div id="ddlDistanceFilter" class="custom-dropdown-width"></div>
                </div>
                <div class="custom-managemycomm-col-md-3">
                    <div id="ddlUnits" class="custom-dropdown-width"></div>
                </div>
                <div class="col-md-1"></div>
                <div class="col-md-12">
                    <div class="col-md-4"></div>
                    <div class="col-md-4">
                        <span id="spanDropDownValidation" class="custom-managemycomm-validation"></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="form-horizontal" role="form">
                <div class="custom-managemycomm-col-md-2">
                    <div class="form-group custom-managemycomm-form-group-padding">
                        <label for="chkApplyTermFilter" class="checkbox custom-checkbox-textalign">
                            <span class="icons"><span class="first-icon fui-checkbox-unchecked"></span><span class="second-icon fui-checkbox-checked"></span></span>
                            <input type="checkbox" value="" id="chkApplyTermFilter" data-toggle="checkbox" onchange="EnableSearchTerm()" />
                            Apply term filter
                        </label>
                    </div>
                </div>
                <div class="custom-managemycomm-col-md-2">
                    <label>Communities about</label>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtSearchTerm" name="txtSearchTerm" placeholder="Search Term" class="form-control" maxlength="50" />
                </div>
                <div class="col-md-2">
                    <input type="button" id="btnFind" name="btnFind" value="Find" class="btn btn-wide btn-primary" onclick="Search()" />
                </div>
            </div>
        </div>
        <div class="col-md-12" id="result">
            <hr />
            <div class="form-horizontal" role="form">
                <h4>Results</h4>
                <div id="communityDiv">
                    <h4>Community</h4>
                    <div id="gvCommunityDetails"></div>
                </div>
                <div id="communityGroupDiv">
                    <h4>Community Group</h4>
                    <div id="gvCommunityGroupDetails"></div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
