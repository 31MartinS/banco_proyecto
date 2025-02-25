CREATE DATABASE  IF NOT EXISTS `banco` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `banco`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: banco
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cards`
--

DROP TABLE IF EXISTS `cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cards` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `card_number` varchar(16) NOT NULL,
  `expiry_date` date NOT NULL,
  `cardholder_name` varchar(255) NOT NULL,
  `is_frozen` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_cards_user` (`user_id`),
  CONSTRAINT `fk_cards_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cards`
--

LOCK TABLES `cards` WRITE;
/*!40000 ALTER TABLE `cards` DISABLE KEYS */;
INSERT INTO `cards` VALUES (2,5,'4111111111111111','2030-05-15','Camila Escobar',1,'2025-02-16 19:26:15'),(3,5,'5500000000000004','2028-10-31','Camila Escobar',0,'2025-02-16 20:36:05'),(4,5,'4012888888881881','2029-01-20','Camila Escobar',0,'2025-02-16 20:36:55'),(6,2,'1234567812345678','2025-12-31','Camila Escobar',0,'2025-02-23 20:54:55'),(7,7,'1234567812345678','2025-12-31','Juan Perez',0,'2025-02-23 21:04:05'),(8,7,'1234567812345678','2025-12-31','Juan Perez',0,'2025-02-23 21:44:08'),(9,7,'1234567812345678','2025-12-31','Juan Perez',0,'2025-02-23 21:47:42');
/*!40000 ALTER TABLE `cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `message` text NOT NULL,
  `notification_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_read` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_notifications_user` (`user_id`),
  CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,5,'Pago de $5 realizado.','2025-02-16 19:56:59',0),(2,5,'Pago de $6 realizado.','2025-02-16 20:27:33',0),(3,5,'Pago de $25 realizado.','2025-02-16 20:39:43',0),(4,5,'Pago de $4 realizado.','2025-02-16 20:39:55',0),(5,5,'Pago de $25 realizado.','2025-02-16 20:53:44',0),(6,5,'Pago de $25 realizado.','2025-02-23 19:42:37',0),(7,5,'Pago de $250 realizado.','2025-02-23 19:43:06',0),(8,5,'Pago de $45 realizado.','2025-02-23 19:50:37',0),(9,5,'Pago de $26 realizado.','2025-02-23 20:03:30',0),(10,5,'Pago de $250 realizado.','2025-02-23 20:08:34',0),(11,5,'Pago de $100.5 realizado.','2025-02-23 21:44:08',0),(12,5,'Pago de $100.5 realizado.','2025-02-23 21:47:42',0);
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `card_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('pending','completed','failed') DEFAULT 'pending',
  PRIMARY KEY (`id`),
  KEY `fk_payments_user` (`user_id`),
  KEY `fk_payments_card` (`card_id`),
  CONSTRAINT `fk_payments_card` FOREIGN KEY (`card_id`) REFERENCES `cards` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_payments_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,5,2,5.00,'2025-02-16 19:56:59','completed'),(2,5,2,6.00,'2025-02-16 20:27:33','completed'),(3,5,2,25.00,'2025-02-16 20:39:43','completed'),(4,5,4,4.00,'2025-02-16 20:39:55','completed'),(5,5,2,25.00,'2025-02-16 20:53:44','completed'),(6,5,4,450.00,'2025-02-23 19:21:55','completed'),(7,5,3,450.00,'2025-02-23 19:22:21','completed'),(8,5,4,25.00,'2025-02-23 19:22:46','completed'),(9,5,4,2.00,'2025-02-23 19:24:01','completed'),(10,5,4,200.00,'2025-02-23 19:29:30','completed'),(11,5,2,25.00,'2025-02-23 19:32:18','completed'),(12,5,2,250.00,'2025-02-23 19:33:42','completed'),(13,5,2,250.00,'2025-02-23 19:37:09','completed'),(14,5,2,25.00,'2025-02-23 19:38:29','completed'),(15,5,2,25.00,'2025-02-23 19:39:15','completed'),(16,5,2,25.00,'2025-02-23 19:39:51','completed'),(17,5,2,25.00,'2025-02-23 19:40:45','completed'),(18,5,2,25.00,'2025-02-23 19:41:15','completed'),(19,5,2,25.00,'2025-02-23 19:41:39','completed'),(20,5,2,25.00,'2025-02-23 19:42:37','completed'),(21,5,2,250.00,'2025-02-23 19:43:06','completed'),(22,5,2,45.00,'2025-02-23 19:50:37','completed'),(23,5,2,26.00,'2025-02-23 20:03:30','completed'),(24,5,2,250.00,'2025-02-23 20:08:34','completed'),(25,5,2,100.50,'2025-02-23 21:44:08','completed'),(26,5,2,100.50,'2025-02-23 21:47:42','completed');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `payment_id` int NOT NULL,
  `transaction_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `details` text,
  `amount` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_transactions_payment` (`payment_id`),
  CONSTRAINT `fk_transactions_payment` FOREIGN KEY (`payment_id`) REFERENCES `payments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (1,1,'2025-02-16 19:56:59','Pago realizado',5.00),(2,2,'2025-02-16 20:27:33','Pago realizado',6.00),(3,3,'2025-02-16 20:39:43','Pago realizado',25.00),(4,4,'2025-02-16 20:39:55','Pago realizado',4.00),(5,5,'2025-02-16 20:53:44','Pago realizado',25.00),(6,13,'2025-02-23 19:37:09','Pago realizado',250.00),(7,14,'2025-02-23 19:38:29','Pago realizado',25.00),(8,15,'2025-02-23 19:39:15','Pago realizado',25.00),(9,16,'2025-02-23 19:39:51','Pago realizado',25.00),(10,17,'2025-02-23 19:40:45','Pago realizado',25.00),(11,19,'2025-02-23 19:41:39','Pago realizado',25.00),(12,20,'2025-02-23 19:42:37','Pago realizado',25.00),(13,21,'2025-02-23 19:43:06','Pago realizado',250.00),(14,22,'2025-02-23 19:50:37','Pago realizado',45.00),(15,23,'2025-02-23 20:03:30','Pago realizado',26.00),(16,24,'2025-02-23 20:08:34','Pago realizado',250.00),(17,25,'2025-02-23 21:44:08','Pago realizado',100.50),(18,26,'2025-02-23 21:47:42','Pago realizado',100.50);
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `balance` decimal(10,2) DEFAULT '0.00',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Ayme','ayme@gmail.com.com','12345',0.00,'2025-02-16 18:23:25'),(2,'Gerald','gerald@gmail.com','12345',0.00,'2025-02-16 19:05:04'),(3,'Gerald','geralds@gmail.com','12345',0.00,'2025-02-16 19:06:42'),(4,'camila','camila@gmail.com','12345',0.00,'2025-02-16 19:11:23'),(5,'camila','camilas@gmail.com','123456',5000.00,'2025-02-16 19:13:44'),(6,'Ayme','ayme@gmail.com','123456',0.00,'2025-02-16 20:05:59'),(7,'Luis','luis@gmail.com','123456',0.00,'2025-02-20 12:26:33'),(9,'Usuario Test','pruebas@gmail.com','123456',0.00,'2025-02-23 20:27:22'),(10,'Usuario Test','pruebas2@gmail.com','123456',0.00,'2025-02-23 20:28:47'),(11,'Usuario Test','pruebas3@gmail.com','123456',0.00,'2025-02-23 20:29:13'),(12,'rigorbert','rigoberts@gmail.com','123456',0.00,'2025-02-23 20:30:34'),(13,'silvana','silvanas@gmail.com','123456',0.00,'2025-02-23 20:33:06');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-23 22:07:56
