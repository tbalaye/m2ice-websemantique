using System;
using System.Collections.Generic;
using System.Text;
using MySql.Data.MySqlClient;
using System.Data;
using SearchEngine.Model;

namespace SearchEngine
{
    class Connector
    {
        string MyConString = "SERVER=localhost;" +
            "DATABASE=websemantique;" +
            "UID=websemantique;" +
            "PASSWORD=websemantique;";

        MySqlConnection connection;
        MySqlCommand command;
        MySqlDataReader Reader;

        public Connector() {
            connection = new MySqlConnection(MyConString);
            command = connection.CreateCommand();
        }

        public String Query(string _query)
        {
            command.CommandText = _query;
            string result = "";
            connection.Open();

            try
            {
                Reader = command.ExecuteReader();

                while (Reader.Read())
                {
                    string row = "";
                    for (int i = 0; i < Reader.FieldCount; i++)
                    {
                        row = Reader.GetValue(i).ToString();
                    }
                    result += row + "\n";
                }
            }
            catch (MySqlException ex)
            {
                result = ex.Message;
            }
            connection.Close();

            return result;
        }

        public Term GetTerm(string word)
        {
            string label = word;

            if (label.Length > 6)
            {
                label = word.Substring(0, 6);
            }

            command.CommandText = "SELECT idTerm FROM Term WHERE Label='" + label + "';";
            int idTerm = -1;

            connection.Open();
            try
            {
                Reader = command.ExecuteReader();
                if (Reader.HasRows)
                {
                    Reader.Read();
                    idTerm = Int32.Parse(Reader.GetValue(0).ToString());
                }
            }
            catch (MySqlException ex)
            {
                Console.WriteLine(ex.Message);
            }
            connection.Close();

            return new Term(idTerm, word, label);
        }

        public List<Paragraph> GetParagraph(int idTerm)
        {
            //command.CommandText = "SELECT idParagraph FROM contain WHERE idTerm='" + idTerm + "';";
            command.CommandText = "SELECT p.xpath, d.pathFile, c.weight FROM Contain c, Paragraph p, Document d WHERE idTerm='" + idTerm + "' AND d.idDocument = p.idDocument AND c.idParagraph = p.idParagraph;";
            List<Paragraph> paragraphs = new List<Paragraph>();

            connection.Open();
            try
            {
                Reader = command.ExecuteReader();
                while (Reader.Read())
                {
                    paragraphs.Add(new Paragraph(Reader.GetValue(0).ToString(), new Document(Reader.GetValue(1).ToString()), Double.Parse(Reader.GetValue(2).ToString())));
                }
            }
            catch (MySqlException ex)
            {
                Console.WriteLine(ex.Message);
            }
            connection.Close();

            return paragraphs;
        }

        
    }
}
