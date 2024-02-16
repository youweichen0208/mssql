--Select: retrieve
--where: filter
--orderby : sort
--Join: work on multible tables in one query


--Aggregation functions: perform a calculation on a set of values a return a single aggregated result
--1. COUNT(): return the number of rows

-- find the number of orders as TotalNumOfRows in the Orders Table:
SELECT COUNT(OrderID) AS TotalNumOfRows 
FROM Orders


-- COUNT(*) vs. COUNT(colName):
-- write the difference
-- COUNT(*) will include null values, but COUNT(colName) will not

-- count the number of Region and count the number of rows in the Employees table
SELECT COUNT(Region), Count(*)
FROM Employees


-- GROUP BY: group rows that have the same values into summary rows
-- In a `GROUP BY` clause, the columns mentioned must be the same as those included in the `SELECT` statement unless they are part of an aggregate function.
-- find CustomerId, ContactName, City, Country, the number of orders placed by each customer from the Orders and Customers table. Order by Number of orders DESC.
SELECT c.CustomerID, c.ContactName, C.City, count(OrderID) as NumOfOrders
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID 
GROUP BY c.CustomerID, c.ContactName, c.city
ORDER BY NumOfOrders DESC


--WHERE vs. HAVING

--1. both are used as filters, HAVING will apply only to groups as whole but WHERE is applied to an individual row
--2. WHERE goes before the aggregation but HAVING goes after the aggregation

--SELECT fields, aggregate(fields)
--FROM table JOIN table2 ON ...
--WHERE criteria -- optional
--GROUP BY  fields -- use when we have both aggregated and non-aggregated fields 
--HAVING criteria --optional
--ORDER BY fields DESC -- optional 

   
--FROM/JOIN ---> WHERE--->GROUP BY --->HAVING ---> SELECT  ---> DISTINCT ---> ORDER BY
--                 |_______________________|
---               cannot use alias from select 


-- find the CustomerID, contactname, City, country, and the number of orders as NumOfOrders from each customer using the table Customers and Orders in the country of USA and Canada and only return the orders greater or equal to 10. Order by the number of Orders DESC.
SELECT c.CustomerID, c.ContactName, C.City, count(o.OrderID) as NumOfOrders
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.ContactName, c.city
HAVING count(o.OrderID) >= 10
ORDER BY NumOfOrders DESC

--3. Where can be used with SELECT, UPDATE Or DELETE but HAVING can only be used in SELECT 

-- update the Products table the UnitPrice to 30 when the ProductID = 1
UPDATE Products
SET UnitPrice = 30
WHERE ProductID = 1

SELECT UnitPrice FROM Products WHERE ProductID = 1

--DISTINCT: only get the unique values
--COUNT DISTINCT: only count unique values

-- retrieves a list of distinct (unique) cities from the "Customers" table. It eliminates duplicate city entries and only returns each unique city name once.


-- 2. AVG(): return the average value of a numeric column

-- find the CustomerID, ContactName, and average revenue spent from each customer in the Customer and Order Details table.
SELECT c.CustomerID, c.ContactName, AVG(od.Quantity * od.UnitPrice)
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od on od.OrderID = o.OrderID
GROUP BY c.CustomerID, c.ContactName

-- 3. SUM():
-- List sum of revenue for each customer
SELECT c.CustomerId, c.ContactName, SUM(od.UnitPrice * od.Quantity) As SumRevenue
FROM Customers c JOIN Orders o ON c.CustomerId = o.CustomerId JOIN [Order Details] od ON od.OrderID = o.OrderId
GROUP BY  c.CustomerId, c.ContactName

-- 4. MAX()
-- list maximum revenue from each customer
SELECT c.CustomerId, c.ContactName, MAX(od.UnitPrice * od.Quantity) As SumRevenue
FROM Customers c JOIN Orders o ON c.CustomerId = o.CustomerId JOIN [Order Details] od ON od.OrderID = o.OrderId
GROUP BY  c.CustomerId, c.ContactName

