using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SearchEngine.Model
{
    class Search
    {
        private Query Query;
        public string Result { get; private set; }

        public Search(Query query)
        {
            Query = query;
            Result = "";

            Connector conn = new Connector();

            foreach (KeyValuePair<string, Term> term in Query.Terms)
            {
                List<Paragraph> paragraphs = conn.GetParagraph(term.Value.IdTerm);

                Result += "For term : " + term.Value.Word + " (total: " + paragraphs.Count + ")\n";

                foreach (Paragraph paragraph in paragraphs)
                {
                    Result += (paragraph.Parent.Path + " - " + paragraph.Xpath + " - " + paragraph.TermWeight + "\n");
                }
            }
        }
    }
}
