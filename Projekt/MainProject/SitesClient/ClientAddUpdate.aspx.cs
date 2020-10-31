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

namespace MainProject.SitesClient
{
    public partial class ClientAddUpdate : System.Web.UI.Page
    {
        private static readonly string cs = System.Configuration.ConfigurationManager.ConnectionStrings["cs"].ConnectionString;
        private static Client client;
        private GridViewRow current;
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
            foreach (GridViewRow row in Clients.Rows)
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
            SqlDataSource sqlDataSource = new SqlDataSource(cs, "spSelectActiveClients");
            sqlDataSource.SelectCommandType = SqlDataSourceCommandType.StoredProcedure;
            Clients.DataSource = sqlDataSource;
            Clients.DataBind();
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
                    SqlDataReader dr = cmd.ExecuteReader();

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

        protected void btnSelect_Click(object sender, EventArgs e)
        {
            int rowIndex = ((GridViewRow)(sender as Control).NamingContainer).RowIndex;
            current = Clients.Rows[rowIndex];
            GetClient(current.Cells[0].Text);
            FillFields();
        }

        private void FillFields()
        {
            txtClientName.Text = client.Title;
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            string spName = "spUpdateClient";
            try
            {
                using (SqlConnection sqlConnection = new SqlConnection(cs))
                using (SqlCommand sqlUpdate = new SqlCommand(spName, sqlConnection))
                {
                    sqlUpdate.CommandType = CommandType.StoredProcedure;
                    sqlUpdate.Parameters.Add("@IDClient", SqlDbType.Int).Value = client.IDClient;
                    sqlUpdate.Parameters.Add("@Title", SqlDbType.NVarChar).Value = txtClientName.Text;
                    sqlUpdate.Parameters.Add("@IsActive", SqlDbType.Bit).Value = 1;
                    sqlConnection.Open();
                    sqlUpdate.ExecuteNonQuery();
                }
                txtClientName.Text = string.Empty;
                Setup();
            } catch (Exception ex)
            {
                Debug.WriteLine(ex.StackTrace);
                ClientScript.RegisterStartupScript(GetType(), "myalert", "alert('Nije uspjelo...');", true);
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            string spName = "spCreateClient";
            using (SqlConnection sqlConnection = new SqlConnection(cs))
            using (SqlCommand sqlCreate = new SqlCommand(spName, sqlConnection))
            {
                sqlCreate.CommandType = CommandType.StoredProcedure;
                sqlCreate.Parameters.Add("@Title", SqlDbType.NVarChar).Value = txtClientName.Text;
                sqlCreate.Parameters.Add("@IsActive", SqlDbType.Bit).Value = 1;
                sqlConnection.Open();
                sqlCreate.ExecuteNonQuery();
            }
            txtClientName.Text = string.Empty;
            Setup();
        }
    }
}