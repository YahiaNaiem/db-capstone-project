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
  `booking_date` DATE NOT NULL,
  `customer_id` INT NULL DEFAULT NULL,
  `Employee_id` INT NULL DEFAULT NULL,
  `table_number` INT NOT NULL,
  PRIMARY KEY (`Booking_id`),
  INDEX `Customer_id_idx` (`customer_id` ASC) VISIBLE,
  INDEX `Employee_id_idx` (`Employee_id` ASC) VISIBLE,
  CONSTRAINT `Customer_id`
    FOREIGN KEY (`customer_id`)
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
-- procedure AddBooking
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddBooking`(
  IN booking_id INT,
  IN customer_id INT,
  IN booking_date DATE,
  IN employee_id INT,
  IN table_number INT
)
BEGIN
  INSERT INTO Bookings (BookingId, CustomerId, BookingDate, EmployeeId, TableNumber) VALUES (booking_id, customer_id, booking_date, employee_id, table_number);
  select 'new booking added' as confirmation;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AddValidBooking
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddValidBooking`(IN booking_date DATE, IN table_number INT)
BEGIN
    DECLARE booked BOOLEAN;

    START TRANSACTION;
    
    SELECT CASE WHEN EXISTS (
        SELECT 1
        FROM Bookings
        WHERE DATE(Booking_Date) = DATE(booking_date) AND Table_Number = table_number
    ) THEN TRUE ELSE FALSE END INTO booked;


    IF booked THEN
        ROLLBACK;
        SELECT CONCAT("table ", table_number, " is booked - booking canceled") AS booking_status;
    ELSE
        SELECT CONCAT("table ", table_number, " is free - booked successfully") AS booking_status;
        INSERT INTO Bookings (booking_id, Booking_Date, Table_Number) VALUES (5, booking_date, table_number);
        COMMIT;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CancelBooking
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelBooking`(
  IN booking_id INT
)
BEGIN
  DELETE FROM Bookings WHERE Booking_Id = booking_id;
END$$

DELIMITER ;

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
-- procedure CheckBooking
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckBooking`(IN booking_date DATE, IN table_number INT)
BEGIN
  DECLARE is_booked BOOLEAN;

  SELECT CASE WHEN EXISTS (SELECT 1 FROM Bookings WHERE Booking_Date = booking_date AND Table_Number = table_number) THEN TRUE ELSE FALSE END into is_booked;

  IF is_booked THEN
    SELECT concat('Table ', table_number, ' is booked') as booking_status;
  ELSE
    SELECT concat('Table ', table_number, ' is not available') as booking_status;
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
-- procedure UpdateBooking
-- -----------------------------------------------------

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBooking`(
IN booking_id INT,
IN booking_date DATE
)
BEGIN
  UPDATE Bookings SET BookingDate = booking_date WHERE BookingId = booking_id;
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
