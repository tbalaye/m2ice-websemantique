using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SearchEngine.Model.Comparison;
using SearchEngine.Model.Persistence;

namespace SearchEngine.Model
{
    class Search
    {
        public Query Query { get; private set; }
        public string Result { get; private set; }
        public List<QrelLine> ResultList { get; private set; }

        public Search(Query query)
        {
            Query = query;
            ResultList = new List<QrelLine>();
            Connector conn = new Connector();
            

            List<Paragraph> paragraphs = conn.GetParagraph(query.Terms.Values.ToList());
                
            foreach (Paragraph paragraph in paragraphs)
            {
                String path = paragraph.Parent.Path;
                String xpath = paragraph.Xpath;
                Double relevance = paragraph.Relevance;

                ResultList.Add(new QrelLine(path, xpath, relevance));
                
            }

            ResultList = ResultList.OrderByDescending(v => v.Relevance).ToList();
            
            StringBuilder result = new StringBuilder();
            foreach (QrelLine qrelLine in ResultList)
            {
                String path = qrelLine.DocPath;
                String xpath = qrelLine.XmlPath;
                Double relevance = qrelLine.Relevance;

                result.AppendLine("[" + relevance + "] " + path + " - " + xpath);
            }
            Result = result.ToString();
        }
    }
}
