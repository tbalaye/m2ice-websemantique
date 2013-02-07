using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SearchEngine.Model.Comparison
{
    class QrelLine
    {
        public String DocPath { get; private set; }
        public String XmlPath { get; private set; }
        public Double Relevance { get; set; }

        public QrelLine(String docPath, String xmlPath, Double relevance)
        {
            DocPath = docPath.Trim();
            XmlPath = xmlPath.Trim();
            Relevance = relevance;
        }

        public override Boolean Equals(Object obj)
        {
            // Check for null values and compare run-time types.
            if (obj == null || GetType() != obj.GetType())
                return false;

            QrelLine q = (QrelLine) obj;
            return (DocPath == q.DocPath) && (XmlPath == q.XmlPath);
        }
    }
}
