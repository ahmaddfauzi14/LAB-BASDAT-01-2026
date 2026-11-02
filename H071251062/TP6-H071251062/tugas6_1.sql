set search_path TO classicmodels;

-- SOAL 1
SELECT
	productCode,
	productName,
	msrp,
	quantityInStock,
	CASE
		WHEN msrp < 50 AND quantityInStock > 500 THEN 'Ekonomis - Stok Tinggi'
		WHEN msrp < 50 AND quantityInStock < 500 THEN 'Ekonomis - Stok Rendah'
		WHEN (msrp BETWEEN 50 AND 100) AND quantityInStock > 500 THEN 'Harga Menengah - Stok Tinggi'
		WHEN (msrp BETWEEN 50 AND 100) AND quantityInStock < 500 THEN 'Harga Menengah - Stok Rendah'
		WHEN msrp > 100 AND quantityInStock > 500 THEN 'Harga Premium - Stok Tinggi'
		ELSE 'Harga Premium - Stok Rendah'
	END AS "Kategori"
FROM products
ORDER BY msrp DESC

-- SOAL 2
SELECT
	productCode,
	SUM(quantityOrdered)
FROM orderdetails
GROUP BY productCode
HAVING SUM(quantityOrdered) > (
	SELECT AVG(quantityOrdered)
	FROM orderdetails
	) AND
	COUNT (DISTINCT quantityOrdered) > 10
ORDER BY SUM(quantityOrdered) DESC

-- SOAL 3
SELECT
	productCode,
	productName,
	quantityInStock,
	msrp
FROM products
WHERE quantityInStock > (
	SELECT AVG(quantityInStock)
	FROM products
	) AND 
	msrp > (
	SELECT AVG(msrp)
	FROM products
	)
ORDER BY quantityInStock DESC

-- SOAL 4
BEGIN

UPDATE orders
SET status = 'Shipped'
WHERE orderNumber = 10100
RETURNING *

SAVEPOINT status_pengiriman

UPDATE orders
SET status = 'Cancelled'
WHERE orderNumber = 10100
RETURNING *

ROLLBACK TO SAVEPOINT status_pengiriman

SELECT * FROM orders
WHERE orderNumber = 10100

COMMIT

CREATE DATABASE perpustakaan_db