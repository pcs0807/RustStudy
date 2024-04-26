-- --------------------------------------------------------
-- 호스트:                          127.0.0.1
-- 서버 버전:                        11.3.2-MariaDB - mariadb.org binary distribution
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- drawingautomation 데이터베이스 구조 내보내기
CREATE DATABASE IF NOT EXISTS `drawingautomation` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `drawingautomation`;

-- 프로시저 drawingautomation.CREATE_DWGSETTING 구조 내보내기
DELIMITER //
CREATE PROCEDURE `CREATE_DWGSETTING`(
	IN `_dwgName` TEXT,
	IN `_jsonName` TEXT,
	IN `_dwgTitle` TEXT,
	IN `_dwgDescription` TEXT
)
BEGIN
	SET @currentDate = RIGHT(REPLACE(CURDATE(),"-",""),6);
	SET @currentTime = NOW();
	
	SET @dwgfileKey = CONCAT(@currentDate, LPAD(CAST((SELECT fileSerial FROM fileinfo ORDER BY fileSerial DESC LIMIT 1) + 1 AS CHAR), 8, '0'));
	
	INSERT INTO fileinfo 
	(fileKey, fileName, filePath, fileInstim, fileCnltim, fileCancel) 
	VALUES 
	(@dwgfileKey, _dwgName, '/path/to/file/example_file.dwg', @currentTime, '', FALSE);
	
	
	SET @jsonFileKey = CONCAT(@currentDate, LPAD(CAST((SELECT fileSerial FROM fileinfo ORDER BY fileSerial DESC LIMIT 1) + 1 AS CHAR), 8, '0'));
	
	INSERT INTO fileinfo 
	(fileKey, fileName, filePath, fileInstim, fileCnltim, fileCancel) 
	VALUES 
	(@jsonFileKey, _jsonName, '/path/to/file/example_file.json', @currentTime, '', FALSE);
	
	SET @dwgKey = CONCAT(@currentDate, LPAD(CAST((SELECT dwgSerial FROM dwgsetting ORDER BY dwgSerial DESC LIMIT 1) + 1 AS CHAR), 8, '0'));
	
	INSERT INTO dwgsetting 
	(dwgKey, dwgTitle, dwgDescription, dwgFileKey, jsonFileKey, dwgInstim, dwgCnltim, dwgCancel) 
	VALUES 
	(@dwgKey, _dwgTitle, _dwgDescription, @dwgfileKey, @jsonFileKey, @currentTime, '', FALSE);
	
END//
DELIMITER ;

