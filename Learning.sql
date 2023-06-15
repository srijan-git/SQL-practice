CREATE DATABASE myDB;
DROP DATABASE myDB;
USE myDB;
SET SQL_SAFE_UPDATES = 0;
ALTER DATABASE myDB READ ONLY=1; -- or 0.


CREATE TABLE employee(
	employee_ID INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    hourly_pay DECIMAL(5,2),
    hire_date DATE
);

RENAME TABLE employee to employees;
SELECT * FROM employees;
DROP TABLE employees;


ALTER TABLE employees ADD phone_number VARCHAR(15);
ALTER TABLE employees RENAME COLUMN phone_number TO email;
ALTER TABLE employees MODIFY COLUMN email VARCHAR(100);
ALTER TABLE employees MODIFY COLUMN email VARCHAR(100) FIRST;
ALTER TABLE employees MODIFY COLUMN email VARCHAR(100) AFTER last_name;
ALTER TABLE employees DROP COLUMN email;




INSERT INTO employees 
VALUES
(1,"Srijan","Khan",15.50,null),
(2,"Kankana","Das",40.50,"2021-05-15"),
(3,"Nimesh","Krishnan",35.50,"2022-02-22"),
(4,"Sk","Sujauddin",25.50,"2023-04-02");
INSERT INTO employees (employee_ID,first_name,last_name) VALUES(5,"Jhon","Cooper");

SELECT last_name,first_name FROM employees;
SELECT * FROM employees WHERE employee_ID=1;
SELECT * FROM employees WHERE first_name="Kankana";
SELECT * FROM employees WHERE hourly_pay>30;
SELECT * FROM employees WHERE hire_date >="2021-05-15";
SELECT * FROM employees WHERE employee_ID!=1;
SELECT * FROM employees WHERE hire_date IS NULL;
SELECT * FROM employees WHERE hourly_pay IS NOT NULL;

UPDATE employees SET hourly_pay=10.20,
hire_date="2023-01-11" WHERE last_name="Cooper";
DELETE FROM employees WHERE last_name="Cooper";


-- Suppose somehow someone deleted all the data from the database in than case we can use AUTOCOMMIT,COMMIT,ROLLBACK 
SET AUTOCOMMIT=OFF;
COMMIT;
DELETE FROM employees;
SELECT * FROM employees;
ROLLBACK;
TRUNCATE employees;



-- CURRENT_DATE(),CURRENT_TIME(),NOW() 
CREATE TABLE test(my_date DATE,my_time TIME,my_datetime DATETIME);
SELECT * FROM test;
INSERT INTO test values(CURRENT_DATE(),CURRENT_TIME(),NOW());
DROP TABLE test;




-- UNIQUE
CREATE TABLE products(
product_id INT,
product_name VARCHAR(25) UNIQUE,
product_code VARCHAR(30),
price DECIMAL(4,2)
);

SELECT * FROM products;

ALTER TABLE products ADD CONSTRAINT UNIQUE(product_code);
INSERT INTO products VALUES(100,"Hamburger","hamP1",3.99),(101,"Pizzs","pizzaP2",4.99);
INSERT INTO products VALUES(100,"Hamburger","hamP1",3.99); -- This will throw an error 

ALTER TABLE products MODIFY COLUMN price DECIMAL(4,2) NOT NULL;
INSERT INTO products VALUES(102,"icecream","iceP3",null); -- this will throw an error 
-- we can write instead
INSERT INTO products VALUES(102,"icecream","iceP3",0);
INSERT INTO products VALUES(102,"icecream","iceP3",2.00);


-- CHECK CONSTRAINT
CREATE TABLE  employees_region (
employee_id INT,
first_name VARCHAR(50),
last_name VARCHAR(50),
hourly_pay DECIMAL(5,2),
hire_date DATE,
CONSTRAINT check_hourly_pay CHECK (hourly_pay >=10.00)
); 
ALTER TABLE employees_region ADD CONSTRAINT chk_hourly_pay CHECK(hourly_pay>=10); -- 2nd way to add check 
SELECT * FROM employees_region;
INSERT INTO employees_region VALUES(500,"SRIJAN","KUMAR",5.00,CURRENT_DATE()); -- THis will throw an error
ALTER TABLE  employees_region DROP CHECK check_hourly_pay;
INSERT INTO employees_region VALUES(500,"SRIJAN","KUMAR",5.00,CURRENT_DATE());

-- DEFAULT CONSTRAINT
ALTER TABLE products ALTER price SET DEFAULT 0;
ALTER TABLE products ALTER product_code SET DEFAULT 0;
SELECT * FROM products;
DELETE FROM products WHERE product_id >=103;
INSERT INTO products(product_id,product_name) VALUES(103,"FORK"),(104,"SPOON"),(105,"NAPKIN");
TRUNCATE products;



