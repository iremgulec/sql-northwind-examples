-- Kaç çalışan bulunmaktadır?
SELECT
COUNT(*) as CalisanSayisi
FROM dbo.Employees;

-- Çalışanların isim ve soyisimlerini listeleyin.

SELECT 
CONCAT(FirstName, ' ', LastName) as İsimSoyisim
FROM Employees

-- Çalışan erkek ve kadın sayısını bulun.

SELECT 
COUNT(*) KadinCalisanSayisi
FROM
Employees
WHERE TitleOfCourtesy IN ('Ms.', 'Mrs.')

SELECT 
COUNT(*) ErkekCalisanSayisi
FROM
Employees
WHERE TitleOfCourtesy = 'Mr.'


-- Çalışanlar kaç farklı şehirde yaşıyor?

SELECT 
COUNT(DISTINCT City) AS FarkliSehirdeCalisanSayisi
FROM 
Employees

-- Doğum tarihi 1960-05-29'dan büyük olanları listeleyelim.

SELECT 
CONCAT(FirstName,' ', LastName) as İsimSoyisim
FROM
Employees
WHERE BirthDate > '1960-05-29'

-- Adresinin içinde House ismi geçenleri listeleyelim.

SELECT 
CONCAT(FirstName,' ', LastName) as İsimSoyisim
FROM
Employees
WHERE Address LIKE '%House%'

-- Extension kolonu 3 haneli olanları listeleyim.

SELECT 
CONCAT(FirstName,' ', LastName) as İsimSoyisim
FROM
Employees
WHERE LEN(Extension) = 3

-- Çalışanların yaşlarını listeleyelim.
SELECT 
CONCAT(FirstName,' ', LastName) as İsimSoyisim,
DATEDIFF (year, BirthDate ,GETDATE()) as CalisanlarinYasi
FROM 
Employees

--Çalışanlar işe kaç yaşında başlamışlardır, en küçük yaşta başlayana göre sıralayalım.
SELECT 
CONCAT(FirstName,' ', LastName) as İsimSoyisim,
DATEDIFF (year, BirthDate , HireDate) as CalisanlarinİseBasladiklariYas
FROM
Employees
ORDER By 2

-- Region kolonu NULL olanları getirelim;

SELECT 
*
FROM 
Employees
WHERE Region IS NULL


-- Çalışanların ortalama yaşını hesaplayalım;

SELECT 
AVG(DATEDIFF(year, BirthDate, GETDATE())) AS OrtalamaCalisanYasi
FROM
Employees

-- Urunlerin KDV dahil ve KDV hariç fiyatlairini bulalim (%18);

SELECT 
ProductName, UnitPrice as KDVHaricFiyat,
CAST((UnitPrice * 1.18) AS DECIMAL(5, 2)) as KDVDahilFiyat
FROM
Products

-- KDV Dahil en pahali 5 urun nelerdir?

SELECT 
TOP 5
ProductName,UnitPrice * 1.18 as KDVDahil
FROM
Products
ORDER BY KDVDahil DESC


-- En ucuz 5 urunun ortalama fiyatini hesaplayalim;

SELECT
AVG(a.UnitPrice) AS OrtalamaFiyat
FROM (
SELECT TOP 5 UnitPrice FROM Products ORDER BY UnitPrice ASC
) AS a

-- Stogu olmayan urunler kac tanedir?

SELECT
COUNT(UnitsInStock) AS NoStock
FROM Products
WHERE UnitsInStock = 0


-- Stok adedi 20 ile 50 arasindaki urunleri getirelim

SELECT
ProductName 
FROM
Products
WHERE UnitsInStock Between 20 AND 50

-- En pahalı urunun adini getirelim.

SELECT
ProductName 
FROM 
Products
WHERE UnitPrice = (
SELECT
MAX(UnitPrice) 
FROM
Products)

-- Musterilerin ulkelere gore sayilarini getirelim;

SELECT 
Country, COUNT(*) AS UlkelereGoreDagilim
FROM CUSTOMERS
GROUP BY Country

-- Her kategoride kaç tane ürün bulunmaktadir?

