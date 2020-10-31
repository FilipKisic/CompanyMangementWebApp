using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Data;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace MainProject.SitesClient
{
    public partial class ClientSelectDeactivate : System.Web.UI.Page
    {
        private static GridViewRow current = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Cookies["loginData"] == null)
            {
                Response.Redirect("../LoginPage.aspx");
            }
            foreach (GridViewRow r in Clients.Rows)
            {
                InitButtons(r);
            }
        }

        protected void btnSelect_Click(object sender, EventArgs e)
        {
            int rowIndex = ((GridViewRow)(sender as Control).NamingContainer).RowIndex;
            current = Clients.Rows[rowIndex];
            current.Cells[2].Text = current.Cells[2].Text == "True" ? "False" : "True";
            InitButtons(current);

            string UpdateProcedure = "spUpdateClient";
            using(SqlConnection sqlConnection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["cs"].ConnectionString))
            using(SqlCommand sqlUpdate = new SqlCommand(UpdateProcedure, sqlConnection))
            {
                sqlUpdate.CommandType = CommandType.StoredProcedure;
                sqlUpdate.Parameters.Add("@IDClient", SqlDbType.Int).Value = current.Cells[0].Text;
                sqlUpdate.Parameters.Add("@Title", SqlDbType.NVarChar).Value = current.Cells[1].Text;
                sqlUpdate.Parameters.Add("@IsActive", SqlDbType.Bit).Value = current.Cells[2].Text;
                sqlConnection.Open();
                sqlUpdate.ExecuteNonQuery();
            }
        }

        private void InitButtons(GridViewRow r)
        {
            Button btn = (Button)r.FindControl("btnSelect");
            btn.Text = r.Cells[2].Text == "True" ? "Deaktiviraj" : "Aktiviraj";
            btn.BackColor = r.Cells[2].Text == "True" ? Color.FromArgb(202, 41, 41) : Color.FromArgb(3, 166, 60);
        }
    }
}