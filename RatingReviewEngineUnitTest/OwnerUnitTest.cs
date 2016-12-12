using Microsoft.VisualStudio.TestTools.UnitTesting;
using RatingReviewEngine.Business;
using RatingReviewEngine.Entities;
using System;

namespace RatingReviewEngineUnitTest
{
    /// <summary>
    /// Summary description for OwnerUnitTest
    /// </summary>
    [TestClass]
    public class OwnerUnitTest
    {
        int ownerId;
        public OwnerUnitTest()
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
        public void OwnerTestCleanup()
        {
            OwnerComponent ownerComponent = new OwnerComponent();
            ownerComponent.OwnerDelete(ownerId);
        }

        #endregion

        [TestMethod]
        public void TestRegisterNewCommunityOwner()
        {
            Owner owner = new Owner();
            owner.OAuthAccountID = 1;
            owner.CompanyName = "Unit Test Company";
            owner.Email = "unittestowner@test.com";
            owner.BusinessNumber = "12345";
            owner.PreferredPaymentCurrencyID = 1;
            owner.PrimaryPhone = "6044";
            owner.OtherPhone = "054545";
            owner.DateAdded = CommonComponent.MYSQLDateTime();
            owner.Website = "www.test.com";
            owner.AddressLine1 = "address1";
            owner.AddressLine2 = "address2";
            owner.AddressCity = "city";
            owner.AddressState = "state";
            owner.AddressPostalCode = "6009";
            //owner.AddressCountryID = 1;
            owner.BillingName = "billing";
            owner.BillingAddressLine1 = "billing address1";
            owner.BillingAddressLine2 = "billing address2";
            owner.BillingAddressCity = "billing city";
            owner.BillingAddressState = "billing state";
            owner.BillingAddressPostalCode = "6008";
            owner.BillingAddressCountryID = 1;

            OwnerComponent ownerComponent = new OwnerComponent();
            ownerId = ownerComponent.RegisterNewCommunityOwner(owner);

            Owner ownerResult = new Owner();
            ownerResult = ownerComponent.OwnerSelect(ownerId);

            Assert.AreEqual(owner.CompanyName, ownerResult.CompanyName, "Companyname insert failed");
            Assert.AreEqual(owner.Email, ownerResult.Email, "Email insert failed");
            Assert.AreEqual(owner.BusinessNumber, ownerResult.BusinessNumber, "Businessnumber insert failed");
            Assert.AreEqual(owner.PreferredPaymentCurrencyID, ownerResult.PreferredPaymentCurrencyID, "PreferredPaymentCurrencyId insert failed");
            Assert.AreEqual(owner.PrimaryPhone, ownerResult.PrimaryPhone, "PrimaryPhone insert failed");
            Assert.AreEqual(owner.OtherPhone, ownerResult.OtherPhone, "OtherPhone insert failed");
            //Assert.AreEqual(owner.DateAdded, ownerResult.DateAdded, "DateAdded insert failed");
            Assert.AreEqual(owner.Website, ownerResult.Website, "Website insert failed");
            Assert.AreEqual(owner.AddressLine1, ownerResult.AddressLine1, "AddressLine1 insert failed");
            Assert.AreEqual(owner.AddressLine2, ownerResult.AddressLine2, "AddressLine2 insert failed");
            Assert.AreEqual(owner.AddressCity, ownerResult.AddressCity, "AddressCity insert failed");
            Assert.AreEqual(owner.AddressState, ownerResult.AddressState, "AddressState insert failed");
            Assert.AreEqual(owner.AddressPostalCode, ownerResult.AddressPostalCode, "AddressPostalCode insert failed");
            Assert.AreEqual(owner.AddressCountryID, ownerResult.AddressCountryID, "AddressCoubntryID insert failed");
            Assert.AreEqual(owner.BillingName, ownerResult.BillingName, "BillinName insert failed");
            Assert.AreEqual(owner.BillingAddressLine1, ownerResult.BillingAddressLine1, "BillingAddressLine1 insert failed");
            Assert.AreEqual(owner.BillingAddressLine2, ownerResult.BillingAddressLine2, "BillingAddressLine2 insert failed");
            Assert.AreEqual(owner.BillingAddressCity, ownerResult.BillingAddressCity, "BillingAddressCity insert failed");
            Assert.AreEqual(owner.BillingAddressState, ownerResult.BillingAddressState, "BillingAddressState insert failed");
            Assert.AreEqual(owner.BillingAddressPostalCode, ownerResult.BillingAddressPostalCode, "BillingAddressPostalCode insert failed");
            Assert.AreEqual(owner.BillingAddressCountryID, ownerResult.BillingAddressCountryID, "BillingAddressCountryID insert failed");
        }

