Reference: https://en.wikibooks.org/wiki/SQL_Exercises/Movie_theatres

 CREATE TABLE Movies (
   Code INTEGER PRIMARY KEY NOT NULL,
   Title TEXT NOT NULL,
   Rating TEXT 
 );
  
 CREATE TABLE MovieTheaters (
   Code INTEGER PRIMARY KEY NOT NULL,
   Name TEXT NOT NULL,
   Movie INTEGER  
     CONSTRAINT fk_Movies_Code REFERENCES Movies(Code)
 );
 
 INSERT INTO Movies(Code,Title,Rating) VALUES(1,'Citizen Kane','PG');
 INSERT INTO Movies(Code,Title,Rating) VALUES(2,'Singin'' in the Rain','G');
 INSERT INTO Movies(Code,Title,Rating) VALUES(3,'The Wizard of Oz','G');
 INSERT INTO Movies(Code,Title,Rating) VALUES(4,'The Quiet Man',NULL);
 INSERT INTO Movies(Code,Title,Rating) VALUES(5,'North by Northwest',NULL);
 INSERT INTO Movies(Code,Title,Rating) VALUES(6,'The Last Tango in Paris','NC-17');
 INSERT INTO Movies(Code,Title,Rating) VALUES(7,'Some Like it Hot','PG-13');
 INSERT INTO Movies(Code,Title,Rating) VALUES(8,'A Night at the Opera',NULL);
 
 INSERT INTO MovieTheaters(Code,Name,Movie) VALUES(1,'Odeon',5);
 INSERT INTO MovieTheaters(Code,Name,Movie) VALUES(2,'Imperial',1);
 INSERT INTO MovieTheaters(Code,Name,Movie) VALUES(3,'Majestic',NULL);
 INSERT INTO MovieTheaters(Code,Name,Movie) VALUES(4,'Royale',6);
 INSERT INTO MovieTheaters(Code,Name,Movie) VALUES(5,'Paraiso',3);
 INSERT INTO MovieTheaters(Code,Name,Movie) VALUES(6,'Nickelodeon',NULL);

 ---------------

 /* Select the title of all movies. */
SELECT Title FROM Movies;

/* Show all the distinct ratings in the database. */
SELECT DISTINCT Rating FROM Movies;

/* Show all unrated movies. */
SELECT Title FROM Movies WHERE Rating IS NULL;

/* Select all movie theaters that are not currently showing a movie. */
SELECT * FROM MovieTheaters
WHERE Movie IS NULL;

/* Select all data from all movie theaters and, additionally, the data from the movie that is being shown in the theater (if one is being shown). */
SELECT * FROM MovieTheaters T
LEFT JOIN Movies M
ON T.Movie = M.Code;

/* Select all data from all movies and, if that movie is being shown in a theater, show the data from the theater. */
SELECT M.Title, M.Rating,T.Code, T.Name, T.Movie FROM MovieTheaters T, Movies M
WHERE T.Movie = M.Code;

/* Show the titles of movies not currently being shown in any theaters. */
SELECT Title FROM Movies
WHERE Code NOT IN (SELECT Movie FROM MovieTheaters WHERE Movie IS NOT NULL);

/* Add the unrated movie "One, Two, Three". */
INSERT INTO Movies(Title,Rating) VALUES('One, Two, Three',NULL);

/* Set the rating of all unrated movies to "G". */
UPDATE Movies SET Rating = "G" WHERE Rating IS NULL;

/* Remove movie theaters projecting movies rated "NC-17". */
DELETE FROM MovieTheaters WHERE Movie IN
(SELECT Code FROM Movies WHERE
Movies.Rating = "NC-17");
