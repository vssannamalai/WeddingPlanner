using System.ServiceModel;
using System.ServiceModel.Web;
using System.ServiceModel.Channels;
using System.Web;
using System.Collections.Specialized;
using System.Collections.Generic;
using System;
using System.Xml.Linq;
using System.Net;
using System.IO;
using System.Configuration;
using System.Runtime.Serialization;
using System.Xml;
using RatingReviewEngine.Business;
using System.Text;
//using RatingReviewEngine.API.Extension ;

namespace RatingReviewEngine.API
{
    public class APITokenAuthorization : ServiceAuthorizationManager
    {
        #region Constants
        public const string APITOKEN = "APIToken";
        public const string APIErrorHTML = @"<ErrorMessage>Invalid API Token</ErrorMessage>";
     
        #endregion

        #region ServiceAuthorizationManager overriden methods
        
        protected override bool CheckAccessCore(OperationContext operationContext)
        {
            //Allow help page without appplication api token
            if (operationContext.IncomingMessageProperties.Via.LocalPath.EndsWith("help"))
            {
                return true;
            }
            else
            {
                return IsValidAPIToken(operationContext);
            }
        }

        #endregion
        #region MemberFunctions
        public bool IsValidAPIToken(OperationContext operationContext)
        {
            // if verification is disabled, return true
            if (Global.APITokenVerification == false)
                return true;

            string token = GetAPIToken(operationContext);
            UserComponent userComponent = new UserComponent();



            // Convert the string into a Guid and validate it
            if (userComponent.ValidateAPIToken(token))
            {
                return true;
            }
            else
            {
                // Send back an HTML reply
                CreateErrorReply(operationContext, token);
                return false;
            }
        }
        public string GetAPIToken(OperationContext operationContext)
        {
            // Get the request message
            var request = operationContext.RequestContext.RequestMessage;

            // Get the HTTP Request
            var requestProp = (HttpRequestMessageProperty)request.Properties[HttpRequestMessageProperty.Name];


            // Get the query string
            NameValueCollection headerParams = requestProp.Headers;

            // Return the API key (if present, null if not)
            return headerParams[APITOKEN];
        }
        private static void CreateErrorReply(OperationContext operationContext, string key)
        {
            // The error message is padded so that IE shows the response by default
            using (var sr = new StringReader("<?xml version=\"1.0\" encoding=\"utf-8\"?>"  + APIErrorHTML))
            {
              XElement response = XElement.Load(sr);
              RatingReviewEngineException ratingException = new RatingReviewEngineException("Invalid API Token");
              
              using (Message reply = Message.CreateMessage(MessageVersion.None, null,response))
                {
                    string ErrorMessage = (String.IsNullOrEmpty(key))?"API Token is missing in request" :String.Format("'{0}' is an invalid API Token", key);
                    HttpResponseMessageProperty responseProp = new HttpResponseMessageProperty() { StatusCode = HttpStatusCode.Unauthorized, StatusDescription = ErrorMessage };
                    responseProp.Headers[HttpResponseHeader.ContentType] = "text/json";
                    reply.Properties[HttpResponseMessageProperty.Name] = responseProp;
                    operationContext.RequestContext.Reply(reply);

                     
                    // set the request context to null to terminate processing of this request
                    operationContext.RequestContext = null;
                }
            }
        }
 
        #endregion
    }
}