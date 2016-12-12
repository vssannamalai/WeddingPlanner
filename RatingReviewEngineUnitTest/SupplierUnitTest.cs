using Microsoft.VisualStudio.TestTools.UnitTesting;
using RatingReviewEngine.Business;
using RatingReviewEngine.Entities;
using System;

namespace RatingReviewEngineUnitTest
{
    /// <summary>
    /// Summary description for SupplierUnitTest
    /// </summary>
    [TestClass]
    public class SupplierUnitTest
    {
        int supplierId;
        public SupplierUnitTest()
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
        public void SupplierTestCleanup()
        {
            SupplierComponent supplierComponent = new SupplierComponent();
            supplierComponent.SupplierDelete(supplierId);
        }

        #endregion

        [TestMethod]
        public void TestRegisterNewSupplier()
        {
            Supplier supplier = new Supplier();
            supplier.OAuthAccountID = 1;
            supplier.CompanyName = "Unit Test supplier";
            supplier.Email = "unittest@supplier.com";
            supplier.BusinessNumber = "12344";
            supplier.PrimaryPhone = "568565";
            supplier.OtherPhone = "678678";
            supplier.DateAdded = CommonComponent.MYSQLDateTime();
            supplier.Website = "www.test.com";
            supplier.AddressLine1 = "test address1";
            supplier.AddressLine2 = "test address2";
            supplier.AddressCity = "test city";
            supplier.AddressState = "test state";
            supplier.AddressPostalCode = "6009";
            supplier.AddressCountryID = 1;
            supplier.BillingName = "test billing";
            supplier.BillingAddressLine1 = "billing address1";
            supplier.BillingAddressLine2 = "billing address2";
            supplier.BillingAddressCity = "billing city";
            supplier.BillingAddressState = "billing state";
            supplier.BillingAddressPostalCode = "50009";
            supplier.BillingAddressCountryID = 1;
            supplier.Longitude = 10.5M;
            supplier.Latitude = 12.4M;
            supplier.ProfileCompletedDate = DateTime.Now;
            supplier.QuoteTerms = "quote";
            supplier.DepositPercent = 10.0M;
            supplier.DepositTerms = "deposite";

            SupplierComponent supplierComponent = new SupplierComponent();
            supplierId = supplierComponent.RegisterNewSupplier(supplier);

            Supplier supplierResult = new Supplier();
            supplierResult = supplierComponent.SupplierSelect(supplierId);

            Assert.AreEqual(supplier.CompanyName, supplierResult.CompanyName, "Company name insert failed");
            Assert.AreEqual(supplier.Email, supplierResult.Email, "Email insert failed");
            Assert.AreEqual(supplier.BusinessNumber, supplierResult.BusinessNumber, "Businessnumber insert failed");
            Assert.AreEqual(supplier.PrimaryPhone, supplierResult.PrimaryPhone, "Primary phone insert failed");
            Assert.AreEqual(supplier.OtherPhone, supplierResult.OtherPhone, "Other phone insert failed");
            //Assert.AreEqual(supplier.DateAdded, supplierResult.DateAdded, "Dateadded insert failed");
            Assert.AreEqual(supplier.Website, supplierResult.Website, "Website insert failed");
            Assert.AreEqual(supplier.AddressLine1, supplierResult.AddressLine1, "Addressline1 insert failed");
            Assert.AreEqual(supplier.AddressLine2, supplierResult.AddressLine2, "Addressline2 insert failed");
            Assert.AreEqual(supplier.AddressCity, supplierResult.AddressCity, "AddressCity insert failed");
            Assert.AreEqual(supplier.AddressState, supplierResult.AddressState, "AddressState insert failed");
            Assert.AreEqual(supplier.AddressPostalCode, supplierResult.AddressPostalCode, "AddressPostalCode insert failed");
            Assert.AreEqual(supplier.AddressCountryID, supplierResult.AddressCountryID, "AddressCountryID insert failed");
            Assert.AreEqual(supplier.BillingName, supplierResult.BillingName, "BillingName insert failed");
            Assert.AreEqual(supplier.BillingAddressLine1, supplierResult.BillingAddressLine1, "BillingAddressLine1 insert failed");
            Assert.AreEqual(supplier.BillingAddressLine2, supplierResult.BillingAddressLine2, "BillingAddressLine2 insert failed");
            Assert.AreEqual(supplier.BillingAddressCity, supplierResult.BillingAddressCity, "BillingAddressCity insert failed");
            Assert.AreEqual(supplier.BillingAddressState, supplierResult.BillingAddressState, "BillingAddressState insert failed");
            Assert.AreEqual(supplier.BillingAddressPostalCode, supplierResult.BillingAddressPostalCode, "BillingAddressPostalCode insert failed");
            Assert.AreEqual(supplier.BillingAddressCountryID, supplierResult.BillingAddressCountryID, "BillingAddressCountryID insert failed");
            Assert.AreEqual(supplier.Longitude, supplierResult.Longitude, "Longitude insert failed");
            Assert.AreEqual(supplier.Latitude, supplierResult.Latitude, "Latitude insert failed");
           // Assert.AreEqual(supplier.ProfileCompletedDate, supplierResult.ProfileCompletedDate, "ProfileCompletedDate insert failed");
            Assert.AreEqual(supplier.QuoteTerms, supplierResult.QuoteTerms, "QuoteTerms insert failed");
            Assert.AreEqual(supplier.DepositPercent, supplierResult.DepositPercent, "DepositPercent insert failed");
            Assert.AreEqual(supplier.DepositTerms, supplierResult.DepositTerms, "DepositTerms insert failed");
        }

