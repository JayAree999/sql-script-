# 
# https://dba.stackexchange.com/questions/74627/difference-between-on-delete-cascade-on-update-cascade-in-mysql
-- -----------------------------------------------------
-- Schema OnlineBookStore
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `OnlineBookStore` ;

-- -----------------------------------------------------
-- Schema OnlineBookStore
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `OnlineBookStore` DEFAULT CHARACTER SET utf8 ;
USE `OnlineBookStore` ;

-- -----------------------------------------------------
-- Table `OnlineBookStore`.`edition`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `OnlineBookStore`.`edition` ;

CREATE TABLE IF NOT EXISTS `OnlineBookStore`.`edition` (
  `ISBN` BIGINT NOT NULL,
  `publisher` VARCHAR(255) NOT NULL,
  `published_date` DATE NULL,
  `page_count` INT NULL,
  `volume` INT NULL,
  `rating` INT NULL,
  PRIMARY KEY (`ISBN`));


-- -----------------------------------------------------
-- Table `OnlineBookStore`.`book`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `OnlineBookStore`.`book` ;

CREATE TABLE IF NOT EXISTS `OnlineBookStore`.`book` (
  `book_id` BIGINT NOT NULL AUTO_INCREMENT,
  `book_title` VARCHAR(255) NOT NULL,
  `price` DECIMAL(8,2) NULL,
  `views` INT NULL,
  `Edition_ISBN` BIGINT NOT NULL,
  PRIMARY KEY (`book_id`),
  CONSTRAINT `fk_Book_Edition1`
    FOREIGN KEY (`Edition_ISBN`)
    REFERENCES `OnlineBookStore`.`edition` (`ISBN`)
    ON DELETE CASCADE ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Table `OnlineBookStore`.`tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `OnlineBookStore`.`tag` ;

CREATE TABLE IF NOT EXISTS `OnlineBookStore`.`tag` (
  `tag_id` INT NOT NULL AUTO_INCREMENT,
  `tag_name` VARCHAR(80) NOT NULL,
  PRIMARY KEY (`tag_id`));



-- -----------------------------------------------------
-- Table `OnlineBookStore`.`book_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `OnlineBookStore`.`book_tag` ;

CREATE TABLE IF NOT EXISTS `OnlineBookStore`.`book_tag` (
  `Book_book_id` bigint NOT NULL,
  `Tag_tag_id` INT NOT NULL,
  PRIMARY KEY (`Book_book_id`, `Tag_tag_id`),
  CONSTRAINT `fk_Book_has_Tag_Book`
    FOREIGN KEY (`Book_book_id`)
    REFERENCES `OnlineBookStore`.`book` (`book_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Book_has_Tag_Tag1`
    FOREIGN KEY (`Tag_tag_id`)
    REFERENCES `OnlineBookStore`.`tag` (`tag_id`)
    ON DELETE CASCADE ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Table `OnlineBookStore`.`genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `OnlineBookStore`.`genre` ;

CREATE TABLE IF NOT EXISTS `OnlineBookStore`.`genre` (
  `genre_id` INT NOT NULL AUTO_INCREMENT,
  `genre_name` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`genre_id`));


-- -----------------------------------------------------
-- Table `OnlineBookStore`.`book_genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `OnlineBookStore`.`book_genre` ;

CREATE TABLE IF NOT EXISTS `OnlineBookStore`.`book_genre` (
  `Book_book_id` bigint NOT NULL,
  `Genre_genre_id` INT NOT NULL,
  PRIMARY KEY (`Book_book_id`, `Genre_genre_id`),
  CONSTRAINT `fk_Book_has_Genre_Book1`
    FOREIGN KEY (`Book_book_id`)
    REFERENCES `OnlineBookStore`.`book` (`book_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Book_has_Genre_Genre1`
    FOREIGN KEY (`Genre_genre_id`)
    REFERENCES `OnlineBookStore`.`genre` (`genre_id`)
    ON DELETE CASCADE ON UPDATE CASCADE);

-- -----------------------------------------------------
-- Table `OnlineBookStore`.`author`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `OnlineBookStore`.`author` ;

CREATE TABLE IF NOT EXISTS `OnlineBookStore`.`author` (
  `author_id` INT NOT NULL AUTO_INCREMENT,
  `author_name` VARCHAR(255) NOT NULL,
  `penname` VARCHAR(255) NULL,
  PRIMARY KEY (`author_id`));

-- -----------------------------------------------------
-- Table `OnlineBookStore`.`book_author`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `OnlineBookStore`.`book_author` ;

CREATE TABLE IF NOT EXISTS `OnlineBookStore`.`book_author` (
  `Book_book_id` bigint NOT NULL,
  `author_author_id` INT NOT NULL,
  PRIMARY KEY (`Book_book_id`, `author_author_id`),
  CONSTRAINT `fk_Book_has_author_Book1`
    FOREIGN KEY (`Book_book_id`)
    REFERENCES `OnlineBookStore`.`book` (`book_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_Book_has_author_author1`
    FOREIGN KEY (`author_author_id`)
    REFERENCES `OnlineBookStore`.`author` (`author_id`)
    ON DELETE CASCADE ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Table `OnlineBookStore`.`customer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `OnlineBookStore`.`customer` ;

CREATE TABLE IF NOT EXISTS `OnlineBookStore`.`customer` (
    customer_id   int       auto_increment   not null
    primary key,
    customer_name varchar(255) null,
    phone_number  varchar(255)          null,
    credits       int          null,
    membership    boolean   null
                                                        );


-- -----------------------------------------------------
-- Table `OnlineBookStore`.`receipt`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `OnlineBookStore`.`receipt` ;

CREATE TABLE IF NOT EXISTS `OnlineBookStore`.`receipt` (
  `Receipt_Date` DATE NOT NULL,
  `receipt_id` INT NOT NULL AUTO_INCREMENT,
  `total_price` DECIMAL(8,2) NULL,
  `Book_book_id` bigint NOT NULL,
  `customer_customer_id` INT NOT NULL,

  PRIMARY KEY (`receipt_id`),
  CONSTRAINT `fk_receipt_Book1`
    FOREIGN KEY (`Book_book_id`)
    REFERENCES `OnlineBookStore`.`book` (`book_id`)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_receipt_customer1`
    FOREIGN KEY (`customer_customer_id`)
    REFERENCES `OnlineBookStore`.`customer` (`customer_id`)
    ON DELETE CASCADE ON UPDATE CASCADE);


-- -----------------------------------------------------
-- Table `OnlineBookStore`.`discount`
-- -----------------------------------------------------
DROP TABLE IF EXISTS discount;
create table discount
(
    discount_id                   int auto_increment       not null
        primary key,
    customer_id                   int        null,
    discount_for_membership       boolean null,
    discount_for_store_promotions boolean null,
    discount_for_credits          boolean null,
    constraint discount_ibfk_1
        foreign key (customer_id) references customer (customer_id)
);


