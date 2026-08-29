-- =====================================================
-- ONLINE BOOKSTORE SQL ANALYSIS
-- PostgreSQL
-- =====================================================


-- =====================================================
-- 1. DATABASE & TABLE SETUP
-- =====================================================

CREATE DATABASE OnlineBookstore;

Drop Table if exists Books;


Create table Books (
	Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);


DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);


DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- =====================================================
-- 2. DATA IMPORT
-- =====================================================
-- Load the raw CSV datasets into their respective tables.
-- Books and Customers are loaded first because Orders
-- contains foreign keys referencing both tables.



-- Import Data into Books Table

COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Users\HP\Desktop\SQL Practise\30 Day - SQL Practice Files\Books.csv' 
CSV HEADER;


-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country) 
FROM 'C:\Users\HP\Desktop\SQL Practise\30 Day - SQL Practice Files\Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:\Users\HP\Desktop\SQL Practise\30 Day - SQL Practice Files\Orders.csv' 
CSV HEADER;


-- =====================================================
-- 3. DATA VALIDATION & QUALITY CHECKS
-- =====================================================

-- 3.1 Check total number of records in each table

SELECT COUNT(*) AS total_books
FROM Books;

SELECT COUNT(*) AS total_customers
FROM Customers;

SELECT COUNT(*) AS total_orders
FROM Orders;


-- 3.2 Preview the imported data

SELECT *
FROM Books
LIMIT 5;

SELECT *
FROM Customers
LIMIT 5;

SELECT *
FROM Orders
LIMIT 5;


-- 3.3 Check for NULL values in Books

SELECT
    COUNT(*) FILTER (WHERE Book_ID IS NULL) AS missing_book_id,
    COUNT(*) FILTER (WHERE Title IS NULL) AS missing_title,
    COUNT(*) FILTER (WHERE Author IS NULL) AS missing_author,
    COUNT(*) FILTER (WHERE Genre IS NULL) AS missing_genre,
    COUNT(*) FILTER (WHERE Published_Year IS NULL) AS missing_published_year,
    COUNT(*) FILTER (WHERE Price IS NULL) AS missing_price,
    COUNT(*) FILTER (WHERE Stock IS NULL) AS missing_stock
FROM Books;


-- 3.4 Check for NULL values in Customers

SELECT
    COUNT(*) FILTER (WHERE Customer_ID IS NULL) AS missing_customer_id,
    COUNT(*) FILTER (WHERE Name IS NULL) AS missing_name,
    COUNT(*) FILTER (WHERE Email IS NULL) AS missing_email,
    COUNT(*) FILTER (WHERE Phone IS NULL) AS missing_phone,
    COUNT(*) FILTER (WHERE City IS NULL) AS missing_city,
    COUNT(*) FILTER (WHERE Country IS NULL) AS missing_country
FROM Customers;


-- 3.5 Check for NULL values in Orders

SELECT
    COUNT(*) FILTER (WHERE Order_ID IS NULL) AS missing_order_id,
    COUNT(*) FILTER (WHERE Customer_ID IS NULL) AS missing_customer_id,
    COUNT(*) FILTER (WHERE Book_ID IS NULL) AS missing_book_id,
    COUNT(*) FILTER (WHERE Order_Date IS NULL) AS missing_order_date,
    COUNT(*) FILTER (WHERE Quantity IS NULL) AS missing_quantity,
    COUNT(*) FILTER (WHERE Total_Amount IS NULL) AS missing_total_amount
FROM Orders;


-- 3.6 Check for duplicate primary keys

SELECT Book_ID, COUNT(*) AS duplicate_count
FROM Books
GROUP BY Book_ID
HAVING COUNT(*) > 1;

SELECT Customer_ID, COUNT(*) AS duplicate_count
FROM Customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

SELECT Order_ID, COUNT(*) AS duplicate_count
FROM Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;


-- 3.7 Check for invalid prices

SELECT *
FROM Books
WHERE Price <= 0;


-- 3.8 Check for invalid stock values

SELECT *
FROM Books
WHERE Stock < 0;


-- 3.9 Check for invalid order quantities

SELECT *
FROM Orders
WHERE Quantity <= 0;


-- 3.10 Check for invalid order amounts

SELECT *
FROM Orders
WHERE Total_Amount < 0;

-- =====================================================
-- 4. BASIC SQL ANALYSIS
-- =====================================================


-- 1) Retrieve all books in the "Fiction" genre:

SELECT * FROM Books 
WHERE Genre='Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books 
WHERE Published_year>1950;

-- 3) List all customers from the Canada:
SELECT * FROM Customers 
WHERE country='Canada';


-- 4) Show orders placed in November 2023:

SELECT * FROM Orders 
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:

SELECT SUM(stock) AS Total_Stock
From Books;


-- 6) Find the details of the most expensive book:
SELECT * FROM Books 
ORDER BY Price DESC 
LIMIT 1;


-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders 
WHERE quantity>1;



-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders 
WHERE total_amount>20;



-- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;


-- 10) Find the book with the lowest stock:
SELECT * FROM Books 
ORDER BY stock 
LIMIT 1;


-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) As Revenue 
FROM Orders;


-- =====================================================
-- 5. INTERMEDIATE and ADVANCED SQL ANALYSIS
-- =====================================================



-- 1) Retrieve the total number of books sold for each genre:

SELECT * FROM ORDERS;

SELECT b.Genre, SUM(o.Quantity) AS Total_Books_sold
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.Genre;


