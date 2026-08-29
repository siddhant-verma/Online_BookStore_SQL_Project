-- =====================================================
-- ONLINE BOOKSTORE SQL PROJECT
-- Database Setup
-- PostgreSQL
-- =====================================================


-- Create Database
CREATE DATABASE OnlineBookstore;


-- =====================================================
-- BOOKS TABLE
-- =====================================================

DROP TABLE IF EXISTS Books;

CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);


-- =====================================================
-- CUSTOMERS TABLE
-- =====================================================

DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);


-- =====================================================
-- ORDERS TABLE
-- =====================================================

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);
