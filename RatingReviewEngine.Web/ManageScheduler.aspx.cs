using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Quartz;
using Quartz.Impl;
using RatingReviewEngine.Web.Scheduler;

namespace RatingReviewEngine.Web
{
    public partial class ManageScheduler : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ISchedulerFactory sf = new StdSchedulerFactory();
                IScheduler sched = sf.GetScheduler();
                ISimpleTrigger tri = (ISimpleTrigger)TriggerBuilder.Create().WithIdentity("billfreeupdatetrigger", "group1").Build();
                if (sched.CheckExists(tri.Key))
                {
                    btnStart.Visible = false;
                    btnStop.Visible = true;
                }
                else
                {
                    btnStart.Visible = true;
                    btnStop.Visible = false;
                }
            }
        }

        protected void btnStart_Click(object sender, EventArgs e)
        {
            ISchedulerFactory sf = new StdSchedulerFactory();
            IScheduler sched = sf.GetScheduler();
            DateTimeOffset startTime = DateBuilder.NextGivenSecondDate(null, 15);

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
            sched.Start();
            btnStart.Visible = false;
            btnStop.Visible = true;
        }

        protected void btnStop_Click(object sender, EventArgs e)
        {
            ISchedulerFactory sf = new StdSchedulerFactory();
            IScheduler sched = sf.GetScheduler();
            ISimpleTrigger tri = (ISimpleTrigger)TriggerBuilder.Create().WithIdentity("billfreeupdatetrigger", "group1").Build();
            sched.UnscheduleJob(tri.Key);

            btnStart.Visible = true;
            btnStop.Visible = false;
        }
    }
}