        [TestMethod]
        public void TestOwnerUpdate()
        {
            Owner owner = new Owner();
            owner.OAuthAccountID = 1;
            owner.CompanyName = "Unit Test Company";
            owner.Email = "unittestowner11@test.com";
            owner.BusinessNumber = "12345";
            owner.PreferredPaymentCurrencyID = 1;
            owner.PrimaryPhone = "6044";
            owner.OtherPhone = "054545";
            owner.DateAdded = CommonComponent.MYSQLDateTime();
            owner.Website = "www.test.com";
            owner.AddressLine1 = "address1";
            owner.AddressLine2 = "address2";
            owner.AddressCity = "city";
            owner.AddressState = "state";
            owner.AddressPostalCode = "6009";
            owner.AddressCountryID = 1;
            owner.BillingName = "billing";
            owner.BillingAddressLine1 = "billing address1";
            owner.BillingAddressLine2 = "billing address2";
            owner.BillingAddressCity = "billing city";
            owner.BillingAddressState = "billing state";
            owner.BillingAddressPostalCode = "6008";
            //owner.BillingAddressCountryID = 1;

            OwnerComponent ownerComponent = new OwnerComponent();
            ownerId = ownerComponent.RegisterNewCommunityOwner(owner);

            owner.OwnerID = ownerId;
            owner.CompanyName = "Unit Test Company1";
            owner.Email = "unittestowner111@test.com";
            owner.BusinessNumber = "123451";
            owner.PreferredPaymentCurrencyID = 2;
            owner.PrimaryPhone = "60441";
            owner.OtherPhone = "0545451";
            owner.DateAdded = CommonComponent.MYSQLDateTime();
            owner.Website = "www.test1.com";
            owner.AddressLine1 = "address11";
            owner.AddressLine2 = "address21";
            owner.AddressCity = "city1";
            owner.AddressState = "state1";
            owner.AddressPostalCode = "60091";
            //owner.AddressCountryID = 2;
            owner.BillingName = "billing1";
            owner.BillingAddressLine1 = "billing address11";
            owner.BillingAddressLine2 = "billing address21";
            owner.BillingAddressCity = "billing city1";
            owner.BillingAddressState = "billing state1";
            owner.BillingAddressPostalCode = "60081";
            owner.BillingAddressCountryID = 1;

            ownerComponent.OwnerUpdate(owner);

            Owner ownerResult = new Owner();
            ownerResult = ownerComponent.OwnerSelect(ownerId);

            Assert.AreEqual(owner.CompanyName, ownerResult.CompanyName, "Companyname update failed");
            Assert.AreEqual(owner.Email, ownerResult.Email, "Email update failed");
            Assert.AreEqual(owner.BusinessNumber, ownerResult.BusinessNumber, "Businessnumber update failed");
            Assert.AreEqual(owner.PreferredPaymentCurrencyID, ownerResult.PreferredPaymentCurrencyID, "PreferredPaymentCurrencyId update failed");
            Assert.AreEqual(owner.PrimaryPhone, ownerResult.PrimaryPhone, "PrimaryPhone update failed");
            Assert.AreEqual(owner.OtherPhone, ownerResult.OtherPhone, "OtherPhone update failed");
            //Assert.AreEqual(owner.DateAdded, ownerResult.DateAdded, "DateAdded update failed");
            Assert.AreEqual(owner.Website, ownerResult.Website, "Website update failed");
            Assert.AreEqual(owner.AddressLine1, ownerResult.AddressLine1, "AddressLine1 update failed");
            Assert.AreEqual(owner.AddressLine2, ownerResult.AddressLine2, "AddressLine2 update failed");
            Assert.AreEqual(owner.AddressCity, ownerResult.AddressCity, "AddressCity update failed");
            Assert.AreEqual(owner.AddressState, ownerResult.AddressState, "AddressState update failed");
            Assert.AreEqual(owner.AddressPostalCode, ownerResult.AddressPostalCode, "AddressPostalCode update failed");
            Assert.AreEqual(owner.AddressCountryID, ownerResult.AddressCountryID, "AddressCoubntryID update failed");
            Assert.AreEqual(owner.BillingName, ownerResult.BillingName, "BillinName update failed");
            Assert.AreEqual(owner.BillingAddressLine1, ownerResult.BillingAddressLine1, "BillingAddressLine1 update failed");
            Assert.AreEqual(owner.BillingAddressLine2, ownerResult.BillingAddressLine2, "BillingAddressLine2 update failed");
            Assert.AreEqual(owner.BillingAddressCity, ownerResult.BillingAddressCity, "BillingAddressCity update failed");
            Assert.AreEqual(owner.BillingAddressState, ownerResult.BillingAddressState, "BillingAddressState update failed");
            Assert.AreEqual(owner.BillingAddressPostalCode, ownerResult.BillingAddressPostalCode, "BillingAddressPostalCode update failed");
            Assert.AreEqual(owner.BillingAddressCountryID, ownerResult.BillingAddressCountryID, "BillingAddressCountryID update failed");
        }
    }
}
