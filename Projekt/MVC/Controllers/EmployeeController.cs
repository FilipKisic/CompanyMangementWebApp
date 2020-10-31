using MVC.Models;
using System.Diagnostics;
using System.Web;
using System.Web.Mvc;

namespace MVC.Controllers
{
    public class EmployeeController : Controller
    {
        private static HttpCookie cookie;
        public ActionResult ShowAll()
        {
            cookie = Request.Cookies["loginData"];
            if(cookie != null)
            {
                ViewBag.workerid = int.Parse(cookie["id"]);
                return View(Repository.GetProjects(int.Parse(cookie["id"])));
            }
            return null;
        }

        public ActionResult Select(int id, int workerId)
        {
            Activity activity = Repository.GetActivity(id, workerId);
            var model = new
            {
                activityName = activity.ActivityName,
                durationInMinutes = activity.DurationInMinutes,
                personalDurationInMinutes = activity.PersonalDurationInMinutes
            };
            return Json(model, JsonRequestBehavior.AllowGet);
        }

        //2. create action method which calls method from repo
        public ActionResult UpdateHours(int activityId, int workerId, int personalDurationSum)
        {
            Repository.UpdatePersonalHours(activityId, workerId, personalDurationSum);
            return RedirectToAction("ShowAll");
        }
    }
}