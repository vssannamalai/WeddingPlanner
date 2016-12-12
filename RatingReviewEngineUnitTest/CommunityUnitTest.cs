using Microsoft.VisualStudio.TestTools.UnitTesting;
using RatingReviewEngine.Business;
using RatingReviewEngine.Entities;

namespace RatingReviewEngineUnitTest
{
    /// <summary>
    /// Summary description for CommunityUnitTest
    /// </summary>
    [TestClass]
    public class CommunityUnitTest
    {
        int communityId;
        int ownerId;
        public CommunityUnitTest()
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
        //[ClassCleanup()]
        //public static void MyClassCleanup() {  }
        //
        // Use TestInitialize to run code before running each test 
        // [TestInitialize()]
        // public void MyTestInitialize() { }
        //
        // Use TestCleanup to run code after each test has run
        [TestCleanup()]
        public void CommunityTestCleanup()
        {
            CommunityComponent communityComponent = new CommunityComponent();
            communityComponent.CommunityDelete(communityId);

            if (ownerId > 0)
            {
                OwnerComponent ownerComponent = new OwnerComponent();
                ownerComponent.OwnerDelete(ownerId);
            }
        }

        #endregion

        [TestMethod]
        public void TestCommunityInsert()
        {
            Common common = new Common();
            ownerId = common.OwnerInsert();

            Community commnity = new Community();
            commnity.Name = "Unit Test Community";
            commnity.Description = "Unit Test Community Description";
            commnity.CurrencyId = 1;
            commnity.CountryID = 1;
            commnity.OwnerID = ownerId;
            commnity.CentreLongitude = 10.34M;
            commnity.CentreLatitude = 5.6M;
            commnity.AutoTransferAmtOwner = 10;
            commnity.AreaRadius = 12.3M;
            commnity.Active = true;

            CommunityComponent communityComponent = new CommunityComponent();
            commnity = communityComponent.CommunityInsert(commnity);
            communityId = commnity.CommunityID;

            Community communityResult = new Community();
            communityResult = communityComponent.CommunitySelect(commnity.CommunityID);

            Assert.AreEqual(commnity.Name, communityResult.Name, "Name insert failed");
            Assert.AreEqual(commnity.Description, communityResult.Description, "Description insert failed");
            Assert.AreEqual(commnity.CurrencyId, communityResult.CurrencyId, "CurrencyID insert failed");
            Assert.AreEqual(commnity.CountryID, communityResult.CountryID, "CountryID insert failed");
            Assert.AreEqual(commnity.OwnerID, communityResult.OwnerID, "OwnerID insert failed");
            Assert.AreEqual(commnity.CentreLongitude, communityResult.CentreLongitude, "CentreLongitude insert failed");
            Assert.AreEqual(commnity.CentreLatitude, communityResult.CentreLatitude, "CentreLAtitude insert failed");
            Assert.AreEqual(commnity.AutoTransferAmtOwner, communityResult.AutoTransferAmtOwner, "AutoTransferAmtOwner insert failed");
            Assert.AreEqual(commnity.AreaRadius, communityResult.AreaRadius, "AreaRadius insert failed");
            Assert.AreEqual(commnity.Active, communityResult.Active, "Active insert failed");
        }

        [TestMethod]
        public void TestCommunityUpdate()
        {
            Common common = new Common();
            ownerId = common.OwnerInsert();

            Community commnity = new Community();
            commnity.Name = "Unit Test Community";
            commnity.Description = "Unit Test Community Description";
            commnity.CurrencyId = 1;
            commnity.CountryID = 1;
            commnity.OwnerID = ownerId;
            commnity.CentreLongitude = 10.34M;
            commnity.CentreLatitude = 5.6M;
            commnity.AutoTransferAmtOwner = 10;
            commnity.Active = true;

            CommunityComponent communityComponent = new CommunityComponent();
            commnity = communityComponent.CommunityInsert(commnity);
            communityId = commnity.CommunityID;

            commnity.Name = "test11";
            commnity.Description = "test desc1";
            commnity.CurrencyId = 2;
            commnity.CountryID = 2;
            commnity.OwnerID = ownerId;
            commnity.CentreLongitude = 10.31M;
            commnity.CentreLatitude = 5.61M;
            commnity.AutoTransferAmtOwner = 10.1M;
            commnity.AreaRadius = 2.5M;
            commnity.Active = false;

            communityComponent.CommunityUpdate(commnity);

            Community communityResult = new Community();
            communityResult = communityComponent.CommunitySelect(commnity.CommunityID);

            Assert.AreEqual(commnity.Name, communityResult.Name, "Name update failed");
            Assert.AreEqual(commnity.Description, communityResult.Description, "Description update failed");
            Assert.AreEqual(commnity.CurrencyId, communityResult.CurrencyId, "CurrencyID update failed");
            Assert.AreEqual(commnity.CountryID, communityResult.CountryID, "CountryID update failed");
            Assert.AreEqual(commnity.OwnerID, communityResult.OwnerID, "OwnerID update failed");
            Assert.AreEqual(commnity.CentreLongitude, communityResult.CentreLongitude, "CentreLongitude update failed");
            Assert.AreEqual(commnity.CentreLatitude, communityResult.CentreLatitude, "CentreLAtitude update failed");
            Assert.AreEqual(commnity.AutoTransferAmtOwner, communityResult.AutoTransferAmtOwner, "AutoTransferAmtOwner update failed");
            Assert.AreEqual(commnity.AreaRadius, communityResult.AreaRadius, "AreaRadius update failed");
            Assert.AreEqual(commnity.Active, communityResult.Active, "Active update failed");

        }

    }
}
