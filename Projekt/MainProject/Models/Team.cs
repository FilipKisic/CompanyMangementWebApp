using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MainProject.Models
{
    public class Team
    {
        public int IDTeam { get; set; }
        public string Title { get; set; }
        public string DateOfCreation { get; set; }
        public int TeamLeaderID { get; set; }
        public bool IsActive { get; set; }

        public Team()
        {
        }

        public Team(int idTeam, string title)
        {
            IDTeam = idTeam;
            Title = title;
        }
    }
}