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

        private double precision;
        public double Precision
        {
            get
            {
                return precision;
            }
            set
            {
                precision = value;
            }
        }

        private double rappel;
        public double Rappel
        {
            get
            {
                return rappel;
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

        private string timeCompute;
        /// <summary>
        /// Temps d'exécution de la recherche côté serveur
        /// </summary>
        public string TimeCompute
        {
            get
            {
                return (timeCompute == null) ? ("") : (timeCompute);
            }
            set
            {
                timeCompute = value;
            }
        }
    }
}
