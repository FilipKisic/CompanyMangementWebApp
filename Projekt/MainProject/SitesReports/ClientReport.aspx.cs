using MainProject.Models;
using System;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MainProject.SitesReports
{
    public partial class ClientReport : System.Web.UI.Page
    {
        private static readonly string cs = System.Configuration.ConfigurationManager.ConnectionStrings["cs"].ConnectionString;
        private static Client client;
        private GridViewRow current;
        private static SqlDataReader dr;        

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Cookies["loginData"] == null)
                Response.Redirect("../LoginPage.aspx");
            if (!IsPostBack)
                Setup();
        }

        protected void btnSelect_Click(object sender, EventArgs e)
        {
            int rowIndex = ((GridViewRow)(sender as Control).NamingContainer).RowIndex;
            current = Clients.Rows[rowIndex];
            GetClient(current.Cells[0].Text);
            FillTable();
            btnExport.Enabled = true;
        }

        private void FillTable()
        {
            SqlDataSource sqlDataSource = new SqlDataSource(cs, "spSelectClientsActivities");
            sqlDataSource.SelectCommandType = SqlDataSourceCommandType.StoredProcedure;
            sqlDataSource.SelectParameters.Add("ClientID", DbType.Int32, client.IDClient.ToString());
            Projects.DataSource = sqlDataSource;
            Projects.DataBind();
        }

        private void GetClient(string id)
        {
            try
            {
                client = new Client();
                using (SqlConnection connection = new SqlConnection(cs))
                {
                    string spName = "spSelectClient";

                    SqlCommand cmd = new SqlCommand(spName, connection);
                    SqlParameter IDClient = new SqlParameter();
                    IDClient.ParameterName = "@IDClient";
                    IDClient.SqlDbType = SqlDbType.Int;
                    IDClient.Value = int.Parse(id);

                    cmd.Parameters.Add(IDClient);

                    connection.Open();
                    cmd.CommandType = CommandType.StoredProcedure;
                    dr = cmd.ExecuteReader();

                    if (dr.HasRows)
                    {
                        while (dr.Read())
                        {
                            client.IDClient = dr.GetInt32(0);
                            client.Title = dr.GetString(1);
                        }
                    }
                }
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.StackTrace);
            }
        }

        private void Setup()
        {
            FetchData();
            foreach (GridViewRow row in Clients.Rows)
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
            SqlDataSource sqlDataSource = new SqlDataSource();
            sqlDataSource.ID = "sqlDataSource";
            Controls.Add(sqlDataSource);
            sqlDataSource.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["cs"].ConnectionString;
            sqlDataSource.SelectCommand = "SELECT IDClient, Title FROM Client WHERE IsActive = 1";
            Clients.DataSource = sqlDataSource;
            Clients.DataBind();
        }

        protected void btnExport_Click(object sender, EventArgs e)
        {
            SQLDataToCSV.ExportToCSV(txtFileName.Text, "spSelectClientsActivities", "@ClientID", client.IDClient);
            ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Pohranjeno');", true);
        }
    }
}