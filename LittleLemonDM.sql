-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema little_lemon_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema little_lemon_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `little_lemon_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `little_lemon_db` ;

-- -----------------------------------------------------
-- Table `little_lemon_db`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`customers` (
  `Customer_id` INT NOT NULL,
  `Full_name` VARCHAR(45) NOT NULL,
  `Contact_Number` VARCHAR(255) NULL DEFAULT NULL,
  `Email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Customer_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`employees` (
  `Employee_id` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(255) NOT NULL,
  `Role` VARCHAR(255) NOT NULL,
  `Address` VARCHAR(255) NOT NULL,
  `Contact_Number` VARCHAR(255) NULL DEFAULT NULL,
  `Email` VARCHAR(255) NOT NULL,
  `Annual_Salary` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Employee_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`bookings` (
  `Booking_id` INT NOT NULL,
  `Booking_date` DATETIME NOT NULL,
  `Cutomer_id` INT NOT NULL,
  `Employee_id` INT NOT NULL,
  PRIMARY KEY (`Booking_id`),
  INDEX `Customer_id_idx` (`Cutomer_id` ASC) VISIBLE,
  INDEX `Employee_id_idx` (`Employee_id` ASC) VISIBLE,
  CONSTRAINT `Customer_id`
    FOREIGN KEY (`Cutomer_id`)
    REFERENCES `little_lemon_db`.`customers` (`Customer_id`),
  CONSTRAINT `Employee_id`
    FOREIGN KEY (`Employee_id`)
    REFERENCES `little_lemon_db`.`employees` (`Employee_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`menu_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`menu_items` (
  `Menu_items_id` INT NOT NULL,
  `Course_name` VARCHAR(45) NOT NULL,
  `Starter_name` VARCHAR(45) NOT NULL,
  `Dessert_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Menu_items_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`menus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`menus` (
  `Menu_id` INT NOT NULL,
  `Menu_items_id` INT NOT NULL,
  `Cuisine` VARCHAR(45) NOT NULL,
  `Menu_name` VARCHAR(1024) NOT NULL,
  PRIMARY KEY (`Menu_id`),
  INDEX `Menu_items_id_idx` (`Menu_items_id` ASC) VISIBLE,
  CONSTRAINT `Menu_items_id`
    FOREIGN KEY (`Menu_items_id`)
    REFERENCES `little_lemon_db`.`menu_items` (`Menu_items_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`orders` (
  `Order_id` INT NOT NULL,
  `Menu_id` INT NOT NULL,
  `Customer_id` INT NOT NULL,
  `Cost` INT NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`Order_id`),
  INDEX `Customer_id_idx` (`Customer_id` ASC) VISIBLE,
  INDEX `Menu_id_idx` (`Menu_id` ASC) VISIBLE,
  CONSTRAINT `Customer_id_orders`
    FOREIGN KEY (`Customer_id`)
    REFERENCES `little_lemon_db`.`customers` (`Customer_id`),
  CONSTRAINT `Menu_id`
    FOREIGN KEY (`Menu_id`)
    REFERENCES `little_lemon_db`.`menus` (`Menu_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `little_lemon_db` ;

-- -----------------------------------------------------
-- Placeholder table for view `little_lemon_db`.`ordersview`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `little_lemon_db`.`ordersview` (`Order_id` INT, `quantity` INT, `Cost` INT);

-- -----------------------------------------------------
-- procedure CancelOrder
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelOrder`(IN Order_ID INT)
BEGIN
  IF EXISTS (SELECT 1 FROM Orders WHERE Order_ID = Order_ID) THEN
    DELETE FROM Orders WHERE Order_ID = Order_ID;
    SELECT CONCAT('Confirmation', '\n', 'Order ', Order_ID, ' is cancelled');
  ELSE
    SELECT 'No order with that ID' as confirmation;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetMaxQuantity
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMaxQuantity`()
BEGIN
  SELECT MAX(Quantity) AS MaxQuantity
  FROM Orders;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `little_lemon_db`.`ordersview`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `little_lemon_db`.`ordersview`;
USE `little_lemon_db`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `little_lemon_db`.`ordersview` AS select `little_lemon_db`.`orders`.`Order_id` AS `Order_id`,`little_lemon_db`.`orders`.`quantity` AS `quantity`,`little_lemon_db`.`orders`.`Cost` AS `Cost` from `little_lemon_db`.`orders` where (`little_lemon_db`.`orders`.`quantity` > 2);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
