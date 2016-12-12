using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using CorsProxy.AspNet;
using System.Web.Routing;
using Microsoft.AspNet.FriendlyUrls;

namespace RatingReviewEngine.Web.App_Start
{
    public static class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            //important, must be added before the default route.
            routes.EnableCorsProxy();
            routes.EnableFriendlyUrls();
        }
    }
}
