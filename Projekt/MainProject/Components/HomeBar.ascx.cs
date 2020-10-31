using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MainProject.Components
{
    public partial class HomeBar : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            HttpCookie cookie = Request.Cookies["loginData"];
            if (cookie["isCEO"] == "True")
                homeLink.NavigateUrl = "../AdminDashboard.aspx";
            else if (cookie["isTeamLeader"] == "True")
                homeLink.NavigateUrl = "../TeamLeaderDashboard.aspx";
            else
                homeLink.NavigateUrl = "http://localhost:54921/";
        }
    }
}