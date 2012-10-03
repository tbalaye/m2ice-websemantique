using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SearchEngine.Model
{
    class Search
    {
        private Query Query;

        public Search(Query query)
        {
            Query = query;

            Connector conn = new Connector();

            List<int> paragraphId = conn.GetParagraphId(Query.Terms.First().Value);
            foreach (int pId in paragraphId)
            {
                Console.Write(pId + " ; ");
            }
        }
    }
}
