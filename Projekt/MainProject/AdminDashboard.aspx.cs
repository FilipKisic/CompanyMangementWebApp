using System;

namespace MainProject
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.Cookies["loginData"] == null)
                Response.Redirect("LoginPage.aspx");
        }
    }
}