<%@ Page Title="" Language="C#" MasterPageFile="~/RatingReviewEngineLogin.Master" AutoEventWireup="true" CodeBehind="SupplierReviews.aspx.cs" Inherits="RatingReviewEngine.Web.SupplierReviews" %>

<%@ Register Src="~/UserControl/ucMenu.ascx" TagPrefix="uc1" TagName="ucMenu" %>
<asp:Content ID="contentHead" ContentPlaceHolderID="contentPlaceHolderHead" runat="server">
    <style>
        .k-widget {
            border-style: none !important;
            box-shadow: none !important;
        }

        .custom-listview-margin {
            margin-left: -77px;
        }

        .custom-col-md-6-response {
            width: 47.5%;
            float: left;
            padding: 0px 15px;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            BindListView();
            BindMenu();
        });

        function BindListView() {
            var ownerId = GetQueryStringParams('oid') == undefined ? "0" : GetQueryStringParams('oid');
            var communityId = GetQueryStringParams('cid') == undefined ? "0" : GetQueryStringParams('cid');
            var communityGroupId = GetQueryStringParams('gid') == undefined ? "0" : GetQueryStringParams('gid');
            var customerid = GetQueryStringParams('cuid') == undefined ? "0" : GetQueryStringParams('cuid');

            ownerId = ownerId > 0 ? $("#hdnCommunityOwnerId").val() : ownerId;
            // var supplierId = ownerId == 0 ? $("#hdnSupplierId").val() : GetQueryStringParams('sid');
            var supplierId = GetQueryStringParams('sid') == undefined ? "0" : GetQueryStringParams('sid');

            var param = "/" + ownerId + "/" + communityId + "/" + communityGroupId + "/" + supplierId + "/" + customerid + "/" + $("#hdnSupplierId").val();
            GetResponse("GetSupplierReviewBySupplier", param, GetSupplierReviewSuccess, Failure, ErrorHandler);
        }

        function BindMenu() {
            var param = '/' + $("#hdnSupplierId").val();
            GetResponse("GetSupplierReviewCount", param, BindMenuSuccess, Failure, ErrorHandler);
        }

        function BindMenuSuccess(response) {

            var communityId = GetQueryStringParams('cid') == undefined ? "0" : GetQueryStringParams('cid');
            var communityGroupId = GetQueryStringParams('gid') == undefined ? "0" : GetQueryStringParams('gid');
            var supplierId = GetQueryStringParams('sid') == undefined ? "0" : GetQueryStringParams('sid');

            var ownerId = GetQueryStringParams('oid') == undefined ? "0" : GetQueryStringParams('oid');
            ownerId = ownerId > 0 ? $("#hdnCommunityOwnerId").val() : ownerId;
            //supplierId = ownerId == 0 ? $("#hdnSupplierId").val() : GetQueryStringParams('sid');

            var param = "/" + communityId + "/" + communityGroupId + "/" + supplierId + "/" + ownerId + "/" + $("#hdnSupplierId").val();
            GetResponse("GetSupplierReviewHeader", param, BindHeaderSuccess, Failure, ErrorHandler);

            var menuDataSource = new kendo.data.DataSource({
                data: response
            })

            menuDataSource.read();
            var menuCount = menuDataSource.total();

            var communityGroupId = GetQueryStringParams('gid') == undefined ? "0" : GetQueryStringParams('gid');
            if (communityGroupId > 0 && menuCount > 0) {

                $("#menuHeader").text('Community - Community Group').append('<b class="caret"></b>');
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

        function BindHeaderSuccess(response) {
            if (response.length == 0) {
                $("#SubTitle").text('0 Stars from 0 Reviews - 0 Pending');
            }
            else {
                $("#SubTitle").text(response.text == null ? "" : response.text);
            }
        }

        function GetSupplierReviewSuccess(response) {
            if (isNullOrEmpty(response.SupplierName)) {
                ErrorWindow('Supplier Reviews', "No data found", 'Nodata.aspx');
                return;
            }

            if (response.lstReview.length == 0) {
                $("#divNoData").show();
            }

            $('#Title').text('Reviews - ' + response.SupplierName);

            $kendoJS("#lsvReview").kendoListView({
                dataSource: response.lstReview,
                template: kendo.template($("#reviewTemplate").html()),
                dataBound: function () {
                    $kendoJS("#lsvReview").removeAttr("role");
                }
            });
        }

        function respond(id) {
            $('#div' + id).show();
            $('#a' + id).hide();
            return false;
        }

        function respondCancel(id) {
            $('#div' + id).hide();
            $('#a' + id).show();

            ClearValidation();
            $("#responseValidation" + id).removeClass("custom-supplierdashboard-email-validation-on").addClass("custom-supplierdashboard-email-validation-off");
            return false;
        }

        //On ajax call failure, failure message will be showed in popup.
        function Failure(response) {
            FailureWindow('Supplier Review', response, '#');
        }

        //On ajax call error, error message will be showed in popup.
        function ErrorHandler(response) {
            //Show error message in a user friendly window
            ErrorWindow('Supplier Review', response, '#');
        }

        function CheckResponseValidation(id) {
            var isValid = false;

            if ($.trim($("#txt" + id).val()) == "") {
                $('#txt' + id).closest('.form-group').addClass('form-group has-error').css('color', '#E74C3C').css('text-align', 'left');
                $("#responseValidation" + id).removeClass("custom-supplierdashboard-email-validation-off").addClass("custom-supplierdashboard-email-validation-on");
                isValid = true;
            }
            else {
                $('#txt' + id).closest('.form-group').removeClass('form-group has-error').addClass('form-group');
                $("#responseValidation" + id).removeClass("custom-supplierdashboard-email-validation-on").addClass("custom-supplierdashboard-email-validation-off");
                isValid = false;
            }

            return isValid;
        }

        function SaveResponse(reviewId) {
            var isValid = CheckResponseValidation(reviewId);
            if (!isValid) {

                var response = encodeURIComponent($("#txt" + reviewId).val());
                var postData = '{"ReviewID": "' + reviewId + '", "Response": "' + response + '", "CustomerID": "' + $("#hdnCustId" + reviewId).val() + '", "CommunityName": "' + $("#hdnComName" + reviewId).val() + '", "CommunityGroupName": "'
                    + $("#hdnComGroupName" + reviewId).val() + '","ReviewSupplierActionID":"' + $("#hdnSupplierActionId" + reviewId).val() + '"}';
                PostRequest("AddReviewResponse", postData, SaveResponseSuccess, Failure, ErrorHandler);
            }
        }

        function SaveResponseSuccess(response) {
            BindListView();
            BindMenu();
            SuccessWindow('Supplier Review', "Saved successfully.", '#');
        }

        function HideReview(reviewId, hideReview) {
            var postData = '{"ReviewID": "' + reviewId + '", "HideReview": "' + hideReview + '"}';
            PostRequest("UpdateReviewHide", postData, HideReviewSuccess, Failure, ErrorHandler);
        }

        function HideReviewSuccess(response) {
            BindListView();
        }

    </script>

</asp:Content>
<asp:Content ID="contentBody" ContentPlaceHolderID="contentPlaceHolderBody" runat="server">
    <uc1:ucMenu runat="server" ID="ucMenu" />
    <h2 class="h2" id="Title">Reviews</h2>
    <div class="row">
        <div class="col-md-12">
            <h4 id="SubTitle"></h4>
            <hr />
            <div class="col-md-1"></div>
            <div class="col-md-3">
                <h4>Star Rating</h4>
            </div>
            <div class="col-md-3">
                <h4>Customer Handle</h4>
            </div>
            <div class="col-md-3">
                <h4>Review Date</h4>
            </div>
            <div class="col-md-1"></div>

            <div id="lsvReview"></div>
            <div class="col-md-12">
                <div class="col-md-7"></div>
                <div id="divNoData" style="display: none;" class="col-md-3">
                    <span style="font-size: 15px; text-align: right; color: #a5a5a5;">No items to display</span>
                </div>
            </div>
            <script id="reviewTemplate" type="text/x-kendo-tmpl">            
                <div class="col-md-12 custom-listview-margin">                    
                   <div>
                       <div style="display :#=  $("\#hdnCommunityOwnerId").val()== CommunityOwnerID ? 'block' : 'none' #;">
                         <div class="col-md-12" style="display :#= HideReview == false && $("\#hdnCommunityOwnerId").val() > 0 && $("\#hdnCommunityOwnerId").val()== CommunityOwnerID ? 'block' : 'none' #;">
                            <div class="col-md-1"></div>
                            <div class="col-md-9" style="text-align: right;">                            
                                <a id="hlHide#= ReviewID #" href="\#" class="custom-anchor" onclick="HideReview(#= ReviewID #, true)">Hide Review</a>                            
                            </div>
                            <div class="col-md-1"></div>
                           </div>
                           <div class="col-md-12" style="display :#= HideReview == true && $("\#hdnCommunityOwnerId").val() > 0 && $("\#hdnCommunityOwnerId").val()== CommunityOwnerID  ? 'block' : 'none' #;">
                            <div class="col-md-1"></div>
                            <div class="col-md-9" style="text-align: right;">                            
                                <a id="hlUnHide#= ReviewID #" href="\#" class="custom-anchor" onclick="HideReview(#= ReviewID #, false)" >Un-Hide Review</a>                            
                            </div>
                            <div class="col-md-1"></div>
                         </div>
                        </div>

                        <div class="col-md-12" >
                            <div class="col-md-12">
                                <div class="col-md-1"></div>
                                <div class="col-md-9">
                                    <hr />
                                </div>
                                <div class="col-md-1"></div>
                            </div>
                            <div class="col-md-1"></div>
                            <div class="col-md-10">
                                <div class="col-md-3">
                                    <label style="font-weight: bold;">#= Rating # Star(s)</label>
                                </div>
                                <div class="col-md-3" style="padding: 0px 0px 0px 35px;">
                                    <label style="font-weight: bold;">#= CustomerHandle # </label>
                                </div>
                                <div class="col-md-3" style="padding: 0px 0px 0px 46px;">
                                   <%-- <label style="font-weight: bold;">#= kendo.toString(new Date(parseInt(ReviewDate.replace("/Date(", "").replace(")/", ""), 10)), "dd/MM/yyyy hh:mm:tt") #</label>--%>
                                    <label style="font-weight: bold;">#= ReviewDateString #</label>
                                </div>
                            </div>                    
                            <div class="col-md-1"></div>
                        </div>                    
                        <div class="col-md-12"  >
                            <div class="col-md-12">
                                <div class="col-md-1"></div>
                                <div class="col-md-9">
                                    <div style="display :#= HideReview == true  &&  $("\#hdnSupplierId").val() != SupplierID && $("\#hdnCommunityOwnerId").val()!= CommunityOwnerID ? 'none' : 'block' #;">
                                        <label>#=  htmlEncode(ReviewMessage) # </label><br/>
                                      </div>
                                       <div style="display :#= HideReview == true  &&  $("\#hdnSupplierId").val() != SupplierID && $("\#hdnCommunityOwnerId").val()!= CommunityOwnerID ? 'block' : 'none' #;">
                                        <label>This review has been hidden by the Community Owner as it does not contain information deemed suitable for public view. </label><br/>
                                      </div>
                                </div>
                                <div class="col-md-1"></div>
                            </div>
                            <div class="col-md-11">
                                <div class="col-md-1"></div>
                                <div class="col-md-10">
                                    <div id=div#= ReviewID # style="display:none" class="form-group">
                                        <textarea row="3"  id=txt#= ReviewID # class="form-control custom-supplierreview-textarea" onchange=CheckResponseValidation(#= ReviewID #)></textarea>
                                        <span id="responseValidation#= ReviewID #" class="custom-supplierdashboard-email-validation-off">You can't leave this empty.</span>
                                        <br /><br />
                                        <div class="pull-right" style="margin-right: 30px;">
                                            <input type="hidden" id="hdnCustId#= ReviewID #" value="#= CustomerID #" />
                                            <input type="hidden" id="hdnSupplierActionId#= ReviewID #" value="#= SupplierActionID #" />
                                            <input type="hidden" id="hdnComName#= ReviewID #" value="#= encodeURIComponent(CommunityName) #" />
                                            <input type="hidden" id="hdnComGroupName#= ReviewID #" value="#= encodeURIComponent(CommunityGroupName) #" />
                                            <input type="button" value="Save" class="btn btn-info" onclick="SaveResponse(#= ReviewID #)" />
                                            <input type="button" value="Cancel" onclick="respondCancel(#= ReviewID #)" class="btn btn-default" />
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-1"></div>
                            </div>                            
                            <div class="col-md-12">
                                <div class="col-md-1"></div>
                                <div class="col-md-10">
                                    <a href='' id=a#= ReviewID # onclick="return respond(#= ReviewID #)" class="custom-anchor" style="display :#= (ResponseCount ==0) ? (SupplierID==$("\#hdnSupplierId").val()? 'block' : 'none') : 'none' #;" >Respond</a>  
                                </div>
                                <div class="col-md-1"></div>
                            </div>                    
                            <div style="display :#= (ResponseCount > 0) == true ? 'block' : 'none' #;" >
                                <div class="col-md-12">
                                    <div class="col-md-1"></div>
                                    <div class="custom-col-md-6-response">
                                        <h4>Response</h4>
                                       <label>#= htmlEncode(Response.Response).replace(/\n/g, "<br>") # </label>                
                                    </div> 
                                    <div class="col-md-4">
                                        <h4 style="margin-left: 0%">Response Date</h4>
                                        <%--<label>#= kendo.toString(new Date(parseInt(Response.ResponseDate.replace("/Date(", "").replace(")/", ""), 10)), "dd/MM/yyyy hh:mm:tt") #</label>   --%>  
                                        <label style="margin-left: 0%">#=Response.ResponseDateString  #</label>                          
                                    </div>
                                    <div class="col-md-1"></div>                   
                                </div>
                            </div>                    
                        </div>
                    </div>                    
                </div>
            </script>
        </div>
    </div>
</asp:Content>
