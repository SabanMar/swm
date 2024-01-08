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
(1,10,'Frame 1 (1).png'),
(2,15,'assets/images/avatars/Frame 1 (2).png');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `session_files`
--

LOCK TABLES `session_files` WRITE;
/*!40000 ALTER TABLE `session_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `session_files` ENABLE KEYS */;
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
  `longitude` double DEFAULT NULL,
  `latitude` double DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES
(6,19,22,NULL,NULL,NULL,'Maths','Zografou','2023-12-20 08:30:00','2023-12-20 10:00:00',2,2,NULL,NULL),
(8,15,17,18,NULL,NULL,'Phycology','vivianospito','2023-12-30 12:00:00','2023-12-30 15:00:00',3,3,NULL,NULL),
(10,17,NULL,NULL,NULL,NULL,'Maths','Sabanospito','2024-01-03 20:00:00','2024-01-03 23:00:00',3,1,NULL,NULL),
(11,18,18,NULL,NULL,NULL,'history','koukaki','2024-01-06 16:00:00','2024-01-05 19:00:00',3,2,NULL,NULL);
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
  `avatar` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_username` (`username`),
  UNIQUE KEY `unique_password` (`password`),
  UNIQUE KEY `unique_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(11,'dimitra','1','NTUA','dgini@ehotmail.com','marianthi','metaxaki','6934567890',0,NULL,NULL),
(12,'maria','234','NTUA','sabmar@ehotmail.com','maria','sabani','6934567890',0,NULL,NULL),
(14,'thoubi','333','NTUA','mar@ehotmail.com','marianthi','metaxaki','6988092861',0,NULL,NULL),
(15,'vivian','111','NTUA','viviaan@ehotmail.com','Vivian','Thanou','6988092863',0,NULL,NULL),
(16,'valia','678','NTUA','salia@ehotmail.com','Valia','Samara','6988052863',0,NULL,NULL),
(17,'petros','000','Aristotelio','petrospil@ehotmail.com','Petros','Piliouris','6988052425',0,NULL,NULL),
(18,'eleni','999','UPEC','elenisabani@ehotmail.com','Helen','Sabani','6983672097',0,'Just a girl who loves nature and hanging out with friends',2),
(19,'valaki','000000','NTUA','valia@gmail.com','Valia','Samara','3245678',0,NULL,NULL),
(22,'jo','8989','Harvard','jo@gmail.com','Jo','Goldberg','9834562789',0,NULL,NULL),
(24,'mar','444','AUTH','Mary@gmail.com','mary','mary','6987145267',0,NULL,NULL),
(29,'valiaaaa','3','NTUA','valia@mail.ntua.gr','Euaggelia','Samaara','9876543856',0,NULL,NULL);
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

-- Dump completed on 2024-01-07 15:58:49
