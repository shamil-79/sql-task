create table Author
(  
AuthorID INT PRIMARY KEY IDENTITY(1,1),
AuthorName NVARCHAR(100) NOT NULL
);

create table Publisher
(
 PublisherID INT PRIMARY KEY IDENTITY(1,1),
 PublisherName NVARCHAR(100) NOT NULL
);
alter table Books
ADD AuthorID INT FOREIGN KEY REFERENCES Author(AuthorID),
PublisherID INT FOREIGN KEY REFERENCES Publisher(PublisherID);

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


alter table Books
drop column AuthorID