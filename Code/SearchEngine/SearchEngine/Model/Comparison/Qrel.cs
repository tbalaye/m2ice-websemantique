using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SearchEngine.Model.Comparison
{
    class Qrel
    {
        public List<QrelLine> Lines { get; private set; }

        public Qrel(List<QrelLine> lines)
        {
            Lines = lines;
        }
    }
}
