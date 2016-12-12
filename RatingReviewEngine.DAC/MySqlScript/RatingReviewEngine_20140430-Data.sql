CREATE DATABASE  IF NOT EXISTS `ratingreviewengine` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `ratingreviewengine`;
-- MySQL dump 10.13  Distrib 5.5.16, for Win32 (x86)
--
-- Host: 192.168.1.111    Database: ratingreviewengine
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `currency`
--

LOCK TABLES `currency` WRITE;
/*!40000 ALTER TABLE `currency` DISABLE KEYS */;
INSERT INTO `currency` VALUES (1,'AUD','Australian Dollar',10.00,''),(2,'USD','US Dollar',10.00,''),(3,'INR','Indian Rupee',10.00,'');
/*!40000 ALTER TABLE `currency` ENABLE KEYS */;
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
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `country` (
  `CountryID` int(11) NOT NULL AUTO_INCREMENT,
  `CountryName` varchar(100) NOT NULL,
  PRIMARY KEY (`CountryID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country`
--

LOCK TABLES `country` WRITE;
/*!40000 ALTER TABLE `country` DISABLE KEYS */;
INSERT INTO `country` VALUES (1,'Australia'),(2,'New Zealand'),(3,'India'),(4,'United States');
/*!40000 ALTER TABLE `country` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-04-30 18:57:20
