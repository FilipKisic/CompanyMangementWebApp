using MainProject.Models;
using System;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MainProject.SitesProject
{
    public partial class ProjectAddUpdate : System.Web.UI.Page
    {
        private static readonly string cs = System.Configuration.ConfigurationManager.ConnectionStrings["cs"].ConnectionString;
        private static Project project;
        private GridViewRow current;
        private string client;
        private string projectLeader;
        private static IList teams;
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
            foreach (GridViewRow row in Projects.Rows)
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
            SqlDataSource sqlDataSource = new SqlDataSource(cs, "spSelectActiveProjects");
            sqlDataSource.SelectCommandType = SqlDataSourceCommandType.StoredProcedure;
            Projects.DataSource = sqlDataSource;
            Projects.DataBind();
        }

        protected void btnSelect_Click(object sender, EventArgs e)
        {
            int rowIndex = ((GridViewRow)(sender as Control).NamingContainer).RowIndex;
            current = Projects.Rows[rowIndex];
            GetProject(current.Cells[0].Text);
            GetTeams(current.Cells[0].Text);
            FillFields();
        }

        private void GetTeams(string id)
        {
            try
            {
                teams = new ArrayList();
                using (SqlConnection connection = new SqlConnection(cs))
                {
                    string spName = "spSelectTeamsInProject";

                    SqlCommand cmd = new SqlCommand(spName, connection);
                    SqlParameter IDProject = new SqlParameter();
                    IDProject.ParameterName = "@IDProject";
                    IDProject.SqlDbType = SqlDbType.Int;
                    IDProject.Value = int.Parse(id);

                    cmd.Parameters.Add(IDProject);

                    connection.Open();
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.HasRows)
                    {
                        while (dr.Read())
                        {
                            teams.Add(new Team(dr.GetInt32(0), dr.GetString(1)));
                        }
                    }
                }
            }
            catch
            {
                ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Nije uspjelo dohvaćanje timova...');", true);
            }
        }

        private void GetProject(string id)
        {
            try
            {
                project = new Project();
                using (SqlConnection connection = new SqlConnection(cs))
                {
                    string spName = "spSelectProject";

                    SqlCommand cmd = new SqlCommand(spName, connection);
                    SqlParameter IDProject = new SqlParameter();
                    IDProject.ParameterName = "@IDProject";
                    IDProject.SqlDbType = SqlDbType.Int;
                    IDProject.Value = int.Parse(id);

                    cmd.Parameters.Add(IDProject);

                    connection.Open();
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.HasRows)
                    {
                        while (dr.Read())
                        {
                            project.IDProject = dr.GetInt32(0);
                            project.Title = dr.GetString(1);
                            project.ClinetID = dr.GetInt32(2);
                            client = dr.GetString(3);
                            project.DateOfStart = dr.GetString(4);
                            project.ProjectLeaderID = dr.GetInt32(5);
                            projectLeader = dr.GetString(6);
                            project.IsActive = true;
                        }
                    }
                }
            }
            catch
            {
                ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Nije uspjelo dohvaćanje projekta...');", true);
            }
        }

        private void FillFields()
        {
            txaTeams.Text = string.Empty;
            txtProjectTitle.Text = project.Title;
            txtClient.Text = client;
            txtDateOfStart.Text = project.DateOfStart;
            txtProjectLeader.Text = projectLeader;
            for (int i = 0; i < teams.Count; i++)
            {
                if (i == (teams.Count - 1))
                    txaTeams.Text += $"{(teams[i] as Team).Title}";
                else
                    txaTeams.Text += $"{(teams[i] as Team).Title}, ";
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string spName = "spUpdateProject";
            string[] name = txtProjectLeader.Text.Split(' ');
            if (name.Length <= 1) return;
            int clientID = PrepareClient();
            int projectLeaderID = PrepareProjectLeader(name);
            teams = PrepareTeams("update");
            try
            {
                foreach (Team team in teams)
                {
                    LinkTeamWtihProject(team);
                }
                if (clientID == -1)
                {
                    txtClient.Text = "Klijent ne postoji...";
                    txtClient.Focus();
                    return;
                }
                if (projectLeaderID == -1)
                {
                    txtProjectLeader.Text = "Osoba ne postoji...";
                    txtProjectLeader.Focus();
                    return;
                }

                using (SqlConnection sqlConnection = new SqlConnection(cs))
                using (SqlCommand cmd = new SqlCommand(spName, sqlConnection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@IDProject", SqlDbType.Int).Value = project.IDProject;
                    cmd.Parameters.Add("@Title", SqlDbType.NVarChar).Value = txtProjectTitle.Text;
                    cmd.Parameters.Add("@ClientID", SqlDbType.Int).Value = clientID;
                    cmd.Parameters.Add("@DateOfStart", SqlDbType.NVarChar).Value = txtDateOfStart.Text;
                    cmd.Parameters.Add("@ProjectLeaderID", SqlDbType.Int).Value = projectLeaderID;
                    cmd.Parameters.Add("@IsActive", SqlDbType.Bit).Value = 1;

                    sqlConnection.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch
            {
                ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Greška...');", true);
            }
            Clean();
            Setup();
        }

        private void LinkTeamWtihProject(Team team)
        {
            string spName = "spLinkProjectAndTeam";
            try
            {
                using (SqlConnection sqlConnection = new SqlConnection(cs))
                using (SqlCommand cmd = new SqlCommand(spName, sqlConnection))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@IDProject", project.IDProject);
                    Debug.WriteLine(team.IDTeam);
                    cmd.Parameters.AddWithValue("@IDTeam", team.IDTeam);

                    sqlConnection.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            catch
            {
                ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Nije uspjelo...');", true);
            }
        }

        private IList PrepareTeams(string operation)
        {
            if (operation == "update" && teams != null)
            {
                foreach (Team team in teams)
                {
                    UnlinkTeamsWithProject(team);
                }
                teams.Clear();
            }
            IList list = new ArrayList();
            string[] teamNames = txaTeams.Text.Split(',');
            int teamID;
            for (int i = 0; i < teamNames.Length; i++)
            {
                teamNames[i] = teamNames[i].Trim();
                teamID = CheckTeam(teamNames[i]);
                if (teamID != -1)
                    list.Add(new Team(teamID, teamNames[i]));
            }
            return list;
        }

        private void UnlinkTeamsWithProject(Team team)
        {
            string spName = "spUnlinkProjectAndTeam";
            using (SqlConnection sqlConnection = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(spName, sqlConnection))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@IDProject", project.IDProject);
                Debug.WriteLine(team.IDTeam);
                cmd.Parameters.AddWithValue("@IDTeam", team.IDTeam);

                sqlConnection.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private int CheckTeam(string teamName)
        {
            string spName = "spCheckIfTeamExists";
            using (SqlConnection sqlConnection = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(spName, sqlConnection))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Title", teamName);
                cmd.Parameters.Add("@IDTeam", SqlDbType.Int);
                cmd.Parameters["@IDTeam"].Direction = ParameterDirection.Output;

                sqlConnection.Open();
                cmd.ExecuteNonQuery();
                return Convert.ToInt32(cmd.Parameters["@IDTeam"].Value);
            }
        }

        private void Clean()
        {
            txtProjectTitle.Text = string.Empty;
            txtClient.Text = string.Empty;
            txtDateOfStart.Text = string.Empty;
            txtProjectLeader.Text = string.Empty;
            txaTeams.Text = string.Empty;
        }

        private int PrepareProjectLeader(string[] name)
        {
            string spName = "spCheckIfProjectLeaderExists";
            using (SqlConnection sqlConnection = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(spName, sqlConnection))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@FirstName", name[0]);
                cmd.Parameters.AddWithValue("@LastName", name[1]);
                cmd.Parameters.Add("@IDWorker", SqlDbType.Int);
                cmd.Parameters["@IDWorker"].Direction = ParameterDirection.Output;

                sqlConnection.Open();
                cmd.ExecuteNonQuery();
                return Convert.ToInt32(cmd.Parameters["@IDWorker"].Value);
            }
        }

        private int PrepareClient()
        {
            string spName = "spCheckIfClientExists";
            using (SqlConnection sqlConnection = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(spName, sqlConnection))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Title", txtClient.Text.Trim());
                cmd.Parameters.Add("@IDClient", SqlDbType.Int);
                cmd.Parameters["@IDClient"].Direction = ParameterDirection.Output;

                sqlConnection.Open();
                cmd.ExecuteNonQuery();
                return Convert.ToInt32(cmd.Parameters["@IDClient"].Value);
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            project = new Project();
            string spName = "spCreateProject";
            string[] name = txtProjectLeader.Text.Split(' ');
            if (name.Length <= 1) return;
            int clientID = PrepareClient();
            int projectLeaderID = PrepareProjectLeader(name);
            if (clientID == -1)
            {
                txtClient.Text = "Klijent ne postoji...";
                txtClient.Focus();
                return;
            }
            if (projectLeaderID == -1)
            {
                txtProjectLeader.Text = "Osoba ne postoji...";
                txtProjectLeader.Focus();
                return;
            }

            using (SqlConnection sqlConnection = new SqlConnection(cs))
            using (SqlCommand cmd = new SqlCommand(spName, sqlConnection))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@IDProject", SqlDbType.Int);
                cmd.Parameters["@IDProject"].Direction = ParameterDirection.Output;
                cmd.Parameters.Add("@Title", SqlDbType.NVarChar).Value = txtProjectTitle.Text;
                cmd.Parameters.Add("@ClientID", SqlDbType.Int).Value = clientID;
                cmd.Parameters.Add("@DateOfStart", SqlDbType.NVarChar).Value = txtDateOfStart.Text;
                cmd.Parameters.Add("@ProjectLeaderID", SqlDbType.Int).Value = projectLeaderID;
                cmd.Parameters.Add("@IsActive", SqlDbType.Bit).Value = 1;

                sqlConnection.Open();
                cmd.ExecuteNonQuery();
                project.IDProject = Convert.ToInt32(cmd.Parameters["@IDProject"].Value);
            }
            teams = PrepareTeams("insert");
            foreach (Team team in teams)
            {
                LinkTeamWtihProject(team);
            }
            Clean();
            Setup();
        }
    }
}