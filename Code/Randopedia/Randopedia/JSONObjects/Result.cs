using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Randopedia.JSONObjects
{
    /// <summary>
    /// Objet JSON permettant la communication avec le serveur back-end
    /// </summary>
    public class Result
    {
        // La recherche de l'utilisateur
        private string request;
        public string Request {
            get
            {
                return (request == null) ? ("") : (request);
            }
            set
            {
                request = value;
            }
        }

        private string precision;
        public string Precision {
            get
            {
                return (precision == null) ? ("") : (precision);
            }
            set
            {
                precision = value;
            }
        }

        private string rappel;
        public string Rappel {
            get
            {
                return (rappel == null) ? ("") : (rappel);
            }
            set
            {
                rappel = value;
            }
        }

        private ResultLine[] results;
        /// <summary>
        /// Chacun des résultats correspondant à la recherche
        /// </summary>
        public ResultLine[] Results {
            get
            {
                return (results == null) ? (new ResultLine[0]) : (results);
            }
            set
            {
                results = value;
            }
        }
    }
}
