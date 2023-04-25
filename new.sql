/*Active: 1681389348096@@8.130.77.8@3306@LyDBTest*/

/*重置服务器的数据库*/

set autocommit=0;

/*USE LyDBTest;*/

DROP TABLE
    IF EXISTS `Administrator`,
    `Users`,
    `Files`,
    `Files_Files`,
    `Comments`,
    `Comment_Comment`,
    `Blobs`,
    `Tag_Types`,
    `Tags`,
    `Files_Tags`;

/*生成各个表*/

/*管理员表*/

CREATE TABLE
    `Administrator`(
        `Adm_Id` INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `Adm_Name` VARCHAR(32) NOT NULL,
        `Adm_Password` VARCHAR(32) NOT NULL,
        `Adm_Permission` INT NOT NULL DEFAULT 0
    );

/*用户表*/

CREATE TABLE
    `Users`(
        `User_Id` INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `User_Name` VARCHAR(32) NOT NULL,
        `User_Password` VARCHAR(32) NOT NULL
        /*
        `User_FileList` INT NOT NULL REFERENCES `Files`(`File_Id`)
        `User_Favorites` INT NOT NULL REFERENCES `Files`(`File_Id`)
        */
    );

/*文件与文件夹表*/

CREATE TABLE
    `Files`(
        `File_Id` INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `File_Type` INT NOT NULL,
        `File_Name` VARCHAR(64) NOT NULL,
        `File_Creator` INT NOT NULL REFERENCES `Users`(`User_Id`),
        `File_Update` TIMESTAMP NOT NULL,
        `File_Download_Count` INT NULL,
        `File_Citation_Count` INT NULL,
        `File_Size` INT NULL,
        `File_Level` INT NULL,
        `File_Icon` INT NOT NULL DEFAULT 0,
        /*
         `File_Icon_Custom` INT NULL REFERENCES Blobs(`Blob_Id`)
         `File_Comments` INT NULL REFERENCES Comments(`Comment_Id`)
         `Fild_Data` INT NULL REFERENCES `Blobs`(`Blob_Id`)
         */
    );

/*父文件-子文件关联表*/

CREATE TABLE
    `Files_Files`(
        `Parent` INT NOT NULL REFERENCES `Files`(`File_Id`),
        `SubFile` INT NOT NULL REFERENCES `Files`(`File_Id`),
        PRIMARY KEY(`Parent`, `SubFile`),
        /*索引:按父文件的id建立索引*/
        INDEX `Parent_Index` (`Parent` ASC)
    );

/*留言表*/

CREATE TABLE
    `Comments`(
        `Comment_Id` INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `Comment_Type` INT NOT NULL DEFAULT 0,
        `Comment_Creator` INT NOT NULL REFERENCES `Users`(`User_Id`),
        `Comment_Upd` TIMESTAMP NOT NULL,
        /*更新时间,包括收到回复和回复收到回复,以及自身的修改*/
        `Comment_Mod` DATETIME NOT NULL,
        /*修改时间,仅包含自身的修改时间*/
        `Comment_Msg` TEXT NOT NULL,
        `Comment_Parent` INT NULL REFERENCES `Comments`(`Comment_Id`)
    );

/*留言与留言回复*/

CREATE TABLE
    `Comment_Comment`(
        `Parent` INT NOT NULL REFERENCES `Comments`(`Comment_Id`),
        `Child` INT NOT NULL REFERENCES `Comments`(`Comment_Id`),
        PRIMARY KEY(`Parent`, `Child`),
        /*索引:按父留言的id建立索引*/
        INDEX `Parent_Index` (`Parent` ASC)
    );

/*文件实例表*/

CREATE TABLE
    `Blobs`(
        `Blob_Id` INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `Blob_Length` INT NOT NULL,
        `Blob_Next` INT NULL REFERENCES `Blobs`(`Blob_Id`),
        `Blob_Content` BLOB NOT NULL
    );

/*标签类型表*/

CREATE TABLE
    `Tag_Types`(
        `Tag_Type_Id` INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `Tag_Type_Name` VARCHAR(32) NOT NULL
    );

/*标签表*/

CREATE TABLE
    `Tags`(
        `Tag_Id` INT(11) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
        `Tag_Name` VARCHAR(32) NOT NULL UNIQUE,
        `Tag_Type` INT NULL REFERENCES `Tag_Types`(`Tag_Type_Id`)
    );

/*文件-标签关联表*/

