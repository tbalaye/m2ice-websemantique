using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SearchEngine.Model.Persistence
{
    class Document
    {
        public string Path { get; private set; }

        public Document(string path)
        {
            Path = path;
        }
    }
}
