using System;
using System.Collections.Generic;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using MySql.Data.MySqlClient;
using System.Data;
using SearchEngine.Model;
using System.Xml.Linq;
using System.Linq;
using SearchEngine.Model.Comparison;

namespace SearchEngine.View
{
    /// <summary>
    /// Logique d'interaction pour MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        Connector Conn;
        Comparator Comparator;

        public MainWindow()
        {
            InitializeComponent();

            Conn = new Connector();
            Comparator = new Comparator();

            FillQueries();
        }

        private void comboBox_query_KeyUp(object sender, KeyEventArgs e)
        {
            Search();
        }

        private void comboBox_query_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if ((sender as ComboBox).SelectedItem != null)
            {
                comboBox_query.Text = (sender as ComboBox).SelectedItem.ToString();
            }
            Search();
        }

        private void Search()
        {
            Search search = new Search(new Query(comboBox_query.Text));

            // Display result on GUI list
            textBox_result.Clear();
            textBox_result.AppendText(search.Result);

            // Display compared datas
            textBox_qrel.Clear();
            textBox_qrel.AppendText(Comparator.CompareWithQrel(search));
        }

        private void FillQueries()
        {
            foreach (KeyValuePair<string, Qrel> query in Comparator.Queries)
            {
                comboBox_query.Items.Add(query.Key);
            }
        }
    }
}
