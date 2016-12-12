using Microsoft.VisualStudio.TestTools.UnitTesting;
using RatingReviewEngine.Business;
using RatingReviewEngine.Entities;
using System;

namespace RatingReviewEngineUnitTest
{
    /// <summary>
    /// Summary description for CustomerComponentUnitTest
    /// </summary>
    [TestClass]
    public class CustomerComponentUnitTest
    {
        int customerId;
        int communityId;
        int supplierId;
        int communityGroupId;
        int reviewId;
        int ownerId;

        public CustomerComponentUnitTest()
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
        public void CustomerTestCleanup()
        {
            CustomerComponent customerComponent = new CustomerComponent();
            if (reviewId > 0)
                customerComponent.ReviewDelete(reviewId);    
        
            if (communityId > 0)
            {
                CommunityComponent communityComponent = new CommunityComponent();
                communityComponent.CommunityDelete(communityId);
            }

            if (ownerId > 0)
            {
                OwnerComponent ownerComponent = new OwnerComponent();
                ownerComponent.OwnerDelete(ownerId);
            }

            if (supplierId > 0)
            {
                SupplierComponent supplierComponent = new SupplierComponent();
                supplierComponent.SupplierActionDeleteBySupplier(supplierId);
                supplierComponent.SupplierDelete(supplierId);
            }            
            
            customerComponent.CustomerDelete(customerId);
        }

        #endregion

        [TestMethod]
        public void TestCustomerInsert()
        {
            Customer customer = new Customer();
            customer.Email = "unittest@test.com";
            customer.MobilePhone = "999999";
            customer.FirstName = "First";
            customer.LastName = "Last";
            customer.Gender = 'M';
            customer.Handle = "Handle";
            customer.DateJoined = CommonComponent.MYSQLDateTime();

            CustomerComponent customerComponent = new CustomerComponent();
            customerId = customerComponent.CustomerInsert(customer);

            Customer customerResult = new Customer();
            customerResult = customerComponent.CustomerSelect(customerId);
            Assert.AreEqual(customer.Email, customerResult.Email, "Email insert failed");
            Assert.AreEqual(customer.MobilePhone, customerResult.MobilePhone, "MobilePhone insert failed");
            Assert.AreEqual(customer.FirstName, customerResult.FirstName, "FirstName insert failed");
            Assert.AreEqual(customer.LastName, customerResult.LastName, "LastName insert failed");
            Assert.AreEqual(customer.Handle, customerResult.Handle, "Handle insert failed");
            Assert.AreEqual(customer.Gender, customerResult.Gender, "Gender insert failed");
            Assert.AreEqual(customer.DateJoined.ToString(), customerResult.DateJoined.ToString(), "Email insert failed");
        }

        [TestMethod]
        public void TestCustomerUpdate()
        {
            Customer customer = new Customer();
            customer.Email = "unittest@unittest.com";
            customer.MobilePhone = "999999";
            customer.FirstName = "First";
            customer.LastName = "Last";
            customer.Gender = 'M';
            customer.Handle = "Handle";
            customer.DateJoined = DateTime.Today;

            CustomerComponent customerComponent = new CustomerComponent();
            customerId = customerComponent.CustomerInsert(customer);
            customer.CustomerID = customerId;
            customer.Email = "unittest1@unittest.com";
            customer.MobilePhone = "9999991";
            customer.FirstName = "First1";
            customer.LastName = "Last1";
            customer.Gender = 'F';
            customer.Handle = "Handle1";
            customer.DateJoined = DateTime.Today;

            customerComponent.CustomerUpdate(customer);

            Customer customerResult = new Customer();
            customerResult = customerComponent.CustomerSelect(customerId);
            Assert.AreEqual(customer.Email, customerResult.Email, "Email insert failed");
            Assert.AreEqual(customer.MobilePhone, customerResult.MobilePhone, "MobilePhone insert failed");
            Assert.AreEqual(customer.FirstName, customerResult.FirstName, "FirstName insert failed");
            Assert.AreEqual(customer.LastName, customerResult.LastName, "LastName insert failed");
            Assert.AreEqual(customer.Handle, customerResult.Handle, "Handle insert failed");
            Assert.AreEqual(customer.Gender, customerResult.Gender, "Gender insert failed");
            Assert.AreEqual(customer.DateJoined.ToString(), customerResult.DateJoined.ToString(), "Email insert failed");
        }

        [TestMethod]
        public void TestCustomerReviewInsert()
        {
            Common common=new Common();
            customerId = common.CustomerInsert();
            supplierId = common.SupplierInsert();
            ownerId = common.OwnerInsert();
            communityId = common.CommunityInsert(ownerId);

            Review review = new Review();
            review.CustomerID = customerId;
            review.CommunityID = communityId;
            review.SupplierID = supplierId;
            review.CommunityGroupID = 2;
            review.Rating = 2;
            review.ReviewMessage = "test";
            review.ReviewDate = DateTime.Today;

            CustomerComponent customerComponent = new CustomerComponent();
            reviewId = customerComponent.CustomerReviewInsert(review).ReviewID;

            Review reviewResult = new Review();
            reviewResult = customerComponent.CustomerReviewSelect(reviewId);

            Assert.AreEqual(review.CustomerID, reviewResult.CustomerID, "CustomerID insert failed");
            Assert.AreEqual(review.CommunityID, reviewResult.CommunityID, "CommunityID insert failed");
            Assert.AreEqual(review.SupplierID, reviewResult.SupplierID, "SupplierID insert failed");
            Assert.AreEqual(review.CommunityGroupID, reviewResult.CommunityGroupID, "CommunityGroupID insert failed");
            Assert.AreEqual(review.Rating, reviewResult.Rating, "Rating insert failed");
            Assert.AreEqual(review.ReviewMessage, reviewResult.ReviewMessage, "ReviewMessage insert failed");
            Assert.AreEqual(review.ReviewDate.ToString("dd/MM/yyyy"), reviewResult.ReviewDate.ToString("dd/MM/yyyy"), "ReviewDate insert failed");
        }
    }
}