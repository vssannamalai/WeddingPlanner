using System;
using System.Text;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;

using RatingReviewEngine.DAC;
using RatingReviewEngine.Business;
using RatingReviewEngine.Entities;

namespace RatingReviewEngineUnitTest
{
    /// <summary>
    /// Summary description for AdministratorUnitTest
    /// </summary>
    [TestClass]
    public class AdministratorUnitTest
    {
        int currencyId;
        public AdministratorUnitTest()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        //
        // You can use the following additional attributes as you write your tests:
        //
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext) { }
        //
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup() { }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        [TestCleanup()]
        public void CurrencyTestCleanup()
        {
            if (currencyId > 0)
            {
                AdministratorComponent administratorComponent = new AdministratorComponent();
                administratorComponent.DeleteCurrency(currencyId);
            }
        }

        #endregion

        [TestMethod]
        public void TestNewCurrency()
        {
            Currency currency = new Currency();
            currency.ISOCode = "TES";
            currency.Description = "TEST";
            currency.MinTransferAmount = 10.50M;
            currency.IsActive = true;
            AdministratorComponent administratorComponent = new AdministratorComponent();
            currencyId = administratorComponent.CurrencyInsert(currency);

            Currency currencyResult = administratorComponent.GetCurrency(currencyId);
            Assert.AreEqual(currency.ISOCode, currencyResult.ISOCode, "Currency ISOCode insert failed");
            Assert.AreEqual(currency.Description, currencyResult.Description, "Currency Descriptin insert failed");
            Assert.AreEqual(currency.MinTransferAmount, currencyResult.MinTransferAmount, "Currency MinTransferAmount insert failed");
            Assert.AreEqual(currency.IsActive, currencyResult.IsActive, "Currency IsActive insert failed");
        }

        [TestMethod]
        public void TestUpdateCurrency()
        {
            Currency currency = new Currency();
            currency.ISOCode = "TES";
            currency.Description = "TEST";
            currency.MinTransferAmount = 10.50M;
            currency.IsActive = true;
            AdministratorComponent administratorComponent = new AdministratorComponent();
            currencyId = administratorComponent.CurrencyInsert(currency);

            currency.CurrencyID = currencyId;
            currency.ISOCode = "TE1";
            currency.Description = "TEST1";
            currency.MinTransferAmount = 10.51M;
            currency.IsActive = false;
            administratorComponent.CurrencyUpdate(currency);
            Currency currencyResult = administratorComponent.GetCurrency(currencyId);

            Assert.AreEqual(currency.ISOCode, currencyResult.ISOCode, "Currency ISOCode insert failed");
            Assert.AreEqual(currency.Description, currencyResult.Description, "Currency Descriptin insert failed");
            Assert.AreEqual(currency.MinTransferAmount, currencyResult.MinTransferAmount, "Currency MinTransferAmount insert failed");
            Assert.AreEqual(currency.IsActive, currencyResult.IsActive, "Currency IsActive insert failed");
        }
    }
}
