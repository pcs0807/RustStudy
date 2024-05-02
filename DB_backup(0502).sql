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
	
	SET @dwgfileKey = CONCAT(@currentDate, LPAD(CAST(IFNULL((SELECT fileSerial FROM fileinfo ORDER BY fileSerial DESC LIMIT 1) + 1, 1) AS CHAR), 8, '0'));
	
	INSERT INTO fileinfo 
	(fileKey, fileName, filePath, fileInstim, fileCnltim, fileCancel) 
	VALUES 
	(@dwgfileKey, _dwgName, '/path/to/file/example_file.dwg', @currentTime, '', FALSE);
	
	
	SET @jsonFileKey = CONCAT(@currentDate, LPAD(CAST(IFNULL((SELECT fileSerial FROM fileinfo ORDER BY fileSerial DESC LIMIT 1) + 1, 1) AS CHAR), 8, '0'));
	
	INSERT INTO fileinfo 
	(fileKey, fileName, filePath, fileInstim, fileCnltim, fileCancel) 
	VALUES 
	(@jsonFileKey, _jsonName, '/path/to/file/example_file.json', @currentTime, '', FALSE);
	
	SET @dwgKey = CONCAT(@currentDate, LPAD(CAST(IFNULL((SELECT dwgSerial FROM dwgsetting ORDER BY dwgSerial DESC LIMIT 1) + 1, 1) AS CHAR), 8, '0'));
	
	INSERT INTO dwgsetting 
	(dwgKey, dwgTitle, dwgDescription, dwgFileKey, jsonFileKey, dwgInstim, dwgCnltim, dwgCancel) 
	VALUES 
	(@dwgKey, _dwgTitle, _dwgDescription, @dwgfileKey, @jsonFileKey, @currentTime, '', FALSE);
	
END//
DELIMITER ;

-- 프로시저 drawingautomation.DELETE_DWGSETTING 구조 내보내기
DELIMITER //
CREATE PROCEDURE `DELETE_DWGSETTING`(
	IN _dwgKey TEXT
)
BEGIN
	SET @currentTime = NOW();
	
	SET @dwgFileKey = '';
	SET @jsonFileKey = '';
	SET @dwgInstim = '';

	
	SELECT dwgFileKey, jsonFileKey
	INTO @dwgFileKey, @jsonFileKey
	FROM dwgsetting
		WHERE dwgKey = _dwgKey 
		AND dwgCancel = FALSE
		LIMIT 1;
		
	UPDATE dwgsetting SET dwgCancel = TRUE, dwgCnltim = @currentTime
	WHERE dwgKey = _dwgKey
	AND dwgCancel = FALSE;
	
	UPDATE fileinfo SET fileCancel = TRUE, fileCnltim = @currentTime
	WHERE fileKey IN (@dwgFileKey, @jsonFileKey)
	AND fileCancel = FALSE;
	
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 drawingautomation.dependinfo:~0 rows (대략적) 내보내기

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 drawingautomation.designdetail:~0 rows (대략적) 내보내기

