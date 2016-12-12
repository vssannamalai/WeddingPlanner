<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="SupplierSnapshot.aspx.cs" Inherits="RatingReviewEngine.Web.SupplierSnapshot" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>
<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <link rel="Stylesheet" type="text/css" href="http://ajax.microsoft.com/ajax/jquery.ui/1.8.5/themes/dark-hive/jquery-ui.css" />
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&libraries=drawing"></script>

    <link rel="stylesheet" type="text/css" href="css/jquery-gmaps-latlon-picker.css" />
    <%-- <script src="js/jquery-gmaps-latlon-picker.js"></script>--%>

    <style>
        .k-header {
            color: White;
            background-color: #34495E;
            font-size: 16px;
        }

        body {
            font-size: 14px !important;
        }

        .k-pager-numbers .k-link {
            line-height: 2.28em !important;
        }

        .custom-suppliersnapshot-logo_icon-size {
            width: 150px;
            height: 150px;
        }

        .thumbnail > img, .thumbnail a > img {
            height: 100% !important;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            if (GetQueryStringParams('sid') == null ) {
                ErrorWindow('Supplier Snapshot', "No data found", 'Nodata.aspx');
                return;
            }

            var supplierId = GetQueryStringParams('sid');
            if (supplierId != "-1") {
                GetSupplier(supplierId);
                GetSupplierSocialReference(supplierId);
                GetSupplierLogo(supplierId);
            }
            else {
                ErrorWindow('Supplier Snapshot', "No data found", 'Nodata.aspx');
                return;
            }
        });

        //Service call to get supplier detail based on supplierid from query string.
        function GetSupplier(supplierId) {
            var param = "/" + supplierId;
            GetResponse("GetSupplier", param, GetSupplierSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, sets the values to the respective controls and calls MapApiLoaded() method.
        function GetSupplierSuccess(response) {
            if (response.SupplierID == 0) {
                ErrorWindow('Supplier Snapshot', "No data found", 'Nodata.aspx');
                return;
            }
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
            //$("#lblQuoteTerms").text(response.QuoteTerms);
            //$("#lblDepositTerms").text(response.DepositTerms);

            $("#lblWebsite").text(response.Website);
            $("#lblWebsite").attr('href', response.Website);

            //$("#hdfDateAdded").val(response.DateAdded);
            //$("#hdfCountryID").val(response.AddressCountryID);
            //$("#hdfBillingCountryID").val(response.BillingAddressCountryID);
            $("#hdfLatitude").val(response.Latitude);
            $("#hdfLongitude").val(response.Longitude);

            //$.ajax({
            //    url: "http://maps.googleapis.com/maps/api/js?sensor=false&callback=MapApiLoaded",
            //    dataType: "script",
            //    timeout: 8000,
            //    error: function () {
            //        // Handle error here
            //    }
            //});

            MapApiLoaded();
        }

        //Service call to fetch supplier logo based on supplieId.
        function GetSupplierLogo(supplierId) {
            var param = "/" + supplierId;
            GetResponse("SupplierLogoSelect", param, GetSupplierLogoSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds the logo to the respective control.
        function GetSupplierLogoSuccess(response) {
            if (response.Base64String != null) {
                $('#imgLogo').attr('src', 'data:image/png' + ';base64,' + response.Base64String);
            }
            $("#progress").hide();
        }

        //Google map will be loaded based on supplier latitude and longitude values.
        function MapApiLoaded() {
            // Create google map

            $('.gllpMap').each(function () {

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

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Supplier Snapshot', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {            
            //Show error message in a user friendly window
            ErrorWindow('Supplier Snapshot', response, '#');
        }

        //Gets supplier social reference detail based on supplierid.
        function GetSupplierSocialReference(supplierId) {
            var param = "/" + supplierId;
            GetResponse("GetSupplierSocialReference", param, GetSupplierSocialReferenceSuccess, Failure, ErrorHandler);
        }

        //On ajax call success, binds social reference details to grid.
        function GetSupplierSocialReferenceSuccess(response) {
            $kendoJS("#gvSocialReference").kendoGrid({
                dataSource: {
                    pageSize: 10,
                    data: response
                },
                columns: [
                    { field: "SocialMediaName", title: "Social Media" },
                    { field: "SocialMediaReference", title: "Social Reference", template: '<a class="custom-anchor" href="#=SocialMediaReference#" target="_blank">#=SocialMediaReference#</a>' }
                ],
                pageable: false,
                scrollable: false
            }).data("kendoGrid");
        }
    </script>

</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2">Supplier Snapshot</h2>
    <div class="row">
        <div class="form-horizontal col-md-12" role="form">
            <hr />
            <div class="col-md-12">
                <div class="col-md-3">
                    <div class="fileinput fileinput-new" data-provides="fileinput">
                        <div class="fileinput-preview thumbnail custom-suppliersnapshot-logo_icon-size" data-trigger="fileinput">
                            <img id="imgLogo" alt="No logo available" />
                        </div>
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
                        <div style="word-break:break-all">
                            <a id="lblWebsite" class="custom-supplierdashboard-label-fontstyle custom-anchor" href="#" target="_blank"></a>
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
                    <fieldset class="gllpLatlonPicker">
                        <div class="gllpMap" style="height: 170px !important; width: 170px !important;">Google Maps</div>
                        <input type="hidden" id="hdfLatitude" />
                        <input type="hidden" id="hdfLongitude" />
                    </fieldset>
                </div>
            </div>
            <div class="col-md-12">
                <hr />
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                    <div class="custom-supplierdashboard-innerdiv">
                        <div>
                            <label class="custom-supplierdashboard-label-lineheight">Billing Name</label>
                        </div>
                        <div>
                            <label id="lblBillingName" class="custom-supplierdashboard-label-fontstyle"></label>
                        </div>
                    </div>
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
                </div>
                <div class="col-md-3">
                </div>
                <div class="col-md-3">
                </div>
            </div>
            <div class="col-md-12">
                <hr />
                <div id="gvSocialReference"></div>
            </div>
        </div>
    </div>
</asp:Content>
