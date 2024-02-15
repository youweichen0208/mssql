use NORTHWND
GO

-- SELECT statement: identify which columns we want to retrieve
-- 1. SELECT all columns and rows
select * from Employees

-- 2. SELECT a list of columns
select EmployeeID, FirstName, LastName, BirthDate from Employees

select e.Country, e.FirstName, e.LastName, e.HomePhone from Employees as e


-- avoid using SELECT *
-- 1) unnecessary data
-- 2) name conflicts


-- 3. SELECT DISTINCT Value:
-- list all the cities that employees located at
SELECT DISTINCT city from Employees

-- 4. SELECT combined with plain text: retrieve the full name of employees
SELECT FirstName + ' ' + LastName AS FullName from Employees

-- identifiers: names we give to db, tables, columns, sp.
-- 1) regular identifier: comply with the rules for the format of identifiers
    --1. first character: a-z, A-Z, @, #
        --@: declare a variable
        DECLARE @today DATETIME
        SELECT @today = GETDATE()
        PRINT @today

        --#: temp tables
            --#: local temp table
            --##: global temp table

    --2. subsequent characters: a-z, A-Z, 0-9, @, $, #, _
    --3. identifier should not be a sql reserved word both uppercase or lower case
    --4. embedded space are not allowed (use delimited space instead for space)
    SELECT FirstName + ' ' + LastName AS "Full Name" from Employees

    SELECT FirstName + ' ' + LastName AS [Full Name] from Employees

-- WHERE statement: filter records
-- 1. equal = 
-- Customers who are from Germany
SELECT CustomerID, ContactName, Country from Customers where country = 'Germany'

-- Product which price is $18
SELECT ProductID, ProductName, UnitPrice from Products where UnitPrice = 18

--2. Customers who are not from UK
SELECT CustomerID, ContactName, Country from Customers where Country != 'UK'

SELECT CustomerID, ContactName, Country from Customers where Country <> 'UK'

--IN Operator: retrieve among a list of values
--E.g: Orders that ship to USA and Canada
SELECT OrderID, CustomerID, ShipCountry FROM Orders WHERE ShipCountry in ('USA', 'Canada')

-- BETWEEN Operator: retrieve in a consecutive order, inclusive
-- 1. retrieve products whose price is between 20 and 30.
SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice >= 20 AND UnitPrice <=30

SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice BETWEEN 20 AND 30


-- NOT Operator: display a record if the condition is not true
-- list orders that does not ship to USA or Canada
SELECT OrderID, CustomerID, ShipCountry FROM Orders WHERE ShipCountry NOT in ('USA', 'Canada')

SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice NOT BETWEEN 20 AND 30

-- NULL Value: a field with no value
-- check which employees' region information is empty
SELECT EmployeeID, FirstName, LastName, Region FROM Employees where Region is null


-- Null in numerical operation

CREATE TABLE TestSalary (EId int primary key identity(1,1), Salary money, Comm money)
INSERT INTO TestSalary VALUES(2000, 500), (2000, NULL), (1500, 500), (2000, 0), (NULL, 500), (NULL, NULL)
SELECT * FROM TestSalary

SELECT EId, IsNull(Salary, 0) as Salary, IsNull(Comm, 0) as Comm, IsNull(Comm, 0) + IsNull(Salary, 0) as [Total Compensation] from TestSalary

--LIKE Operator: create a search expression
-- 1. work with % wildcard character: % is used to subsitute to 0 or more characters

-- retrieve all the employees whose last name starts with D
SELECT FirstName, LastName from Employees where LastName LIKE 'D%'

-- 2. work with [] and % tp search in ranges:
-- find customers whose postal code starts with number between 0 and 3
SELECT ContactName, PostalCode from Customers where PostalCode like '[0-3]%'

-- 3. Work with NOT:
SELECT ContactName, PostalCode from Customers where PostalCode NOT like '[0-3]%'

-- 4. Work with ^: any characters not in the brackets
SELECT ContactName, PostalCode from Customers where PostalCode like '[^0-3]%'

