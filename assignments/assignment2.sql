-- 1. How many products can you find in the Production.Product table?
SELECT COUNT(ProductID) AS NumOfProducts 
FROM Production.Product

-- 2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(ProductID) As ProductsInSubcategory
FROM Production.Product 
WHERE ProductSubcategoryID is NOT null 

-- 3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT ProductSubcategoryID, COUNT(ProductID) As CountedProducts
FROM Production.Product 
WHERE ProductSubcategoryID is NOT null 
GROUP BY ProductSubcategoryID

-- 4. How many products that do not have a product subcategory.
SELECT COUNT(ProductID) As ProductsNotInSubcategory
FROM Production.Product 
WHERE ProductSubcategoryID is null 

-- 5. Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT ProductID, COUNT(Quantity) as [TheSum]
FROM Production.ProductInventory
GROUP BY ProductID

-- 6. Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
SELECT ProductID, COUNT(Quantity) as TheSum
FROM Production.ProductInventory
WHERE LocationID = 40 
GROUP BY ProductID 
HAVING COUNT(Quantity) < 100

-- 7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT Shelf, ProductID, COUNT(Quantity) as TheSum
FROM Production.ProductInventory
WHERE LocationID = 40 
GROUP BY Shelf, ProductID
HAVING COUNT(Quantity) < 100

-- 8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT ProductID, AVG(Quantity) AS [Average Quantity for Products]
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID

-- 9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS TheAVG
FROM Production.ProductInventory
GROUP BY ProductID, Shelf

-- 10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS TheAVG
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY ProductID, Shelf

-- 11. List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null. 
SELECT Color, Class, COUNT(ListPrice) AS TheCount, AVG(ListPrice) AS AvgPrice
FROM Production.product
WHERE Color IS NOT null and Class IS NOT null
GROUP BY Color, Class


-- 12. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following.
SELECT cr.Name AS Country, sp.Name AS Province 
FROM Person.CountryRegion cr 
JOIN Person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode 

-- 13. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT cr.Name AS Country, sp.Name AS Province 
FROM Person.CountryRegion cr 
JOIN Person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode 
WHERE cr.Name IN ('Germany', 'Canada')

-- 14. List all Products that has been sold at least once in last 26 years.
SELECT OrderID, OrderDate 
FROM Orders
WHERE DATEDIFF(YEAR, OrderDate, GETDATE()) <= 26 

-- 15. List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 ShipPostalCode, COUNT(OrderID) AS NumOfProductsSold
FROM Orders
WHERE ShipPostalCode IS NOT NULL
GROUP BY  ShipPostalCode
ORDER BY  COUNT(OrderID) DESC

-- 16. List top 5 locations (Zip Code) where the products sold most in last 26 years.
SELECT TOP 5 ShipPostalCode, COUNT(OrderID) AS NumOfProductsSold
FROM Orders
WHERE ShipPostalCode IS NOT NULL AND DATEDIFF(YEAR, OrderDate, GETDATE()) <= 26 
GROUP BY  ShipPostalCode
ORDER BY  COUNT(OrderID) DESC

-- 17. List all city names and number of customers in that city.  
SELECT City, COUNT(DISTINCT ContactName) AS [Number of Customers]
FROM Customers
GROUP BY City 


-- 18. List city names which have more than 2 customers, and number of customers in that city
SELECT City, COUNT(DISTINCT ContactName) AS [Number of Customers]
FROM Customers
GROUP BY City 
HAVING COUNT(DISTINCT ContactName) > 2


-- 19. List the names of customers who placed orders after 1/1/98 with order date.
SELECT c.ContactName, o.OrderDate
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate > '1998-01-01'

-- 20. List the names of all customers with most recent order dates
SELECT c.ContactName, sub.OrderDate, sub.RNK
FROM Customers c JOIN (SELECT CustomerID, OrderDate, DENSE_RANK() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) RNK FROM Orders) AS sub ON sub.CustomerID = c.CustomerID
WHERE sub.RNK = 1

-- 21. Display the names of all customers  along with the count of products they bought
SELECT c.ContactName, SUM(od.Quantity) as [Count of Products Bought]
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID 
GROUP BY c.ContactName


-- 22. Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CustomerID, SUM(od.Quantity) as [Count of Products Bought]
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID 
GROUP BY c.CustomerID
HAVING SUM(od.Quantity) > 100

-- 23. List all of the possible ways that suppliers can ship their products. Display the results as below
SELECT supp.CompanyName AS [Supplier Company Name], ship.CompanyName as [Shipping Company Name] 
FROM Suppliers supp CROSS JOIN Shippers ship 

-- 24. Display the products order each day. Show Order date and Product Name.
SELECT p.ProductName, o.OrderDate 
FROM Products p JOIN [Order Details] od ON p.productID = od.productID JOIN Orders o ON od.OrderID = o.OrderID 
ORDER BY o.OrderDate

-- 25. Displays pairs of employees who have the same job title.
SELECT e1.LastName + ' ' + e1.FirstName AS [Names of Employee 1], e2.LastName + ' '+ e2.FirstName AS [Names of Employee 2], e1.Title 
FROM Employees e1 JOIN Employees e2 ON e1.Title = e2.Title 
WHERE e1.EmployeeID < e2.EmployeeID

-- 26. Display all the Managers who have more than 2 employees reporting to them.
SELECT e1.EmployeeID, e1.LastName, e1.FirstName
FROM Employees e1 JOIN Employees e2 ON e1.EmployeeID = e2.ReportsTo 
GROUP BY e1.EmployeeID, e1.LastName, e1.FirstName
HAVING COUNT(e2.ReportsTo) > 2

-- 27. Display the customers and suppliers by city. The results should have the following columns
SELECT City, ContactName, 'Customer' AS Type 
FROM Customers 
UNION 
SELECT City, ContactName, 'Supplier' AS Type
FROM Suppliers 
