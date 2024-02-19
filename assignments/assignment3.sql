-- 1. List all cities that have both Employees and Customers.
SELECT City
FROM Employees
WHERE City IN (
    SELECT City 
    FROM Customers  
) 

-- 2. List all cities that have Customers but no Employee.
-- a. Use sub-query
SELECT City
FROM Customers
WHERE City NOT IN (
    SELECT City 
    FROM Employees  
) 

-- b. Do not use sub-query
SELECT c.City
FROM Customers c LEFT JOIN Employees e ON c.City = e.City
WHERE e.City is null

-- 3. List all products and their total order quantities throughout all orders.
SELECT p.ProductName, SUM(od.Quantity) as [Total Order Quantities]
FROM Products p JOIN [Order Details] od ON p.productID = od.ProductID 
GROUP BY p.ProductName

-- 4. List all Customer Cities and total products ordered by that city.
SELECT c.City, SUM(Quantity) as [Total Number of Products]
FROM [Order Details] od JOIN Orders o ON o.OrderID = od.OrderID JOIN Customers c ON c.CustomerID = o.CustomerID 
GROUP BY c.City

-- 5. List all Customer Cities that have at least two customers.
-- a. Use union
SELECT City  
FROM Customers 
GROUP BY City 
HAVING COUNT(CustomerID) >= 2
UNION 
SELECT ShipCity AS City 
FROM Orders 
GROUP BY ShipCity 
HAVING COUNT(DISTINCT CustomerID) >= 2

-- b. Use sub-query and no union
SELECT DISTINCT City 
FROM Customers 
WHERE City IN (
    SELECT City 
    FROM Customers 
    GROUP BY City 
    HAVING COUNT(CustomerID) >= 2
)
-- 6. List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City, COUNT(DISTINCT p.ProductID) AS [Number of Different Products]
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON od.OrderID = o.OrderID JOIN Products p ON od.ProductID = p.ProductID 
GROUP BY c.City
HAVING COUNT(DISTINCT p.ProductID) >= 2

-- 7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT DISTINCT c.CustomerID, c.ContactName, c.City, o.ShipCity 
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID 
WHERE c.City != o.ShipCity

-- 8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
SELECT TOP 5 od.ProductID, SUM(Quantity) as [Total Number of Products], AVG(Quantity * UnitPrice) as [Average Price],  (
    SELECT TOP 1 c.City
    FROM Customers c JOIN Orders o2 ON o2.CustomerID = c.CustomerID JOIN [Order Details] od2 ON od2.OrderID = o2.OrderID
    WHERE od.ProductID = od2.ProductID
    GROUP BY c.City 
    ORDER BY SUM(od2.Quantity) DESC) AS [Top Customer City]
FROM [Order Details] od JOIN Orders o ON od.OrderID = o.OrderID JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY od.ProductID
ORDER BY SUM(Quantity) DESC


-- 9.  List all cities that have never ordered something but we have employees there.
-- a. Use sub-query
SELECT City 
FROM Employees 
WHERE City NOT IN (SELECT ShipCity FROM Orders)
ORDER BY City

-- b. Do not use sub-query
SELECT e.City 
FROM Employees e LEFT JOIN Orders o ON o.ShipCity = e.City 
WHERE o.ShipCity is NULL
ORDER BY e.City

-- 10. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
SELECT TOP 1 e.City AS [City]
    FROM Employees e JOIN Orders o ON e.EmployeeID = o.EmployeeID
    WHERE e.City = (
        SELECT TOP 1 City 
        FROM Customers c JOIN Orders o ON o.CustomerID = c.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID 
        GROUP BY c.City  
        ORDER BY SUM(od.Quantity) DESC)
    GROUP BY e.City
    ORDER BY COUNT(o.OrderID) DESC   

-- Short Answer:
-- 11. How do you remove the duplicates record of a table?
-- Answer: To remove the duplicates record from a table, we can use the Window function ROW_NUMBER() to help us identify 
-- the duplicate rows. ROW_NUMBER() will return a sequential number of a row within the partition. Therefore, I will include 
-- all the columns that define duplicate in the Partition By clause. I will use the CTE to store the result set of ROW_NUMBER query and use 
-- the `DELETE FROM` to delete and filter all Row_number that is greater than 1 (greater than 1 means duplicate rows). 

