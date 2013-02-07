using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Configuration;
using Randopedia.JSONObjects;

namespace Randopedia.Controllers
{
    public class SearchController : Controller
    {
        //
        // GET: /Search/
        //
        public ActionResult Index()
        {
            ViewBag.Result = new Result();
            ViewBag.IsSearch = false;
            if (Request.IsAjaxRequest())
            {
                return PartialView("PartialSearch");
            }
            else
            {
                return View("Index");
            }
        }

        //
        // POST: /Search/SearchRando/
        //
        [HttpPost]
        public ActionResult SearchRando(string SearchString)
        {
            string json = "";
            string searchServer = ConfigurationManager.AppSettings["SearchServer"];
            try
            {
                json = new WebClient().DownloadString(searchServer + SearchString);
            }
            catch (WebException ex)
            {
                ViewBag.Error = ex.Message;
                ViewBag.SearchServer = searchServer;
            }
            ViewBag.Result = JsonConvert.DeserializeObject<Result>(json);
            ViewBag.IsSearch = true;

            if (Request.IsAjaxRequest())
            {
                return PartialView("PartialSearch");
            }
            else
            {
                return View("Index");
            }
        }
    }
}
