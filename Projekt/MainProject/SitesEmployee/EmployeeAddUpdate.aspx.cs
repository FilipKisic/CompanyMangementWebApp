using MainProject.Models;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MainProject.SitesEmployee
{
    public partial class EmployeeAddUpdate : System.Web.UI.Page
    {
        private static readonly string cs = System.Configuration.ConfigurationManager.ConnectionStrings["cs"].ConnectionString;
        private static Worker worker;
        private GridViewRow current;
        private static string teamName;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Cookies["loginData"] == null)
            {
                Response.Redirect("../LoginPage.aspx");
            }
            if (!IsPostBack)
            {
                Setup();
            }
        }

        private void Setup()
        {
            FetchData();
            foreach (GridViewRow row in Employees.Rows)
            {
                SetButton(row);
            }
        }

        private void SetButton(GridViewRow row)
        {
            Button btn = (Button)row.FindControl("btnSelect");
            btn.Text = "Odaberi";
            btn.BackColor = Color.FromArgb(99, 176, 255);
        }

        private void FetchData()
        {
            SqlDataSource sqlDataSource = new SqlDataSource(cs, "spSelectWorkersWithFullName");
            sqlDataSource.SelectCommandType = SqlDataSourceCommandType.StoredProcedure;
            Employees.DataSource = sqlDataSource;
            Employees.DataBind();
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
                            teamName = dr.GetString(11);
                        }
                    }
                }
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.StackTrace);
            }
        }

        protected void btnSelect_Click(object sender, EventArgs e)
        {
            int rowIndex = ((GridViewRow)(sender as Control).NamingContainer).RowIndex;
            current = Employees.Rows[rowIndex];
            GetWorker(current.Cells[0].Text);
            FillFields();
        }

        private void FillFields()
        {
            txtFullName.Text = worker.FirstName + " " + worker.LastName;
            txtEmail.Text = worker.Email;
            txtDate.Text = worker.DateOfEmployment;
            txtType.Text = worker.TypeOfEmployee;
            txtTeam.Text = teamName;
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string spName = "spUpdateWorker";
            string[] name = txtFullName.Text.Split(' ');
            if (name.Length <= 1) return;
            int teamID = 0;
            if (txtTeam.Text != string.Empty)
                teamID = PrepareTeam();
            if (teamID == -1)
            {
                txtTeam.Text = "Pogrešan naziv tima";
                return;
            }
            try
            {
                using (SqlConnection sqlConnection = new SqlConnection(cs))
                using (SqlCommand sqlUpdate = new SqlCommand(spName, sqlConnection))
                {
                    sqlUpdate.CommandType = CommandType.StoredProcedure;
                    sqlUpdate.Parameters.Add("@IDWorker", SqlDbType.Int).Value = worker.IDWorker;
                    sqlUpdate.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = name[0];
                    sqlUpdate.Parameters.Add("@LastName", SqlDbType.NVarChar).Value = name[1];
                    sqlUpdate.Parameters.Add("@Email", SqlDbType.NVarChar).Value = txtEmail.Text;
                    sqlUpdate.Parameters.Add("@DateOfEmployment", SqlDbType.NVarChar).Value = txtDate.Text;
                    sqlUpdate.Parameters.Add("@PSWRD", SqlDbType.NVarChar).Value = worker.PSWRD;
                    sqlUpdate.Parameters.Add("@TypeOfEmployee", SqlDbType.NVarChar).Value = txtType.Text;
                    sqlUpdate.Parameters.AddWithValue("@TeamID", teamID == 0 ? Convert.DBNull : teamID);
                    sqlUpdate.Parameters.Add("@IsActive", SqlDbType.Bit).Value = 1;
                    sqlUpdate.Parameters.Add("@IsTeamLeader", SqlDbType.Bit).Value = worker.IsTeamLeader;
                    sqlUpdate.Parameters.Add("@IsCEO", SqlDbType.Bit).Value = worker.IsCEO;

                    sqlConnection.Open();
                    sqlUpdate.ExecuteNonQuery();
                }
            }
            catch
            {
                ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Nije moguće učiniti...');", true);
            }
            Clean();
            Setup();
        }

        private int PrepareTeam()
        {
            string spName = "spCheckIfTeamExists";
            using (SqlConnection sqlConnection = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(spName, sqlConnection))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Title", txtTeam.Text.Trim());
                cmd.Parameters.Add("@IDTeam", SqlDbType.Int);
                cmd.Parameters["@IDTeam"].Direction = ParameterDirection.Output;

                sqlConnection.Open();
                cmd.ExecuteNonQuery();
                return Convert.ToInt32(cmd.Parameters["@IDTeam"].Value);
            }
        }

        private void Clean()
        {
            txtFullName.Text = string.Empty;
            txtEmail.Text = string.Empty;
            txtDate.Text = string.Empty;
            txtType.Text = string.Empty;
            txtTeam.Text = string.Empty;
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            string spName = "spCreateWorker";
            string[] name = txtFullName.Text.Split(' ');
            if (name.Length <= 1) return;
            int teamID = 0;
            if (txtTeam.Text != string.Empty)
                teamID = PrepareTeam();
            if (teamID == -1)
            {
                txtTeam.Text = "Pogrešan naziv tima";
                return;
            }

            using (SqlConnection sqlConnection = new SqlConnection(cs))
            using (SqlCommand sqlUpdate = new SqlCommand(spName, sqlConnection))
            {
                sqlUpdate.CommandType = CommandType.StoredProcedure;
                sqlUpdate.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = name[0];
                sqlUpdate.Parameters.Add("@LastName", SqlDbType.NVarChar).Value = name[1];
                sqlUpdate.Parameters.Add("@Email", SqlDbType.NVarChar).Value = txtEmail.Text;
                sqlUpdate.Parameters.Add("@DateOfEmployment", SqlDbType.NVarChar).Value = txtDate.Text;
                sqlUpdate.Parameters.Add("@PSWRD", SqlDbType.NVarChar).Value = Membership.GeneratePassword(8, 1);
                sqlUpdate.Parameters.Add("@TypeOfEmployee", SqlDbType.NVarChar).Value = txtType.Text;
                sqlUpdate.Parameters.AddWithValue("@TeamID", teamID == 0 ? Convert.DBNull : teamID);
                sqlUpdate.Parameters.Add("@IsActive", SqlDbType.Bit).Value = 1;
                sqlUpdate.Parameters.Add("@IsTeamLeader", SqlDbType.Bit).Value = 0;
                sqlUpdate.Parameters.Add("@IsCEO", SqlDbType.Bit).Value = 0;

                sqlConnection.Open();
                sqlUpdate.ExecuteNonQuery();
            }
            Clean();
            Setup();
        }
    }
}