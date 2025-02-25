-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 10, 2024 at 03:49 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lga_competency`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_AddDivision` (IN `region_id_val` INT, IN `division_name_val` VARCHAR(255), IN `division_chief_val` VARCHAR(255), IN `created_by_val` VARCHAR(255))   BEGIN
    INSERT INTO division (region_id, division_name, division_chief, created_by, updated_by, status)
    SELECT region_id_val, 
           division_name_val, 
           IFNULL(division_chief_val, ''), 
           created_by_val, 
           created_by_val, 
           'active'
    WHERE NOT EXISTS (
        SELECT 1 FROM division 
        WHERE division_name = division_name_val
    )
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_AddProvince` (IN `region_id_val` INT, IN `province_name_val` VARCHAR(255), IN `province_director_val` VARCHAR(255), IN `created_by_val` VARCHAR(255))   BEGIN

    INSERT INTO province_or_huc (province_or_huc_name, region_id, province_or_huc_director, created_by, updated_by, created_on, updated_on, status)
    SELECT 
        province_name_val,
        region_id_val,
        IFNULL(province_director_val, ''), 
        created_by_val, 
        created_by_val, 
        CURRENT_TIMESTAMP, 
        CURRENT_TIMESTAMP, 
        'active'
    WHERE 
        NOT EXISTS (
            SELECT 1 
            FROM province_or_huc 
            WHERE province_or_huc_name = province_name_val AND region_id = region_id_val
        )
    LIMIT 1;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_AddRegion` (IN `region_name_val` VARCHAR(255), IN `regional_director_val` VARCHAR(255), IN `created_by_val` VARCHAR(255))   BEGIN
    INSERT INTO region (region_name, regional_director, created_by, updated_by, status)
    SELECT region_name_val, 
           IFNULL(regional_director_val, ''),  
           created_by_val, 
           created_by_val, 
           'active'
    WHERE NOT EXISTS (
        SELECT 1 FROM region WHERE region_name = region_name_val
    )
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_AddUser` (IN `username_val` VARCHAR(255), IN `password_val` VARCHAR(255), IN `name_val` VARCHAR(255), IN `email_val` VARCHAR(255), IN `region_id_val` INT, IN `user_type_val` ENUM('superadmin','regional admin','regional director','asst regional director','provincial dic','city dic','division chief','asst div chief','cluster head','rank and file'), IN `education_val` VARCHAR(255), IN `mobile_number_val` VARCHAR(20), IN `division_id_val` INT, IN `position_val` VARCHAR(255), IN `sex_val` ENUM('male','female'), IN `date_of_birth_val` DATE, IN `province_or_huc_id_val` INT, IN `place_of_birth_val` VARCHAR(255), IN `address_val` VARCHAR(255), IN `municipality_id_val` INT, IN `scc_id_val` INT, IN `remarks_val` TEXT)   BEGIN
    INSERT INTO user (
        username, password, name, email, region_id, user_type, education, mobile_number,
        division_id, position, sex, date_of_birth, province_or_huc_id, place_of_birth,
        address, municipality_id, scc_id, status, remarks, created_on, updated_on, f_login
    )
    SELECT
        username_val, password_val, name_val, email_val, 
        IF(region_id_val = '', NULL, region_id_val),
        user_type_val, education_val, mobile_number_val,
        IF(division_id_val = '', NULL, division_id_val), 
        position_val, sex_val, date_of_birth_val, 
        IF(province_or_huc_id_val = '', NULL, province_or_huc_id_val), 
        place_of_birth_val, address_val, 
        IF(municipality_id_val = '', NULL, municipality_id_val), 
        IF(scc_id_val = '', NULL, scc_id_val), 
        'active', remarks_val, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1
    WHERE NOT EXISTS (SELECT 1 FROM user WHERE username = username_val);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_ChangeDivisionStatus` (IN `division_id_val` INT, IN `status_val` ENUM('active','inactive'))   BEGIN
    -- Update the division status based on division_id
    UPDATE division
    SET 
        status = status_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
        division_id = division_id_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_changeRegionStatus` (IN `region_id_val` INT, IN `status_val` ENUM('active','inactive'))   BEGIN
    UPDATE region
    SET 
        status = status_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
    	region_id = region_id_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_DDGetAllRegions` ()   BEGIN
    SELECT 
        region_id,
        region_name
    FROM 
        region
    WHERE
    	status = 'active'
    ORDER BY 
        region_id DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetAllDivision` (IN `pageNo` INT, IN `pageSize` INT, IN `keyword` VARCHAR(255))   BEGIN
    SET pageNo = (pageNo - 1) * pageSize;

    SELECT 
        d.division_id,
        d.division_name,
        d.division_chief,
        d.status,
        r.region_name,
        d.created_by, 
        d.updated_by, 
        d.created_on, 
        d.updated_on
    FROM 
        division d
    JOIN 
        region r ON d.region_id = r.region_id
    WHERE (d.division_name LIKE CONCAT('%', keyword, '%')
             OR d.division_chief LIKE CONCAT('%', keyword, '%'))
    ORDER BY 
        d.division_id DESC
    LIMIT 
        pageSize OFFSET pageNo;
    SELECT 
        COUNT(d.division_id) AS total
    FROM 
        division d
    JOIN 
        region r ON d.region_id = r.region_id
    WHERE 
        (d.division_name LIKE CONCAT('%', keyword, '%')
             OR d.division_chief LIKE CONCAT('%', keyword, '%'));
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetAllProvince` (IN `pageNo` INT, IN `pageSize` INT, IN `keyword` VARCHAR(255))   BEGIN
    SET pageNo = (pageNo - 1) * pageSize;

    SELECT 
        province_or_city_id, 
        province_or_huc_name, 
        region_id, 
        province_or_huc_director, 
        created_by, 
        updated_by, 
        created_on, 
        updated_on, 
        status
    FROM 
        province_or_huc
    WHERE 
        province_or_huc_name LIKE CONCAT('%', keyword, '%') 
        OR province_or_huc_director LIKE CONCAT('%', keyword, '%')
    ORDER BY 
        province_or_city_id DESC
    LIMIT 
        pageSize OFFSET pageNo;

    SELECT 
        COUNT(province_or_city_id) AS total
    FROM 
        province_or_huc
    WHERE 
        province_or_huc_name LIKE CONCAT('%', keyword, '%') 
        OR province_or_huc_director LIKE CONCAT('%', keyword, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetAllRegions` (IN `pageNo` INT, IN `pageSize` INT, IN `keyword` VARCHAR(255))   BEGIN
    SET pageNo = (pageNo - 1) * pageSize;

    SELECT region_id, region_name, regional_director, created_on, created_by, updated_on, updated_by, status
    FROM region
    WHERE  (
        region_name LIKE CONCAT('%', keyword, '%') 
        OR regional_director LIKE CONCAT('%', keyword, '%')
    )
    ORDER BY region_id DESC
    LIMIT pageSize OFFSET pageNo;

    -- Get the total number of regions that match the keyword
    SELECT COUNT(region_id) AS total
    FROM region
    WHERE (
        region_name LIKE CONCAT('%', keyword, '%') 
        OR regional_director LIKE CONCAT('%', keyword, '%')
    );

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetAllUsers` (IN `pageNo` INT, IN `pageSize` INT, IN `keyword` VARCHAR(255))   BEGIN
    SET pageNo = (pageNo - 1) * pageSize;

    SELECT 
        user_id, 
        username, 
        name, 
        email, 
        region_id, 
        user_type, 
        education, 
        mobile_number, 
        division_id, 
        position, 
        sex, 
        date_of_birth, 
        province_or_huc_id, 
        place_of_birth, 
        address, 
        municipality_id, 
        scc_id, 
        status, 
        remarks, 
        created_on, 
        updated_on
    FROM 
        user
    WHERE 
        username LIKE CONCAT('%', keyword, '%') 
        OR name LIKE CONCAT('%', keyword, '%')
        OR email LIKE CONCAT('%', keyword, '%')
        OR education LIKE CONCAT('%', keyword, '%')
        OR mobile_number LIKE CONCAT('%', keyword, '%')
        OR position LIKE CONCAT('%', keyword, '%')
        OR place_of_birth LIKE CONCAT('%', keyword, '%')
        OR address LIKE CONCAT('%', keyword, '%')
        OR remarks LIKE CONCAT('%', keyword, '%')
    ORDER BY 
        user_id DESC
    LIMIT 
        pageSize OFFSET pageNo;

    SELECT 
        COUNT(user_id) AS total
    FROM 
        user
    WHERE 
        username LIKE CONCAT('%', keyword, '%') 
        OR name LIKE CONCAT('%', keyword, '%')
        OR email LIKE CONCAT('%', keyword, '%')
        OR education LIKE CONCAT('%', keyword, '%')
        OR mobile_number LIKE CONCAT('%', keyword, '%')
        OR position LIKE CONCAT('%', keyword, '%')
        OR place_of_birth LIKE CONCAT('%', keyword, '%')
        OR address LIKE CONCAT('%', keyword, '%')
        OR remarks LIKE CONCAT('%', keyword, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetDivisionByID` (IN `division_id` INT)   BEGIN
    -- Select division details and its corresponding region name based on division_id
    SELECT 
        d.division_id,
        d.division_name,
        d.division_chief,
        d.status,
        r.region_name,
        d.created_by, 
        d.updated_by, 
        d.created_on, 
        d.updated_on
    FROM 
        division d
    JOIN 
        region r ON d.region_id = r.region_id
    WHERE 
        d.division_id = division_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetRegionsByID` (IN `region_id_val` INT)   BEGIN
    SELECT region_id, region_name, regional_director, created_by, updated_by, created_on, updated_on, status
    FROM region
    WHERE region_id = region_id_val
    AND status = 'active';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_Login` (IN `username_val` VARCHAR(100))   BEGIN

SELECT password, username FROM `user` WHERE username = username_val;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_Register` (IN `username_val` VARCHAR(100), IN `password_val` VARCHAR(255))   BEGIN

IF NOT EXISTS (
   SELECT 1
   FROM user
   WHERE username = username_val
) THEN
   INSERT INTO user (username, password, user_type)
   VALUES (username_val, password_val, 'superadmin');
END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_UpdateDivision` (IN `division_id_val` INT, IN `region_id_val` INT, IN `division_name_val` VARCHAR(255), IN `division_chief_val` VARCHAR(255), IN `updated_by_val` VARCHAR(255))   BEGIN
    UPDATE division
    SET 
        division_name = division_name_val,
        division_chief = division_chief_val,
        region_id = region_id_val,
        updated_by = updated_by_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
        division_id = division_id_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_UpdateRegion` (IN `region_id_val` INT, IN `region_name_val` VARCHAR(255), IN `regional_director_val` VARCHAR(255), IN `updated_by_val` VARCHAR(255))   BEGIN
    UPDATE region
    SET 
        region_name = region_name_val,
        regional_director = regional_director_val,
        updated_by = updated_by_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
        region_id = region_id_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_UpdateUser` (IN `user_id_val` INT, IN `name_val` VARCHAR(255), IN `email_val` VARCHAR(255), IN `region_id_val` INT, IN `user_type_val` ENUM('superadmin','regional admin','regional director','asst regional director','provincial dic','city dic','division chief','asst div chief','cluster head','rank and file'), IN `education_val` VARCHAR(255), IN `mobile_number_val` VARCHAR(20), IN `division_id_val` INT, IN `position_val` VARCHAR(255), IN `sex_val` ENUM('male','female'), IN `date_of_birth_val` DATE, IN `province_or_huc_id_val` INT, IN `place_of_birth_val` VARCHAR(255), IN `address_val` VARCHAR(255), IN `municipality_id_val` INT, IN `scc_id_val` INT, IN `remarks_val` TEXT)   BEGIN
    UPDATE user
    SET 
        name = name_val,
        email = email_val,
        region_id = IF(region_id_val = '', NULL, region_id_val),
        user_type = user_type_val,
        education = education_val,
        mobile_number = mobile_number_val,
        division_id = IF(division_id_val = '', NULL, division_id_val),
        position = position_val,
        sex = sex_val,
        date_of_birth = date_of_birth_val,
        province_or_huc_id = IF(province_or_huc_id_val = '', NULL, province_or_huc_id_val),
        place_of_birth = place_of_birth_val,
        address = address_val,
        municipality_id = IF(municipality_id_val = '', NULL, municipality_id_val),
        scc_id = IF(scc_id_val = '', NULL, scc_id_val),
        remarks = remarks_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
        user_id = user_id_val;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `division`
--

CREATE TABLE `division` (
  `division_id` int(11) NOT NULL,
  `region_id` int(11) NOT NULL,
  `division_name` varchar(255) NOT NULL,
  `division_chief` varchar(255) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `created_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_on` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` enum('active','inactive') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `division`
--

INSERT INTO `division` (`division_id`, `region_id`, `division_name`, `division_chief`, `created_by`, `updated_by`, `created_on`, `updated_on`, `status`) VALUES
(1, 1, 'Division 6', ' ', 'super_admin', 'super_admin', '2024-11-20 10:39:02', '2024-11-20 11:38:05', 'inactive'),
(2, 1, 'Division 2', ' ', 'super_admin', 'super_admin', '2024-11-20 10:39:34', '2024-11-20 10:39:34', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `municipality`
--

CREATE TABLE `municipality` (
  `municipality_id` int(11) NOT NULL,
  `region_id` int(11) NOT NULL,
  `cluster_id` int(11) NOT NULL,
  `province_or_city_id` int(11) NOT NULL,
  `municipality_name` varchar(255) NOT NULL,
  `municipality_head` varchar(255) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `created_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_on` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` enum('active','inactive') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `province_or_huc`
--

CREATE TABLE `province_or_huc` (
  `province_or_city_id` int(11) NOT NULL,
  `region_id` int(11) NOT NULL,
  `province_or_huc_name` varchar(255) NOT NULL,
  `province_or_huc_director` varchar(255) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `created_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_on` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` enum('active','inactive') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `province_or_huc`
--

INSERT INTO `province_or_huc` (`province_or_city_id`, `region_id`, `province_or_huc_name`, `province_or_huc_director`, `created_by`, `updated_by`, `created_on`, `updated_on`, `status`) VALUES
(2, 1, 'Province 2', ' ', 'super_admin', 'super_admin', '2024-11-23 06:57:01', '2024-11-23 06:57:01', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `region`
--

CREATE TABLE `region` (
  `region_id` int(11) NOT NULL,
  `region_name` varchar(255) NOT NULL,
  `regional_director` varchar(255) DEFAULT NULL,
  `created_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_on` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `region`
--

INSERT INTO `region` (`region_id`, `region_name`, `regional_director`, `created_on`, `updated_on`, `status`, `created_by`, `updated_by`) VALUES
(1, 'Region 6', ' ', '2024-11-20 07:27:10', '2024-11-20 09:11:54', 'inactive', 'super_admin', 'super_admin'),
(2, 'Region 2', ' ', '2024-11-20 07:27:37', '2024-11-20 07:27:37', 'active', 'super_admin', 'super_admin'),
(3, 'Region 3', ' ', '2024-11-20 07:29:10', '2024-11-20 07:29:10', 'active', 'super_admin', 'super_admin');

-- --------------------------------------------------------

--
-- Table structure for table `sadmin_user`
--

CREATE TABLE `sadmin_user` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sadmin_user`
--

INSERT INTO `sadmin_user` (`id`, `username`, `password`) VALUES
(1, 'super_admin', '$2b$12$TJGRVUfZrWcQKF/AdoU9AOPVAVFey08MofdizryJ8VAQTjwVhOuWe');

-- --------------------------------------------------------

--
-- Table structure for table `scc`
--

CREATE TABLE `scc` (
  `scc_id` int(11) NOT NULL,
  `region_id` int(11) NOT NULL,
  `province_or_city_id` int(11) NOT NULL,
  `type` enum('section','city','cluster') NOT NULL,
  `scc_name` varchar(255) NOT NULL,
  `scc_head` varchar(255) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `created_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_on` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` enum('active','inactive') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `region_id` int(11) DEFAULT NULL,
  `user_type` enum('superadmin','regional admin','regional director','asst regional director','provincial director','city director','div chief','asst div chief','cluster head','rank and file') DEFAULT NULL,
  `education` varchar(255) DEFAULT NULL,
  `mobile_number` varchar(20) DEFAULT NULL,
  `division_id` int(11) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `sex` enum('male','female') DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `province_or_huc_id` int(11) DEFAULT NULL,
  `place_of_birth` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `municipality_id` int(11) DEFAULT NULL,
  `scc_id` int(11) DEFAULT NULL,
  `status` enum('active','inactive') DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `created_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_on` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `f_login` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `username`, `password`, `name`, `email`, `region_id`, `user_type`, `education`, `mobile_number`, `division_id`, `position`, `sex`, `date_of_birth`, `province_or_huc_id`, `place_of_birth`, `address`, `municipality_id`, `scc_id`, `status`, `remarks`, `created_on`, `updated_on`, `f_login`) VALUES
(6, 'john_doe', '$2b$12$W/VSgakupeS/QCmj6wvvk.spqVA8cXbaeqXQMJkeJOucCKPqsouh2', 'John Doe', 'kim@sitesphil.com', 1, 'regional director', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Director', 'male', '1990-01-01', NULL, 'New York', '123 Main St, New York, NY 10001', NULL, NULL, 'active', 'No remarks', '2024-11-22 07:19:56', '2024-11-23 03:17:18', 1),
(7, 'dev', '$2b$12$ytWMHplAidiPl39M8ol2keu7hY/FXlP.CnmTv7y2m8r8CSC7R05ji', 'John Doe', 'kim@sitesphil.com', NULL, 'regional director', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Director', 'male', '1990-01-01', NULL, 'New York', '123 Main St, New York, NY 10001', NULL, NULL, 'active', 'No remarks', '2024-11-22 08:24:06', '2024-11-22 08:24:06', 1),
(8, 'dev001', '$2b$12$OH4muybDxF0mbdRhRtIxCeNPDHQCKnEYZfzT8SXmGmmwa92vHNkxu', 'Peter Dino Rex', 'peter@sitesphil.com', NULL, '', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Lead', 'male', '1990-01-01', NULL, 'New York', '123 Main St, New York, NY 10001', NULL, NULL, 'active', 'No remarks', '2024-11-23 03:21:25', '2024-11-23 03:21:25', 1),
(9, 'EmployeeNumber1', '$2b$12$9uQo6t.EK04POe8Oh6dVgeBfD0IViAOyVtiEH5PDDhfmk8yWyiYfy', 'Nyalmer Dino Rex', 'jhomark@sitesphil.com', NULL, '', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Lead', 'male', '1990-01-01', NULL, 'New York', '123 Main St, New York, NY 10001', NULL, NULL, 'active', 'No remarks', '2024-11-23 03:27:53', '2024-11-23 03:27:53', 1),
(10, 'PostJhomark', '$2b$12$h5.FLS1JUyECQkL/UPOAxeVfiLCuZj7B2vn0ynBNq242rqQt73Hd.', 'Nyalmer Dino Rex', 'jhomark@sitesphil.com', NULL, '', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Lead', 'male', '1990-01-01', NULL, 'New York', '123 Main St, New York, NY 10001', NULL, NULL, 'active', 'No remarks', '2024-11-23 03:32:05', '2024-11-23 03:32:05', 1),
(16, 'test', 'test', NULL, NULL, NULL, 'superadmin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-12-09 08:07:06', '2024-12-09 08:07:06', 1),
(18, '1', '2', NULL, NULL, NULL, 'superadmin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-12-09 09:21:07', '2024-12-09 09:21:07', 1),
(19, 'super_admin', '$2b$12$LMfyQsgO.qcTF793GDYyJO7NzWC1Ol5BtkCeygbFceV0Bj1eg6.ua', NULL, NULL, NULL, 'superadmin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-12-09 09:22:38', '2024-12-09 09:22:38', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `division`
--
ALTER TABLE `division`
  ADD PRIMARY KEY (`division_id`),
  ADD KEY `region_id` (`region_id`);

--
-- Indexes for table `municipality`
--
ALTER TABLE `municipality`
  ADD PRIMARY KEY (`municipality_id`),
  ADD KEY `region_id` (`region_id`),
  ADD KEY `cluster_id` (`cluster_id`),
  ADD KEY `province_or_city_id` (`province_or_city_id`);

--
-- Indexes for table `province_or_huc`
--
ALTER TABLE `province_or_huc`
  ADD PRIMARY KEY (`province_or_city_id`),
  ADD KEY `region_id` (`region_id`);

--
-- Indexes for table `region`
--
ALTER TABLE `region`
  ADD PRIMARY KEY (`region_id`);

--
-- Indexes for table `sadmin_user`
--
ALTER TABLE `sadmin_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `scc`
--
ALTER TABLE `scc`
  ADD PRIMARY KEY (`scc_id`),
  ADD KEY `region_id` (`region_id`),
  ADD KEY `province_or_city_id` (`province_or_city_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `region_id` (`region_id`),
  ADD KEY `division_id` (`division_id`),
  ADD KEY `province_or_huc_id` (`province_or_huc_id`),
  ADD KEY `municipality_id` (`municipality_id`),
  ADD KEY `scc_id` (`scc_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `division`
--
ALTER TABLE `division`
  MODIFY `division_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `municipality`
--
ALTER TABLE `municipality`
  MODIFY `municipality_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `province_or_huc`
--
ALTER TABLE `province_or_huc`
  MODIFY `province_or_city_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `region`
--
ALTER TABLE `region`
  MODIFY `region_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `sadmin_user`
--
ALTER TABLE `sadmin_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `scc`
--
ALTER TABLE `scc`
  MODIFY `scc_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `division`
--
ALTER TABLE `division`
  ADD CONSTRAINT `division_ibfk_1` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`);

--
-- Constraints for table `municipality`
--
ALTER TABLE `municipality`
  ADD CONSTRAINT `municipality_ibfk_1` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`),
  ADD CONSTRAINT `municipality_ibfk_2` FOREIGN KEY (`cluster_id`) REFERENCES `scc` (`scc_id`),
  ADD CONSTRAINT `municipality_ibfk_3` FOREIGN KEY (`province_or_city_id`) REFERENCES `province_or_huc` (`province_or_city_id`);

--
-- Constraints for table `province_or_huc`
--
ALTER TABLE `province_or_huc`
  ADD CONSTRAINT `province_or_huc_ibfk_1` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`);

--
-- Constraints for table `scc`
--
ALTER TABLE `scc`
  ADD CONSTRAINT `scc_ibfk_1` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`),
  ADD CONSTRAINT `scc_ibfk_2` FOREIGN KEY (`province_or_city_id`) REFERENCES `province_or_huc` (`province_or_city_id`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`),
  ADD CONSTRAINT `user_ibfk_2` FOREIGN KEY (`division_id`) REFERENCES `division` (`division_id`),
  ADD CONSTRAINT `user_ibfk_3` FOREIGN KEY (`province_or_huc_id`) REFERENCES `province_or_huc` (`province_or_city_id`),
  ADD CONSTRAINT `user_ibfk_4` FOREIGN KEY (`municipality_id`) REFERENCES `municipality` (`municipality_id`),
  ADD CONSTRAINT `user_ibfk_5` FOREIGN KEY (`scc_id`) REFERENCES `scc` (`scc_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
