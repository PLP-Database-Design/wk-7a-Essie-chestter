-- Question 1: Achieving 1NF (First Normal Form)

-- Create the initial ProductDetail table 
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(255),
    Products VARCHAR(255)
);

INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Query to transform the table into 1NF
WITH SplitProducts AS (
    SELECT
        OrderID,
        CustomerName,
        TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
    FROM
        ProductDetail
    CROSS JOIN
        (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3) AS numbers -- Adjust number of unions based on the maximum number of products
    WHERE
        SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1) <> ''
)
SELECT OrderID, CustomerName, Product
FROM SplitProducts;

-- Question 2: Achieving 2NF (Second Normal Form)

-- Create the initial OrderDetails table 
CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(255),
    Product VARCHAR(255),
    Quantity INT
);

INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Create the Customers table to remove partial dependency
CREATE TABLE Customers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Insert distinct OrderID, CustomerName pairs into Customers
INSERT INTO Customers (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create the OrderProduct table to store OrderID, Product, and Quantity
CREATE TABLE OrderProduct (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Customers(OrderID)
);

-- Insert data into OrderProduct
INSERT INTO OrderProduct (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Show the results of the 2NF transformation.
SELECT * FROM Customers;
SELECT * FROM OrderProduct;
