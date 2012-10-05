using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SearchEngine.Model
{
    class Term
    {
        public int IdTerm { get; private set; }
        public string Label { get; private set; }
        public string Word { get; private set; }

        public Term(int idTerm, string word, string label)
        {
            IdTerm = idTerm;
            Word = word;
            Label = label;

        }
    }
}
