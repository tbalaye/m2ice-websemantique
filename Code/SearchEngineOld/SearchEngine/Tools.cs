using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SearchEngine
{
    class Tools
    {
        public static String ToLabel(string word)
        {
            return (word.Length > 6) ? (word.Substring(0, 6)) : (word);
        }
    }
}