-- 5.MIN()
-- list the cheapeast product bought by each customer
SELECT c.CustomerId, c.ContactName, MIN(od.UnitPrice) As CheapestProduct
FROM Customers c JOIN Orders o ON c.CustomerId = o.CustomerId JOIN [Order Details] od ON od.OrderID = o.OrderId
GROUP BY  c.CustomerId, c.ContactName

-- TOP predicate: SELECT a specific number or a certain percentage of records
SELECT ProductName, UnitPrice 
FROM Products

-- retrieve top 5 most expensive products
SELECT TOP 5 ProductName, UnitPrice 
FROM Products

-- retrieve top 10 percent most expensive products

SELECT TOP 10 PERCENT ProductName, UnitPrice 
FROM Products 
ORDER BY UnitPrice DESC 

-- LIMIT: we do not have LIMIT in sql server, use TOP instead


-- Subquery: a SELECT statement that is embedded in another SQL statement

-- find ContactName, City from the Customers from the same city where Alejandra Camino lives
SELECT ContactName, City 
FROM Customers 
WHERE City in (
    SELECT City 
    FROM Customers 
    WHERE ContactName = 'Alejandra Camino'
)

SELECT c1.ContactName, c1.City 
From Customers c1  JOIN Customers c2 on c1.CustomerID = c2.CustomerID 
WHERE c2.ContactName = 'Alejandra Camino'


-- find the CustomerID, contactname, City, country of each user from the Customers table who MAKE ANY ORDER FROM THE Orders table 

-- USING JOIN
SELECT c.CustomerID, c.ContactName, c.City, c.Country 
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID 


-- USING SUBQUERY
SELECT CustomerID, ContactName, City, Country 
FROM Customers 
WHERE CustomerID IN (
    SELECT DISTINCT CustomerID 
    FROM Orders
)

-- Subquery vs. join 
-- 1) JOIN can only be used in FROM clause, but subquery can be used in SELECT, FROM, WHERE, HAVING, ORDER BY


-- Correlated Subquery: inner query is dependent on the outer query


-- find the Customer name and total number of orders of each customer in the order table
-- join:
SELECT c.ContactName, COUNT(o.OrderID) as NumOfOrders
FROM Customers c 
JOIN Orders o ON c.CustomerID = o.CustomerID 
GROUP BY c.ContactName
ORDER BY NumOfOrders DESC

-- ** subquery:
SELECT ContactName, (SELECT COUNT(OrderID) from Orders o where o.CustomerID = c.CustomerID) as NumOfOrders
FROM Customers c  
ORDER BY NumOfOrders DESC


-- derived table: subquery in from clause

-- get Customers' ContactName, City, Country, and Total number of Orders made by each customer

-- JOIN
SELECT c.CustomerID, c.ContactName, C.City, COUNT(OrderID) as NumOfOrders
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID 
GROUP BY c.CustomerID, c.ContactName, c.city
ORDER BY NumOfOrders DESC

-- ** Derived Table
SELECT c.CustomerID, c.ContactName, c.City, sub.NumOfOrders
FROM Customers c LEFT JOIN (SELECT CustomerID, Count(OrderID) AS NumOfOrders FROM Orders GROUP BY CustomerID) sub ON c.CustomerID = sub.CustomerID 
ORDER BY NumOfOrders DESC


-- Union vs. Union ALL:
-- Common features:
    -- number of cols must be the same
    -- data types of each column must be identical

-- Differences:
    -- 1. Union will remove duplicates but Union all will not
    -- 2. Union will sort the first column ascendingly
    -- 3. Union can not be used in recursive cte, but Union all can be used.
SELECT City, Country 
FROM Customers 
UNION
SELECT City, Country 
FROM Employees 

SELECT City, Country 
FROM Customers 
UNION ALL
SELECT City, Country 
FROM Employees 


-- Window Function: operate on a set of rows and return a single aggregated value for each row by adding extra columns

-- RANK(): give a rank based on certain order
-- rank for product price, when there is a tie, there will be a value gap