CREATE TABLE
    `Files_Tags`(
        `File` INT NOT NULL REFERENCES `Files`(Id),
        `Tag` INT NOT NULL REFERENCES `Tags`(Id),
        PRIMARY KEY(`File`, `Tag`),
        /*按文件id建立索引*/
        INDEX `File_Index` (`File` ASC)
    );

/*添加外键约束的属性*/

ALTER TABLE `Users`
ADD
    `User_FileList` INT NULL REFERENCES `Files`(`File_Id`) AFTER `User_Password`;

/*`User_FileList` INT NOT NULL REFERENCES `Files`(`File_Id`)*/

ALTER TABLE `Users`
ADD
    `User_Favorites` INT NULL REFERENCES `Files`(`File_Id`) AFTER `User_FileList`;

/*`User_Favorites` INT NOT NULL REFERENCES `Files`(`File_Id`)*/

ALTER TABLE `Files`
ADD
    `File_Icon_Custom` INT NULL REFERENCES `Blobs`(`Blob_Id`) AFTER `File_Icon`;

/*`File_Icon_Custom` INT NULL REFERENCES Blobs(`Blob_Id`)*/

ALTER TABLE `Files`
ADD
    `File_Comments` INT NULL REFERENCES `Comments`(`Comment_Id`) AFTER `File_Icon_Custom`;

/*`File_Comments` INT NULL REFERENCES Comments(`Comment_Id`)*/

ALTER TABLE `Files`
ADD
    `Fild_Data` INT NULL REFERENCES `Blobs`(`Blob_Id`) AFTER `File_Comments`;

/*`Fild_Data` INT NULL REFERENCES `Blobs`(`Blob_Id`)*/

/*生成存储过程和函数*/

DROP FUNCTION IF EXISTS `User_Create`;

DELIMITER //

CREATE FUNCTION `USER_CREATE`(`U_NAME` VARCHAR(32), `U_PASSWORD` INT(11)) RETURNS INT(11) DETERMINISTIC 
/*创建用户函数,返回新建用户的ID*/ 
BEGIN 
	DECLARE `NEW_UID` INT(11) DEFAULT 0;
	DECLARE `NEW_UFavName` VARCHAR(64) DEFAULT "";
	DECLARE `NEW_UFileName` VARCHAR(64) DEFAULT "";
	DECLARE `NEW_UFavID` INT(11) DEFAULT 0;
	DECLARE `NEW_UFileID` INT(11) DEFAULT 0;
	INSERT INTO`Users`(`User_Name`, `User_Password`) VALUES (`U_Name`, `U_Password`);
	SELECT last_insert_id() INTO `NEW_UID`;
	SELECT CONCAT(`U_Name`,"_Favorites") INTO `NEW_UFavName`;
	SELECT CONCAT(`U_Name`,"_Files") INTO `NEW_UFileName`;
	SELECT `File_Create`('1', `NEW_UFavName`, `NEW_UID`) INTO `NEW_UFavID`;
	SELECT `File_Create`( '2', `NEW_UFileName`, `NEW_UID`) INTO `NEW_UFileID`;
	UPDATE `Users`
	SET `User_FileList` = `NEW_UFileID`, `User_Favorites` = `NEW_UFavID` WHERE `Users`.`User_Id` = `NEW_UID`;
	RETURN `NEW_UID`; 
END;

// 

DELIMITER ;

DROP FUNCTION IF EXISTS `File_Create`;

DELIMITER //

CREATE FUNCTION `FILE_CREATE`(`F_TYPE` INT, `F_NAME` VARCHAR(32), `F_CREATOR` INT) RETURNS INT(11) DETERMINISTIC 
/*
    创建文件函数,返回新建文件的ID,
    可用的FILE_TYPE有4个:1用户收藏夹,2用户根目录,3常规文件,4文件夹
*/ 
BEGIN 
    DECLARE `NEW_ID` INT DEFAULT 0;
	IF (EXISTS (SELECT *FROM `Users`WHERE`Users`.`User_Id` = `F_Creator`)) THEN
        BEGIN
        INSERT INTO `Files` (`File_Type`, `File_Name`, `File_Creator`) VALUES (`F_TYPE`, `F_NAME`, `F_CREATOR`);
        SELECT last_insert_id() INTO `NEW_ID`;
        RETURN `NEW_ID`;
        END;
    ELSE
        RETURN -1;
    END IF;
END;

// 

DELIMITER ;

/*生成触发器*/

/*用//替换分号*/