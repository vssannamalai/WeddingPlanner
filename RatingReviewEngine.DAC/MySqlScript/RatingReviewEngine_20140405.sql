CREATE DATABASE  IF NOT EXISTS `ratingreviewengine` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `ratingreviewengine`;
-- MySQL dump 10.13  Distrib 5.5.16, for Win32 (x86)
--
-- Host: localhost    Database: ratingreviewengine
-- ------------------------------------------------------
-- Server version	5.5.25a

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `supplieraction`
--

DROP TABLE IF EXISTS `supplieraction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supplieraction` (
  `SupplierActionID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerID` int(11) NOT NULL,
  `SupplierID` int(11) NOT NULL,
  `CommunityID` int(11) DEFAULT NULL,
  `CommunityGroupID` int(11) NOT NULL,
  `ActionID` int(11) NOT NULL,
  `ActionDate` datetime NOT NULL COMMENT 'Datetime the action occurred',
  `Detail` varchar(200) DEFAULT NULL COMMENT 'Content of the action. I.e., if the action is a ''message received'', then the value of this field will be the content of the message. If the action is a ''quote'', then the value of this field will be the content of the quote. If the action is a ''question'', then the value of this field will be the content of the message.\nThis field can be null as not all action types have associated detail.',
  `ResponseActionPerformed` bit(1) DEFAULT NULL COMMENT 'If the action is of a type that requires some sort of response action (derived from\nActions.ResponseActionResponse), then this field is used to indicate if that response has been actioned.\nI.e., if the Action is of type "Quote Request", and the required response action is "Quote", then upon first creation of this "Quote Request", the "ResponseActionPerformed" field is to be set to "true" to indicate that a response action is required. Once the Quote is generated (as associated to this action), the "ResponseActionPerformed" value is to be set to "false" to indicate that the action has been performed.',
  PRIMARY KEY (`SupplierActionID`),
  KEY `FK_SupplierAction_ActionID` (`ActionID`),
  KEY `FK_SupplierAction_CustomerID` (`CustomerID`),
  KEY `FK_SupplierAction_SupplierID` (`SupplierID`),
  CONSTRAINT `FK_SupplierAction_ActionID` FOREIGN KEY (`ActionID`) REFERENCES `actions` (`ActionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierAction_CustomerID` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierAction_SupplierID` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplieraction`
--

LOCK TABLES `supplieraction` WRITE;
/*!40000 ALTER TABLE `supplieraction` DISABLE KEYS */;
/*!40000 ALTER TABLE `supplieraction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplierlogo`
--

DROP TABLE IF EXISTS `supplierlogo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supplierlogo` (
  `SupplierID` int(11) NOT NULL,
  `Logo` binary(10) NOT NULL,
  PRIMARY KEY (`SupplierID`),
  KEY `FK_SupplierLogo_SupplierID` (`SupplierID`),
  CONSTRAINT `FK_SupplierLogo_SupplierID` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplierlogo`
--

LOCK TABLES `supplierlogo` WRITE;
/*!40000 ALTER TABLE `supplierlogo` DISABLE KEYS */;
/*!40000 ALTER TABLE `supplierlogo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customersupplieractionattachment`
--

DROP TABLE IF EXISTS `customersupplieractionattachment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customersupplieractionattachment` (
  `CustomerSupplierActionAttachmentID` int(11) NOT NULL,
  `Attachment` binary(10) NOT NULL COMMENT 'Any image or pdf file that is to be attached to an individual action. E.g., if the Action was a ''Quote Request'', then the customer may have attached an example image of the cake they want designed.',
  PRIMARY KEY (`CustomerSupplierActionAttachmentID`),
  KEY `FK_CustomerSupplierActionAttachmentID` (`CustomerSupplierActionAttachmentID`),
  CONSTRAINT `FK_CustomerSupplierActionAttachmentID` FOREIGN KEY (`CustomerSupplierActionAttachmentID`) REFERENCES `supplieraction` (`SupplierActionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customersupplieractionattachment`
--

LOCK TABLES `customersupplieractionattachment` WRITE;
/*!40000 ALTER TABLE `customersupplieractionattachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `customersupplieractionattachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplierbankingdetails`
--

DROP TABLE IF EXISTS `supplierbankingdetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supplierbankingdetails` (
  `SupplierID` int(11) NOT NULL,
  `Bank` varchar(50) NOT NULL,
  `AccountName` varchar(50) NOT NULL,
  `BSB` varchar(10) NOT NULL,
  `AccountNumber` varchar(20) NOT NULL,
  PRIMARY KEY (`SupplierID`),
  KEY `FK_SupplierBankingDetails_SupplierID` (`SupplierID`),
  CONSTRAINT `FK_SupplierBankingDetails_SupplierID` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplierbankingdetails`
--

LOCK TABLES `supplierbankingdetails` WRITE;
/*!40000 ALTER TABLE `supplierbankingdetails` DISABLE KEYS */;
/*!40000 ALTER TABLE `supplierbankingdetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliericon`
--

DROP TABLE IF EXISTS `suppliericon`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suppliericon` (
  `SupplierID` int(11) NOT NULL,
  `Icon` binary(10) NOT NULL,
  KEY `FK_SupplierIcon_SupplierID` (`SupplierID`),
  CONSTRAINT `FK_SupplierIcon_SupplierID` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliericon`
--

LOCK TABLES `suppliericon` WRITE;
/*!40000 ALTER TABLE `suppliericon` DISABLE KEYS */;
/*!40000 ALTER TABLE `suppliericon` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `creditallocationtypes`
--

DROP TABLE IF EXISTS `creditallocationtypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `creditallocationtypes` (
  `CreditAllocationTypeID` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL COMMENT 'Options include: "Credit", "Allocation", "Debit"',
  PRIMARY KEY (`CreditAllocationTypeID`),
  UNIQUE KEY `UQ_CreditAllocationTypes_Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `creditallocationtypes`
--

LOCK TABLES `creditallocationtypes` WRITE;
/*!40000 ALTER TABLE `creditallocationtypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `creditallocationtypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `communitygroup`
--

DROP TABLE IF EXISTS `communitygroup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `communitygroup` (
  `CommunityGroupID` int(11) NOT NULL AUTO_INCREMENT,
  `CommunityID` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `Description` varchar(200) DEFAULT NULL,
  `CreditMin` decimal(10,2) DEFAULT NULL COMMENT 'A minimum credit bound that a supplier can have within the given community group. When suppliers reach below this credit min, they appear as "Below Min Suppliers".',
  `CurrencyID` int(11) NOT NULL COMMENT 'The currency that this community group''s financials are managed in. NB: The default currency is the currency of the parent community.',
  `Active` bit(1) NOT NULL COMMENT 'If the community group is active within the system, then the value is "1"\nIf the community group is not active within the system, then the value is "0"',
  PRIMARY KEY (`CommunityGroupID`),
  UNIQUE KEY `UQ_CommunityGroup_CommunityID` (`CommunityID`),
  UNIQUE KEY `UQ_CommunityGroup_Name` (`Name`),
  UNIQUE KEY `UQ_CommunityGroup_CommunityIDName` (`CommunityID`,`Name`),
  KEY `FK_CommunityGroup_CommunityID` (`CommunityID`),
  CONSTRAINT `FK_CommunityGroup_CommunityID` FOREIGN KEY (`CommunityID`) REFERENCES `community` (`CommunityID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `communitygroup`
--

LOCK TABLES `communitygroup` WRITE;
/*!40000 ALTER TABLE `communitygroup` DISABLE KEYS */;
INSERT INTO `communitygroup` VALUES (2,1,'test','test',1.00,1,'');
/*!40000 ALTER TABLE `communitygroup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `community`
--

DROP TABLE IF EXISTS `community`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `community` (
  `CommunityID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) NOT NULL,
  `Description` varchar(200) DEFAULT NULL,
  `CurrencyId` int(11) NOT NULL,
  `CountryID` int(11) NOT NULL,
  `OwnerID` int(11) NOT NULL,
  `CentreLongitude` decimal(10,4) NOT NULL COMMENT 'Specifies the longitude coordinate of the area centre to which this community applies',
  `CentreLatitude` decimal(10,4) NOT NULL COMMENT 'Specifies the latitude coordinate of the area centre to which this community applies',
  `AreaRadius` decimal(10,3) NOT NULL COMMENT 'Specifies the radius out from the centre (based on CentreLongitude & CentreLatitude) that covers the primary area of this community.',
  `AutoTransferAmtOwner` decimal(10,2) DEFAULT NULL COMMENT 'The auto-transfer amount is the amount of money that the community owner wants automatically transferred from their virtual account to their designated account. I.e., if the community owner sets the auto-transfer amount for the given community to be "100.00", then once the balance within the community owner''s account community balance reaches $100.00, the community owner will have $100.00 transferred out of their virtual account and into their specified bank account.',
  `Active` bit(1) NOT NULL COMMENT 'If the community is active within the system, then the value is "1"\nIf the community is not active within the system, then the value is "0"',
  PRIMARY KEY (`CommunityID`),
  UNIQUE KEY `UQ_Community_Name` (`Name`),
  KEY `FK_Community_CurrencyId` (`CurrencyId`),
  KEY `FK_Community_OwnerID` (`OwnerID`),
  KEY `FK_Community_CountryID` (`CountryID`),
  CONSTRAINT `FK_Community_CountryID` FOREIGN KEY (`CountryID`) REFERENCES `country` (`CountryID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Community_CurrencyId` FOREIGN KEY (`CurrencyId`) REFERENCES `currency` (`CurrencyID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Community_OwnerID` FOREIGN KEY (`OwnerID`) REFERENCES `owner` (`OwnerID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `community`
--

LOCK TABLES `community` WRITE;
/*!40000 ALTER TABLE `community` DISABLE KEYS */;
INSERT INTO `community` VALUES (1,'test1','test descr',1,1,1,20.0000,10.0000,3.000,7.00,'');
/*!40000 ALTER TABLE `community` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliercommunitybillfreeoverride`
--

DROP TABLE IF EXISTS `suppliercommunitybillfreeoverride`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suppliercommunitybillfreeoverride` (
  `SupplierCommunityBillFreeOverrideID` int(11) NOT NULL,
  `CommunitySupplierID` int(11) NOT NULL,
  `CommunityGroupBillingFeeID` int(11) NOT NULL,
  `BillFreeStart` date NOT NULL COMMENT 'The date that the bill-free period commences',
  `BillFreeEnd` date NOT NULL COMMENT 'The date that the bill-free period finishes',
  `IsActive` bit(1) NOT NULL COMMENT 'If the current date is within the bounds of the BillFreeStart and BillFreeEnd inclusively, then the value is "true" else "false"',
  `CommunityID` int(11) NOT NULL,
  `CommunityGroupID` int(11) NOT NULL,
  `SupplierID` int(11) NOT NULL,
  PRIMARY KEY (`SupplierCommunityBillFreeOverrideID`),
  KEY `FK_SupplierCommunityBillFreeOverride_CommunityGroupID` (`CommunityGroupID`),
  KEY `FK_SupplierCommunityBillFreeOverride_CommunityID` (`CommunityID`),
  KEY `FK_SupplierCommunityBillFreeOverride_CommunitySupplierID` (`CommunitySupplierID`),
  KEY `FK_SupplierCommunityBillFreeOverride_SupplierID` (`SupplierID`),
  KEY `FK_SupplierCommunityBillFreeOverride_CommunityGroupBillingFeeID` (`CommunityGroupBillingFeeID`),
  CONSTRAINT `FK_SupplierCommunityBillFreeOverride_CommunityGroupBillingFeeID` FOREIGN KEY (`CommunityGroupBillingFeeID`) REFERENCES `communitygroupbillingfee` (`CommunityGroupBillingFeeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierCommunityBillFreeOverride_CommunityGroupID` FOREIGN KEY (`CommunityGroupID`) REFERENCES `communitygroup` (`CommunityGroupID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierCommunityBillFreeOverride_CommunityID` FOREIGN KEY (`CommunityID`) REFERENCES `community` (`CommunityID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierCommunityBillFreeOverride_CommunitySupplierID` FOREIGN KEY (`CommunitySupplierID`) REFERENCES `communitysupplier` (`CommunitySupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierCommunityBillFreeOverride_SupplierID` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliercommunitybillfreeoverride`
--

LOCK TABLES `suppliercommunitybillfreeoverride` WRITE;
/*!40000 ALTER TABLE `suppliercommunitybillfreeoverride` DISABLE KEYS */;
/*!40000 ALTER TABLE `suppliercommunitybillfreeoverride` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `currency`
--

DROP TABLE IF EXISTS `currency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `currency` (
  `CurrencyID` int(11) NOT NULL AUTO_INCREMENT,
  `ISOCode` varchar(3) NOT NULL COMMENT 'The ISO currency code corresponding to the currency',
  `Description` varchar(50) NOT NULL COMMENT 'The full currency description. I.e., if the ISOCode is "AUD" then the value of this Description field will be "Australian Dollar"',
  `MinTransferAmount` decimal(10,2) DEFAULT NULL COMMENT 'The minimum transfer amount as specified against an individual currency. I.e., to ensure that a Supplier tops up their credit amount by a denomination that covers transaction costs, a transfer minimum will be specified. This transfer minimum also related to the transferring of revenue funds back to a supplier. The transfer minimum is set per currency.\nThe MinTransferAmount is mandatory if IsActive = true.',
  `IsActive` bit(1) NOT NULL COMMENT 'If the currency is available, then the value will be "true"\nIf the currency is not available, then the value will be "false"',
  PRIMARY KEY (`CurrencyID`),
  UNIQUE KEY `UQ_Currency_ISOCode` (`ISOCode`),
  UNIQUE KEY `UQ_Currency_Description` (`Description`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currency`
--

LOCK TABLES `currency` WRITE;
/*!40000 ALTER TABLE `currency` DISABLE KEYS */;
INSERT INTO `currency` VALUES (1,'RE','Ruppe',2.00,''),(2,'DOL','Doller',10.00,''),(3,'Rup','Ruppees',1.10,'');
/*!40000 ALTER TABLE `currency` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customerrewards`
--

DROP TABLE IF EXISTS `customerrewards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customerrewards` (
  `CustomerRewardID` int(11) NOT NULL,
  `CommunityID` int(11) NOT NULL COMMENT 'The community that these customer reward points are associated to.',
  `CustomerID` int(11) NOT NULL,
  `RewardDate` datetime DEFAULT NULL COMMENT 'The datetime stamp of when the reward was applied',
  `CommunityRewardID` int(11) NOT NULL,
  `RewardName` varchar(150) NOT NULL COMMENT 'The name of the reward at the time the reward was given',
  `RewardDescription` varchar(200) NOT NULL COMMENT 'The description of the reward at the time the reward was given',
  `PointsApplied` int(11) NOT NULL COMMENT 'The number of points that were applied at the time the reward was given.\nNB: If points have been revoked (e.g. for a review that has been ''hidden'' by the community owner, then this field must cater for a negative PointsApplied value',
  `TriggeredEventsID` int(11) NOT NULL,
  KEY `FK_CustomerRewards_CommunityRewardID` (`CommunityRewardID`),
  KEY `FK_CustomerRewards_TriggeredEventsID` (`TriggeredEventsID`),
  CONSTRAINT `FK_CustomerRewards_CommunityRewardID` FOREIGN KEY (`CommunityRewardID`) REFERENCES `communityreward` (`CommunityRewardID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CustomerRewards_TriggeredEventsID` FOREIGN KEY (`TriggeredEventsID`) REFERENCES `triggeredevent` (`TriggeredEventID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customerrewards`
--

LOCK TABLES `customerrewards` WRITE;
/*!40000 ALTER TABLE `customerrewards` DISABLE KEYS */;
/*!40000 ALTER TABLE `customerrewards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `owner`
--

DROP TABLE IF EXISTS `owner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `owner` (
  `OwnerID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyName` varchar(50) NOT NULL,
  `Email` varchar(200) NOT NULL,
  `BusinessNumber` varchar(50) NOT NULL,
  `PreferredPaymentCurrencyID` int(11) NOT NULL COMMENT 'Will be defaulted to the currency of the community that the owner is owner of',
  `PrimaryPhone` varchar(50) NOT NULL,
  `OtherPhone` varchar(50) DEFAULT NULL,
  `DateAdded` datetime NOT NULL,
  `Website` varchar(50) DEFAULT NULL,
  `AddressLine1` varchar(150) DEFAULT NULL,
  `AddressLine2` varchar(150) DEFAULT NULL,
  `AddressCity` varchar(50) DEFAULT NULL,
  `AddressState` varchar(50) DEFAULT NULL,
  `AddressPostalCode` varchar(50) DEFAULT NULL,
  `AddressCountryID` int(11) DEFAULT NULL,
  `BillingName` varchar(150) DEFAULT NULL,
  `BillingAddressLine1` varchar(150) DEFAULT NULL,
  `BillingAddressLine2` varchar(150) DEFAULT NULL,
  `BillingAddressCity` varchar(50) DEFAULT NULL,
  `BillingAddressState` varchar(50) DEFAULT NULL,
  `BillingAddressPostalCode` varchar(50) DEFAULT NULL,
  `BillingAddressCountryID` int(11) DEFAULT NULL,
  PRIMARY KEY (`OwnerID`),
  UNIQUE KEY `UQ_CommunityOwner_Email` (`Email`),
  KEY `FK_Owner_AddressCountryID` (`AddressCountryID`),
  KEY `FK_Owner_BillingAddressCountryID` (`BillingAddressCountryID`),
  CONSTRAINT `FK_Owner_AddressCountryID` FOREIGN KEY (`AddressCountryID`) REFERENCES `country` (`CountryID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Owner_BillingAddressCountryID` FOREIGN KEY (`BillingAddressCountryID`) REFERENCES `country` (`CountryID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `owner`
--

LOCK TABLES `owner` WRITE;
/*!40000 ALTER TABLE `owner` DISABLE KEYS */;
INSERT INTO `owner` VALUES (1,'test','test@test.com','1234',1,'5678','67878','2014-03-25 10:02:32','www.test.com','dfgdfgd','df','city','state','6005',1,'test','test','','city','state','6009',1),(3,'test','test1@test.com','1234',1,'5678','67878','2014-03-27 18:38:43','www.test.com','dfgdfgd','df','city','state','6005',1,'test','test','','city','state','6009',1);
/*!40000 ALTER TABLE `owner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicationauthentication`
--

DROP TABLE IF EXISTS `applicationauthentication`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applicationauthentication` (
  `ApplicationID` int(11) NOT NULL AUTO_INCREMENT,
  `ApplicationName` varchar(50) NOT NULL,
  `TokenGenerated` datetime DEFAULT NULL,
  `APIToken` varchar(50) DEFAULT NULL,
  `LastConnection` datetime DEFAULT NULL,
  `IsActive` bit(1) NOT NULL COMMENT 'If the token is still active, then the value will be "true".\nIf the token is not active, then the value will be "false".',
  `RegisteredEmail` varchar(200) NOT NULL COMMENT 'Registered email address responsible for managing the consumption of the generated API token.\nAll correspondence relating to API tokens etc will be sent to this registered email address.',
  `CommunityID` int(11) NOT NULL COMMENT 'The CommunityID that this application reference is associated to.\nIn order for a Community Owner to apply for an API Token, a Community must be supplied.\nOnly one Application Token can be active for one Community at any one time.',
  PRIMARY KEY (`ApplicationID`),
  UNIQUE KEY `UQ_ApplicationAuthentication_ApplicationName` (`ApplicationName`),
  UNIQUE KEY `UQ_ApplicationAuthentication_APIToken` (`APIToken`),
  KEY `FK_CommunityID` (`CommunityID`),
  CONSTRAINT `FK_ApplicationAuthentication_CommunityID` FOREIGN KEY (`CommunityID`) REFERENCES `community` (`CommunityID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicationauthentication`
--

LOCK TABLES `applicationauthentication` WRITE;
/*!40000 ALTER TABLE `applicationauthentication` DISABLE KEYS */;
/*!40000 ALTER TABLE `applicationauthentication` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `communityreward`
--

DROP TABLE IF EXISTS `communityreward`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `communityreward` (
  `CommunityRewardID` int(11) NOT NULL,
  `CommunityID` int(11) NOT NULL,
  `TriggeredEventsID` int(11) NOT NULL,
  `Points` int(11) NOT NULL COMMENT 'The number of ''reward points'' that will be applied to the customer for initiating the referenced action for a given community.',
  PRIMARY KEY (`CommunityRewardID`),
  KEY `FK_CommunityRewards_TriggeredEventsID` (`TriggeredEventsID`),
  CONSTRAINT `FK_CommunityRewards_TriggeredEventsID` FOREIGN KEY (`TriggeredEventsID`) REFERENCES `triggeredevent` (`TriggeredEventID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `communityreward`
--

LOCK TABLES `communityreward` WRITE;
/*!40000 ALTER TABLE `communityreward` DISABLE KEYS */;
/*!40000 ALTER TABLE `communityreward` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entityoauthaccount`
--

DROP TABLE IF EXISTS `entityoauthaccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entityoauthaccount` (
  `EntityOAuthAccountID` int(11) NOT NULL AUTO_INCREMENT,
  `EntityType` varchar(50) DEFAULT NULL COMMENT 'The entity type is the type of user. Entity types are given a name consistent with the table data that contains their data. For example, an entity type of "Customer" will connect to the "customer" table to associate the given OAuth 2.0 Membership to the account. Entity types will be either "Customer", "Supplier" or "CommunityOwner"',
  `EntityID` int(11) NOT NULL,
  `OAuthAccountID` int(11) NOT NULL,
  PRIMARY KEY (`EntityOAuthAccountID`),
  KEY `FK_EntityOAuthAccount_EntityID` (`EntityID`),
  KEY `FK_EntityOAuthAccount_OAuthAccount` (`OAuthAccountID`),
  CONSTRAINT `FK_EntityOAuthAccount_OAuthAccount` FOREIGN KEY (`OAuthAccountID`) REFERENCES `oauthaccount` (`OAuthAccountID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entityoauthaccount`
--

LOCK TABLES `entityoauthaccount` WRITE;
/*!40000 ALTER TABLE `entityoauthaccount` DISABLE KEYS */;
INSERT INTO `entityoauthaccount` VALUES (1,'Supplier',2,1),(2,'CommunityOwner',1,1),(3,'CommunityOwner',3,1),(14,'CommunityOwner',8,3),(22,'CommunityOwner',17,16),(23,'CommunityOwner',18,1),(29,'CommunityOwner',25,1),(31,'CommunityOwner',27,1);
/*!40000 ALTER TABLE `entityoauthaccount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review` (
  `ReviewID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerID` int(11) NOT NULL,
  `SupplierID` int(11) NOT NULL,
  `CommunityID` int(11) NOT NULL,
  `CommunityGroupID` int(11) NOT NULL,
  `Rating` int(11) NOT NULL COMMENT 'Minimum bound = 0\nMaximum bound = 5',
  `Review` text NOT NULL COMMENT 'Review written by the Customer',
  `ReviewDate` datetime NOT NULL COMMENT 'Datetime stamp when the review was created.',
  `HideReview` bit(1) NOT NULL DEFAULT b'0' COMMENT 'If the review is able to be viewed publicly, then the value will be "false".\nIf the review is required to be hidden, then the value will be "false".',
  PRIMARY KEY (`ReviewID`),
  UNIQUE KEY `UQ_CustomerID` (`CustomerID`),
  UNIQUE KEY `UQ_SupplierID` (`SupplierID`),
  UNIQUE KEY `UQ_CommunityID` (`CommunityID`),
  UNIQUE KEY `UQ_CommunityGroupID` (`CommunityGroupID`),
  UNIQUE KEY `UQ_Review` (`CustomerID`,`SupplierID`,`CommunityID`,`CommunityGroupID`),
  KEY `FK_Review_CommunityGroupID` (`CommunityGroupID`),
  KEY `FK_Review_CommunityID` (`CommunityID`),
  KEY `FK_Review_CustomerID` (`CustomerID`),
  KEY `FK_Review_SupplierID` (`SupplierID`),
  CONSTRAINT `FK_Review_CommunityGroupID` FOREIGN KEY (`CommunityGroupID`) REFERENCES `communitygroup` (`CommunityGroupID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Review_CommunityID` FOREIGN KEY (`CommunityID`) REFERENCES `community` (`CommunityID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Review_CustomerID` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Review_SupplierID` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliershortlist`
--

DROP TABLE IF EXISTS `suppliershortlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suppliershortlist` (
  `SupplierShortlistID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerID` int(11) NOT NULL,
  `CommunityID` int(11) NOT NULL,
  `CommunityGroupID` int(11) NOT NULL,
  `SupplierID` int(11) NOT NULL,
  PRIMARY KEY (`SupplierShortlistID`),
  UNIQUE KEY `UQ_CustomerID` (`CustomerID`),
  UNIQUE KEY `UQ_CommunityID` (`CommunityID`),
  UNIQUE KEY `UQ_CommunityGroupID` (`CommunityGroupID`),
  UNIQUE KEY `UQ_SupplierID` (`SupplierID`),
  UNIQUE KEY `UQ_SupplierShortlist` (`CustomerID`,`CommunityID`,`CommunityGroupID`,`SupplierID`),
  KEY `FK_SupplierShortlist_CommunityGroupID` (`CommunityGroupID`),
  KEY `FK_SupplierShortlist_CommunityID` (`CommunityID`),
  KEY `FK_SupplierShortlist_CustomerID` (`CustomerID`),
  KEY `FK_SupplierShortlist_SupplierID` (`SupplierID`),
  CONSTRAINT `FK_SupplierShortlist_CommunityGroupID` FOREIGN KEY (`CommunityGroupID`) REFERENCES `communitygroup` (`CommunityGroupID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierShortlist_CommunityID` FOREIGN KEY (`CommunityID`) REFERENCES `community` (`CommunityID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierShortlist_CustomerID` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierShortlist_SupplierID` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliershortlist`
--

LOCK TABLES `suppliershortlist` WRITE;
/*!40000 ALTER TABLE `suppliershortlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `suppliershortlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `socialmedia`
--

DROP TABLE IF EXISTS `socialmedia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `socialmedia` (
  `SocialMediaID` int(11) NOT NULL,
  `Name` varchar(100) NOT NULL COMMENT 'The name of the relevant social media outlet. E.g., "Facebook", "Twitter", "Pinterest", "FourSquare", "Instagram", "Google+", "LinkedIn", etc.',
  PRIMARY KEY (`SocialMediaID`),
  UNIQUE KEY `UQ_SocialMedia_Name` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `socialmedia`
--

LOCK TABLES `socialmedia` WRITE;
/*!40000 ALTER TABLE `socialmedia` DISABLE KEYS */;
INSERT INTO `socialmedia` VALUES (1,'Facebook'),(4,'FourSquare'),(6,'Google+'),(5,'Instagram'),(7,'LinkedIn'),(3,'Pinterest'),(2,'Twitter');
/*!40000 ALTER TABLE `socialmedia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliercreditallocations`
--

DROP TABLE IF EXISTS `suppliercreditallocations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suppliercreditallocations` (
  `SupplierCreditAllocationID` int(11) NOT NULL,
  `RecVer` int(11) NOT NULL,
  `SupplierID` int(11) NOT NULL,
  `CreditAllocationTypeID` int(11) NOT NULL,
  `Description` varchar(50) NOT NULL,
  `AllocateFrom` int(11) NOT NULL COMMENT 'CommunityID from which the allocation is comming.\nNB: "0" is a new credit - has not come from a community;\n"0001" is an ''unallocated'' community - i.e., a repository of unallocated credit that is pending the supplier allocating out to each community they''re associated with',
  `AllocateTo` int(11) NOT NULL COMMENT 'CommunityID that the allocation is being allocated to.\nNB: "0001" is an ''unallocated'' community - i.e., a repository of unallocated credit that is pending the supplier allocating out to each community they''re associated with. In this instance, it would mean that allocated credit is being ''unallocated'' from the community and brought back into the general repository.',
  `Amount` decimal(10,2) NOT NULL,
  `Date` datetime NOT NULL COMMENT 'The datetime stamp of when the allocation was processed',
  PRIMARY KEY (`SupplierCreditAllocationID`),
  KEY `FK_SupplierCreditAllocations_CreditAllocationTypeID` (`CreditAllocationTypeID`),
  KEY `FK_SupplierCreditAllocations_SupplierID` (`SupplierID`),
  CONSTRAINT `FK_SupplierCreditAllocations_CreditAllocationTypeID` FOREIGN KEY (`CreditAllocationTypeID`) REFERENCES `creditallocationtypes` (`CreditAllocationTypeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierCreditAllocations_SupplierID` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliercreditallocations`
--

LOCK TABLES `suppliercreditallocations` WRITE;
/*!40000 ALTER TABLE `suppliercreditallocations` DISABLE KEYS */;
/*!40000 ALTER TABLE `suppliercreditallocations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `communitygroupbillingfee`
--

DROP TABLE IF EXISTS `communitygroupbillingfee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `communitygroupbillingfee` (
  `CommunityGroupBillingFeeID` int(11) NOT NULL,
  `TriggeredEventID` int(11) NOT NULL COMMENT 'Reference back to the particular action that this community-configured fee is being applied to.',
  `CommunityGroupID` int(11) NOT NULL,
  `Fee` decimal(10,2) NOT NULL COMMENT 'The fee that is to be billed to the supplier for the particular service',
  `FeeCurrencyID` int(11) NOT NULL COMMENT 'Reference to the particular currency that this fee is defined in - based off the Community Default Currency. E.g., if the parent community currency is USD, then the ''fee'' would automatically be defined in USD.',
  `IsFeePercentage` bit(1) NOT NULL DEFAULT b'1' COMMENT 'If the fee is actually a percentage of an amount, then the value of this field will be "true". E.g., the action being billed is a customer adding the final billed amount for the supplier. This fee is setup as a percentage of 0.01. Therefore, if the final amount of the transaction between the supplier and the customer was $1000.00, then the supplier will be billed 1% which is $10.00.\nIf the fee is billed as a fixed amount, then the value of this field will be "false". E.g., the action being billed is a customer adding a recommendation for the supplier. This fee is $0.02 as a fixed amount. Therefore, if 3 customers have added recommendations for the supplier within a single billing period, then the supplier will be billed 3 x .02 = $0.06 for this service.',
  `BillFreeDays` int(11) NOT NULL DEFAULT '0' COMMENT 'The number of days that a newly registered supplier will remain bill-free for within this community group for the given action.\nI.e., if the supplier joins the community on 01/03/2014 and they are bill-free for 10 days for the ''View'' action, then the supplier will not have any credit deducted from their community virtual account for customer views until 11/03/2014.',
  `DateUpdated` datetime NOT NULL COMMENT 'The datetime stamp of when the fee was last updated',
  PRIMARY KEY (`CommunityGroupBillingFeeID`),
  KEY `FK_CommunityGroupBillingFee_CommunityGroupID` (`CommunityGroupID`),
  KEY `FK_CommunityGroupBillingFee_TriggeredEventID` (`TriggeredEventID`),
  CONSTRAINT `FK_CommunityGroupBillingFee_CommunityGroupID` FOREIGN KEY (`CommunityGroupID`) REFERENCES `communitygroup` (`CommunityGroupID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CommunityGroupBillingFee_TriggeredEventID` FOREIGN KEY (`TriggeredEventID`) REFERENCES `triggeredevent` (`TriggeredEventID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `communitygroupbillingfee`
--

LOCK TABLES `communitygroupbillingfee` WRITE;
/*!40000 ALTER TABLE `communitygroupbillingfee` DISABLE KEYS */;
/*!40000 ALTER TABLE `communitygroupbillingfee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `supplier` (
  `SupplierID` int(11) NOT NULL AUTO_INCREMENT,
  `CompanyName` varchar(50) NOT NULL,
  `Email` varchar(200) NOT NULL,
  `Website` varchar(200) DEFAULT NULL COMMENT 'Supplier''s website',
  `PrimaryPhone` varchar(50) DEFAULT NULL,
  `OtherPhone` varchar(50) DEFAULT NULL,
  `AddressLine1` varchar(150) DEFAULT NULL,
  `AddressLine2` varchar(150) DEFAULT NULL,
  `AddressCity` varchar(50) DEFAULT NULL,
  `AddressState` varchar(50) DEFAULT NULL,
  `AddressPostalCode` varchar(50) DEFAULT NULL,
  `AddressCountryID` int(11) DEFAULT NULL,
  `BillingName` varchar(150) DEFAULT NULL,
  `BillingAddressLine1` varchar(150) DEFAULT NULL,
  `BillingAddressLine2` varchar(150) DEFAULT NULL,
  `BillingAddressCity` varchar(50) DEFAULT NULL,
  `BillingAddressState` varchar(50) DEFAULT NULL,
  `BillingAddressPostalCode` varchar(50) DEFAULT NULL,
  `BillingAddressCountryID` int(11) DEFAULT NULL,
  `BusinessNumber` varchar(50) DEFAULT NULL,
  `Longitude` decimal(10,4) DEFAULT NULL COMMENT 'Longitude of the supplier''s location for pinpointing on a map',
  `Latitude` decimal(10,4) DEFAULT NULL COMMENT 'Latitude of the supplier''s location for pinpointing on a map',
  `DateAdded` datetime NOT NULL COMMENT 'The datetime stamp indicating when the supplier was added to the system',
  `ProfileCompletedDate` datetime DEFAULT NULL COMMENT 'The datetime stamp indicating when the supplier finalised their profile',
  `QuoteTerms` varchar(250) NOT NULL DEFAULT 'This quote is valid for 30 days from the date of issue.' COMMENT 'The supplier''s quote terms - the quote terms are to appear anywhere that a supplier''s quote is displayed or issued.\nField cannot be null and is pre-populated with a standard quote statement of "This quote is valid for 30 days from the date of issue."',
  `DepositPercent` decimal(10,2) NOT NULL DEFAULT '10.00' COMMENT 'The deposit percentage that the Supplier specifies in order to confirm a customer''s intention to purchase.\nIf the deposit percentage is "0", then the Supplier does not require a deposit to be paid.\nThe default deposit percentage is set at 10% but can be altered by the Supplier.',
  `DepositTerms` varchar(250) NOT NULL DEFAULT 'Payment of the requested deposit amount confirms the Customer''s intention to pay in full for the product/service as defined within the quote.' COMMENT 'The supplier''s deposit terms - the deposit terms are to appear anywhere that a supplier''s quote or deposit details are displayed or issued.\nField cannot be null and is pre-populated with a standard deposit statement of "Payment of the requested deposit amount confirms the Customer''s intention to pay in full for the product/service as defined within the quote."',
  PRIMARY KEY (`SupplierID`),
  UNIQUE KEY `UQ_Supplier_CompanyName` (`CompanyName`),
  UNIQUE KEY `UQ_Supplier_Email` (`Email`),
  KEY `FK_Supplier_AddressCountryID` (`AddressCountryID`),
  KEY `FK_Supplier_BillingAddressCountryID` (`BillingAddressCountryID`),
  CONSTRAINT `FK_Supplier_AddressCountryID` FOREIGN KEY (`AddressCountryID`) REFERENCES `country` (`CountryID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_Supplier_BillingAddressCountryID` FOREIGN KEY (`BillingAddressCountryID`) REFERENCES `country` (`CountryID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
INSERT INTO `supplier` VALUES (2,'test','test@test.com','test.com','5678','','line1','line2','city','state','6009',1,'billing','address1','address2','city','state','6008',1,'12345',40.5000,50.3000,'2014-03-25 16:04:25','2014-03-25 16:04:25','quote',10.00,'deposite');
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customerquote`
--

DROP TABLE IF EXISTS `customerquote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customerquote` (
  `CustomerQuoteID` int(11) NOT NULL,
  `CustomerID` int(11) NOT NULL,
  `CommunityID` int(11) NOT NULL,
  `CommunityGroupID` int(11) NOT NULL,
  `SupplierID` int(11) NOT NULL,
  `QuoteAmount` decimal(10,2) NOT NULL,
  `DepositSpecified` bit(1) NOT NULL COMMENT 'If a deposit was specified as part of the quote, then the value will be "true". If no deposit was specified as part of the quote, then the value will be "false".',
  `DepositAmount` decimal(10,2) NOT NULL COMMENT 'The amount of the deposit that was specified as part of the quote. If no deposit was specified, then this value will be "0".',
  `QuoteTerms` varchar(200) DEFAULT NULL COMMENT 'The supplier''s quote terms at the time of generating the quote.',
  `DepositTerms` varchar(200) DEFAULT NULL COMMENT 'The supplier''s deposit terms at the time of generating the quote.',
  `CurrencyID` int(11) NOT NULL COMMENT 'Reference to the unique id of the currency that this quote was specified in',
  `QuoteDetail` varchar(200) NOT NULL COMMENT 'The detail associated with the quote.',
  `SupplierActionID` int(11) NOT NULL COMMENT 'Reference to the relevant SupplierActionID for the "Quote" action that this Quote relates to.',
  PRIMARY KEY (`CustomerQuoteID`),
  UNIQUE KEY `UQ_CustomerQuote_SupplierActionID` (`SupplierActionID`),
  KEY `FK_CustomerQuote_CommunityGroupID` (`CommunityGroupID`),
  KEY `FK_CustomerQuote_CommunityID` (`CommunityID`),
  KEY `FK_CustomerQuote_CustomerID` (`CustomerID`),
  KEY `FK_CustomerQuote_SupplierActionID` (`SupplierActionID`),
  KEY `FK_CustomerQuote_SupplierID` (`SupplierID`),
  CONSTRAINT `FK_CustomerQuote_CommunityGroupID` FOREIGN KEY (`CommunityGroupID`) REFERENCES `communitygroup` (`CommunityGroupID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CustomerQuote_CommunityID` FOREIGN KEY (`CommunityID`) REFERENCES `community` (`CommunityID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CustomerQuote_CustomerID` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CustomerQuote_SupplierActionID` FOREIGN KEY (`SupplierActionID`) REFERENCES `supplieraction` (`SupplierActionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CustomerQuote_SupplierID` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customerquote`
--

LOCK TABLES `customerquote` WRITE;
/*!40000 ALTER TABLE `customerquote` DISABLE KEYS */;
/*!40000 ALTER TABLE `customerquote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `communitygroupsupplier`
--

DROP TABLE IF EXISTS `communitygroupsupplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `communitygroupsupplier` (
  `CommunityGroupSupplierID` int(11) NOT NULL AUTO_INCREMENT,
  `SupplierID` int(11) NOT NULL,
  `CommunityID` int(11) NOT NULL,
  `CommunityGroupID` int(11) NOT NULL,
  `DateJoined` datetime NOT NULL COMMENT 'The date the supplier joined the community group.',
  `IsActive` bit(1) NOT NULL COMMENT 'If the supplier-community-community group is currently active, then the value is "true"\nIf the supplier-community-community group is current not active, then the value is "false"',
  PRIMARY KEY (`CommunityGroupSupplierID`),
  UNIQUE KEY `SupplierID_UNIQUE` (`SupplierID`),
  UNIQUE KEY `CommunityID_UNIQUE` (`CommunityID`),
  UNIQUE KEY `CommunityGroupID_UNIQUE` (`CommunityGroupID`),
  KEY `FK_CommunityGroupSupplier_SupplierID` (`SupplierID`),
  KEY `FK_CommunityGroupSupplier_CommunityGroupID` (`CommunityGroupID`),
  KEY `FK_CommunityGroupSupplier_CommunityID` (`CommunityID`),
  CONSTRAINT `FK_CommunityGroupSupplier_CommunityGroupID` FOREIGN KEY (`CommunityGroupID`) REFERENCES `communitygroup` (`CommunityGroupID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CommunityGroupSupplier_CommunityID` FOREIGN KEY (`CommunityID`) REFERENCES `community` (`CommunityID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CommunityGroupSupplier_SupplierID` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `communitygroupsupplier`
--

LOCK TABLES `communitygroupsupplier` WRITE;
/*!40000 ALTER TABLE `communitygroupsupplier` DISABLE KEYS */;
INSERT INTO `communitygroupsupplier` VALUES (4,2,1,2,'2014-03-26 14:30:20','\0');
/*!40000 ALTER TABLE `communitygroupsupplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliercommunitytransactionhistory`
--

DROP TABLE IF EXISTS `suppliercommunitytransactionhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suppliercommunitytransactionhistory` (
  `SupplierCommunityTransactionHistoryID` int(11) NOT NULL AUTO_INCREMENT,
  `SupplierID` int(11) NOT NULL,
  `CommunityID` int(11) NOT NULL,
  `CommunityGroupID` int(11) DEFAULT NULL COMMENT 'If the transaction is performed within the context of a community group, then this field is to be completed. If the transaction is account-based, such as topup or transfer, then this field is to remain null.',
  `Description` varchar(50) NOT NULL COMMENT 'The description of the type of transaction. I.e., could be "CREDIT APPLIED", "CUSTOMER REVIEW", etc.',
  `Amount` decimal(10,2) NOT NULL COMMENT 'The amount of revenue earned by the supplier. Value can be positive or negative.',
  `DateApplied` datetime NOT NULL COMMENT 'The datetime stamp that the revenue was applied',
  `Balance` decimal(10,2) NOT NULL COMMENT 'The current balance based on credits & debits from previous balance. Balance starts at 0 and is credited or debited depending on the amount applied.',
  `CustomerID` int(11) DEFAULT NULL COMMENT 'Reference to the Customer whose action resulted in the generation of this bill.\nThe Supplier will not be able to see details of an individual Customer; however, anonymous metrics will be able to be derived from this relationship. This reference will also enable the Community Owner to perform informative metrics on active Customers whose actions create revenue.\nIf the transaction was not a result of Customer action, then this field will be null.',
  PRIMARY KEY (`SupplierCommunityTransactionHistoryID`),
  KEY `FK_SupplierCommunityTransactionHistory_CommunityGroupID` (`CommunityGroupID`),
  KEY `FK_SupplierCommunityTransactionHistory_CommunityID` (`CommunityID`),
  KEY `FK_SupplierCommunityTransactionHistory_CustomerID` (`CustomerID`),
  KEY `FK_SupplierCommunityTransactionHistory_SupplierID` (`SupplierID`),
  CONSTRAINT `FK_SupplierCommunityTransactionHistory_CommunityGroupID` FOREIGN KEY (`CommunityGroupID`) REFERENCES `communitygroup` (`CommunityGroupID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierCommunityTransactionHistory_CommunityID` FOREIGN KEY (`CommunityID`) REFERENCES `community` (`CommunityID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierCommunityTransactionHistory_CustomerID` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierCommunityTransactionHistory_SupplierID` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliercommunitytransactionhistory`
--

LOCK TABLES `suppliercommunitytransactionhistory` WRITE;
/*!40000 ALTER TABLE `suppliercommunitytransactionhistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `suppliercommunitytransactionhistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `actionresponse`
--

DROP TABLE IF EXISTS `actionresponse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actionresponse` (
  `ActionResponseID` int(11) NOT NULL AUTO_INCREMENT,
  `ActionID` int(11) NOT NULL,
  `ResponseID` int(11) NOT NULL,
  PRIMARY KEY (`ActionResponseID`),
  KEY `FK_ActionResponse_ActionID` (`ActionID`),
  KEY `FK_ActionResponse_ResponseID` (`ResponseID`),
  CONSTRAINT `FK_ActionResponse_ActionID` FOREIGN KEY (`ActionID`) REFERENCES `actions` (`ActionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ActionResponse_ResponseID` FOREIGN KEY (`ResponseID`) REFERENCES `actions` (`ActionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actionresponse`
--

LOCK TABLES `actionresponse` WRITE;
/*!40000 ALTER TABLE `actionresponse` DISABLE KEYS */;
/*!40000 ALTER TABLE `actionresponse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `communitysupplier`
--

DROP TABLE IF EXISTS `communitysupplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `communitysupplier` (
  `CommunitySupplierID` int(11) NOT NULL AUTO_INCREMENT,
  `SupplierID` int(11) NOT NULL,
  `CommunityID` int(11) NOT NULL,
  `DateJoined` datetime NOT NULL COMMENT 'The date the supplier joined the community',
  `IsActive` bit(1) NOT NULL COMMENT 'If the supplier is a current member of a community, then the value of this field will be "true"\nIf the supplier is not a current member of this community, then the value will be "false"',
  `AutoTransferAmtSupplier` decimal(10,2) DEFAULT NULL COMMENT 'The auto-transfer amount is the amount of money that the supplier wants automatically transferred from their virtual account to their designated account. I.e., if the supplier sets the auto-transfer amount for the given community to be "100.00", then once the balance within the supplier''s virtual community account reaches $100.00, the supplier will have $100.00 transferred out of their virtual account and into their specified bank account.',
  `AutoTopUp` bit(1) NOT NULL DEFAULT b'1' COMMENT 'If the supplier wants to setup automated credit top-up for this community, then the value of this field will be "true".\nIf the supplier wants to manage credit top-up for this community manually, then the value of this field will be "false".\nIf the value of this field is "true", then the MinCredit field becomes mandatory. If the value of this field is set to "false", then the MinCredit value is to be cleared.',
  `MinCredit` decimal(10,2) DEFAULT NULL COMMENT 'MinCredit is the minimum amount of credit that the supplier wants to topup their community virtual account by once it hits the designated creditmin for a given community group. If the value of the AutoTopUp field is "true", then this field becomes mandatory.',
  PRIMARY KEY (`CommunitySupplierID`),
  UNIQUE KEY `SupplierID_UNIQUE` (`SupplierID`),
  UNIQUE KEY `CommunityID_UNIQUE` (`CommunityID`),
  UNIQUE KEY `UQ_CommunitySupplier` (`SupplierID`,`CommunityID`),
  KEY `FK_CommunitySupplier_CommunityID` (`CommunityID`),
  KEY `FK_CommunitySupplier_SupplierID` (`SupplierID`),
  CONSTRAINT `FK_CommunitySupplier_CommunityID` FOREIGN KEY (`CommunityID`) REFERENCES `community` (`CommunityID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CommunitySupplier_SupplierID` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `communitysupplier`
--

LOCK TABLES `communitysupplier` WRITE;
/*!40000 ALTER TABLE `communitysupplier` DISABLE KEYS */;
INSERT INTO `communitysupplier` VALUES (1,2,1,'2014-03-26 14:35:10','',10.00,'',5.00);
/*!40000 ALTER TABLE `communitysupplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billingreference`
--

DROP TABLE IF EXISTS `billingreference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `billingreference` (
  `CommunityOwnerTransactionHistoryID` int(11) NOT NULL,
  `SupplierCommunityTransactionHistoryID` int(11) NOT NULL,
  UNIQUE KEY `UQ_BillingReference` (`CommunityOwnerTransactionHistoryID`,`SupplierCommunityTransactionHistoryID`),
  KEY `FK_CommunityOwnerTransactionHistoryID` (`CommunityOwnerTransactionHistoryID`),
  KEY `FK_SupplierCommunityTransactionHistoryID` (`SupplierCommunityTransactionHistoryID`),
  CONSTRAINT `FK_CommunityOwnerTransactionHistoryID` FOREIGN KEY (`CommunityOwnerTransactionHistoryID`) REFERENCES `communityownertransactionhistory` (`CommunityOwnerTransactionHistoryID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierCommunityTransactionHistoryID` FOREIGN KEY (`SupplierCommunityTransactionHistoryID`) REFERENCES `suppliercommunitytransactionhistory` (`SupplierCommunityTransactionHistoryID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billingreference`
--

LOCK TABLES `billingreference` WRITE;
/*!40000 ALTER TABLE `billingreference` DISABLE KEYS */;
/*!40000 ALTER TABLE `billingreference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauthaccount`
--

DROP TABLE IF EXISTS `oauthaccount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauthaccount` (
  `OAuthAccountID` int(11) NOT NULL AUTO_INCREMENT,
  `Provider` varchar(50) NOT NULL COMMENT 'NB: If the provider is not actually an OAuth Provider (i.e., isn''t facebook, twitter, etc), as the user has opted to register their account via email & password, then the Provider is "General"',
  `ProviderUserID` varchar(200) NOT NULL COMMENT 'NB: If the provider is not actually an OAuth Provider is "General", as the user has opted to register their account via email & password, then the ProviderUserID is the users'' Email Address.',
  `Token` varchar(50) NOT NULL,
  PRIMARY KEY (`OAuthAccountID`),
  UNIQUE KEY `UQ_OAuthAccount_ProviderProviderUserID` (`Provider`,`ProviderUserID`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauthaccount`
--

LOCK TABLES `oauthaccount` WRITE;
/*!40000 ALTER TABLE `oauthaccount` DISABLE KEYS */;
INSERT INTO `oauthaccount` VALUES (1,'test','test','test'),(3,'General','test@versatile-soft.com','test123'),(5,'General','test@test.com','test'),(9,'General','test2@test.com','test2'),(10,'General','',''),(12,'General','test3@test.com','test'),(13,'General','test1@test.com','test'),(14,'General','test4@test.com','test'),(15,'General','test5@test.com','test'),(16,'General','test6@test.com',''),(17,'General','test10@test.com','test');
/*!40000 ALTER TABLE `oauthaccount` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customercommunity`
--

DROP TABLE IF EXISTS `customercommunity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customercommunity` (
  `CustomerCommunityID` int(11) NOT NULL,
  `CommunityID` int(11) NOT NULL,
  `CustomerID` int(11) NOT NULL,
  `DateJoined` datetime NOT NULL COMMENT 'The datetime when the customer joined the community',
  `EmailOptIn` bit(1) NOT NULL COMMENT 'If the customer wishes to receive emails triggered from the community then the value is "true".\nIf the customer does not wish to receive emails triggered from the community the value is "false".',
  `IsActive` bit(1) NOT NULL COMMENT 'If the customers'' membership to the community is active, then the value is "true". \nIf the customers'' membership to the community is not active, then the value is "false".',
  PRIMARY KEY (`CustomerCommunityID`),
  KEY `FK_CustomerCommunity_CommunityID` (`CommunityID`),
  KEY `FK_CustomerCommunity_CustomerID` (`CustomerID`),
  CONSTRAINT `FK_CustomerCommunity_CommunityID` FOREIGN KEY (`CommunityID`) REFERENCES `community` (`CommunityID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CustomerCommunity_CustomerID` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customercommunity`
--

LOCK TABLES `customercommunity` WRITE;
/*!40000 ALTER TABLE `customercommunity` DISABLE KEYS */;
/*!40000 ALTER TABLE `customercommunity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviewresponse`
--

DROP TABLE IF EXISTS `reviewresponse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reviewresponse` (
  `ReviewResponseID` int(11) NOT NULL AUTO_INCREMENT,
  `ReviewID` int(11) NOT NULL,
  `Response` text NOT NULL,
  `ResponseDate` datetime NOT NULL,
  `HideResponse` bit(1) NOT NULL COMMENT 'If the response is able to be viewed publicly, then the value will be "false".\nIf the response is required to be hidden, then the value will be "false".\nIf a response has been marked as hidden, then any reward or billing fee associated to that response is to be reversed.',
  PRIMARY KEY (`ReviewResponseID`),
  UNIQUE KEY `UQ_ReviewResponse_ReviewResponseID` (`ReviewResponseID`),
  KEY `FK_ReviewResponse_ReviewID` (`ReviewID`),
  CONSTRAINT `FK_ReviewResponse_ReviewID` FOREIGN KEY (`ReviewID`) REFERENCES `review` (`ReviewID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviewresponse`
--

LOCK TABLES `reviewresponse` WRITE;
/*!40000 ALTER TABLE `reviewresponse` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviewresponse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `actions`
--

DROP TABLE IF EXISTS `actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actions` (
  `ActionID` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL,
  PRIMARY KEY (`ActionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actions`
--

LOCK TABLES `actions` WRITE;
/*!40000 ALTER TABLE `actions` DISABLE KEYS */;
INSERT INTO `actions` VALUES (1,'Shortlisted'),(2,'Selection'),(3,'Message Received'),(4,'Message Response'),(5,'Quote Request'),(6,'Quote'),(7,'Transact'),(8,'View'),(9,'Rate & Review'),(10,'Review Helpful'),(11,'Question'),(12,'Answer'),(13,'TopUp Credit'),(14,'Withdrawl');
/*!40000 ALTER TABLE `actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `errorlogs`
--

DROP TABLE IF EXISTS `errorlogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `errorlogs` (
  `ErrorLogID` int(11) NOT NULL AUTO_INCREMENT,
  `Description` varchar(500) NOT NULL,
  `Details` varchar(8000) NOT NULL,
  `Timestamp` datetime NOT NULL,
  PRIMARY KEY (`ErrorLogID`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `errorlogs`
--

LOCK TABLES `errorlogs` WRITE;
/*!40000 ALTER TABLE `errorlogs` DISABLE KEYS */;
INSERT INTO `errorlogs` VALUES (1,'test','test','2014-03-28 18:07:27'),(2,'test custom exception','   at RatingReviewEngine.API.RatingReviewEngineAPI.Login(String oauthProvider, String oauthUserId, String oauthToken) in d:\\MHJ\\MichaelHillWeddingPlanner\\RatingReviewEngine.API\\RatingReviewEngineAPI.svc.cs:line 18','2014-03-31 05:17:42'),(3,'test custom exception','   at RatingReviewEngine.API.RatingReviewEngineAPI.Login(String oauthProvider, String oauthUserId, String oauthToken) in d:\\MHJ\\MichaelHillWeddingPlanner\\RatingReviewEngine.API\\RatingReviewEngineAPI.svc.cs:line 18','2014-03-31 05:19:51'),(4,'test custom exception','   at RatingReviewEngine.API.RatingReviewEngineAPI.Login(String oauthProvider, String oauthUserId, String oauthToken) in d:\\MHJ\\MichaelHillWeddingPlanner\\RatingReviewEngine.API\\RatingReviewEngineAPI.svc.cs:line 18','2014-03-31 05:22:02'),(5,'test Exception','   at RatingReviewEngine.API.RatingReviewEngineAPI.Login(String oauthProvider, String oauthUserId, String oauthToken) in d:\\MHJ\\MichaelHillWeddingPlanner\\RatingReviewEngine.API\\RatingReviewEngineAPI.svc.cs:line 20','2014-03-31 06:19:14'),(6,'test Exception','   at RatingReviewEngine.API.RatingReviewEngineAPI.Login(String oauthProvider, String oauthUserId, String oauthToken) in d:\\MHJ\\MichaelHillWeddingPlanner\\RatingReviewEngine.API\\RatingReviewEngineAPI.svc.cs:line 20','2014-03-31 06:32:20'),(7,'test Exception','   at RatingReviewEngine.API.RatingReviewEngineAPI.Login(String oauthProvider, String oauthUserId, String oauthToken) in d:\\MHJ\\MichaelHillWeddingPlanner\\RatingReviewEngine.API\\RatingReviewEngineAPI.svc.cs:line 20','2014-03-31 06:35:44'),(8,'test Exception','   at RatingReviewEngine.API.RatingReviewEngineAPI.Login(String oauthProvider, String oauthUserId, String oauthToken) in d:\\MHJ\\MichaelHillWeddingPlanner\\RatingReviewEngine.API\\RatingReviewEngineAPI.svc.cs:line 20','2014-03-31 06:36:53'),(9,'test erroew','   at RatingReviewEngine.API.RatingReviewEngineAPI.Login(String oauthProvider, String oauthUserId, String oauthToken) in d:\\MHJ\\MichaelHillWeddingPlanner\\RatingReviewEngine.API\\RatingReviewEngineAPI.svc.cs:line 20','2014-03-31 06:40:36'),(10,'test','   at RatingReviewEngine.API.RatingReviewEngineAPI.Login(String oauthProvider, String oauthUserId, String oauthToken) in d:\\MHJ\\MichaelHillWeddingPlanner\\RatingReviewEngine.API\\RatingReviewEngineAPI.svc.cs:line 20','2014-03-31 06:43:40');
/*!40000 ALTER TABLE `errorlogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliercustomernote`
--

DROP TABLE IF EXISTS `suppliercustomernote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suppliercustomernote` (
  `SupplierCustomerNoteID` int(11) NOT NULL AUTO_INCREMENT,
  `CustomerID` int(11) NOT NULL,
  `CommunityID` int(11) NOT NULL,
  `CommunityGroupID` int(11) NOT NULL,
  `SupplierID` int(11) NOT NULL,
  `SupplierNote` text COMMENT 'The notes that a Supplier has added about a customer relationship.',
  `CustomerNote` text COMMENT 'The notes that a Customer has added about a supplier relationship.',
  PRIMARY KEY (`SupplierCustomerNoteID`),
  KEY `FK_SupplierCustomerNote_CommunityGroupID` (`CommunityGroupID`),
  KEY `FK_SupplierCustomerNote_CommunityID` (`CommunityID`),
  KEY `FK_SupplierCustomerNote_SupplierID` (`SupplierID`),
  KEY `FK_SupplierCustomerNote_CustomerID` (`CustomerID`),
  CONSTRAINT `FK_SupplierCustomerNote_CommunityGroupID` FOREIGN KEY (`CommunityGroupID`) REFERENCES `communitygroup` (`CommunityGroupID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierCustomerNote_CommunityID` FOREIGN KEY (`CommunityID`) REFERENCES `community` (`CommunityID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierCustomerNote_CustomerID` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierCustomerNote_SupplierID` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliercustomernote`
--

LOCK TABLES `suppliercustomernote` WRITE;
/*!40000 ALTER TABLE `suppliercustomernote` DISABLE KEYS */;
/*!40000 ALTER TABLE `suppliercustomernote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliersocialreference`
--

DROP TABLE IF EXISTS `suppliersocialreference`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suppliersocialreference` (
  `SupplierSocialReferenceID` int(11) NOT NULL AUTO_INCREMENT,
  `SupplierID` int(11) NOT NULL,
  `SocialMediaID` int(11) NOT NULL COMMENT 'Reference to the unique identifier of the relevant social media type from the SocialMedia table',
  `SocialMediaReference` varchar(200) NOT NULL COMMENT 'Supplier''s social media reference id. I.e., if the supplier''s Social Media is ''Facebook'', then the value of this field will be the unique Facebook reference for this supplier''s Facebook account',
  PRIMARY KEY (`SupplierSocialReferenceID`),
  UNIQUE KEY `UQ_SupplierSocialReference_SupplierID` (`SupplierID`),
  UNIQUE KEY `UQ_SupplierSocialReference_SocialMediaID` (`SocialMediaID`),
  UNIQUE KEY `UQ_SupplierSocialReference_SupplierIDSocialMediaID` (`SupplierID`,`SocialMediaID`),
  KEY `FK_SupplierSocialReference_SocialMediaID` (`SocialMediaID`),
  KEY `FK_SupplierSocialReference_SupplierID` (`SupplierID`),
  CONSTRAINT `FK_SupplierSocialReference_SocialMediaID` FOREIGN KEY (`SocialMediaID`) REFERENCES `socialmedia` (`SocialMediaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierSocialReference_SupplierID` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliersocialreference`
--

LOCK TABLES `suppliersocialreference` WRITE;
/*!40000 ALTER TABLE `suppliersocialreference` DISABLE KEYS */;
/*!40000 ALTER TABLE `suppliersocialreference` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `suppliertransactions`
--

DROP TABLE IF EXISTS `suppliertransactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `suppliertransactions` (
  `SupplierActionID` int(11) NOT NULL,
  `CustomerID` int(11) NOT NULL,
  `SupplierID` int(11) NOT NULL,
  `CommunityID` int(11) NOT NULL,
  `CommunityGroupID` int(11) NOT NULL,
  `TransactionAmount` decimal(10,2) NOT NULL,
  `IsQuote` bit(1) NOT NULL DEFAULT b'0' COMMENT 'If the transaction is a quote, then the value will be "true".\nIf the transaction is not a quote (i.e., a purchase), then the value will be "false".',
  `ReceiptID` varchar(50) DEFAULT NULL COMMENT 'The receipt id of the transaction as generated by the payment gateway upon finalisation of a successful transaction.',
  `TransactionDate` datetime DEFAULT NULL COMMENT 'The datetime stamp of when the transaction was successfully finalised by the payment gateway.',
  `CurrencyID` int(11) NOT NULL COMMENT 'The currency that this transaction has been transacted in.',
  PRIMARY KEY (`SupplierActionID`),
  KEY `FK_SupplierTransactions_CommunityGroupID` (`CommunityGroupID`),
  KEY `FK_SupplierTransactions_CommunityID` (`CommunityID`),
  KEY `FK_SupplierTransactions_CustomerID` (`CustomerID`),
  KEY `FK_SupplierTransactions_CustomerSupplierID` (`SupplierActionID`),
  KEY `FK_SupplierTransactions_SupplierID` (`SupplierID`),
  CONSTRAINT `FK_SupplierTransactions_CommunityGroupID` FOREIGN KEY (`CommunityGroupID`) REFERENCES `communitygroup` (`CommunityGroupID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierTransactions_CommunityID` FOREIGN KEY (`CommunityID`) REFERENCES `community` (`CommunityID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierTransactions_CustomerID` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierTransactions_CustomerSupplierID` FOREIGN KEY (`SupplierActionID`) REFERENCES `supplieraction` (`SupplierActionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SupplierTransactions_SupplierID` FOREIGN KEY (`SupplierID`) REFERENCES `supplier` (`SupplierID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `suppliertransactions`
--

LOCK TABLES `suppliertransactions` WRITE;
/*!40000 ALTER TABLE `suppliertransactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `suppliertransactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `CustomerID` int(11) NOT NULL AUTO_INCREMENT,
  `Email` varchar(100) NOT NULL,
  `MobilePhone` varchar(50) NOT NULL,
  `FirstName` varchar(50) NOT NULL COMMENT 'Displayed only to a specifically recommended or selected supplier within communications',
  `LastName` varchar(50) NOT NULL COMMENT 'Displayed only to a specifically recommended or selected supplier within communications',
  `Handle` varchar(50) NOT NULL COMMENT 'Public handle viewable by a Customer or Supplier. E.g., ''<Handle> is a 3-Star Reviewer''',
  `Gender` char(10) DEFAULT NULL COMMENT '"M" for male\n"F" for female',
  `DateJoined` datetime NOT NULL COMMENT 'The datetime stamp of when the customer signed up to the system',
  PRIMARY KEY (`CustomerID`),
  UNIQUE KEY `UQ_Customer_Email` (`Email`),
  UNIQUE KEY `UQ_Customer_MobilePhone` (`MobilePhone`),
  UNIQUE KEY `UQ_Customer_Handle` (`Handle`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `communityownertransactionhistory`
--

DROP TABLE IF EXISTS `communityownertransactionhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `communityownertransactionhistory` (
  `CommunityOwnerTransactionHistoryID` int(11) NOT NULL AUTO_INCREMENT,
  `OwnerID` int(11) NOT NULL,
  `CommunityID` int(11) NOT NULL,
  `CommunityGroupID` int(11) DEFAULT NULL COMMENT 'If the transaction is performed within the context of a community group, then this field is to be completed. If the transaction is account-based, such as a transfer, then this field is to remain null.',
  `Description` varchar(50) NOT NULL,
  `Amount` decimal(10,2) NOT NULL,
  `DateApplied` datetime NOT NULL,
  `Balance` decimal(10,2) NOT NULL,
  PRIMARY KEY (`CommunityOwnerTransactionHistoryID`),
  KEY `FK_CommunityID1` (`CommunityID`),
  KEY `FK_CommunityGroupID1` (`CommunityGroupID`),
  CONSTRAINT `FK_CommunityOwnerTransactionHistory_CommunityGroupID` FOREIGN KEY (`CommunityGroupID`) REFERENCES `communitygroup` (`CommunityGroupID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CommunityOwnerTransactionHistory_CommunityID` FOREIGN KEY (`CommunityID`) REFERENCES `community` (`CommunityID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `communityownertransactionhistory`
--

LOCK TABLES `communityownertransactionhistory` WRITE;
/*!40000 ALTER TABLE `communityownertransactionhistory` DISABLE KEYS */;
INSERT INTO `communityownertransactionhistory` VALUES (1,2,1,2,'test',10.00,'2014-03-26 14:45:21',10.00),(2,2,1,2,'test',10.00,'2014-03-26 14:45:40',10.00);
/*!40000 ALTER TABLE `communityownertransactionhistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country` (
  `CountryID` int(11) NOT NULL AUTO_INCREMENT,
  `CountryName` varchar(100) NOT NULL,
  PRIMARY KEY (`CountryID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES (1,'India');
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customerpointstally`
--

DROP TABLE IF EXISTS `customerpointstally`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customerpointstally` (
  `CustomerID` int(11) NOT NULL,
  `CommunityID` int(11) NOT NULL,
  `PointsTally` int(11) NOT NULL COMMENT 'The current number of points that a customer has accrued.',
  PRIMARY KEY (`CustomerID`),
  KEY `FK_CustomerPointsTally_CommunityID` (`CommunityID`),
  KEY `FK_CustomerPointsTally_CustomerID` (`CustomerID`),
  CONSTRAINT `FK_CustomerPointsTally_CommunityID` FOREIGN KEY (`CommunityID`) REFERENCES `community` (`CommunityID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CustomerPointsTally_CustomerID` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customerpointstally`
--

LOCK TABLES `customerpointstally` WRITE;
/*!40000 ALTER TABLE `customerpointstally` DISABLE KEYS */;
/*!40000 ALTER TABLE `customerpointstally` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usersecurity`
--

DROP TABLE IF EXISTS `usersecurity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usersecurity` (
  `OAuthAccountID` int(11) NOT NULL,
  `Administrator` char(1) NOT NULL COMMENT '0 = no - the account does not have Administrator security\n1 = yes - the account does have Administrator security',
  `CommunityOwner` char(1) NOT NULL COMMENT '0 = no - the account does not have Community Owner security\n1 = yes - the account does have Community Owner security',
  `Supplier` char(1) NOT NULL COMMENT '0 = no - the account does not have Supplier security\n1 = yes - the account does have Supplier security',
  `Customer` char(1) NOT NULL COMMENT '0 = no - the account does not have Customer security\n1 = yes - the account does have Customer security',
  PRIMARY KEY (`OAuthAccountID`),
  KEY `FK_UserSecurity_OAuthAccountID` (`OAuthAccountID`),
  CONSTRAINT `FK_UserSecurity_OAuthAccountID` FOREIGN KEY (`OAuthAccountID`) REFERENCES `oauthaccount` (`OAuthAccountID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usersecurity`
--

LOCK TABLES `usersecurity` WRITE;
/*!40000 ALTER TABLE `usersecurity` DISABLE KEYS */;
/*!40000 ALTER TABLE `usersecurity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviewhelpful`
--

DROP TABLE IF EXISTS `reviewhelpful`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reviewhelpful` (
  `ReviewID` int(11) NOT NULL,
  `CustomerID` int(11) NOT NULL,
  `ReviewHelpfulDate` datetime DEFAULT NULL COMMENT 'The datetime stamp of when the customer selected the ''i found this review helpful'' option',
  PRIMARY KEY (`ReviewID`),
  KEY `FK_ReviewHelpful_CustomerID` (`CustomerID`),
  KEY `FK_ReviewHelpful_ReviewID` (`ReviewID`),
  CONSTRAINT `FK_ReviewHelpful_CustomerID` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ReviewHelpful_ReviewID` FOREIGN KEY (`ReviewID`) REFERENCES `review` (`ReviewID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviewhelpful`
--

LOCK TABLES `reviewhelpful` WRITE;
/*!40000 ALTER TABLE `reviewhelpful` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviewhelpful` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `triggeredevent`
--

DROP TABLE IF EXISTS `triggeredevent`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `triggeredevent` (
  `TriggeredEventID` int(11) NOT NULL AUTO_INCREMENT,
  `ActionID` int(11) NOT NULL COMMENT 'Reference to the unique action that this triggered event is intercepting',
  `RecVer` int(11) NOT NULL,
  `BillingPercentageAdministrator` decimal(10,2) DEFAULT NULL COMMENT 'The percentage of the resulting fee that will be given to the administrator upon billing the supplier the amount defined in the CommunityGroupBillingFee table.E.g., if the BillingPercentageAdministrator is defined as 0.01, then 1% of the total amount billed to the supplier for this particular Action will be credited to the Administrator.',
  `BillingPercentageOwner` decimal(10,2) DEFAULT NULL COMMENT 'The percentage of the resulting fee that will be given to the community owner upon billing the supplier the amount defined in the CommunityGroupBillingFee table.\nE.g., if the BillingPercentageOwner is defined as 0.01, then 1% of the total amount billed to the supplier for this particular Action will be credited to the Community Owner.',
  `IsActive` bit(1) NOT NULL COMMENT 'If the action is currently active, then the value is to be "true"\nIf the action is currently inactive, then the value is to be "false"',
  PRIMARY KEY (`TriggeredEventID`),
  KEY `FK_TriggeredEvent_ActionID` (`ActionID`),
  CONSTRAINT `FK_TriggeredEvent_ActionID` FOREIGN KEY (`ActionID`) REFERENCES `actions` (`ActionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `triggeredevent`
--

LOCK TABLES `triggeredevent` WRITE;
/*!40000 ALTER TABLE `triggeredevent` DISABLE KEYS */;
INSERT INTO `triggeredevent` VALUES (1,1,2,5.50,6.70,'\0');
/*!40000 ALTER TABLE `triggeredevent` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customeravatar`
--

DROP TABLE IF EXISTS `customeravatar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `customeravatar` (
  `CustomerID` int(11) NOT NULL,
  `Avatar` binary(10) NOT NULL,
  PRIMARY KEY (`CustomerID`),
  KEY `FK_CustomerAvatar_CustomerID` (`CustomerID`),
  CONSTRAINT `FK_CustomerAvatar_CustomerID` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customeravatar`
--

LOCK TABLES `customeravatar` WRITE;
/*!40000 ALTER TABLE `customeravatar` DISABLE KEYS */;
/*!40000 ALTER TABLE `customeravatar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ownerbankingdetails`
--

DROP TABLE IF EXISTS `ownerbankingdetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ownerbankingdetails` (
  `OwnerID` int(11) NOT NULL,
  `Bank` varchar(50) NOT NULL,
  `AccountName` varchar(50) NOT NULL,
  `BSB` varchar(10) NOT NULL,
  `AccountNumber` varchar(20) NOT NULL,
  PRIMARY KEY (`OwnerID`),
  KEY `FK_OwnerBankingDetails_OwnerID` (`OwnerID`),
  CONSTRAINT `FK_OwnerBankingDetails_OwnerID` FOREIGN KEY (`OwnerID`) REFERENCES `owner` (`OwnerID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ownerbankingdetails`
--

LOCK TABLES `ownerbankingdetails` WRITE;
/*!40000 ALTER TABLE `ownerbankingdetails` DISABLE KEYS */;
/*!40000 ALTER TABLE `ownerbankingdetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `applicationconnections`
--

DROP TABLE IF EXISTS `applicationconnections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `applicationconnections` (
  `ApplicationConnectionID` int(11) NOT NULL,
  `ApplicationID` int(11) NOT NULL,
  `datetime` datetime NOT NULL,
  PRIMARY KEY (`ApplicationConnectionID`),
  KEY `FK_ApplicationID` (`ApplicationID`),
  CONSTRAINT `FK_ApplicationConnections_ApplicationID` FOREIGN KEY (`ApplicationID`) REFERENCES `applicationauthentication` (`ApplicationID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applicationconnections`
--

LOCK TABLES `applicationconnections` WRITE;
/*!40000 ALTER TABLE `applicationconnections` DISABLE KEYS */;
/*!40000 ALTER TABLE `applicationconnections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'ratingreviewengine'
--
/*!50003 DROP PROCEDURE IF EXISTS `ACTIONINSERT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `ACTIONINSERT`(
IN IN_CommunityID INT,
IN IN_CommunityGroupID INT,
IN IN_ActionID INT,
IN IN_CommunityOwnerID INT,
IN IN_SupplierID INT,
IN IN_CustomerID INT,
IN IN_ActionDetails VARCHAR(200),
IN IN_ActionAmt DECIMAL(10,2)
)
BEGIN
-- -------Comment-------------------------------------------
-- 1. If the given action is active (TriggeredEvent.IsActive) then the procedure continues, else it ends here
-- 2. A record of the action is to be logged against the given supplier (SupplierAction)
-- 3. If a value was supplied for the @ActionAmt input parameter, then an additional record of financial activity is to be logged (SupplierTransactions) - 
--      (NB: The 'IsQuote' flag can be derived from the Action table - if Action.Name like '%quote%', then this flag is true)
-- 3. If the given Supplier is not currently within a Bill Free Override (SupplierCommunityBillFreeOverride.IsActive = true) then the procedure continues - 
--      (NB: Even if the fee is 0, this process will still continue). If the IsActive flag is False, then the procedure is to end.
-- 4. The Community Owner is to have their virtual community account (CommunityOwnerTransactionHistory) credited by the calculated @CommunityOwnerIncome 
--      (CommunityGroupBillingFee.Fee * TriggeredEvent.BillingPercentageOwner)
-- 5. The Supplier's virtual community account (SupplierTransactionHistory) is to be debited the full Fee amount (CommunityGroupBillingFee.Fee) in the fee's 
--      currency (CommunityGroupBillingFee.FeeCurrencyID)
-- 6. Add a billing reference to ensure that the supplier transaction record is linked to the community owner transaction record (BillingReference)
-- 7. If there is a customer reward associated with the triggered event for the given community (CommunityReward.Points), then add the points to the given
--      customer's points tally (CustomerPointsTally), and also record a record of the reward for the given customer (CustomerRewards)
-- ---------------------------------------------------------

    DECLARE exit handler for sqlexception
      BEGIN
        -- ERROR
      ROLLBACK;
    END;

    DECLARE exit handler for sqlwarning
     BEGIN
        -- WARNING
     ROLLBACK;
    END;
    
    START TRANSACTION;
    
    IF(EXISTS(SELECT TriggeredEventID FROM TirggeredEvent WHERE ActionID=IN_ActionID AND IsActive=true)) THEN
    BEGIN
            INSERT INTO SupplierAction(CustomerID,SupplierID,CommunityID,CommunityGroupID,ActionID,ActionDate,Detail,ResponseActionPerformed)
                VALUES(IN_CustomerID,IN_SupplierID,IN_CommunityID,IN_CommunityGroupID,IN_ActionID,NOW(),IN_ActionDetails,true);
            
            IF(IN_ActionAmt IS Not Null OR INActionAmt>0) THEN
                INSERT INTO SupplierTransactions(SupplierActionID,CustomerID,SupplierID,CommunityID,CommunityGroupID,TransactionAmount)
                    VALUES(LAST_INSERT_ID(),IN_CustomerID,IN_SupplierID,IN_CommunityID,IN_CommunityGroupID,IN_ActionAmt);
           
         --  ELSEIF(EXISTS(SELECT IsActive FROM SupplierCommunityBillFreeOverride WHERE CommunityID=IN_CommunityID AND CommunityGroupID=IN_CommunityGroupID
         --                   AND SupplierID=IN_SupplierID AND IsActive=true)) THEN
                    
              
                  
            END IF;
    END;
    END IF;
    
     COMMIT;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `APITOKENACTIVATE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `APITOKENACTIVATE`(

IN IN_ApplicationName VARCHAR(50),
IN IN_TokenGenerated DATETIME,
IN IN_APIToken VARCHAR(50),
IN IN_IsActive BIT,
IN IN_RegisteredEmail VARCHAR(200),
IN IN_CommunityID INT
)
BEGIN
-- Comment ------------------------------------------------------------------
-- 1. Save the given Application details (ApplicationAuthentication)
-- 2. Generate a new API Token and update the application record to save the token (ApplicationAuthentication.APIToken & ApplicationAuthentication.TokenGenerated)
-- 3. Activate the API Token (ApplicationAuthentication.IsActive = true)
-- ----------------------------------------------------------------------------
        INSERT INTO ApplicationAuthentication (ApplicationName,TokenGenerated,APIToken,IsActive,RegisteredEmail,CommunityID)
        VALUES(IN_ApplicationName,IN_TokenGenerated,IN_APIToken,IN_IsActive,IN_RegisteredEmail,IN_CommunityID);
        
         SELECT LAST_INSERT_ID();
        
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `APITOKENDEACTIVATE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `APITOKENDEACTIVATE`(
IN IN_ApplicationID INT
)
BEGIN
-- ---------Comment------------------
-- 1. Update the application record and deactivate the API Token associated to the registered application (ApplicationAuthentication.IsActive = false)
-- ----------------------------------

        UPDATE ApplicationAuthentication SET IsActive = false WHERE ApplicationID = IN_ApplicationID;
        
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `APITOKENRESET` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `APITOKENRESET`(
IN IN_ApplicationID INT,
IN IN_APIToken VARCHAR(50),
IN IN_TokenGenerated DATETIME
)
BEGIN
-- ------------------Comment-----------------------------
-- 1. Generate a new API Token and update the application record to save the token (ApplicationAuthentication.APIToken & ApplicationAuthentication.TokenGenerated)
-- 2. Activate the API Token (ApplicationAuthentication.IsActive = true)
-- ------------------------------------------------------

        UPDATE ApplicationAuthentication SET APIToken=IN_APIToken,IsActive=true,TokenGenerated=IN_TokenGenerated WHERE ApplicationID=IN_ApplicationID;
        
        SELECT ApplicatonID,AppliationName,TokenGenerated,APIToken,LastConnection,IsActive,RegisteredEmail,CommunityID 
            FROM ApplicationAuthentication WHERE ApplicationID=IN_ApplicationID;
        
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `APPLICATIONINSERT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `APPLICATIONINSERT`(
IN IN_ApplicationName VARCHAR(50),
IN IN_RegisteredEmail VARCHAR(200),
IN IN_CommunityID INT
)
BEGIN
-- --------------Comment---------------------------------------------
-- 1. Save the given Application details (ApplicationAuthentication)
-- ------------------------------------------------------------------
        INSERT INTO ApplicationAuthentication (ApplicationName,RegisteredEmail,CommunityID,IsActive)
        Values(IN_ApplicationName,IN_RegisteredEmail,IN_CommunityID,true);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `BANKACCOUNTUPDATE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `BANKACCOUNTUPDATE`(
IN IN_ID INT,
IN IN_Entity VARCHAR(50),
IN IN_Bank VARCHAR(50),
IN IN_AccountName VARCHAR(50),
IN IN_BSB VARCHAR(10),
IN IN_AccountNumber VARCHAR(20)
)
BEGIN
        
-- -------------Comment------------------------------
-- 1. If the supplied entity is "Supplier", then create a new record in the SupplierBankingDetails table
-- 2. If the supplied entity is "Community Owner", then create a new record in the OwnerBankingDetails table
-- --------------------------------------------------

    IF(IN_Entity='Supplier"') THEN
        INSERT INTO SupplierBankingDetails (SupplierID,Bank,AccountName,BSB,AccountNumber)
          VALUES (IN_ID,IN_Bank,IN_AccountName,IN_BSB,IN_AccountNumber);
          
    ELSEIF(IN_Entity='Community Owner') THEN
        INSERT INTO OwnerBankingDetails (OwnerID,Bank,AccountName,BSB,AccountNumber)
          VALUES (IN_ID,IN_Bank,IN_AccountName,IN_BSB,IN_AccountNumber);
          
    END IF;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `BILLFREEOVERRIDEUPDATE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `BILLFREEOVERRIDEUPDATE`(
IN IN_SupplierCommunityBillFreeOverrideID INT,
IN IN_IsActive BIT,
IN IN_BillFreeEnd DATETIME
)
BEGIN
-- ---------------Comment-------------------------
-- 1. Update the relevant bill free override record with the supplied details (SupplierCommunityBillFreeOverride) 
-- - (NB - if the supplied BillFreeEnd date is null/emtpy, then do not update this date - only update this field if a date is supplied.)
-- -----------------------------------------------

    UPDATE SupplierCommunityBillFreeOverride SET IsActive=IN_IsActive Where SupplierCommunityBillFreeOverrideID=IN_SupplierCommunityBillFreeOverrideID;
    
    IF (IN_BillFreeEnd IS NOT NULL OR IN_BillFreeEnd!='') THEN
    UPDATE SupplierCommunityBillFreeOverride SET BillFreeEnd=IN_BillFreeEnd Where SupplierCommunityBillFreeOverrideID=IN_SupplierCommunityBillFreeOverrideID;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CheckValidUserID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `CheckValidUserID`(
IN IN_OAuthProvider VARCHAR(50),
IN IN_OAuthUserID VARCHAR(200)
)
BEGIN
-- ----------Comment---------------------------------------
-- Check Provider and UserID already Exist IF Exist return Valid ELSE Invalid
-- --------------------------------------------------------

    IF(EXISTS(SELECT OAuthAccountID FROM OAuthAccount WHERE Provider=IN_OAuthProvider AND ProviderUserID=IN_OAuthUSerID)) THEN
        SELECT 'invalid';
    ELSE
        SELECT 'valid';
    END IF;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `COMMUNITYGROUPBILLINGFEEUPDATE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `COMMUNITYGROUPBILLINGFEEUPDATE`(
IN IN_CommunityGroupBillingFeeID INT,
IN IN_Fee DECIMAL(10,2),
IN IN_FeeCurrencyID INT,
IN IN_IsFeePercentage BIT,
IN IN_BillFreeDays INT
)
BEGIN
-- ----Comment-----------------------------------------------------
-- 1. Update the given community group billing fee record with the supplied details (CommunityGroupBillingFee)
-- ----------------------------------------------------------------
    
    UPDATE CommunityGroupBillingFee SET Fee=IN_Fee,FeeCurrencyID=IN_FeeCurrencyID,IsFeePercentage=IN_IsFeePercentage,BillFreeDays=IN_BillFreeDays
    WHERE CommunityGroupBillingFeeID=IN_CommunityGroupBillingFeeID;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `COMMUNITYGROUPINSERT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `COMMUNITYGROUPINSERT`(
IN IN_CommunityID INT,
IN IN_Name VARCHAr(50),
IN IN_Description VARCHAR(200),
IN IN_CreditMin DECIMAL(10,2),
IN IN_CurrencyID INT,
IN IN_Active BIT
)
BEGIN
-- -------Comment------------------------
-- 1. Insert a new community group for the given community with the supplied details (CommunityGroup)
-- --------------------------------------
        
        INSERT INTO CommunityGroup (CommunityID,Name,Description,CreditMin,CurrencyID,Active)
          Values (IN_CommunityID,IN_Name,IN_Description,IN_CreditMin,IN_CurrencyID,IN_Active);
          
        SELECT LAST_INSERT_ID();

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `COMMUNITYGROUPJOIN` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `COMMUNITYGROUPJOIN`(
IN IN_SupplierID INT,
IN IN_CommunityID INT,
IN IN_CommunityGroupID INT
)
BEGIN
-- ------------Comment---------------------------------------
-- 1. Link the given Supplier with the given Community Group (CommunityGroupSupplier) and set the DateJoined to 'now' and the IsActive flag to true
-- ----------------------------------------------------------

        INSERT INTO CommunityGroupSupplier (SupplierID,CommunityID,CommunityGroupID,DateJoined,IsActive)
           VALUES (IN_SupplierID,IN_CommunityID,IN_CommunityGroupID,NOW(),true);
           
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `COMMUNITYGROUPLEAVE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `COMMUNITYGROUPLEAVE`(
IN IN_SupplierID INT,
IN IN_CommunityID INT,
IN IN_CommunityGroupID INT
)
BEGIN
-- -------------Comment----------------------------------------
-- 1. Find the relevant CommunityGroupSupplier.CommunityGroupSupplierID from the supplied SupplierID, CommunityID and CommunityGroupID
-- 2. Deactivate (CommunityGroupSupplier.IsActive = false) the relationship between the supplied Supplier - Community - Community Group (CommunityGroupSupplier)
-- ------------------------------------------------------------

        UPDATE CommunityGroupSupplier SET IsActive=false 
        WHERE SupplierID=IN_SupplierID AND CommunityID=IN_CommunityID AND CommunityGroupID=IN_CommunityGroupID;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `COMMUNITYGROUPSEARCH` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `COMMUNITYGROUPSEARCH`(
IN IN_SearchTerm VARCHAR(50),
IN IN_CommunityID VARCHAR(50)
)
BEGIN
-- -----------Comment--------------------------
-- 1. If the SearchTerm is not null, based on a wildcard search (prepending '%' and appending '%' and replacing any blanks with '%'), 
--    use the supplied search term to search across CommunityGroup.Name and CommunityGroup.Description
-- 2. If a CommunityID is not null, then retrieve all community groups associated to the given community (communitygroup.CommunityID)
-- 3. Return the results
-- --------------------------------------------

    SELECT SQL_NO_CACHE CommunityGroupID,CommunityID,Name,Description,CreditMin,CurrencyID,Active FROM CommunityGroup
     WHERE (Name LIKE Concat('%',IN_SearchTerm,'%') OR Description LIKE CONCAT('%',IN_SearchTerm,'%') ) 
            AND (CommunityID=IN_CommunityID OR IN_CommunityID='');

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `COMMUNITYGROUPSELECT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `COMMUNITYGROUPSELECT`(
IN IN_CommunityGroupID INT
)
BEGIN
-- -------Comment----------------------------------------------
-- 1. Retrieve the community group record associated to the given CommunityGroupID (CommunityGroup.CommunityGroupID)
-- 2. Return the results
-- ------------------------------------------------------------

        SELECT SQL_NO_CACHE CommunityGroupID,CommunityID,Name,Description,CreditMin,CurrencyID,Active FROM CommunityGroup
            WHERE CommunityGroupID = IN_CommunityGroupID LIMIT 1;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `COMMUNITYGROUPUPDATE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `COMMUNITYGROUPUPDATE`(
IN IN_CommunityGroupID INT,
IN IN_Name VARCHAR(50),
IN IN_Description VARCHAr(200),
IN IN_CreditMin DECIMAL(10,2),
IN IN_CurrencyID INT,
IN IN_Active BIT
)
BEGIN
-- ---------Comment------------------------------------------
-- 1. Update the existing community group record with the supplied details (CommunityGroup)
-- ----------------------------------------------------------

        UPDATE CommunityGroup SET Name=IN_Name,Description=IN_Description,CreditMin=IN_CreditMin,CurrencyID=IN_CurrencyID,Active=IN_Active
           WHERE CommunityGroupID=IN_CommunityGroupID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `COMMUNITYINSERT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `COMMUNITYINSERT`(
IN IN_Name VARCHAR(50),
IN IN_Description VARCHAR(200),
IN IN_CurrencyID INT,
IN IN_CountryID INT,
IN IN_OwnerID INT,
IN IN_CentreLongitude DECIMAL(10,4),
IN IN_CentreLatitude DECIMAL(10,4),
IN IN_AreaRadius DECIMAL(10,3),
IN IN_AutoTransferAmtOwner DECIMAL(10,2),
IN IN_Active BIT
)
BEGIN
-- ---------------Comment---------------------------------
-- 1. Insert a new community record with the supplied details (Community)
-- -------------------------------------------------------

        INSERT INTO Community (Name,Description,CurrencyID,CountryID,OwnerID,CentreLongitude,CentreLatitude,AreaRadius,AutoTransferAmtOwner,Active)
            VALUES (IN_Name,IN_Description,IN_CurrencyID,IN_CountryID,IN_OwnerID,IN_CentreLongitude,IN_CentreLatitude,IN_AreaRadius,IN_AutoTransferAmtOwner,IN_Active);
            
        SELECT LAST_INSERT_ID();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `COMMUNITYJOIN` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `COMMUNITYJOIN`(
IN IN_SupplierID INT,
IN IN_CommunityID INT,
IN IN_AutoTransferAmtSupplier DECIMAL(10,2),
IN IN_AutoTopUp BIT,
IN IN_MinCredit DECIMAL(10,2)
)
BEGIN
-- -------Comment--------------------------------------------
-- 1. Link the given Supplier with the given Community (CommunitySupplier) and set the DateJoined to 'now' and the IsActive flag to true
-- ----------------------------------------------------------

        INSERT INTO CommunitySupplier(SupplierID,CommunityID,DateJoined,IsActive,AutoTransferAmtSupplier,AutoTopUp,MinCredit)
           VALUES(IN_SupplierID,IN_CommunityID,NOW(),true,IN_AutoTransferAmtSupplier,IN_AutoTopup,IN_MinCredit);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `COMMUNITYLEAVE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `COMMUNITYLEAVE`(
IN IN_ID INT,
IN IN_Entity VARCHAR(50),
IN IN_CommunityID INT
)
BEGIN
-- ------------Comment------------------------------------
-- 1. Find the relevant CommunitySupplier.CommunitySupplierID from the supplied SupplierID and CommunityID
-- 2. Deactivate (CommunitySupplier.IsActive = false) the relationship between the supplied Supplier - Community (CommunitySupplier)
-- -------------------------------------------------------

    IF(IN_Entity='Supplier"') THEN
    
        UPDATE CommunitySupplier SET IsActive=false WHERE SupplierID=IN_ID AND CommunityID=IN_CommunityID;
        
    ELSEIF(IN_Entity='Customer"') THEN
        
        UPDATE CustomerCommunity SET IsActive=false WHERE CustomerID=IN_ID AND CommunityID=IN_CommunityID;
        
    END IF;
    

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `COMMUNITYSEARCH` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `COMMUNITYSEARCH`(
IN IN_SearchTerm VARCHAR(50),
IN IN_SearchDistance DECIMAL(10,2),
IN IN_ReferenceLongitude DECIMAL(10,2),
IN IN_ReferenceLatitude DECIMAL(10,2)
)
BEGIN
-- ------------------Comment----------------------------------------
-- 1. If the SearchTerm is not null, based on a wildcard search (prepending '%' and appending '%' and replacing any blanks with '%'), 
--     use the supplied search term to search across Community.Name and Community.Description)
-- 2. If SearchDistance is not null, using the ReferenceLongitude, ReferenceLatitude & SearchDistance, retrieve communities that have a 
--      Community.CentreLongitude and Community.CentreLatitude point no further away than the supplied SearchDistance.
-- 3. Return the results
-- http://zcentric.com/2010/03/11/calculate-distance-in-mysql-with-latitude-and-longitude/
-- -----------------------------------------------------------------

        SELECT CommunityID,Name,Description,CurrencyID,CountryID,OwnerID,CentreLongitude,CentreLatitude,AreaRadius,AutoTransferAmtOwner,Active
         FROM Community WHERE (Name LIKE CONCAT('%',IN_SearchTerm,'%') OR Description LIKE CONCAT('%',IN_SearchTerm,'%')) 
            AND(IN_SearchDistance=0 OR (
            ((ACOS(SIN(IN_ReferenceLatitude * PI() / 180) * SIN(CentreLatitude * PI() / 180) + COS(IN_ReferenceLatitude * PI() / 180) 
            * COS(CentreLatitude * PI() / 180) * COS((IN_ReferenceLongitude - CentreLongitude) * PI() / 180)) * 180 / PI()) * 60 * 1.1515)
            <=IN_SearchDistance
            )
            );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `COMMUNITYSELECT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `COMMUNITYSELECT`(
IN IN_CommunityID INT
)
BEGIN
-- ----------Comment------------------------------------
-- 1. Retrieve the community record associated to the given CommunityID (Community.CommunityID)
-- 2. Return the results
-- -----------------------------------------------------

    SELECT SQL_NO_CACHE CommunityID,Name,Description,CurrencyID,CountryID,OwnerID, CentreLongitude,CentreLatitude,AreaRadius,AutoTransferAmtOwner,Active
      FROM Community WHERE CommunityID=IN_CommunityID LIMIT 1;
      
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `COMMUNITYUPDATE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `COMMUNITYUPDATE`(
IN IN_CommunityID INT,
IN IN_Name VARCHAR(50),
IN IN_Description VARCHAR(200),
IN IN_CurrencyID INT,
IN IN_CountryID INT,
IN IN_CentreLongitude DECIMAL(10,4),
IN IN_CentreLatitude DECIMAL(10,4),
IN IN_AreaRadius DECIMAL(10,3),
IN IN_AutoTransferAmtOwner DECIMAL(10,2),
IN IN_Active BIT
)
BEGIN
-- -----------Comment------------------------------------------
-- 1. Update the existing community record with the supplied details (Community)
-- ------------------------------------------------------------

    UPDATE Community SET Name=IN_Name, Description=IN_Description, CurrencyID=IN_CurrencyID, CountryID=IN_CountryID
        ,CentreLongitude=IN_CentreLongitude, CentreLatitude=IN_CentreLatitude, AreaRadius=IN_AreaRadius
        ,AutoTransferAmtOwner=IN_AutoTransferAmtOwner, Active=IN_Active
    WHERE CommunityID=IN_CommunityID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `COUNTRYSELECTS` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `COUNTRYSELECTS`()
BEGIN
-- -----------------Comment------------------------------
-- Get all Country list from Country table
-- ------------------------------------------------------

    SELECT SQL_NO_CACHE CountryID,CountryName FROM Country;
        
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CREDITVIRTUALCOMMUNITYACCOUNT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `CREDITVIRTUALCOMMUNITYACCOUNT`(
IN IN_ID INT,
IN IN_Entity VARCHAR(50),
IN IN_CommunityID INT,
IN IN_CommunityGroupID INT,
IN IN_Description VARCHAR(200),
IN IN_Amount DECIMAL(10,2),
IN IN_DateApplied DATETIME,
IN IN_CustomerID INT
)
BEGIN
-- -------Comment--------------------------------------------------------
-- 1. If the supplied entity is "Supplier"
--      a) retrieve the current balance for the supplier's community virtual account (SupplierCommunityTransactionHistory.Balance) based on the most recent transaction 
--          ( Max(SupplierCommunityTransactionHistory.DateApplied) ) for the given Supplier-Community relationship
--      b) calculate the new balance for the supplier's community virtual account from the current balance and the deposit amount 
--          (SupplierCommunityTransactionHistory.Balance + Amount)
--      c) add a new transaction record to the supplier's community virtual account based on the calculated balance and the supplied details 
--          (SupplierCommunityTransactionHistory)
-- 2. If the supplied entity is "Community Owner"
--      a) retrieve the current balance for the community owner's community virtual account (CommunityOwnerTransactionHistory.Balance) 
--          based on the most recent transaction ( Max(CommunityOwnerTransactionHistory.DateApplied) ) for the given Community Owner-Community relationship
--      b) calculate the new balance for the community owner's community virtual account from the current balance and the deposit amount 
--          (CommunityOwnerTransactionHistory.Balance + Amount)
--      c) add a new transaction record to the community owner's community virtual account based on the calculated balance and the supplied details 
--          (CommunityOwnerTransactionHistory)
-- ----------------------------------------------------------------------

    DECLARE Balance DECIMAL(10,2);
    SET Balance=0;
    
    IF(IN_Entity='Supplier') THEN
     BEGIN
       SET Balance=COALESCE( (SELECT COALESCE(Balance,0) FROM SupplierCommunityTransactionHistory WHERE SupplierID=IN_ID AND CommunityID=IN_CommunityID 
                      AND DateApplied= (SELECT MAX(DateApplied) FROM SupplierCommunityTransactionHistory WHERE SupplierID=IN_ID AND CommunityID=IN_CommunityID
                                        GROUP BY DateApplied)
                    ),0);
                   
        INSERT INTO SupplierCommunityTransactionHistory(SupplierID,CommunityID,CommunityGroupID,Description,Amount,DateApplied,Balance,CustomerID)
         VALUES(IN_ID,IN_CommunityId,IN_CommunityGroupID,IN_Description,IN_Amount,IN_DateApplied,(Balance+IN_Amount),IN_CustomerID);
         
         SELECT SupplierCommunityTransactionHistoryID,SupplierID,CommunityID,CommunityGroupID,Description,Amount,DateApplied,Balance,CustomerID 
            FROM SupplierCommunityTransactionHistory WHERE SupplierCommunityTransactionHistoryID=LAST_INSERT_ID();
         
     END;
     
     ELSEIF(IN_Entity='Community Owner') THEN
     BEGIN
     
      SET Balance=COALESCE( (SELECT COALESCE(Balance,0) FROM CommunityOwnerTransactionHistory WHERE OwnerID=IN_ID AND CommunityID=IN_CommunityID 
                      AND DateApplied=(SELECT MAX(DateApplied) FROM CommunityOwnerTransactionHistory WHERE OwnerID=IN_ID AND CommunityID=IN_CommunityID
                                        GROUP BY DateApplied)
                    ),0);
                    
        INSERT INTO CommunityOwnerTransactionHistory(OwnerID,CommunityID,CommunityGroupID,Description,Amount,DateApplied,Balance)
         VALUES(IN_ID,IN_CommunityId,IN_CommunityGroupID,IN_Description,IN_Amount,IN_DateApplied,(Balance+IN_Amount));
         
         SELECT CommunityOwnerTransactionHistoryID,OwnerID,CommunityID,CommunityGroupID,Description,Amount,DateApplied,Balance
            FROM CommunityOwnerTransactionHistory WHERE CommunityOwnerTransactionHistoryID=LAST_INSERT_ID();
         
     END;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CURRENCYINSERT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `CURRENCYINSERT`(
IN IN_ISOCode VARCHAR(3),
IN IN_Description VARCHAR(50),
IN IN_MinTransferAmount DECIMAL(10,2),
IN IN_IsActive BIT
)
BEGIN
-- ----------------Comment-----------------------------------
-- 1. Create a new currency within the system from the supplied details (Currency)
-- ----------------------------------------------------------

    INSERT INTO Currency (ISOCode,Description,MinTransferAmount,ISActive)
        VALUEs(IN_ISOCode,IN_Description,IN_MinTransferAmount,IN_IsActive);
    
    SELECT LAST_INSERT_ID();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CURRENCYUPDATE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `CURRENCYUPDATE`(
IN IN_CurrencyID INT,
IN IN_ISOCode VARCHAR(3),
IN IN_Description VARCHAR(50),
IN IN_MINTransferAmount DECIMAL(10,2),
IN IN_IsActive BIT
)
BEGIN
-- ---------------Comment---------------------------------------
-- 1. Update an existing currency record from the supplied CurrencyID (Currency.CurrencyID) with the supplied details (Currency)
-- -------------------------------------------------------------

    UPDATE Currency SET ISOCode=IN_ISOCode, Description=IN_Description, MinTransferAmount=IN_MinTransferAmount, IsActive=IN_IsActive
     WHERE CurrencyID=IN_CurrencyID;
     
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CUSTOMERAVATARINSERT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `CUSTOMERAVATARINSERT`(
IN IN_CustomerID INT,
IN IN_Avatar BINARY(10)
)
BEGIN
-- ------------Comment---------------------------------------
-- Insert a new CustomerAvatar record with the supplied details (CustomerAvatar)
-- If already exist then update Avatar
-- ----------------------------------------------------------

    IF(EXISTS(SELECT CustomerID FROM CustomerAvatar WHERE CustomerID=IN_CustomerID)) THEN
        UPDATE CustomerAvatar SET Avatar=IN_Avatar WHERE CustomerID=IN_CustomerID;
    ELSE
        INSERT INTO CustomerAvatar(CustomerID,Avatar) VALUES(IN_CustomerID,IN_Avatar);
    END IF;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CUSTOMERINSERT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `CUSTOMERINSERT`(
IN IN_Email VARCHAR(100),
IN IN_MobilePhone VARCHAR(50),
IN IN_FirstName VARCHAR(50),
IN IN_LastName VARCHAR(50),
IN IN_Handle VARCHAR(50),
IN IN_Gender CHAR(10),
IN IN_DateJoined DATETIME
)
BEGIN
-- --------------Comment----------------------------------
-- 1. Insert  Customer record with the supplied details (Customer)
-- -------------------------------------------------------

    INSERT INTO Customer(Email,MobilePhone,FirstName,LastName,Handle,Gender,DateJoined)
        VALUES(IN_Email,IN_MobilePhone,IN_FirstName,IN_LastName,IN_Handle,IN_Gender,IN_DateJoined);
    
    SELECT LAST_INSERT_ID();
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CUSTOMERNOTEUPDATE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `CUSTOMERNOTEUPDATE`(
IN IN_CustomerID INT,
IN IN_SupplierID INT,
IN IN_CommunityID INT,
IN IN_CommunityGroupID INT,
IN IN_NoteText TEXT
)
BEGIN
-- ---------------Comment-------------------------------------
-- 1. Check if a record already exists for the given supplier-customer-community-community group relationship in the SupplierCustomerNote table 
--      and retieve the SupplierCustomerNote.SupplierCustomerNoteID if it does
-- 2. If the returned SupplierCustomerNoteID is not null, update the existing record (SupplierCustomerNote.SupplierCustomerNoteID) with the 
--      updated Customer Note text (SupplierCustomerNote.CustomerNote)
-- 3. If the returned SupplierCustomerNoteID is null, create a new record for the given supplier-customer-community-community group relationship in 
--      the SupplierCustomerNote table, populating the customer note field (SupplierCustomerNote.CustomerNote)
-- -----------------------------------------------------------

    IF EXISTS(SELECT SupplierCustomerNoteID FROM SupplierCustomerNote WHERE CustomerID=IN_CustomerID AND SupplierID=IN_SupplierID AND CommunityID=IN_CommunityID AND CommunityGroupID=IN_CommunityGroupID) THEN
    
        UPDATE SupplierCustomerNote SET CustomerNote=IN_NoteText WHERE CustomerID=IN_CustomerID AND SupplierID=IN_SupplierID AND CommunityID=IN_CommunityID AND CommunityGroupID=IN_CommunityGroupID;
    
    ELSE
        
        INSERT INTO SupplierCustomerNote (CustomerID,CommunityID,CommunityGroupID,SupplierID,CustomerNote)
         VALUES(IN_CustomerID,IN_CommunityID,IN_CommunityGroupID,IN_SupplierID,IN_NoteText);
    END IF;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CUSTOMERREVIEWINSERT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `CUSTOMERREVIEWINSERT`(
IN IN_CustomerID INT,
IN IN_SupplierID INT,
IN IN_CommunityID INT,
IN IN_CommunityGroupID INT,
IN IN_Rating INT,
IN IN_Review TEXT,
IN IN_ReviewDate DATETIME
)
BEGIN
-- -------------------Comment--------------------------------------
-- 1. Trigger the ActionInsert stored procedure to handle any required results for this action
-- 2. Create a new review record (Review) with the supplied details - (NB: The Review.HideReview value is to be set to "false")
-- ----------------------------------------------------------------

    INSERT INTO Review (CustomerID,SupplierID,CommunityID,CommunityGroupID,Rating,Review,ReviewDate,HideReview)
        VALUES(IN_CustomerID,IN_SupplierID,IN_CommunityID,IN_CommunityGroupID,IN_Rating,IN_Review,IN_ReviewDate,false);
        
    SELECT LAST_INSERT_ID();
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CUSTOMERREVIEWSELECT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `CUSTOMERREVIEWSELECT`(
IN IN_ReviewID INT
)
BEGIN
-- ---------------Comment--------------------------------------
-- 1. Retrieve the details of a review from the supplied ReviewID (Review)
-- 2. Return the details
-- ------------------------------------------------------------

    SELECT SQL_NO_CACHE ReviewID,CustomerID,SupplierID,CommunityID,CommunityGroupID,Rating,Review,ReviewDate,HideReview FROM Review WHERE ReviewID=IN_ReviewID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CUSTOMERREVIEWSSELECT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `CUSTOMERREVIEWSSELECT`(
IN IN_SupplierID INT,
IN IN_CommunityID INT,
IN IN_CommunityGroupID INT
)
BEGIN
-- -----------------Comment--------------------------------------
-- 1. Retrieve all the reviews for the given Supplier within the given Community - Community Group (Review)
-- 2. Return the results
-- --------------------------------------------------------------

    SELECT SQL_NO_CACHE ReviewID,CustomerID,SupplierID,CommunityID,CommunityGroupID,Rating,Review,ReviewDate,HideReview FROM Review
     WHERE SupplierID=IN_SupplierID AND CommunityID=IN_CommunityID AND CommunityGroupID=IN_CommunityGroupID;
     
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CUSTOMERSEARCH` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `CUSTOMERSEARCH`(
IN IN_SearchTerm VARCHAR(50),
IN IN_CommunityID INT,
IN IN_SupplierID INT
)
BEGIN
-- -----------Comment-------------------------------------
-- 1. If the SearchTerm is not null, based on a wildcard search (prepending '%' and appending '%' and replacing any blanks with '%'), 
--      use the supplied search term to search across Customer.FirstName, Customer.LastName and Customer.Handle) for the given CommunityID (CustomerCommunity.CommunityID) 
--      and SupplierID (SupplierShortlist.SupplierID) - NB: if the SupplierID or SearchTerm is not supplied, then ignore from search filter
-- 2. Return the results
-- -------------------------------------------------------

    SELECT C.CustomerID,C.Email,C.MobilePhone,C.FirstName,C.LastName,C.Handle,C.Gender,C.DateJoined FROM Customer C INNER JOIN CustomerCommunity CC ON C.CustomerID=CC.CustomerID
    INNER JOIN SupplierShortlist SS ON C.CustomerID=SS.CustomerID WHERE (C.FirstName LIKE CONCAT('%',IN_SearchTerm,'%') OR C.LastName LIKE CONCAT('%',IN_SearchTerm,'%')
     OR C.Handle LIKE CONCAT('%',IN_SearchTerm,'%'));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CUSTOMERSELECT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `CUSTOMERSELECT`(
IN IN_CustomerID INT
)
BEGIN
-- --------Comment----------------------------------------
-- 1. Retrieve the details of the given CustomerID from the Customer table (Customer.CustomerID)
-- 2. Return the results
-- -------------------------------------------------------

    SELECT CustomerID,Email,MobilePhone,FirstName,LastName,Handle,Gender,DateJoined FROM Customer WHERE CustomerID=IN_CustomerID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CUSTOMERUPDATE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `CUSTOMERUPDATE`(
IN IN_CustomerID INT,
IN IN_Email VARCHAR(100),
IN IN_MobilePhone VARCHAR(50),
IN IN_FirstName VARCHAR(50),
IN IN_LastName VARCHAR(50),
IN IN_Handle VARCHAR(50),
IN IN_GENDER CHAR(10)
)
BEGIN
-- --------------Comment----------------------------------
-- 1. Update the existing Customer record (Customer.CustomerID) with the supplied details (Customer)
-- -------------------------------------------------------

    UPDATE Customer SET Email=IN_Email, MobilePhone=IN_MobilePhone, FirstName=IN_FirstName, LastName=IN_LastName, Handle=IN_Handle, Gender=IN_Gender
     WHERE CustomerID=IN_CustomerID;
     
     
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DEBITVIRTUALCOMMUNITYACCOUNT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `DEBITVIRTUALCOMMUNITYACCOUNT`(
IN IN_ID INT,
IN IN_Entity VARCHAR(50),
IN IN_CommunityID INT,
IN IN_CommunityGroupID INT,
IN IN_Description VARCHAR(200),
IN IN_Amount DECIMAL(10,2),
IN IN_DateApplied DATETIME,
IN IN_CustomerID INT
)
BEGIN
-- ----------------Comment-----------------------------------------------
-- 1. If the supplied entity is "Supplier"
--      a) retrieve the current balance for the supplier's community virtual account (SupplierCommunityTransactionHistory.Balance) based on the most recent transaction
--          ( Max(SupplierCommunityTransactionHistory.DateApplied) ) for the given Supplier-Community relationship
--      b) calculate the new balance for the supplier's community virtual account from the current balance and the debit amount
--      (SupplierCommunityTransactionHistory.Balance - Amount)
--      c) add a new transaction record to the supplier's community virtual account based on the calculated balance and the supplied details (SupplierCommunityTransactionHistory)
--  2. If the supplied entity is "Community Owner"
--      a) retrieve the current balance for the community owner's community virtual account (CommunityOwnerTransactionHistory.Balance) based on the most recent transaction 
--          ( Max(CommunityOwnerTransactionHistory.DateApplied) ) for the given Community Owner-Community relationship
--      b) calculate the new balance for the community owner's community virtual account from the current balance and the debit amount 
--          (CommunityOwnerTransactionHistory.Balance - Amount)
--      c) add a new transaction record to the community owner's community virtual account based on the calculated balance and the supplied details 
--          (CommunityOwnerTransactionHistory)
-- ----------------------------------------------------------------------
 DECLARE Balance DECIMAL(10,2);
    SET Balance=0;
    
    IF(IN_Entity='Supplier') THEN
     BEGIN
       SET Balance=COALESCE( (SELECT COALESCE(Balance,0) FROM SupplierCommunityTransactionHistory WHERE SupplierID=IN_ID AND CommunityID=IN_CommunityID 
                      AND DateApplied= (SELECT MAX(DateApplied) FROM SupplierCommunityTransactionHistory WHERE SupplierID=IN_ID AND CommunityID=IN_CommunityID
                                        GROUP BY DateApplied)
                    ),0);
                   
        INSERT INTO SupplierCommunityTransactionHistory(SupplierID,CommunityID,CommunityGroupID,Description,Amount,DateApplied,Balance,CustomerID)
         VALUES(IN_ID,IN_CommunityId,IN_CommunityGroupID,IN_Description,IN_Amount,IN_DateApplied,(Balance-IN_Amount),IN_CustomerID);
         
         SELECT SupplierCommunityTransactionHistoryID,SupplierID,CommunityID,CommunityGroupID,Description,Amount,DateApplied,Balance,CustomerID 
            FROM SupplierCommunityTransactionHistory WHERE SupplierCommunityTransactionHistoryID=LAST_INSERT_ID();
            
     END;
     
     ELSEIF(IN_Entity='Community Owner') THEN
     BEGIN
     
      SET Balance=COALESCE( (SELECT COALESCE(Balance,0) FROM CommunityOwnerTransactionHistory WHERE OwnerID=IN_ID AND CommunityID=IN_CommunityID 
                      AND DateApplied=(SELECT MAX(DateApplied) FROM CommunityOwnerTransactionHistory WHERE OwnerID=IN_ID AND CommunityID=IN_CommunityID
                                        GROUP BY DateApplied)
                    ),0);
                    
        INSERT INTO CommunityOwnerTransactionHistory(OwnerID,CommunityID,CommunityGroupID,Description,Amount,DateApplied,Balance)
         VALUES(IN_ID,IN_CommunityId,IN_CommunityGroupID,IN_Description,IN_Amount,IN_DateApplied,(Balance-IN_Amount));
         
          SELECT CommunityOwnerTransactionHistoryID,OwnerID,CommunityID,CommunityGroupID,Description,Amount,DateApplied,Balance
            FROM CommunityOwnerTransactionHistory WHERE CommunityOwnerTransactionHistoryID=LAST_INSERT_ID();
         
     END;
    END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ERRORLOGINSERT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `ERRORLOGINSERT`(
IN IN_Description VARCHAr(500),
IN IN_Details VARCHAr(8000),
IN IN_Timestamp DATETIME
)
BEGIN
-- -----------Comment-----------------------------------
-- Insert ErrorLog with supplied details (ErrorLogs)
-- -----------------------------------------------------

    INSERT INTO ErrorLogs(Description,Details,Timestamp) VALUES(IN_Description,IN_Details,IN_Timestamp);
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `OWNERUPDATE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `OWNERUPDATE`(
IN IN_OwnerID INT,
IN IN_CompanyName VARCHAR(50),
IN IN_Email VARCHAR(200),
IN IN_BusinessNumber VARCHAR(50),
IN IN_PreferredPaymentCurrencyID INT,
IN IN_PrimaryPhone VARCHAR(50),
IN IN_OtherPhone VARCHAR(50),
IN IN_DateAdded DATETIME,
IN IN_Website VARCHAR(50),
IN IN_AddressLine1 VARCHAR(150),
IN IN_AddressLine2 VARCHAR(150),
IN IN_AddressCity VARCHAR(50),
IN IN_AddressState VARCHAR(50),
IN IN_AddressPostalCode VARCHAR(50),
IN IN_AddressCountryID INT,
IN IN_BillingName VARCHAR(150),
IN IN_BillingAddressLine1 VARCHAR(150),
IN IN_BillingAddressLine2 VARCHAR(150),
IN IN_BillingAddressCity VARCHAR(50),
IN IN_BillingAddressState VARCHAR(50),
IN IN_BillingAddressPostalCode VARCHAR(50),
IN IN_BillingAddressCountryID VARCHAR(50)
)
BEGIN
-- -----------------Comment--------------------------------
-- 1. Update the details of an existing community owner record (Owner.OwnerID) with the supplied details.
-- --------------------------------------------------------

    UPDATE Owner SET CompanyName=IN_CompanyName, Email=IN_Email, BusinessNumber=IN_BusinessNumber, PreferredPaymentCurrencyID=IN_PreferredPaymentCurrencyID
      , PrimaryPhone=IN_PrimaryPhone, OtherPhone=IN_OtherPhone, DateAdded=IN_DateAdded, Website=IN_Website, AddressLine1=IN_AddressLine1, AddressLine2=IN_AddressLine2
      , AddressCity=IN_AddressCity, AddressState=IN_AddressState, AddressPostalCode=IN_AddressPostalCode, AddressCountryID=IN_AddressCountryID
      , BillingName=IN_BillingName, BillingAddressLine1=IN_BillingAddressLine1, BillingAddressLine2=IN_BillingAddressLine2, BillingAddressCity=IN_BillingAddressCity
      , BillingAddressState=IN_BillingAddressState, BillingAddressPostalCode=IN_BillingAddressPostalCode, BillingAddressCountryID=IN_BillingAddressCountryID
    WHERE OwnerID=IN_OwnerID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `REGISTERNEWACCOUNT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `REGISTERNEWACCOUNT`(
IN IN_OAuthProvider VARCHAR(50),
IN IN_OAuthUserID VARCHAR(200),
IN IN_OAuthToken VARCHAR(50)
)
BEGIN
-- --------Comment---------------------------------------------
-- 1. Create new account within the system based on the supplied details (OAuthAccount)
-- ------------------------------------------------------------

    INSERT INTO OAuthAccount (Provider,ProviderUSerID,Token) VALUES (IN_OAuthProvider,IN_OAuthUserID,IN_OAuthToken);
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `REGISTERNEWCOMMUNITYOWNER` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `REGISTERNEWCOMMUNITYOWNER`(
IN IN_OAuthAccountID INT,
IN IN_CompanyName VARCHAR(50),
IN IN_Email VARCHAR(200),
IN IN_BusinessNumber VARCHAR(50),
IN IN_PreferredPaymentCurrencyID INT,
IN IN_PrimaryPhone VARCHAR(50),
IN IN_OtherPhone VARCHAR(50),
IN IN_DateAdded DATETIME,
IN IN_Website VARCHAR(50),
IN IN_AddressLine1 VARCHAR(150),
IN IN_AddressLine2 VARCHAR(150),
IN IN_AddressCity VARCHAR(50),
IN IN_AddressState VARCHAR(50),
IN IN_AddressPostalCode VARCHAR(50),
IN IN_AddressCountryID INT,
IN IN_BillingName VARCHAR(150),
IN IN_BillingAddressLine1 VARCHAR(150),
IN IN_BillingAddressLine2 VARCHAR(150),
IN IN_BillingAddressCity VARCHAR(50),
IN IN_BillingAddressState VARCHAR(50),
IN IN_BillingAddressPostalCode VARCHAR(50),
IN IN_BillingAddressCountryID VARCHAR(50)
)
BEGIN
-- --------Comment------------------------------------------------------
-- 1. Create a new community owner record with the supplied details (Owner)
-- 2. Associate the newly created Owner record (Owner.OwnerID) with the supplied OAuth Account (OAuthAccount.OAuthAccountID) (EntityOAuthAccount)
-- ---------------------------------------------------------------------

    DECLARE ID INT;
    DECLARE exit handler for sqlexception
      BEGIN
        -- ERROR
        RESIGNAL;
      ROLLBACK;
    END;

    DECLARE exit handler for sqlwarning
     BEGIN
     RESIGNAL;
        -- WARNING
     ROLLBACK;
    END;
    
    START TRANSACTION;
    
        INSERT INTO Owner (CompanyName,Email,BusinessNumber,PreferredPaymentCurrencyID,PrimaryPhone,OtherPhone,DateAdded,Website,AddressLine1,AddressLine2,AddressCity
            ,AddressState,AddressPostalCode,AddressCountryID,BillingName,BillingAddressLine1,BillingAddressLine2,BillingAddressCity,BillingAddressState,BillingAddressPostalCode
            , BillingAddressCountryID)
        VALUES (IN_CompanyName,IN_Email,IN_BusinessNumber,IN_PreferredPaymentCurrencyID,IN_PrimaryPhone,IN_OtherPhone,IN_DateAdded,IN_Website,IN_AddressLine1,IN_AddressLine2
            ,IN_AddressCity,IN_AddressState,IN_AddressPostalCode,IN_AddressCountryID,IN_BillingName,IN_BillingAddressLine1,IN_BillingAddressLine2,IN_BillingAddressCity
            ,IN_BillingAddressState,IN_BillingAddressPostalCode,IN_BillingAddressCountryID);
        
        
        SET ID=(SELECT LAST_INSERT_ID());
        
        INSERT INTO EntityOAuthAccount (EntityType,EntityID,OAuthAccountID) VALUES ('CommunityOwner',ID,IN_OAuthAccountID);
        
        SELECT ID;
        
    COMMIT;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `REGISTERNEWSUPPLIER` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `REGISTERNEWSUPPLIER`(
IN IN_OAuthAccountID INT,
IN IN_CompanyName VARCHAR(50),
IN IN_Email VARCHAR(200),
IN IN_BusinessNumber VARCHAR(50),
IN IN_PreferredPaymentCurrencyID INT,
IN IN_PrimaryPhone VARCHAR(50),
IN IN_OtherPhone VARCHAR(50),
IN IN_DateAdded DATETIME,
IN IN_Website VARCHAR(50),
IN IN_AddressLine1 VARCHAR(150),
IN IN_AddressLine2 VARCHAR(150),
IN IN_AddressCity VARCHAR(50),
IN IN_AddressState VARCHAR(50),
IN IN_AddressPostalCode VARCHAR(50),
IN IN_AddressCountryID INT,
IN IN_BillingName VARCHAR(150),
IN IN_BillingAddressLine1 VARCHAR(150),
IN IN_BillingAddressLine2 VARCHAR(150),
IN IN_BillingAddressCity VARCHAR(50),
IN IN_BillingAddressState VARCHAR(50),
IN IN_BillingAddressPostalCode VARCHAR(50),
IN IN_BillingAddressCountryID VARCHAR(50),
IN IN_Longitude DECIMAL(10,4),
IN IN_Latitude DECIMAL(10,4),
IN IN_ProfileCompletedDate DATETIME,
IN IN_QuoteTerms VARCHAR(250),
IN IN_DepositPercent DECIMAL(10,2),
IN IN_DepositTerms VARCHAR(250)
)
BEGIN
-- -------Comment--------------------------------------------------
-- 1. Create a new supplier record with the supplied details (Supplier)
-- 2. Associate the newly created Supplier record (Supplier.SupplierID) with the supplied OAuth Account (OAuthAccount.OAuthAccountID) (EntityOAuthAccount)
-- ----------------------------------------------------------------
    DECLARE ID INT;
    DECLARE exit handler for sqlexception
      BEGIN
        -- ERROR
        RESIGNAL;
      ROLLBACK;
    END;

    DECLARE exit handler for sqlwarning
     BEGIN
        -- WARNING
        RESIGNAL;
     ROLLBACK;
    END;
    
    START TRANSACTION;
        INSERT INTO Supplier (CompanyName,Email,Website,PrimaryPhone,OtherPhone,AddressLine1,AddressLine2,AddressCity,AddressState,AddressPostalCode,AddressCountryID
          ,BillingName,BillingAddressLine1,BillingAddressLine2,BillingAddressCity,BillingAddressState,BillingAddressPostalCode,BillingAddressCountryID,BusinessNumber
          ,Longitude,Latitude,DateAdded,ProfileCompletedDate,QuoteTerms,DepositPercent,DepositTerms)
          
        VALUES(IN_CompanyName,IN_Email,IN_Website,IN_PrimaryPhone,IN_OtherPhone,IN_AddressLine1,IN_AddressLine2,IN_AddressCity,IN_AddressState,IN_AddressPostalCode
          ,IN_AddressCountryID,IN_BillingName,IN_BillingAddressLine1,IN_BillingAddressLine2,IN_BillingAddressCity,IN_BillingAddressState,IN_BillingAddressPostalCode
          ,IN_BillingAddressCountryID,IN_BusinessNumber,IN_Longitude,IN_Latitude,IN_DateAdded,IN_ProfileCompletedDate,IN_QuoteTerms,IN_DepositPercent,IN_DepositTerms);
            
        SET ID=(SELECT LAST_INSERT_ID());
          
          INSERT INTO EntityOAuthAccount (EntityType,EntityID,OAuthAccountID) VALUES ('Supplier',ID,IN_OAuthAccountID);
          
          SELECT ID;
          
    COMMIT;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `REVIEWHELPFULINSERT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `REVIEWHELPFULINSERT`(
IN IN_ReviewID INT,
IN IN_CustomerID INT
)
BEGIN
-- -----------Comment--------------------------------------------
-- 1. Trigger the ActionInsert stored procedure to handle any required results for this action
-- 2. Insert a new 'review helpful' record (ReviewHelpful) with the supplied ReviewID and CustomerID
-- --------------------------------------------------------------

    INSERT INTO ReviewHelpful(ReviewID,CustomerID) VALUES(IN_ReviewID,IN_CustomerID);
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `REVIEWRESPONSESELECT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `REVIEWRESPONSESELECT`(
IN IN_ReviewID INT
)
BEGIN
-- ---------Comment--------------------------------------------
-- 1. Retrieve the response detail for the given Review (ReviewResponse.ReviewID)
-- 2. Return the results
-- ------------------------------------------------------------

    SELECT SQL_NO_CACHE ReviewResponseID,ReviewID,Response,ResponseDate,HideResponse FROM ReviewResponse WHERE ReviewID=IN_ReviewID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `REWARDSSELECT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `REWARDSSELECT`(
IN IN_CustomerID INT,
IN IN_CommunityID INT
)
BEGIN
-- ---------Comment---------------------------------------------
-- 1. Retrieve all the rewards for the given Customer - Community (CustomerRewards)
-- 2. Return the results
-- -------------------------------------------------------------

    SELECT CustomerRewardID,CommunityID,CustomerID,RewardDate,CommunityRewardID,RewardName,RewardDescription,PointsApplied,TriggeredEventsID
    FROM CustomerRewards WHERE CustomerID=IN_CustomerID AND CommunityID=IN_CommunityID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `REWARDSTALLYSELECT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `REWARDSTALLYSELECT`(
IN IN_CustomerID INT,
IN IN_CommunityID INT
)
BEGIN
-- -----Comment-------------------------------------------------
-- 1. Retrieve the current reward points tally for the given Customer in the context of the given Community (CustomerPointsTally)
-- 2. Return the results
-- -------------------------------------------------------------

    SELECT SQL_NO_CACHE CustomerID,CommunityID,PointsTally FROM CustomerPointsTally WHERE CustomerID=IN_CustomerID AND CommunityID=IN_CommunityID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ShortlistUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `ShortlistUpdate`(
IN IN_CustomerID INT,
IN IN_SupplierID INT,
IN IN_CommunityID INT,
IN IN_CommunityGroupId INT,
IN IN_Add BIT
)
BEGIN
-- -----------Comment---------------------------------------
-- 1. Trigger the ActionInsert stored procedure to handle any required results for this action
-- 2. If Add = "true", then add the supplier to the customer's shortlist for the given community - community group (SupplierShortlist)
-- 3. If Add = "false", then remove the supplier from the customer's shortlist for the given community - community group (SupplierShortlist)
-- ---------------------------------------------------------

    IF(IN_Add=true) THEN
        INSERT INTO SupplierShortList(CustomerID,CommunityID,CommunityGroupID,SupplierID)
        VALUES(IN_CustomerID,IN_CommunityID,IN_CommunityGroupID,IN_SupplierID);
        
    ELSE 
        DELETE FROM SupplierShortList WHERE  CommunityID=IN_CommunityID AND CommunityGroupID=IN_CommunityGroupId;
          
    END IF;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SUPPLIERICONINSERT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `SUPPLIERICONINSERT`(
IN IN_SupplierID INT,
IN IN_Icon BINARY(10)
)
BEGIN
-- ---Comment------------------------------------------------
-- Insert a new supplierIcon record with the supplied details (SuppliedIcon)
-- If already exists then Update Icon
-- ----------------------------------------------------------

    IF(EXISTS(SELECT SupplierID FROM SupplierIcon WHERE SupplierID=IN_SupplierID)) THEN
        UPDATE SupplierIcon SET Icon=IN_Icon WHERE SupplierID=IN_SupplierID;
    ELSE
        INSERT INTO SupplierIcon(SupplierID,Icon) VALUES(IN_SupplierID,IN_Icon);
    END IF;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SUPPLIERICONSELECT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `SUPPLIERICONSELECT`(
IN IN_SupplierID INT
)
BEGIN
-- --------------Comment-------------------------------------
-- Get Supplier Icon based on SupplierId
-- ----------------------------------------------------------

    SELECT SQL_NO_CACHE SupplierID,Icon FROM SupplierIcon WHERE SupplierID=IN_SupplierID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SupplierInsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `SupplierInsert`(
IN IN_CompanyName VARCHAR(50),
IN IN_Email VARCHAR(200),
IN IN_Website VARCHAR(200),
IN IN_PrimaryPhone VARCHAR(50),
IN IN_OtherPhone VARCHAR(50),
IN IN_AddressLine1 VARCHAR(150),
IN IN_AddressLine2 VARCHAR(150),
IN IN_AddressCity VARCHAR(50),
IN IN_AddressState VARCHAR(50),
IN IN_AddressPostalCode VARCHAR(50),
IN IN_AddressCountryID INT,
IN IN_BillingName VARCHAR(150),
IN IN_BillingAddressLine1 VARCHAR(150),
IN IN_BillingAddressLine2 VARCHAR(150),
IN IN_BillingAddressCity VARCHAR(50),
IN IN_BillingAddressState VARCHAR(50),
IN IN_BillingAddressPostalCode VARCHAR(50),
IN IN_BillingAddressCountryID INT,
IN IN_BusinessNumber VARCHAR(50),
IN IN_Longitude DECIMAL(10,4),
IN IN_Latitude DECIMAL(10,4)
)
BEGIN
-- -----------Comment----------------------------------
-- 1. Create a new supplier record (Supplier) with the supplied details
-- ----------------------------------------------------

    INSERT INTO Supplier(CompanyName,Email,Website,PrimaryPhone,OtherPhone,AddressLine1,AddressLine2,AddressCity,AddressState,AddressPostalCode,AddressCountryID
                         ,BillingName,BillingAddressLine1,BillingAddressLine2,BillingAddressCity,BillingAddressState,BillingAddressPostalCode,BillingAddressCountryID
                         ,BusinessNumber,Longitude,Latitude,DateAdded)
    VALUES(IN_CompanyName,IN_Email,IN_Website,IN_PrimaryPhone,IN_OtherPhone,IN_AddressLine1,IN_AddressLine2,IN_AddressCity,IN_AddressState,IN_AddressPostalCode
            ,IN_AddressCountryID,IN_BillingName,IN_BillingAddressLine1,IN_BillingAddressLine2,IN_BillingAddressCity,IN_BillingAddressState,IN_BillingAddressPostalCode
            ,IN_BillingAddressCountryID,IN_BusinessNumber,IN_Longitude,IN_Latitude,NOW());
            
    SELECT LAST_INSERT_ID();
            
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SUPPLIERLOGOINSERT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `SUPPLIERLOGOINSERT`(
IN IN_SupplierID INT,
IN IN_Logo BINARY(10)
)
BEGIN
-- ------------------Comment---------------------------------
-- Insert a new supplierLogo record with the supplied details (SuppliedIcon)
-- If already exist then update Logo
-- ----------------------------------------------------------

    IF(EXISTS(SELECT SupplierID FROM SupplierLogo WHERE SupplierID=IN_SupplierID)) THEN
        UPDATE SupplierLogo SET Logo=IN_Logo WHERE SupplierID=IN_SupplierID;
    ELSE
        INSERT INTO SupplierLogo(SupplierID,Logo) VALUES(IN_SupplierID,IN_Logo);
    END IF;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SUPPLIERLOGOSELECT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `SUPPLIERLOGOSELECT`(
IN IN_SupplierID INT
)
BEGIN
-- ------------------Comment----------------------------------
-- Get Supplier Logo based on SupplierId
-- -----------------------------------------------------------

    SELECT SQL_NO_CACHE SupplierID,Logo FROM SupplierLogo WHERE SupplierID=IN_SupplierID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SupplierNoteUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `SupplierNoteUpdate`(
IN IN_CustomerID INT,
IN IN_SupplierID INT,
IN IN_CommunityID INT,
IN IN_CommunityGroupID INT,
IN IN_NoteText TEXT
)
BEGIN
-- -------------Comment-------------------------------------------
-- 1. Check if a record already exists for the given supplier-customer-community-community group relationship in the SupplierCustomerNote table 
--      and retieve the SupplierCustomerNote.SupplierCustomerNoteID if it does
-- 2. If the returned SupplierCustomerNoteID is not null, update the existing record (SupplierCustomerNote.SupplierCustomerNoteID) with the updated 
--      Supplier Note text (SupplierCustomerNote.SupplierNote)
-- 3. If the returned SupplierCustomerNoteID is null, create a new record for the given supplier-customer-community-community group relationship in 
--      the SupplierCustomerNote table, populating the supplier note field (SupplierCustomerNote.SupplierNote)
-- ---------------------------------------------------------------

    IF (EXISTS(SELECT SupplierCustomerNoteID FROM SupplierCustomerNote WHERE CustomerID=IN_CustomerID AND SupplierID=IN_SupplierID 
                AND CommunityID=IN_CommunityID AND CommunityGroupID=IN_CommunityGroupID)) THEN
       
        UPDATE SupplierCustomerNote SET SupplierNote=IN_NoteText WHERE CustomerID=IN_CustomerID AND SupplierID=IN_SupplierID
            AND CommunityID=IN_CommunityId AND CommunityGroupID=IN_CommunityGroupID;
    ELSE
        INSERT INTO SupplierCustomerNote(CustomerID,CommunityId,CommunityGroupID,SupplierID,SupplierNote) 
            VALUES(IN_CustomerID,IN_CommunityID,IN_CommunityGroupID,IN_SupplierID,IN_NoteText);
    END IF;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SupplierSearch` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `SupplierSearch`(
IN IN_SearchTerm VARCHAR(50),
IN IN_CommunityID INT,
IN IN_CommunityGroupID INT,
IN IN_Filter VARCHAR(50)
)
BEGIN
-- -----------Comment----------------------------------------
-- 1. If the Filter value = "All"
--      a) retrieve all suppliers from the Supplier table where they are linked to the supplied Community (CommunitySupplier.CommunityID) and/or Community Group 
--          (CommunityGroupSupplier.CommunityGroupID) that match the wildcard search term (SearchTerm with "%" prepended & appended and replacing blanks)
-- 2. If the Filter value = "In Credit"
--      a) retrieve all suppliers from the Supplier table where they are linked to the supplied Community (CommunitySupplier.CommunityID) and/or Community Group 
--          (CommunityGroupSupplier.CommunityGroupID) that match the wildcard search term (SearchTerm with "%" prepended & appended and replacing blanks) 
--          and that have a current balance for the associated CommunityID (SupplierCommunityTransactionHistory.Balance) greater than equal to the defined 
--          MinCredit amount (CommunityGroup.CreditMin)
-- 3. If the Filter value = "Out of Credit"
--      a) retrieve all suppliers from the Supplier table where they are linked to the supplied Community (CommunitySupplier.CommunityID) and/or Community Group 
--          (CommunityGroupSupplier.CommunityGroupID) that match the wildcard search term (SearchTerm with "%" prepended & appended and replacing blanks) and that
-- 4. If the Filter value = "Below Min Credit"
--      a) retrieve all suppliers from the Supplier table where they are linked to the supplied Community (CommunitySupplier.CommunityID) and/or Community Group 
--          (CommunityGroupSupplier.CommunityGroupID) that match the wildcard search term (SearchTerm with "%" prepended & appended and replacing blanks) 
--          and that have a current balance for the associated CommunityID (SupplierCommunityTransactionHistory.Balance) less than the defined MinCredit amount 
--          (CommunityGroup.CreditMin) and greater than 0.00
-- 5. Return the results
-- ----------------------------------------------------------

    IF(IN_Filter='All') THEN
        SELECT SQL_NO_CACHE S.* FROM Supplier S LEFT JOIN CommunitySupplier CS ON CS.SupplierID=S.SupplierID 
            LEFT JOIN CommunityGroupSupplier CGS ON CGS.SupplierID=S.SupplierID
        WHERE COMPANYNAME LIKE CONCAT('%',IN_SearchTerm,'%') AND CS.CommunityID=IN_CommunityID AND CGS.CommunityGroupID=IN_CommunityGroupId;
        
    ELSEIF(IN_Filter='IN Credit') THEN
        
        SELECT SQL_NO_CACHE S.* FROM Supplier S LEFT JOIN CommunitySupplier CS ON CS.SupplierID=S.SupplierID 
            LEFT JOIN CommunityGroupSupplier CGS ON CGS.SupplierID=S.SupplierID
            LEFT JOIN SupplierCommunityTransactionHistory SH ON SH.SupplierID=S.SupplierID
            LEFT Join CommunityGroup CG ON CG.CommunityGroupID=CGS.CommunityGroupID
        WHERE COMPANYNAME LIKE CONCAT('%',IN_SearchTerm,'%') AND CS.CommunityID=IN_CommunityID AND CG.CommunityGroupID=IN_CommunityGroupId
        AND SH.Balance>=CG.CreditMin;
       
     ELSEIF(IN_Filter='Out of Credit') THEN
        
        SELECT SQL_NO_CACHE S.* FROM Supplier S LEFT JOIN CommunitySupplier CS ON CS.SupplierID=S.SupplierID 
            LEFT JOIN CommunityGroupSupplier CGS ON CGS.SupplierID=S.SupplierID
            LEFT JOIN SupplierCommunityTransactionHistory SH ON SH.SupplierID=S.SupplierID
            -- LEFT Join CommunityGroup CG ON CG.CommunityGroupID=CGS.CommunityGroupID
        WHERE COMPANYNAME LIKE CONCAT('%',IN_SearchTerm,'%') AND CS.CommunityID=IN_CommunityID AND CGS.CommunityGroupID=IN_CommunityGroupId
        AND SH.Balance=0;
        
     ELSEIF(IN_Filter='Below Min Credit') THEN
        
        SELECT SQL_NO_CACHE S.* FROM Supplier S LEFT JOIN CommunitySupplier CS ON CS.SupplierID=S.SupplierID 
            LEFT JOIN CommunityGroupSupplier CGS ON CGS.SupplierID=S.SupplierID
            LEFT JOIN SupplierCommunityTransactionHistory SH ON SH.SupplierID=S.SupplierID
            LEFT Join CommunityGroup CG ON CG.CommunityGroupID=CGS.CommunityGroupID
        WHERE COMPANYNAME LIKE CONCAT('%',IN_SearchTerm,'%') AND CS.CommunityID=IN_CommunityID AND CG.CommunityGroupID=IN_CommunityGroupId
        AND SH.Balance<CG.CreditMin AND SH.Balance>0;    
    
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SupplierSelect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `SupplierSelect`(
IN IN_SupplierID INT
)
BEGIN
-- ------------Comment------------------------------------
-- 1. Retrieve the details of the given SupplierID from the Supplier table (Supplier.SupplierID)
-- 2. Return the results
-- -------------------------------------------------------

    SELECT SupplierID,CompanyName,Email,Website,PrimaryPhone,OtherPhone,AddressLine1,AddressLine2,AddressCity,AddressState
            ,AddressPostalCode,AddressCountryID,BillingName,BillingAddressLine1,BillingAddressLine2,BillingAddressCity,BillingAddressState
            ,BillingAddressPostalCode,BillingAddressCountryID,BusinessNumber,Longitude,Latitude,DateAdded,ProfileCompletedDate,QuoteTerms,DepositPercent,DepositTerms
    FROM Supplier WHERE SupplierID=IN_SupplierID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SupplierSocialReferenceDelete` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `SupplierSocialReferenceDelete`(
IN IN_SupplierSocialReferenceID INT
)
BEGIN
-- -------------Comment-------------------------------------------------
-- 1. Remove the given supplier's social reference (SupplierSocialReference)
-- ---------------------------------------------------------------------

    DELETE FROM SupplierSocialReference WHERE SupplierSocialReferenceID=IN_SupplierSocialReferenceID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SupplierSocialReferenceInsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `SupplierSocialReferenceInsert`(
IN IN_SupplierID INT,
IN IN_SocialMediaID INT,
IN IN_SocialMediaReference VARCHAR(200)
)
BEGIN
-- -------------Comment-------------------------------------------------
-- 1. Insert a new social reference for the given supplier with the given details (SupplierSocialReference)
-- ---------------------------------------------------------------------

    INSERT INTO SupplierSocialReference(SupplierID,SocialMediaID,SocialMediaReference)
    VALUES(IN_SupplierID,IN_SocialMediaID,IN_SocialMediaReference);
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SupplierSocialReferenceUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `SupplierSocialReferenceUpdate`(
IN IN_SupplierSocialReferenceID INT,
IN IN_SupplierID INT,
IN IN_SocialMediaID INT,
IN IN_SocialMediaReference VARCHAR(200)
)
BEGIN
-- -------------Comment---------------------------------------------
-- 1. Updates an existing social reference record for a supplier with the given details (SupplierSocialReference)
-- -----------------------------------------------------------------

    UPDATE SupplierSocialReference SET SupplierID=IN_SupplierID,SocialMediaID=IN_SocialMediaID,SocialMediaReference=IN_SocialMediaReference
    WHERE SupplierSocialReferenceID=IN_SupplierSocialReferenceID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SupplierUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `SupplierUpdate`(
IN IN_SupplierID INT,
IN IN_CompanyName VARCHAR(50),
IN IN_Email VARCHAR(200),
IN IN_BusinessNumber VARCHAR(50),
IN IN_PrimaryPhone VARCHAR(50),
IN IN_OtherPhone VARCHAR(50),
IN IN_DateAdded DATETIME,
IN IN_Website VARCHAR(200),
IN IN_AddressLine1 VARCHAR(150),
IN IN_AddressLine2 VARCHAR(150),
IN IN_AddressCity VARCHAR(50),
IN IN_AddressState VARCHAR(50),
IN IN_AddressPostalCode VARCHAR(50),
IN IN_AddressCountryID INT,
IN IN_BillingName VARCHAR(150),
IN IN_BillingAddressLine1 VARCHAR(150),
IN IN_BillingAddressLine2 VARCHAR(150),
IN IN_BillingAddressCity VARCHAR(50),
IN IN_BillingAddressState VARCHAR(50),
IN IN_BillingAddressPostalCode VARCHAR(50),
IN IN_BillingAddressCountryID VARCHAR(50),
IN IN_Longitude DECIMAL(10,4),
IN IN_Latitude DECIMAL(10,4),
IN IN_ProfileCompletedDate DATETIME,
IN IN_QuoteTerms VARCHAR(250),
IN IN_DepositPercent DECIMAL(10,2),
IN IN_DepositTerms VARCHAr(250)
)
BEGIN
-- -----------Comment-----------------------------------------
-- 1. Update an existing supplier record (Supplier.SupplierID) with the supplied details (Supplier)
-- -----------------------------------------------------------

    UPDATE Supplier SET CompanyName=IN_CompanyName,Email=IN_Email,BusinessNumber=IN_BusinessNumber
        ,PrimaryPhone=IN_PrimaryPhone,OtherPhone=IN_OtherPhone,DateAdded=IN_DateAdded,Website=IN_Website,AddressLine1=IN_AddressLine1
        ,AddressLine2=IN_AddressLine2,AddressCity=IN_AddressCity,AddressState=IN_AddressState,AddressPostalCode=IN_AddressPostalCode
        ,AddressCountryID=IN_AddressCountryID,BillingName=IN_BillingName,BillingAddressLine1=IN_BillingAddressLine1,BillingAddressLine2=IN_BillingAddressLine2
        ,BillingAddressCity=IN_BillingAddressCity,BillingAddressState=IN_BillingAddressState,BillingAddressPostalCode=IN_BillingAddressPostalCode
        ,BillingAddressCountryID=IN_BillingAddressCountryID,Longitude=IN_Longitude,Latitude=IN_Latitude,ProfileCompletedDate=IN_ProfileCompletedDate
        ,QuoteTerms=IN_quoteTerms,DepositPercent=IN_DepositPercent,DepositTerms=IN_DepositTerms
    WHERE SupplierID=IN_SupplierID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TransactionSelect` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `TransactionSelect`(
IN IN_TransactionHistoryID INT,
IN IN_Entity VARCHAR(50)
)
BEGIN
-- ------Comment---------------------------------------------
-- 1. The supplied entity is "Community Owner"
--      a) Retrieve the transaction record for the supplied TransactionHistoryID for the given Community Owner - Community 
--          (CommunityOwnerTransactionHistory.CommunityOwnerTransactionHistoryID)
-- 2. The supplied entity is "Supplier"
--      a) Retrieve the transaction record for the supplied TransactionHistoryID for the given Supplier - Community 
--          (SupplierCommunityTransactionHistory.SupplierCommunityTransactionHistoryID)
-- 3. Return the results
-- ----------------------------------------------------------

    IF(IN_Entity='Community Owner') THEN
        SELECT SQL_NO_CACHE CommunityOwnerTransactionHistoryID,OwnerID,CommunityID,CommunityGroupID,Description,Amount,DateApplied,Balance
        FROM CommunityOwnerTransactionHistory WHERE CommunityOwnerTransactionHistoryID=IN_TransactionHistoryID;
    
    ELSEIF(IN_Entity='Supplier') THEN
        SELECT SQL_NO_CACHE SupplierCommunityTransactionHistoryID,SupplierID,CommunityID,CommunityGroupID,Description,Amount,DateApplied,Balance,CustomerID
        FROM SupplierCommunityTransactionHistory WHERE SupplierCommunityTransactionHistoryID=IN_TransactionHistoryID;
        
    END IF;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TriggeredEventInsert` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `TriggeredEventInsert`(
IN IN_ActionName VARCHAR(50),
IN IN_ActionResponse INT,
IN IN_BillingPercentageAdministrator DECIMAL(10,2),
IN IN_BillingPercentageOwner DECIMAL(10,2),
IN IN_ISActive BIT
)
BEGIN
-- -----------Comment-------------------------------------------
-- 1. Create a new action record from the supplied ActionName and ActionResponse and receive the returned ActionID
-- 2. Creatae a new triggered event record from the returned ActionID and the supplied data (TriggeredEvent) - (NB: Newly created records will have a RecVer of 1).
-- -------------------------------------------------------------

    DECLARE ID INT;
    DECLARE exit handler for sqlexception
    BEGIN
        -- ERROR
      RESIGNAL;
      ROLLBACK;
    END;

    DECLARE exit handler for sqlwarning
     BEGIN
        -- WARNING
     RESIGNAL;
     ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO Actions(Name) VALUES(IN_ActionName);
    
    SET ID=LAST_INSERT_ID();
    INSERT INTO ActionResponse(ActionID,ResponseID) VALUES(ID,ActionResponse);
        
    INSERT INTO TriggeredEvent(ActionID,RecVer,BillingPercentageAdministrator,BillingPercentageOwner,IsActive)
    VALUES(ID,1,IN_BillingPercentageAdministrator,IN_BillingPercentageOwner,IN_IsActive);
   
     COMMIT;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TriggeredEventUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `TriggeredEventUpdate`(
IN IN_ActionID INT,
IN IN_ActionResponse INT,
IN IN_RecVer INT,
IN IN_BillingPercentageAdministrator DECIMAL(10,2),
IN IN_BillingPercentageOwner DECIMAL(10,2),
IN IN_IsActive BIT
)
BEGIN
-- ------------Comment-----------------------------------------
-- 1. Update the action record (Actions) with the supplied Action Response (Actions.ActionResponse)
-- 2. Update the existing triggered event record (TriggeredEvent.TriggeredEventID) with the supplied details (TriggeredEvent)
-- ------------------------------------------------------------

    DECLARE exit handler for sqlexception
    BEGIN
        -- ERROR
      RESIGNAL;
      ROLLBACK;
    END;

    DECLARE exit handler for sqlwarning
     BEGIN
        -- WARNING
     RESIGNAL;
     ROLLBACK;
    END;

    START TRANSACTION;
    
        IF(EXISTS(SELECT ActionID FROM ActionResponse WHERE ActionID=IN_ActionID AND ResponseID=IN_ActionResponse)) THEN
            INSERT INTO ActionResponse(ActionID,ResponseID) VALUEs(IN_ActionID,IN_ActionResponse);
        END IF;
        
        UPDATE TriggeredEvent SET RecVer=IN_RecVer,BillingPercentageAdministrator=IN_BillingPercentageAdministrator
            ,BillingPercentageOwner=IN_BillingPercentageOwner,ISActive=IN_IsActive 
        WHERE ActionID=IN_ActionID;
        
    COMMIT;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UT_COMMUNITYDELETE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `UT_COMMUNITYDELETE`(
IN IN_CommunityID INT
)
BEGIN
-- --------Comment------------------------------------------
-- Delete Community from table (Unit test purpose)
-- ---------------------------------------------------------

    DELETE FROM Community WHERE CommunityID=IN_CommunityID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UT_COMMUNITYGROUPDELETE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `UT_COMMUNITYGROUPDELETE`(
IN IN_CommunityGroupID INT
)
BEGIN
-- -------------------Comment------------------------------------
-- Delete Community group from table (Unit test purpose)
-- --------------------------------------------------------------
    
    DELETE FROM CommunityGroup WHERE CommunityGroupID=IN_CommunityGroupID;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UT_CUSTOMERDELETE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `UT_CUSTOMERDELETE`(
IN IN_CustomerID INT
)
BEGIN
-- --------Comment-------------------------------------------
-- Delete Customer information from tabel(Customer) based on CustomerId (Unit test purpose)
-- ----------------------------------------------------------

    DELETE FROM Customer WHERE CustomerID=IN_CustomerID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UT_DELETECURRENCY` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `UT_DELETECURRENCY`(
IN IN_CurrencyID INT
)
BEGIN
-- -------------------Comment------------------------------
-- Delete Currency from tabel 
-- --------------------------------------------------------

    DELETE FROM Currency WHERE CurrencyId=IN_CurrencyID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UT_GETCURRENCY` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `UT_GETCURRENCY`(
IN IN_CurrencyID INT
)
BEGIN
-- ---------Comment--------------------------------------
-- Get Currency information based on CurrencyID
-- -------------------------------------------------------

    SELECT CurrencyID,ISOCode,Description,MinTransferAmount,IsActive FROM Currency WHERE CurrencyID=IN_CurrencyID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UT_OWNERDELETE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `UT_OWNERDELETE`(
IN IN_OwnerID INT
)
BEGIN
-- ---------Comment-----------------------------------------
-- Delete Supplier from tabel (Unit test purpose)
-- ---------------------------------------------------------
    
    DECLARE exit handler for sqlexception
      BEGIN
        -- ERROR
        RESIGNAL;
      ROLLBACK;
    END;

    DECLARE exit handler for sqlwarning
     BEGIN
        -- WARNING
        RESIGNAL;
     ROLLBACK;
    END;
    
    START TRANSACTION;
    
    DELETE FROM EntityOAuthAccount WHERE EntityType='CommunityOwner' AND EntityID=IN_OwnerID;
    
    DELETE FROM Owner WHERE OwnerID=IN_OwnerID;
    
    COMMIT;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UT_OWNERSELECT` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `UT_OWNERSELECT`(
IN IN_OwnerID INT
)
BEGIN
-- -------------Comment-----------------------------------
-- Get Owner Information based on OwnerID (Unit test purpose)
-- -------------------------------------------------------

    SELECT * FROM Owner WHERE OwnerID=IN_OwnerID;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UT_REVIEWDELETE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `UT_REVIEWDELETE`(
IN IN_ReviewID INT
)
BEGIN
-- --------------------Comment----------------------------
-- Delete Review from table (Unit test purpose)
-- -------------------------------------------------------
    
    DELETE FROM Review WHERE ReviewID=IN_ReviewID;
    

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UT_SUPPLIERDELETE` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `UT_SUPPLIERDELETE`(
IN IN_SupplierID INT
)
BEGIN
-- ---------Comment-----------------------------------------
-- Delete Supplier from tabel (Unit test purpose)
-- ---------------------------------------------------------
    
    DECLARE exit handler for sqlexception
      BEGIN
        -- ERROR
        RESIGNAL;
      ROLLBACK;
    END;

    DECLARE exit handler for sqlwarning
     BEGIN
        -- WARNING
        RESIGNAL;
     ROLLBACK;
    END;
    
    START TRANSACTION;
    
    DELETE FROM EntityOAuthAccount WHERE EntityType='Supplier' AND EntityID=IN_SupplierID;
    
    DELETE FROM Supplier WHERE SupplierID=IN_SupplierID;
    
    COMMIT;
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ValidateAccount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `ValidateAccount`(
in OAuthProvider varchar(50),
in OAuthUserID varchar(200),
in OAuthToken varchar(50)
)
BEGIN
    
      IF(EXISTS(SELECT OAuthAccountID From oauthaccount Where Provider=OAuthProvider AND ProviderUSerID=OAuthUserID AND Token=OAuthToken)) THEN
            SELECT 'valid' as result;
       ELSE
            SELECT 'invalid' as result;
       END IF;
      
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-04-05 15:16:21
