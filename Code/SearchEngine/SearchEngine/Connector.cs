using System;
using System.Collections.Generic;
using System.Text;
using MySql.Data.MySqlClient;
using System.Data;

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

        public int GetTermId(string term)
        {
            command.CommandText = "SELECT idTerm FROM Term WHERE Label='" + term + "';";
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

            return idTerm;
        }

        public List<int> GetParagraphId(int idTerm)
        {
            command.CommandText = "SELECT idParagraph FROM contain WHERE idTerm='" + idTerm + "';";
            List<int> paragraphId = new List<int>();

            connection.Open();
            try
            {
                Reader = command.ExecuteReader();
                while (Reader.Read())
                {
                    for (int i = 0; i < Reader.FieldCount; i++)
                    {
                        paragraphId.Add(Int32.Parse(Reader.GetValue(i).ToString()));
                    }
                }
            }
            catch (MySqlException ex)
            {
                Console.WriteLine(ex.Message);
            }
            connection.Close();

            return paragraphId;
        }
    }
}
