CREATE TABLE Books (
    BookID INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255) NOT NULL,
    Author NVARCHAR(100) NOT NULL,
    PublicationYear INT
);


INSERT INTO Books (Title, Author, PublicationYear) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald', 1925),
('To Kill a Mockingbird', 'Harper Lee', 1960),
('1984', 'George Orwell', 1949),
('Pride and Prejudice', 'Jane Austen', 1813),
('The Catcher in the Rye', 'J.D. Salinger', 1951);
UPDATE Books SET Title='Harry Potter' WHERE BookID=3;

SELECT * FROM Books WHERE PublicationYear = 1951;

SELECT * FROM Books WHERE Author = 'Jane Austen';

SELECT DISTINCT Author FROM Books;
CREATE TABLE Author (
    AuthorID INT PRIMARY KEY IDENTITY(1,1),
    AuthorName NVARCHAR(100) NOT NULL
);
CREATE TABLE Publisher (
    PublisherID INT PRIMARY KEY IDENTITY(1,1),
    PublisherName NVARCHAR(100) NOT NULL
);

ALTER TABLE Books
ADD AuthorID INT FOREIGN KEY REFERENCES Author(AuthorID),PublisherID INT FOREIGN KEY REFERENCES Publisher(PublisherID)

INSERT INTO Author (AuthorName) VALUES
('F. Scott Fitzgerald'),
('Harper Lee'),
('George Orwell'),
('Jane Austen'),
('J.D. Salinger');

INSERT INTO Publisher (PublisherName) VALUES
('Scribner'),
('J.B. Lippincott & Co.'),
('Secker & Warburg'),
('Thomas Egerton'),
('Little, Brown and Company');

SELECT *FROM Books
UPDATE Books SET AuthorID=1,PublisherID=1  WHERE BookID=1
UPDATE Books SET AuthorID=2,PublisherID=2  WHERE BookID=2
UPDATE Books SET AuthorID=3,PublisherID=3  WHERE BookID=3
UPDATE Books SET AuthorID=4,PublisherID=4  WHERE BookID=4
UPDATE Books SET AuthorID=5,PublisherID=5  WHERE BookID=5


	SELECT Title,Author.AuthorName,Publisher.PublisherName FROM Books 
	 RIGHT JOIN Author ON Author.AuthorID=Books.AuthorID
	 RIGHT JOIN Publisher ON Publisher.PublisherID=Books.PublisherID
 

 INSERT INTO Books (Title, Author, PublicationYear) VALUES ('The Great Gatsby', 'F. Scott Fitzgerald', 1925)

SELECT Title FROM Books
UNION
SELECT PublisherName FROM Publisher;
SELECT Title FROM Books
UNION ALL
SELECT PublisherName FROM Publisher;


CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    SaleDate DATE,
    SaleAmount DECIMAL(10, 2) NOT NULL
);
SELECT *FROM  Sales
INSERT INTO Sales (BookID, SaleDate, SaleAmount) VALUES
(1, '2022-01-15', 50.00),
(2, '2022-02-01', 75.50),
(3, '2022-03-10', 120.25),
(4, '2022-01-20', 90.75),
(5, '2022-02-28', 60.00);


-- Calculate total sales amount for each book
SELECT b.Title, SUM(s.SaleAmount) AS TotalSalesAmount
FROM Books b
INNER JOIN Sales s ON b.BookID = s.BookID
GROUP BY b.Title;
-- Group sales data by book and year
SELECT b.Title, YEAR(s.SaleDate) AS SaleYear, SUM(s.SaleAmount) AS TotalSalesAmount
FROM Books b
INNER JOIN Sales s ON b.BookID = s.BookID
GROUP BY b.Title, YEAR(s.SaleDate);

-- Filter books with total sales exceeding a specific threshold
SELECT b.Title, SUM(s.SaleAmount) AS TotalSalesAmount
FROM Books b
INNER JOIN Sales s ON b.BookID = s.BookID
GROUP BY b.Title
HAVING SUM(s.SaleAmount) > 60; -- Replace 1000 with the desired threshold


-- Create a stored procedure to retrieve total sales for a book
CREATE PROCEDURE GetTotalSalesForBook
    @BookTitle NVARCHAR(255)
AS
BEGIN
    SELECT b.Title, SUM(s.SaleAmount) AS TotalSalesAmount 
    FROM Books b
    INNER JOIN Sales s ON b.BookID = s.BookID
    WHERE b.Title = @BookTitle
    GROUP BY b.Title;
END;
 -- THIS HOW TO EXCUTE S-POCEDURE EXEC OR EXECUTE QUERY
EXEC GetTotalSalesForBook @BookTitle = 'The Great Gatsby';

-- Define a user-defined function (UDF) to calculate average sale amount
CREATE FUNCTION dbo.CalculateAverageSaleAmount (@BookID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @AverageSaleAmount DECIMAL(10, 2);

    SELECT @AverageSaleAmount = AVG(SaleAmount)
    FROM Sales
    WHERE BookID = @BookID;

    RETURN @AverageSaleAmount;
END;

SELECT dbo.CalculateAverageSaleAmount(1) AS AverageSaleAmount;

-- Create a stored procedure to retrieve all book titles
CREATE PROCEDURE GetAllBookTitles
AS
BEGIN
    SELECT Title
    FROM Books;
END;

EXEC GetAllBookTitles;

-- Create a stored procedure to get books by a specific author
CREATE PROCEDURE GetBooksByAuthor
    @AuthorName NVARCHAR(100)
AS
BEGIN
    SELECT Title
    FROM Books
    WHERE Author = @AuthorName;
END;

-- Execute GetBooksByAuthor stored procedure
DECLARE @Author NVARCHAR(100) = 'Jane Austen'; -- Replace with the author's name
EXEC GetBooksByAuthor @Author;

-- Create a function to return the number of books by a specific author
CREATE FUNCTION dbo.GetNumberOfBooksByAuthor (@AuthorName NVARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @NumberOfBooks INT;

    SELECT @NumberOfBooks = COUNT(*)
    FROM Books
    WHERE Author = @AuthorName;

    RETURN @NumberOfBooks;
END;

-- Execute GetNumberOfBooksByAuthor function
DECLARE @NumberOfBooks INT;
SET @NumberOfBooks = dbo.GetNumberOfBooksByAuthor('Jane Austen'); -- Replace with the author's name
SELECT @NumberOfBooks AS NumberOfBooks;

-- Create a view to retrieve Book and Author details
CREATE VIEW BookAuthorDetails AS
SELECT
    B.BookID,
    B.Title AS BookTitle,
    B.PublicationYear,
    A.AuthorID,
    A.AuthorName
FROM
    Books B
JOIN
    Author A ON B.AuthorID = A.AuthorID;

	-- Select data from the BookAuthorDetails view
SELECT * FROM BookAuthorDetails;


















