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
DROP SCHEMA IF EXISTS `little_lemon_db` ;

-- -----------------------------------------------------
-- Schema little_lemon_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `little_lemon_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `little_lemon_db` ;

-- -----------------------------------------------------
-- Table `little_lemon_db`.`customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `little_lemon_db`.`customers` ;

CREATE TABLE IF NOT EXISTS `little_lemon_db`.`customers` (
  `Customer_id` INT NOT NULL AUTO_INCREMENT,
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
DROP TABLE IF EXISTS `little_lemon_db`.`employees` ;

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
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`bookings`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `little_lemon_db`.`bookings` ;

CREATE TABLE IF NOT EXISTS `little_lemon_db`.`bookings` (
  `Booking_id` INT NOT NULL AUTO_INCREMENT,
  `booking_date` DATE NOT NULL,
  `customer_id` INT NULL DEFAULT NULL,
  `Employee_id` INT NULL DEFAULT NULL,
  `table_number` INT NOT NULL,
  `booked` TINYINT(1) NULL DEFAULT NULL,
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
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `little_lemon_db`.`menu_items`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `little_lemon_db`.`menu_items` ;

CREATE TABLE IF NOT EXISTS `little_lemon_db`.`menu_items` (
  `Menu_items_id` INT NOT NULL AUTO_INCREMENT,
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
DROP TABLE IF EXISTS `little_lemon_db`.`menus` ;

CREATE TABLE IF NOT EXISTS `little_lemon_db`.`menus` (
  `Menu_id` INT NOT NULL AUTO_INCREMENT,
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
DROP TABLE IF EXISTS `little_lemon_db`.`orders` ;

CREATE TABLE IF NOT EXISTS `little_lemon_db`.`orders` (
  `Order_id` INT NOT NULL AUTO_INCREMENT,
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

USE `little_lemon_db`;
DROP procedure IF EXISTS `little_lemon_db`.`AddBooking`;

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
  INSERT INTO bookings (booking_id, customer_id, booking_date, employee_id, table_number) VALUES (booking_id, customer_id, booking_date, employee_id, table_number);
  SELECT 'new booking added' AS confirmation;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure AddValidBooking
-- -----------------------------------------------------

USE `little_lemon_db`;
DROP procedure IF EXISTS `little_lemon_db`.`AddValidBooking`;

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddValidBooking`(IN booking_date DATE, IN table_number INT)
BEGIN
    DECLARE booked BOOLEAN;

    START TRANSACTION;
    
    SELECT CASE WHEN EXISTS (
        SELECT 1
        FROM bookings
        WHERE DATE(Booking_Date) = DATE(booking_date) AND Table_Number = table_number
    ) THEN TRUE ELSE FALSE END INTO booked;

    IF booked THEN
        ROLLBACK;
        SELECT CONCAT("table ", table_number, " is booked - booking canceled") AS booking_status;
    ELSE
        SELECT CONCAT("table ", table_number, " is free - booked successfully") AS booking_status;
        INSERT INTO bookings (booking_id, Booking_Date, Table_Number) VALUES (5, booking_date, table_number);
        COMMIT;
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CancelBooking
-- -----------------------------------------------------

USE `little_lemon_db`;
DROP procedure IF EXISTS `little_lemon_db`.`CancelBooking`;

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelBooking`(
  IN booking_id INT
)
BEGIN
  DELETE FROM bookings WHERE booking_id = booking_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CancelOrder
-- -----------------------------------------------------

USE `little_lemon_db`;
DROP procedure IF EXISTS `little_lemon_db`.`CancelOrder`;

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelOrder`(
  IN order_id INT
)
BEGIN
  IF EXISTS (SELECT 1 FROM Orders WHERE order_id = order_id) THEN
    DELETE FROM Orders WHERE order_id = order_id;
    SELECT CONCAT('Confirmation', '\n', 'Order ', order_id, ' is cancelled') AS confirmation;
  ELSE
    SELECT 'No order with that ID' AS confirmation;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure CheckBooking
-- -----------------------------------------------------

USE `little_lemon_db`;
DROP procedure IF EXISTS `little_lemon_db`.`CheckBooking`;

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CheckBooking`(
  IN booking_date DATE,
  IN table_number INT
)
BEGIN
  IF EXISTS (SELECT 1 FROM bookings WHERE booking_date = booking_date AND table_number = table_number) THEN
    SELECT 'Table is booked' AS booking_status;
  ELSE
    SELECT 'Table is not booked' AS booking_status;
  END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure Checkbookingstatus
-- -----------------------------------------------------

USE `little_lemon_db`;
DROP procedure IF EXISTS `little_lemon_db`.`Checkbookingstatus`;

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Checkbookingstatus`(
    IN inputbooking_date DATE,
    IN inputtable_number INT
)
BEGIN
    DECLARE bookingstatusMessage VARCHAR(255);

    -- Start a transaction
    START TRANSACTION;

    -- Add the 'booked' column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = 'bookings'
          AND COLUMN_NAME = 'booked'
    ) THEN
        ALTER TABLE bookings
        ADD COLUMN booked BOOLEAN;
    END IF;

    -- Check if the table is already booked at the specified date
    IF EXISTS (
        SELECT 1
        FROM bookings
        WHERE booking_Date = inputbooking_date AND table_number = inputtable_number AND booked = 1
    ) THEN
        -- Rollback the transaction and return a message
        ROLLBACK;
        SET bookingstatusMessage = CONCAT("Table ", inputtable_number, " is booked on ", inputbooking_date, " - booking canceled");
    ELSE
        -- If the table is not booked, insert a new record and commit the transaction
        INSERT INTO bookings (booking_date, table_number, booked)
        VALUES (inputbooking_date, inputtable_number, 1);
        COMMIT;
        SET bookingstatusMessage = CONCAT("Table ", inputtable_number, " is free on ", inputbooking_date, " - booked successfully");
    END IF;

    -- Return the status message
    SELECT bookingstatusMessage AS booking_status;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure GetMaxQuantity
-- -----------------------------------------------------

USE `little_lemon_db`;
DROP procedure IF EXISTS `little_lemon_db`.`GetMaxQuantity`;

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

USE `little_lemon_db`;
DROP procedure IF EXISTS `little_lemon_db`.`UpdateBooking`;

DELIMITER $$
USE `little_lemon_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBooking`(
  IN booking_id INT,
  IN booking_date DATE
)
BEGIN
  UPDATE bookings SET booking_date = booking_date WHERE booking_id = booking_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `little_lemon_db`.`ordersview`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `little_lemon_db`.`ordersview`;
DROP VIEW IF EXISTS `little_lemon_db`.`ordersview` ;
USE `little_lemon_db`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `little_lemon_db`.`ordersview` AS select `little_lemon_db`.`orders`.`Order_id` AS `Order_id`,`little_lemon_db`.`orders`.`quantity` AS `quantity`,`little_lemon_db`.`orders`.`Cost` AS `Cost` from `little_lemon_db`.`orders` where (`little_lemon_db`.`orders`.`quantity` > 2);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