-- 2) What is the average price of books in each genre?
SELECT
    Genre,
    ROUND(AVG(Price), 2) AS Average_Price
FROM Books
GROUP BY Genre
ORDER BY Average_Price DESC;


-- 3) List customers who have placed at least 2 orders:
SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >=2;




-- 4) Find the most frequently ordered book:
SELECT o.Book_id, b.title, COUNT(o.order_id) AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id, b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;



-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT
    Book_ID,
    Title,
    Author,
    Price
FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;


-- 6) Retrieve the total quantity of books sold by each author:

SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.Author;


-- 7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;


-- 8) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;


--9) Which genres generate the most revenue?
SELECT
    b.Genre,
    SUM(o.Total_Amount) AS Total_Revenue
FROM Orders o
JOIN Books b
    ON o.Book_ID = b.Book_ID
GROUP BY b.Genre
ORDER BY Total_Revenue DESC;


--10)Revenue by Country
select c.country, sum(o.total_amount) as total_revenue
from orders o join customers c
on  o.Customer_ID = c.Customer_ID
group by c.country
order by total_revenue desc;


--11) Revenue by Month
select date_trunc('month', order_date) as month, 
sum(total_amount) as monthly_revenue
from orders
group by month
order by month;

--12) Categorize Books by Price
select title, price,
case
	when price < 10 then 'Budget'
	when price between 10 and 20 then 'Mid-Range'
	else 'Premium'
end as Price_category
from books
order by price;

--13) Categorize Inventory
select title, genre, stock,
case
when stock = 0 then 'out-of-stock'
when stock < 10 then 'Low Stock'
when stock < 30 then 'Medium Stock'
else 'High Stock'
end as Stock_status
from books 
order by stock asc;

--9) Calculate the stock remaining after fulfilling all orders:

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

select b.Book_id, b.title, b.stock, coalesce(sum(o.quantity),0) as order_quantity, 
b.stock - coalesce(sum(o.quantity),0) as remaining_quantity
from books b 
left join orders o 
on b.book_id = o.book_id
group by b.book_id
order by b.book_id asc;


-- =====================================================
-- 6. BUSINESS INSIGHTS
-- =====================================================


-- 6.1 Overall Business Performance

SELECT
    (SELECT COUNT(*) FROM Books) AS Total_Books,
    (SELECT COUNT(*) FROM Customers) AS Total_Customers,
    (SELECT COUNT(*) FROM Orders) AS Total_Orders,
    (SELECT SUM(Quantity) FROM Orders) AS Total_Books_Sold,
    (SELECT SUM(Total_Amount) FROM Orders) AS Total_Revenue;


-- 6.2 Best-Performing Genre

select b.genre,
	sum(o.quantity) as books_sold,
	sum(o.total_amount) as Revenue
from books b 
join orders o on b.book_id = o.book_id
group by b.genre
order by revenue desc;


-- 6.3) Best-Selling Books

SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    SUM(o.Quantity) AS Books_Sold,
    SUM(o.Total_Amount) AS Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Author
ORDER BY Books_Sold DESC
LIMIT 10;

-- 6.4) Highest-Revenue Books 
SELECT
    b.Book_ID,
    b.Title,
    b.Author,
    SUM(o.Quantity) AS Books_Sold,
    SUM(o.Total_Amount) AS Revenue
FROM Books b
JOIN Orders o
    ON b.Book_ID = o.Book_ID
GROUP BY
    b.Book_ID,
    b.Title,
    b.Author
ORDER BY Revenue DESC
LIMIT 10;


-- 6.5) Highest-Spending Customers
SELECT
    c.Customer_ID,
    c.Name,
    c.City,
    c.Country,
    COUNT(o.Order_ID) AS Total_Orders,
    SUM(o.Total_Amount) AS Total_Spent
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Name,
    c.City,
    c.Country
ORDER BY Total_Spent DESC
LIMIT 10;


-- 6.5) what percentage of customers who placed at least one order placed more than one order.
SELECT
    ROUND(
        COUNT(*) FILTER (WHERE Order_Count > 1) * 100.0
        / COUNT(*),
        2
    ) AS Repeat_Customer_Percentage
FROM (
    SELECT
        Customer_ID,
        COUNT(Order_ID) AS Order_Count
    FROM Orders
    GROUP BY Customer_ID
) AS Customer_Order_Count;




-- 6.6) Revenue by Country
SELECT
    c.Country,
    COUNT(DISTINCT c.Customer_ID) AS Customers,
    SUM(o.Total_Amount) AS Revenue
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Country
ORDER BY Revenue DESC;


-- 6.7) Average Order Value
SELECT
    ROUND(AVG(Total_Amount), 2) AS Average_Order_Value
FROM Orders;

-- 6.8) Average Books per Order
SELECT
	AVG(Quantity) AS Average_Books_Per_Order
FROM Orders;

-- 6.9)
SELECT
    (SELECT COUNT(*) FROM Books) AS Total_Books,
    (SELECT COUNT(*) FROM Customers) AS Total_Customers,
    (SELECT COUNT(*) FROM Orders) AS Total_Orders,
    (SELECT SUM(Quantity) FROM Orders) AS Total_Books_Sold,
    (SELECT ROUND(SUM(Total_Amount), 2) FROM Orders) AS Total_Revenue,
    (SELECT ROUND(AVG(Total_Amount), 2) FROM Orders) AS Average_Order_Value,
    (SELECT ROUND(AVG(Quantity), 2) FROM Orders) AS Average_Books_Per_Order;
