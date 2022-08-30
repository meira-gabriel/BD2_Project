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
