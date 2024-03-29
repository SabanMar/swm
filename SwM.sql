-- MariaDB dump 10.19-11.1.2-MariaDB, for osx10.18 (arm64)
--
-- Host: localhost    Database: swm
-- ------------------------------------------------------
-- Server version	11.1.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `avatar`
--

DROP TABLE IF EXISTS `avatar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `avatar` (
  `id` int(11) NOT NULL,
  `cost` int(11) NOT NULL,
  `file_name` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `avatar`
--

LOCK TABLES `avatar` WRITE;
/*!40000 ALTER TABLE `avatar` DISABLE KEYS */;
INSERT INTO `avatar` VALUES
(1,10,'assets/images/avatars/Frame 1.png'),
(2,15,'assets/images/avatars/Frame 1 (1).png'),
(3,25,'assets/images/avatars/Frame 1 (2).png'),
(4,30,'assets/images/avatars/Frame 1 (3).png'),
(5,30,'assets/images/avatars/Frame 1 (4).png'),
(6,35,'assets/images/avatars/Frame 1 (5).png'),
(7,40,'assets/images/avatars/Frame 1 (6).png'),
(8,45,'assets/images/avatars/Frame 1 (7).png'),
(9,50,'assets/images/avatars/Frame 1 (8).png'),
(10,55,'assets/images/avatars/Frame 1 (9).png'),
(11,60,'assets/images/avatars/Frame 1 (10).png'),
(12,65,'assets/images/avatars/Frame 1 (11).png'),
(13,70,'assets/images/avatars/Frame 1 (12).png'),
(14,75,'assets/images/avatars/Frame 1 (13).png'),
(15,80,'assets/images/avatars/Frame 1 (14).png'),
(16,85,'assets/images/avatars/Frame 1 (15).png'),
(17,90,'assets/images/avatars/Frame 1 (16).png'),
(18,95,'assets/images/avatars/Frame 1 (17).png'),
(19,100,'assets/images/avatars/Frame 1 (18).png'),
(20,105,'assets/images/avatars/Frame 1 (19).png'),
(21,110,'assets/images/avatars/Frame 1 (20).png'),
(22,115,'assets/images/avatars/Frame 1 (21).png'),
(23,120,'assets/images/avatars/Frame 1 (22).png'),
(24,125,'assets/images/avatars/Frame 1 (23).png'),
(25,130,'assets/images/avatars/Frame 1 (24).png'),
(26,135,'assets/images/avatars/Frame 1 (25).png'),
(27,140,'assets/images/avatars/Frame 1 (26).png'),
(28,145,'assets/images/avatars/Frame 1 (27).png'),
(29,150,'assets/images/avatars/Frame 1 (28).png'),
(30,155,'assets/images/avatars/Frame 1 (29).png'),
(31,160,'assets/images/avatars/Frame 1 (30).png'),
(32,165,'assets/images/avatars/Frame 1 (31).png'),
(33,170,'assets/images/avatars/Frame 1 (32).png'),
(34,175,'assets/images/avatars/Frame 1 (33).png'),
(35,180,'assets/images/avatars/Frame 1 (34).png'),
(36,185,'assets/images/avatars/Frame 1 (35).png'),
(37,190,'assets/images/avatars/Frame 1 (36).png'),
(38,195,'assets/images/avatars/Frame 1 (37).png'),
(39,200,'assets/images/avatars/Frame 1 (38).png'),
(40,205,'assets/images/avatars/Frame 1 (39).png'),
(41,210,'assets/images/avatars/Frame 1 (40).png');
/*!40000 ALTER TABLE `avatar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session_files`
--

DROP TABLE IF EXISTS `session_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session_files` (
  `file_id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` int(11) NOT NULL,
  `file_name` text DEFAULT 'file',
  PRIMARY KEY (`file_id`),
  KEY `session_files_fk` (`session_id`),
  CONSTRAINT `session_files_fk` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_files`
--

