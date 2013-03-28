using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Randopedia.JSONObjects
{
    public class ResultLine
    {
        public string Xpath  { get; set; }
        public Boolean found { get; set; }
        public string Content { get; set; }
        public string pathFile { get; set; }
        public double weight { get; set; }
    }
}