-- 테이블 drawingautomation.designmaster 구조 내보내기
CREATE TABLE IF NOT EXISTS `designmaster` (
  `dsmSerial` int(11) NOT NULL AUTO_INCREMENT,
  `dsmKey` char(14) NOT NULL,
  `dsmVersion` char(10) NOT NULL,
  `dsmInstim` char(19) NOT NULL DEFAULT '0',
  `dsmCnltim` char(19) DEFAULT NULL,
  `dsmCancel` tinyint(1) NOT NULL,
  PRIMARY KEY (`dsmSerial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 drawingautomation.designmaster:~0 rows (대략적) 내보내기

-- 테이블 drawingautomation.dwgsetting 구조 내보내기
CREATE TABLE IF NOT EXISTS `dwgsetting` (
  `dwgSerial` int(11) NOT NULL AUTO_INCREMENT,
  `dwgKey` char(14) NOT NULL,
  `dwgTitle` text NOT NULL,
  `dwgDescription` text DEFAULT NULL,
  `dwgFileKey` char(14) DEFAULT NULL,
  `jsonFileKey` char(14) DEFAULT NULL,
  `dwgInstim` char(19) NOT NULL DEFAULT '',
  `dwgCnltim` char(19) DEFAULT NULL,
  `dwgCancel` tinyint(1) NOT NULL,
  PRIMARY KEY (`dwgSerial`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 drawingautomation.dwgsetting:~16 rows (대략적) 내보내기
INSERT INTO `dwgsetting` (`dwgSerial`, `dwgKey`, `dwgTitle`, `dwgDescription`, `dwgFileKey`, `jsonFileKey`, `dwgInstim`, `dwgCnltim`, `dwgCancel`) VALUES
	(1, '24043000000001', '오세아니아', 'ㄶㅇㅎㄴㅇㅇㅎㄴ', '24043000000001', '24043000000002', '2024-04-30 17:36:01', '2024-04-30 17:36:22', 1),
	(2, '24043000000002', '오세아니아', 'ㄶㅇㅎㄴㅇㅇㅎㄴ', '24043000000003', '24043000000004', '2024-04-30 17:36:04', '2024-04-30 17:36:32', 1),
	(3, '24043000000002', '가즈아', '넌 뭔데', '24043000000003', '24043000000004', '2024-04-30 17:36:32', '2024-04-30 17:42:18', 1),
	(4, '24043000000004', '오세아니아', 'ㄶㅇㅎㄴㅇㅇㅎㄴ', '24043000000005', '24043000000006', '2024-04-30 17:42:24', '2024-04-30 18:08:54', 1),
	(5, '24043000000004', '제목', '가즈아', '24043000000005', '24043000000006', '2024-04-30 18:08:54', '2024-05-02 10:33:18', 1),
	(6, '24043000000006', 'ㅇㄹㅇ', 'ㄶㅇㅎㄴㅇㅇㅎㄴ', '24043000000007', '24043000000008', '2024-04-30 18:09:32', '2024-04-30 18:09:46', 1),
	(7, '24043000000006', '안녕', '가즈아', '24043000000007', '24043000000008', '2024-04-30 18:09:46', '2024-04-30 19:27:14', 1),
	(8, '24043000000008', '안녕하세요', 'ㄶㅇㅎㄴㅇㅇㅎㄴ', '24043000000009', '24043000000010', '2024-04-30 19:26:18', '2024-04-30 19:26:58', 1),
	(9, '24043000000006', '22333', '가즈아', '24043000000007', '24043000000008', '2024-04-30 19:27:14', '2024-04-30 19:28:14', 1),
	(10, '24043000000006', '33333', '가즈아', '24043000000007', '24043000000008', '2024-04-30 19:28:14', '2024-05-02 10:32:54', 1),
	(11, '24043000000011', '마이다스 아이티', '굿 잡', '24043000000011', '24043000000012', '2024-04-30 20:14:43', '2024-04-30 20:15:04', 1),
	(12, '24043000000011', '마이다스인', '가즈아', '24043000000011', '24043000000012', '2024-04-30 20:15:04', '2024-04-30 20:15:11', 1),
	(13, '24043000000013', '유지보수 테스트', '굿 잡', '24043000000013', '24043000000014', '2024-04-30 20:16:34', '2024-04-30 20:16:53', 1),
	(14, '24043000000013', '유지보수 해보자', '232323', '24043000000013', '24043000000014', '2024-04-30 20:16:53', '2024-04-30 20:17:06', 1),
	(15, '24043000000013', '유지보수 해보자', '마지막 변경', '24043000000013', '24043000000014', '2024-04-30 20:17:06', '2024-05-02 10:32:40', 1),
	(16, '24043000000004', '유지보수 해보자', '마지막 변경', '24043000000005', '24043000000006', '2024-05-02 10:33:18', '', 0),
	(17, '24050200000017', '유지ssd스트', '굿 잡', '24050200000015', '24050200000016', '2024-05-02 11:00:01', '', 0),
	(18, '24050200000018', '유121스트', '굿 잡', '24050200000017', '24050200000018', '2024-05-02 11:00:04', '', 0);

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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 테이블 데이터 drawingautomation.fileinfo:~14 rows (대략적) 내보내기
INSERT INTO `fileinfo` (`fileSerial`, `fileKey`, `fileName`, `filePath`, `fileInstim`, `fileCnltim`, `fileCancel`) VALUES
	(1, '24043000000001', 'DWG 파일 데이터', '/path/to/file/example_file.dwg', '2024-04-30 17:36:01', '2024-04-30 17:36:22', 1),
	(2, '24043000000002', 'JSON 파일 데이터', '/path/to/file/example_file.json', '2024-04-30 17:36:01', '2024-04-30 17:36:22', 1),
	(3, '24043000000003', 'DWG 파일 데이터', '/path/to/file/example_file.dwg', '2024-04-30 17:36:04', '2024-04-30 17:42:18', 1),
	(4, '24043000000004', 'JSON 파일 데이터', '/path/to/file/example_file.json', '2024-04-30 17:36:04', '2024-04-30 17:42:18', 1),
	(5, '24043000000005', 'DWG 파일 데이터', '/path/to/file/example_file.dwg', '2024-04-30 17:42:24', '', 0),
	(6, '24043000000006', 'JSON 파일 데이터', '/path/to/file/example_file.json', '2024-04-30 17:42:24', '', 0),
	(7, '24043000000007', 'DWG 파일 데이터', '/path/to/file/example_file.dwg', '2024-04-30 18:09:32', '2024-05-02 10:32:54', 1),
	(8, '24043000000008', 'JSON 파일 데이터', '/path/to/file/example_file.json', '2024-04-30 18:09:32', '2024-05-02 10:32:54', 1),
	(9, '24043000000009', 'DWG 파일 데이터', '/path/to/file/example_file.dwg', '2024-04-30 19:26:18', '2024-04-30 19:26:58', 1),
	(10, '24043000000010', 'JSON 파일 데이터', '/path/to/file/example_file.json', '2024-04-30 19:26:18', '2024-04-30 19:26:58', 1),
	(11, '24043000000011', 'ㄴㅇㅇㄴ', '/path/to/file/example_file.dwg', '2024-04-30 20:14:43', '2024-04-30 20:15:11', 1),
	(12, '24043000000012', 'JSON 파일 데이터', '/path/to/file/example_file.json', '2024-04-30 20:14:43', '2024-04-30 20:15:11', 1),
	(13, '24043000000013', 'ㄴㅇㅇㄴ', '/path/to/file/example_file.dwg', '2024-04-30 20:16:34', '2024-05-02 10:32:40', 1),
	(14, '24043000000014', 'JSON 파일 데이터', '/path/to/file/example_file.json', '2024-04-30 20:16:34', '2024-05-02 10:32:40', 1),
	(15, '24050200000015', 'ㄴㅇㅇㄴ', '/path/to/file/example_file.dwg', '2024-05-02 11:00:01', '', 0),
	(16, '24050200000016', 'JSON 파일 데이터', '/path/to/file/example_file.json', '2024-05-02 11:00:01', '', 0),
	(17, '24050200000017', 'ㄴㅇㅇㄴ', '/path/to/file/example_file.dwg', '2024-05-02 11:00:04', '', 0),
	(18, '24050200000018', 'JSON 파일 데이터', '/path/to/file/example_file.json', '2024-05-02 11:00:04', '', 0);

-- 프로시저 drawingautomation.SELECT_DWGSETTING 구조 내보내기
DELIMITER //
CREATE PROCEDURE `SELECT_DWGSETTING`(
	IN `_key` TEXT,
	IN `_column` TEXT,
	IN `_asc` BOOL
)
BEGIN

    SET @orderDirection = IF(_asc, 'ASC', 'DESC');
    
    SET @orderByColumn = '';
    
    IF _column = 'latest' THEN
        SET @orderByColumn = 'dwgInstim';
    ELSEIF _column = 'name' THEN
        SET @orderByColumn = 'dwgTitle';
    ELSE
        SET @orderByColumn = 'dwgInstim';
    END IF;

    SET @query = CONCAT('
        SELECT 
            dwgKey, 
            dwgTitle, 
            dwgDescription, 
            dwgFile.fileName AS dwgFileName, 
            jsonFile.fileName AS jsonFileName, 
            dwgInstim, 
            dwgCnltim 
        FROM dwgsetting 
            INNER JOIN 
                (SELECT 
                    fileKey, 
                    fileName, 
                    filePath 
                    FROM dwgsetting 
                    INNER JOIN fileinfo 
                    ON dwgFileKey = fileKey 
                    AND fileCancel = 0 
                    WHERE dwgCancel = 0) AS dwgFile 
            ON dwgsetting.dwgFilekey = dwgFile.fileKey 
            INNER JOIN 
                (SELECT 
                    fileKey, 
                    fileName,
                    filePath 
                    FROM dwgsetting 
                    INNER JOIN fileinfo 
                    ON jsonFilekey = fileKey 
                    AND fileCancel = 0 
                    WHERE dwgCancel = 0) AS jsonFile 
            ON dwgsetting.jsonFilekey = jsonFile.fileKey
        WHERE dwgcancel = 0');
        
    IF _key != '' THEN
     SET @query = CONCAT(@query, ' AND dwgKey = ', QUOTE(_key));
    END IF;
    
    SET @query = CONCAT(@query, ' ORDER BY ', @orderByColumn, ' ', @orderDirection);
    
    PREPARE stmt FROM @query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
END//
DELIMITER ;

-- 프로시저 drawingautomation.UPDATE_DWGSETTING 구조 내보내기
DELIMITER //
CREATE PROCEDURE `UPDATE_DWGSETTING`(
	IN `_dwgKey` TEXT,
	IN `_title` TEXT,
	IN `_description` TEXT,
	OUT `RESULT` INT
)
BEGIN
	SET @currentTime = NOW();
	
	SET @dwgSerial = 0;
	SET @dwgFileKey = '';
	SET @jsonFileKey = '';
	SET @dwgInstim = '';
	SET @recordCnt = 0;

	
	SELECT COUNT(*), dwgSerial, dwgFileKey, jsonFileKey, dwgInstim 
	INTO @recordCnt, @dwgSerial, @dwgFileKey, @jsonFileKey, @dwgInstim 
	FROM dwgsetting
		WHERE dwgKey = _dwgKey 
		AND dwgCancel = FALSE
		LIMIT 1;
		
	SET RESULT = 0;
	
	START TRANSACTION;
		IF @recordCnt > 0 THEN
		
			UPDATE dwgsetting 
			SET dwgCancel = TRUE, dwgCnltim = @currentTime
			WHERE dwgSerial = @dwgSerial;		
			
			INSERT INTO dwgsetting 
				(dwgKey, 
				dwgTitle, 
				dwgDescription, 
				dwgFileKey, 
				jsonFileKey, 
				dwgInstim, 
				dwgCnltim, 
				dwgCancel) 
				VALUES 
				(_dwgKey, 
				_title, 
				_description, 
				@dwgFileKey, 
				@jsonFileKey, 
				@currentTime, 
				'', 
				FALSE);
				
			SET RESULT = 1;
			
		ELSE
			SET RESULT = 0;				
		END IF;
	COMMIT;
	
END//
DELIMITER ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
