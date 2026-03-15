-- Question 1
SELECT dept_name
FROM department
WHERE budget = (
    SELECT MAX(budget)
    FROM department
);

-- Question 2
SELECT name, salary
FROM instructor
WHERE salary > (
    SELECT AVG(salary)
    FROM instructor
);

-- Question 3
SELECT i.name, t.ID, COUNT(*) AS nb_cours
FROM instructor i
JOIN teaches te ON i.ID = te.ID
JOIN takes t ON te.course_id = t.course_id
GROUP BY i.name, t.ID
HAVING COUNT(*) > 2;

-- Question 4
SELECT name, ID, nb_cours
FROM (
    SELECT i.name, t.ID, COUNT(*) nb_cours
    FROM instructor i
    JOIN teaches te ON i.ID = te.ID
    JOIN takes t ON te.course_id = t.course_id
    GROUP BY i.name, t.ID
) temp
WHERE nb_cours > 2;

-- Question 5
SELECT ID, name
FROM student
WHERE ID NOT IN (
    SELECT ID
    FROM takes
    WHERE year < 2010
);

-- Question 6
SELECT *
FROM instructor
WHERE name LIKE 'E%';

-- Question 7
SELECT name, salary
FROM instructor
ORDER BY salary DESC
OFFSET 3 ROWS FETCH NEXT 1 ROW ONLY;

-- Question 8
SELECT name, salary
FROM instructor
ORDER BY salary ASC
FETCH FIRST 3 ROWS ONLY;

-- Question 9
SELECT name
FROM student
WHERE ID IN (
    SELECT ID
    FROM takes
    WHERE semester='Fall' AND year=2009
);

-- Question 10
SELECT name
FROM student
WHERE ID = SOME (
    SELECT ID
    FROM takes
    WHERE semester='Fall' AND year=2009
);

-- Question 11
SELECT name
FROM student
NATURAL JOIN takes
WHERE semester='Fall' AND year=2009;

-- Question 12
SELECT name
FROM student s
WHERE EXISTS (
    SELECT *
    FROM takes t
    WHERE s.ID = t.ID
    AND semester='Fall'
    AND year=2009
);

-- Question 13
SELECT DISTINCT t1.ID, t2.ID
FROM takes t1
JOIN takes t2
ON t1.course_id = t2.course_id
AND t1.ID <> t2.ID;

-- Question 14
SELECT i.name, COUNT(*) AS nb_students
FROM instructor i
JOIN teaches te ON i.ID = te.ID
JOIN takes t ON te.course_id = t.course_id
GROUP BY i.name
ORDER BY nb_students DESC;

-- Question 15
SELECT i.name, COUNT(t.ID)
FROM instructor i
LEFT JOIN teaches te ON i.ID = te.ID
LEFT JOIN takes t ON te.course_id = t.course_id
GROUP BY i.name
ORDER BY COUNT(t.ID) DESC;

-- Question 16
SELECT i.name, COUNT(*) AS nb_A
FROM instructor i
JOIN teaches te ON i.ID = te.ID
JOIN takes t ON te.course_id = t.course_id
WHERE t.grade='A'
GROUP BY i.name;

-- Question 17
SELECT i.name, t.ID, COUNT(*) nb
FROM instructor i
JOIN teaches te ON i.ID = te.ID
JOIN takes t ON te.course_id = t.course_id
GROUP BY i.name, t.ID;

-- Question 18
SELECT i.name, t.ID
FROM instructor i
JOIN teaches te ON i.ID = te.ID
JOIN takes t ON te.course_id = t.course_id
GROUP BY i.name, t.ID
HAVING COUNT(*) >= 2;
