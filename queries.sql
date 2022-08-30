/* 1°Query:Seleciona ID do funcionario, primeiro e segundo nome, 
alem de sua região. Faz uma verificação da região
se a mesma for WA e ordena pelo ID*/
SELECT EmployeeID, LastName, FirstName, Region FROM employees
	WHERE EmployeeID IN (SELECT EmployeeID FROM orders WHERE Region = 'WA')
		ORDER BY EmployeeID; 


/*2°Query:Seleciona o ID do funcionario, data do pedido, ID do cliente e a via de transporte
e pede todas as vias acima do valor 1, ordenando as mesmas*/
SELECT EmployeeID, OrderDate, CustomerID, ShipVia FROM orders
	GROUP BY EmployeeID HAVING ShipVia > 1 ORDER BY ShipVia;


/*3°Query:Seleciona o ID do produto e o preço da unidade da tabela produtos, após isso seleciona
ID do distribuidor e o nome da compania da tabela suplementos e caso existam em ambas tabelas
distribuidores com produtos de preço abaixo de 20 será apresentado de forma agrupada*/
SELECT ProductID, ProductName, UnitPrice FROM products
	WHERE EXISTS (SELECT SupplierID, CompanyName FROM suppliers WHERE
		products.SupplierID = suppliers.SupplierID AND UnitPrice < 20) GROUP BY UnitPrice;


/*4°Query:Seleciona o ID de funcionario, primeiro nome, segundo nome, endereço e cidade da tabela funcionarios
e faz todas as verificações de igualdade com atabela da esquerda, ordenando pelo ID de funcionario*/
SELECT a.EmployeeID, a.FirstName, a.LastName, a.Address, a.City 
	FROM employees a LEFT JOIN employeeterritories b
		ON a.EmployeeID = b.EmployeeID;
        

/*5°Query:Seleciona da tabela produtos o nome do produto, Id do fornecedor, preço por unidade,
unidades em estoque e o ID de categoria, faz as verificações de igualdade com a tabela da direita
ordenando pelo preço por unidade*/        
SELECT a.ProductName, a.SupplierID, a.UnitPrice, a.UnitsInStock, a.CategoryID 
	FROM products a RIGHT JOIN categories b
		ON a.CategoryID = b.CategoryID ORDER BY UnitPrice;
        

/*6°Query:Seleciona da tabela clientes, cidade, região e país, onde a cidade não seja nula
e une as informações de cidade, região e país da tabela funcionarios, ordenando por cidade*/
SELECT City, Region, Country FROM customers WHERE City
	IS NOT NULL UNION SELECT City, Region, Country
		FROM employees ORDER BY City;
    

/*7°Query:Seleciona os ID de pedido, ID do cliente, data do pedido e ID do produto da tabela Pedidos 
 verifica qual ID de pedido coincide com a tabela detalhes de pedidos*/
SELECT orders.OrderID, orderdetails.OrderID, CustomerID, OrderDate, ProductID  
	FROM orders INNER JOIN orderdetails 
		ON orders.OrderID = orderdetails.OrderID;
    

/*8°Query:Seleciona o primeiro e ultimo nome do funcionario e tambem o primeiro e ultimo nome de seu "chefe"
retornando os valores não nulos, alinhando somente com suas proprias informações "Self join" e ordenando
com o nome do chefe. OBS: Retorna valores identicos, pois parece que os funcionarios cuidam de si mesmos,
como vendedores ou algo assim*/    
SELECT COALESCE(e.FirstName, '', e.LastName) AS employee,
	COALESCE(m.FirstName, '', m.LastName) AS ReportsTo FROM employees e
		INNER JOIN employees m ON e.EmployeeID = m.EmployeeID ORDER BY ReportsTo;
        

/*9°Query:Seleciona a quantidade de produtos e o ID do produto da tabela Detalhes de pedido
ordenando pela quantidade e somando o mesmo*/
SELECT Quantity, ProductID FROM orderdetails GROUP BY Quantity WITH ROLLUP;


