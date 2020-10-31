using MainProject.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MainProject.SitesTeam
{
    public partial class TeamAddUpdate : System.Web.UI.Page
    {
        private static readonly string cs = System.Configuration.ConfigurationManager.ConnectionStrings["cs"].ConnectionString;
        private static Team team;
        private GridViewRow current;
        private static string teamLeader;
        private static IList teamMembers;
        private Worker worker;

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
            foreach (GridViewRow row in Teams.Rows)
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
            SqlDataSource sqlDataSource = new SqlDataSource(cs, "spSelectActiveTeams");
            sqlDataSource.SelectCommandType = SqlDataSourceCommandType.StoredProcedure;
            Teams.DataSource = sqlDataSource;
            Teams.DataBind();
        }

        protected void btnSelect_Click(object sender, EventArgs e)
        {
            int rowIndex = ((GridViewRow)(sender as Control).NamingContainer).RowIndex;
            current = Teams.Rows[rowIndex];
            GetTeam(current.Cells[0].Text);
            GetEmployees();
            FillFields();
        }

        private void GetTeam(string id)
        {
            try
            {
                team = new Team();
                using (SqlConnection connection = new SqlConnection(cs))
                {
                    string spName = "spSelectTeam";

                    SqlCommand cmd = new SqlCommand(spName, connection);
                    SqlParameter IDTeam = new SqlParameter();
                    IDTeam.ParameterName = "@IDTeam";
                    IDTeam.SqlDbType = SqlDbType.Int;
                    IDTeam.Value = int.Parse(id);

                    cmd.Parameters.Add(IDTeam);

                    connection.Open();
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.HasRows)
                    {
                        while (dr.Read())
                        {
                            team.IDTeam = dr.GetInt32(0);
                            team.Title = dr.GetString(1);
                            team.DateOfCreation = dr.GetString(2);
                            team.TeamLeaderID = dr.GetInt32(3);
                            team.IsActive = dr.GetBoolean(4);
                            teamLeader = dr.GetString(5);
                        }
                    }
                }
            }
            catch
            {
                ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Ne može se dohvatiti tim...');", true);
            }
        }

        private void GetEmployees()
        {
            try
            {
                teamMembers = new ArrayList();

                using (SqlConnection sqlConnection = new SqlConnection(cs))
                {
                    string spName = "spSelectTeamMembers";
                    SqlCommand cmd = new SqlCommand(spName, sqlConnection);
                    SqlParameter IDTeam = new SqlParameter();
                    IDTeam.ParameterName = "@IDTeam";
                    IDTeam.SqlDbType = SqlDbType.Int;
                    IDTeam.Value = team.IDTeam;

                    cmd.Parameters.Add(IDTeam);

                    sqlConnection.Open();
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.HasRows)
                    {
                        while (dr.Read())
                        {
                            teamMembers.Add(new Worker(dr.GetString(0), dr.GetString(1)));
                        }
                    }
                }
            }
            catch
            {
                ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Ne mogu se dohvatiti zaposlenici...');", true);
            }
        }

        private void FillFields()
        {
            txaEmployees.Text = string.Empty;
            txtTeamName.Text = team.Title;
            txtTeamLeader.Text = teamLeader;
            for (int i = 0; i < teamMembers.Count; i++)
            {
                if (i == (teamMembers.Count - 1))
                    txaEmployees.Text += $"{teamMembers[i] as Worker}";
                else
                    txaEmployees.Text += $"{teamMembers[i] as Worker}, ";
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string spName = "spUpdateTeam";
            string[] name = txtTeamLeader.Text.Split(' ');
            if (name.Length <= 1) return;
            int teamLeaderID = PrepareTeamLeader(name);
            if (teamLeaderID == -1)
            {
                txtTeamLeader.Text = "Osoba ne postoji...";
                return;
            }
            try
            {
                using (SqlConnection sqlConnection = new SqlConnection(cs))
                using (SqlCommand cmd = new SqlCommand(spName, sqlConnection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@IDTeam", SqlDbType.Int).Value = team.IDTeam;
                    cmd.Parameters.Add("@Title", SqlDbType.NVarChar).Value = txtTeamName.Text;
                    cmd.Parameters.Add("@DateOfCreation", SqlDbType.NVarChar).Value = team.DateOfCreation;
                    cmd.Parameters.Add("@TeamLeaderID", SqlDbType.Int).Value = teamLeaderID;
                    cmd.Parameters.Add("@IsActive", SqlDbType.Bit).Value = 1;

                    sqlConnection.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch
            {
                ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Greška...');", true);
            }
            UpdateEmployees();

            Clean();
            Setup();
        }

        private int PrepareTeamLeader(string[] name)
        {
            GetWorker(name);
            if (worker.IDWorker == 0) return -1;
            if (worker.IsTeamLeader)
            {
                AddTeamLeader("spAddExistingTeamLeader");
                return worker.IDWorker;
            }
            else
            {
                worker.IsTeamLeader = true;
                AddTeamLeader("spAddNewTeamLeader");
                return worker.IDWorker;
            }
        }

        private void AddTeamLeader(string spName)
        {
            try
            {
                using (SqlConnection sqlConnection = new SqlConnection(cs))
                using (SqlCommand cmd = new SqlCommand(spName, sqlConnection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@IDWorker", SqlDbType.Int).Value = worker.IDWorker;
                    cmd.Parameters.Add("@IDTeam", SqlDbType.Int).Value = team.IDTeam;

                    sqlConnection.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch
            {
                ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Nije moguće dodati voditelja tima...');", true);
            }
        }

        private void Clean()
        {
            txtTeamName.Text = string.Empty;
            txtTeamLeader.Text = string.Empty;
            txaEmployees.Text = string.Empty;
        }

        private void UpdateEmployees()
        {
            try
            {
                foreach (Worker worker in teamMembers)
                {
                    UpdateWorker(worker, -1);
                }
                GetNewMembers();
            }
            catch
            {
                ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('NIje moguće ažurirati zaposlene...');", true);
            }
        }

        private void GetNewMembers()
        {
            IList list = new ArrayList();
            string[] members = txaEmployees.Text.Split(',');
            for (int i = 0; i < members.Length; i++)
            {
                members[i] = members[i].Trim();
                string[] name = members[i].Split(' ');
                Debug.WriteLine(name.Length);
                if (name.Length >= 2)
                {
                    GetWorker(name);
                    if (worker.IDWorker != 0)
                        list.Add(worker);
                }
            }
            foreach (Worker worker in list)
            {
                UpdateWorker(worker, team.IDTeam);
            }
        }

        private void UpdateWorker(Worker worker, int teamID)
        {
            try
            {
                string spName = "spUpdateWorkerTeamID";
                using (SqlConnection sqlConnection = new SqlConnection(cs))
                using (SqlCommand cmd = new SqlCommand(spName, sqlConnection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    if (teamID == -1)
                        cmd.Parameters.Add("@IDTeam", SqlDbType.Int).Value = DBNull.Value;
                    else
                        cmd.Parameters.Add("@IDTeam", SqlDbType.Int).Value = teamID;
                    cmd.Parameters.Add("@FirstName", SqlDbType.NVarChar).Value = worker.FirstName;
                    cmd.Parameters.Add("@LastName", SqlDbType.NVarChar).Value = worker.LastName;

                    sqlConnection.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch
            {
                ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Nije moguće ažurirati zaposlenika...');", true);
            }
        }

        private void GetWorker(string[] teamLeader)
        {
            try
            {
                worker = new Worker();
                using (SqlConnection connection = new SqlConnection(cs))
                {
                    string spName = "spGetWorker";

                    SqlCommand cmd = new SqlCommand(spName, connection);
                    SqlParameter FirstName = new SqlParameter();
                    SqlParameter LastName = new SqlParameter();
                    FirstName.ParameterName = "@FirstName";
                    LastName.ParameterName = "@LastName";
                    FirstName.SqlDbType = SqlDbType.NVarChar;
                    LastName.SqlDbType = SqlDbType.NVarChar;
                    FirstName.Value = teamLeader[0];
                    LastName.Value = teamLeader[1];

                    cmd.Parameters.Add(FirstName);
                    cmd.Parameters.Add(LastName);

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
                }
            }
            catch
            {
                ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Nije moguće dohvatiti zaposlenika...');", true);
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            team = new Team();
            try
            {
                string spName = "spCreateTeam";
                string[] name = txtTeamLeader.Text.Split(' ');
                if (name.Length <= 1)
                    return;
                using (SqlConnection sqlConnection = new SqlConnection(cs))
                using (SqlCommand cmd = new SqlCommand(spName, sqlConnection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@IDTeam", SqlDbType.Int);
                    cmd.Parameters["@IDTeam"].Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("@Title", SqlDbType.NVarChar).Value = txtTeamName.Text;
                    cmd.Parameters.Add("@DateOfCreation", SqlDbType.NVarChar).Value = DateTime.UtcNow.Date.ToString("dd.MM.yyyy");
                    cmd.Parameters.Add("@IsActive", SqlDbType.Bit).Value = 1;

                    sqlConnection.Open();
                    cmd.ExecuteNonQuery();
                    team.IDTeam = Convert.ToInt32(cmd.Parameters["@IDTeam"].Value);
                }
                int teamLeaderID = PrepareTeamLeader(name);
                if (teamLeaderID == -1)
                {
                    txtTeamLeader.Text = "Osoba ne postoji...";
                    return;
                }
                SetTeamLeader(teamLeaderID);
                GetNewMembers();
            }
            catch
            {
                ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Greška...');", true);
                return;
            }
            Clean();
            Setup();
        }

        private void SetTeamLeader(int teamLeaderID)
        {
            try
            {
                string spName = "spSetTeamLeaderID";
                using (SqlConnection sqlConnection = new SqlConnection(cs))
                using (SqlCommand cmd = new SqlCommand(spName, sqlConnection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@IDTeam", SqlDbType.Int).Value = team.IDTeam;
                    cmd.Parameters.Add("@TeamLeaderID", SqlDbType.Int).Value = teamLeaderID;

                    sqlConnection.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch
            {
                ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Nije moguće postaviti voditelja tima...');", true);
            }
        }
    }
}