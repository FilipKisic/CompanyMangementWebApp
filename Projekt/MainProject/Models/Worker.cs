using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;

namespace MainProject.Models
{
    public class Worker
    {
        public int IDWorker { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string DateOfEmployment { get; set; }
        public string PSWRD { get; set; }
        public string TypeOfEmployee { get; set; }
        public int TeamID { get; set; }
        public bool IsActive { get; set; }
        public bool IsTeamLeader { get; set; }
        public bool IsCEO { get; set; }

        public Worker()
        {
        }

        public Worker(string firstName, string lastName)
        {
            FirstName = firstName;
            LastName = lastName;
        }

        public Worker(int idWorker, bool isTeamLeader)
        {
            IDWorker = idWorker;
            IsTeamLeader = isTeamLeader;
        }

        public override string ToString() => $"{FirstName} {LastName}";

        public static void UpdateTeamLeaderFlag(string cs, int IDWorker, int flag)
        {
            try
            {
                string spName = "spUpdateWorkerTeamLeaderFlag";
                using (SqlConnection sqlConnection = new SqlConnection(cs))
                using (SqlCommand cmd = new SqlCommand(spName, sqlConnection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@IDWorker", SqlDbType.Int).Value = IDWorker;
                    cmd.Parameters.Add("@IsTeamLeader", SqlDbType.Bit).Value = flag;

                    sqlConnection.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.StackTrace);
            }
        }
    }
}