/*10°Query:Seleciona as unidades em estoque e as unidades de pedidos da tabela produtos e verifica 
as unidades em estoque com numero entre 2 a 10 ordenando por essa mesma variavel*/
SELECT UnitsInStock, UnitsOnOrder
	FROM products
		WHERE UnitsInStock BETWEEN 2 AND 10 
			ORDER BY UnitsInStock;


/*11° contagem dos produtos*/
SELECT count(*) as 'número total de produtos' FROM products;    

/*12° mostra os compradores do Estado de São Paulo*/ 
SELECT *FROM customers c 
	WHERE c.Region like 'SP';        

/*13° mostra o numero do pedido e a data que foi feito pelo cliente*/
SELECT orders.OrderID, Customers.ContactName, orders.OrderDate
	FROM orders
		INNER JOIN customers ON Orders.CustomerID=Customers.CustomerID;

/*14° quantidade de clientes por país*/
SELECT COUNT(CustomerID) as 'qtde total por país', Country as 'país' FROM customers
	GROUP BY Country
		HAVING COUNT(CustomerID) 
			ORDER BY COUNT(CustomerID) ASC;

/*15° seleciona todos os produtos com valor entre 10 e 80 e ordena por preço do menor para o maior*/
SELECT ProductName, UnitPrice  FROM products
	WHERE UnitPrice BETWEEN 10 AND 80 order by UnitPrice ASC;

/*16° média de preços dos produtos */
SELECT AVG(UnitPrice) as 'Média de preço'
	FROM products;
 
/*17° seleciona todos os pedidos entre essas datas*/
SELECT * FROM orders
	WHERE OrderDate BETWEEN '1996-10-21' and '1997-11-26';

/*18° mostra os funcionários que moram no Reino Unido*/
SELECT FirstName, Title, reportsTo, Extension, PostalCode FROM employees
	WHERE Country IN
(SELECT Country FROM employees
	WHERE Country = 'UK');

/*19° apresenta os funcionários que ganham menos de 2000 e os que ganham mais de 2800 */
SELECT FirstName, Title, Salary FROM employees WHERE Salary < 2000
	UNION ALL
SELECT FirstName, Title, Salary FROM employees WHERE Salary > 2800
	ORDER BY Salary;

/*20° apresenta todos os produtos que contém entre 1 e 20 unidades no estoque e os que tem mais de 50 unidades,
em ordem de quantidade */
SELECT ProductName, ProductID,UnitsInStock FROM products WHERE UnitsInStock BETWEEN 1 AND 20
	UNION ALL
SELECT ProductName, ProductID,UnitsInStock FROM products WHERE UnitsInStock > 50
	ORDER BY UnitsInStock;
	
/*21° Query: Seleciona a cidade e a empresa fornecedora dos produtos e os consumidores e fornecedores
verificando e removendo as duplicadas*/
CREATE VIEW `Fornecedores e Clientes por Cidade`
	AS
		SELECT City, CompanyName, ContactName,'Customers' AS Relationship 
			FROM Customers
	UNION
		SELECT City, CompanyName, ContactName, 'Suppliers'
			FROM Suppliers 
	ORDER BY City;


/*22° Query: Seleciona a cidade e a empresa fornecedora dos produtos e os consumidores e fornecedores
verificando e removendo as duplicadas*/

CREATE VIEW `Resumo de Vendas por Ano`
AS
SELECT
   Orders.ShippedDate, 
   Orders.OrderID, 
   `Order Subtotals`.Subtotal
FROM Orders 
   INNER JOIN `Order Subtotals` ON Orders.OrderID = `Order Subtotals`.OrderID
WHERE Orders.ShippedDate IS NOT NULL;


/*23° Query: Seleciona a dados dos produtos e os respectivos compradores*/

CREATE VIEW `Orders Qry`
AS
SELECT 
   Orders.OrderID,
   Orders.CustomerID,
   Orders.EmployeeID, 
   Orders.OrderDate, 
   Orders.RequiredDate,
   Orders.ShippedDate, 
   Orders.ShipVia, 
   Orders.Freight,
   Orders.ShipName, 
   Orders.ShipAddress, 
   Orders.ShipCity,
   Orders.ShipRegion,
   Orders.ShipPostalCode,
   Orders.ShipCountry,
   Customers.CompanyName,
   Customers.Address,
   Customers.City,
   Customers.Region,
   Customers.PostalCode, 
   Customers.Country
