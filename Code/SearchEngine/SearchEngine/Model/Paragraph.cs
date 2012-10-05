using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SearchEngine.Model
{
    class Paragraph
    {
        public string Xpath { get; private set; }
        public Document Parent { get; private set; }
        public double TermWeight { get; private set; }

        public Paragraph(string xpath, Document parent, double termWeight)
        {
            Xpath = xpath;
            Parent = parent;
            TermWeight = termWeight;
        }
    }
}