        [TestMethod]
        public void TestSupplierInsert()
        {
            Supplier supplier = new Supplier();
            supplier.OAuthAccountID = 1;
            supplier.CompanyName = "Unit Test Supplier";
            supplier.Email = "unittest@supplier.com";
            supplier.PrimaryPhone = "568565";
            supplier.OtherPhone = "678678";
            supplier.Website = "www.test.com";
            supplier.AddressLine1 = "test address1";
            supplier.AddressLine2 = "test address2";
            supplier.AddressCity = "test city";
            supplier.AddressState = "test state";
            supplier.AddressPostalCode = "6009";
            //supplier.AddressCountryID = 1;
            supplier.BillingName = "test billing";
            supplier.BillingAddressLine1 = "billing address1";
            supplier.BillingAddressLine2 = "billing address2";
            supplier.BillingAddressCity = "billing city";
            supplier.BillingAddressState = "billing state";
            supplier.BillingAddressPostalCode = "50009";
           // supplier.BillingAddressCountryID = 1;
            supplier.BusinessNumber = "123434";
            supplier.Longitude = 10.5M;
            supplier.Latitude = 12.4M;

            SupplierComponent supplierComponent = new SupplierComponent();
            supplierId = supplierComponent.SupplierInsert(supplier);

            Supplier supplierResult = new Supplier();
            supplierResult = supplierComponent.SupplierSelect(supplierId);

            Assert.AreEqual(supplier.CompanyName, supplierResult.CompanyName, "Company name insert failed");
            Assert.AreEqual(supplier.Email, supplierResult.Email, "Email insert failed");
            Assert.AreEqual(supplier.PrimaryPhone, supplierResult.PrimaryPhone, "Primary phone insert failed");
            Assert.AreEqual(supplier.OtherPhone, supplierResult.OtherPhone, "Other phone insert failed");
            //Assert.AreEqual(supplier.DateAdded, supplierResult.DateAdded, "Dateadded insert failed");
            Assert.AreEqual(supplier.Website, supplierResult.Website, "Website insert failed");
            Assert.AreEqual(supplier.AddressLine1, supplierResult.AddressLine1, "Addressline1 insert failed");
            Assert.AreEqual(supplier.AddressLine2, supplierResult.AddressLine2, "Addressline2 insert failed");
            Assert.AreEqual(supplier.AddressCity, supplierResult.AddressCity, "AddressCity insert failed");
            Assert.AreEqual(supplier.AddressState, supplierResult.AddressState, "AddressState insert failed");
            Assert.AreEqual(supplier.AddressPostalCode, supplierResult.AddressPostalCode, "AddressPostalCode insert failed");
            Assert.AreEqual(supplier.AddressCountryID, supplierResult.AddressCountryID, "AddressCountryID insert failed");
            Assert.AreEqual(supplier.BillingName, supplierResult.BillingName, "BillingName insert failed");
            Assert.AreEqual(supplier.BillingAddressLine1, supplierResult.BillingAddressLine1, "BillingAddressLine1 insert failed");
            Assert.AreEqual(supplier.BillingAddressLine2, supplierResult.BillingAddressLine2, "BillingAddressLine2 insert failed");
            Assert.AreEqual(supplier.BillingAddressCity, supplierResult.BillingAddressCity, "BillingAddressCity insert failed");
            Assert.AreEqual(supplier.BillingAddressState, supplierResult.BillingAddressState, "BillingAddressState insert failed");
            Assert.AreEqual(supplier.BillingAddressPostalCode, supplierResult.BillingAddressPostalCode, "BillingAddressPostalCode insert failed");
            Assert.AreEqual(supplier.BillingAddressCountryID, supplierResult.BillingAddressCountryID, "BillingAddressCountryID insert failed");
            Assert.AreEqual(supplier.BusinessNumber, supplierResult.BusinessNumber, "Businessnumber insert failed");
            Assert.AreEqual(supplier.Longitude, supplierResult.Longitude, "Longitude insert failed");
            Assert.AreEqual(supplier.Latitude, supplierResult.Latitude, "Latitude insert failed");

        }

