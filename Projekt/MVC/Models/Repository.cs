using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Web;

namespace MVC.Models
{
    public class Repository
    {
        public static DataSet dataSet { get; set; }
        private static readonly string cs = ConfigurationManager.ConnectionStrings["cs"].ConnectionString;

        public static IEnumerable<Activity> GetProjects(int id)
        {
            dataSet = SqlHelper.ExecuteDataset(cs, "spSelectActivitesForWorker", id);
            foreach (DataRow row in dataSet.Tables[0].Rows)
            {
                yield return new Activity
                {
                    IDActivity = (int)row["IDActivity"],
                    ProjectID = row["ProjectID"] == DBNull.Value ? 0 : (int)row["ProjectID"],
                    ActivityName = row["Title"].ToString()
                };
            }
        }

        public static Activity GetActivity(int IDActivity, int IDWorker)
        {
            Debug.WriteLine($"IDActivity: {IDActivity}");
            DataRow row = SqlHelper.ExecuteDataset(cs, "spSelectActivity", IDActivity, IDWorker).Tables[0].Rows[0];
            Debug.WriteLine(row["ActivityName"].ToString());
            return new Activity
            {
                IDActivity = (int)row["IDActivity"],
                ActivityName = row["ActivityName"].ToString(),
                DurationInMinutes = (int)row["DurationInMinutes"],
                ProjectID = row["ProjectID"] == DBNull.Value ? 0 : (int)row["ProjectID"],
                PersonalDurationInMinutes = (int)row["PersonalDurationInMinutes"]
            };
        }

        //1. create method to update row in database
        //public static void UpdateActivityHours(int IDActivity, int duration) => SqlHelper.ExecuteNonQuery(cs, "spUpdateActivity", IDActivity, duration);
        public static void UpdatePersonalHours(int ActivityID, int WorkerID, int duration) => SqlHelper.ExecuteNonQuery(cs, "spUpdatePersonalMinutes", ActivityID, WorkerID, duration);
    }
}