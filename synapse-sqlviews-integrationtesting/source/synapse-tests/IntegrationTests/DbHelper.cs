using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Threading.Tasks;

namespace IntegrationTests
{
    public class DbHelper
    {
        internal static async Task<DataSet> QueryDataSet(string serverlessEndPoint, string dbAccessToken, string query)
        {
            var builder = new SqlConnectionStringBuilder();
            builder.DataSource = serverlessEndPoint;
            builder.InitialCatalog = "myserverlessdb";
            var cnString = builder.ConnectionString;

            using (var cn = new SqlConnection(cnString))
            {
                cn.AccessToken = dbAccessToken;
                await cn.OpenAsync();
                using (var cmd = new SqlCommand(query, cn))
                {
                    var adapter = new SqlDataAdapter(cmd);
                    var ds = new DataSet();
                    adapter.Fill(ds);
                    return ds;
                }
            }
        }
    }
}