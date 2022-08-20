#List all of the tags
CALL list_all_tags();
#List all the book name by alphabetically
CALL sort_by_book_name();
#List all the book order by the views
CALL sort_By_views();
#List all the genre by alphabetically
CALL sort_By_genre();
#List all the book by the price from expensive to inexpensive
CALL sort_By_price();
#List the book from more famous to less famous
CALL sort_by_rating();
#List all book from newest to oldest
CALL sort_by_date();
#Show the book that published in that date
CALL search_by_published_date('2018-05-22');
#Search the book from the publisher
CALL search_by_publisher('Black library');
#Search the book form author
CALL search_by_author('Guy Haley');

CALL search_by_author('William S.');
#Search the book from ISBN
CALL search_by_ISBN(1238548657895);
#Show the membership that have a membership
CALL membership_Discount();
#Show tags by multiple tags
CALL search_by_multiple_tags('bestseller','90s');
#Show all the book
CALL list_all_book();
#Show the book which have the rice from range to range
CALL search_by_price_range(100,450);
#Insert Customer to the Customer table
CALL list_all_customer();
#Buy book
CALL Buy_book('2022-4-1',1,1,0);
CALL Buy_book('2022/5/20',2,3,0);
CALL Buy_book('2022-4-2',1,1,0);
CALL Buy_book('2022/4/3',2,3,0);
CALL Buy_book('2001/10/21',1,1,0);
CALL Buy_book('2001/10/7',2,4,0);
#list all receipts
CALL list_all_receipts();
#check for the reciepts history
CALL sort_receipts_by_date;
#check customer point
CALL list_all_customer();
#Cancle purchase
CALL cancel_order(3,1,1,0);
#Check the receipts again that does the receipt was gone
CALL list_all_receipts();
#check for the customer credits
CALL list_all_customer();
#search for the history of specific customer
CALL search_receipts_by_customer('poon');


