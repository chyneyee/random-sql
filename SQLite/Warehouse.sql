Reference: https://en.wikibooks.org/wiki/SQL_Exercises/The_warehouse

CREATE TABLE Warehouses (
   Code INTEGER PRIMARY KEY NOT NULL,
   Location TEXT NOT NULL ,
   Capacity INTEGER NOT NULL 
 );
 
 CREATE TABLE Boxes (
   Code TEXT PRIMARY KEY NOT NULL,
   Contents TEXT NOT NULL ,
   Value REAL NOT NULL ,
   Warehouse INTEGER NOT NULL 
     CONSTRAINT fk_Warehouses_Code REFERENCES Warehouses(Code)
 );
 
 INSERT INTO Warehouses(Code,Location,Capacity) VALUES(1,'Chicago',3);
 INSERT INTO Warehouses(Code,Location,Capacity) VALUES(2,'Chicago',4);
 INSERT INTO Warehouses(Code,Location,Capacity) VALUES(3,'New York',7);
 INSERT INTO Warehouses(Code,Location,Capacity) VALUES(4,'Los Angeles',2);
 INSERT INTO Warehouses(Code,Location,Capacity) VALUES(5,'San Francisco',8);
 
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('0MN7','Rocks',180,3);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('4H8P','Rocks',250,1);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('4RT3','Scissors',190,4);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('7G3H','Rocks',200,1);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('8JN6','Papers',75,1);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('8Y6U','Papers',50,3);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('9J6F','Papers',175,2);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('LL08','Rocks',140,4);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('P0H6','Scissors',125,1);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('P2T6','Scissors',150,2);
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('TU55','Papers',90,5);

 ---------------

 /* Select all warehouses. */
SELECT * FROM Warehouses;

/* Select all boxes with a value larger than $150. */
SELECT * FROM Boxes WHERE Value > 150;

/* Select all distinct contents in all the boxes. */
SELECT DISTINCT(Contents) FROM Boxes;

/* Select the average value of all the boxes. */
SELECT AVG(Value) AS AverageValue FROM Boxes;

/* Select the warehouse code and the average value of the boxes in each warehouse. */
SELECT Warehouse, AVG(Value) AS AverageValue
FROM Boxes
GROUP BY Warehouse;

/* Same as previous exercise, but select only those warehouses where the average value of the boxes is greater than 150. */
SELECT Warehouse, AVG(Value) AS AverageValue
FROM Boxes
GROUP BY Warehouse
HAVING AVG(Value) > 150;

/* Select the code of each box, along with the name of the city the box is located in. */
SELECT B.Code, W.Location
FROM Boxes B
INNER JOIN Warehouses W
ON B.Warehouse = W.Code;

/* Select the warehouse codes, along with the number of boxes in each warehouse. Optionally, take into account that some warehouses are empty (i.e., the box count should show up as zero, instead of omitting the warehouse from the result).*/
SELECT W.Code, COUNT(B.Code) AS NumberofBoxes
FROM Boxes B
INNER JOIN Warehouses W
ON B.Warehouse = W.Code
GROUP BY W.Code;

/* Select the codes of all warehouses that are saturated (a warehouse is saturated if the number of boxes in it is larger than the warehouse's capacity). */
SELECT W.Code
FROM Warehouses W
JOIN Boxes B
ON B.Warehouse = W.Code
GROUP BY W.Code
HAVING COUNT(B.Code) >
W.Capacity;

/* Select the codes of all the boxes located in Chicago. */
SELECT B.Code
FROM Boxes B
LEFT JOIN Warehouses W
ON B.Warehouse = W.Code
WHERE Location = 'Chicago';

/* Create a new warehouse in New York with a capacity for 3 boxes. */
INSERT INTO Warehouses(Location,Capacity) VALUES('New York',3);

/* Create a new box, with code "H5RT", containing "Papers" with a value of $200, and located in warehouse 2. */
INSERT INTO Boxes(Code,Contents,Value,Warehouse)
VALUES('H5RT','Papers',200,2);

/* Reduce the value of all boxes by 15%. */
UPDATE Boxes SET Value = Value * 0.85;

/* Apply a 20% value reduction to boxes with a value larger than the average value of all the boxes. */
UPDATE Boxes SET Value = Value * 0.8
WHERE HAVING Value > (SELECT AVG(Value) FROM Boxes);

/* Remove all boxes with a value lower than $100. */
DELETE FROM Boxes WHERE Value < 100;

/* Remove all boxes from saturated warehouses. */
DELETE FROM Boxes WHERE Warehouse IN
(SELECT Code FROM Warehouses WHERE Capacity <
 (SELECT COUNT(*) FROM Boxes WHERE Warehouse = Warehouses.Code)
 );