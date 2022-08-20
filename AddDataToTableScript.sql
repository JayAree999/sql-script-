#================================ I N S E R T ==================================================#
#insert edition
DROP PROCEDURE IF EXISTS insert_edition;
DELIMITER $$
create procedure insert_edition(IN ISBN bigint, IN publisher varchar(255), IN published_date DATE, IN page_count int, IN volume int, IN rating int)
begin
    INSERT INTO edition(ISBN,publisher,published_date,page_count,volume,rating) VALUES (ISBN,publisher,published_date,page_count,volume,rating);
END $$
DELIMITER ;

#insert book
DROP PROCEDURE IF EXISTS insert_book;
DELIMITER $$
create procedure insert_book(IN book_title varchar(255), IN price DECIMAL(8,2), IN views int , IN ISBN bigint, IN publisher varchar(255),
IN published_date DATE, IN page_count int, IN volume int, IN rating int, IN author_id int, IN tag_id int, IN genre_id int )

begin
    INSERT INTO edition(ISBN,publisher,published_date,page_count,volume,rating) VALUES (ISBN,publisher,published_date,page_count,volume,rating);
    INSERT INTO book(book_title,price,views,Edition_ISBN) VALUES (book_title,price,views,ISBN);
    SET @current_book = LAST_INSERT_ID();
    INSERT INTO book_author (book_book_id, author_author_id) VALUES (@current_book, author_id);
    INSERT INTO book_genre (Book_book_id, Genre_genre_id) VALUES (@current_book, genre_id);
    INSERT INTO book_tag (Book_book_id, Tag_tag_id) VALUES (@current_book, tag_id);
END $$
DELIMITER ;

#insert tag
DROP PROCEDURE IF EXISTS insert_tag;
DELIMITER $$
create procedure insert_tag(IN tag_name varchar(80))
begin
    INSERT INTO tag(tag_name) VALUES (tag_name);
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS insert_book_tag;
DELIMITER $$
create procedure insert_book_tag(IN book_id bigint, IN tag_id int)
begin
    INSERT INTO book_tag (Book_book_id, Tag_tag_id) VALUES (@current_book, tag_id);
END $$
DELIMITER ;



#insert genre

DROP PROCEDURE IF EXISTS insert_genre;
DELIMITER $$
create procedure insert_genre(IN genre_name varchar(255))
begin
    INSERT INTO genre(genre_name) VALUES (genre_name);
END $$
DELIMITER ;






DROP PROCEDURE IF EXISTS insert_book_genre;
DELIMITER $$
create procedure insert_book_genre(IN book_id bigint, IN genre_id int)
begin
    INSERT INTO book_genre VALUES (book_id, genre_id);
END $$
DELIMITER ;



#insert author

DROP PROCEDURE IF EXISTS insert_author;
DELIMITER $$
create procedure insert_author(IN author_name varchar(255), IN penname varchar(255))
begin
    INSERT INTO author(author_name,penname) VALUES (author_name,penname);
END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS insert_book_author;
DELIMITER $$
create procedure insert_book_author(IN book_id bigint, IN author_id int)
begin
    INSERT INTO book_author VALUES (book_id, author_id);
END $$
DELIMITER ;


#insert customer
DROP PROCEDURE IF EXISTS insert_customer;
DELIMITER $$
create procedure insert_customer(IN customer_name varchar(255), IN phone_number varchar(255), IN credits int ,IN membership boolean)
begin
    INSERT INTO customer(customer_name, phone_number, credits, membership) VALUES (customer_name, phone_number,credits,membership);
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS insert_discount;
DELIMITER $$
create procedure insert_discount(IN Customer_id int , IN discount_for_store_promotions boolean, IN discount_for_credits boolean)
begin
    INSERT INTO discount(customer_id, discount_for_membership, discount_for_store_promotions, discount_for_credits)
    VALUES ((SELECT customer_id FROM customer WHERE customer.customer_id IN (Customer_id)),
            (SELECT membership FROM customer WHERE customer.customer_id IN (Customer_id)),
            discount_for_store_promotions
            ,discount_for_credits);
END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS Buy_book;
DELIMITER //
create procedure Buy_book(IN reciept_date date,IN Customer_id int ,IN book_sold_id bigint, use_credits boolean)