-- find the ProductID, ProductName, UnitPrice, rank based on the UnitPrice from the Products table
SELECT ProductID, ProductName, UnitPrice, RANK() OVER (ORDER BY UnitPrice) RNK 
FROM Products

-- find 2nd highest price with the ProductID, ProductName, UnitPrice, rank based on the UnitPrice from the Products table
SELECT dt.ProductID, dt.ProductName, dt.UnitPrice, dt.RNK
FROM (
    SELECT ProductID, ProductName, UnitPrice, RANK() OVER (ORDER BY UnitPrice DESC) RNK 
    FROM Products
) dt 
WHERE dt.RNK = 2

-- DENSE_RANK():
SELECT ProductID, ProductName, UnitPrice, DENSE_RANK() OVER (ORDER BY UnitPrice DESC) as DenseRNK, RANK() OVER (ORDER BY UnitPrice DESC) RNK 
FROM Products

-- ROW_NUMBER(): return the row number of the sorted records starting from 1
SELECT ProductID, ProductName, UnitPrice, DENSE_RANK() OVER (ORDER BY UnitPrice DESC) as DenseRNK, RANK() OVER (ORDER BY UnitPrice DESC) RNK,  ROW_NUMBER() OVER(ORDER BY UnitPrice DESC) RowNum  
FROM Products

-- PARTITION BY: divide the result set into partitions and perform calculation on each subset
-- list customers from every country with the ranking for number of orders
SELECT c.ContactName, c.City, c.Country, COUNT(o.OrderId) as TotalNumOfOrders, RANK() OVER(PARTITION BY c.Country ORDER BY COUNT(o.OrderId) DESC) RNK  
FROM Customers c LEFT JOIN Orders o ON c.CustomerId = o.CustomerId 
GROUP BY c.ContactName, c.City, c.Country

-- ** Find Top 3 customers from every country with maximum orders
SELECT dt.ContactName, dt.City, dt.Country, dt.TotalNumOfOrders, dt.RNK FROM (SELECT c.ContactName, c.City, c.Country, COUNT(o.OrderId) as TotalNumOfOrders, RANK() OVER(PARTITION BY c.Country ORDER BY COUNT(o.OrderID) DESC) RNK  
FROM Customers c LEFT JOIN Orders o ON c.CustomerId = o.CustomerId GROUP BY c.ContactName, c.City, c.Country) dt 
WHERE dt.RNK <= 3


-- cte: common table expression -- temporary named result set
SELECT c.ContactName, c.City, c.Country, dt.TotalNumOfOrders
FROM Customers c LEFT JOIN (
    SELECT CustomerId, COUNT(OrderId) AS TotalNumOfOrders
    FROM Orders 
    GROUP BY CustomerId
) dt ON c.CustomerId = dt.CustomerId
ORDER BY  TotalNumOfOrders DESC


WITH OrderCntCTE
AS(
    SELECT CustomerId, COUNT(OrderId) AS TotalNumOfOrders
    FROM Orders 
    GROUP BY CustomerId
)
SELECT c.ContactName, c.City, c.Country, cte.TotalNumOfOrders
FROM Customers c LEFT JOIN OrderCntCTE cte ON  c.CustomerId = cte.CustomerId
ORDER BY  TotalNumOfOrders DESC

--lifecycle: created and used in the very next select statement 

--recursive CTE:  

--initialization: initial call to the cte which passes in some valies to get things started
--recursive rule:


SELECT EmployeeId, FirstName, ReportsTo
FROM Employees

-- level 1: Andrew
-- Level 2: Nancy, Janet, Margaret, Steven, Laura
-- level 3: Michael, Robert, Anne

WITH EmpHierarchyCTE
AS(
    SELECT EmployeeId, FirstName, ReportsTo, 1 lvl
    FROM Employees
    WHERE ReportsTo IS NULL
    UNION ALL
    SELECT e.EmployeeId, e.FirstName, e.ReportsTo, cte.lvl + 1
    FROM Employees e INNER JOIN EmpHierarchyCTE cte ON e.ReportsTo = cte.EmployeeId
)

SELECT * FROM EmpHierarchyCTE