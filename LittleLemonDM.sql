-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Employees` (
  `Employee_id` VARCHAR(45) NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Address` VARCHAR(45) NOT NULL,
  `Role` VARCHAR(45) NOT NULL,
  `Salary` INT NOT NULL,
  `Email` VARCHAR(45) NULL,
  `Contact_number` INT NULL,
  PRIMARY KEY (`Employee_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customers` (
  `Customer_id` INT NOT NULL,
  `Name` VARCHAR(45) NOT NULL,
  `Contact_number` INT NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Customer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Bookings` (
  `booking_id` INT NOT NULL,
  `Booking_date` DATETIME NOT NULL,
  `Customer_id` INT NOT NULL,
  `Employee_id` INT NOT NULL,
  PRIMARY KEY (`booking_id`),
  INDEX `Customer_id_idx` (`Customer_id` ASC) VISIBLE,
  CONSTRAINT `Employee_id`
    FOREIGN KEY ()
    REFERENCES `LittleLemonDB`.`Employees` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Customer_id`
    FOREIGN KEY (`Customer_id`)
    REFERENCES `LittleLemonDB`.`Customers` (`Customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Menu_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menu_items` (
  `Menu_items_id` INT NOT NULL,
  `Starter` VARCHAR(45) NOT NULL,
  `Course` VARCHAR(45) NOT NULL,
  `Drinks` VARCHAR(45) NOT NULL,
  `Dessert` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Menu_items_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Menus`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menus` (
  `Menu_id` INT NOT NULL,
  `Menu_items_id` INT NOT NULL,
  `Cuisine` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Menu_id`),
  INDEX `Menu_items_id_idx` (`Menu_items_id` ASC) VISIBLE,
  CONSTRAINT `Menu_items_id`
    FOREIGN KEY (`Menu_items_id`)
    REFERENCES `LittleLemonDB`.`Menu_items` (`Menu_items_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Orders` (
  `Order_id` VARCHAR(45) NOT NULL,
  `Order_date` DATE NOT NULL,
  `Quantity` INT NOT NULL,
  `Total_cost` INT NOT NULL,
  `Customer_id` INT NOT NULL,
  `Menu_id` INT NOT NULL,
  PRIMARY KEY (`Order_id`),
  INDEX `Customer_id_idx` (`Customer_id` ASC) VISIBLE,
  INDEX `Menu_id_idx` (`Menu_id` ASC) VISIBLE,
  CONSTRAINT `Customer_id`
    FOREIGN KEY (`Customer_id`)
    REFERENCES `LittleLemonDB`.`Customers` (`Customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Menu_id`
    FOREIGN KEY (`Menu_id`)
    REFERENCES `LittleLemonDB`.`Menus` (`Menu_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Order_delivery_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Order_delivery_status` (
  `Order_id` INT NOT NULL,
  `Delivery_date` DATE NOT NULL,
  `Status` VARCHAR(45) NOT NULL,
  INDEX `Order_id_idx` (`Order_id` ASC) VISIBLE,
  CONSTRAINT `Order_id`
    FOREIGN KEY (`Order_id`)
    REFERENCES `LittleLemonDB`.`Orders` (`Quantity`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
