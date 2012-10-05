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

namespace SearchEngine
{
    /// <summary>
    /// Logique d'interaction pour MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        Connector conn;

        public MainWindow()
        {
            InitializeComponent();

            conn = new Connector();
        }

        private void button_go_Click(object sender, RoutedEventArgs e)
        {
            Search();
        }

        private void TextBox_query_KeyUp(object sender, KeyEventArgs e)
        {
            if(e.Key.Equals(Key.Enter))
            {
                Search();
            }
        }

        private void Search()
        {
            Search search = new Search(new Query(TextBox_query.Text));

            // Display result on GUI list
            textBox_result.Clear();
            textBox_result.AppendText(search.Result);
        }
    }
}
