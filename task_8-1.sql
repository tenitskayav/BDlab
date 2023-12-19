-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema tm
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema tm
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tm` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `tm` ;

-- -----------------------------------------------------
-- Table `tm`.`producer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tm`.`producer` (
  `prodid` INT NOT NULL AUTO_INCREMENT,
  `producername` VARCHAR(100) NOT NULL,
  `country` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`prodid`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `tm`.`treatments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tm`.`treatments` (
  `treatid` INT NOT NULL AUTO_INCREMENT,
  `treatment` VARCHAR(100) NOT NULL,
  `descriptionoftreatment` VARCHAR(500) NULL DEFAULT NULL,
  `dose` INT NOT NULL,
  `amountinpackage` INT NOT NULL,
  `cost` INT NOT NULL,
  `link` VARCHAR(500) NULL DEFAULT NULL,
  `receiptdate` TIMESTAMP NOT NULL,
  `amountofpackage` INT NOT NULL,
  `prodid` INT NOT NULL,
  `remains` INT NOT NULL,
  PRIMARY KEY (`treatid`),
  INDEX `fk_treatments_prodid` (`prodid` ASC) VISIBLE,
  CONSTRAINT `fk_treatments_prodid`
    FOREIGN KEY (`prodid`)
    REFERENCES `tm`.`producer` (`prodid`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `tm`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tm`.`orders` (
  `orderid` INT NOT NULL AUTO_INCREMENT,
  `numoforder` INT NOT NULL,
  `treatid` INT NOT NULL,
  `amount` INT NOT NULL,
  `customername` VARCHAR(200) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `dateoforder` TIMESTAMP NOT NULL,
  `dateofdelivery` TIMESTAMP NOT NULL,
  `dateofbuying` TIMESTAMP NOT NULL,
  PRIMARY KEY (`orderid`),
  INDEX `fk_orders_treatid` (`treatid` ASC) VISIBLE,
  CONSTRAINT `fk_orders_treatid`
    FOREIGN KEY (`treatid`)
    REFERENCES `tm`.`treatments` (`treatid`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `tm` ;

-- -----------------------------------------------------
-- Placeholder table for view `tm`.`view1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tm`.`view1` (`producername` INT, `country` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tm`.`view3`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tm`.`view3` (`customername` INT, `cost` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tm`.`view2`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tm`.`view2` (`treatment` INT);

-- -----------------------------------------------------
-- View `tm`.`view1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tm`.`view1`;
USE `tm`;
CREATE  OR REPLACE VIEW `view1` as 
SELECT producername, country FROM producer
WHERE country = 'Germany';

-- -----------------------------------------------------
-- View `tm`.`view3`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tm`.`view3`;
USE `tm`;
CREATE  OR REPLACE VIEW `view3` AS
select customername, (amount*cost) as cost from orders ord
inner join treatments tr on ord.treatid = tr.treatid;

-- -----------------------------------------------------
-- View `tm`.`view2`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tm`.`view2`;
USE `tm`;
CREATE  OR REPLACE VIEW `view2` AS
select treatment from treatments tr
inner join orders ord on tr.treatid = ord.treatid
where remains != 0 or tr.remains >= ord.amount;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