begin
    set @current_book_price= (SELECT price from book WHERE book.book_id=book_sold_id);
    set @tag_name = (SELECT tag.tag_id FROM book
    JOIN book_tag on book_id=Book_book_id
    JOIN tag on (Tag.tag_id=book_tag.Tag_tag_id)
    WHERE tag_id=3 and book_id=book_sold_id);
    set @current_credits = (SELECT credits from customer WHERE customer.customer_id IN (Customer_id));

    INSERT INTO receipt(Receipt_Date,customer_customer_id,Book_book_id,total_price)
    VALUES (reciept_date,
            (SELECT customer_id FROM customer WHERE customer.customer_id IN (Customer_id)),
            (SELECT book_id FROM book WHERE book.book_id=book_sold_id),
            #check membership/credits/promo either one
            (SELECT CASE

                        WHEN @tag_name='promo' THEN @current_book_price*0.9
                        WHEN (SELECT membership FROM customer WHERE customer.customer_id IN (customer_id)) = 1
                            THEN @current_book_price - 30
                        WHEN @current_credits>0 and use_credits=true
                            THEN @current_book_price - 10
                ELSE @current_book_price

                END
                    ));

            #add credits to user/delete credits if used

    CASE use_credits
     WHEN false THEN
             UPDATE customer
    SET credits = @current_credits+@current_book_price*0.5
WHERE customer.customer_id IN (Customer_id);
      WHEN true AND @current_credits>1000 THEN
          UPDATE customer
    SET credits = @current_credits-1000
    WHERE customer.customer_id IN (Customer_id);
          ELSE UPDATE customer
    SET credits = @current_credits+@current_book_price*0.5
    WHERE customer.customer_id IN (Customer_id);
END CASE;

END //
DELIMITER ;

#================================ L I S T ==================================================#

#List all books
DROP PROCEDURE IF EXISTS list_all_book;

DELIMITER $$
create procedure list_all_book()
begin
    SELECT OnlineBookStore.Book.book_id, OnlineBookStore.Book.book_title, OnlineBookStore.Book.price, OnlineBookStore.Book.views,
    author.author_id AS author_id, author.author_name AS author_name, genre.genre_id AS genre_id, genre.genre_name AS genre_name, tag.tag_id AS tag_id,
    tag.tag_name AS tag_name
    FROM Book
    JOIN book_author on (Book.book_id=Book_Author.Book_book_id)
    JOIN author on (Author.author_id=Book_Author.author_author_id)
    JOIN book_genre on (Book.book_id=Book_genre.Book_book_id)
    JOIN genre on (Genre.genre_id =book_genre.Genre_genre_id)
    JOIN book_tag on (Book.book_id=Book_Tag.Book_book_id)
    JOIN tag on (Tag.tag_id=book_tag.Tag_tag_id);
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS list_all_receipts;
DELIMITER $$
create procedure list_all_receipts()
begin
    SELECT * from receipt
        JOIN book b on b.book_id = receipt.Book_book_id
        JOIN customer c on c.customer_id = receipt.customer_customer_id;
END $$
DELIMITER ;



DROP PROCEDURE IF EXISTS list_all_tags;
DELIMITER $$
create procedure list_all_tags()
begin
    SELECT tag_name FROM tag;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS list_all_customer;
DELIMITER $$
create procedure list_all_customer()
begin
    SELECT customer_id,customer_name,credits,membership
    FROM customer;
END $$
DELIMITER ;


#================================ D E L E T E ==================================================#



# delete genre WARNING! if u delete this genre book associated with the genre will also get deleted if that book only has 1 genre
DROP PROCEDURE IF EXISTS delete_genre;
DELIMITER $$
CREATE PROCEDURE delete_genre(id INT)
BEGIN
    DELETE FROM genre WHERE genre.genre_id = id;
END $$
DELIMITER ;


# delete book WARNING! if that book is associated with author/genre/tag/edition they may also get deleted if there is only of instance of those var
DROP PROCEDURE IF EXISTS delete_book;
DELIMITER $$
CREATE PROCEDURE delete_book(id INT)
BEGIN
    DELETE FROM book WHERE book.book_id = id;
END $$
DELIMITER ;

# delete tag WARNING! if u delete this tag book associated with the tag may also get deleted if that book only has 1 tag
DROP PROCEDURE IF EXISTS delete_tag;
DELIMITER $$
CREATE PROCEDURE delete_tag(id INT)
BEGIN
    DELETE FROM tag WHERE tag.tag_id = id;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS cancel_order;
