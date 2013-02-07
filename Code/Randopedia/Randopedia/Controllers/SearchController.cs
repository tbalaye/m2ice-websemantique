using System;
using System.Collections.Generic;
using System.Linq;
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
