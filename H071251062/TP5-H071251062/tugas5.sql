set search_path TO classicmodels;

-- SOAL 1
SELECT 
	c.contactFirstName,
	c.customerName,
	o.city,
	CONCAT(e.firstName, ' ', e.lastName) AS sales_rap_name
FROM customers c
JOIN employees e
ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN offices o
ON o.officeCode = e.officeCode
WHERE c.contactFirstName ILIKE 'A%' AND o.city != 'NYC'
ORDER BY customerName ASC

-- SOAL 2
SELECT
	c.customerName,
	SUM(p.amount) AS total_payment,
	MAX(p.amount) AS max_single_payment
FROM payments p
JOIN customers c
ON c.customerNumber = p.customerNumber
GROUP BY c.customerName
HAVING SUM(amount) > 50000
ORDER BY total_payment DESC

-- SOAL 3
SELECT 
	c.customerName,
	COUNT(DISTINCT o.orderNumber) AS total_order,
	ROUND(AVG(od.quantityOrdered), 2) AS avg_quantity_per_order
FROM customers c
JOIN orders o
ON o.customerNumber = c.customerNumber
JOIN orderdetails od
ON od.orderNumber = o.orderNumber
GROUP BY c.customerName
HAVING COUNT(DISTINCT o.orderNumber) > 3 AND ROUND(AVG(od.quantityOrdered), 2) > 35
ORDER BY avg_quantity_per_order DESC, total_order DESC

-- SOAL 4
SELECT 
	p.productline,
	SUM(od.quantityOrdered) AS total_terjual,
	ROUND(AVG(od.priceEach), 2) AS rata_rata_harga,
	ROUND(AVG((p.msrp - od.priceEach)/p.msrp * 100), 2) AS avg_discount_percentage
FROM products p
JOIN orderdetails od
ON od.productCode = p.productCode
GROUP BY p.productLine
HAVING ROUND(AVG(od.priceEach), 2) >80 AND SUM(od.quantityOrdered) > 3000
ORDER BY total_terjual DESC

-- SOAL 5
SELECT 
	c.customerName,
	SUM(od.quantityOrdered * od.priceEach) AS total_transaksi,
	COUNT(DISTINCT o.orderNumber) AS total_shipped_orders,
	ROUND(SUM(od.quantityOrdered * od.priceEach) / COUNT(DISTINCT o.orderNumber), 2) AS avg_transaction_per_order
FROM customers c
JOIN orders o
ON o.customerNumber = c.customerNumber
JOIN orderdetails od
ON od.orderNumber = o.orderNumber
WHERE o.status = 'Shipped'
GROUP BY c.customerName
HAVING COUNT(DISTINCT EXTRACT (YEAR FROM o.orderDate)) >1
ORDER BY total_transaksi DESC
LIMIT 5

-- SOAL 6
SELECT 
	c.customerName,
	c.city AS customer_city,
	oc.city AS office_city,
	SUM(od.quantityOrdered) AS total_unit_terjual,
	ROUND(SUM(od.quantityOrdered * od.priceEach) / COUNT(DISTINCT o.orderNumber), 2) AS avg_nilai_per_order
FROM customers c
JOIN employees e
ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN offices oc
ON oc.officeCode = e.officeCode
JOIN orders o
ON o.customerNumber = c.customerNumber
JOIN orderdetails od
ON od.orderNumber = o.orderNumber
WHERE oc.territory = 'EMEA'
GROUP BY c.customerNumber, oc.officeCode
HAVING COUNT(DISTINCT EXTRACT (YEAR FROM o.orderDate)) > 2 AND SUM(od.quantityOrdered) > 1000 AND ROUND(SUM(od.quantityOrdered * priceEach) / COUNT(DISTINCT o.orderNumber), 2) > 10000
ORDER BY avg_nilai_per_order DESC