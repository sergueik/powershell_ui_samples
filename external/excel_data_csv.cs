using System;
using System.Data;
using System.IO;
using System.Data.OleDb;
public class Excel_Data
{

    public static void Main(string[] args)
    {
        ImportCsvFile(args[0]);
    }

public static void ImportCsvFile(string filename)
{
    FileInfo file = new FileInfo(filename);
    String x = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=\"" +
            file.DirectoryName + "\";" +
            "Extended Properties='text;HDR=Yes;FMT=Delimited(,)';";
     Console.WriteLine(x);
     using (OleDbConnection con = 
            new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=\"" +
            file.DirectoryName + "\";" +
            "Extended Properties='text;HDR=Yes;FMT=Delimited(,)';"))
    {
        using (OleDbCommand cmd = new OleDbCommand(string.Format
                                  ("SELECT * FROM [{0}]", file.Name), con))
        {
            con.Open();
 
            // Using a DataReader to process the data
            using (OleDbDataReader reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    // Process the current reader entry...
                    Console.WriteLine("x"); 
                }
            }

            // Using a DataTable to process the data
            using (OleDbDataAdapter adp = new OleDbDataAdapter(cmd))
            {
                DataTable tbl = new DataTable("MyTable");
                adp.Fill(tbl);

                foreach (DataRow row in tbl.Rows)
                {
                    // Process the current row...
                }
            }
        }
    }
} 
}