using MainProject.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MainProject.SitesReports
{
    public partial class TeamReports : System.Web.UI.Page
    {
        private static readonly string cs = System.Configuration.ConfigurationManager.ConnectionStrings["cs"].ConnectionString;
        private static Team team;
        private GridViewRow current;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Cookies["loginData"] == null)
                Response.Redirect("../LoginPage.aspx");
            if (!IsPostBack)
                Setup();
        }

        private void Setup()
        {
            FetchData();
            foreach(GridViewRow row in Teams.Rows)
            {
                SetButton(row);
            }
            btnExport.Enabled = false;
        }

        private void SetButton(GridViewRow row)
        {
            Button btn = (Button)row.FindControl("btnSelect");
            btn.Text = "Odaberi";
            btn.BackColor = Color.FromArgb(99, 176, 255);
        }

        private void FetchData()
        {
            HttpCookie cookie = Request.Cookies["loginData"];
            SqlDataSource sqlDataSource;
            if (cookie["isCEO"] == "True")
            {
                sqlDataSource = new SqlDataSource(cs, "spSelectTeamTitlesForCEO");
                sqlDataSource.SelectCommandType = SqlDataSourceCommandType.StoredProcedure;
                Teams.DataSource = sqlDataSource;
                Teams.DataBind();
            }
            else
            {
                sqlDataSource = new SqlDataSource(cs, "spSelectTeamTitles");
                sqlDataSource.SelectCommandType = SqlDataSourceCommandType.StoredProcedure;
                sqlDataSource.SelectParameters.Add("TeamLeaderID", DbType.Int32, cookie["id"]);
                Teams.DataSource = sqlDataSource;
                Teams.DataBind();
            }
        }

        protected void btnSelect_Click(object sender, EventArgs e)
        {
            int rowIndex = ((GridViewRow)(sender as Control).NamingContainer).RowIndex;
            current = Teams.Rows[rowIndex];
            GetTeam(current.Cells[0].Text);
            FillTable();
            btnExport.Enabled = true;
        }

        private void FillTable()
        {
            SqlDataSource sqlDataSource = new SqlDataSource(cs, "spSelectTeamWorkers");
            sqlDataSource.SelectCommandType = SqlDataSourceCommandType.StoredProcedure;
            sqlDataSource.SelectParameters.Add("TeamID", DbType.Int32, team.IDTeam.ToString());
            Employees.DataSource = sqlDataSource;
            Employees.DataBind();
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
                            team.IsActive = true;
                        }
                    }
                }
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.StackTrace);
            }
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            SQLDataToCSV.ExportToCSV(txtFileName.Text, "spSelectTeamWorkers", "@TeamID", team.IDTeam);
            ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Pohranjeno');", true);
        }
    }
}