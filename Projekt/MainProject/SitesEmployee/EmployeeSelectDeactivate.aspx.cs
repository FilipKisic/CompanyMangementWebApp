using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MainProject.SitesEmployee
{
    public partial class EmployeeSelectDeactivate : System.Web.UI.Page
    {
        private static GridViewRow current = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Cookies["loginData"] == null)
            {
                Response.Redirect("../LoginPage.aspx");
            }
            foreach (GridViewRow r in Employees.Rows)
            {
                InitButtons(r);
            }
        }

        protected void btnSelect_Click(object sender, EventArgs e)
        {
            int rowIndex = ((GridViewRow)(sender as Control).NamingContainer).RowIndex;
            current = Employees.Rows[rowIndex];
            current.Cells[5].Text = current.Cells[5].Text == "True" ? "False" : "True";
            InitButtons(current);

            string UpdateProcedure = "spUpdateWorkerStatus";
            using (SqlConnection sqlConnection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["cs"].ConnectionString))
            using (SqlCommand sqlUpdate = new SqlCommand(UpdateProcedure, sqlConnection))
            {
                sqlUpdate.CommandType = CommandType.StoredProcedure;
                sqlUpdate.Parameters.Add("@IsActive", SqlDbType.Bit).Value = current.Cells[5].Text;
                sqlUpdate.Parameters.Add("@Email", SqlDbType.NVarChar).Value = current.Cells[2].Text;
                sqlConnection.Open();
                sqlUpdate.ExecuteNonQuery();
            }
        }

        private void InitButtons(GridViewRow r)
        {
            Button btn = (Button)r.FindControl("btnSelect");
            btn.Text = r.Cells[5].Text == "True" ? "Deaktiviraj" : "Aktiviraj";
            btn.BackColor = r.Cells[5].Text == "True" ? Color.FromArgb(202, 41, 41) : Color.FromArgb(3, 166, 60);
        }
    }
}