-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 14, 2025 at 03:22 AM
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
        WHERE division_name = division_name_val AND region_id = region_id_val
    )
    LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_AddMessage` (IN `message_val` TEXT, IN `created_by_val` VARCHAR(100))   BEGIN

    INSERT INTO messages (message, created_by, created_at, status)
    SELECT 
        message_val, 
        created_by_val, 
        CURRENT_TIMESTAMP, 
        'active'
    WHERE 
        NOT EXISTS (
            SELECT 1 
            FROM messages
            WHERE message = message_val
        )
    LIMIT 1;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_AddMunicipality` (IN `region_id_val` INT, IN `scc_id_val` INT, IN `province_or_city_id_val` INT, IN `municipality_name_val` VARCHAR(255), IN `created_by_val` VARCHAR(255))   BEGIN

    INSERT INTO municipality (region_id, cluster_id, province_or_city_id, municipality_name, created_by, updated_by, created_on, updated_on, status)
    SELECT 
        region_id_val, 
        scc_id_val, 
        province_or_city_id_val, 
        municipality_name_val, 
        created_by_val, 
        created_by_val, 
        CURRENT_TIMESTAMP, 
        CURRENT_TIMESTAMP, 
        'active'
    WHERE 
        NOT EXISTS (
            SELECT 1 
            FROM municipality 
            WHERE municipality_name = municipality_name_val AND region_id = region_id_val AND cluster_id = scc_id_val AND province_or_city_id = province_or_city_id_val
        )
    LIMIT 1;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_AddPosition` (IN `position_name_val` VARCHAR(255), IN `created_by_val` VARCHAR(100))   BEGIN

    INSERT INTO positions (position_name, created_by, created_at, status)
    SELECT 
        position_name_val, 
        created_by_val, 
        CURRENT_TIMESTAMP, 
        'active'
    WHERE 
        NOT EXISTS (
            SELECT 1 
            FROM positions
            WHERE position_name = position_name_val
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
    INSERT INTO region (region_name, regional_director, created_by, updated_by, status, competency_status)
    SELECT region_name_val, 
           IFNULL(regional_director_val, ''),  
           created_by_val, 
           created_by_val, 
           'active',
           'incomplete'
    FROM DUAL
    WHERE NOT EXISTS (
        SELECT 1 FROM region WHERE region_name = region_name_val
    ) AND (
        regional_director_val IS NULL OR regional_director_val = '' OR EXISTS (
            SELECT 1 FROM user WHERE name = regional_director_val
        )
    )
	LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_AddSCC` (IN `scc_name_val` VARCHAR(255), IN `region_id_val` INT, IN `province_or_huc_id_val` INT, IN `type_val` ENUM('section','city','cluster'), IN `scc_head_val` VARCHAR(255), IN `created_by_val` VARCHAR(255))   BEGIN

    INSERT INTO scc (scc_name, region_id, province_or_city_id, type, scc_head, created_by, updated_by, created_on, updated_on, status)
    SELECT 
        scc_name_val, 
        region_id_val, 
        province_or_huc_id_val, 
        type_val, 
        scc_head_val, 
        created_by_val, 
        created_by_val, 
        CURRENT_TIMESTAMP, 
        CURRENT_TIMESTAMP, 
        'active'
    WHERE 
        NOT EXISTS (
            SELECT 1 
            FROM scc 
            WHERE scc_name = scc_name_val AND region_id = region_id_val AND province_or_city_id = province_or_huc_id_val
        )
    LIMIT 1;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_AddUser` (IN `username_val` VARCHAR(255), IN `password_val` VARCHAR(255), IN `name_val` VARCHAR(255), IN `email_val` VARCHAR(255), IN `region_id_val` INT, IN `user_type_val` ENUM('superadmin','regional admin','regional director','asst regional director','provincial director','city director','div chief','asst div chief','cluster head','rank and file'), IN `education_val` VARCHAR(255), IN `mobile_number_val` VARCHAR(20), IN `division_id_val` INT, IN `position_val` VARCHAR(255), IN `sex_val` ENUM('male','female'), IN `date_of_birth_val` DATE, IN `province_or_huc_id_val` INT, IN `place_of_birth_val` VARCHAR(255), IN `address_val` VARCHAR(255), IN `municipality_id_val` INT, IN `scc_id_val` INT, IN `remarks_val` TEXT, IN `created_by_val` VARCHAR(100))   BEGIN
    INSERT INTO user (
        username, password, name, email, region_id, user_type, education, mobile_number,
        division_id, position, sex, date_of_birth, province_or_huc_id, place_of_birth,
        address, municipality_id, scc_id, status, remarks, created_on, updated_on, f_login, created_by
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
        'active', remarks_val, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1, created_by_val
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_ChangeMunicipalityStatus` (IN `municipality_id_val` INT, IN `status_val` ENUM('active','inactive'))   BEGIN
    UPDATE municipality
    SET 
        status = status_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
        municipality_id = municipality_id_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_changeProvinceStatus` (IN `id_val` INT, IN `status_val` ENUM('active','inactive'))   BEGIN
    UPDATE province_or_huc
    SET 
        status = status_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
    	province_or_city_id = id_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_changeRegionStatus` (IN `region_id_val` INT, IN `status_val` ENUM('active','inactive'))   BEGIN
    UPDATE region
    SET 
        status = status_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
    	region_id = region_id_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_changeSCCStatus` (IN `scc_id_val` INT, IN `status_val` ENUM('active','inactive'))   BEGIN
    UPDATE scc
    SET 
        status = status_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
    	scc_id = scc_id_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_Dashboard` ()   BEGIN
    
    SELECT COUNT(user_id) AS active_users_total
    FROM user
    WHERE status = 'active';
        
    SELECT COUNT(user_id) AS inactive_users_total
    FROM user
    WHERE status = 'inactive';
    
    SELECT COUNT(user_id) AS raters_total
    FROM user
    WHERE status = 'active' 
    AND user_type IN ('regional director','asst regional director','provincial director','city director','div chief','asst div chief','cluster head');
    
    SELECT COUNT(user_id) AS ratees_total
    FROM user
    WHERE status = 'active' 
    AND user_type IN ('regional admin','div chief','asst div chief','cluster head','rank and file');
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_DDGetAllProvinceByRegion` (IN `region_id_val` INT)   BEGIN
    SELECT 
        province_or_city_id,
        province_or_huc_name
    FROM 
        province_or_huc
    WHERE
    	status = 'active' AND region_id = region_id_val
    ORDER BY 
        province_or_city_id DESC;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_DisableMessage` (IN `mID_val` INT)   BEGIN
    UPDATE messages
    SET 
        status = 'inactive'
    WHERE 
        id = mID_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_DisablePosition` (IN `pID_val` INT)   BEGIN
    UPDATE positions
    SET 
        status = 'inactive'
    WHERE 
        id = pID_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_EnableMessage` (IN `mID_val` INT)   BEGIN
    UPDATE messages
    SET 
        status = 'active'
    WHERE 
        id = mID_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_EnablePosition` (IN `pID_val` INT)   BEGIN
    UPDATE positions
    SET 
        status = 'active'
    WHERE 
        id = pID_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetAllClusterByRegionAndProvince` (IN `region_id_val` INT, IN `province_id_val` INT)   BEGIN
	SELECT
       	s.scc_id,
        s.scc_name,
        s.region_id,
        s.province_or_city_id
    FROM 
        scc s
    LEFT JOIN 
        region r ON s.region_id = r.region_id 
    LEFT JOIN
    	province_or_huc p ON s.province_or_city_id = p.province_or_city_id
    WHERE 
        s.type = 'cluster'
    ORDER BY 
        scc_id DESC;

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetAllMessages` (IN `pageNo` INT, IN `pageSize` INT, IN `keyword` VARCHAR(255))   BEGIN
    SET pageNo = (pageNo - 1) * pageSize;

    SELECT 
    	id, 
        message, 
        created_by 
 		created_at,
        updated_by,
        updated_at,
        status
    FROM messages 
    WHERE 
        message LIKE CONCAT('%', keyword, '%')
    ORDER BY id DESC
    LIMIT pageSize OFFSET pageNo;

    SELECT COUNT(id) AS total
    FROM messages
    WHERE message LIKE CONCAT('%', keyword, '%');

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetAllMunicipality` (IN `pageNo` INT, IN `pageSize` INT, IN `keyword` VARCHAR(255))   BEGIN
    SET pageNo = (pageNo - 1) * pageSize;
    SELECT 
    	m.municipality_id,
        m.region_id,
        r.region_name,
        m.cluster_id,
        s.scc_name,
        p.province_or_huc_name,
        m.municipality_name,
        s.scc_head as head,
        m.created_by,
        m.updated_by,
        m.created_on,
        m.updated_on,
        m.status
    FROM municipality m
    JOIN
    	region r ON m.region_id = r.region_id
    JOIN
    	scc s ON m.cluster_id = s.scc_id
    JOIN
    	province_or_huc p ON m.province_or_city_id = p.province_or_city_id
    WHERE  (
        municipality_name LIKE CONCAT('%', keyword, '%') 
    )
    ORDER BY municipality_id DESC
    LIMIT pageSize OFFSET pageNo;

    -- Get the total number of regions that match the keyword
    SELECT COUNT(municipality_id) AS total
    FROM municipality m
    JOIN
    	region r ON m.region_id = r.region_id
    JOIN
    	scc s ON m.cluster_id = s.scc_id
    JOIN
    	province_or_huc p ON m.province_or_city_id = p.province_or_city_id
    WHERE (
        municipality_name LIKE CONCAT('%', keyword, '%')
    );

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetAllPositions` (IN `pageNo` INT, IN `pageSize` INT, IN `keyword` VARCHAR(255))   BEGIN
    SET pageNo = (pageNo - 1) * pageSize;

    SELECT 
    	id, 
        position_name, 
        created_by 
 		created_at,
        updated_by,
        updated_at,
        status
    FROM positions
    WHERE 
        position_name LIKE CONCAT('%', keyword, '%')
    ORDER BY id DESC
    LIMIT pageSize OFFSET pageNo;

    SELECT COUNT(id) AS total
    FROM positions
    WHERE position_name LIKE CONCAT('%', keyword, '%');

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetAllProvince` (IN `pageNo` INT, IN `pageSize` INT, IN `keyword` VARCHAR(255))   BEGIN
    SET pageNo = (pageNo - 1) * pageSize;

    SELECT 
        p.province_or_city_id, 
        p.province_or_huc_name, 
        p.region_id, 
        r.region_name,
        p.province_or_huc_director, 
        p.created_by, 
        p.updated_by, 
        p.created_on, 
        p.updated_on, 
        p.status
    FROM 
        province_or_huc p
    LEFT JOIN 
        region r ON p.region_id = r.region_id 
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
        province_or_huc p
    LEFT JOIN 
        region r ON p.region_id = r.region_id
    WHERE 
        province_or_huc_name LIKE CONCAT('%', keyword, '%') 
        OR province_or_huc_director LIKE CONCAT('%', keyword, '%');
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetAllRegions` (IN `pageNo` INT, IN `pageSize` INT, IN `keyword` VARCHAR(255))   BEGIN
    SET pageNo = (pageNo - 1) * pageSize;

    SELECT region_id, region_name, regional_director as regional_admin, created_on, created_by, updated_on, updated_by, status, competency_status
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetAllSCC` (IN `pageNo` INT, IN `pageSize` INT, IN `keyword` VARCHAR(255))   BEGIN
    SET pageNo = (pageNo - 1) * pageSize;

    SELECT 
        s.scc_id,
        s.region_id,
        r.region_name,
       	s.province_or_city_id,
        p.province_or_huc_name,
        s.type, 
        s.scc_name,
        s.scc_head, 
        s.created_by, 
        s.updated_by, 
        s.created_on, 
        s.updated_on, 
        s.status
    FROM 
        scc s
    LEFT JOIN 
        region r ON s.region_id = r.region_id 
    LEFT JOIN
    	province_or_huc p ON s.province_or_city_id = p.province_or_city_id
    WHERE 
        scc_name LIKE CONCAT('%', keyword, '%') 
        OR scc_head LIKE CONCAT('%', keyword, '%')
    ORDER BY 
        scc_id DESC
    LIMIT 
        pageSize OFFSET pageNo;

    SELECT 
        COUNT(scc_id) AS total
    FROM 
        scc s
    LEFT JOIN 
        region r ON s.region_id = r.region_id
    LEFT JOIN
    	province_or_huc p ON s.province_or_city_id = p.province_or_city_id
    WHERE 
        scc_name LIKE CONCAT('%', keyword, '%') 
        OR scc_head LIKE CONCAT('%', keyword, '%');
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetAllUsersByRegionID` (IN `region_id_val` INT)   BEGIN

    SELECT 
        user_id, 
        name
    FROM 
        user
    WHERE 
        region_id = region_id_val 
    ORDER BY 
        user_id DESC;
 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetAllUsersByRegionIDAndDivID` (IN `region_id_val` INT, IN `div_id` INT)   BEGIN

    SELECT 
        user_id, 
        name
    FROM 
        user
    WHERE 
        region_id = region_id_val AND division_id = div_id
    ORDER BY 
        user_id DESC;
 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetAllUsersByRegionIDAndMuniID` (IN `region_id_val` INT, IN `muni_id_val` INT)   BEGIN

    SELECT 
        user_id, 
        name
    FROM 
        user
    WHERE 
        region_id = region_id_val AND municipality_id = muni_id_val
    ORDER BY 
        user_id DESC;
 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetAllUsersByRegionIDAndProvID` (IN `region_id_val` INT, IN `prov_id` INT)   BEGIN

    SELECT 
        user_id, 
        name
    FROM 
        user
    WHERE 
        region_id = region_id_val AND province_or_huc_id = prov_id
    ORDER BY 
        user_id DESC;
 
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetMessageByID` (IN `mID` INT)   BEGIN
    SELECT 
    	id, 
        message, 
        created_by 
 		created_at,
        updated_by,
        updated_at,
        status
    FROM messages 
    WHERE 
        id = mID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetMunicipalityByID` (IN `municipality_id_val` INT)   BEGIN
    SELECT 
    	m.municipality_id,
        m.municipality_name,
        m.region_id,
        r.region_name,
    	m.cluster_id,
       	s.scc_name,
        s.scc_head,
       	m.province_or_city_id,
        p.province_or_huc_name,
        m.created_by,
        m.updated_by,
        m.created_on,
        m.updated_on,
        m.status
    FROM 
    	municipality m
    LEFT JOIN
    	region r ON m.region_id = r.region_id
    LEFT JOIN
    	province_or_huc p ON m.province_or_city_id = p.province_or_city_id
    LEFT JOIN
    	scc s ON m.cluster_id = s.scc_id
    WHERE m.municipality_id = municipality_id_val
    AND m.status = 'active';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetPositionByID` (IN `pID` INT)   BEGIN
    SELECT 
    	id, 
        position_name, 
        created_by 
 		created_at,
        updated_by,
        updated_at,
        status
    FROM positions 
    WHERE 
        id = pID;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetProvinceByID` (IN `id_val` INT)   BEGIN
    SELECT 
        p.province_or_city_id,
        p.province_or_huc_name,
        p.province_or_huc_director,
        p.status,
        r.region_name,
        p.created_by, 
        p.updated_by, 
        p.created_on, 
        p.updated_on
    FROM 
        province_or_huc p
    JOIN 
        region r ON p.region_id = r.region_id
    WHERE 
        p.province_or_city_id = id_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetRegionsByID` (IN `region_id_val` INT)   BEGIN
    SELECT region_id, region_name, regional_director, created_by, updated_by, created_on, updated_on, status
    FROM region
    WHERE region_id = region_id_val
    AND status = 'active';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_GetSCCByID` (IN `scc_id_val` INT)   BEGIN
    SELECT 
    	scc.scc_id, 
    	scc.region_id, 
        r.region_name,
        scc.province_or_city_id,
        p.province_or_huc_name,
        scc.type,
        scc.scc_name,
        scc.scc_head,
        scc.created_by,
        scc.updated_by,
        scc.created_on,
        scc.updated_on,
        scc.status
    FROM 
    	scc scc
    LEFT JOIN
    	region r ON scc.region_id = r.region_id
    LEFT JOIN
    	province_or_huc p ON scc.province_or_city_id = p.province_or_city_id
    WHERE scc.scc_id = scc_id_val
    AND scc.status = 'active';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_Login` (IN `username_val` VARCHAR(100))   BEGIN

SELECT password, username FROM `sadmin_user` WHERE username = username_val;

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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_UpdateClusterHead` (IN `scc_id_val` INT, IN `scc_head_val` VARCHAR(255), IN `updated_by_val` VARCHAR(255))   BEGIN

	UPDATE user SET user_type = 'rank and file'
    WHERE scc_id = scc_id_val and user_type  = 'cluster head' and name != scc_head_val;
    
    UPDATE scc
    SET 
        scc_head = scc_head_val,
        updated_by = updated_by_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
        scc_id = scc_id_val AND type = 'cluster';
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_UpdateDivisionChief` (IN `division_id_val` INT, IN `division_chief_val` VARCHAR(255), IN `updated_by_val` VARCHAR(255))   BEGIN

	UPDATE user SET user_type = 'rank and file'
    WHERE division_id = division_id_val and user_type  = 'div chief' and name != division_chief_val;
    
    UPDATE division
    SET 
        division_chief = division_chief_val,
        updated_by = updated_by_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
        division_id = division_id_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_UpdateMessage` (IN `mID_val` INT, IN `message_val` TEXT, IN `updated_by_val` VARCHAR(255))   BEGIN
    UPDATE messages
    SET 
        message = message_val,
        updated_by = updated_by_val,
        updated_at = CURRENT_TIMESTAMP
    WHERE 
        id = mID_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_UpdateMunicipality` (IN `municipality_id_val` INT, IN `region_id_val` INT, IN `scc_id_val` INT, IN `province_or_city_id_val` INT, IN `municipality_name_val` VARCHAR(255), IN `updated_by_val` VARCHAR(255))   BEGIN
    UPDATE municipality
    SET 
        municipality_name = municipality_name_val,
        region_id = region_id_val,
        cluster_id = scc_id_val,
        province_or_city_id = province_or_city_id_val,
        updated_by = updated_by_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
        municipality_id = municipality_id_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_UpdatePosition` (IN `pID_val` INT, IN `position_name_val` TEXT, IN `updated_by_val` VARCHAR(255))   BEGIN
    UPDATE positions
    SET 
        position_name = position_name_val,
        updated_by = updated_by_val,
        updated_at = CURRENT_TIMESTAMP
    WHERE 
        id = pID_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_UpdateProvince` (IN `province_id_val` INT, IN `region_id_val` INT, IN `province_name_val` VARCHAR(255), IN `province_director_val` VARCHAR(255), IN `updated_by_val` VARCHAR(255))   BEGIN
    UPDATE province_or_huc
    SET 
        province_or_huc_name = province_name_val,
        province_or_huc_director = province_director_val,
        region_id = region_id_val,
        updated_by = updated_by_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
        province_or_city_id = province_id_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_UpdateProvincialDirector` (IN `province_id_val` INT, IN `province_director_val` VARCHAR(255), IN `updated_by_val` VARCHAR(255))   BEGIN

	UPDATE user SET user_type = 'rank and file'
    WHERE province_or_huc_id = province_id_val and user_type  = 'provincial director' and name != province_director_val;
    
    UPDATE user SET user_type = 'rank and file'
    WHERE province_or_huc_id = province_id_val and user_type  = 'city director' and name != province_director_val;
    
    UPDATE province_or_huc
    SET 
        province_or_huc_director = province_director_val,
        updated_by = updated_by_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
        province_or_city_id = province_id_val;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_UpdateRegionAdmin` (IN `region_id_val` INT, IN `regional_director_val` VARCHAR(255), IN `updated_by_val` VARCHAR(255))   BEGIN
	UPDATE user SET user_type = 'rank and file'
    WHERE region_id = region_id_val and user_type  = 'regional admin' and name != regional_director_val;
    
    UPDATE region
    SET 
        regional_director = regional_director_val,
        updated_by = updated_by_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
        region_id = region_id_val;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SuperAdmin_UpdateSCC` (IN `scc_id_val` INT, IN `scc_name_val` VARCHAR(255), IN `scc_head_val` VARCHAR(255), IN `type_value` ENUM('section','city','cluster'), IN `region_id_val` INT, IN `province_or_city_id_val` INT, IN `updated_by_val` VARCHAR(255))   BEGIN
    UPDATE scc
    SET 
        scc_name = scc_name_val,
        scc_head = scc_head_val,
        type = type_value,
        region_id = region_id_val,
        province_or_city_id = province_or_city_id_val,
        updated_by = updated_by_val,
        updated_on = CURRENT_TIMESTAMP
    WHERE 
        scc_id = scc_id_val;
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
(2, 1, 'Division 2', ' ', 'super_admin', 'super_admin', '2024-11-20 10:39:34', '2024-11-20 10:39:34', 'active'),
(3, 2, 'Division 2', ' ', 'super_admin', 'super_admin', '2025-01-24 03:11:21', '2025-01-24 03:11:21', 'active'),
(4, 2, 'Division 23', 'Ivan Keeling', 'super_admin', 'super_admin', '2025-02-12 12:31:27', '2025-02-12 12:36:53', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_by` varchar(100) DEFAULT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('inactive','active') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `message`, `created_by`, `updated_by`, `created_at`, `updated_at`, `status`) VALUES
(1, 'Hi Team', 'super_admin', 'super_admin', '2025-02-13 13:10:06', '2025-02-13 13:42:37', 'active'),
(2, 'Good Day All', 'super_admin', NULL, '2025-02-13 13:23:17', '2025-02-13 13:23:17', 'active');

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

--
-- Dumping data for table `municipality`
--

INSERT INTO `municipality` (`municipality_id`, `region_id`, `cluster_id`, `province_or_city_id`, `municipality_name`, `municipality_head`, `created_by`, `updated_by`, `created_on`, `updated_on`, `status`) VALUES
(3, 1, 3, 2, 'municipalityName', 'municipalityHead', 'Just', 'Just', '2025-01-24 10:40:28', '2025-01-24 10:40:28', 'active'),
(4, 1, 3, 2, 'M 6', 'municipalityHead', 'Just', 'super_admin', '2025-01-27 04:56:44', '2025-01-27 07:23:51', 'active'),
(5, 1, 3, 2, 'Muni 7', NULL, 'Just', 'Just', '2025-01-27 07:32:06', '2025-01-27 07:32:06', 'active');

-- --------------------------------------------------------

--
-- Table structure for table `positions`
--

CREATE TABLE `positions` (
  `id` int(11) NOT NULL,
  `position_name` varchar(255) NOT NULL,
  `created_by` varchar(255) NOT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('inactive','active') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `positions`
--

INSERT INTO `positions` (`id`, `position_name`, `created_by`, `updated_by`, `created_at`, `updated_at`, `status`) VALUES
(1, 'Team Lead', 'super_admin', 'super_admin', '2025-02-13 14:13:49', '2025-02-13 14:28:39', 'active'),
(2, 'Chief', 'super_admin', NULL, '2025-02-13 14:18:23', '2025-02-13 14:18:23', 'active');

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
(2, 1, 'Province 6', 'Claudia Towne', 'super_admin', 'super_admin', '2024-11-23 06:57:01', '2025-02-12 11:57:13', 'active'),
(3, 1, 'City 1', 'Mrs. Ann Kub', 'super_admin', 'super_admin', '2025-02-12 12:26:53', '2025-02-12 12:28:45', 'active');

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
  `competency_status` enum('completed','incomplete','failed') NOT NULL DEFAULT 'incomplete',
  `created_by` varchar(255) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `region`
--

INSERT INTO `region` (`region_id`, `region_name`, `regional_director`, `created_on`, `updated_on`, `status`, `competency_status`, `created_by`, `updated_by`) VALUES
(1, 'Region 6', 'Luis Lowe PhD', '2024-11-20 07:27:10', '2025-02-12 12:19:18', 'inactive', 'incomplete', 'super_admin', 'super_admin'),
(2, 'Region 2', ' ', '2024-11-20 07:27:37', '2024-12-19 07:12:23', 'active', 'incomplete', 'super_admin', 'super_admin'),
(3, 'Region 3', ' ', '2024-11-20 07:29:10', '2024-12-19 07:12:31', 'active', 'incomplete', 'super_admin', 'super_admin'),
(4, 'Cyril Love Camille S', 'Jose Rizal', '2024-12-19 07:23:52', '2024-12-19 07:23:52', 'active', 'incomplete', 'super_admin', 'super_admin'),
(5, 'Try Lang Po', 'Juan Dela Cruz', '2024-12-19 07:27:55', '2024-12-19 07:27:55', 'active', 'incomplete', 'super_admin', 'super_admin'),
(6, 'Try 2 ', 'Jose Rizal', '2024-12-19 07:30:41', '2024-12-19 07:30:41', 'active', 'incomplete', 'super_admin', 'super_admin'),
(7, 'Region INC', 'Jose Rizal', '2024-12-19 07:32:00', '2024-12-19 07:32:00', 'active', 'incomplete', 'super_admin', 'super_admin'),
(8, 'Region 10', 'John Doe', '2024-12-19 07:40:35', '2024-12-19 07:40:35', 'active', 'incomplete', 'super_admin', 'super_admin'),
(9, 'Region 11', ' ', '2024-12-19 07:51:01', '2024-12-19 07:51:01', 'active', 'incomplete', 'super_admin', 'super_admin'),
(10, 'Region 12', '', '2024-12-19 07:51:08', '2024-12-19 07:51:08', 'active', 'incomplete', 'super_admin', 'super_admin'),
(11, 'Region 13', 'John Doe', '2024-12-19 07:51:40', '2024-12-19 07:51:40', 'active', 'incomplete', 'super_admin', 'super_admin'),
(12, 'Region Checker Test', '', '2024-12-19 07:54:18', '2024-12-19 07:54:18', 'active', 'incomplete', 'super_admin', 'super_admin'),
(13, 'Region Checker 2', '', '2024-12-19 07:59:59', '2024-12-19 07:59:59', 'active', 'incomplete', 'super_admin', 'super_admin'),
(14, 'A Hey Region Try', '', '2024-12-19 08:07:31', '2024-12-19 08:07:31', 'active', 'incomplete', 'super_admin', 'super_admin'),
(15, 'AA Hey Region', '', '2024-12-19 08:08:20', '2024-12-19 08:08:20', 'active', 'incomplete', 'super_admin', 'super_admin'),
(16, '1 Region Try', '', '2024-12-19 08:48:48', '2024-12-19 08:48:48', 'active', 'incomplete', 'super_admin', 'super_admin'),
(17, '1 1 Region Try', '', '2024-12-19 08:55:09', '2024-12-19 08:55:09', 'active', 'incomplete', 'super_admin', 'super_admin'),
(18, '111 Region Try langs', '', '2024-12-19 09:36:49', '2024-12-19 09:36:49', 'active', 'incomplete', 'super_admin', 'super_admin'),
(19, '1111 Region Added', '', '2024-12-19 09:40:18', '2024-12-19 09:40:18', 'active', 'incomplete', 'super_admin', 'super_admin'),
(20, '11111 Region Addings', '', '2024-12-19 09:41:00', '2024-12-19 09:41:00', 'active', 'incomplete', 'super_admin', 'super_admin'),
(21, '111111Try Region', '', '2024-12-19 09:42:47', '2024-12-19 09:42:47', 'active', 'incomplete', 'super_admin', 'super_admin'),
(22, '1111111 Region try 7', '', '2024-12-19 09:45:54', '2024-12-19 09:45:54', 'active', 'incomplete', 'super_admin', 'super_admin'),
(23, '11111111 Region Try 8', '', '2024-12-19 09:47:45', '2024-12-19 09:47:45', 'active', 'incomplete', 'super_admin', 'super_admin'),
(24, '111111111Region 9 try', '', '2024-12-19 09:48:06', '2024-12-19 09:48:06', 'active', 'incomplete', 'super_admin', 'super_admin'),
(25, '1111111111 Region 10x', '', '2024-12-19 09:49:43', '2024-12-19 09:49:43', 'active', 'incomplete', 'super_admin', 'super_admin'),
(26, '11111111111 Region 11x', '', '2024-12-19 09:51:08', '2024-12-19 09:51:08', 'active', 'incomplete', 'super_admin', 'super_admin'),
(27, 'hey', '', '2024-12-19 09:51:56', '2024-12-19 09:51:56', 'active', 'incomplete', 'super_admin', 'super_admin'),
(28, 'hey hey', '', '2024-12-19 09:52:16', '2024-12-19 09:52:16', 'active', 'incomplete', 'super_admin', 'super_admin'),
(29, 'heyheyhey', '', '2024-12-19 09:53:18', '2024-12-19 09:53:18', 'active', 'incomplete', 'super_admin', 'super_admin'),
(30, 'heyheyheyhey', '', '2024-12-19 09:54:31', '2024-12-19 09:54:31', 'active', 'incomplete', 'super_admin', 'super_admin'),
(31, 'heyheyheyheyhey', '', '2024-12-19 09:55:51', '2024-12-19 09:55:51', 'active', 'incomplete', 'super_admin', 'super_admin'),
(32, 'hebkjarkjarkjaer', '', '2024-12-19 09:57:30', '2024-12-19 09:57:30', 'active', 'incomplete', 'super_admin', 'super_admin'),
(33, 'aeajweajwoeiuaowie', '', '2024-12-19 09:58:33', '2024-12-19 09:58:33', 'active', 'incomplete', 'super_admin', 'super_admin'),
(34, 'kndvkjxkvnflbjdpgo', '', '2024-12-19 09:58:48', '2024-12-19 09:58:48', 'active', 'incomplete', 'super_admin', 'super_admin'),
(35, 'a;lkfe;osjdgpi', '', '2024-12-19 09:59:11', '2024-12-19 09:59:11', 'active', 'incomplete', 'super_admin', 'super_admin'),
(36, 'jahkjeahwekjawe', '', '2024-12-19 09:59:22', '2024-12-19 09:59:22', 'active', 'incomplete', 'super_admin', 'super_admin'),
(37, '.aweqwe', '', '2024-12-19 09:59:36', '2024-12-19 09:59:36', 'active', 'incomplete', 'super_admin', 'super_admin'),
(38, 'kajwlekq', '', '2024-12-19 09:59:57', '2024-12-19 09:59:57', 'active', 'incomplete', 'super_admin', 'super_admin'),
(39, 'jelae', '', '2024-12-19 10:00:19', '2024-12-19 10:00:19', 'active', 'incomplete', 'super_admin', 'super_admin'),
(40, 'heyjajaja', '', '2024-12-19 10:04:35', '2024-12-19 10:04:35', 'active', 'incomplete', 'super_admin', 'super_admin'),
(41, 'Region 69', '', '2025-01-24 14:37:04', '2025-01-24 14:37:04', 'active', 'incomplete', 'super_admin', 'super_admin');

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

--
-- Dumping data for table `scc`
--

INSERT INTO `scc` (`scc_id`, `region_id`, `province_or_city_id`, `type`, `scc_name`, `scc_head`, `created_by`, `updated_by`, `created_on`, `updated_on`, `status`) VALUES
(3, 1, 2, 'cluster', 'Cluster 6', 'Mr. Holly McClure', 'super_admin', 'super_admin', '2025-01-06 08:40:59', '2025-02-12 12:43:24', 'active'),
(4, 1, 2, 'section', 'Section 11', ' ', 'super_admin', 'super_admin', '2025-02-11 06:43:28', '2025-02-11 06:43:28', 'active');

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
  `created_by` varchar(100) NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_on` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `f_login` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `username`, `password`, `name`, `email`, `region_id`, `user_type`, `education`, `mobile_number`, `division_id`, `position`, `sex`, `date_of_birth`, `province_or_huc_id`, `place_of_birth`, `address`, `municipality_id`, `scc_id`, `status`, `remarks`, `created_by`, `created_on`, `updated_on`, `f_login`) VALUES
