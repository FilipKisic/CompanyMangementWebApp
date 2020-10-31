using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MVC.Models
{
    public class Activity
    {
        public int IDActivity { get; set; }
        public string ActivityName { get; set; }
        public int DurationInMinutes { get; set; }
        public int ProjectID { get; set; }
        public int PersonalDurationInMinutes { get; set; }


    }
}