SELECT
c.CategoryName,
COUNT(p.ProductID) as UrunSayisi
FROM
Products p
INNER JOIN Categories c ON  p.CategoryID= c.CategoryID
GROUP BY c.CategoryName

-- Çalışanlar ne kadarlık satış yapmıştır?
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS CalisanİsmiSoyismi,
SUM(od.UnitPrice * od.Quantity) AS ToplamSatisMiktari
FROM Employees e 
INNER JOIN Orders o  ON e.EmployeeID = o. EmployeeID
INNER JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY CONCAT(e.FirstName, ' ', e.LastName) 

-- Hangi sipariş firmaya ne kadar kazandırmıştır?

SELECT
OrderID, SUM(UnitPrice*Quantity*(1-Discount)) AS ToplamSiparişGetirisi
FROM
[Order Details]
GROUP BY OrderID

-- 50'den fazla satışı olan çalışanlar;
SELECT CONCAT(e.FirstName, ' ', e.LastName) AS CalisanİsimSoyisim, 
COUNT(o.OrderId) as SatisSayisi
FROM Orders o 
INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY CONCAT(e.FirstName, ' ', e.LastName) 
HAVING COUNT(o.OrderId) > 50

--Brezilya'da olmayan müşterileri listeleyelim.

SELECT 
*
FROM Customers
WHERE Country !=  'Brasil'

-- YA DA 

SELECT 
*
FROM Customers
WHERE Country NOT LIKE  'Brasil'

--Hiç satış olmayan ürün listesi

SELECT * FROM Products P
LEFT JOIN [Order Details] od ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL

-- Sipariş tarihleri 1 Haziran 1996 ile 30 Kasım 1996 tarihleri arasındaki
-- OrderID ve ShipCountrylerini getir.

	SELECT OrderID,ShipCountry FROM Orders 
	WHERE OrderDate BETWEEN '1996-06-01'  AND '1996-11-30'

-- Müşterilerin içerisinde en uzun isme sahip müşterinin harf sayısı nedir?

SELECT MAX(LEN(CompanyName)) AS MaksimumUzunluk
FROM CUSTOMERS

--Hangi üründen toplam kaç adet alınmıştır?

SELECT p.ProductName, SUM(Quantity) AS ToplamAdet
FROM [Order Details] od 
INNER JOIN Products p ON od.ProductID = p.ProductID
GROUP BY  p.ProductName

-- 1000 adetten fazla satılmış ürünler nelerdir?

SELECT ProductID,
SUM(quantity) ToplamAdet
FROM [Order Details] 
GROUP BY ProductID
HAVING SUM(quantity) > 1000

-- Fiyatları ortalamanın altında olan ürünlerin adı ve fiyatını getir.

SELECT ProductName, UnitPrice FROM Products
WHERE UnitPrice < (SELECT AVG(UnitPrice) FROM Products)

-- Hangi müşteriler hiç sipariş vermemiştir?

SELECT * FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL

-- YA DA (Daha Yavaş Çalışır)

SELECT * FROM Customers WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Orders)

-- Hangi ürün hangi kategoridedir?

SELECT p. ProductName, c.CategoryName from Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID

-- Hangi çalışan hangi bölgedendir?

Select CONCAT(e.FirstName, ' ', e.LastName) AS Calisanİsmi,
TerritoryDescription FROM Employees e 
INNER JOIN EmployeeTerritories et ON e.EmployeeID= et.EmployeeID
INNER JOIN Territories t ON t.TerritoryID= et.TerritoryID

-- Hangi tedarikçi hangi ürünü sağlıyor?

SELECT ProductName, s.CompanyName FROM Products p
INNER JOIN Suppliers s ON p.SupplierID = s. SupplierID

-- Beverages kategorisine ait ürünlerin listesini getir.

SELECT * FROM Products WHERE CategoryID = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Beverages' )

--Ürünlerin karşısına kategorilerini getir.

SELECT ProductName,
(SELECT c.CategoryName FROM Categories c WHERE p.CategoryID = c.CategoryID )Categories
FROM Products p

-- YA DA 

SELECT P. ProductName, C.CategoryName FROM Products P 
INNER JOIN Categories C ON P.CategoryID = C.CategoryID




