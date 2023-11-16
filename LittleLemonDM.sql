-- MySQL dump 10.13  Distrib 8.1.0, for Win64 (x86_64)
--
-- Host: localhost    Database: little_lemon_db
-- ------------------------------------------------------
-- Server version	8.1.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookings` (
  `Booking_id` int NOT NULL AUTO_INCREMENT,
  `booking_date` date NOT NULL,
  `customer_id` int DEFAULT NULL,
  `Employee_id` int DEFAULT NULL,
  `table_number` int NOT NULL,
  `booked` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`Booking_id`),
  KEY `Customer_id_idx` (`customer_id`),
  KEY `Employee_id_idx` (`Employee_id`),
  CONSTRAINT `Customer_id` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`Customer_id`),
  CONSTRAINT `Employee_id` FOREIGN KEY (`Employee_id`) REFERENCES `employees` (`Employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
INSERT INTO `bookings` VALUES (1,'2022-10-10',1,1,5,1),(2,'2022-11-12',3,2,3,1),(3,'2022-10-11',2,3,2,1),(4,'2022-10-13',1,2,2,1),(5,'2023-11-10',NULL,NULL,5,1),(6,'2022-11-10',NULL,NULL,5,1),(7,'2023-10-10',NULL,NULL,5,1);
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `Customer_id` int NOT NULL,
  `Full_name` varchar(45) NOT NULL,
  `Contact_Number` varchar(255) DEFAULT NULL,
  `Email` varchar(45) NOT NULL,
  PRIMARY KEY (`Customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,'John Doe','1234567890','john.doe@example.com'),(2,'Jane Doe','9876543210','jane.doe@example.com'),(3,'Peter Smith','987654321','peter.smith@example.com');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `Employee_id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Role` varchar(255) NOT NULL,
  `Address` varchar(255) NOT NULL,
  `Contact_Number` varchar(255) DEFAULT NULL,
  `Email` varchar(255) NOT NULL,
  `Annual_Salary` varchar(255) NOT NULL,
  PRIMARY KEY (`Employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'Alice','Manager','123 Main Street','1234567890','alice@example.com','$100,000'),(2,'Bob','Chef','456 Elm Street','9876543210','bob@example.com','$80,000'),(3,'Carol','Waiter','789 Oak Street','987654321','carol@example.com','$60,000');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menu_items`
--

DROP TABLE IF EXISTS `menu_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menu_items` (
  `Menu_items_id` int NOT NULL,
  `Course_name` varchar(45) NOT NULL,
  `Starter_name` varchar(45) NOT NULL,
  `Dessert_name` varchar(45) NOT NULL,
  PRIMARY KEY (`Menu_items_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menu_items`
--

LOCK TABLES `menu_items` WRITE;
/*!40000 ALTER TABLE `menu_items` DISABLE KEYS */;
INSERT INTO `menu_items` VALUES (1,'Appetizer','Soup','Ice Cream'),(2,'Main Course','Salad','Cake'),(3,'Dessert','Bread','Cookies');
/*!40000 ALTER TABLE `menu_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menus`
--

DROP TABLE IF EXISTS `menus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menus` (
  `Menu_id` int NOT NULL,
  `Menu_items_id` int NOT NULL,
  `Cuisine` varchar(45) NOT NULL,
  `Menu_name` varchar(1024) NOT NULL,
  PRIMARY KEY (`Menu_id`),
  KEY `Menu_items_id_idx` (`Menu_items_id`),
  CONSTRAINT `Menu_items_id` FOREIGN KEY (`Menu_items_id`) REFERENCES `menu_items` (`Menu_items_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menus`
--

LOCK TABLES `menus` WRITE;
/*!40000 ALTER TABLE `menus` DISABLE KEYS */;
INSERT INTO `menus` VALUES (1,1,'Italian','Menu Italian'),(2,2,'American','Menu American'),(3,3,'Dessert','Menu Dessert');
/*!40000 ALTER TABLE `menus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `Order_id` int NOT NULL,
  `Menu_id` int NOT NULL,
  `Customer_id` int NOT NULL,
  `Cost` int NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`Order_id`),
  KEY `Customer_id_idx` (`Customer_id`),
  KEY `Menu_id_idx` (`Menu_id`),
  CONSTRAINT `Customer_id_orders` FOREIGN KEY (`Customer_id`) REFERENCES `customers` (`Customer_id`),
  CONSTRAINT `Menu_id` FOREIGN KEY (`Menu_id`) REFERENCES `menus` (`Menu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,1,40,1),(2,2,2,50,2),(3,3,3,60,3),(4,1,1,70,4),(5,2,2,80,5),(6,3,3,90,6),(7,1,1,100,7),(8,2,2,90,8),(9,3,3,80,9),(10,1,1,70,10);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `ordersview`
--

DROP TABLE IF EXISTS `ordersview`;
/*!50001 DROP VIEW IF EXISTS `ordersview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `ordersview` AS SELECT 
 1 AS `Order_id`,
 1 AS `quantity`,
 1 AS `Cost`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `ordersview`
--

/*!50001 DROP VIEW IF EXISTS `ordersview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ordersview` AS select `orders`.`Order_id` AS `Order_id`,`orders`.`quantity` AS `quantity`,`orders`.`Cost` AS `Cost` from `orders` where (`orders`.`quantity` > 2) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-16 19:00:54
