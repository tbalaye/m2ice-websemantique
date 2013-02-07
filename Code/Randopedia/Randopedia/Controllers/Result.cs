using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Randopedia.Controllers
{
    public class Result
    {
        public string Request { get; set; }
        public string Precision { get; set; }
        public string Rappel { get; set; }
        public ResultLine[] Results { get; set; }
    }
}
