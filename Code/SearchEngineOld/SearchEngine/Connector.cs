using System;
using System.Collections.Generic;
using System.Text;
using MySql.Data.MySqlClient;
using System.Data;
using SearchEngine.Model;
using SearchEngine.Model.Persistence;

namespace SearchEngine
{
    class Connector
    {
        string MyConString = "SERVER=localhost;" +
            "DATABASE=websemantique;" +
            "UID=websemantique;" +
            "PASSWORD=websemantique;" +
            "Allow User Variables=True;";

        MySqlConnection connection;
        MySqlCommand command;

        public Connector() {
            connection = new MySqlConnection(MyConString);
            command = connection.CreateCommand();
        }

        /// <summary>
        /// Get term from MySQL database
        /// </summary>
        /// <param name="word"></param>
        /// <returns>Term object</returns>
        public Term GetTerm(string word)
        {
            string label = Tools.ToLabel(word);
            int idTerm = -1;
            command.CommandText = "SELECT idTerm FROM Term WHERE Label='" + label + "';";
            try
            {
                connection.Open();
                MySqlDataReader Reader = command.ExecuteReader();
                if (Reader.HasRows)
                {
                    Reader.Read();
                    idTerm = Int32.Parse(Reader.GetValue(0).ToString());
                }
                Reader.Close();
                connection.Close();
            }
            catch (MySqlException ex)
            {
                Console.WriteLine(ex.Message);
            }
            return new Term(idTerm, word, label);
        }

        /// <summary>
        /// Get paragraph from MySQL database
        /// </summary>
        /// <param name="idTerm"></param>
        /// <returns>Paragraph list</returns>
        public List<Paragraph> GetParagraph(List<Term> terms)
        {
            Int32 inc;
            List<Paragraph> paragraphs = new List<Paragraph>();

            if (terms.Count > 0)
            {
                // Building Contain request part
                StringBuilder requestContain = new StringBuilder();
                requestContain.Append("(select (weight * @weight) as weight, idParagraph, idTerm from contain where ");
                inc = 1;
                foreach (Term term in terms)
                {
                    requestContain.Append("(idterm = " + term.IdTerm + " and @weight := " + 1.0 + ") ");
                    if (inc < terms.Count)
                    {
                        requestContain.Append("or ");
                        inc += 1;
                    }
                }
                requestContain.Append(")");

                // Building main request
                StringBuilder request = new StringBuilder();
                request.Append("set @weight:=0;");
                request.Append("select par.xpath, doc.pathFile, sum(terw.weight) as weight ");
                request.Append("from ");
                request.Append("contain con, ");
                request.Append("document doc, ");
                request.Append("paragraph par, ");
                request.Append(requestContain.ToString() + " terw ");
                request.Append("where ");
                request.Append("terw.idParagraph = con.idParagraph and ");
                request.Append("par.idDocument = doc.idDocument and ");
                request.Append("par.idParagraph = con.idParagraph and ");
                request.Append("(");
                inc = 1;
                foreach (Term term in terms)
                {
                    request.Append("con.idTerm = " + term.IdTerm + " ");
                    if (inc < terms.Count)
                    {
                        request.Append("or ");
                        inc += 1;
                    }
                }
                request.Append(") ");
                request.Append("group by con.idParagraph ");
                request.Append("order by con.idParagraph desc;");

                command.CommandText = request.ToString();

                try
                {
                    connection.Open();
                    MySqlDataReader Reader = command.ExecuteReader();
                    while (Reader.Read())
                    {
                        paragraphs.Add(new Paragraph(Reader.GetValue(0).ToString(), new Document(Reader.GetValue(1).ToString()), Double.Parse(Reader.GetValue(2).ToString())));
                    }
                    Reader.Close();
                    connection.Close();
                }
                catch (MySqlException ex)
                {
                    Console.WriteLine(ex.Message);
                }
            }
            return paragraphs;
        }

        
    }
}
