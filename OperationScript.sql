
#================================ S O R T ==================================================#

DROP PROCEDURE IF EXISTS sort_By_genre;
DELIMITER $$
create procedure sort_By_genre()
begin
    SELECT #OnlineBookStore.book.book_id,
           OnlineBookStore.book.book_title,
           #OnlineBookStore.author.author_id AS author_id,
           OnlineBookStore.author.author_name AS author_name,
           #OnlineBookStore.genre.genre_id AS genre_id,
           OnlineBookStore.genre.genre_name AS genre_name
    FROM Book
    JOIN book_author on (Book.book_id=Book_Author.Book_book_id)
    JOIN author on (Author.author_id=Book_Author.author_author_id)
    JOIN book_genre on (Book.book_id=Book_genre.Book_book_id)
    JOIN genre on (Genre.genre_id =book_genre.Genre_genre_id)
    ORDER BY genre_name;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sort_By_price;
DELIMITER $$
create procedure sort_By_price()
begin
    SELECT OnlineBookStore.book.book_title,
           OnlineBookStore.author.author_name as author_name,
           OnlineBookStore.book.price as price
    FROM Book
    JOIN book_author on (Book.book_id=Book_Author.Book_book_id)
    JOIN author on (Author.author_id=Book_Author.author_author_id)
    ORDER BY price ASC ;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sort_By_views;
DELIMITER $$
create procedure sort_By_views()
begin
    SELECT OnlineBookStore.book.book_title,
           OnlineBookStore.author.author_name as author_name,
           OnlineBookStore.book.views as view
    FROM Book
    JOIN book_author on (Book.book_id=Book_Author.Book_book_id)
    JOIN author on (Author.author_id=Book_Author.author_author_id)
    ORDER BY view DESC ;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS sort_by_rating;
DELIMITER $$
create procedure sort_by_rating()
begin
    SELECT OnlineBookStore.book.book_title,
           OnlineBookStore.author.author_name as author_name,
           OnlineBookStore.edition.rating as rating
    FROM Book
    JOIN book_author on (Book.book_id=Book_Author.Book_book_id)
    JOIN author on (Author.author_id=Book_Author.author_author_id)
    JOIN edition on (Book.Edition_ISBN=edition.ISBN)
    ORDER BY rating DESC ;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sort_by_date;
DELIMITER $$
create procedure sort_by_date()
begin
    SELECT OnlineBookStore.book.book_title as book_title,
           OnlineBookStore.author.author_name as author_name,
           OnlineBookStore.edition.published_date as published_date
    FROM book
    JOIN book_author on (Book.book_id=Book_Author.Book_book_id)
    JOIN author on (Author.author_id=Book_Author.author_author_id)
    JOIN edition on (Book.Edition_ISBN=edition.ISBN)
    ORDER BY published_date DESC;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sort_by_book_name;
DELIMITER $$
create procedure sort_by_book_name()
begin
     SELECT OnlineBookStore.book.book_title as book_title,
           OnlineBookStore.author.author_name as author_name
    FROM Book
    JOIN book_author on (Book.book_id=Book_Author. Book_book_id)
    JOIN author on (Author.author_id=Book_Author.author_author_id)
    ORDER BY book_title;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS membership_Discount;
DELIMITER $$
create procedure membership_Discount()
begin
    SELECT customer_id,customer_name
    FROM customer
    WHERE membership = 1;

END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS sort_receipts_by_date;
DELIMITER $$
create procedure sort_receipts_by_date()
begin
    SELECT * from receipt
        JOIN book b on b.book_id = receipt.Book_book_id
        JOIN customer c on c.customer_id = receipt.customer_customer_id
        ORDER BY Receipt_Date DESC ;
END $$
DELIMITER ;

#================================ S E A R C H ==================================================#

DROP PROCEDURE IF EXISTS search_by_published_date;
DELIMITER $$
create procedure search_by_published_date(taget_date DATE)
begin
     SELECT OnlineBookStore.book.book_title as book_title,
           OnlineBookStore.author.author_name as author_name

     FROM book
     JOIN book_author on (Book.book_id=Book_Author.Book_book_id)
     JOIN author on (Author.author_id=Book_Author.author_author_id)
     JOIN edition on (Book.Edition_ISBN=edition.ISBN)
     WHERE taget_date = published_date;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS search_by_price_range;
DELIMITER $$
create procedure search_by_price_range(price1 DECIMAL,price2 DECIMAL)
begin
    SELECT OnlineBookStore.book.book_title as book_title,
           OnlineBookStore.author.author_name as author_name,
           OnlineBookStore.book.price as price
    FROM book
    JOIN book_author on (Book.book_id=Book_Author.Book_book_id)
    JOIN author on (Author.author_id=Book_Author.author_author_id)
    WHERE price BETWEEN price1 and price2;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS search_by_ISBN;
DELIMITER $$
create procedure search_by_ISBN(target_ISBN bigint)
begin
    SELECT OnlineBookStore.book.book_title as book_title,
           OnlineBookStore.author.author_name as author_name,
           OnlineBookStore.edition.ISBN as ISBN
     FROM book
     JOIN book_author on (Book.book_id=Book_Author.Book_book_id)
     JOIN author on (Author.author_id=Book_Author.author_author_id)
     JOIN edition on (Book.Edition_ISBN=edition.ISBN)
     WHERE target_ISBN = ISBN;


END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS search_receipts_by_customer;
DELIMITER $$
create procedure search_receipts_by_customer(target_name varchar(255))
begin
    SELECT * from receipt
        JOIN book b on b.book_id = receipt.Book_book_id
        JOIN customer c on c.customer_id = receipt.customer_customer_id
    WHERE target_name = customer_name;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS search_By_Multiple_Tags;
DELIMITER $$
create procedure search_by_multiple_tags(tag1 varchar(80),tag2 varchar(80))
begin
    SELECT OnlineBookStore.book.book_title as book_title,
           OnlineBookStore.author.author_name as author_name,
           OnlineBookStore.tag.tag_name as tag
    FROM book
    JOIN book_author on (Book.book_id=Book_Author.Book_book_id)
    JOIN author on (Author.author_id=Book_Author.author_author_id)
    JOIN book_tag on (Book.book_id=Book_Tag.Book_book_id)
    JOIN tag on (Tag.tag_id=book_tag.Tag_tag_id)
    WHERE tag1 = tag_name OR tag2 = tag_name;
END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS search_by_author;
DELIMITER $$
create procedure search_by_author(target_author_name varchar(255))
begin
    SELECT OnlineBookStore.book.book_title,
           OnlineBookStore.author.author_name as author_name
    FROM Book
    JOIN book_author on (Book.book_id=Book_Author.Book_book_id)
    JOIN author on (Author.author_id=Book_Author.author_author_id)
    WHERE target_author_name = author_name;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS search_by_publisher;
DELIMITER $$
create procedure search_by_publisher(target_publisher varchar(255))
begin
      SELECT OnlineBookStore.book.book_title,
             OnlineBookStore.edition.publisher as publisher
      FROM book
      JOIN edition on (Book.Edition_ISBN=edition.ISBN)
      WHERE target_publisher = publisher;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS search_by_book_name;
DELIMITER $$
create procedure search_by_book_name(bookName varchar(255))
begin
     SELECT OnlineBookStore.book.book_title as book_title,
           OnlineBookStore.author.author_name as author_name
    FROM Book
    JOIN book_author on (Book.book_id=Book_Author.Book_book_id)
    JOIN author on (Author.author_id=Book_Author.author_author_id)
    WHERE bookName = book_title;

END $$
DELIMITER ;