DELIMITER //
create procedure cancel_order(IN Receipt_id int ,IN Customer_id int,IN book_sold_id bigint, use_credits boolean)

begin
    CASE
        WHEN (SELECT receipt_id from receipt WHERE receipt.receipt_id=Receipt_id)=Receipt_id
            THEN DELETE from receipt where receipt.receipt_id=Receipt_id;

    END CASE;

    set @current_book_price= (SELECT price from book WHERE book.book_id=book_sold_id);
    set @tag_id = (SELECT tag.tag_id FROM book
    JOIN book_tag on book_id=Book_book_id
    JOIN tag on (Tag.tag_id=book_tag.Tag_tag_id)
    WHERE tag_id=3 and book_id=book_sold_id);
    set @current_credits = (SELECT credits from customer WHERE customer.customer_id IN (Customer_id));

    #add credits to user/delete credits if usedq
    CASE use_credits
    WHEN true THEN
          UPDATE customer
    SET credits = @current_credits+1000+(@current_book_price*0.5)
    WHERE customer.customer_id IN (Customer_id);

    WHEN false and @current_credits>0 THEN
          UPDATE customer
    SET credits = @current_credits-(@current_book_price*0.5)
    WHERE customer.customer_id IN (Customer_id);

END CASE;

END //
DELIMITER ;

# delete author WARNING! if u delete this author, book associated with the author will also get deleted if that book only has 1 author
DROP PROCEDURE IF EXISTS delete_author;
DELIMITER $$
CREATE PROCEDURE delete_author(id INT)
BEGIN
    DELETE FROM author WHERE author.author_id = id;
END $$
DELIMITER ;


DROP PROCEDURE IF EXISTS delete_discount;
DELIMITER $$
CREATE PROCEDURE delete_discount(id INT)
BEGIN
    DELETE FROM discount WHERE discount.discount_id = id;
END $$
DELIMITER ;

#Create dummy data:
#Create Author information to the author table
CALL insert_author('William S.', 'William S.');
CALL insert_author('Rowling','J.K.');
CALL insert_author('Guy Haley','Guy Haley');

#Add Genre to the database
CALL insert_genre('scifi');
CALL insert_genre('action');
CALL insert_genre('horror');
CALL insert_genre('romance');
CALL insert_genre('history');

#Add tag to the database
CALL insert_tag('bestseller');
CALL insert_tag('90s');
CALL insert_tag('70s');
call insert_tag('promo');



#Add the book to the database
#In Book we have a Author information that came from the Author table
#The Genre and Tag are from Genre and Tag table
CALL insert_book('helloworld',154.50,30, 0989693554, 'Oxford press','2000-07-16',
    122,1,5,1,1,1);
#Inorder that the book have multiple authors we need to call "insert_book_author" to insert additional author to the book
CALL insert_book_author(1,2);
#Inorder that the book have multiple tags we need to call "insert_book_tag" to insert additional tag to the book
CALL insert_book_tag(1,2); #add tag name 90s to book helloworld
#Inorder that the book have multiple genres we need to call "insert_book_genre" to insert additional genre to the book
CALL insert_book_genre(1,2); #add genre action to book helloworld


CALL insert_book('onepiece',222,20,1989693654,'sunrise','2018-05-22',122,1,4,2,2,1);

CALL insert_book_author(2,3);

CALL insert_book('pdff',154.50,30, 6989693584, 'Cambridge','2001-07-16',
    12,1,5,2,1,3);

CALL insert_book('Jaylovescat',154.50,30, 6489693584, 'Cambridge','2001-07-16',
    12,1,5,2,4,3);
CALL insert_book_genre(4,4);

CALL insert_book('Dark Imperium',890,15,1238548657895,'Black library','2021-05-18',780,4,2,3,1,1);
CALL insert_book_genre(5,2);
CALL insert_book_genre(5,3);

#Customer Register
CALL insert_customer('poon','0123456123',0,1);
CALL insert_customer('jay','123456123',0,0);
CALL insert_customer('jew','0984961453',0,0);
CALL insert_customer('bosssexy','0364851568',0,1);

#Insert Discount
CALL insert_discount(1,1,1);
CALL insert_discount(4,1,1);