using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ServiceModel.Description;
using System.ServiceModel.Dispatcher;
using System.ServiceModel.Channels;
using System.ServiceModel.Web;
using System.Net;
using System.Text;
using RatingReviewEngine.Business.Shared;
namespace RatingReviewEngine.API
{
    /// <summary>
    /// Class to implement authentication for accessing individual method. 
    /// Reference : http://www.mikeobrien.net/blog/wcf-rest-per-method-basic/
    /// </summary>
    public class RequireUserAuthentication : Attribute, IOperationBehavior, IOperationInvoker
    {
        #region Private Fields

        private IOperationInvoker _invoker;

        #endregion

        #region IOperationBehavior Members

        public void ApplyDispatchBehavior(OperationDescription operationDescription,
            DispatchOperation dispatchOperation)
        {
            _invoker = dispatchOperation.Invoker;
            dispatchOperation.Invoker = this;
        }

        public void ApplyClientBehavior(OperationDescription operationDescription,
            ClientOperation clientOperation) { }
        public void AddBindingParameters(OperationDescription operationDescription,
            BindingParameterCollection bindingParameters) { }
        public void Validate(OperationDescription operationDescription) { }

        #endregion

        #region IOperationInvoker Members

        public object Invoke(object instance, object[] inputs, out object[] outputs)
        {
            if (Authenticate("Rating Review Engine"))
                return _invoker.Invoke(instance, inputs, out outputs);
            else
            {
                outputs = null;
                return null;
            }
        }

        public object[] AllocateInputs() { return _invoker.AllocateInputs(); }

        public IAsyncResult InvokeBegin(object instance, object[] inputs,
            AsyncCallback callback, object state)
        { throw new NotSupportedException(); }

        public object InvokeEnd(object instance, out object[] outputs, IAsyncResult result)
        { throw new NotSupportedException(); }

        public bool IsSynchronous { get { return true; } }

        #endregion

        #region Private Methods
        private bool Authenticate(string realm)
        {
            string OAuthToken = GetOAuthToken(WebOperationContext.Current.IncomingRequest.Headers);
            ///Planned to keep the user authentication token in session and validate from the session on each request.
            ///The session id keep changing on each request due to Cross Origin Resource Sharing (CORS) not configured properly.
            //TODO:Need to validate user authentication token, need dicussion whether we have those user auth token in a list or need to check against database
            if (!String.IsNullOrEmpty(OAuthToken)) //// && OAuthToken == SessionHelper.OAuthToken
            {
                return true;
            }
            WebOperationContext.Current.OutgoingResponse.Headers["WWW-Authenticate"] =
                string.Format("Basic realm=\"{0}\"", realm);
            WebOperationContext.Current.OutgoingResponse.StatusCode =
                HttpStatusCode.Unauthorized;
            return false;
        }

        private string GetOAuthToken(WebHeaderCollection headers)
        {
            string authToken = WebOperationContext.Current.IncomingRequest.
                  Headers["AuthToken"];
            if (authToken != null)
            {
                authToken = authToken.Trim();
                return authToken;
            }
            else
            {
                return null;
            }
        }
        #endregion
    }
}