-- Customer name starting from letter A but not followed by l-n
SELECT ContactName, PostalCode from Customers where ContactName like 'A[^l-n]%'

-- ORDER BY statement: sort the result set in ascending or descending order
-- 1. retrieve all customers except those in Boston and sort by name
SELECT ContactName, City from Customers WHERE City != 'Boston' ORDER BY ContactName DESC

-- 2. retrieve product name and unit price, and sort by unit price in descending order
SELECT ProductName, UnitPrice FROM Products ORDER BY UnitPrice DESC

-- 3. Order by multiple columns
SELECT ProductName, UnitPrice FROM Products ORDER BY UnitPrice DESC, ProductName DESC

-- JOIN is used to combine rows from two or more tables based on the related column between them.
--1. INNER JOIN: return the records that have matching values only.
-- find employees who have deal with any orders
SELECT e.EmployeeID, e.FirstName, e.LastName, o.OrderDate from Employees e join Orders o on e.EmployeeID = o.EmployeeID

-- get customers information and corresponding order date
SELECT c.ContactName, c.City, c.country, o.OrderDate FROM Customers c INNER JOIN Orders o on c.CustomerID = o.CustomerID

-- add detailed information about quantity, price, join Order Details
SELECT c.ContactName, e.FirstName+ ' ' + e.LastName AS EmployeeName, o.OrderDate, od.Quantity, od.UnitPrice
FROM Customers c INNER JOIN Orders o ON C.CustomerID = O.CustomerID INNER JOIN Employees e ON O.EmployeeID = e.EmployeeID 
INNER JOIN [Order Details] AS od ON od.OrderID = o.OrderID

-- 2. OUTER JOIN
-- 1) LEFT OUTER JOIN: return all records from the left table, and matching records from the right table, if no matching records, return null
--list all customers whether they have made any purchase or not
SELECT c.ContactName, o.OrderID FROM Customers c left join Orders o on C.CustomerID = O.CustomerID ORDER BY O.OrderID DESC


-- JOIN with WHERE: find out customers who have never placed any order
SELECT c.ContactName, o.OrderID
FROM Customers c LEFT JOIN Orders o ON C.CustomerID = o.CustomerID
WHERE o.OrderId is NULL
ORDER BY o.OrderID DESC

-- 2) RIGHT OUTER JOIN: return all records from the right table, and matching records from the left table, if no matching records, return null
-- list all customers whether they have made any purchase or not
SELECT c.ContactName, o.OrderID
FROM Orders o RIGHT JOIN Customers c ON o.CustomerId = c.CustomerID
ORDER BY o.OrderID DESC

-- 3) FULL OUTER JOIN: return all rows from both left and right table with null values, if we cannot find matching records
-- match all customers and suppliers by country
SELECT c.ContactName As Customer, c.Country As CustomerCountry, s.ContactName As Supplier, s.Country AS SupplierCountry
FROM Customers c FULL JOIN Suppliers s ON c.Country = s.Country

--3. CROSS JOIN: create the cartesian product of two tables
--table1: 10 rows; table2: 20 rows -> cross join -> 200 rows 

SELECT *
FROM Customers

SELECT *
FROM Orders

SELECT *
FROM Customers CROSS JOIN Orders


--* SELF JOIN：join a table with itself

SELECT EmployeeID, FirstName, LastName, ReportsTo
FROM Employees

--find emloyees with the their manager name

--CEO: Andrew
--Manager: Nancy, Janet, Margaret, Steven, Laura
--Employee: Michael, Robert, Anne

SELECT e.FirstName+ ' '+e.LastName AS Employee, m.FirstName + ' '+m.LastName AS Manager
FROM Employees e LEFT JOIN Employees m ON e.ReportsTo=m.EmployeeID


--Batch Directives

CREATE DATABASE FebBatch
GO
USE FebBatch
GO
CREATE TABLE Customer(Id int, EName varchar(20), Salary money)


