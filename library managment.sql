CREATE DATABASE LIBRARY;
USE LIBRARY;
/*CREATING A TABLE PUBLISHER*/
CREATE TABLE tbl_publisher ( 
    publisher_PublisherName VARCHAR(255) PRIMARY KEY, 
    publisher_PublisherAddress TEXT, 
    publisher_PublisherPhone VARCHAR(15)
);
												/*LOADING THE DATA AND VERIFING THE DATA IN TABLE*/
													SELECT * FROM tbl_publisher;
/*CREATING A TABLE BOOK*/
CREATE TABLE tbl_book ( 
    book_BookID INT PRIMARY KEY, 
    book_Title VARCHAR(255), 
    book_PublisherName VARCHAR(255), 
    FOREIGN KEY (book_PublisherName) REFERENCES 
tbl_publisher(publisher_PublisherName) 
);
												/*LOADING THE DATA AND VERIFING THE DATA IN THE TABLE*/
													SELECT * FROM tbl_book;
/*CREATING A NEW TABLE BOOK AUTHORS*/
CREATE TABLE tbl_book_authors ( 
    book_authors_AuthorID INT PRIMARY KEY  AUTO_INCREMENT, 
    book_authors_BookID INT, 
    book_authors_AuthorName VARCHAR(255),
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID) 
);
TRUNCATE tbl_book_authors;
												/*LOADING THE DATA AND VERFING THE DATA IN THE TABLE*/
													SELECT * FROM tbl_book_authors;
/*CREATING A TABLE BRANCH*/
CREATE TABLE tbl_library_branch ( 
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT, 
    library_branch_BranchName VARCHAR(255), 
    library_branch_BranchAddress TEXT 
);
											/*LOADING THE DATA AND VERFING THE DATA IN THE TABLE*/
													SELECT * FROM tbl_library_branch;
/*CREATING TEJ TABLE BOOK COPIES*/
CREATE TABLE tbl_book_copies ( 
    book_copies_CopiesID INT PRIMARY KEY AUTO_INCREMENT, 
    book_copies_BookID INT, 
    book_copies_BranchID INT, 
    book_copies_No_Of_Copies INT, 
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID), 
    FOREIGN KEY (book_copies_BranchID) REFERENCES 
tbl_library_branch(library_branch_BranchID) 
);
TRUNCATE tbl_book_copies;
											/*LOADING THE DATA AND VERFING THE DATA IN THE TABLE*/
													SELECT * FROM tbl_book_copies;
/*CREATGIN THE NEW TABLE BORROWER*/
CREATE TABLE tbl_borrower ( 
    borrower_CardNo INT PRIMARY KEY, 
    borrower_BorrowerName VARCHAR(255), 
    borrower_BorrowerAddress TEXT, 
    borrower_BorrowerPhone VARCHAR(15) 
); 
											/*LOADING THE DATA AND VERFING THE DATA IN THE TABLE*/
													SELECT * FROM tbl_borrower;
/*CREATING THE TABLE BOOK LOAN*/
CREATE TABLE tbl_book_loans ( 
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT, 
    book_loans_BookID INT, 
    book_loans_BranchID INT, 
    book_loans_CardNo INT, 
    book_loans_DateOut DATE, 
    book_loans_DueDate DATE, 
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID), 
    FOREIGN KEY (book_loans_BranchID) REFERENCES 
tbl_library_branch(library_branch_BranchID), 
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo) 
);
ALTER TABLE tbl_book_loans 
MODIFY COLUMN book_loans_DateOut VARCHAR(10);
ALTER TABLE tbl_book_loans
MODIFY COLUMN book_loans_DueDate VARCHAR(10); 

TRUNCATE tbl_book_loans;
											/*LOADING THE DATA AND VERFING THE DATA IN THE TABLE*/
													SELECT * FROM tbl_book_loans;
