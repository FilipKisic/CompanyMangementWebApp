using MainProject.Models;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Web;

namespace MainProject
{
    public partial class LoginPage : System.Web.UI.Page
    {
        private static readonly string cs = System.Configuration.ConfigurationManager.ConnectionStrings["cs"].ConnectionString;
        private static Worker worker;
        protected void Page_Load(object sender, EventArgs e)
        {
            HttpCookie cookie = Request.Cookies["loginData"];
            if (Request.Cookies["loginData"] != null && cookie["isCEO"] == "True")
                Response.Redirect("AdminDashboard.aspx");
            else if (Request.Cookies["loginData"] != null && cookie["isTeamLeader"] == "True")
                Response.Redirect("TeamLeaderDashboard.aspx");
            else if (Request.Cookies["loginData"] != null)
                Response.Redirect("http://localhost:54921/");
            else
                txtUsername.Focus();
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (ValidatePass())
            {
                if (worker.IsActive)
                {
                    HttpCookie cookie = new HttpCookie("loginData");
                    cookie["username"] = txtUsername.Text;
                    cookie["password"] = txtPassword.Text;
                    cookie["id"] = worker.IDWorker.ToString();
                    cookie["isTeamLeader"] = worker.IsTeamLeader.ToString();
                    cookie["isCEO"] = worker.IsCEO.ToString();
                    cookie.Expires = DateTime.Now.AddHours(12);
                    Response.Cookies.Add(cookie);
                    
                    Redirect();
                }
            }
        }

        private void Redirect()
        {
            if (worker.IsCEO)
                Response.Redirect("AdminDashboard.aspx");
            else if (worker.IsTeamLeader)
                Response.Redirect("TeamLeaderDashboard.aspx");
            else
                Response.Redirect("http://localhost:54921/");
        }

        private bool ValidatePass()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(cs))
                {
                    string spName = "spValidateWorker";
                    worker = new Worker();
                    SqlCommand cmd = new SqlCommand(spName, conn);
                    SqlParameter username = new SqlParameter();
                    SqlParameter password = new SqlParameter();
                    username.ParameterName = "@Email";
                    password.ParameterName = "@PSWRD";
                    username.SqlDbType = password.SqlDbType = SqlDbType.NVarChar;
                    username.Value = txtUsername.Text;
                    password.Value = txtPassword.Text;

                    cmd.Parameters.Add(username);
                    cmd.Parameters.Add(password);

                    conn.Open();

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
                            worker.PSWRD = dr.GetString(4);
                            worker.TypeOfEmployee = dr.GetString(5);
                            worker.IsActive = dr.GetBoolean(6);
                            worker.IsTeamLeader = dr.GetBoolean(7);
                            worker.IsCEO = dr.GetBoolean(8);
                            return true;
                        }
                    }
                    else
                    {
                        Error.Text = "Korisnik ne postoji.";
                        return false;
                    }
                }
            }
            catch (Exception e)
            {
                Debug.WriteLine(e.Message);
                Clean();
                Error.Text = "Greška";
            }
            return false;
        }

        private void Clean()
        {
            txtUsername.Text = string.Empty;
            txtPassword.Text = string.Empty;
            txtUsername.Focus();
        }
    }
}