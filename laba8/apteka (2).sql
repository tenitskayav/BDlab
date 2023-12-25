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
AUTO_INCREMENT = 10
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
AUTO_INCREMENT = 10
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
AUTO_INCREMENT = 12
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `tm` ;

-- -----------------------------------------------------
-- Placeholder table for view `tm`.`remains`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tm`.`remains` (`treatment` INT, `available_for_order` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tm`.`cost_order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tm`.`cost_order` (`orderid` INT, `"Имя заказчика"` INT, `'Заказ'` INT, `'Стоимость заказа '` INT);

-- -----------------------------------------------------
-- Placeholder table for view `tm`.`country_producer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `tm`.`country_producer` (`producername` INT, `country` INT);

-- -----------------------------------------------------
-- View `tm`.`remains`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tm`.`remains`;
USE `tm`;
CREATE  OR REPLACE VIEW `remains` AS
SELECT t.treatment,
	CASE
WHEN t.remains - SUM(o.amount) < 0
 THEN 'недоступно для заказа'
ELSE t.remains - SUM(o.amount)
END AS available_for_order
FROM orders o
INNER JOIN treatments t ON o.treatid = t.treatid
WHERE CURRENT_TIMESTAMP() <= o.dateofdelivery
GROUP BY o.treatid,o.amount, o.dateofdelivery ;

-- -----------------------------------------------------
-- View `tm`.`cost_order`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tm`.`cost_order`;
USE `tm`;
CREATE  OR REPLACE VIEW `cost_order` AS
SELECT orderid, customername AS "Имя заказчика",CONCAT(treatment, ', Количество:', amount) AS 'Заказ', (amount*cost) AS 'Стоимость заказа' FROM orders ord
INNER JOIN treatments tr ON ord.treatid = tr.treatid;

-- -----------------------------------------------------
-- View `tm`.`country_producer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tm`.`country_producer`;
USE `tm`;
CREATE  OR REPLACE VIEW `country_producer` AS
SELECT DISTINCT producername, country FROM producer;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