(6, 'john_doe', '$2b$12$W/VSgakupeS/QCmj6wvvk.spqVA8cXbaeqXQMJkeJOucCKPqsouh2', 'John Doe', 'kim@sitesphil.com', 1, 'regional director', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Director', 'male', '1990-01-01', NULL, 'New York', '123 Main St, New York, NY 10001', NULL, NULL, 'active', 'No remarks', '', '2024-11-22 07:19:56', '2024-11-23 03:17:18', 1),
(7, 'dev', '$2b$12$ytWMHplAidiPl39M8ol2keu7hY/FXlP.CnmTv7y2m8r8CSC7R05ji', 'John Doe', 'kim@sitesphil.com', NULL, 'regional director', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Director', 'male', '1990-01-01', NULL, 'New York', '123 Main St, New York, NY 10001', NULL, NULL, 'active', 'No remarks', '', '2024-11-22 08:24:06', '2024-11-22 08:24:06', 1),
(16, 'test', 'test', NULL, NULL, NULL, 'superadmin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'inactive', NULL, '', '2024-12-09 08:07:06', '2025-02-13 15:10:46', 1),
(18, '1', '2', NULL, NULL, NULL, 'superadmin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '2024-12-09 09:21:07', '2024-12-09 09:21:07', 1),
(19, 'super_admin', '$2b$12$LMfyQsgO.qcTF793GDYyJO7NzWC1Ol5BtkCeygbFceV0Bj1eg6.ua', NULL, NULL, NULL, 'superadmin', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', '2024-12-09 09:22:38', '2024-12-09 09:22:38', 1),
(23, 'Cleo58', '$2b$12$0gnTA.wKOBFWvJcc2G5nH.cg3shXa9SYsaaSZXprrstVeCTu1sL3S', 'Al Brown', 'kim@sitesphil.com', 1, 'rank and file', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Outcast', 'male', '1990-01-01', 2, 'Lewis Fords', '832 Victoria Plaza', NULL, 4, 'active', 'No remarks', 'super_admin', '2025-02-11 09:08:32', '2025-02-12 11:52:48', 1),
(24, 'Clement.Harvey', '$2b$12$d5Cq5DKyphBObnz9wu0AlOXp5LqMq6IXzdgts.TAOSZf1kj8G/KkS', 'Cornelius Lockman', 'kim@sitesphil.com', 1, 'rank and file', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Outcast', 'male', '1990-01-01', 2, 'Faustino Inlet', '7371 Jast Drive', NULL, 4, 'active', 'No remarks', '[object Object]', '2025-02-12 11:42:03', '2025-02-12 11:52:48', 1),
(25, 'Amiya_Bogisich', '$2b$12$AWAVWsksKwTN3yceaUZkUOOwOxtfO2lr8TuFVdP6xUHnLoYBU89GW', 'Sammy Runolfsdottir', 'kim@sitesphil.com', 1, 'rank and file', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Outcast', 'male', '1990-01-01', 2, 'Erdman Fall', '32729 Stroman Flat', NULL, 4, 'active', 'No remarks', '[object Object]', '2025-02-12 11:42:33', '2025-02-12 11:52:48', 1),
(26, 'Nickolas.Ankunding', '$2b$12$bqquuI7k2ZHLA1HL8us6xuwx8kcA4dpvQVQ1RlqC4EMH32djACKe6', 'Lee Haag', 'kim@sitesphil.com', 1, 'rank and file', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Outcast', 'male', '1990-01-01', 2, 'Maya Ridge', '338 Zakary Forges', NULL, 4, 'active', 'No remarks', 'super_admin', '2025-02-12 11:42:58', '2025-02-12 11:52:48', 1),
(27, 'Clinton27', '$2b$12$WBMlNssYkrSiAMBmVHWgH.7Jrn4BzrTo8kaTI2SR4MDhHg6xFVc0W', 'Priscilla Howell', 'kim@sitesphil.com', 1, 'rank and file', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Outcast', 'male', '1990-01-01', 2, 'Wiegand Drive', '2234 Laurence Dale', NULL, 4, 'active', 'No remarks', 'super_admin', '2025-02-12 11:51:44', '2025-02-12 11:52:48', 1),
(28, 'Ian74', '$2b$12$C3EGWKMRNiamzHR4kipkkeBdq4xdQdmxBALVHDmtB64DakGTKjJvK', 'Hugo Blanda', 'kim@sitesphil.com', 1, 'rank and file', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Outcast', 'male', '1990-01-01', 2, 'Collier Throughway', '89582 Werner Radial', NULL, 4, 'active', 'No remarks', 'super_admin', '2025-02-12 11:52:48', '2025-02-12 11:52:48', 1),
(29, 'Bobby49', '$2b$12$AvsOcf1vV7xoPvQ3VKDvj.GibvHZuLU2sYBNod6W9hXQK8CvTNkui', 'Guadalupe Mayer', 'kim@sitesphil.com', 1, 'rank and file', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Outcast', 'male', '1990-01-01', 2, 'Hamill Streets', '8505 Okuneva Pine', NULL, 4, 'inactive', 'No remarks', 'super_admin', '2025-02-12 11:53:25', '2025-02-13 15:11:10', 1),
(30, 'Brenda.Jaskolski31', '$2b$12$4jpWiO43A5VNtEDxX9gx2.fcgTXU2B8ehQJcu4wAfkZDRCzfZsG8m', 'Mrs. Noel Blick', 'kim@sitesphil.com', 1, 'rank and file', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Outcast', 'male', '1990-01-01', 2, 'Cormier Station', '1213 Halle Streets', NULL, 4, 'active', 'No remarks', 'super_admin', '2025-02-12 11:56:54', '2025-02-12 11:57:13', 1),
(31, 'Modesto74', '$2b$12$1WFIuNBgTn9ljN5qYvxnVecL0KJubcAmfJqMVjyyuwzrHaLgpFQFG', 'Claudia Towne', 'kim@sitesphil.com', 1, 'provincial director', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Outcast', 'male', '1990-01-01', 2, 'Jeremie Avenue', '8504 Renner Ridge', NULL, 4, 'active', 'No remarks', 'super_admin', '2025-02-12 11:57:13', '2025-02-12 11:57:13', 1),
(37, 'Harley.Heaney', '$2b$12$96mGOz9CsQlssLcw7NGdoujCRdhRtlscVY.Yjv4.Dp0FdA4ZyQUuq', 'Luis Lowe PhD', 'kim@sitesphil.com', 1, 'regional admin', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Outcast', 'male', '1990-01-01', 2, 'Boyle Squares', '126 Karolann Turnpike', NULL, 4, 'active', 'No remarks', 'super_admin', '2025-02-12 12:19:18', '2025-02-12 12:19:18', 1),
(38, 'Caterina.Ledner20', '$2b$12$bwxXrF1gJ.IFURWdFPAj0.SRnvFa1WigTX4BzTeA1DUbaDo66LrLu', 'Marie Schaefer', 'kim@sitesphil.com', 1, 'rank and file', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Outcast', 'male', '1990-01-01', 3, 'Collier Cove', '86460 Haley Park', NULL, 4, 'active', 'No remarks', 'super_admin', '2025-02-12 12:28:05', '2025-02-12 12:28:45', 1),
(39, 'Idell.Lehner75', '$2b$12$WJH2zdln73cQfviaVY0rO..4zLC7PY0YBAL.2xGgAVaqwx4uCtfee', 'Anna Rath', 'kim@sitesphil.com', 1, 'rank and file', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Outcast', 'male', '1990-01-01', 3, 'Trever Freeway', '16338 Zulauf Heights', NULL, 4, 'active', 'No remarks', 'super_admin', '2025-02-12 12:28:27', '2025-02-12 12:28:45', 1),
(40, 'Jeramy67', '$2b$12$ZDHhLqo6wZRXMPQeaYzNi.VA14eJxPK6iXoK/tihu2qDus4QmAasa', 'Mrs. Ann Kub', 'kim@sitesphil.com', 1, 'city director', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Outcast', 'male', '1990-01-01', 3, 'Norbert Island', '849 Yost Radial', NULL, 4, 'active', 'No remarks', 'super_admin', '2025-02-12 12:28:45', '2025-02-12 12:28:45', 1),
(43, 'Douglas_Mann60', '$2b$12$0wRH/NrB6/fKCwvQ31jcdeFsU5V7DdTBPvI87Bc2AV6CM85H/5Gtm', 'Ms. Andy Dickens', 'kim@sitesphil.com', 2, 'rank and file', 'Bachelor\'s Degree in Computer Science', '0934567890', 4, 'Outcast', 'male', '1990-01-01', NULL, 'Emmett Lodge', '90069 Dallin Prairie', NULL, NULL, 'active', 'No remarks', 'super_admin', '2025-02-12 12:35:23', '2025-02-12 12:36:53', 1),
(44, 'Lydia.Bergstrom', '$2b$12$YKFwhRc4yv2en4MJyLCqRehHLLvziRYRce6HYF6G8QxOcgM4tVqEm', 'Ivan Keeling', 'kim@sitesphil.com', 2, 'div chief', 'Bachelor\'s Degree in Computer Science', '0934567890', 4, 'Outcast', 'male', '1990-01-01', NULL, 'Gianni Parks', '2632 Heath Points', NULL, NULL, 'active', 'No remarks', 'super_admin', '2025-02-12 12:36:53', '2025-02-12 12:36:53', 1),
(45, 'Dandre_Hodkiewicz', '$2b$12$xvN1i82V2lDALia13ubuR.QGJfDkq2q/fZQ13hGZJ8nGgkffHNOf2', 'Elijah Schamberger', 'kim@sitesphil.com', 1, 'rank and file', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Outcast', 'male', '1990-01-01', 2, 'Mckenna Spring', '232 Erick Way', 3, 3, 'active', 'No remarks', 'super_admin', '2025-02-12 12:43:06', '2025-02-13 05:38:48', 1),
(46, 'Lura_Grimes6', '$2b$12$k3rEHeUfI24Xy9sALWpL..1G3b4LOKmC80OOOzaNdnlDtmdsXWhDi', 'Mr. Holly McClure', 'kim@sitesphil.com', 1, 'cluster head', 'Bachelor\'s Degree in Computer Science', '0934567890', NULL, 'Outcast', 'male', '1990-01-01', 2, 'Maeve Stravenue', '50853 Ashley Field', NULL, 3, 'active', 'No remarks', 'super_admin', '2025-02-12 12:43:24', '2025-02-12 12:43:24', 1);

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
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `municipality`
--
ALTER TABLE `municipality`
  ADD PRIMARY KEY (`municipality_id`),
  ADD KEY `region_id` (`region_id`),
  ADD KEY `cluster_id` (`cluster_id`),
  ADD KEY `province_or_city_id` (`province_or_city_id`);

--
-- Indexes for table `positions`
--
ALTER TABLE `positions`
  ADD PRIMARY KEY (`id`);

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
  MODIFY `division_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `municipality`
--
ALTER TABLE `municipality`
  MODIFY `municipality_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `positions`
--
ALTER TABLE `positions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `province_or_huc`
--
ALTER TABLE `province_or_huc`
  MODIFY `province_or_city_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `region`
--
ALTER TABLE `region`
  MODIFY `region_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `sadmin_user`
--
ALTER TABLE `sadmin_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `scc`
--
ALTER TABLE `scc`
  MODIFY `scc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

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