/*Q1 How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"? */
SELECT DISTINCT tbl_book.book_Title,tbl_book_copies.book_copies_No_Of_Copies,tbl_library_branch.library_branch_BranchName
FROM tbl_book
LEFT JOIN tbl_book_copies
ON tbl_book.book_BookID = tbl_book_copies.book_copies_BookID
RIGHT JOIN tbl_library_branch
ON tbl_library_branch.library_branch_BranchID = tbl_book_copies.book_copies_BranchID
WHERE tbl_book.book_Title = 'The Lost Tribe' AND tbl_library_branch.library_branch_BranchName = 'Sharpstown';

/*Q2.How many copies of the book titled "The Lost Tribe" are owned by each library branch? */
SELECT DISTINCT tbl_book.book_Title,tbl_book_copies.book_copies_No_Of_Copies,tbl_library_branch.library_branch_BranchName
FROM tbl_book
LEFT JOIN tbl_book_copies
ON tbl_book.book_BookID = tbl_book_copies.book_copies_BookID
RIGHT JOIN tbl_library_branch
ON tbl_library_branch.library_branch_BranchID = tbl_book_copies.book_copies_BranchID
WHERE tbl_book.book_Title = 'The Lost Tribe';

/*Q3.Retrieve the names of all borrowers who do not have any books checked out.*/
SELECT tbl_borrower.borrower_BorrowerName
FROM tbl_borrower 
WHERE tbl_borrower.borrower_CardNo NOT IN 
										(SELECT tbl_book_loans.book_loans_CardNo FROM tbl_book_loans);

/*Q4.For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the 
borrower's address.*/
SELECT tbl_book.book_Title,tbl_borrower.borrower_BorrowerName,tbl_borrower.borrower_BorrowerAddress,tbl_library_branch.library_branch_BranchName,tbl_book_loans.book_loans_DueDate
FROM tbl_book_loans
LEFT JOIN tbl_library_branch
ON tbl_book_loans.book_loans_BranchID = tbl_library_branch.library_branch_BranchID
LEFT JOIN tbl_book
ON tbl_book.book_BookID=tbl_book_loans.book_loans_BookID
LEFT JOIN tbl_borrower
ON tbl_borrower.borrower_CardNo=tbl_book_loans.book_loans_CardNo
WHERE tbl_book_loans.book_loans_DueDate = '2/3/18' AND tbl_library_branch.library_branch_BranchName = 'Sharpstown';

/*Q5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.*/                                                   
SELECT tbl_library_branch.library_branch_BranchName, COUNT(tbl_book_loans.book_loans_BookID)
FROM tbl_library_branch
LEFT JOIN tbl_book_loans
ON tbl_library_branch.library_branch_BranchID=tbl_book_loans.book_loans_BranchID
GROUP BY 1;  
                                                  
 /* Q6. Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.*/
SELECT tbl_borrower.borrower_BorrowerName,tbl_borrower.borrower_BorrowerAddress,COUNT(tbl_book_copies.book_copies_No_Of_Copies)
FROM tbl_borrower
LEFT JOIN tbl_book_loans
ON tbl_borrower.borrower_CardNo=tbl_book_loans.book_loans_CardNo
LEFT JOIN tbl_book_copies
ON tbl_book_copies.book_copies_BookID = tbl_book_loans.book_loans_BookID 
GROUP BY 1,2
HAVING COUNT(tbl_book_copies.book_copies_No_Of_Copies) > 5;  
                                                 
/*Q7. For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central"*/
SELECT tbl_book_authors.book_authors_AuthorName,
		tbl_book.book_Title,
		tbl_book_copies.book_copies_No_Of_Copies,
        tbl_library_branch.library_branch_BranchName
FROM tbl_book_authors
LEFT JOIN tbl_book
ON tbl_book_authors.book_authors_BookID = tbl_book.book_BookID
LEFT JOIN tbl_book_copies
ON tbl_book.book_BookID = tbl_book_copies.book_copies_BookID
LEFT JOIN tbl_library_branch
ON tbl_book_copies.book_copies_BranchID = tbl_library_branch.library_branch_BranchID
WHERE tbl_book_authors.book_authors_AuthorName = 'Stephen King' AND tbl_library_branch.library_branch_BranchName = 'Central';










