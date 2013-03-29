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
using System.Text;

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
        public ActionResult SearchRando(string SearchString, bool SearchMode, bool SearchDetail)
        {
            ViewBag.Result = new Result();
            ViewBag.IsSearch = false;
            ViewBag.DetailedSearch = SearchDetail;

            if (SearchString.Trim() != "")
            {
                string json = "";
                string url = ConfigurationManager.AppSettings["SearchServer"];
                string searchPath = ConfigurationManager.AppSettings["SearchPath"];
                string searchOntologyPath = ConfigurationManager.AppSettings["SearchOntologyPath"];
                url += (SearchMode) ? (searchOntologyPath) : (searchPath);

                try
                {
                    WebClient webClient = new WebClient();
                    webClient.Encoding = Encoding.UTF8;
                    json = webClient.DownloadString(url + SearchString);
                }
                catch (WebException ex)
                {
                    ViewBag.Error = ex.Message;
                    ViewBag.SearchServer = url;
                }
                JsonSerializerSettings settings = new JsonSerializerSettings();

                ViewBag.Result = JsonConvert.DeserializeObject<Result>(json);
                ViewBag.IsSearch = true;
                ViewBag.DetailedSearch = SearchDetail;
                ViewBag.SearchOntology = SearchMode;
            }

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
