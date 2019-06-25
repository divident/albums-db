-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema albumy_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema albumy_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `albumy_db` DEFAULT CHARACTER SET utf8 ;
USE `albumy_db` ;

-- -----------------------------------------------------
-- Table `albumy_db`.`author`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `albumy_db`.`author` (
  `idauthor` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idauthor`))
ENGINE = InnoDB
AUTO_INCREMENT = 10001
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `albumy_db`.`album`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `albumy_db`.`album` (
  `idAlbum` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `year` VARCHAR(45) NOT NULL,
  `fk_author` INT(11) NOT NULL,
  PRIMARY KEY (`idAlbum`),
  INDEX `author` (`fk_author` ASC),
  CONSTRAINT `author`
    FOREIGN KEY (`fk_author`)
    REFERENCES `albumy_db`.`author` (`idauthor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 100001
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `albumy_db`.`albumprice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `albumy_db`.`albumprice` (
  `idalbumPrice` INT(11) NOT NULL AUTO_INCREMENT,
  `price` DECIMAL(10,0) NOT NULL,
  `fk_album` INT(11) NOT NULL,
  PRIMARY KEY (`idalbumPrice`),
  INDEX `albumy_idx` (`fk_album` ASC),
  CONSTRAINT `albumy`
    FOREIGN KEY (`fk_album`)
    REFERENCES `albumy_db`.`album` (`idAlbum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 50001
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `albumy_db`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `albumy_db`.`user` (
  `idUser` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(200) NOT NULL,
  `lastname` VARCHAR(200) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idUser`))
ENGINE = InnoDB
AUTO_INCREMENT = 10001
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `albumy_db`.`albumscore`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `albumy_db`.`albumscore` (
  `idAlbumScore` INT(11) NOT NULL AUTO_INCREMENT,
  `rating` INT(11) NOT NULL,
  `fk_user` INT(11) NOT NULL,
  `fk_album` INT(11) NOT NULL,
  PRIMARY KEY (`idAlbumScore`),
  INDEX `FK_album` (`fk_album` ASC),
  INDEX `FK_user` (`fk_user` ASC),
  CONSTRAINT `FK_album`
    FOREIGN KEY (`fk_album`)
    REFERENCES `albumy_db`.`album` (`idAlbum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_user`
    FOREIGN KEY (`fk_user`)
    REFERENCES `albumy_db`.`user` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 200001
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `albumy_db`.`track`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `albumy_db`.`track` (
  `idtrack` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `duration` INT(11) NOT NULL,
  PRIMARY KEY (`idtrack`))
ENGINE = InnoDB
AUTO_INCREMENT = 50001
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `albumy_db`.`trackscore`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `albumy_db`.`trackscore` (
  `idTrackScore` INT(11) NOT NULL AUTO_INCREMENT,
  `fk_track` INT(11) NOT NULL,
  `rating` INT(11) NOT NULL,
  `fk_user` INT(11) NOT NULL,
  `coment` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idTrackScore`),
  INDEX `track` (`fk_track` ASC),
  INDEX `user` (`fk_user` ASC),
  CONSTRAINT `track`
    FOREIGN KEY (`fk_track`)
    REFERENCES `albumy_db`.`track` (`idtrack`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user`
    FOREIGN KEY (`fk_user`)
    REFERENCES `albumy_db`.`user` (`idUser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 3000001
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `albumy_db`.`tracktoalbum`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `albumy_db`.`tracktoalbum` (
  `idtrackToAlbum` INT(11) NOT NULL AUTO_INCREMENT,
  `fk_album` INT(11) NOT NULL,
  `fk_track` INT(11) NOT NULL,
  PRIMARY KEY (`idtrackToAlbum`),
  INDEX `fk_track_idx` (`fk_track` ASC),
  INDEX `fk_albums` (`fk_album` ASC),
  CONSTRAINT `fk_albums`
    FOREIGN KEY (`fk_album`)
    REFERENCES `albumy_db`.`album` (`idAlbum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_track`
    FOREIGN KEY (`fk_track`)
    REFERENCES `albumy_db`.`track` (`idtrack`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 100001
DEFAULT CHARACTER SET = utf8;

USE `albumy_db` ;

-- -----------------------------------------------------
-- procedure 01_load_100K_data
-- -----------------------------------------------------

DELIMITER $$
USE `albumy_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `01_load_100K_data`()
BEGIN
	declare v_max int default 100 * 1000;
	declare N_authors int default 1 * 1000;
	declare N_tracks int default 1 * 1000;
	declare N_users int default 1 * 1000;
	declare N_albums int default 100 * 1000;
	declare N_prices int default 10 * 1000;
	declare N_albumScores int default 100 * 1000;
	declare N_trackScores int default 100 * 1000;
	declare N_trackToAlbum int default 100 * 1000;

    call albumy_db.`1_create_authors`(N_authors);

	call albumy_db.`2_create_tracks`(N_tracks);
    
    call albumy_db.`3_create_users`(N_users);
    
    call albumy_db.`4_create_albums`(N_albums, N_authors);

	call albumy_db.`5_create_prices`(N_prices, N_albums);

	call albumy_db.`6_craete_album_Scores`(N_albumScores, N_users, N_albums);

	call albumy_db.`7_create_trackScores`(N_trackScores, N_tracks, N_users);

	call albumy_db.`8_create_tracktoalbum`(N_trackToAlbum, N_albums, N_tracks);

END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure 1_create_authors
-- -----------------------------------------------------

DELIMITER $$
USE `albumy_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `1_create_authors`(in v_max int)
BEGIN
	DECLARE v_i INT DEFAULT 1;
    
    
	while v_i <= v_max do
		INSERT INTO author(idauthor, name) VALUES
        (v_i, elt(floor(rand()*50+1), 
        'Scot Acker', 'Albert Mclean', 'Adelaida Bergman', 'Abram Patten', 'Edgar Adler',
        'Edward Jarvis', 'Wesley Ramirez', 'Gregg Fulmer', 'Karly Aguirre', 'Rueben Sell',
        'Porsha Minton', 'Almeta Bowling', 'Leonora Houser', 'Dudley Rowan', 'Vance Blaine',
        'Clemmie Grove',
		'Lester Cohn',
		'Andrew Crutchfield',
		'Percy Valdes',
		'Duncan Sisco',
		'Christian Gill',
		'Avery Weeks',
		'Travis Abney',
		'Judson Oh',
		'Abe Tibbs',
		'Allan Canales',
		'Kristle Dickens',
		'Aide Manley',
		'Vita Morrissey',
		'Alease Perales',
		'Agueda Camp',
		'Jamie Aguiar',
		'Augustus Abreu',
		'Romeo Anderson',
		'Abdul Rainey',
		'Joye Ryder',
		'Rory Burchfield',
		'Adaline Shah',
		'Alexandria Mendenhall',
		'Adolfo Rangel',
		'Kyung Andrew',
		'Melvin Sommers',
		'Jamika Mendez',
		'Seth Ojeda',
		'Mistie Musgrove',
		'Gabriela Harmon',
		'Alexis Goulet',
		'Neal Bergman',
		'Fermina Fields',
		'Rolande Price'));
		set v_i = v_i + 1;
		end while;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure 2_create_tracks
-- -----------------------------------------------------

DELIMITER $$
USE `albumy_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `2_create_tracks`(in v_max int)
BEGIN
	DECLARE v_i INT DEFAULT 1;

	while v_i <= v_max do
		INSERT INTO track(idtrack, name, duration) VALUES
		(v_i + 1, 'LQYLuythnQzlqganzmCmfj', 135),
		(v_i + 2, 'LmmbeBasDEfRNpMvdKpApnrd''aooHKxc.IuCwOhHNydt.', 181),
		(v_i + 3, 'xSl YxrVHFQufNaC- rmp-bzfdYvCrxpYXK nW.YQYeb,', 199),
		(v_i + 4, 'IJGgTDgcDZoXhEGIN,TgkBjmpPWJ,yfmFcZeMMuYaeli,', 249),
		(v_i + 5, 'nJXvObmGeAIIegJS- RNt''Tqogb', 30),
		(v_i + 6, 'zLblAMeebdZpXrBLAjsBFpAU', 162),
		(v_i + 7, 'TzhgwiPXOO,CvrqyFcMpMgmIRp-IC'' .yCeTsKuFRkkqW', 396),
		(v_i + 8, 'nKsrlPcgCHepOKgcprMIMvpBqxqxCppWEybNUiWTXDrfP', 300),
		(v_i + 9, 'ROtvaOC jjoGniCLcDlhmokXiJydSvXPBKO.zugiUjM. ', 253),
		(v_i + 10, 'eRAteKAp.kXFhoEIWPCF', 295),
		(v_i + 11, 'qt-dSXVQp''mcNyHeQqIdFUueg GFSuLJeujPizZNADqMj', 398),
		(v_i + 12, 'EPQnFMenOLEaxQXzszhpCBXpb,gJmpyCE kUmeJfUlKgU', 291),
		(v_i + 13, 'IOs BNaRtc-kyqwVYryfqFG.lFLXCCOagmGTHMbgq''Fz.', 275),
		(v_i + 14, 'DOpccPwaIwecCHZslKxQJa', 205),
		(v_i + 15, 'KgXyKCoarAwvpnWuSxzHbxfuXOfbpMSE-gS''pCKnqXpPW', 134),
		(v_i + 16, 'tmIBahcacDVw,NtyBRAzdnRQRknaZRWdWIoVwcPubGAOZ', 230),
		(v_i + 17, 'hcwWs.CpIlHIfP.LpbiPWHfPNtWIQnabSJpEK', 48),
		(v_i + 18, 'zingzCGskFIljIKeCaJSE-RNIkjIKQTip', 105),
		(v_i + 19, 'uDntndYf', 394),
		(v_i + 20, 'am''LEYotnB,BAOGSvTYZCkyzgxFWMAOvo.aDjKIGOgChn', 301),
		(v_i + 21, 'FEawEKtukDzjCrRWNZDqBeBpjFlAccBbigjerMbiFh''Yf', 31),
		(v_i + 22, 'wryLSRpZPDxEFeARyCfJAxvgzeyVDDg'' aXqWny', 197),
		(v_i + 23, 'YtmfnGKYM', 59),
		(v_i + 24, 'EbMWbZnFfTPXxI.Ese''wwdbOOs''igKtAwgEbD ubzKimT', 319),
		(v_i + 25, 'NpWGFdyMhlLJqTynEWwehPIXeNXBAO-LctUrYrfOwCRib', 102),
		(v_i + 26, 'BzNklfVa,PGfGMfLjkhEC- lnbna.KOEUlZdHSymBClfV', 188),
		(v_i + 27, 'yFKoczsYUGkUsShzIhvAqRexMkfCMN', 258),
		(v_i + 28, 'tweckwXcRTBRDY. ancusDwlbFWDKEuFycntGspKoKKPr', 49),
		(v_i + 29, 'aq DV-gEcgQUW EQXBadpyt.BQRQPVGnfzGTo'' JoUmST', 55),
		(v_i + 30, 'NjacT''OSo OGAuhoLFJ KYGJf dWOyEQNE''dYHsjEbvMQ', 101),
		(v_i + 31, 'ajqfjCLQfIJvioBoEtCT SWmNjpWgbnpEVynLPySI''FJN', 216),
		(v_i + 32, 'DpmCrDahmZwwoPEJOqOgVYmDudpSJqX,qtLRcYp,DDxmY', 59),
		(v_i + 33, 'yCypSQcO-OhHzjBtvF''QruSsklOPwzbRcoGMEqYEGiUAX', 57),
		(v_i + 34, 'EMwmWVyBmCAuvdLiKEkGGVsAT-vMDINNJHqC. GaguBzD', 234),
		(v_i + 35, 'rqgBoAacPFZhjh KPQCJVFQbOXNNNPKwDfBKPqvVFvvPp', 136),
		(v_i + 36, 'xHScbrj,jlyPehUHyIzsl.ZEBJihGWcoOymaoVAklOKoV', 349),
		(v_i + 37, 'ABCOixUlQPyXyCuMSALXdb uAhwWyvHY,POyYHcqpzcfp', 231),
		(v_i + 38, 'Xd.WRSlXaWKOxeCPHfrJenNnsEtYwagcuzkUVTjr', 372),
		(v_i + 39, 'hkLJ,EzUvxQXJs. vBMegUOgXsQq', 356),
		(v_i + 40, 'RF''CEywp-OZZgmwygBpMtuVIVoBnCiDUQAEDXEQKHDzKc', 382),
		(v_i + 41, 'ntTlPaXCh.zxXW,dEBDkdOd-YKCQVHEw.VkONJhsYxplN', 35),
		(v_i + 42, 'PdK GYmdMvQg-jC', 364),
		(v_i + 43, 'iuHTSefkG-oVzFiZOSbZgseIlTjbcq-YptszxBZkJ''xXB', 100),
		(v_i + 44, 'zIvUbRRcCvmDiWDvoiXSKA', 61),
		(v_i + 45, 'PYXwnP,cbEoBlOOluiKEVPZJVM.ZkqTmZSWgBAqhYgLkU', 301),
		(v_i + 46, 'aimEIIYkwofCoBcFeTDID'' oVInxIzO', 75),
		(v_i + 47, 'SYysJaojryv,eFcrr', 59),
		(v_i + 48, 'Su  BUCFrgTHDaMLXErktWCeOlauKHx', 171),
		(v_i + 49, 'MYpP-xcsHvtHcGQGKtBIFMiAkomPJk.WrM-aYGWqATvWP', 63),
		(v_i, 'QfypbXg.MXGNXZzNZzxtmjgswIRFR.xdeQFiVzwWchYGo', 93);
        set v_i = v_i + 50;
		end while;
        
        
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure 3_create_users
-- -----------------------------------------------------

DELIMITER $$
USE `albumy_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `3_create_users`(in v_max int)
BEGIN

	DECLARE v_i INT DEFAULT 1;
    
        
	while v_i <= v_max do
		INSERT INTO user(idUser, name, lastname, email) VALUES
		(v_i, 'Zofia', 'Manley', 'AbeSSims856@example.com'),
		(v_i + 1, 'Alan', 'Abel', 'Bolin641@example.com'),
		(v_i + 2, 'Candace', 'Bowden', 'Arroyo@nowhere.com'),
		(v_i + 3, 'Carina', 'Abernathy', 'FrederickLandis@example.com'),
		(v_i + 4, 'Audrea', 'Tirado', 'Oralia_Sousa6@example.com'),
		(v_i + 5, 'Lupita', 'Quintanilla', 'Bennett_J.Maldonado58@example.com'),
		(v_i + 6, 'Adah', 'Schafer', 'AlesiaLilly47@nowhere.com'),
		(v_i + 7, 'Alessandra', 'Gatlin', 'lhonzjm1591@example.com'),
		(v_i + 8, 'Almeda', 'Bowen', 'AddisonS51@example.com'),
		(v_i + 9, 'Dusty', 'Tisdale', 'WillardAiello@nowhere.com'),
		(v_i + 10, 'Heriberto', 'Moreau', 'qfaozsv350@example.com'),
		(v_i + 11, 'Ward', 'Abney', 'EarnestAndres453@example.com'),
		(v_i + 12, 'Morris', 'Quintero', 'xglzwedk.kovibhvvd@example.com'),
		(v_i + 13, 'Adolph', 'Dial', 'DollyMares67@example.com'),
		(v_i + 14, 'Andy', 'Gauthier', 'TiffanyM.Cunningham62@example.com'),
		(v_i + 15, 'Harlan', 'Diamond', 'Vernon_Estrada24@nowhere.com'),
		(v_i + 16, 'Tanika', 'Bowens', 'AdellAbreu@example.com'),
		(v_i + 17, 'Carley', 'Joe', 'Peek26@nowhere.com'),
		(v_i + 18, 'Ulysses', 'Morehead', 'Rubin432@example.com'),
		(v_i + 19, 'Andra', 'Gavin', 'LalaHough@nowhere.com'),
		(v_i + 20, 'Shu', 'Schaffer', 'dmeoo8@nowhere.com'),
		(v_i + 21, 'Alecia', 'Abraham', 'Hammett@example.com'),
		(v_i + 22, 'Eladia', 'Dias', 'YeseniaMyers536@nowhere.com'),
		(v_i + 23, 'Alyssa', 'Gay', 'Stack837@nowhere.com'),
		(v_i + 24, 'Dollie', 'Diaz', 'Alston13@nowhere.com'),
		(v_i + 25, 'Bernard', 'Gaylord', 'hrzd6@example.com'),
		(v_i + 26, 'Adam', 'Dick', 'Alexander.Albers@nowhere.com'),
		(v_i + 27, 'Ellsworth', 'Quiroz', 'Milburn396@example.com'),
		(v_i + 28, 'Weston', 'Geary', 'Brantley@example.com'),
		(v_i + 29, 'Aletha', 'Moreland', 'Carranza811@example.com'),
		(v_i + 30, 'Burton', 'Titus', 'zejfydwz.ismw@example.com'),
		(v_i + 31, 'Candra', 'Bower', 'xoipmh517@example.com'),
		(v_i + 32, 'Tracey', 'Rader', 'Beaulieu@example.com'),
		(v_i + 33, 'Adam', 'Abrams', 'Schmid@example.com'),
		(v_i + 34, 'Collin', 'Schell', 'AcevedoG@example.com'),
		(v_i + 35, 'Mathilda', 'Moreno', 'Clair_CDangelo@example.com'),
		(v_i + 36, 'Aimee', 'Mann', 'Oconner162@example.com'),
		(v_i + 37, 'Adah', 'Johansen', 'Bourne@example.com'),
		(v_i + 38, 'Francoise', 'Tobias', 'GaryDuke@nowhere.com'),
		(v_i + 39, 'Bong', 'Dickens', 'Emmitt_UAckerman@example.com'),
		(v_i + 40, 'Kimberely', 'Gee', 'Ballard@example.com'),
		(v_i + 41, 'Lakisha', 'Radford', 'Abbott962@example.com'),
		(v_i + 42, 'Marguerite', 'Bowers', 'Geary@nowhere.com'),
		(v_i + 43, 'Gennie', 'Scherer', 'Witt836@example.com'),
		(v_i + 44, 'Felicidad', 'Tobin', 'Street8@example.com'),
		(v_i + 45, 'Markus', 'Manning', 'Bentley173@example.com'),
		(v_i + 46, 'Darrell', 'Dickerson', 'ArianeTrotter@example.com'),
		(v_i + 47, 'Christy', 'Morey', 'ReinaldoHardwick787@example.com'),
		(v_i + 48, 'Halley', 'John', 'BartonCoffin@nowhere.com'),
		(v_i + 49, 'Bridgett', 'Manns', 'CortneyMiner@example.com');
        set v_i = v_i + 50;
		end while;
        
        
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure 4_create_albums
-- -----------------------------------------------------

DELIMITER $$
USE `albumy_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `4_create_albums`(in v_max int, in v_max_fk_author int)
BEGIN

	DECLARE v_i INT DEFAULT 1;
    

    set v_i = 1;
        
	while v_i <= v_max do
		INSERT INTO album(idAlbum, name, year, fk_author) VALUES
		(v_i, 'WorldWide Optics Corporation', '2016', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 1, 'Advanced Research Corp.', '2004', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 2, 'National Space Explore Co.', '1988', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 3, 'Smart Mining Corporation', '2008', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 4, 'Global High-Technologies Corp.', '1979', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 5, 'First 2G Wireless Corporation', '2003', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 6, 'Future Industry Corporation', '2003', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 7, 'West I-Mobile Group', '2015', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 8, 'United Logics Group', '1967', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 9, 'Home Space Research Inc.', '1976', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 10, 'Canadian Space Research Group', '2017', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 11, 'Australian W-Mobile Inc.', '2005', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 12, 'East High-Technologies Inc.', '2013', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 13, 'General High-Technologies Group', '1968', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 14, 'Creative Fossil Fuel Power Group', '2002', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 15, 'Creative Laboratories Corp.', '2003', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 16, 'Domestic J-Mobile Inc.', '1977', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 17, 'City Q-Mobile Group', '2009', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 18, 'Home Telecom Corporation', '2015', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 19, 'City M-Mobile Corporation', '1966', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 20, 'South Natural Gas Resources Group', '1989', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 21, 'Federal Instruments Group', '1989', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 22, 'City O-Mobile Inc.', '1998', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 23, 'Western High-Technologies Corporation', '1999', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 24, 'First Natural Gas Power Inc.', '1977', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 25, 'Pacific Space Research Group', '2001', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 26, 'Home Space Explore Inc.', '1969', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 27, 'Advanced T-Mobile Corporation', '1996', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 28, 'Western O-Mobile Group', '1986', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 29, 'National Goods Group', '1998', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 30, 'West 7D Electronic Inc.', '2000', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 31, 'Domestic Telecom Group', '2006', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 32, 'Canadian Mining Corporation', '1987', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 33, 'Domestic Nuclear Power Co.', '2018', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 34, 'Western Consulting Group', '2004', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 35, 'WorldWide Broadcasting Group', '1976', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 36, 'City 5G Wireless Inc.', '1987', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 37, 'International High-Technologies Group', '1967', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 38, 'Pacific Research Co.', '2005', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 39, 'North Renewable Power Group', '1978', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 40, 'WorldWide Services Co.', '2005', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 41, 'Advanced Space Research Group', '2018', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 42, 'Canadian Wave Power Corporation', '1976', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 43, 'Home Materials Inc.', '1996', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 44, 'Global Travel Corporation', '2008', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 45, 'First U-Mobile Corporation', '1978', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 46, 'Flexible Data Group', '1998', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 47, 'Federal Industry Corporation', '1977', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 48, 'Domestic Industry Inc.', '2003', FLOOR(RAND()*(v_max_fk_author-1+1)+1)),
		(v_i + 49, 'Advanced Insurance Inc.', '2004',  FLOOR(RAND()*(v_max_fk_author-1+1)+1));
        set v_i = v_i + 50;
		end while;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure 5_create_prices
-- -----------------------------------------------------

DELIMITER $$
USE `albumy_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `5_create_prices`(in v_max int, in v_max_fk_album int)
BEGIN
	DECLARE v_i INT DEFAULT 0;
    
	while v_i < v_max do
        INSERT INTO albumprice(price, fk_album) VALUES
        (floor(rand()*(10000-1+1)+1)/10, FLOOR(RAND()*(v_max_fk_album-1+1)+1));
		
		set v_i = v_i + 1;
		end while;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure 6_craete_album_Scores
-- -----------------------------------------------------

DELIMITER $$
USE `albumy_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `6_craete_album_Scores`(in v_max int, in v_max_fk_user int, in v_max_fk_album int)
BEGIN

	DECLARE v_i INT DEFAULT 1;


	set v_i = 0;
	while v_i  < v_max do
		INSERT INTO albumscore(rating, fk_user, fk_album) VALUES
		(FLOOR(RAND()*(10-1+1)+1) ,FLOOR(RAND()*(v_max_fk_user-1+1)+1), FLOOR(RAND()*(v_max_fk_album-1+1)+1));
		set v_i = v_i + 1;
		end while;
	
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure 7_create_trackScores
-- -----------------------------------------------------

DELIMITER $$
USE `albumy_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `7_create_trackScores`(in v_max int, in v_max_fk_track int, in v_max_fk_user int)
BEGIN
	DECLARE v_i INT DEFAULT 1;


    set v_i = 0;
	while v_i < v_max do
        INSERT INTO trackscore(fk_track, rating, fk_user, coment) VALUES
		(FLOOR(RAND()*(v_max_fk_track-1+1)+1), FLOOR(RAND()*(10-1+1)+1), FLOOR(RAND()*(v_max_fk_user-1+1)+1), 'KtcTQblRrglYlHR,wBxegQxYrZPdiJixpmZAdKkABOxF-'),
		(FLOOR(RAND()*(v_max_fk_track-1+1)+1), FLOOR(RAND()*(10-1+1)+1), FLOOR(RAND()*(v_max_fk_user-1+1)+1), 'e.wIKVtPCwAW-eqNibokVjgplSecHTDFGGVITGxdaW,rf'),
		(FLOOR(RAND()*(v_max_fk_track-1+1)+1), FLOOR(RAND()*(10-1+1)+1), FLOOR(RAND()*(v_max_fk_user-1+1)+1), 'AlUZJ ukX'),
		(FLOOR(RAND()*(v_max_fk_track-1+1)+1), FLOOR(RAND()*(10-1+1)+1), FLOOR(RAND()*(v_max_fk_user-1+1)+1), 'wEm msQ-IPVeMVBVTqKAVqkEMAhCtbQXI-zQv''iXpCOVi'),
		(FLOOR(RAND()*(v_max_fk_track-1+1)+1), FLOOR(RAND()*(10-1+1)+1), FLOOR(RAND()*(v_max_fk_user-1+1)+1), 'UhufErgJkG,oiAWrshnwLF.Gq''hVWK-oNKLoIXWAg-SzG'),
		(FLOOR(RAND()*(v_max_fk_track-1+1)+1), FLOOR(RAND()*(10-1+1)+1), FLOOR(RAND()*(v_max_fk_user-1+1)+1), 'SfCUPb');
		set v_i = v_i + 5;
		end while;
        
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure 8_create_tracktoalbum
-- -----------------------------------------------------

DELIMITER $$
USE `albumy_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `8_create_tracktoalbum`(in v_max int, in v_max_fk_album int,in v_max_fk_track int)
BEGIN
	DECLARE v_i INT DEFAULT 1;

	set v_i = 0;
	while v_i < v_max do
        INSERT INTO tracktoalbum(fk_album, fk_track) VALUES
		(FLOOR(RAND()*(v_max_fk_album-1+1)+1), FLOOR(RAND()*(v_max_fk_track-1+1)+1));
		set v_i = v_i + 1;
		end while;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure clear_db
-- -----------------------------------------------------

DELIMITER $$
USE `albumy_db`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `clear_db`()
BEGIN
--
-- Delete data from the table 'tracktoalbum'
--
DELETE FROM tracktoalbum where tracktoalbum.idtrackToAlbum > 0;
--
-- Delete data from the table 'trackscore'
--
DELETE FROM trackscore where trackscore.idTrackScore > 0;
--
-- Delete data from the table 'albumscore'
--
DELETE FROM albumscore where albumscore.idAlbumScore > 0;
--
-- Delete data from the table 'albumprice'
--
DELETE FROM albumprice where albumprice.idalbumPrice > 0;
--
-- Delete data from the table 'album'
--
DELETE FROM album where album.idAlbum > 0;
--
-- Delete data from the table 'user'
--
DELETE FROM user where user.idUser > 0;
--
-- Delete data from the table 'track'
--
DELETE FROM track where track.idtrack > 0;
--
-- Delete data from the table 'author'
--
DELETE FROM author where author.idauthor > 0;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