FROM Customers 
   JOIN Orders ON Customers.CustomerID = Orders.CustomerID;


/*24° Query: Subtotal para cada pedido identificado por OrderID.
Através de consulta simples usando GROUP BY para agregar dados para cada pedido.*/

SELECT OrderID, 
    FORMAT(sum(UnitPrice * Quantity * (1 - Discount)), 2) AS Subtotal
		FROM order_details
	GROUP by OrderID
	ORDER by OrderID;


/*25° Query: Selecção de produtos por ordem alfabetica*/

SELECT distinct b.*, a.Category_Name
	FROM Categories a 
		INNER JOIN Products b ON a.Category_ID = b.Category_ID
			WHERE b.Discontinued = 'N'
	ORDER BY b.Product_Name;



/*26° Query: Seleção de produtos com desconto aplicado*/

SELECT DISTINCT y.OrderID, 
    y.ProductID, 
    x.ProductName, 
    y.UnitPrice, 
    y.Quantity, 
    y.Discount, 
    round(y.UnitPrice * y.Quantity * (1 - y.Discount), 2) AS ExtendedPrice
	FROM Products x
		INNER JOIN Order_Details y ON x.ProductID = y.ProductID
	ORDER BY y.OrderID;


/*27° Query: Seleção categoria, para obtenção de lista de produtos vendidos e o valor total das vendas.*/

SELECT DISTINCT a.CategoryID, 
    a.CategoryName,  
    b.ProductName, 
    SUM(round(y.UnitPrice * y.Quantity * (1 - y.Discount), 2)) AS ProductSales
		FROM Order_Details y
	INNER JOIN Orders d ON d.OrderID = y.OrderID
	INNER JOIN Products b ON b.ProductID = y.ProductID
	INNER JOIN Categories a ON a.CategoryID = b.CategoryID
		WHERE d.OrderDate BETWEEN date('1997/1/1') AND date('1997/12/31')
	GROUP BY a.CategoryID, a.CategoryName, b.ProductName
	ORDER BY a.CategoryName, b.ProductName, ProductSales;


/*28° Query: Quantidade de unidades em estoque por categoria e o local fornecedor,
por meio de classificação/atribuição de continente*/

SELECT c.CategoryName AS "Product Category", 
       CASE WHEN s.Country IN 
                 ('UK','Spain','Sweden','Germany','Norway',
                  'Denmark','Netherlands','Finland','Italy','France')
            THEN 'Europe'
            WHEN s.Country IN ('USA','Canada','Brazil') 
            THEN 'America'
            ELSE 'Asia-Pacific'
        END AS "Supplier Continent", 
        SUM(p.UnitsInStock) AS UnitsInStock
	FROM Suppliers s 
	INNER JOIN Products p ON p.SupplierID=s.SupplierID
	INNER JOIN Categories c ON c.CategoryID=p.CategoryID 
	GROUP BY c.CategoryName, 
    CASE WHEN s.Country in 
                 ('UK','Spain','Sweden','Germany','Norway',
                  'Denmark','Netherlands','Finland','Italy','France')
              THEN 'Europe'
              WHEN s.Country IN ('USA','Canada','Brazil') 
              THEN 'America'
              ELSE 'Asia-Pacific'
	END;


/*29° Query: Produtos acima do preço médio
Emprego de subconsulta para obter um valor único (preço unitário médio)*/

SELECT DISTINCT ProductName, UnitPrice
	FROM Products
	WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products)
	ORDER BY UnitPrice;


/*30° Query: Valor das vendas, por funcionário discriminado pelo nome do país*/

SELECT DISTINCT b.*, a.CategoryNamefrom Categories a 
	INNER JOIN Products b ON a.CategoryID = b.CategoryIDwhere b.Discontinued = 'N'
	ORDER BY b.ProductName;	
	
	
