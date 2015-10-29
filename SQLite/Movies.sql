Reference: https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_extra/

CREATE TABLE Movie
    ("mID" INTEGER, "title" TEXT(23), "year" INTEGER, "director" TEXT(16))
;

INSERT INTO Movie
    ("mID", "title", "year", "director")
VALUES
    (101, 'Gone with the Wind', 1939, 'Victor Fleming')
;

INSERT INTO Movie
    ("mID", "title", "year", "director")
VALUES
    (102, 'Star Wars', 1977, 'George Lucas')
;

INSERT INTO Movie
    ("mID", "title", "year", "director")
VALUES
    (103, 'The Sound of Music', 1965, 'Robert Wise')
;

INSERT INTO Movie
    ("mID", "title", "year", "director")
VALUES
    (104, 'E.T.', 1982, 'Steven Spielberg')
;

INSERT INTO Movie
    ("mID", "title", "year", "director")
VALUES
    (105, 'Titanic', 1997, 'James Cameron')
;

INSERT INTO Movie
    ("mID", "title", "year", "director")
VALUES
    (106, 'Snow White', 1937, '<null>')
;

INSERT INTO Movie
    ("mID", "title", "year", "director")
VALUES
    (107, 'Avatar', 2009, 'James Cameron')
;

INSERT INTO Movie
    ("mID", "title", "year", "director")
VALUES
    (108, 'Raiders of the Lost Ark', 1981, 'Steven Spielberg')
;



CREATE TABLE Reviewer
    ("rID" INTEGER, "name" TEXT(16))
;

INSERT INTO Reviewer
    ("rID", "name")
VALUES
    (201, 'Sarah Martinez')
;

INSERT INTO Reviewer
    ("rID", "name")
VALUES
    (202, 'Daniel Lewis')
;

INSERT INTO Reviewer
    ("rID", "name")
VALUES
    (203, 'Brittany Harris')
;

INSERT INTO Reviewer
    ("rID", "name")
VALUES
    (204, 'Mike Anderson')
;

INSERT INTO Reviewer
    ("rID", "name")
VALUES
    (205, 'Chris Jackson')
;

INSERT INTO Reviewer
    ("rID", "name")
VALUES
    (206, 'Elizabeth Thomas')
;

INSERT INTO Reviewer
    ("rID", "name")
VALUES
    (207, 'James Cameron')
;

INSERT INTO Reviewer
    ("rID", "name")
VALUES
    (208, 'Ashley White')
;



CREATE TABLE Rating
    ("rID" INTEGER, "mID" INTEGER, "stars" INTEGER, "ratingDate" TEXT(10))
;

INSERT INTO Rating
    ("rID", "mID", "stars", "ratingDate")
VALUES
    (201, 101, 2, '2011-01-22')
;

INSERT INTO Rating
    ("rID", "mID", "stars", "ratingDate")
VALUES
    (201, 101, 4, '2011-01-27')
;

INSERT INTO Rating
    ("rID", "mID", "stars", "ratingDate")
VALUES
    (202, 106, 4,NULL)
;

INSERT INTO Rating
    ("rID", "mID", "stars", "ratingDate")
VALUES
    (203, 103, 2, '2011-01-20')
;

INSERT INTO Rating
    ("rID", "mID", "stars", "ratingDate")
VALUES
    (203, 108, 4, '2011-01-12')
;

INSERT INTO Rating
    ("rID", "mID", "stars", "ratingDate")
VALUES
    (203, 108, 2, '2011-01-30')
;

INSERT INTO Rating
    ("rID", "mID", "stars", "ratingDate")
VALUES
    (204, 101, 3, '2011-01-09')
;

INSERT INTO Rating
    ("rID", "mID", "stars", "ratingDate")
VALUES
    (205, 103, 3, '2011-01-27')
;

INSERT INTO Rating
    ("rID", "mID", "stars", "ratingDate")
VALUES
    (205, 104, 2, '2011-01-22')
;

INSERT INTO Rating
    ("rID", "mID", "stars", "ratingDate")
VALUES
    (205, 108, 4,NULL)
;

INSERT INTO Rating
    ("rID", "mID", "stars", "ratingDate")
VALUES
    (206, 107, 3, '2011-01-15')
;

INSERT INTO Rating
    ("rID", "mID", "stars", "ratingDate")
VALUES
    (206, 106, 5, '2011-01-19')
;

INSERT INTO Rating
    ("rID", "mID", "stars", "ratingDate")
VALUES
    (207, 107, 5, '2011-01-20')
;

INSERT INTO Rating
    ("rID", "mID", "stars", "ratingDate")
VALUES
    (208, 104, 3, '2011-01-02')
;


-------------------------------

/* Find the titles of all movies directed by Steven Spielberg. */
SELECT title FROM MOVIE WHERE director="Steven Spielberg";

/* Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.*/
SELECT DISTINCT(MOVIE.year) FROM MOVIE, RATING WHERE MOVIE.mID = Rating.mID AND Rating.stars IN (4,5) ORDER BY MOVIE.year ASC;

/* Find the titles of all movies that have no ratings.*/
SELECT DISTINCT(MOVIE.title) FROM MOVIE, RATING WHERE NOT EXISTS (SELECT RATING.stars FROM RATING WHERE MOVIE.mID = Rating.mID);

/* Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. */
SELECT REVIEWER.name FROM REVIEWER, RATING WHERE REVIEWER.rID = RATING.rID AND RATING.ratingDate IS NULL;

/* Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. */
SELECT REVIEWER.name, MOVIE.title, RATING.stars, RATING.ratingDate FROM REVIEWER, RATING, MOVIE WHERE REVIEWER.rID = RATING.rID AND RATING.mID = MOVIE.mID ORDER BY REVIEWER.name, MOVIE.title, RATING.stars;

/* For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. */
SELECT REVIEWER.name, MOVIE.title FROM RATING, MOVIE, REVIEWER 
WHERE Reviewer.rID = RATING.rID
AND MOVIE.mID = RATING.mID
GROUP BY REVIEWER.name, MOVIE.title HAVING count(REVIEWER.name) > 1
AND RATING.stars > (SELECT MIN(RATING.stars) FROM RATING)

/* For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. */
SELECT MOVIE.title, RATING.stars
FROM MOVIE, RATING, REVIEWER
WHERE MOVIE.mID = RATING.mID
GROUP BY MOVIE.title
HAVING count(RATING.stars) >= 1
AND (SELECT MAX(RATING.stars) FROM RATING)

/* For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. */
SELECT MOVIE.title, (MAX(RATING.stars)) - (MIN(RATING.stars)) AS "RATING_SPREAD"
FROM MOVIE, RATING
WHERE MOVIE.mID = RATING.mID
GROUP BY MOVIE.title
ORDER BY "RATING_SPREAD" DESC, MOVIE.title

/* Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) */
select max(a1)-min(a1) from
(select avg(av1) a1 from
(select avg(stars) av1 from rating r join movie m on r.mid=m.mid where m.year < 1980
group by r.mid)
union
select avg(av2) a1 from
(select avg(stars) av2 from rating r join movie m on r.mid=m.mid where m.year > 1980
group by r.mid))

/* Find the names of all reviewers who rated Gone with the Wind. */
SELECT DISTINCT(REVIEWER.name)
FROM REVIEWER, RATING, MOVIE
WHERE
MOVIE.mID = RATING.mID
AND
RATING.rID = REVIEWER.rID
AND
MOVIE.mID = "101";

/* For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. */
SELECT DISTINCT(REVIEWER.name), MOVIE.title, RATING.stars
FROM REVIEWER, RATING, MOVIE
WHERE
MOVIE.mID = RATING.mID
AND
RATING.rID = REVIEWER.rID
AND
MOVIE.director = REVIEWER.name;

/* Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) */
SELECT REVIEWER.name
FROM REVIEWER
UNION
SELECT MOVIE.title
FROM MOVIE
ORDER BY REVIEWER.name;

/* Find the titles of all movies not reviewed by Chris Jackson. */
SELECT title
FROM MOVIE
WHERE mID NOT IN
(SELECT mID FROM RATING
INNER JOIN REVIEWER USING (rID)
WHERE name = "Chris Jackson");

/* For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. */
SELECT DISTINCT Rev1.name, Rev2.name
FROM REVIEWER Rev1, REVIEWER Rev2, RATING R1, Rating R2
WHERE R1.mID = R2.mID
AND R1.rID = Rev1.rID
AND R2.rID = Rev2.rID
AND Rev1.name < Rev2.name
ORDER BY Rev1.name, Rev2.name;

/* For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. */
SELECT name, title, stars
FROM MOVIE
INNER JOIN RATING USING (mID)
INNER JOIN REVIEWER USING (rID)
WHERE stars =  (SELECT MIN(stars) FROM RATING);

/* List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. */
SELECT title, AVG(stars)
FROM MOVIE
INNER JOIN RATING USING (mID)
GROUP BY title
ORDER BY AVG(stars) DESC;

/* Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) */
SELECT DISTINCT name
FROM REVIEWER
WHERE (SELECT COUNT(*) FROM RATING WHERE RATING.rID = REVIEWER.rID) >=3;

/* Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) */
SELECT title, director
FROM MOVIE M1
WHERE (SELECT COUNT(*) FROM MOVIE M2 WHERE M1.director = M2.director)  > 1
ORDER BY director, title;

/*Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) */
SELECT title, AVG(stars) AS average
FROM Movie
INNER JOIN Rating USING(mId)
GROUP BY mId
HAVING average = (
  SELECT MAX(average_stars)
  FROM (
    SELECT title, AVG(stars) AS average_stars
    FROM Movie
    INNER JOIN Rating USING(mId)
    GROUP BY mId
  )
);

/* Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) 
*/
SELECT title, AVG(stars) AS average
FROM Movie
INNER JOIN Rating USING(mId)
GROUP BY mId
HAVING average = (
  SELECT MIN(average_stars)
  FROM (
    SELECT title, AVG(stars) AS average_stars
    FROM Movie
    INNER JOIN Rating USING(mId)
    GROUP BY mId
  )
);

/* For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL. */
SELECT director, title, MAX(stars)
FROM Movie
INNER JOIN Rating USING(mId)
WHERE director IS NOT NULL
GROUP BY director;
