-- MySQL dump 10.13  Distrib 5.1.61, for redhat-linux-gnu (x86_64)
--
-- Host: localhost    Database: DNS
-- ------------------------------------------------------
-- Server version	5.1.61

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
-- Table structure for table `DOMAINNAME`
--

DROP TABLE IF EXISTS `DOMAINNAME`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DOMAINNAME` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domainsuffix` varchar(254) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DOMAINNAME`
--

LOCK TABLES `DOMAINNAME` WRITE;
/*!40000 ALTER TABLE `DOMAINNAME` DISABLE KEYS */;
INSERT INTO `DOMAINNAME` VALUES (1,'rainsbrook.co.uk'),(2,'rainsbrook.pri'),(3,'andrewstringer.co.uk'),(4,'testdomain'),(5,'ads.rainsbrook.pri'),(6,'nds.rainsbrook.pri');
/*!40000 ALTER TABLE `DOMAINNAME` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FORWARDZONE`
--

DROP TABLE IF EXISTS `FORWARDZONE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FORWARDZONE` (
  `hostname` varchar(254) NOT NULL DEFAULT '',
  `domainsuffix` varchar(254) DEFAULT NULL,
  `description` varchar(254) DEFAULT NULL,
  `username` varchar(20) DEFAULT NULL,
  `team` varchar(20) DEFAULT NULL,
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `recorddata` varchar(40) DEFAULT NULL,
  `recordclass` varchar(2) DEFAULT NULL,
  `recordtype` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`hostname`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FORWARDZONE`
--

LOCK TABLES `FORWARDZONE` WRITE;
/*!40000 ALTER TABLE `FORWARDZONE` DISABLE KEYS */;
INSERT INTO `FORWARDZONE` VALUES ('optiplex','rainsbrook.pri','Optiplex in rack','Andrew','network','2012-09-25 10:21:14','192.168.1.1','IN','A'),('quince','rainsbrook.co.uk','Quince in virtual server','Andrew','server','2012-09-25 10:21:28','192.168.5.21','IN','A'),('spruce','rainsbrook.co.uk','Spruce webserver in attic','Andrew','server','2012-09-25 10:21:24','192.168.5.12','IN','A'),('ipfire','rainsbrook.co.uk','Firewall','Andrew','security','2012-09-25 10:21:33','192.168.1.10','IN','A'),('filer','rainsbrook.pri','filer in rack','andrew','server','2012-09-27 21:34:03','192.168.1.42','IN','A'),('oak','rainsbrook.pri','oak not in rack','andrew','server','2012-09-27 16:07:46','192.168.1.41','IN','A'),('testhost','rainsbrook.pri','test host, this does not exist.','andrew','server','2012-09-27 16:08:16','192.168.1.43','IN','A'),('3750-1','rainsbrook.pri','loft rack','andrew','network','2012-09-27 16:08:25','192.168.1.2','IN','A'),('express500-1','rainsbrook.pri','cisco express 500 in loft rack','andrew','network','2012-09-27 16:24:34','192.168.1.3','IN','A'),('express500-2','rainsbrook.pri','express500 in garage','andrew','network','2012-09-27 21:43:58','192.168.1.4','IN','A'),('3750-2','rainsbrook.pri','3750 in garage','andrew','network','2012-09-27 21:22:27','192.168.1.5','IN','A'),('www','andrewstringer.co.uk','website','andrew','server','2012-10-16 08:34:57','quince.rainsbrook.co.uk.','IN','CNAME'),('test','andrewstringer.co.uk','test','andrew','desktop','2012-10-01 11:08:43','192.168.1.203','IN','A'),('ups2','rainsbrook.pri','UPS2 in garage','andrew','network','2012-10-10 21:41:52','192.168.1.7','IN','A'),('oldserver','rainsbrook.pri','newserver to oldserver','andrew','server','2012-10-16 08:37:21','newserver','IN','CNAME');
/*!40000 ALTER TABLE `FORWARDZONE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MEMBERS`
--

DROP TABLE IF EXISTS `MEMBERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MEMBERS` (
  `username` varchar(20) NOT NULL,
  `memberofteam` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MEMBERS`
--

LOCK TABLES `MEMBERS` WRITE;
/*!40000 ALTER TABLE `MEMBERS` DISABLE KEYS */;
INSERT INTO `MEMBERS` VALUES ('dick','desktop'),('harry','noaccess'),('andrew','network'),('andrew','security'),('andrew','server'),('tom','server'),('tom','desktop');
/*!40000 ALTER TABLE `MEMBERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TEAMMEMBERS`
--

DROP TABLE IF EXISTS `TEAMMEMBERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TEAMMEMBERS` (
  `username` varchar(20) DEFAULT NULL,
  `password` char(25) NOT NULL,
  `fullname` varchar(40) DEFAULT NULL,
  `emailaddress` varchar(40) DEFAULT NULL,
  `memberof` varchar(40) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TEAMMEMBERS`
--

LOCK TABLES `TEAMMEMBERS` WRITE;
/*!40000 ALTER TABLE `TEAMMEMBERS` DISABLE KEYS */;
INSERT INTO `TEAMMEMBERS` VALUES ('andrew','password','Andrew Stringer','andrew@rainsbrook.co.uk','server, network'),('tom','password','Tom Test','[3~tomtest@rainsbrook.notexist.uk','security, network'),('dick','password','Dick Dodgy','dickdodgy@rainsbrook.notexist.uk','desktop, network'),('harry','password','Harry Hopeless','harry.hopeless@rainsbrook.notexist.uk','desktop');
/*!40000 ALTER TABLE `TEAMMEMBERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TEAMS`
--

DROP TABLE IF EXISTS `TEAMS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TEAMS` (
  `team` varchar(20) DEFAULT NULL,
  `displayname` varchar(40) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TEAMS`
--

LOCK TABLES `TEAMS` WRITE;
/*!40000 ALTER TABLE `TEAMS` DISABLE KEYS */;
INSERT INTO `TEAMS` VALUES ('network','Network'),('server','Server'),('desktop','Desktop'),('security','Security');
/*!40000 ALTER TABLE `TEAMS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USERS`
--

DROP TABLE IF EXISTS `USERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USERS` (
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  `fullname` varchar(254) NOT NULL,
  `emailaddress` varchar(254) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USERS`
--

LOCK TABLES `USERS` WRITE;
/*!40000 ALTER TABLE `USERS` DISABLE KEYS */;
INSERT INTO `USERS` VALUES ('andrew','password','Andrew Stringer','andrew@rainsbrook.co.uk'),('tom','password','Tom Test','tomtest@rainsbrook.notexist.co.uk'),('dick','password','Dick Dodgy','DickDodgy@rainsbrook.notexist.co.uk'),('harry','password','Harry Hopeless','Harry.Hopeless@rainsbrook.notexist.co.uk');
/*!40000 ALTER TABLE `USERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ZONEINFO`
--

DROP TABLE IF EXISTS `ZONEINFO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ZONEINFO` (
  `domainsuffix` varchar(254) NOT NULL DEFAULT '',
  `primarymaster` varchar(40) DEFAULT NULL,
  `respperson` varchar(40) DEFAULT NULL,
  `serial` int(11) NOT NULL,
  `refresh` varchar(6) DEFAULT NULL,
  `retry` varchar(6) DEFAULT NULL,
  `expire` varchar(7) DEFAULT NULL,
  `minimttl` varchar(6) DEFAULT NULL,
  `ns1` varchar(20) DEFAULT NULL,
  `ns2` varchar(20) DEFAULT NULL,
  `ns3` varchar(20) DEFAULT NULL,
  `ns4` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`domainsuffix`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ZONEINFO`
--

LOCK TABLES `ZONEINFO` WRITE;
/*!40000 ALTER TABLE `ZONEINFO` DISABLE KEYS */;
/*!40000 ALTER TABLE `ZONEINFO` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-10-27 12:44:45
