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

        private string nameQrel;
        public string NameQrel
        {
            get
            {
                return nameQrel;
            }
            set
            {
                nameQrel = value;
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

        private String[] termSimple;
        /// <summary>
        /// Termes saisis par l'utilisateur
        /// </summary>
        public String[] TermSimple
        {
            get
            {
                return termSimple;
            }
            set
            {
                termSimple = value;
            }
        }

        private String[] termSynonymes;
        /// <summary>
        /// Synonymes trouvés par l'ontologie
        /// </summary>
        public String[] TermSynonymes
        {
            get
            {
                return termSynonymes;
            }
            set
            {
                termSynonymes = value;
            }
        }

        private String[] termChildren;
        /// <summary>
        /// Fils trouvés par l'ontologie
        /// </summary>
        public String[] TermChildren
        {
            get
            {
                return termChildren;
            }
            set
            {
                termChildren = value;
            }
        }

        private String[] termInstances;
        /// <summary>
        /// Instances trouvées par l'ontologie
        /// </summary>
        public String[] TermInstances
        {
            get
            {
                return termInstances;
            }
            set
            {
                termInstances = value;
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