-- Primary Key CONSTRAINT and AUTO_INCREMENT ATTRIBUTE
CREATE TABLE trasctions (
trasction_id INT PRIMARY KEY AUTO_INCREMENT,
amount DECIMAL(5,2)
);
RENAME TABLE trasctions TO transactions;
INSERT INTO transactions(amount) values(4.99);
SELECT * FROM trasctions;
ALTER TABLE transactions AUTO_INCREMENT=1000;
DELETE FROM transactions;
DROP TABLE transactions;
ROLLBACK;




-- FOREIGN KEY
CREATE TABLE customer(
customer_id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50),
last_name VARCHAR(50)
);
SELECT * FROM CUSTOMER;
INSERT INTO CUSTOMER (first_name,last_name) VALUES("Srijan","Khan"),("Kankana","Das"),("Nimesh","Krishnan"),("Sk","Sujauddin");
CREATE TABLE transactions (
trasction_id INT PRIMARY KEY AUTO_INCREMENT,
amount DECIMAL(5,2),
customer_id INT,
FOREIGN KEY(customer_id) REFERENCES customer(customer_id)
);
SELECT * FROM trasctions;
ALTER TABLE transactions DROP FOREIGN KEY trasctions_ibfk_1;  -- FOREIGN KEY name is under the SCNEMA SECTION AND TABLE AND FOREIGN KEY 
ALTER TABLE transactions ADD CONSTRAINT foeignKey_customer_id FOREIGN KEY(customer_id) REFERENCES customer(customer_id);
ALTER TABLE transactions AUTO_INCREMENT=1000;
INSERT INTO transactions(amount,customer_id) values(4.99,3),(5.88,2),(3.99,3),(2.88,1);



-- JOINS
INSERT INTO trasctions(amount,customer_id) VALUES(1.00,NULL);
INSERT INTO customer (first_name,last_name) VALUES("Poppy","Puff");
SELECT * FROM trasctions;
SELECT * FROM customer;
SELECT * FROM transactions INNER JOIN customer ON transactions.customer_id=customer.customer_id;
SELECT * FROM transactions LEFT JOIN customer ON transactions.customer_id=customer.customer_id;
SELECT * FROM transactions RIGHT JOIN customer ON transactions.customer_id=customer.customer_id;

-- LOGICAL OPERATOR(AND,OR,NOT,IN,BETWEEN) 

-- WILD CARD OPERATOR(%,_) 
SELECT * FROM customer WHERE first_name LIKE "S%";
SELECT * FROM customer WHERE last_name LIKE "%n";
SELECT * FROM customer WHERE first_name LIKE "__pp_";
SELECT * FROM customer WHERE first_name LIKE "_a%";


-- ORDER BY
SELECT * FROM customer ORDER BY last_name DESC; 

-- LIMIT
 SELECT * FROM customer ORDER BY last_name DESC LIMIT 2;
 SELECT * FROM customer ORDER BY last_name DESC LIMIT 1,2; -- We can set OffSet 


-- UNION (It does not allows duplicates)
-- UNION ALL (IT allows duplicates)
SELECT first_name,last_name FROM employees 
UNION
SELECT first_name,last_name FROM customer;

SELECT first_name,last_name FROM employees 
UNION ALL
SELECT first_name,last_name FROM customer;



-- SELF JOIN
ALTER TABLE customer ADD referral_id INT;
SELECT * FROM customer;
DELETE FROM customer WHERE customer_id=5;
UPDATE customer SET referral_id=1 WHERE customer_id=2;
UPDATE customer SET referral_id=2  WHERE customer_id=3;
UPDATE customer SET referral_id=1  WHERE customer_id=4;
SELECT a.customer_id,a.first_name,a.last_name,CONCAT(b.first_name," ",b.last_name) AS referred_by
 FROM customer AS a INNER JOIN customer AS B ON a.referral_id=b.customer_id;
 
 
 -- VIEWS (This is a virtual table which is made based on real tables)
CREATE VIEW employee_attendance AS SELECT first_name,last_name FROM employees;
SELECT * FROM employee_attendance ORDER BY last_name DESC;
DROP VIEW employee_attendance;
ALTER TABLE customer ADD COLUMN email VARCHAR(50);
UPDATE customer SET email="sk@gmail.com" WHERE customer_id=4;
SELECT * FROM customer;
CREATE VIEW customer_emails AS SELECT email FROM customer;
SELECT * FROM customer_emails;
INSERT INTO customer VALUES(5,"Perl","Krabs",null,"Pkrabs@gmail.com");

