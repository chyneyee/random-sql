Reference: https://en.wikibooks.org/wiki/SQL_Exercises/Employee_management

CREATE TABLE Departments (
   Code INTEGER PRIMARY KEY NOT NULL,
   Name TEXT NOT NULL ,
   Budget REAL NOT NULL 
 );
 
 CREATE TABLE Employees (
   SSN INTEGER PRIMARY KEY NOT NULL,
   Name TEXT NOT NULL ,
   LastName TEXT NOT NULL ,
   Department INTEGER NOT NULL , 
   CONSTRAINT fk_Departments_Code FOREIGN KEY(Department) 
   REFERENCES Departments(Code)
 );
 
 INSERT INTO Departments(Code,Name,Budget) VALUES(14,'IT',65000);
INSERT INTO Departments(Code,Name,Budget) VALUES(37,'Accounting',15000);
INSERT INTO Departments(Code,Name,Budget) VALUES(59,'Human Resources',240000);
INSERT INTO Departments(Code,Name,Budget) VALUES(77,'Research',55000);

INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('123234877','Michael','Rogers',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('152934485','Anand','Manikutty',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('222364883','Carol','Smith',37);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('326587417','Joe','Stevens',37);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('332154719','Mary-Anne','Foster',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('332569843','George','ODonnell',77);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('546523478','John','Doe',59);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('631231482','David','Smith',77);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('654873219','Zacary','Efron',59);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('745685214','Eric','Goldsmith',59);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('845657245','Elizabeth','Doe',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('845657246','Kumar','Swamy',14);

-------------------

/* Select the last name of all employees. */
SELECT LastName FROM Employees;

/* Select the last name of all employees, without duplicates. */
SELECT DISTINCT(LastName) FROM Employees;

/* Select all the data of employees whose last name is "Smith". */
SELECT * FROM Employees WHERE LastName='Smith';

/* Select all the data of employees whose last name is "Smith" or "Doe". */
SELECT * FROM Employees WHERE LastName IN('Smith', 'Doe');

/* Select all the data of employees that work in department 14. */
SELECT * FROM Employees WHERE Department = 14;

/* Select all the data of employees that work in department 37 or department 77. */
SELECT * FROM Employees WHERE Department IN (37,77);

/* Select all the data of employees whose last name begins with an "S". */
SELECT * FROM Employees WHERE LastName LIKE 'S%';

/* Select the sum of all the departments' budgets. */
SELECT SUM(Budget) AS TotalBudget FROM Departments;

/* Select the number of employees in each department (you only need to show the department code and the number of employees). */
SELECT Department, COUNT(*) AS NumberEmployees FROM Employees
GROUP BY Department;

/* Select all the data of employees, including each employee's department's data. */
SELECT * FROM Employees INNER JOIN Departments
ON Employees.Department = Departments.Code;

/* Select the name and last name of each employee, along with the name and budget of the employee's department. */
SELECT E.Name, E.LastName, D.Name, D.Budget
FROM Employees E INNER JOIN Departments D
ON E.Department = D.Code;

/* Select the name and last name of employees working for departments with a budget greater than $60,000. */
SELECT Employees.Name, Employees.LastName 
FROM Employees INNER JOIN Departments
ON Employees.Department = Departments.Code
WHERE Departments.Budget > 60000;

/* Select the departments with a budget larger than the average budget of all the departments. */
SELECT * FROM Departments
WHERE Budget > (SELECT AVG(Budget) FROM Departments);

/* Select the names of departments with more than two employees. */
SELECT D.Name FROM Departments D
INNER JOIN Employees E
ON D.Code = E.Department
GROUP BY D.Name
HAVING COUNT(*) > 2;

/* Select the name and last name of employees working for departments with second lowest budget. */
SELECT E.Name, E.LastName FROM Employees E
WHERE E.Department = 
(SELECT sub.Code
 FROM (SELECT * FROM Departments D ORDER BY D.Budget LIMIT 2) sub
 ORDER BY budget DESC LIMIT 1);
 
 /* Add a new department called "Quality Assurance", with a budget of $40,000 and departmental code 11. Add an employee called "Mary Moore" in that department, with SSN 847-21-9811. */
 INSERT INTO Departments(Code,Name,Budget) VALUES(11, 'Quality Assurance',40000);
 INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('847219811', 'Mary','Moore',11);
 
 /* Reduce the budget of all departments by 10%. */
 UPDATE Departments SET Budget = Budget *0.9;
 
 /* Reassign all employees from the Research department (code 77) to the IT department (code 14).*/
 UPDATE Employees SET Department = 14
 WHERE Department = 77;
 
 /* Delete from the table all employees in the IT department (code 14). */
 DELETE FROM Employees WHERE Department = 14;
 
 /* Delete from the table all employees who work in departments with a budget greater than or equal to $60,000. */
 DELETE FROM Employees
 WHERE Department IN
 (SELECT Code FROM Departments
 WHERE Budget >=60000);
 
 /* Delete from the table all employees. */
 DELETE FROM Employees;