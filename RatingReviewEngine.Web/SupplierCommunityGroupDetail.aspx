<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="SupplierCommunityGroupDetail.aspx.cs" Inherits="RatingReviewEngine.Web.SupplierCommunityGroupDetail" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>

<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <%--<link rel="Stylesheet" type="text/css" href="http://ajax.microsoft.com/ajax/jquery.ui/1.8.5/themes/dark-hive/jquery-ui.css" />--%>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&libraries=drawing"></script>

    <%-- <link rel="stylesheet" type="text/css" href="css/jquery-gmaps-latlon-picker.css" />
    <script src="js/jquery-gmaps-latlon-picker.js"></script>--%>

    <style>
        .k-widget {
            border-style: none !important;
            box-shadow: none !important;
        }

        .mapDisable {
            z-index: -1;
            height: 170px !important;
            width: 170px !important;
        }

        .rotatedtext {
            -webkit-transform: rotate(90deg);
            -moz-transform: rotate(90deg);
            -ms-transform: rotate(90deg);
            -o-transform: rotate(90deg);
            transform: rotate(90deg);
        }

        .rotatedtextanticlock {
            -webkit-transform: rotate(-90deg);
            -moz-transform: rotate(-90deg);
            -ms-transform: rotate(-90deg);
            -o-transform: rotate(-90deg);
            transform: rotate(-90deg);
        }

        span {
            font-size: 15px;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            if (GetQueryStringParams('gid') == null) {
                ErrorWindow('Community Group Detail', "No data found", 'Nodata.aspx');
                return;
            }
            HideLabels();
            GetCommunityGroupDetail();
            BindCommunityGroupDetail();
            BindMenu();
        });

        //This method hides attach and detach labels initially.
        function HideLabels() {
            $("#lblAttachCommunity").hide();
            $("#lblDetachCommunity").hide();
        }

        //Gets community group details based on community group id from query string.
        function GetCommunityGroupDetail() {
            var param = '/' + GetQueryStringParams('gid');
            GetResponse("GetCommunityGroup", param, GetCommunityGroupDetailSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the data to the corresponding fields.
        function GetCommunityGroupDetailSuccess(response) {
            if (response.CommunityID == 0) {
                window.location = 'nodata.aspx';
                return;
            }
            $("#hdnCommunityGroupName").val(response.Name);
            $("#SubTitle").text($("#hdnCommunityGroupName").val());
            $("#hdnCommunityID").val(response.CommunityID);
            $("#hdnCommunityGroupID").val(response.CommunityGroupID);

            $("#lblAttachCommunity").text('Attach to ' + $("#hdnCommunityGroupName").val());
            $("#lblDetachCommunity").text('Detach from ' + $("#hdnCommunityGroupName").val());
        }

        //Gets rating and review details based on community group id and supplier id.
        function BindCommunityGroupDetail() {
            var param = '/' + GetQueryStringParams('gid') + '/' + $("#hdnSupplierId").val();
            GetResponse("GetCommunityGroupDetailBySupplier", param, GetCommunityGroupSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the data to the corresponding fields and listview.
        function GetCommunityGroupSuccess(response) {
            $("#lblSupplierCount").text(response.SupplierCount);
            $("#lblHigher").text(response.HigherRatingSupplier);
            $("#lblSame").text(response.EqualRatingSupplier);
            $("#lblLower").text(response.LowerRatingSupplier);
            $("#lblAverageRating").text((response.CommunityGroupRating).toFixed(1) + ' Stars');

            if (response.SupplierRating < response.CommunityGroupRating) {
                $("#spanHandLeft").hide();
                $("#spanHandRight").removeClass("rotatedtextanticlock");
            }
            else if (response.SupplierRating > response.CommunityGroupRating) {
                $("#spanHandLeft").removeClass("rotatedtextanticlock");
                $("#spanHandRight").hide();
            }

            if (response.IsMember == "1") {
                $("#lblAttachCommunity").hide();
                $("#lblDetachCommunity").show();

                $("#divHigherStar").show();
                $("#divSameStar").show();
                $("#divLowerStar").show();
            }
            else {
                $("#lblDetachCommunity").hide();
                $("#lblAttachCommunity").show();

                $("#divHigherStar").hide();
                $("#divSameStar").hide();
                $("#divLowerStar").hide();
            }

            $kendoJS("#lsvSupplierDetails").kendoListView({
                dataSource: response.lstCommunityGroupDetailChild,
                template: kendo.template($("#supplierTemplate").html())
            });

            MapApiLoaded();
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Community Group Detail', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Community Group Detail', response, '#');
        }

        //Gets list of community groups to bind the menu based on supplier id.
        function BindMenu() {
            var param = '/' + $("#hdnSupplierId").val();
            GetResponse("GetCommunityGroupListActiveBySupplier", param, BindMenuSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the menu.
        function BindMenuSuccess(response) {
            var menuDataSource = new kendo.data.DataSource({
                data: response
            })

            menuDataSource.read();
            var menuCount = menuDataSource.total();
            for (var i = 0; i < menuCount; i++) {
                if (GetQueryStringParams('gid') == response[i].id) {
                    $("#SubTitle").text(response[i].text);
                    break;
                }
            }

            if (menuCount > 0) {
                $("#menuHeader").text('Community Groups').append('<b class="caret"></b>');
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
        }

        //Service request to join a supplier to community group.
        function CommunityGroupJoin() {
            var postData = '{"SupplierID": "' + $("#hdnSupplierId").val() + '", "CommunityID": "' + $("#hdnCommunityID").val() + '", "CommunityGroupID": "' + $("#hdnCommunityGroupID").val() + '"}';
            PostRequest("SupplierJoinCommunityGroup", postData, CommunityGroupJoinSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, displays success message in popup and calls BindCommunityGroupDetail() & BindMenu() methods.
        function CommunityGroupJoinSuccess(response) {
            SuccessWindow('Community Group Detail', 'You have joined this community group.', '#');
            BindCommunityGroupDetail();
            BindMenu();
        }

        //This method displays a confirmation popup for leaving community group.
        function CommunityGroupLeave() {
            BootstrapDialog.show({
                title: 'Leave Community Group',
                message: 'Do you want to leave this community group?',
                buttons: [{
                    label: 'Yes',
                    cssClass: 'btn-info',
                    action: function (dialog) {
                        var postData = '{"SupplierID": "' + $("#hdnSupplierId").val() + '", "CommunityID": "' + $("#hdnCommunityID").val() + '", "CommunityGroupID": "' + $("#hdnCommunityGroupID").val() + '"}';
                        PostRequest("SupplierLeaveCommunityGroup", postData, CommunityGroupLeaveSuccess, Failure, ErrorHandler);

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

        //On ajax call success, displays success message in popup and calls  BindCommunityGroupDetail(), BindMenu() & BindSuppliers() methods.
        function CommunityGroupLeaveSuccess(response) {
            $("#lblDetachCommunity").hide();
            $("#lblAttachCommunity").show();

            BindCommunityGroupDetail();
            BindMenu();
            BindSuppliers('none');
            SuccessWindow('Community Group Detail', 'You have left this community group.', '#');
        }

        //This method naviagtes to supplier review page.
        function OpenSupplierReview(data) {
            var supplierId = data.id;
            window.location = "SupplierReviews.aspx?cid=" + Encrypted($("#hdnCommunityID").val()) + "&gid=" + Encrypted($("#hdnCommunityGroupID").val()) + "&sid=" + Encrypted(supplierId);
        }

        //This method set the header text based on rating type.
        function BindSuppliers(ratingType) {
            var param = "/" + $("#hdnCommunityGroupID").val() + "/" + $("#hdnSupplierId").val() + "/" + ratingType;
            GetResponse("GetCommunityGroupReviewListBySupplierRating", param, BindSuppliersSuccess, Failure, ErrorHandler);

            if (ratingType == 'high') {
                $("#lblHeader").text('Suppliers with Higher Star Rating');
            }
            else if (ratingType == 'equal') {
                $("#lblHeader").text('Suppliers with Same Star Rating');
            }
            else if (ratingType == 'low') {
                $("#lblHeader").text('Suppliers with Lower Star Rating');
            }
            else if (ratingType == 'none') {
                $("#lblHeader").text('All Suppliers');
            }

            //$.ajax({
            //    url: "http://maps.googleapis.com/maps/api/js?sensor=false&callback=MapApiLoaded",
            //    dataType: "script",
            //    timeout: 8000,
            //    error: function () {
            //        // Handle error here
            //    }
            //});
        }

        //On ajax call success, binds the data to listview.
        function BindSuppliersSuccess(response) {
            $kendoJS("#lsvSupplierDetails").kendoListView({
                dataSource: response,
                template: kendo.template($("#supplierTemplate").html())
            });

            MapApiLoaded();
        }

        //This method binds the latitude & longitude sets loction.
        function MapApiLoaded() {
            // Create google map
            //for (var i = 0; i < $('.gllpMap').length; i++)

            $('.gllpMap').each(function () {
                //var div = $('.gllpMap')[i];
                var lat = $(this).siblings('div').find('input')[0].value;
                var log = $(this).siblings('div').find('input')[1].value;
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
                    map: map
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
    </script>
</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <input type="hidden" id="hdnCommunityID" />
    <input type="hidden" id="hdnCommunityGroupID" />
    <input type="hidden" id="hdnCommunityGroupName" />
    <h2 class="h2">Community Group Detail</h2>
    <div class="row">
        <div class="col-md-12">
            <div class="form-horizontal" role="form">
                <h4 id="SubTitle"></h4>
                <hr />
                <div class="col-md-12">
                    <div class="custom-suppcommgroupdetail-col-md-4">
                        <label>Total Suppliers :</label>
                    </div>
                    <div class="col-md-1"><a class="custom-anchor" id="lblSupplierCount" onclick="BindSuppliers('none')"></a></div>
                    <div class="col-md-4 pull-right">
                        <div class="custom-suppcommgroupdetail-div-text">
                            <label class="custom-suppcommgroupdetail-label">Average Rating :</label><span id="lblAverageRating" class="custom-communitydetail-label-fontstyle"></span>&nbsp;&nbsp;<span id="spanHandRight" class="glyphicon glyphicon-thumbs-down rotatedtextanticlock"></span>&nbsp;<span id="spanHandLeft" class="glyphicon glyphicon-thumbs-up rotatedtextanticlock"></span>
                        </div>
                    </div>
                </div>
                <div class="col-md-12" id="divHigherStar">
                    <div class="custom-suppcommgroupdetail-col-md-4">
                        <label>Total Suppliers with Higher Star Rating :</label>
                    </div>
                    <div class="col-md-1"><a class="custom-anchor" id="lblHigher" onclick="BindSuppliers('high')"></a></div>
                </div>
                <div class="col-md-12" id="divSameStar">
                    <div class="custom-suppcommgroupdetail-col-md-4">
                        <label>Total Suppliers with Same Star Rating :</label>
                    </div>
                    <div class="col-md-1"><a class="custom-anchor" id="lblSame" onclick="BindSuppliers('equal')"></a></div>
                </div>
                <div class="col-md-8" id="divLowerStar">
                    <div class="custom-suppcommgroupdetail-col-md-5">
                        <label>Total Suppliers with Lower Star Rating :</label>
                    </div>
                    <div class="col-md-1"><a class="custom-anchor" id="lblLower" onclick="BindSuppliers('low')"></a></div>
                </div>
                <div class="col-md-12 pull-right">
                    <div class="custom-suppcommgroupdetail-div-text">
                        <a class="custom-suppcommgroupdetail-anchor-bold" id="lblAttachCommunity" onclick="CommunityGroupJoin()">Attach to Community Group</a><a class="custom-suppcommgroupdetail-anchor-bold" id="lblDetachCommunity" onclick="CommunityGroupLeave()">Detach from Community Group</a>
                    </div>
                </div>
                <div class="row"></div>
            </div>
            <h4 id="lblHeader">All Suppliers</h4>
            <div class="form-horizontal" role="form">
                <div class="col-md-3">
                    <h4>Avg Star Rating</h4>
                </div>
                <div class="col-md-3">
                    <h4>Supplier Name</h4>
                </div>
                <div class="col-md-3">
                    <h4>Reviews</h4>
                </div>
                <div class="col-md-3">
                    <h4>Location Map</h4>
                </div>
                <div id="lsvSupplierDetails"></div>
                <script id="supplierTemplate" type="text/x-kendo-tmpl">                    
                    <div class="custom-suppcommgroupdetail-col-md-11"><hr /></div>                        
                    <div class="col-md-3"><span><b>#= SupplierCommunityGroupRating==0 ? 'No Rating' : (SupplierCommunityGroupRating).toFixed(1) + ' Star(s)' #</b></span></div>
                    <div class="col-md-3" style="margin-left: -30px;"><span><b><a href="\#" class="custom-anchor" id="#= SupplierID #" onclick="OpenSupplierReview(this)">#= htmlEncode(SupplierName) #</a></b></span></div>
                    <div class="col-md-3" style="margin-left: -32px;"><span><b>#= ReviewCount == 0 ? 'No Review' :  ReviewCount + ' Review(s)' #</b></span></div>
                    <div class="col-md-8" style="margin-top: 25px; word-wrap: break-word;"><span>#= htmlEncode(Description) #</span></div>
                    <div class="col-md-2 pull-right" style="margin-top: -31px; margin-right: 65px;">
                        <div class="gllpMap" id="#= SupplierID #" style="width: 170px; height:170px; ">Google Maps</div>
                        <div class="form-group" id="divMapLatLon" style="display: none;">
                            <input type="text" class="gllpLatitude form-control custom-newcommunity-latlon-textbox" placeholder="Latitude" id="txtLatitude" name="txtLatitude" value="#= Latitude #" />
                            <label class="custom-regsupplier-slash-align">/</label>
                            <input type="text" class="gllpLongitude form-control custom-newcommunity-latlon-textbox" placeholder="Longitude" id="txtLongitude" name="txtLongitude" value="#= Longitude #" />
                        </div>
                    </div>
                </script>
            </div>
        </div>
    </div>
</asp:Content>