-- GROUP BY( Aggregate all rows by a specific column often used with aggregate functions ex. SUM() MAX() MIN() AVG() COUNT()) 
SELECT * FROM transactions;
ALTER TABLE transactions ADD COLUMN order_date DATE;
UPDATE transactions SET order_date="2023-01-03" WHERE trasction_id=1004;
SELECT SUM(amount) AS Total_amount,order_date FROM transactions GROUP BY order_date;
SELECT MAX(amount) AS Total_amount,order_date FROM transactions GROUP BY order_date;
SELECT COUNT(amount) AS total_amount,customer_id FROM transactions GROUP BY customer_id HAVING COUNT(amount) >1 AND customer_id IS NOT NULL;

-- ROLLUP ,extension of GROUP BY clause
-- produce another row and shows the grand total(super-aggregate value) 
SELECT SUM(amount) AS Total_amount,order_date FROM transactions GROUP BY order_date WITH ROLLUP;


-- ON DELETE SET NULL = when a FK is deleted,replaced fk with null.
-- ON DELETE CASCADE = when a FK is deleted, delete row. 
ALTER TABLE transactions DROP FOREIGN KEY foeignKey_customer_id;
ALTER TABLE transactions ADD CONSTRAINT fk_customer_id FOREIGN KEY(customer_id) REFERENCES customer(customer_id)
ON DELETE CASCADE;
UPDATE transactions SET customer_id=5 WHERE trasction_id=1004;
SELECT * FROM transactions;
SELECT * FROM customer;
DELETE FROM customer WHERE customer_id=5;
INSERT INTO customer VALUES(5,"Perl","Krabs",null,"Pkrabs@gmail.com");
INSERT INTO transactions VALUES(1004,3.99,5,"2023-01-03");


-- STORED PROCEDURE (If there is a query that you write very often then we can use stored procedure)
-- 
DELIMITER $$
CREATE PROCEDURE get_customer()
BEGIN
	SELECT * FROM customer;
END $$
DELIMITER ;
CALL get_customer();
DROP PROCEDURE get_customer;


DELIMITER $$
CREATE PROCEDURE find_customer(IN id INT)
BEGIN	
	SELECT * FROM customer WHERE customer_id=id;
END $$
DELIMITER ;
CALL find_customer(1);


DELIMITER $$
CREATE PROCEDURE find_customer_by_name(IN f_name VARCHAR(50),IN l_name VARCHAR(50))
BEGIN	
	SELECT * FROM customer WHERE first_name=f_name AND last_name=l_name;
END $$
DELIMITER ;
CALL find_customer_by_name("Srijan","Khan");

-- TRIGGER = When and event happens do something ex.(INSERT,UPDATE,DELETE) CHECKS data,handles errors,auditing tables 
 SELECT * FROM employees;
ALTER TABLE employees MODIFY salary DECIMAL(10,2) AFTER hourly_pay;
UPDATE employees SET salary=hourly_pay*40*52; -- 40 hours a week and 52 weeks in a year(2080 hours of work in a year)

CREATE TRIGGER before_hourly_pay_update
BEFORE UPDATE ON employees
FOR EACH ROW
SET NEW.salary=(NEW.hourly_pay*2080);
UPDATE employees SET hourly_pay=51 WHERE employee_ID=1;

CREATE TRIGGER before_hourly_pay_insert 
BEFORE INSERT ON employees
FOR EACH ROW
SET NEW.salary=(NEW.hourly_pay*2080);

INSERT INTO employees values(5,"Jhon","Smith",30.50,null,2023-05-23);



-- Find 2nd highest Salary from a employee table
SELECT MAX(SALARY) FROM emp1 WHERE SALARY NOT IN (SELECT MAX(SALARY) FROM emp1);


-- Find Nth highest Salary from a employee table

CREATE table emp1(id INT PRIMARY KEY NOT NULL,SALARY varchar(50));
INSERT INTO emp1 values(1,10000);
INSERT INTO emp1 values(2,10000);
INSERT INTO emp1 values(3,20000);
INSERT INTO emp1 values(4,30000);
TRUNCATE TABLE emp1;
SELECT * FROM emp1;
ALTER TABLE emp1 DROP PRIMARY KEY;
ALTER TABLE emp1 MODIFY COLUMN id INT PRIMARY KEY NOT NULL;

SELECT id,salary from emp1 e1 where (3-1) =(SELECT COUNT(DISTINCT SALARY) FROM emp1 e2
WHERE e2.salary>e1.salary);
 