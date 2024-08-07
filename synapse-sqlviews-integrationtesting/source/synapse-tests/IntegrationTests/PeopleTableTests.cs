﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace IntegrationTests
{
    [TestClass]
    public class PeopleTableTests
    {
        [TestMethod]
        public async Task Test_For_Column_Data_Type()
        {
            //Arrange
            var azureHelper = new AzureHelper();
            string dbAccessToken = await azureHelper.GetDatabaseAccessToken(); //fill this
            string serverlessEndPoint = await azureHelper.GetServerlessEndPoint();

            //Act
            DataSet ds = await DbHelper.QueryDataSet(serverlessEndPoint, dbAccessToken, "SELECT ID,FIRSTNAME,LASTNAME FROM PEOPLE ORDER BY ID");

            //Assert

            var peopleTable = ds.Tables[0];

            Assert.AreEqual(typeof(int), peopleTable.Columns["ID"].DataType);
            Assert.AreEqual(typeof(string), peopleTable.Columns["FIRSTNAME"].DataType);
            Assert.AreEqual(typeof(string), peopleTable.Columns["LASTNAME"].DataType);
        }

        [TestMethod]
        public async Task Test_For_Count_Of_Rows()
        {
            //Arrange
            var azureHelper = new AzureHelper();
            string dbAccessToken = await azureHelper.GetDatabaseAccessToken(); //fill this
            string serverlessEndPoint = await azureHelper.GetServerlessEndPoint();

            //Act
            DataSet ds = await DbHelper.QueryDataSet(serverlessEndPoint, dbAccessToken, "SELECT * FROM PEOPLE ORDER BY ID");

            //Assert
            Assert.AreEqual(1, ds.Tables.Count);

            var peopleTable = ds.Tables[0];
            Assert.AreEqual(4, peopleTable.Rows.Count);

        }

        [TestMethod]
        public async Task Test_For_Values_Of_ID_Column()
        {
            //Arrange
            var azureHelper = new AzureHelper();
            string dbAccessToken = await azureHelper.GetDatabaseAccessToken(); //fill this
            string serverlessEndPoint = await azureHelper.GetServerlessEndPoint();

            //Act
            DataSet ds = await DbHelper.QueryDataSet(serverlessEndPoint, dbAccessToken, "SELECT * FROM PEOPLE ORDER BY ID");

            //Assert

            var peopleTable = ds.Tables[0];

            Assert.AreEqual(100, peopleTable.Rows[0]["ID"]);
            Assert.AreEqual(200, peopleTable.Rows[1]["ID"]);
            Assert.AreEqual(300, peopleTable.Rows[2]["ID"]);
            Assert.AreEqual(400, peopleTable.Rows[3]["ID"]);
        }
    }
}