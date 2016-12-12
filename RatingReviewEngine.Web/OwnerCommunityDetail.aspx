<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="OwnerCommunityDetail.aspx.cs" Inherits="RatingReviewEngine.Web.OwnerCommunityDetail" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <%--<link rel="Stylesheet" type="text/css" href="http://ajax.microsoft.com/ajax/jquery.ui/1.8.5/themes/dark-hive/jquery-ui.css" />--%>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&libraries=drawing"></script>

    <link rel="stylesheet" type="text/css" href="css/jquery-gmaps-latlon-picker.css" />
    <script src="js/jquery-gmaps-latlon-picker.js"></script>

    <style>
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

        #tbody, tr {
            line-height: 1.42857;
            vertical-align: top;
            font-size: 15px;
        }

        .mapDisable {
            z-index: -1;
        }

        body {
            font-size: 14px !important;
        }

        .k-pager-numbers .k-link {
            line-height: 2.28em !important;
        }
    </style>

    <script type="text/javascript">
        var isValid = false;
        var active = 1;

        $(document).ready(function () {
            if (GetQueryStringParams('cid') == null)
            {
                ErrorWindow('Community Detail', "No data found", 'Nodata.aspx');
                return;
            }
            ControlValidation();
            ButtonClickEventOnLoad();
            GetCommunityDetail();

            BindActive();
            BindMenu();
            SetValueToHiddenFieldOnLoad();
            OnBlurEventOnLoad();
            $("#mapEdit").hide();
        });

        //JQuery validation for controls.
        function ControlValidation() {
            $("#frmRatingReviewEngine").validate({
                event: "custom",
                rules: {
                    txtAreaRadius: { required: true }
                },
                messages: {
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
            $("#btnManageFee").click(function () {
                window.location = "/CommunityFeeManagement.aspx?cid=" + Encrypted(GetQueryStringParams('cid'));
            });

            $("#btnManageReward").click(function () {
                window.location = "/CommunityRewardManagement.aspx?cid=" + Encrypted(GetQueryStringParams('cid'));
            });
        }

        //Service call to fetch community details.
        function GetCommunityDetail() {
            var param = '/' + $("#hdnCommunityOwnerId").val() + '/' + GetQueryStringParams('cid');
            GetResponse("GetCommunityByIDAndOwner", param, GetCommunitySuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the data to the corresponding controls.
        function GetCommunitySuccess(response) {
            if (response.CommunityID == 0) {
                //ErrorWindow('Community Detail', 'Unauthorized access', 'unauthorized.aspx');
                window.location = 'nodata.aspx';
                return;
            }
            $("#hdfCommunityID").val(response.CommunityID);
            $("#lblCommunityName").text(response.Name);
            $("#lblDescription").text(response.Description);
            $("#lblActive").text(response.Active.toString() == "true" ? "Active" : "Inactive");

            if (response.Active.toString() == "true")
                $("#lblActive").css('color', '#1abc9c');
            else
                $("#lblActive").css('color', '#d9534f');

            $("#hdftLatitude").val(response.CentreLatitude);
            $("#hdfLongitude").val(response.CentreLongitude);

            $("#txtLatitude").val(response.CentreLatitude);
            $("#txtLongitude").val(response.CentreLongitude);
            $("#txtDescription").val(response.Description);
            $("#txtAreaRadius").val(response.AreaRadius);
            $("#hdfAreaRadius").val(response.AreaRadius);
            $("#hdfCurrency").val(response.CurrencyId);
            $("#hdfCountry").val(response.CountryID);
            $("#hdfAutoTransferAmtOwner").val(response.AutoTransferAmtOwner);
            $kendoJS("#ddlActive").data("kendoDropDownList").value(response.Active);
            $('.gllpUpdateButton').click();
            MapApiLoaded();

            GetCommunitySummaryDetail();
            GetCommunityGroupSummary('true');
        }

        //Loads google map.
        function MapApiLoaded() {
            // Create google map

            $('.gllpMap1').each(function () {

                var lat = $("#hdftLatitude").val();
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


                // Trigger resize to correctly display the map
                google.maps.event.trigger(map, "resize");

                // Add circle overlay and bind to marker
                var circle = new google.maps.Circle({
                    map: map,
                    radius: parseFloat($("#hdfAreaRadius").val() * 1000),    //  metres
                    fillColor: '#AA0000'
                });

                circle.bindTo('center', marker, 'position');

                // Map loaded trigger
                google.maps.event.addListenerOnce(map, 'idle', function () {
                    // Fire when map tiles are completly loaded
                });
            });
        }

        //Service call to fetch community summary details.
        function GetCommunitySummaryDetail() {
            var param = '/' + $("#hdfCommunityID").val();
            GetResponse("GetCommunitySummary", param, GetCommunitySummarySuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the data to the corresponding controls.
        function GetCommunitySummarySuccess(response) {
            $("#lblGroupNo").text(response.CommunityGroupCount);
            $("#hlCreditSupplierNo").text(response.InCreditSuppliersCount);
            $("#hlOutCreditSupplierNo").text(response.OutofCreditSuppliersCount);
            $("#hlBelowCreditSupplierNo").text(response.BelowMinCreditSuppliersCount);
            $("#hlCustomerNo").text(response.CustomersCount);
            $("#lblRevenue").text("(" + response.CurrencyName + ") " + ((response.CurrentRevenue == null || response.CurrentRevenue == 0) ? "0.00" : (response.CurrentRevenue).toFixed(2)));
        }

        //Service call to fetch community group summary details.
        function GetCommunityGroupSummary(data) {
            active = (data == 'true' ? 1 : 0);
            var param = '/' + $("#hdfCommunityID").val() + "/" + data;
            GetResponse("GetCommunityGroupSummaryByCommunity", param, GetCommunityGroupSummarySuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the data to the grid.
        function GetCommunityGroupSummarySuccess(response) {
            var cid = GetQueryStringParams('cid');
            $kendoJS("#gvCommunityGroupSummary").kendoGrid({
                dataSource: {
                    pageSize: 10,
                    data: response
                },
                pageable: true,
                scrollable: false,
                columns: [
                    { field: "Name", width: 350, title: "Community Group", template: '<a id="#=CommunityGroupID#" href="OwnerCommunityGroupDetail.aspx?cid=' + Encrypted(cid) + '&gid=#=Encrypted(CommunityGroupID)#" class="custom-anchor" >${Name}</a>' },
                    { field: "InCreditSuppliersCount", width: 90, title: "# In Credit Suppliers", template: '<a id="#=CommunityGroupID#" class="custom-anchor" href="SupplierManagement.aspx?cid=' + Encrypted(cid) + '&gid=#=Encrypted(CommunityGroupID)#&cat=' + Encrypted(1) + '">${InCreditSuppliersCount}</a>' },
                    { field: "OutofCreditSuppliersCount", width: 105, title: "# Out of Credit Suppliers", template: '<a id="#=CommunityGroupID#" class="custom-anchor" href="SupplierManagement.aspx?cid=' + Encrypted(cid) + '&gid=#=Encrypted(CommunityGroupID)#&cat=' + Encrypted(2) + '">${OutofCreditSuppliersCount}</a>' },
                    { field: "BelowMinCreditSuppliersCount", width: 107, title: "# Below Min Credit Suppliers", template: '<a id="#=CommunityGroupID#" class="custom-anchor" href="SupplierManagement.aspx?cid=' + Encrypted(cid) + '&gid=#=Encrypted(CommunityGroupID)#&cat=' + Encrypted(3) + '">${BelowMinCreditSuppliersCount}</a>' },
                    { field: "CustomersCount", width: 110, title: "# Customers", template: '<a id="#=CommunityGroupID#" class="custom-anchor" href="CustomerManagement.aspx?cid=' + Encrypted(cid) + '&gid=#=Encrypted(CommunityGroupID)#">${CustomersCount}</a>' },
                    { field: "CurrentRevenue", width: 150, title: "Total Revenue", template: '<span id=${CurrencyID}>(${CurrencyName}) #=(CurrentRevenue).toFixed(2)#</span>' }]
            }).data("kendoGrid");

            if (active == 1)
                $("#gvCommunityGroupSummary th[data-field=Name]").html("Active Community Group");
            else
                $("#gvCommunityGroupSummary th[data-field=Name]").html("Inactive Community Group");
        }

        //This method sets the values to hidden fields on page load.
        function SetValueToHiddenFieldOnLoad() {
            $("#hlCreditSupplierNo").attr('href', 'SupplierManagement.aspx?cid=' + Encrypted(GetQueryStringParams('cid')) + '&cat=' + Encrypted(1) + '');
            $("#hlOutCreditSupplierNo").attr('href', 'SupplierManagement.aspx?cid=' + Encrypted(GetQueryStringParams('cid')) + '&cat=' + Encrypted(2) + '');
            $("#hlBelowCreditSupplierNo").attr('href', 'SupplierManagement.aspx?cid=' + Encrypted(GetQueryStringParams('cid')) + '&cat=' + Encrypted(3) + '');
            $("#hlCustomerNo").attr('href', 'CustomerManagement.aspx?cid=' + Encrypted(GetQueryStringParams('cid')));
            $("#lblRevenue").attr('href', 'CommunityOwnerAccount.aspx?cid=' + Encrypted(GetQueryStringParams('cid')));
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

        //This method bind active dropdown on load.
        function BindActive() {
            $kendoJS("#ddlActive").kendoDropDownList({
                dataTextField: "text",
                dataValueField: "value",
                index: 0,
                suggest: true,
                filter: "contains",
                dataSource: [
                    { text: "Active", value: "true" },
                    { text: "Inactive", value: "false" }
                ]
            });
        }

        //Service call to fetch menu information.
        function BindMenu() {
            var param = '/' + $("#hdnCommunityOwnerId").val();
            GetResponse("GetOwnerCommunityMenu", param, BindMenuSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, bind the menu from the list obtained.
        function BindMenuSuccess(response) {

            var menuDataSource = new kendo.data.DataSource({
                data: response
            })

            menuDataSource.read();
            var menuCount = menuDataSource.total();
            for (var i = 0; i < menuCount; i++) {
                if (GetQueryStringParams('cid') == response[i].id) {
                    $("#SubTitle").text(response[i].text);
                    break;
                }
            }

            $("#menuHeader").text('Communities').append('<b class="caret"></b>');
            $("#DynamicMenu").removeClass('custom-hide').addClass('custom-visible');

            $kendoJS("#menu").kendoMenu({
                dataSource: response
            });

            $("#menu").removeClass('k-widget k-reset k-header k-menu k-menu-horizontal');
            $("#menu .k-link").each(function () {
                $(this).removeAttr('class');
                $(this).addClass('custom-menu-anchor');
            });
        }

        //This method checks form validation and calls UpdateCommunityDetail() method.
        function UpdateCommunity() {
            if ($("#frmRatingReviewEngine").valid() && !isValid && !LatitudeLongitudeValidation()) {
                UpdateCommunityDetail();
            }
        }

        //Service call to update community details.
        function UpdateCommunityDetail() {
            var postData = '{"CommunityID":"' + $("#hdfCommunityID").val() + '","Name":"' + encodeURIComponent($.trim($("#lblCommunityName").text())) + '","Description":"' + encodeURIComponent($.trim($("#txtDescription").val()))
                + '","CurrencyId":"' + $("#hdfCurrency").val() + '","CountryID":"' + $("#hdfCountry").val() + '","CentreLongitude":"' + $("#txtLongitude").val()
                + '","CentreLatitude":"' + $("#txtLatitude").val() + '","AreaRadius":"' + $("#txtAreaRadius").val() + '","Active":"' + $("#ddlActive").val() + '"}';

            PostRequest("UpdateCommunity", postData, UpdateCommunitySuccess, Failure, ErrorHandler);
        }

        //On ajax call success, calls GetCommunityDetail() and HideEdit() methods.
        function UpdateCommunitySuccess() {
            GetCommunityDetail();
            HideEdit();
            SuccessWindow('Community Detail', "Updated successfully.", '#');
        }

        //This method redirects to new community group page.
        function NewCommunity() {
            window.location = "NewCommunityGroup.aspx?cid=" + Encrypted(GetQueryStringParams('cid')) + "&cuid=" + Encrypted($("#hdfCurrency").val());
        }

        //This method displays the controls in edit mode.
        function ShowEdit() {
            $("#txtDescription").val($("#lblDescription").text());
            $("#txtAreaRadius").val($("#hdfAreaRadius").val());

            $kendoJS("#ddlActive").data("kendoDropDownList").text($("#lblActive").text());
            $("#divLabel").hide();
            $("#divEdit").show();
            $("#divMapSearch").show();
            $("#divMapLatLon").show();
            $("#divMapUpdate").show();
            //$("#gllpMap").removeAttr("class");
            // $("#gllpMap").attr("class", "gllpMap");
            $("#divBtnSave").show();
            $("#divBtnEdit").hide();

            $("#mapView").hide();
            $("#mapEdit").show();

            google.maps.event.trigger($(".gllpMap")[0], 'resize');
            $('.gllpSearchField').val('');
            $('.gllpUpdateButton').click();
        }

        //This method hides the controls in edit mode.
        function HideEdit() {
            $("#divLabel").show();
            $("#divEdit").hide();
            $("#divMapSearch").hide();
            $("#divMapLatLon").hide();
            $("#divMapUpdate").hide();
            // $("#gllpMap").attr("class", "gllpMap mapDisable");
            $("#divBtnSave").hide();
            $("#divBtnEdit").show();

            $("#txtLatitude").closest('.form-group').removeClass('has-error');
            $("#txtLongitude").closest('.form-group').removeClass('has-error');
            $("#latitudeVadiation").removeClass("custom-supplierdashboard-email-validation-on").addClass("custom-supplierdashboard-email-validation-off");
            $("#longitudeVadiation").removeClass("custom-supplierdashboard-email-validation-on").addClass("custom-supplierdashboard-email-validation-off");

            $("#txtLongitude").val($("#hdfLongitude").val());
            $("#txtLatitude").val($("#hdftLatitude").val());
            $('.gllpSearchField').val('');
            $('.gllpUpdateButton').click();
            $("#mapView").show();
            $("#mapEdit").hide();


            ClearValidation();
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Community Detail', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Community Detail', response, '#');
        }

        //This method validated latitude and longitude fields for empty and decimal.
        function LatitudeLongitudeValidation() {
            var latIsValid = false;
            if ($("#txtLatitude").val() == "") {
                $("#txtLatitude").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#latitudeVadiation").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                latIsValid = true;
            }
            else {
                if (DecimalValidation($("#txtLatitude").val())) {
                    $("#latitudeVadiation").text('').css('display', 'none');
                    $("#txtLatitude").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                    latIsValid = false;
                }
                else {

                    $("#txtLatitude").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                    $("#latitudeVadiation").text('Please enter a valid latitude value.').css('display', 'block').css('color', '#E74C3C');
                    latIsValid = true;
                }
            }

            var longIsValid = false;
            if ($("#txtLongitude").val() == "") {
                $("#txtLongitude").closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#longitudeVadiation").text('You can\'t leave this empty.').removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on").css('display', 'block');
                longIsValid = true;
            }
            else {
                if (DecimalValidation($("#txtLongitude").val())) {
                    $("#longitudeVadiation").text('').css('display', 'none');
                    $("#txtLongitude").closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                    longIsValid = false;
                }
                else {

                    $("#txtLongitude").closest('.form-group').addClass('form-group has-error').css('text-align', 'left');
                    $("#longitudeVadiation").text('Please enter a valid longitude value.').css('display', 'block').css('color', '#E74C3C');
                    longIsValid = true;
                }
            }

            if (latIsValid || longIsValid)
                return true;
            else
                return false;
        }
    </script>

</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Community Detail</h2>
    <div class="row">
        <div class="col-md-12">
            <h4 id="SubTitle"></h4>
            <hr />
        </div>
        <div class="col-md-12">
            <div class="col-md-4">
                <div class="form-horizontal" role="form">
                    <div class="form-group" style="display: none;">
                        <label id="lblCommunityName">CommunityName</label>
                        <input type="hidden" id="hdfCommunityID" />
                        <input type="hidden" id="hdfAreaRadius" />
                        <input type="hidden" id="hdfCurrency" />
                        <input type="hidden" id="hdfCountry" />
                        <input type="hidden" id="hdfAutoTransferAmtOwner" />
                    </div>
                    <div id="divLabel" class="form-group">
                        <div>
                            <label id="lblDescription">Description</label>
                        </div>
                        <div>
                            <label id="lblActive">Active</label>
                        </div>
                    </div>
                    <div id="divEdit" style="display: none;">
                        <div class="form-group">
                            <div>
                                <label class="custom-field-label-fontstyle" style="float: none;">Description</label>
                            </div>
                            <input type="text" id="txtDescription" class="form-control custom-ownercomdetail-textbox-width" name="txtDescription" placeholder="Description" maxlength="200" />
                        </div>
                        <div class="form-group">
                            <div>
                                <label class="custom-field-label-fontstyle" style="float: none;">Approximate Area Radius (Km)</label>
                            </div>
                            <input type="text" id="txtAreaRadius" name="txtAreaRadius" class="form-control custom-ownercomdetail-textbox-width" placeholder="Approximate Area Radius" maxlength="10" />
                            <span id="spanAreaRadius" class="custom-register-email-span"></span>
                        </div>
                        <div class="form-group">
                            <div id="ddlActive" class="custom-ownercomdetail-dropdown-width"></div>
                        </div>
                    </div>
                </div>
                <div class="form-horizontal" role="form">
                    <h4 class="form-group">Statistics</h4>
                    <div class="form-group">
                        <div class="custom-ownercomdetail-col-md-8">
                            <label># Community Groups:</label>
                        </div>
                        <div class="custom-ownercomdetail-col-md-4">
                            <label id="lblGroupNo"></label>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="custom-ownercomdetail-col-md-8">
                            <label># In Credit Suppliers:</label>
                        </div>
                        <div class="custom-ownercomdetail-col-md-4">
                            <a class="custom-anchor custom-ownercomdetail-anchor-lineheight" id="hlCreditSupplierNo"></a>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="custom-ownercomdetail-col-md-8">
                            <label># Out of Credit Suppliers:</label>
                        </div>
                        <div class="custom-ownercomdetail-col-md-4">
                            <a class="custom-anchor custom-ownercomdetail-anchor-lineheight" id="hlOutCreditSupplierNo"></a>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="custom-ownercomdetail-col-md-8">
                            <label># Below Min Credit Suppliers:</label>
                        </div>
                        <div class="custom-ownercomdetail-col-md-4">
                            <a class="custom-anchor custom-ownercomdetail-anchor-lineheight" id="hlBelowCreditSupplierNo"></a>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="custom-ownercomdetail-col-md-8">
                            <label># Customers:</label>
                        </div>
                        <div class="custom-ownercomdetail-col-md-4">
                            <a class="custom-anchor custom-ownercomdetail-anchor-lineheight" id="hlCustomerNo"></a>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="custom-ownercomdetail-col-md-8">
                            <label>Current Revenue:</label>
                        </div>
                        <div class="custom-ownercomdetail-col-md-4">
                            <a class="custom-anchor custom-ownercomdetail-anchor-lineheight" id="lblRevenue"></a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div id="mapView">
                    <fieldset class="gllpLatlonPicker1">
                        <div class="gllpMap1" style="height: 250px !important;">Google Maps</div>
                    </fieldset>
                </div>
                <div id="mapEdit">
                    <fieldset class="gllpLatlonPicker">
                        <div class="form-group" id="divMapSearch" style="display: none;">
                            <input type="text" class="gllpSearchField form-control custom-newcommunity-search-textbox" placeholder="Search" style="margin-left: 0px !important;" />
                            <input type="button" class="gllpSearchButton btn btn-primary custom-newcommunity-search-button" value="Search by Location" />
                        </div>
                        <br />
                        <br />
                        <div class="gllpMap" id="gllpMap">Google Maps</div>
                        <br />
                        <div id="divMapLatLon" style="display: none; margin-left: -13px;">
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
                            <span id="latitudeVadiation" class="custom-supplierdashboard-email-validation-off">You can't leave this empty.</span>
                        </div>
                        <div class="col-md-6" style="margin-left: -5px;">
                            <span id="longitudeVadiation" class="custom-supplierdashboard-email-validation-off">You can't leave this empty.</span>
                        </div>
                        <div class="custom-comownerdash-updatemap-button" id="divMapUpdate" style="display: none">
                            <input type="button" class="gllpUpdateButton btn btn-primary" value="Search by Co-ordinate" onclick="LatitudeLongitudeValidation()" />
                        </div>
                        <div style="display: none;">
                            zoom:
                            <input type="text" class="gllpZoom" value="5" />
                            <input type="text" class="gllpLocationName form-control custom-regsupplier-location-textbox" placeholder="Longitude" />
                        </div>
                    </fieldset>
                </div>
            </div>
            <div class="col-md-2">
                <div id="divBtnEdit">
                    <input type="button" id="btnEdit" value="Edit" class="btn btn-block btn-lg btn-primary custom-comownerdash-button-rightalign" onclick="ShowEdit()" />
                </div>
                <div id="divBtnSave" style="display: none; margin-left: 23%;">
                    <input id="btnSave" type="button" value="Save" class="btn btn-block btn-lg btn-info custom-comownerdash-button-rightalign" onclick="UpdateCommunity()" />
                    <input id="btnCancel" type="button" value="Cancel" class="btn btn-block btn-lg btn-default custom-comownerdash-button-rightalign" onclick="HideEdit()" />
                </div>
            </div>
            <div class="col-md-8 pull-right custom-default-top-margin">
                <div class="col-md-6 pull-right">
                    <input type="button" id="btnManageFee" value="Manage Fee Structures" class="btn btn-block btn-lg btn-primary custom-comownerdash-managebutton-rightalign" />
                </div>
            </div>
            <div class="col-md-8 pull-right custom-default-top-margin">
                <div class="col-md-6 pull-right">
                    <input type="button" id="btnManageReward" value="Manage Reward Structures" class="btn btn-block btn-lg btn-primary custom-comownerdash-managebutton-rightalign" />
                </div>
            </div>
        </div>
        <div class="form-horizontal col-md-12" role="form">
            <hr />
            <a href="#" class="custom-anchor" style="font-size: 16px !important; float: left;" id="hlActiveCommunity" onclick="GetCommunityGroupSummary('true')">Active Community Groups</a>
            <div class="col-md-2"></div>
            <a href="#" class="custom-anchor" style="font-size: 16px !important" id="hlInactiveCommunity" onclick="GetCommunityGroupSummary('false')">Inactive Community Groups</a>
        </div>
        <div class="col-md-12">
            <div id="gvCommunityGroupSummary"></div>
            <div class="col-md-12" style="padding: 15px 0px 0px 0px;">
                <a href="#" class="custom-anchor" onclick="NewCommunity()">New Community Group</a>
            </div>
        </div>
    </div>
</asp:Content>
