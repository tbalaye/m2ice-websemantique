using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml.Linq;
using System.IO;

namespace SearchEngine.Model.Comparison
{
    class Comparator
    {
        public Dictionary<string, Qrel> Queries { get; private set; }

        private string AppPath = System.AppDomain.CurrentDomain.BaseDirectory;

        public Comparator()
        {
            Queries = new Dictionary<string, Qrel>();

            LoadQrels();
        }

        private void LoadQrels()
        {
            // Loading queries from XML file
            XDocument xdoc = XDocument.Load(AppPath + "Queries\\queries.xml");
            Dictionary<string, string> queries = new Dictionary<string, string>();
            foreach (var elt in (from query in xdoc.Descendants("query") select query))
            {
                queries.Add(elt.Attribute("id").Value, (elt.FirstNode as XElement).Value);
            }

            // Loading qrels from TXT file
            foreach (KeyValuePair<string, string> query in queries)
            {
                List<QrelLine> qrelLines = new List<QrelLine>();
                try
                {
                    using (StreamReader sr = new StreamReader(AppPath + "qrels\\qrel" + query.Key.Substring(1, 2) + ".txt"))
                    {
                        while (!sr.EndOfStream)
                        {
                            string[] line = sr.ReadLine().Split('	');
                            if (line[2].Trim().Equals("1"))
                            {
                                qrelLines.Add(new QrelLine("./" + line[0], line[1], -1));
                            }
                        }
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine("The file could not be read:\n" + e.Message);
                }
                Queries.Add(query.Value, new Qrel(qrelLines));
            }
        }

        public string CompareWithQrel(Search search)
        {
            int found = 0, diff = 0;
            string query = search.Query.OriginalQuery;
            string qrelResult = "";
            if (Queries.ContainsKey(query))
            {
                Qrel qrel = Queries[query];
                foreach (QrelLine qrelLine in search.ResultList)
                {
                    if (qrel.Lines.Contains(qrelLine))
                    {
                        found += 1;
                    }
                    else
                    {
                        diff += 1;
                    }
                }
                qrelResult = "Trouvé : " + found + "/" + qrel.Lines.Count + " - Résultats supplémentaires : " + diff;
            }
            else
            {
                qrelResult = "Pas de Qrel associée à ces critères";
            }
            return "Total : " + search.ResultList.Count + " - " + qrelResult;
        }
    }
}
