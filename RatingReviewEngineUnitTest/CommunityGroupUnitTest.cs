using Microsoft.VisualStudio.TestTools.UnitTesting;
using RatingReviewEngine.Business;
using RatingReviewEngine.Entities;

namespace RatingReviewEngineUnitTest
{
    /// <summary>
    /// Summary description for CommunityGroupUnitTest
    /// </summary>
    [TestClass]
    public class CommunityGroupUnitTest
    {
        int nOwnerId;
        int nCommunityId;        
        int nCommunityGroupId;

        public CommunityGroupUnitTest()
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
        // [TestCleanup()]
        // public void MyTestCleanup() { }
        //

        [TestCleanup()]
        public void CommunityGroupTestCleanup()
        {
            CommunityGroupComponent communityGroupComponent = new CommunityGroupComponent();

            if (nCommunityGroupId > 0)
            {
                communityGroupComponent.CommunityGroupDelete(nCommunityGroupId);
            }

            if (nCommunityId > 0)
            {
                CommunityComponent communityComponent = new CommunityComponent();
                communityComponent.CommunityDelete(nCommunityId);
            }            

            if (nOwnerId > 0)
            {
                OwnerComponent ownerComponent = new OwnerComponent();
                ownerComponent.OwnerDelete(nOwnerId);
            }
        }
        #endregion

        [TestMethod]
        public void TestCommunityGroupInsert()
        {
            Common common = new Common();
            nOwnerId = common.OwnerInsert();
            nCommunityId = common.CommunityInsert(nOwnerId);

            CommunityGroup communityGroup = new CommunityGroup();
            communityGroup.CommunityID = nCommunityId;
            communityGroup.Name = "Unit Test Name";
            communityGroup.Description = "Unit Test Description";
            communityGroup.CreditMin = 0.1M;
            communityGroup.CurrencyID = 1;
            communityGroup.Active = true;

            CommunityGroupComponent communityGroupComponent = new CommunityGroupComponent();
            nCommunityGroupId = communityGroupComponent.CommunityGroupInsert(communityGroup);

            CommunityGroup communityGroupResult = new CommunityGroup();
            communityGroupResult = communityGroupComponent.CommunityGroupSelect(nCommunityGroupId);

            Assert.AreEqual(communityGroup.CommunityID, communityGroupResult.CommunityID, "CommunityID insert failed");
            Assert.AreEqual(communityGroup.Name, communityGroupResult.Name, "Name insert failed");
            Assert.AreEqual(communityGroup.Description, communityGroupResult.Description, "Description insert failed");
            Assert.AreEqual(communityGroup.CreditMin, communityGroupResult.CreditMin, "CreditMin insert failed");
            Assert.AreEqual(communityGroup.CurrencyID, communityGroupResult.CurrencyID, "CurrencyID insert failed");
            Assert.AreEqual(communityGroup.Active, communityGroupResult.Active, "Active insert failed");
        }

        [TestMethod]
        public void TestCommunityGroupUpdate()
        {
            Common common = new Common();
            nOwnerId = common.OwnerInsert();
            nCommunityId = common.CommunityInsert(nOwnerId);

            CommunityGroup communityGroup = new CommunityGroup();
            communityGroup.CommunityID = nCommunityId;
            communityGroup.Name = "Unit Test Name";
            communityGroup.Description = "Unit Test Description";
            communityGroup.CreditMin = 0.1M;
            communityGroup.CurrencyID = 1;
            communityGroup.Active = true;

            CommunityGroupComponent communityGroupComponent = new CommunityGroupComponent();
            nCommunityGroupId = communityGroupComponent.CommunityGroupInsert(communityGroup);

            communityGroup.CommunityGroupID = nCommunityGroupId;
            communityGroup.CommunityID = nCommunityId;
            communityGroup.Name = "Unit Test Update Name";
            communityGroup.Description = "Unit Test Update Description";
            communityGroup.CreditMin = 0.1M;
            communityGroup.CurrencyID = 1;
            communityGroup.Active = true;

            communityGroupComponent.CommunityGroupUpdate(communityGroup);

            CommunityGroup communityGroupResult = new CommunityGroup();
            communityGroupResult = communityGroupComponent.CommunityGroupSelect(nCommunityGroupId);

            Assert.AreEqual(communityGroup.CommunityID, communityGroupResult.CommunityID, "CommunityID update failed");
            Assert.AreEqual(communityGroup.Name, communityGroupResult.Name, "Name update failed");
            Assert.AreEqual(communityGroup.Description, communityGroupResult.Description, "Description update failed");
            Assert.AreEqual(communityGroup.CreditMin, communityGroupResult.CreditMin, "CreditMin update failed");
            Assert.AreEqual(communityGroup.CurrencyID, communityGroupResult.CurrencyID, "CurrencyID update failed");
            Assert.AreEqual(communityGroup.Active, communityGroupResult.Active, "Active update failed");
        }
    }
}
