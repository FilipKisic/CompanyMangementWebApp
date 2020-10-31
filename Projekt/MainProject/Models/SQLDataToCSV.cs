using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;

namespace MainProject.Models
{
    public class SQLDataToCSV
    {
        private static readonly string cs = ConfigurationManager.ConnectionStrings["cs"].ConnectionString;

        public static void ExportToCSV(string fileName, string spName, string parameterName, int parameter)
        {
            DataTable table = ReadTable(spName, parameterName, parameter);
            string SAVE_PATH = $"C:\\temp\\reports\\Report-{DateTime.Today.Day}-{DateTime.Today.Month}-{DateTime.Today.Hour}-{DateTime.Now.Minute}.csv";
            if (!string.IsNullOrEmpty(fileName))
            {
                fileName = $"C:\\temp\\reports\\{fileName}.csv";
                WriteToFile(table, fileName, false);
            }
            else
                WriteToFile(table, SAVE_PATH, false);
        }

        private static void WriteToFile(DataTable table, string fileLocation, bool firstRowIsColumnHeader = false, string separator = ";")
        {
            StreamWriter sw = new StreamWriter(fileLocation, false);
            int colCount = table.Columns.Count;

            if (!firstRowIsColumnHeader)
            {
                for(int i = 0; i < colCount; i++)
                {
                    sw.Write(table.Columns[i]);
                    if (i < colCount - 1)
                        sw.Write(separator);
                }
                sw.Write(sw.NewLine);
            }

            foreach(DataRow dataRow in table.Rows)
            {
                for(int i = 0; i < colCount; i++)
                {
                    if (!Convert.IsDBNull(dataRow[i]))
                        sw.Write(dataRow[i].ToString());
                    if (i < colCount - 1)
                        sw.Write(separator);
                }
                sw.Write(sw.NewLine);
            }
            sw.Close();
        }

        private static DataTable ReadTable(string spName, string parameterName, int parameter)
        {
            DataTable dataTable = new DataTable();
            try
            {
                using(SqlConnection connection = new SqlConnection(cs))
                {
                    using(SqlCommand cmd = new SqlCommand(spName, connection))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add(parameterName, SqlDbType.Int).Value = parameter;
                        using(SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            adapter.Fill(dataTable);
                        }
                    }   
                }
            } 
            catch(Exception e)
            {
                Debug.WriteLine(e.StackTrace);
            }
            return dataTable;
        }
    }
}