        [TestMethod]
        public void TestSupplierUpdate()
        {
            Supplier supplier = new Supplier();
            supplier.OAuthAccountID = 1;
            supplier.CompanyName = "Unit Test Supplier";
            supplier.Email = "unittest@supplier.com";
            supplier.BusinessNumber = "12345";
            supplier.PrimaryPhone = "568565";
            supplier.OtherPhone = "678678";
            supplier.DateAdded = CommonComponent.MYSQLDateTime();
            supplier.Website = "www.test.com";
            supplier.AddressLine1 = "test address1";
            supplier.AddressLine2 = "test address2";
            supplier.AddressCity = "test city";
            supplier.AddressState = "test state";
            supplier.AddressPostalCode = "6009";
            //supplier.AddressCountryID = 1;
            supplier.BillingName = "test billing";
            supplier.BillingAddressLine1 = "billing address1";
            supplier.BillingAddressLine2 = "billing address2";
            supplier.BillingAddressCity = "billing city";
            supplier.BillingAddressState = "billing state";
            supplier.BillingAddressPostalCode = "50009";
            supplier.BillingAddressCountryID = 1;
            supplier.Longitude = 10.5M;
            supplier.Latitude = 12.4M;
            supplier.ProfileCompletedDate = CommonComponent.MYSQLDateTime();
            supplier.QuoteTerms = "quote";
            supplier.DepositPercent = 10.0M;
            supplier.DepositTerms = "deposite";

            SupplierComponent supplierComponent = new SupplierComponent();
            supplierId = supplierComponent.RegisterNewSupplier(supplier);

            supplier.SupplierID = supplierId;
            supplier.CompanyName = "Unit Test Supplier1";
            supplier.Email = "unittest1@supplier.com";
            supplier.BusinessNumber = "123441";
            supplier.PrimaryPhone = "5685651";
            supplier.OtherPhone = "6786781";
            supplier.DateAdded = DateTime.Now;
            supplier.Website = "www.test1.com";
            supplier.AddressLine1 = "test address11";
            supplier.AddressLine2 = "test address21";
            supplier.AddressCity = "test city1";
            supplier.AddressState = "test state1";
            supplier.AddressPostalCode = "60091";
            supplier.AddressCountryID = 1;
            supplier.BillingName = "test billing1";
            supplier.BillingAddressLine1 = "billing address11";
            supplier.BillingAddressLine2 = "billing address21";
            supplier.BillingAddressCity = "billing city1";
            supplier.BillingAddressState = "billing state1";
            supplier.BillingAddressPostalCode = "500091";
            //supplier.BillingAddressCountryID = 2;
            supplier.Longitude = 10.51M;
            supplier.Latitude = 12.41M;
            supplier.ProfileCompletedDate = CommonComponent.MYSQLDateTime();
            supplier.QuoteTerms = "quote1";
            supplier.DepositPercent = 10.01M;
            supplier.DepositTerms = "deposite1";
            supplierComponent.SupplierUpdate(supplier);

            Supplier supplierResult = new Supplier();
            supplierResult = supplierComponent.SupplierSelect(supplierId);

            Assert.AreEqual(supplier.CompanyName, supplierResult.CompanyName, "Company name update failed");
            Assert.AreEqual(supplier.Email, supplierResult.Email, "Email update failed");
            Assert.AreEqual(supplier.BusinessNumber, supplierResult.BusinessNumber, "Businessnumber update failed");
            Assert.AreEqual(supplier.PrimaryPhone, supplierResult.PrimaryPhone, "Primary phone update failed");
            Assert.AreEqual(supplier.OtherPhone, supplierResult.OtherPhone, "Other phone update failed");
            //Assert.AreEqual(supplier.DateAdded, supplierResult.DateAdded, "Dateadded update failed");
            Assert.AreEqual(supplier.Website, supplierResult.Website, "Website update failed");
            Assert.AreEqual(supplier.AddressLine1, supplierResult.AddressLine1, "Addressline1 update failed");
            Assert.AreEqual(supplier.AddressLine2, supplierResult.AddressLine2, "Addressline2 update failed");
            Assert.AreEqual(supplier.AddressCity, supplierResult.AddressCity, "AddressCity update failed");
            Assert.AreEqual(supplier.AddressState, supplierResult.AddressState, "AddressState update failed");
            Assert.AreEqual(supplier.AddressPostalCode, supplierResult.AddressPostalCode, "AddressPostalCode update failed");
            Assert.AreEqual(supplier.AddressCountryID, supplierResult.AddressCountryID, "AddressCountryID update failed");
            Assert.AreEqual(supplier.BillingName, supplierResult.BillingName, "BillingName update failed");
            Assert.AreEqual(supplier.BillingAddressLine1, supplierResult.BillingAddressLine1, "BillingAddressLine1 update failed");
            Assert.AreEqual(supplier.BillingAddressLine2, supplierResult.BillingAddressLine2, "BillingAddressLine2 update failed");
            Assert.AreEqual(supplier.BillingAddressCity, supplierResult.BillingAddressCity, "BillingAddressCity update failed");
            Assert.AreEqual(supplier.BillingAddressState, supplierResult.BillingAddressState, "BillingAddressState update failed");
            Assert.AreEqual(supplier.BillingAddressPostalCode, supplierResult.BillingAddressPostalCode, "BillingAddressPostalCode update failed");
            Assert.AreEqual(supplier.BillingAddressCountryID, supplierResult.BillingAddressCountryID, "BillingAddressCountryID update failed");
            Assert.AreEqual(supplier.Longitude, supplierResult.Longitude, "Longitude update failed");
            Assert.AreEqual(supplier.Latitude, supplierResult.Latitude, "Latitude update failed");
            // Assert.AreEqual(supplier.ProfileCompletedDate, supplierResult.ProfileCompletedDate, "ProfileCompletedDate update failed");
            Assert.AreEqual(supplier.QuoteTerms, supplierResult.QuoteTerms, "QuoteTerms update failed");
            Assert.AreEqual(supplier.DepositPercent, supplierResult.DepositPercent, "DepositPercent update failed");
            Assert.AreEqual(supplier.DepositTerms, supplierResult.DepositTerms, "DepositTerms update failed");
        }

    }
}