LOCK TABLES `session_files` WRITE;
/*!40000 ALTER TABLE `session_files` DISABLE KEYS */;
INSERT INTO `session_files` VALUES
(9,6,'file_6_18_1'),
(10,6,'file_6_18_2'),
(11,6,'file_6_18_3'),
(12,13,'file_13_18_1'),
(13,13,'file_13_18_2'),
(14,13,'file_13_18_3'),
(15,13,'file_13_18_4.txt'),
(16,10,'file_10_17_1'),
(17,13,'file_13_17_5'),
(18,12,'file_12_17_1.txt'),
(19,12,'file_12_17_2.txt'),
(20,12,'file_12_17_3.txt'),
(21,11,'file_11_18_1.txt'),
(22,12,'file_12_18_4'),
(23,10,'file_10_18_2'),
(24,6,'file_6_18_4'),
(25,13,'file_13_17_6'),
(26,21,'file_21_18_1'),
(27,21,'file_21_18_2'),
(28,34,'file_34_17_1'),
(29,34,'file_34_18_2');
/*!40000 ALTER TABLE `session_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `session_images`
--

DROP TABLE IF EXISTS `session_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `session_images` (
  `image_id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` int(11) NOT NULL,
  `photo` mediumblob DEFAULT NULL,
  PRIMARY KEY (`image_id`),
  KEY `session_images_fk` (`session_id`),
  CONSTRAINT `session_images_fk` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_images`
--

LOCK TABLES `session_images` WRITE;
/*!40000 ALTER TABLE `session_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `session_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `host_id` int(11) NOT NULL,
  `member1_id` int(11) DEFAULT NULL,
  `member2_id` int(11) DEFAULT NULL,
  `member3_id` int(11) DEFAULT NULL,
  `member4_id` int(11) DEFAULT NULL,
  `subject` text NOT NULL,
  `location` text NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `max_members` int(11) NOT NULL DEFAULT 5,
  `current_members` int(11) NOT NULL DEFAULT 1,
  `has_started` tinyint(4) DEFAULT 0,
  `coins` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `host_idfk` (`host_id`),
  KEY `member1_idfk` (`member1_id`),
  KEY `member2_idfk` (`member2_id`),
  KEY `member3_idfk` (`member3_id`),
  KEY `member4_idfk` (`member4_id`),
  CONSTRAINT `host_idfk` FOREIGN KEY (`host_id`) REFERENCES `users` (`id`),
  CONSTRAINT `member1_idfk` FOREIGN KEY (`member1_id`) REFERENCES `users` (`id`),
  CONSTRAINT `member2_idfk` FOREIGN KEY (`member2_id`) REFERENCES `users` (`id`),
  CONSTRAINT `member3_idfk` FOREIGN KEY (`member3_id`) REFERENCES `users` (`id`),
  CONSTRAINT `member4_idfk` FOREIGN KEY (`member4_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES
(6,19,22,NULL,NULL,NULL,'Mathematics','Zografou','2023-12-20 08:30:00','2023-12-20 10:00:00',2,2,0,0),
(8,15,17,18,NULL,NULL,'Programming','vivianospito','2023-12-30 12:00:00','2023-12-30 15:00:00',3,3,0,0),
(10,17,NULL,NULL,NULL,NULL,'Mathematics','Sabanospito','2024-01-03 20:00:00','2024-01-03 23:00:00',3,1,0,0),
(11,18,17,NULL,NULL,NULL,'history','koukaki','2024-01-06 16:00:00','2024-01-05 19:00:00',3,2,0,0),
(12,17,NULL,NULL,NULL,NULL,'physics','here','2024-01-11 12:00:00','2024-01-11 16:00:00',3,1,0,0),
(13,17,11,NULL,NULL,NULL,'Mathematics','Library','2024-01-10 12:00:00','2024-01-11 03:00:00',4,2,0,0),
(14,18,NULL,NULL,NULL,NULL,'history','Paris','2024-01-13 18:00:00','2024-01-13 22:00:00',3,1,0,0),
(15,11,NULL,NULL,NULL,NULL,'Physics','Barcelona','2024-01-11 13:50:00','2024-01-24 18:50:00',5,1,0,0),
(16,11,NULL,NULL,NULL,NULL,'Programming','Halandri','2024-01-11 18:00:00','2024-01-11 21:00:00',5,1,0,0),
(17,19,NULL,NULL,NULL,NULL,'Maths','Zografou','2023-12-20 08:30:00','2023-12-20 10:00:00',1,1,0,0),
(18,17,NULL,NULL,NULL,NULL,'Biology','Library ','2024-01-15 16:18:00','2024-01-15 18:18:00',4,1,0,0),
(19,17,NULL,NULL,NULL,NULL,'Electonics','marianthospito','2024-01-16 00:30:00','2024-01-16 15:30:00',2,1,0,0),
(20,18,NULL,NULL,NULL,NULL,'Physics','sabanospito','2024-01-15 21:00:00','2024-01-15 23:30:00',5,1,0,0),
(21,18,17,NULL,NULL,NULL,'History','koukaki','2024-01-17 18:30:00','2024-01-17 21:00:00',2,2,0,0),
(22,18,NULL,NULL,NULL,NULL,'Programming','1w2erf','2024-01-15 18:35:00','2024-01-15 14:35:00',3,1,0,0),
(23,17,11,NULL,NULL,NULL,'Physics','bibliotech','2024-01-16 21:00:00','2024-01-16 23:55:00',4,2,0,0),
(24,18,NULL,NULL,NULL,NULL,'Programming','NTUA','2024-01-18 16:29:00','2024-01-18 20:00:00',3,1,0,0),
(25,17,NULL,NULL,NULL,NULL,'Literature','Library','2024-01-16 17:57:00','2024-01-16 21:00:00',3,1,0,0),
(26,17,NULL,NULL,NULL,NULL,'Electonics','house','2024-01-17 21:00:00','2024-01-17 23:30:00',5,1,0,0),
(27,17,NULL,NULL,NULL,NULL,'Chemistry','Thiva','2024-01-16 18:30:00','2024-01-16 21:30:00',4,1,0,0),
(28,17,NULL,NULL,NULL,NULL,'History','Library NTUA','2024-01-16 19:18:00','2024-01-16 21:18:00',4,1,0,0),
(29,17,NULL,NULL,NULL,NULL,'Literature','here','2024-01-17 00:09:00','2024-01-17 06:09:00',3,1,0,0),
(30,37,NULL,NULL,NULL,NULL,'Chemistry','Metamorfosi','2024-01-18 09:00:00','2024-01-18 17:00:00',5,1,0,0),
(31,37,18,NULL,NULL,NULL,'Literature','Athens','2024-01-19 00:33:00','2024-01-19 06:33:00',2,2,0,10),
(32,18,NULL,NULL,NULL,NULL,'Programming','gvhbd','2024-01-17 19:18:00','2024-01-17 22:18:00',3,1,0,10),
(33,17,NULL,NULL,NULL,NULL,'History','xirospito','2024-01-17 21:26:00','2024-01-17 12:26:00',3,1,0,10),
(34,17,18,NULL,NULL,NULL,'Electonics','exarcheia','2024-01-18 21:41:00','2024-01-18 12:41:00',5,3,0,10),
(35,17,NULL,NULL,NULL,NULL,'Chemistry','pagrati','2024-01-17 21:51:00','2024-01-17 12:53:00',4,1,0,40),
(36,18,17,NULL,NULL,NULL,'Literature','metaxoyrgeio','2024-01-19 14:00:00','2024-01-19 17:00:00',2,2,0,5),
(37,18,NULL,NULL,NULL,NULL,'Biology','Panteion University','2024-01-18 12:00:00','2024-01-21 18:00:00',3,1,0,0),
(38,18,NULL,NULL,NULL,NULL,'History','Panteion University','2024-01-18 18:34:00','2024-01-18 22:34:00',3,1,0,0),
(39,18,NULL,NULL,NULL,NULL,'Biology','Panteion University','2024-01-18 12:00:00','2024-01-21 18:00:00',3,1,0,0),
(40,17,NULL,NULL,NULL,NULL,'Physics','Thessaloniki','2024-01-19 14:30:00','2024-01-19 18:30:00',3,1,0,0),
(41,17,NULL,NULL,NULL,NULL,'Physics','koukaki','2024-01-19 15:18:00','2024-01-19 20:18:00',3,1,0,0),
(42,18,40,11,17,NULL,'Biology','Library NTUA','2024-01-20 15:34:00','2024-01-20 19:34:00',4,4,0,0),
(43,18,NULL,NULL,NULL,NULL,'Literature','Exarcheia','2024-01-21 18:17:00','2024-01-22 21:17:00',2,1,0,0),
(44,11,NULL,NULL,NULL,NULL,'History','exarcheia','2024-01-22 21:21:00','2024-01-22 23:21:00',3,1,0,0),
(45,11,NULL,NULL,NULL,NULL,'Programming','zografou','2024-01-22 12:00:00','2024-01-22 15:00:00',3,1,0,0),
(46,18,NULL,NULL,NULL,NULL,'Literature','metaxourgeio','2024-01-23 06:49:00','2024-01-23 08:49:00',3,1,0,0),
(47,18,NULL,NULL,NULL,NULL,'History','Starbucks ilisia','2024-01-22 11:00:00','2024-01-22 15:50:00',2,1,0,0),
(48,18,NULL,NULL,NULL,NULL,'Chemistry','thiva','2024-01-22 19:11:00','2024-01-22 23:11:00',2,1,0,0);
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `university` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `coins` int(11) DEFAULT 0,
  `bio` text DEFAULT NULL,
  `avatar` int(11) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_username` (`username`),
  UNIQUE KEY `unique_password` (`password`),
  UNIQUE KEY `unique_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(11,'dimitra','1','NTUA','dgini@ehotmail.com','marianthi','metaxaki','6934567890',45,NULL,2),
(12,'maria','234','NTUA','sabmar@ehotmail.com','maria','sabani','6934567890',60,NULL,1),
(14,'thoubi','333','NTUA','mar@ehotmail.com','marianthi','metaxaki','6988092861',60,NULL,1),
(15,'vivian','111','NTUA','viviaan@ehotmail.com','Vivian','Thanou','6988092863',60,NULL,1),
(16,'valia','678','NTUA','salia@ehotmail.com','Valia','Samara','6988052863',60,NULL,1),
(17,'petros','0000','Aristotelio','petrospil@ehotmail.com','Petros','Piliouris','6988052425',95,NULL,12),
(18,'eleni','999','UPEC','elenisabani@ehotmail.com','Helen','Sabani','6983672097',139,'Just a girl who loves nature and hanging out with friends',10),
(19,'valaki','000000','NTUA','valia@gmail.com','Valia','Samara','3245678',60,NULL,1),
(22,'jo','8989','Harvard','jo@gmail.com','Jo','Goldberg','9834562789',60,NULL,1),
(24,'mar','444','AUTH','Mary@gmail.com','mary','mary','6987145267',60,NULL,1),
(29,'valiaaaa','3','NTUA','valia@mail.ntua.gr','Euaggelia','Samaara','9876543856',60,NULL,1),
(32,'Kostaras','20011008','NTUA','kapoutsinos.psa@gmail.com','Kostas','Psarras','6970638096',60,'I love H3',1),
(33,'antonis','1256','2o Lykeio Thivas','sampanis.agro@yahoo.gr','Antonis','Sampanis','6976790422',60,NULL,1),
(34,'vaggelio','101','1o gel Thivas','vaggelio@gmail.com','Evangelina','Paagopoulou','6972692113',60,NULL,2),
(36,'nontis','12345678','M','ep@gmail.com','nontas','','6977482129',60,NULL,1),
(37,'niki','niki','UOPA','noukou@gmail.com','Niki','Theod','6980924567',30,NULL,1),
(40,'mariaa','5','NTUA','sabanhmaria@gmail.com','Maria','Sabani','6988092962',0,NULL,1);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_avatars`
--

DROP TABLE IF EXISTS `users_avatars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users_avatars` (
  `user_id` int(11) NOT NULL,
  `avatar_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`avatar_id`),
  KEY `avatar_id` (`avatar_id`),
  CONSTRAINT `users_avatars_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `users_avatars_ibfk_2` FOREIGN KEY (`avatar_id`) REFERENCES `avatar` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_avatars`
--

LOCK TABLES `users_avatars` WRITE;
/*!40000 ALTER TABLE `users_avatars` DISABLE KEYS */;
INSERT INTO `users_avatars` VALUES
(12,1),
(14,1),
(15,1),
(16,1),
(17,1),
(18,1),
(19,1),
(22,1),
(24,1),
(29,1),
(32,1),
(33,1),
(34,1),
(11,2),
(17,2),
(18,2),
(18,3),
(18,4),
(17,5),
(17,6),
(18,6),
(18,7),
(17,8),
(18,10),
(17,12);
/*!40000 ALTER TABLE `users_avatars` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-01-21 19:31:54
