using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MainProject.Models
{
    public class Project
    {
        public int IDProject { get; set; }
        public string Title { get; set; }
        public int ClinetID { get; set; }
        public string DateOfStart { get; set; }
        public int ProjectLeaderID { get; set; }
        public bool IsActive { get; set; }
    }
}