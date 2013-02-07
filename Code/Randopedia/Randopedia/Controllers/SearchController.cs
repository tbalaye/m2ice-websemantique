using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace Randopedia.Controllers
{
    public class SearchController : Controller
    {
        //
        // GET: /Search/
        //
        public ActionResult Index()
        {
            ViewBag.Result = "";
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
            string json = new WebClient().DownloadString("http://172.31.190.56:4567/search/" + SearchString);

            Result res = JsonConvert.DeserializeObject<Result>(json);
            ViewBag.Request = res.Request;
            ViewBag.Precision = res.Precision;
            ViewBag.Rappel = res.Rappel;
            ViewBag.Results = res.Results;

            if (Request.IsAjaxRequest())
            {
                ViewBag.Result = Regex.Split(SearchString, @"[ ]+");
                return PartialView("PartialSearch");
            }
            else
            {
                ViewBag.Result = "";
                return View("Index");
            }
        }
    }
}
