using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.Routing;

using Common.Logging;
using Quartz;
using Quartz.Impl;


using RatingReviewEngine.Web.Scheduler;

namespace RatingReviewEngine.Web
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            App_Start.AuthConfig.RegisterOpenAuth();
            App_Start.RouteConfig.RegisterRoutes(RouteTable.Routes);


            ISchedulerFactory sf = new StdSchedulerFactory();

            IScheduler sched = sf.GetScheduler();


            DateTimeOffset startTime = DateBuilder.NextGivenSecondDate(null, 15);



            IJobDetail job2 = JobBuilder.Create<MonthlyBillingCycle>()
                .WithIdentity("MonthlyBillingCycle", "supplier1")
                .Build();

            ICronTrigger trigger2 = (ICronTrigger)TriggerBuilder.Create()
                                                        .WithIdentity("MonthlyBillingCycletrigger", "group2")
                                                        .WithCronSchedule("0 30 11 25 * ?")// Fire at 11:30am on the 25th day of every month

                                                        .StartNow()
                                                        .Build();

            sched.ScheduleJob(job2, trigger2);


            IJobDetail job = JobBuilder.Create<BillFreeEndDateUpdate>()
                 .WithIdentity("billfreeendupdate", "supplier")
                 .Build();

            ISimpleTrigger trigger = (ISimpleTrigger)TriggerBuilder.Create()
                                                        .WithIdentity("billfreeupdatetrigger", "group1")
                                                        .StartAt(startTime)
                                                         .WithSimpleSchedule(x => x
                                                         .WithIntervalInHours(24)
                                                         .RepeatForever())
                                                        .Build();

            sched.ScheduleJob(job, trigger);

            IJobDetail fileDelete = JobBuilder.Create<TempFileDelete>()
                .WithIdentity("TempFileDelete", "file")
                .Build();

            ISimpleTrigger trigger3 = (ISimpleTrigger)TriggerBuilder.Create()
                                                        .WithIdentity("TempFileDeletetrigger", "group3")
                                                        .StartAt(startTime)
                                                         .WithSimpleSchedule(x => x
                                                         .WithIntervalInHours(24)
                                                         .RepeatForever())
                                                        .Build();

            sched.ScheduleJob(fileDelete, trigger3);

            sched.Start();

        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {
            HttpContext.Current.Response.AddHeader("Access-Control-Allow-Origin", "*");

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}