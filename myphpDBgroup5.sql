-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 08, 2024 at 02:37 AM
-- Server version: 10.11.7-MariaDB-cll-lve
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u803325201_DBGroup5`
--

-- --------------------------------------------------------

--
-- Table structure for table `bonuses`
--

CREATE TABLE `bonuses` (
  `BonusID` int(11) NOT NULL,
  `EmployeeID` int(11) DEFAULT NULL,
  `BonusType` varchar(45) DEFAULT NULL,
  `BonusRecordID` int(11) DEFAULT NULL,
  `BonusAmount` decimal(10,2) DEFAULT NULL,
  `BonusDate` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- --------------------------------------------------------

--
-- Table structure for table `dailysales`
--

CREATE TABLE `dailysales` (
  `DailySaleID` int(11) NOT NULL,
  `Date` date DEFAULT NULL,
  `TotalTendered` decimal(10,2) DEFAULT NULL,
  `TotalDeposited` decimal(10,2) DEFAULT NULL,
  `BankRunAmount` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

--
-- Dumping data for table `dailysales`
--

INSERT INTO `dailysales` (`DailySaleID`, `Date`, `TotalTendered`, `TotalDeposited`, `BankRunAmount`) VALUES
(2, '2024-03-03', '250.24', '18.23', NULL),
(3, '2024-03-04', '1713.68', '252.40', '653.39'),
(4, '2024-03-05', '1933.37', '394.33', NULL),
(5, '2024-03-06', '1229.83', '100.38', NULL),
(6, '2024-03-07', '2687.92', '405.94', NULL),
(7, '2024-03-08', '1511.02', '193.04', '1345.98'),
(8, '2024-03-09', '980.32', '32.19', NULL),
(9, '2024-03-10', '707.15', '230.11', NULL),
(10, '2024-03-11', '1602.05', '561.68', NULL),
(11, '2024-03-12', '2063.72', '862.99', NULL),
(12, '2024-03-13', '844.86', '92.79', NULL),
(13, '2024-03-14', '1924.12', '213.63', '1970.00'),
(14, '2024-03-15', '1222.67', '192.79', NULL),
(15, '2024-03-16', '413.78', '76.82', NULL),
(16, '2024-03-17', '598.73', '32.73', NULL),
(17, '2024-03-18', '2212.98', '189.98', NULL),
(20, '2024-04-05', '125.00', '25.00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `EmployeeID` int(11) NOT NULL,
  `FirstName` varchar(45) DEFAULT NULL,
  `LastName` varchar(45) DEFAULT NULL,
  `Username` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Position` varchar(45) DEFAULT NULL,
  `IsActive` tinyint(1) NOT NULL,
  `IsAdmin` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`EmployeeID`, `FirstName`, `LastName`, `Username`, `Password`, `Position`, `IsActive`, `IsAdmin`) VALUES
