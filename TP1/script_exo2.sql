-- Question 1 : Afficher la structure de la relation section et son contenu --
DESC section;
SELECT * FROM section;

-- Question 2 : Afficher tous les renseignements sur les cours que l'on peut programmer --
SELECT * FROM course;

-- Question 3 : Afficher les titres des cours et les départements qui les proposent --
SELECT title, dept_name FROM course;

-- Question 4 : Afficher les noms des départements ainsi que leur budget --
SELECT dept_name, budget FROM department;

-- Question 5 : Afficher tous les noms des enseignants et leur département --
SELECT name, dept_name FROM teacher;

-- Question 6 : Afficher tous les noms des enseignants ayant un salaire supérieur strictement à 65.000 $ --
SELECT name FROM teacher WHERE salary > 65000;

-- Question 7 : Afficher les noms des enseignants ayant un salaire compris entre 55.000 $ et 85.000 $ --
SELECT name FROM teacher WHERE salary BETWEEN 55000 AND 85000;

-- Question 8 : Afficher les noms des départements, en utilisant la relation teacher et éliminer les doublons --
SELECT DISTINCT dept_name FROM teacher;

-- Question 9 : Afficher tous les noms des enseignants du département informatique ayant un salaire supérieur strictement à 65.000 $ --
SELECT name FROM teacher WHERE salary > 65000 AND dept_name = 'Comp. Sci.';

-- Question 10 : Afficher tous les renseignements sur les cours proposés au printemps 2010 --
SELECT * FROM section WHERE semester = 'Spring' AND year = 2010;

-- Question 11 : Afficher tous les titres des cours dispensés par le département informatique qui ont plus de trois crédits --
SELECT title FROM course WHERE dept_name = 'Comp. Sci.' AND credits > 3;

-- Question 12 : Afficher tous les noms des enseignants ainsi que le nom de leur département et les noms des bâtiments qui les hébergent --
SELECT teacher.name, teacher.dept_name, department.building 
FROM teacher, department 
WHERE teacher.dept_name = department.dept_name;

-- Question 13 : Afficher tous les étudiants ayant suivi au moins un cours en informatique --
SELECT DISTINCT student.name 
FROM student, takes, course 
WHERE student.ID = takes.ID 
  AND takes.course_id = course.course_id 
  AND course.dept_name = 'Comp. Sci.';

-- Question 14 : Afficher les noms des étudiants ayant suivi un cours dispensé par un enseignant nommé Einstein --
SELECT DISTINCT student.name 
FROM student, teacher, takes, teaches 
WHERE student.ID = takes.ID 
  AND takes.course_id = teaches.course_id 
  AND takes.sec_id = teaches.sec_id 
  AND takes.semester = teaches.semester 
  AND takes.year = teaches.year 
  AND teaches.ID = teacher.ID 
  AND teacher.name = 'Einstein';

-- Question 15 : Afficher tous les identifiants des cours et les enseignants qui les ont assurés --
SELECT teacher.name, teaches.course_id 
FROM teacher, teaches 
WHERE teacher.ID = teaches.ID;

-- Question 16 : Afficher le nombre d'inscrits pour chaque enseignement proposé au printemps 2010 --
SELECT takes.course_id, takes.sec_id, takes.semester, takes.year, count(*) 
FROM takes 
WHERE takes.semester = 'Spring' AND takes.year = 2010 
GROUP BY takes.course_id, takes.sec_id, takes.semester, takes.year;

-- Question 17 : Afficher les noms des départements et les salaires maximum de leurs enseignants --
SELECT dept_name, max(salary) 
FROM teacher 
GROUP BY dept_name;

-- Question 18 : Afficher le nombre d'inscrits pour chaque enseignement proposé --
SELECT takes.course_id, takes.sec_id, takes.semester, takes.year, count(*) 
FROM takes 
GROUP BY takes.course_id, takes.sec_id, takes.semester, takes.year;

-- Question 19 : Afficher le nombre total de cours qui ont eu lieu dans chaque bâtiment, pendant l'automne 2009 et le printemps 2010 --
SELECT building, count(*) 
FROM section 
WHERE (semester, year) IN (('Fall', 2009), ('Spring', 2010)) 
GROUP BY building;

-- Question 20 : Afficher le nombre total de cours dispensés par chaque département et qui ont eu lieu dans le même bâtiment qui l'abrite --
SELECT department.dept_name, count(*) 
FROM section, department, teacher, teaches 
WHERE (section.course_id, section.sec_id, section.semester, section.year) = (teaches.course_id, teaches.sec_id, teaches.semester, teaches.year) 
  AND teaches.ID = teacher.ID 
  AND teacher.dept_name = department.dept_name 
  AND department.building = section.building 
GROUP BY department.dept_name;

-- Question 21 : Afficher les titres des cours proposés et qui ont eu lieu et les enseignants qui les ont assurés --
SELECT course.title, teacher.name 
FROM section, teacher, teaches, course 
WHERE (section.course_id, section.sec_id, section.semester, section.year) = (teaches.course_id, teaches.sec_id, teaches.semester, teaches.year) 
  AND teaches.ID = teacher.ID 
  AND section.course_id = course.course_id 
ORDER BY course.title;

-- Question 22 : Afficher le nombre total de cours qui ont eu lieu pour chacune des période Summer, Fall et Spring --
SELECT semester, count(*) 
FROM section 
GROUP BY semester;

-- Question 23 : Afficher pour chaque étudiant le nombre total de crédits qu'il a obtenu, en suivant des cours qui n'ont pas été proposé par son département --
SELECT student.name, sum(course.credits) 
FROM student, course, takes 
WHERE student.ID = takes.ID 
  AND takes.course_id = course.course_id 
  AND student.dept_name != course.dept_name 
GROUP BY student.name;

-- Question 24 : Pour chaque département, afficher le nombre total de crédits des cours qui ont eu lieu dans ce département --
SELECT section.building, sum(course.credits) 
FROM section, course 
WHERE section.course_id = course.course_id 
GROUP BY section.building;