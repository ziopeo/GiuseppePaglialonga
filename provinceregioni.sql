# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.5.42)
# Database: carling
# Generation Time: 2018-12-08 11:34:21 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table province
# ------------------------------------------------------------

DROP TABLE IF EXISTS `province`;

CREATE TABLE `province` (
  `id_provincia` int(4) NOT NULL AUTO_INCREMENT,
  `nome_provincia` varchar(20) NOT NULL DEFAULT '',
  `id_regione` int(4) NOT NULL DEFAULT '0',
  `sigla_provincia` char(2) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_provincia`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `province` WRITE;
/*!40000 ALTER TABLE `province` DISABLE KEYS */;

INSERT INTO `province` (`id_provincia`, `nome_provincia`, `id_regione`, `sigla_provincia`)
VALUES
	(1,'Ancona',1,'AN'),
	(2,'Macerata',1,'MC'),
	(3,'Pesaro Urbino',1,'PU'),
	(4,'Ascoli Piceno',1,'AP'),
	(5,'Alessandria',13,'AL'),
	(6,'Asti',13,'AT'),
	(7,'Biella',13,'BI'),
	(8,'Cuneo',13,'CN'),
	(9,'Novara',13,'NO'),
	(10,'Vercelli',13,'VC'),
	(11,'Torino',13,'TO'),
	(12,'Agrigento',11,'AG'),
	(13,'Caltanissetta',11,'CL'),
	(14,'Catania',11,'CT'),
	(15,'Enna',11,'EN'),
	(16,'Messina',11,'ME'),
	(17,'Palermo',11,'PA'),
	(18,'Ragusa',11,'RG'),
	(19,'Siracusa',11,'SR'),
	(20,'Trapani',11,'TP'),
	(21,'Catanzaro',7,'CZ'),
	(22,'Cosenza',7,'CS'),
	(23,'Crotone',7,'KR'),
	(24,'Reggio Calabria',7,'RC'),
	(25,'Vibo Valentia',7,'VV'),
	(27,'Matera',3,'MT'),
	(28,'Potenza',3,'PZ'),
	(29,'Bari',6,'BA'),
	(30,'Brindisi',6,'BR'),
	(31,'Foggia',6,'FG'),
	(32,'Lecce',6,'LE'),
	(33,'Taranto',6,'TA'),
	(34,'Avellino',8,'AV'),
	(35,'Benevento',8,'BN'),
	(36,'Caserta',8,'CE'),
	(37,'Napoli',8,'NA'),
	(38,'Salerno',8,'SA'),
	(39,'Frosinone',9,'FR'),
	(40,'Latina',9,'LT'),
	(41,'Rieti',9,'RI'),
	(42,'Roma',9,'RM'),
	(43,'Viterbo',9,'VT'),
	(44,'Chieti',2,'CH'),
	(45,'L\'Aquila',2,'AQ'),
	(46,'Pescara',2,'PE'),
	(47,'Teramo',2,'TE'),
	(48,'Arezzo',12,'AR'),
	(49,'Firenze',12,'FI'),
	(50,'Grosseto',12,'GR'),
	(51,'Livorno',12,'LI'),
	(52,'Lucca',12,'LU'),
	(53,'Massa Carrara',12,'MS'),
	(54,'Pisa',12,'PI'),
	(55,'Pistoia',12,'PT'),
	(56,'Siena',12,'SI'),
	(57,'Bologna',14,'BO'),
	(58,'Ferrara',14,'FE'),
	(59,'Forl? Cesena',14,'FC'),
	(60,'Modena',14,'MO'),
	(61,'Parma',14,'PR'),
	(62,'Piacenza',14,'PC'),
	(63,'Ravenna',14,'RA'),
	(64,'Reggio Emilia',14,'RE'),
	(65,'Rimini',14,'RN'),
	(66,'Belluno',17,'BL'),
	(67,'Padova',17,'PD'),
	(68,'Rovigo',17,'RO'),
	(69,'Treviso',17,'TV'),
	(70,'Venezia',17,'VE'),
	(71,'Verona',17,'VR'),
	(72,'Vicenza',17,'VI'),
	(73,'Gorizia',15,'GO'),
	(74,'Pordenone',15,'PN'),
	(75,'Udine',15,'UD'),
	(76,'Trieste',15,'TS'),
	(77,'Aosta',16,'AO'),
	(78,'Cagliari',10,'CA'),
	(79,'Nuoro',10,'NU'),
	(80,'Oristano',10,'OR'),
	(81,'Sassari',10,'SS'),
	(82,'Genova',18,'GE'),
	(83,'Imperia',18,'IM'),
	(84,'Savona',18,'SV'),
	(85,'La Spezia',18,'SP'),
	(86,'Isernia',4,'IS'),
	(87,'Campobasso',4,'CB'),
	(88,'Perugia',20,'PG'),
	(89,'Terni',20,'TR'),
	(90,'Bergamo',19,'BG'),
	(91,'Brescia',19,'BS'),
	(92,'Como',19,'CO'),
	(93,'Cremona',19,'CR'),
	(94,'Lecco',19,'LC'),
	(95,'Lodi',19,'LO'),
	(96,'Mantova',19,'MN'),
	(97,'Milano',19,'MI'),
	(98,'Pavia',19,'PV'),
	(99,'Sondrio',19,'SO'),
	(100,'Varese',19,'VA'),
	(101,'Trento',5,'TN'),
	(102,'Bolzano',5,'BZ'),
	(103,'Prato',12,'PO'),
	(104,'Verbania',13,'VB'),
	(105,'Carbonia Iglesias',10,'CI'),
	(106,'Medio Campidano',10,'VS'),
	(107,'Ogliastra',10,'OG'),
	(108,'Olbia Tempio',10,'OT');

/*!40000 ALTER TABLE `province` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table regioni
# ------------------------------------------------------------

DROP TABLE IF EXISTS `regioni`;

CREATE TABLE `regioni` (
  `id_regione` int(4) NOT NULL AUTO_INCREMENT,
  `nome_regione` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_regione`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `regioni` WRITE;
/*!40000 ALTER TABLE `regioni` DISABLE KEYS */;

INSERT INTO `regioni` (`id_regione`, `nome_regione`)
VALUES
	(1,'Marche'),
	(2,'Abruzzo'),
	(3,'Basilicata'),
	(4,'Molise'),
	(5,'Trentino Alto Adige'),
	(6,'Puglia'),
	(7,'Calabria'),
	(8,'Campania'),
	(9,'Lazio'),
	(10,'Sardegna'),
	(11,'Sicilia'),
	(12,'Toscana'),
	(13,'Piemonte'),
	(14,'Emilia Romagna'),
	(15,'Friuli Venezia Giulia'),
	(16,'Valle d\'Aosta'),
	(17,'Veneto'),
	(18,'Liguria'),
	(19,'Lombardia'),
	(20,'Umbria');

/*!40000 ALTER TABLE `regioni` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
