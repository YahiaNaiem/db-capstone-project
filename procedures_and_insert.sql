-- MySQL dump 10.13 Distrib 8.1.0, for Win64 (x86_64)
-- ...

unlock tables;

-- Dumping data for table `bookings`
TRUNCATE TABLE Bookings;
INSERT INTO `bookings` VALUES (1,'2022-10-10',1,1,5,1),(2,'2022-11-12',3,2,3,1),(3,'2022-10-11',2,3,2,1),(4,'2022-10-13',1,2,2,1),(5,'2023-11-10',NULL,NULL,5,1),(6,'2022-11-10',NULL,NULL,5,1),(7,'2023-10-10',NULL,NULL,5,1);

-- Dumping data for table `customers`
TRUNCATE TABLE customers;
INSERT INTO `customers` VALUES (1,'John Doe','1234567890','john.doe@example.com'),(2,'Jane Doe','9876543210','jane.doe@example.com'),(3,'Peter Smith','987654321','peter.smith@example.com');

-- Dumping data for table `employees`
TRUNCATE TABLE employees;
INSERT INTO `employees` VALUES (1,'Alice','Manager','123 Main Street','1234567890','alice@example.com','$100,000'),(2,'Bob','Chef','456 Elm Street','9876543210','bob@example.com','$80,000'),(3,'Carol','Waiter','789 Oak Street','987654321','carol@example.com','$60,000');

-- Dumping data for table `menu_items`
TRUNCATE TABLE menu_items;
INSERT INTO `menu_items` VALUES (1,'Appetizer','Soup','Ice Cream'),(2,'Main Course','Salad','Cake'),(3,'Dessert','Bread','Cookies');

-- Dumping data for table `menus`
TRUNCATE TABLE menus;
INSERT INTO `menus` VALUES (1,1,'Italian','Menu Italian'),(2,2,'American','Menu American'),(3,3,'Dessert','Menu Dessert');

-- Dumping data for table `orders`
TRUNCATE TABLE orders;
INSERT INTO `orders` VALUES (1,1,1,40,1),(2,2,2,50,2),(3,3,3,60,3),(4,1,1,70,4),(5,2,2,80,5),(6,3,3,90,6),(7,1,1,100,7),(8,2,2,90,8),(9,3,3,80,9),(10,1,1,70,10);

-- Dumping routines for database 'little_lemon_db'

drop procedure if exists AddBooking;
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddBooking`(
  IN booking_id INT,
  IN customer_id INT,
  IN booking_date DATE,
  IN employee_id INT,
  IN table_number INT
)
BEGIN
  INSERT INTO Bookings (BookingId, CustomerId, BookingDate, EmployeeId, TableNumber) VALUES (booking_id, customer_id, booking_date, employee_id, table_number);
  SELECT 'new booking added' as confirmation;
END//

delimiter //

drop procedure if exists AddValidBooking;
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
END//

-- AddBooking Procedure
drop procedure if exists AddBooking;
CREATE PROCEDURE `AddBooking`(
  IN booking_id INT,
  IN customer_id INT,
  IN booking_date DATE,
  IN employee_id INT,
  IN table_number INT
)
BEGIN
  INSERT INTO Bookings (BookingId, CustomerId, BookingDate, EmployeeId, TableNumber) VALUES (booking_id, customer_id, booking_date, employee_id, table_number);
  SELECT 'new booking added' AS confirmation;
END;

-- CancelBooking Procedure
drop procedure if exists CancelBooking;
CREATE PROCEDURE `CancelBooking`(
  IN booking_id INT
)
BEGIN
  DELETE FROM Bookings WHERE BookingId = booking_id;
END;

-- UpdateBooking Procedure
drop procedure if exists UpdateBooking;
CREATE PROCEDURE `UpdateBooking`(
  IN booking_id INT,
  IN booking_date DATE
)
BEGIN
  UPDATE Bookings SET BookingDate = booking_date WHERE BookingId = booking_id;
END;

-- CancelOrder Procedure
drop procedure if exists CancelOrder;
CREATE PROCEDURE `CancelOrder`(
  IN order_id INT
)
BEGIN
  IF EXISTS (SELECT 1 FROM Orders WHERE OrderId = order_id) THEN
    DELETE FROM Orders WHERE OrderId = order_id;
    SELECT CONCAT('Confirmation', '\n', 'Order ', order_id, ' is cancelled') AS confirmation;
  ELSE
    SELECT 'No order with that ID' AS confirmation;
  END IF;
END;

-- CheckBooking Procedure
drop procedure if exists CheckBooking;
CREATE PROCEDURE `CheckBooking`(
  IN booking_date DATE,
  IN table_number INT
)
BEGIN
  IF EXISTS (SELECT 1 FROM Bookings WHERE BookingDate = booking_date AND TableNumber = table_number) THEN
    SELECT 'Table is booked' AS booking_status;
  ELSE
    SELECT 'Table is not booked' AS booking_status;
  END IF;
END;

-- CheckBookingStatus Procedure
drop procedure if exists CheckBookingStatus;
CREATE PROCEDURE `CheckBookingStatus`(
    IN inputBookingDate DATE,
    IN inputTableNumber INT
)
BEGIN
    DECLARE bookingStatusMessage VARCHAR(255);

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
        WHERE booking_Date = inputBookingDate AND table_number = inputTableNumber AND booked = 1
    ) THEN
        -- Rollback the transaction and return a message
        ROLLBACK;
        SET bookingStatusMessage = CONCAT("Table ", inputTableNumber, " is booked on ", inputBookingDate, " - booking canceled");
    ELSE
        -- If the table is not booked, insert a new record and commit the transaction
        INSERT INTO bookings (BookingDate, TableNumber, booked)
        VALUES (inputBookingDate, inputTableNumber, 1);
        COMMIT;
        SET bookingStatusMessage = CONCAT("Table ", inputTableNumber, " is free on ", inputBookingDate, " - booked successfully");
    END IF;

    -- Return the status message
    SELECT bookingStatusMessage AS booking_status;
END;

-- GetMaxQuantity Procedure

drop procedure if exists GetMaxQuantity;
CREATE PROCEDURE `GetMaxQuantity`()
BEGIN
  SELECT MAX(Quantity) AS MaxQuantity
  FROM Orders;
END;

