using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SearchEngine.Model
{
    class Query
    {
        public Dictionary<string, int> Terms { get; private set; }

        public Query(string query)
        {
            Connector conn = new Connector();
            Terms = new Dictionary<string, int>();

            foreach (string term in query.Split(' '))
            {
                string termTmp = term;

                if (termTmp.Length > 6)
                {
                    termTmp = termTmp.Substring(0, 6);
                }

                int termId = conn.GetTermId(termTmp.ToLower());
                if(termId != -1)
                {
                    Terms.Add(term, termId);
                }
            }
        }
    }
}
