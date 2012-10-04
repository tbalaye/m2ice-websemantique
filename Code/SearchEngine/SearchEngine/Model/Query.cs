using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SearchEngine.Model
{
    class Query
    {
        public Dictionary<string, Term> Terms { get; private set; }

        public Query(string query)
        {
            Connector conn = new Connector();
            Terms = new Dictionary<string, Term>();

            foreach (string word in query.Split(' '))
            {
                Term term = conn.GetTerm(word.ToLower());
                if(term.IdTerm != -1)
                {
                    Terms.Add(word, term);
                }
            }
        }
    }
}
