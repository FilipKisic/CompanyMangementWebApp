using MainProject.Models;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Web;

namespace MainProject.SiteSettings
{
    public partial class Settings : System.Web.UI.Page
    {
        private static readonly string cs = System.Configuration.ConfigurationManager.ConnectionStrings["cs"].ConnectionString;
        private static Worker worker;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.Cookies["loginData"] != null)
                {
                    HttpCookie cookie = Request.Cookies["loginData"];
                    GetWorker(cookie["id"]);
                    FillFields();
                }
                else
                    Response.Redirect("../LoginPage.aspx");
            }
        }

        private void GetWorker(string id)
        {
            try
            {
                worker = new Worker();
                using (SqlConnection connection = new SqlConnection(cs))
                {
                    string spName = "spSelectWorker";

                    SqlCommand cmd = new SqlCommand(spName, connection);
                    SqlParameter IDWorker = new SqlParameter();
                    IDWorker.ParameterName = "@IDWorker";
                    IDWorker.SqlDbType = SqlDbType.Int;
                    IDWorker.Value = int.Parse(id);

                    cmd.Parameters.Add(IDWorker);

                    connection.Open();
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.HasRows)
                    {
                        while (dr.Read())
                        {
                            worker.IDWorker = dr.GetInt32(0);
                            worker.FirstName = dr.GetString(1);
                            worker.LastName = dr.GetString(2);
                            worker.Email = dr.GetString(3);
                            worker.DateOfEmployment = dr.GetString(4);
                            worker.PSWRD = dr.GetString(5);
                            worker.TypeOfEmployee = dr.GetString(6);
                            worker.TeamID = dr.GetInt32(7);
                            worker.IsActive = dr.GetBoolean(8);
                            worker.IsTeamLeader = dr.GetBoolean(9);
                            worker.IsCEO = dr.GetBoolean(10);
                        }
                    }
                    Debug.WriteLine($"TeamID: {worker.TeamID}");
                }
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.StackTrace);
            }
        }

        private void FillFields()
        {
            txtFirstName.Text = worker.FirstName;
            txtLastName.Text = worker.LastName;
            txtEmail.Text = worker.Email;
            txtDate.Text = worker.DateOfEmployment;
            txtType.Text = worker.TypeOfEmployee;
        }

        protected void UpdateWorker()
        {
            string spName = "spUpdateWorker";
            using (SqlConnection sqlConnection = new SqlConnection(cs))
            using (SqlCommand sqlUpdate = new SqlCommand(spName, sqlConnection))
            {
                sqlUpdate.CommandType = CommandType.StoredProcedure;
                sqlUpdate.Parameters.Add("@IDWorker", SqlDbType.Int).Value = worker.IDWorker;
                sqlUpdate.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = txtFirstName.Text;
                sqlUpdate.Parameters.Add("@LastName", SqlDbType.NVarChar).Value = txtLastName.Text;
                sqlUpdate.Parameters.Add("@Email", SqlDbType.NVarChar).Value = txtEmail.Text;
                sqlUpdate.Parameters.Add("@DateOfEmployment", SqlDbType.NVarChar).Value = txtDate.Text;
                sqlUpdate.Parameters.Add("@PSWRD", SqlDbType.NVarChar).Value = worker.PSWRD;
                sqlUpdate.Parameters.Add("@TypeOfEmployee", SqlDbType.NVarChar).Value = txtType.Text;
                sqlUpdate.Parameters.Add("@TeamID", SqlDbType.Int).Value = worker.TeamID == 0 ? 0 : worker.TeamID;
                sqlUpdate.Parameters.Add("@IsActive", SqlDbType.Bit).Value = 1;
                sqlUpdate.Parameters.Add("@IsTeamLeader", SqlDbType.Bit).Value = worker.IsTeamLeader;
                sqlUpdate.Parameters.Add("@IsCEO", SqlDbType.Bit).Value = worker.IsCEO;

                sqlConnection.Open();
                sqlUpdate.ExecuteNonQuery();
            }
        }

        protected void Update_Click(object sender, EventArgs e)
        {
            UpdateWorker();
        }

        protected void LogOut_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            HttpCookie cookie = Response.Cookies["loginData"];
            cookie.Expires = DateTime.Now.AddDays(-1);
            Response.Cookies.Add(cookie);
            Response.Redirect("../LoginPage.aspx");
        }
    }
}