(1, 'Scott', 'Pritten', '', '', '4', 1, 0),
(2, 'Kiara', 'Morelos', '', '', '4', 1, 0),
(3, 'Darren', 'Simpson', '', '', '4', 1, 0),
(4, 'Kavish', 'Singh', '', '', '4', 1, 0),
(5, 'Nancy', 'Gaye', '', '', '4', 1, 0),
(6, 'Siah', 'Gaye', 'siah', 'password', '1', 1, 1),
(7, 'Carla', 'Hernandez', 'carla', 'password', '4', 1, 0),
(8, 'Erick', 'Vitela', 'evitela', 'wordpass', '4', 1, 1),
(9, 'Carlos', 'Camarillo', 'miklo', 'comp420', '4', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `employee_vacations`
--

CREATE TABLE `employee_vacations` (
  `vacation_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `request_date` varchar(255) NOT NULL,
  `start_date` varchar(255) NOT NULL,
  `end_date` varchar(255) NOT NULL,
  `status` enum('Pending','Approved','Denied','') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `mailboxes`
--

CREATE TABLE `mailboxes` (
  `MailboxID` int(11) NOT NULL,
  `CustomerID` int(11) DEFAULT NULL,
  `EmployeeID` int(11) DEFAULT NULL,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `BonusID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- --------------------------------------------------------

--
-- Table structure for table `notaries`
--

CREATE TABLE `notaries` (
  `NotaryID` int(11) NOT NULL,
  `CustomerID` int(11) DEFAULT NULL,
  `EmployeeID` int(11) DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `BonusID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

-- --------------------------------------------------------

--
-- Table structure for table `registers`
--

CREATE TABLE `registers` (
  `RegisterID` int(11) NOT NULL,
  `RegisterName` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

--
-- Dumping data for table `registers`
--

INSERT INTO `registers` (`RegisterID`, `RegisterName`) VALUES
(1, 'POS A'),
(2, 'POS B'),
(3, 'POS C');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `SaleID` int(11) NOT NULL,
  `RegisterID` int(11) DEFAULT NULL,
  `EmployeeID` int(11) DEFAULT NULL,
  `SaleDate` date DEFAULT NULL,
  `SaleAmount` decimal(10,2) DEFAULT NULL,
  `TenderedAmount` decimal(10,2) DEFAULT NULL,
  `DepositAmount` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`SaleID`, `RegisterID`, `EmployeeID`, `SaleDate`, `SaleAmount`, `TenderedAmount`, `DepositAmount`) VALUES
(9, 1, 7, '2024-04-05', '25.00', NULL, '25.00'),
(10, 3, 9, '2024-04-05', '25.00', '25.00', NULL),
(11, 3, 9, '2024-04-05', '100.00', '100.00', NULL);

--
-- Triggers `sales`
--
DELIMITER $$
CREATE TRIGGER `AfterInsertSalesUpdateDailyTotals` AFTER INSERT ON `sales` FOR EACH ROW IF EXISTS (SELECT 1 FROM dailysales WHERE Date = NEW.SaleDate) THEN
        UPDATE dailysales
        SET TotalTendered = TotalTendered + COALESCE(NEW.TenderedAmount, 0),
            TotalDeposited = TotalDeposited + COALESCE(NEW.DepositAmount, 0)
        WHERE Date = NEW.SaleDate;
    ELSE
        INSERT INTO dailysales (Date, TotalTendered, TotalDeposited)
        VALUES (NEW.SaleDate, COALESCE(NEW.TenderedAmount, 0), COALESCE(NEW.DepositAmount, 0));
    END IF
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `shifts`
--

CREATE TABLE `shifts` (
  `ShiftID` int(11) NOT NULL,
  `EmployeeID` int(11) DEFAULT NULL,
  `ShiftDate` varchar(255) DEFAULT NULL,
  `ScheduledStart` varchar(255) DEFAULT NULL,
  `ScheduledEnd` varchar(255) DEFAULT NULL,
  `ActualStart` varchar(255) DEFAULT NULL,
  `ActualEnd` varchar(255) DEFAULT NULL,
  `TotalHours` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_bin;

--
-- Dumping data for table `shifts`
--

INSERT INTO `shifts` (`ShiftID`, `EmployeeID`, `ShiftDate`, `ScheduledStart`, `ScheduledEnd`, `ActualStart`, `ActualEnd`, `TotalHours`) VALUES
(1, 2, '2024-02-26', NULL, NULL, NULL, NULL, '8.00'),
(2, 2, '2024-02-27', NULL, NULL, NULL, NULL, '8.00'),
(3, 2, '2024-02-28', NULL, NULL, NULL, NULL, '8.00'),
(4, 2, '2024-02-29', NULL, NULL, NULL, NULL, '8.00'),
(5, 2, '2024-03-01', NULL, NULL, NULL, NULL, '8.00'),
(6, 3, '2024-02-26', NULL, NULL, NULL, NULL, '8.00'),
(7, 3, '2024-02-27', NULL, NULL, NULL, NULL, '8.00'),
(8, 3, '2024-02-28', NULL, NULL, NULL, NULL, '8.00'),
(9, 3, '2024-02-29', NULL, NULL, NULL, NULL, '8.00'),
(10, 3, '2024-03-01', NULL, NULL, NULL, NULL, '8.00'),
(11, 4, '2024-02-25', NULL, NULL, NULL, NULL, '6.75'),
(12, 4, '2024-03-02', NULL, NULL, NULL, NULL, '5.75'),
(13, 2, '2024-03-04', NULL, NULL, NULL, NULL, '8.00'),
(14, 2, '2024-03-05', NULL, NULL, NULL, NULL, '8.00'),
(15, 2, '2024-03-07', NULL, NULL, NULL, NULL, '8.00'),
(16, 2, '2024-03-08', NULL, NULL, NULL, NULL, '8.00'),
(17, 3, '2024-03-04', NULL, NULL, NULL, NULL, '8.00'),
(18, 3, '2024-03-05', NULL, NULL, NULL, NULL, '8.00'),
(19, 3, '2024-03-06', NULL, NULL, NULL, NULL, '8.00'),
(20, 3, '2024-03-07', NULL, NULL, NULL, NULL, '8.00'),
(21, 3, '2024-03-08', NULL, NULL, NULL, NULL, '8.00'),
(22, 4, '2024-03-03', NULL, NULL, NULL, NULL, '5.75'),
(23, 4, '2024-03-06', NULL, NULL, NULL, NULL, '8.00'),
(24, 4, '2024-03-07', NULL, NULL, NULL, NULL, '8.00'),
(25, 4, '2024-03-09', NULL, NULL, NULL, NULL, '5.75'),
(26, 2, '2024-03-11', NULL, NULL, NULL, NULL, '8.00'),
(27, 3, '2024-03-11', NULL, NULL, NULL, NULL, '8.00'),
(28, 7, '2024-03-31', NULL, NULL, '2024-03-31 10:40:41', '2024-03-31 10:41:29', '4.00');

--
-- Triggers `shifts`
--
DELIMITER $$
CREATE TRIGGER `CheckConsecutiveShiftsBeforeInsert` BEFORE INSERT ON `shifts` FOR EACH ROW BEGIN
    DECLARE shift_count INT;
 
    SELECT COUNT(*) INTO shift_count
    FROM shifts
    WHERE EmployeeID = NEW.EmployeeID
    AND (ShiftDate BETWEEN DATE_SUB(NEW.ShiftDate, INTERVAL 6 DAY) AND DATE_ADD(NEW.ShiftDate, INTERVAL 6 DAY));

    IF shift_count >= 6 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot schedule more than 6 consecutive shifts.';
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `CheckConsecutiveShiftsBeforeUpdate` BEFORE UPDATE ON `shifts` FOR EACH ROW BEGIN
    DECLARE shift_count INT;
    
    SELECT COUNT(*) INTO shift_count
    FROM shifts
    WHERE EmployeeID = NEW.EmployeeID
    AND (ShiftDate BETWEEN DATE_SUB(NEW.ShiftDate, INTERVAL 6 DAY) AND DATE_ADD(NEW.ShiftDate, INTERVAL 6 DAY));

    IF shift_count >= 6 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot schedule more than 6 consecutive shifts.';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `shift_switch`
--

CREATE TABLE `shift_switch` (
  `RequestID` int(11) NOT NULL,
  `EmployeeID` int(11) NOT NULL,
  `SwitchDate` varchar(255) NOT NULL,
  `RequestDate` varchar(255) NOT NULL,
  `Status` enum('Pending','Approved','Denied','') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bonuses`
--
ALTER TABLE `bonuses`
  ADD PRIMARY KEY (`BonusID`),
  ADD KEY `Employee-Bonus-Relation_idx` (`EmployeeID`);

--
-- Indexes for table `dailysales`
--
ALTER TABLE `dailysales`
  ADD PRIMARY KEY (`DailySaleID`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`EmployeeID`);

--
-- Indexes for table `employee_vacations`
--
ALTER TABLE `employee_vacations`
  ADD PRIMARY KEY (`vacation_id`),
  ADD KEY `Employee-Vacation-Relation` (`employee_id`);

--
-- Indexes for table `mailboxes`
--
ALTER TABLE `mailboxes`
  ADD PRIMARY KEY (`MailboxID`),
  ADD KEY `Employee-Mailbox-Relation_idx` (`EmployeeID`),
  ADD KEY `Bonus-Mailbox-Relation_idx` (`BonusID`);

--
-- Indexes for table `notaries`
--
ALTER TABLE `notaries`
  ADD PRIMARY KEY (`NotaryID`),
  ADD KEY `Employee-Notary-Relation_idx` (`EmployeeID`),
  ADD KEY `Bonus-Notary-Relation_idx` (`BonusID`);

--
-- Indexes for table `registers`
--
ALTER TABLE `registers`
  ADD PRIMARY KEY (`RegisterID`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`SaleID`),
  ADD KEY `Employee-Sales-Relation_idx` (`EmployeeID`),
  ADD KEY `Register-Sales-Relation_idx` (`RegisterID`);

--
-- Indexes for table `shifts`
--
ALTER TABLE `shifts`
  ADD PRIMARY KEY (`ShiftID`),
  ADD KEY `EmployeeID_idx` (`EmployeeID`);

--
-- Indexes for table `shift_switch`
--
ALTER TABLE `shift_switch`
  ADD PRIMARY KEY (`RequestID`),
  ADD KEY `Employee-Switch-Relation` (`EmployeeID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bonuses`
--
ALTER TABLE `bonuses`
  MODIFY `BonusID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dailysales`
--
ALTER TABLE `dailysales`
  MODIFY `DailySaleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `EmployeeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `employee_vacations`
--
ALTER TABLE `employee_vacations`
  MODIFY `vacation_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mailboxes`
--
ALTER TABLE `mailboxes`
  MODIFY `MailboxID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notaries`
--
ALTER TABLE `notaries`
  MODIFY `NotaryID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `registers`
--
ALTER TABLE `registers`
  MODIFY `RegisterID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `SaleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `shifts`
--
ALTER TABLE `shifts`
  MODIFY `ShiftID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `shift_switch`
--
ALTER TABLE `shift_switch`
  MODIFY `RequestID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bonuses`
--
ALTER TABLE `bonuses`
  ADD CONSTRAINT `Employee-Bonus-Relation` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `employee_vacations`
--
ALTER TABLE `employee_vacations`
  ADD CONSTRAINT `Employee-Vacation-Relation` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`EmployeeID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `mailboxes`
--
ALTER TABLE `mailboxes`
  ADD CONSTRAINT `Bonus-Mailbox-Relation` FOREIGN KEY (`BonusID`) REFERENCES `bonuses` (`BonusID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `Employee-Mailbox-Relation` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `notaries`
--
ALTER TABLE `notaries`
  ADD CONSTRAINT `Bonus-Notary-Relation` FOREIGN KEY (`BonusID`) REFERENCES `bonuses` (`BonusID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `Employee-Notary-Relation` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `Employee-Sales-Relation` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `Register-Sales-Relation` FOREIGN KEY (`RegisterID`) REFERENCES `registers` (`RegisterID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `shifts`
--
ALTER TABLE `shifts`
  ADD CONSTRAINT `Employee-Shift-Relation` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `shift_switch`
--
ALTER TABLE `shift_switch`
  ADD CONSTRAINT `Employee-Switch-Relation` FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
