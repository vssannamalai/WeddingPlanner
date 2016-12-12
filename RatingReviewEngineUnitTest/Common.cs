using RatingReviewEngine.Business;
using RatingReviewEngine.Entities;
using System;

namespace RatingReviewEngineUnitTest
{
    public class Common
    {
        public int OwnerInsert()
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
            owner.AddressCountryID = 1;
            owner.BillingName = "billing";
            owner.BillingAddressLine1 = "billing address1";
            owner.BillingAddressLine2 = "billing address2";
            owner.BillingAddressCity = "billing city";
            owner.BillingAddressState = "billing state";
            owner.BillingAddressPostalCode = "6008";
            owner.BillingAddressCountryID = 1;

            OwnerComponent ownerComponent = new OwnerComponent();
            return ownerComponent.RegisterNewCommunityOwner(owner);
        }

        public int SupplierInsert()
        {
            Supplier supplier = new Supplier();
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
            supplier.AddressCountryID = 1;
            supplier.BillingName = "test billing";
            supplier.BillingAddressLine1 = "billing address1";
            supplier.BillingAddressLine2 = "billing address2";
            supplier.BillingAddressCity = "billing city";
            supplier.BillingAddressState = "billing state";
            supplier.BillingAddressPostalCode = "50009";
            supplier.BillingAddressCountryID = 1;
            supplier.BusinessNumber = "123434";
            supplier.Longitude = 10.5M;
            supplier.Latitude = 12.4M;

            SupplierComponent supplierComponent = new SupplierComponent();
            return supplierComponent.SupplierInsert(supplier);
        }

        public int CustomerInsert()
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
            return customerComponent.CustomerInsert(customer);
        }

        public int CommunityInsert(int ownerId)
        {
            Community commnity = new Community();
            commnity.Name = "Unit Test Community.";
            commnity.Description = "Unit Test Community Description.";
            commnity.CurrencyId = 1;
            commnity.CountryID = 1;
            commnity.OwnerID = ownerId;
            commnity.CentreLongitude = 10.34M;
            commnity.CentreLatitude = 5.6M;
            commnity.AutoTransferAmtOwner = 10;
            commnity.Active = true;

            CommunityComponent communityComponent = new CommunityComponent();
            commnity = communityComponent.CommunityInsert(commnity);
            return commnity.CommunityID;
        }
    }
}