-- 테이블 drawingautomation.dependinfo 구조 내보내기
CREATE TABLE IF NOT EXISTS `dependinfo` (
  `dpSerial` int(11) NOT NULL AUTO_INCREMENT,
  `dpDwgSetKey` char(14) NOT NULL,
  `dpDesignKey` char(14) NOT NULL,
  `dpInstim` char(19) NOT NULL DEFAULT '',
  `dpCnltim` char(19) DEFAULT NULL,
  `dpCancel` tinyint(1) NOT NULL,
  PRIMARY KEY (`dpSerial`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 drawingautomation.dependinfo:~2 rows (대략적) 내보내기
INSERT INTO `dependinfo` (`dpSerial`, `dpDwgSetKey`, `dpDesignKey`, `dpInstim`, `dpCnltim`, `dpCancel`) VALUES
	(1, '1234', '1000', '2024-04-25 13:46:13', '2024-04-25 13:46:14', 0),
	(2, '1234', '1001', '2024-04-25 13:46:13', '2024-04-25 13:46:14', 0);

-- 테이블 drawingautomation.designdetail 구조 내보내기
CREATE TABLE IF NOT EXISTS `designdetail` (
  `dsdSerial` int(11) NOT NULL AUTO_INCREMENT,
  `dsdKey` char(14) NOT NULL,
  `dsdName` varchar(50) NOT NULL,
  `dsdDescription` text DEFAULT NULL,
  `dsdValue` text NOT NULL,
  `dsdinstim` char(19) NOT NULL DEFAULT '',
  `dsdCnltim` char(19) DEFAULT NULL,
  `dsdCancel` tinyint(1) NOT NULL,
  PRIMARY KEY (`dsdSerial`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 drawingautomation.designdetail:~4 rows (대략적) 내보내기
INSERT INTO `designdetail` (`dsdSerial`, `dsdKey`, `dsdName`, `dsdDescription`, `dsdValue`, `dsdinstim`, `dsdCnltim`, `dsdCancel`) VALUES
	(1, '1000', 'VAR1', NULL, '123', '2024-04-25 13:42:45', '2024-04-25 13:42:46', 0),
	(2, '1000', 'VAR2', NULL, '100X100', '2024-04-25 13:43:02', '2024-04-25 13:43:03', 0),
	(3, '1001', 'BP01', NULL, '100', '2024-04-25 13:47:14', '2024-04-25 13:47:15', 0),
	(4, '1001', 'BP02', NULL, '300', '2024-04-25 13:47:31', '2024-04-25 13:47:32', 0);

-- 테이블 drawingautomation.designmaster 구조 내보내기
CREATE TABLE IF NOT EXISTS `designmaster` (
  `dsmSerial` int(11) NOT NULL AUTO_INCREMENT,
  `dsmKey` char(14) NOT NULL,
  `dsmVersion` char(10) NOT NULL,
  `dsmInstim` char(19) NOT NULL DEFAULT '0',
  `dsmCnltim` char(19) DEFAULT NULL,
  `dsmCancel` tinyint(1) NOT NULL,
  PRIMARY KEY (`dsmSerial`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 drawingautomation.designmaster:~2 rows (대략적) 내보내기
INSERT INTO `designmaster` (`dsmSerial`, `dsmKey`, `dsmVersion`, `dsmInstim`, `dsmCnltim`, `dsmCancel`) VALUES
	(1, '1000', '1.0', '2024-04-25 13:42:02', '2024-04-25 13:42:02', 0),
	(2, '1001', '1.0', '2024-04-25 13:46:32', '2024-04-25 13:46:33', 0);

-- 테이블 drawingautomation.dwgsetting 구조 내보내기
CREATE TABLE IF NOT EXISTS `dwgsetting` (
  `dwgSerial` int(11) NOT NULL AUTO_INCREMENT,
  `dwgKey` char(14) NOT NULL,
  `dwgTitle` text NOT NULL,
  `dwgDescription` text DEFAULT NULL,
  `dwgFileKey` char(14) NOT NULL,
  `jsonFileKey` char(14) DEFAULT NULL,
  `dwgInstim` char(19) NOT NULL DEFAULT '',
  `dwgCnltim` char(19) DEFAULT NULL,
  `dwgCancel` tinyint(1) NOT NULL,
  PRIMARY KEY (`dwgSerial`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 drawingautomation.dwgsetting:~25 rows (대략적) 내보내기
INSERT INTO `dwgsetting` (`dwgSerial`, `dwgKey`, `dwgTitle`, `dwgDescription`, `dwgFileKey`, `jsonFileKey`, `dwgInstim`, `dwgCnltim`, `dwgCancel`) VALUES
	(1, '1234', '테스트셋팅', '테스트입니다.', '100', '101', '2024-04-25 13:43:37', '2024-04-25 13:43:38', 0),
	(2, '2404260', 'Example DWG Title', 'This is an example description.', '2404266', '2404267', '2024-04-26 14:51:24', '', 0),
	(3, '2404260', 'Example DWG Title', 'This is an example description.', '24042600000012', '24042600000013', '2024-04-26 14:57:23', '', 0),
	(4, '2404260', 'Example DWG Title', 'This is an example description.', '24042600000014', '24042600000015', '2024-04-26 14:58:16', '', 0),
	(5, '2404260', 'Example DWG Title', 'This is an example description.', '24042600000016', '24042600000017', '2024-04-26 14:58:20', '', 0),
	(6, '2404260', 'Example DWG Title', 'This is an example description.', '24042600000018', '24042600000019', '2024-04-26 14:59:21', '', 0),
	(7, '2404260', 'Example DWG Title', 'This is an example description.', '24042600000021', '24042600000022', '2024-04-26 15:01:58', '', 0),
	(8, '2404260', 'Example DWG Title', 'This is an example description.', '24042600000023', '24042600000024', '2024-04-26 15:03:08', '', 0),
	(9, '2404260', 'Example DWG Title', 'This is an example description.', '24042600000025', '24042600000026', '2024-04-26 15:13:24', '', 0),
	(10, '2404260', 'Example DWG Title', 'This is an example description.', '24042600000027', '24042600000028', '2024-04-26 15:13:28', '', 0),
	(11, '24042600000011', 'Example DWG Title', 'This is an example description.', '24042600000029', '24042600000030', '2024-04-26 15:15:16', '', 0),
	(12, '24042600000012', 'Example DWG Title', 'This is an example description.', '24042600000031', '24042600000032', '2024-04-26 15:15:19', '', 0),
	(13, '24042600000013', 'Example DWG Title', 'This is an example description.', '24042600000033', '24042600000034', '2024-04-26 15:15:23', '', 0),
	(14, '24042600000014', 'Example DWG Title', 'This is an example description.', '24042600000035', '24042600000036', '2024-04-26 15:28:13', '', 0),
	(15, '24042600000015', 'Example DWG Title', 'This is an example description.', '24042600000037', '24042600000038', '2024-04-26 15:31:11', '', 0),
	(16, '24042600000016', 'Example DWG Title', 'This is an example description.', '24042600000039', '24042600000040', '2024-04-26 15:35:03', '', 0),
	(17, '24042600000017', 'Example DWG Title', 'This is an example description.', '24042600000041', '24042600000042', '2024-04-26 15:37:53', '', 0),
	(18, '24042600000018', 'Example DWG Title', 'This is an example description.', '24042600000043', '24042600000044', '2024-04-26 16:55:23', '', 0),
	(19, '24042600000019', 'Example DWG Title', 'This is an example description.', '24042600000045', '24042600000046', '2024-04-26 16:55:32', '', 0),
	(20, '24042600000020', 'Example DWG Title', 'This is an example description.', '24042600000047', '24042600000048', '2024-04-26 17:25:49', '', 0),
	(21, '24042600000021', 'Example DWG Title', 'This is an example description.', '24042600000049', '24042600000050', '2024-04-26 17:26:31', '', 0),
	(22, '24042600000022', 'Example DWG Title', 'This is an example description.', '24042600000051', '24042600000052', '2024-04-26 17:27:00', '', 0),
	(23, '24042600000023', '123', 'novel', '24042600000053', '24042600000054', '2024-04-26 18:08:58', '', 0),
	(24, '24042600000024', '123', 'novel', '24042600000055', '24042600000056', '2024-04-26 18:09:00', '', 0),
	(25, '24042600000025', '123', 'novel', '24042600000057', '24042600000058', '2024-04-26 18:09:00', '', 0),
	(26, '24042600000026', '123', 'novel', '24042600000059', '24042600000060', '2024-04-26 18:11:33', '', 0),
	(27, '24042600000027', '123', 'novel', '24042600000061', '24042600000062', '2024-04-26 18:16:57', '', 0),
	(28, '24042600000028', '제목', '설명', '24042600000063', '24042600000064', '2024-04-26 18:27:29', '', 0),
	(29, '24042600000029', '혹시 들어갔나?', '설명', '24042600000065', '24042600000066', '2024-04-26 18:27:58', '', 0),
	(30, '24042600000030', '김주노', 'ㄶㅇㅎㄴㅇㅇㅎㄴ', '24042600000067', '24042600000068', '2024-04-26 18:30:58', '', 0);

-- 테이블 drawingautomation.fileinfo 구조 내보내기
CREATE TABLE IF NOT EXISTS `fileinfo` (
  `fileSerial` int(11) NOT NULL AUTO_INCREMENT,
  `fileKey` char(14) NOT NULL,
  `fileName` varchar(50) NOT NULL,
  `filePath` text NOT NULL,
  `fileInstim` char(19) NOT NULL DEFAULT '',
  `fileCnltim` char(19) DEFAULT NULL,
  `fileCancel` tinyint(1) NOT NULL,
  PRIMARY KEY (`fileSerial`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 drawingautomation.fileinfo:~58 rows (대략적) 내보내기
INSERT INTO `fileinfo` (`fileSerial`, `fileKey`, `fileName`, `filePath`, `fileInstim`, `fileCnltim`, `fileCancel`) VALUES
	(1, '100', 'test.dwg', 'D:', '2024-04-25 13:40:12', '2024-04-25 13:40:13', 0),
	(2, '101', 'test.json', 'D:', '2024-04-25 13:41:01', '2024-04-25 15:39:37', 1),
	(3, '101', 'test.json', 'c:', '2024-04-25 15:39:36', '2024-04-25 15:39:37', 0),
	(4, '2404260', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 14:47:24', '2024-04-26 14:47:24', 0),
	(5, '2404260', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 14:50:48', '', 0),
	(6, '2404260', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 14:51:24', '', 0),
	(7, '2404260', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 14:51:24', '', 0),
	(8, '2404260', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 14:52:31', '', 0),
	(9, '24042600000000', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 14:55:41', '', 0),
	(10, '24042600000000', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 14:56:33', '', 0),
	(11, '24042600000000', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 14:56:36', '', 0),
	(12, '24042600000000', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 14:57:23', '', 0),
	(13, '24042600000000', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 14:57:23', '', 0),
	(14, '24042600000000', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 14:58:16', '', 0),
	(15, '24042600000000', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 14:58:16', '', 0),
	(16, '24042600000000', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 14:58:20', '', 0),
	(17, '24042600000000', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 14:58:20', '', 0),
	(18, '24042600000000', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 14:59:21', '', 0),
	(19, '24042600000000', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 14:59:21', '', 0),
	(20, '00000000', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 14:59:21', '', 0),
	(21, '24042600000020', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 15:01:58', '', 0),
	(22, '24042600000021', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 15:01:58', '', 0),
	(23, '24042600000000', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 15:03:08', '', 0),
	(24, '24042600000000', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 15:03:08', '', 0),
	(25, '24042600000025', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 15:13:24', '', 0),
	(26, '24042600000026', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 15:13:24', '', 0),
	(27, '24042600000027', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 15:13:28', '', 0),
	(28, '24042600000028', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 15:13:28', '', 0),
	(29, '24042600000029', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 15:15:16', '', 0),
	(30, '24042600000030', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 15:15:16', '', 0),
	(31, '24042600000031', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 15:15:19', '', 0),
	(32, '24042600000032', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 15:15:19', '', 0),
	(33, '24042600000033', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 15:15:23', '', 0),
	(34, '24042600000034', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 15:15:23', '', 0),
	(35, '24042600000035', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 15:28:13', '', 0),
	(36, '24042600000036', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 15:28:13', '', 0),
	(37, '24042600000037', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 15:31:11', '', 0),
	(38, '24042600000038', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 15:31:11', '', 0),
	(39, '24042600000039', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 15:35:03', '', 0),
	(40, '24042600000040', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 15:35:03', '', 0),
	(41, '24042600000041', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 15:37:53', '', 0),
	(42, '24042600000042', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 15:37:53', '', 0),
	(43, '24042600000043', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 16:55:23', '', 0),
	(44, '24042600000044', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 16:55:23', '', 0),
	(45, '24042600000045', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 16:55:32', '', 0),
	(46, '24042600000046', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 16:55:32', '', 0),
	(47, '24042600000047', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 17:25:49', '', 0),
	(48, '24042600000048', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 17:25:49', '', 0),
	(49, '24042600000049', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 17:26:31', '', 0),
	(50, '24042600000050', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 17:26:31', '', 0),
	(51, '24042600000051', 'example_file.dwg', '/path/to/file/example_file.dwg', '2024-04-26 17:27:00', '', 0),
	(52, '24042600000052', 'example_file.json', '/path/to/file/example_file.json', '2024-04-26 17:27:00', '', 0),
	(53, '24042600000053', '00001', '/path/to/file/example_file.dwg', '2024-04-26 18:08:58', '', 0),
	(54, '24042600000054', 'AAA', '/path/to/file/example_file.json', '2024-04-26 18:08:58', '', 0),
	(55, '24042600000055', '00001', '/path/to/file/example_file.dwg', '2024-04-26 18:09:00', '', 0),
	(56, '24042600000056', 'AAA', '/path/to/file/example_file.json', '2024-04-26 18:09:00', '', 0),
	(57, '24042600000057', '00001', '/path/to/file/example_file.dwg', '2024-04-26 18:09:00', '', 0),
	(58, '24042600000058', 'AAA', '/path/to/file/example_file.json', '2024-04-26 18:09:00', '', 0),
	(59, '24042600000059', '00001', '/path/to/file/example_file.dwg', '2024-04-26 18:11:33', '', 0),
	(60, '24042600000060', 'AAA', '/path/to/file/example_file.json', '2024-04-26 18:11:33', '', 0),
	(61, '24042600000061', '00001', '/path/to/file/example_file.dwg', '2024-04-26 18:16:57', '', 0),
	(62, '24042600000062', 'AAA', '/path/to/file/example_file.json', '2024-04-26 18:16:57', '', 0),
	(63, '24042600000063', 'DWG 파일 데이터', '/path/to/file/example_file.dwg', '2024-04-26 18:27:29', '', 0),
	(64, '24042600000064', 'JSON 파일 데이터', '/path/to/file/example_file.json', '2024-04-26 18:27:29', '', 0),
	(65, '24042600000065', 'DWG 파일 데이터', '/path/to/file/example_file.dwg', '2024-04-26 18:27:58', '', 0),
	(66, '24042600000066', 'JSON 파일 데이터', '/path/to/file/example_file.json', '2024-04-26 18:27:58', '', 0),
	(67, '24042600000067', 'DWG 파일 데이터', '/path/to/file/example_file.dwg', '2024-04-26 18:30:58', '', 0),
	(68, '24042600000068', 'JSON 파일 데이터', '/path/to/file/example_file.json', '2024-04-26 18:30:58', '', 0);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
