using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SearchEngine.Model.Persistence
{
    class Paragraph
    {
        public string Xpath { get; private set; }
        public Document Parent { get; private set; }
        public double Relevance { get; private set; }

        public Paragraph(string xpath, Document parent, double relevance)
        {
            Xpath = xpath;
            Parent = parent;
            Relevance = relevance;
        }
    }
}
