# Exercice 1 – Requêtes SQL

Cet exercice consiste à écrire différentes requêtes SQL permettant
d’interroger une base de données universitaire.

Les requêtes utilisent notamment :

- des fonctions d’agrégation
- des sous-requêtes
- la clause HAVING
- des jointures
- les opérateurs IN, SOME et EXISTS.

Les requêtes SQL complètes sont disponibles dans le fichier `requetes.sql`.

Chaque requête répond à l’une des questions de l’énoncé.




/*
--------------------------------------------------------
Question 1
Afficher le nom du département qui possède le budget
le plus élevé.


On utilise une sous-requête pour calculer le budget
maximal dans la table department. Ensuite, on sélectionne
le département dont le budget correspond à cette valeur.
--------------------------------------------------------
*/

SELECT dept_name
FROM department
WHERE budget = (
    SELECT MAX(budget)
    FROM department
);


/*
--------------------------------------------------------
Question 2
Afficher les noms et les salaires des enseignants qui
gagnent plus que le salaire moyen.


La fonction AVG permet de calculer le salaire moyen
des enseignants. On compare ensuite chaque salaire
à cette valeur moyenne.
--------------------------------------------------------
*/

SELECT name, salary
FROM instructor
WHERE salary > (
    SELECT AVG(salary)
    FROM instructor
);


/*
--------------------------------------------------------
Question 3
Pour chaque enseignant, afficher les étudiants qui ont
suivi plus de deux cours dispensés par cet enseignant.


Nous effectuons une jointure entre les tables instructor,
teaches et takes afin de relier les enseignants aux
étudiants. La clause GROUP BY permet de regrouper les
résultats par enseignant et par étudiant.

La clause HAVING permet ensuite de conserver uniquement
les groupes ayant un nombre de cours supérieur à deux.
--------------------------------------------------------
*/

SELECT i.name, t.ID, COUNT(*) AS nombre_cours
FROM instructor i
JOIN teaches te ON i.ID = te.ID
JOIN takes t ON te.course_id = t.course_id
GROUP BY i.name, t.ID
HAVING COUNT(*) > 2;


/*
--------------------------------------------------------
Question 4
Même question que précédemment mais sans utiliser
la clause HAVING.


On calcule d'abord le nombre de cours suivis dans
une sous-requête, puis on applique la condition dans
la requête externe.
--------------------------------------------------------
*/

SELECT name, ID, nombre_cours
FROM (
    SELECT i.name, t.ID, COUNT(*) AS nombre_cours
    FROM instructor i
    JOIN teaches te ON i.ID = te.ID
    JOIN takes t ON te.course_id = t.course_id
    GROUP BY i.name, t.ID
) temp
WHERE nombre_cours > 2;


/*
--------------------------------------------------------
Question 5
Afficher les identifiants et les noms des étudiants
qui n'ont pas suivi de cours avant 2010.


On sélectionne les étudiants dont l'identifiant
n'apparaît pas dans la liste des étudiants ayant
suivi un cours avant 2010.
--------------------------------------------------------
*/

SELECT ID, name
FROM student
WHERE ID NOT IN (
    SELECT ID
    FROM takes
    WHERE year < 2010
);


/*
--------------------------------------------------------
Question 6
Afficher tous les enseignants dont le nom commence
par la lettre E.


L'opérateur LIKE permet de rechercher un motif dans
une chaîne de caractères. Le symbole % représente
une suite quelconque de caractères.
--------------------------------------------------------
*/

SELECT *
FROM instructor
WHERE name LIKE 'E%';


/*
--------------------------------------------------------
Question 7
Afficher les noms et les salaires des enseignants
qui possèdent le quatrième salaire le plus élevé.


Les salaires sont triés par ordre décroissant.
On ignore les trois premiers résultats puis
on sélectionne le suivant.
--------------------------------------------------------
*/

SELECT name, salary
FROM instructor
ORDER BY salary DESC
OFFSET 3 ROWS FETCH NEXT 1 ROW ONLY;


/*
--------------------------------------------------------
Question 8
Afficher les noms et salaires des trois enseignants
ayant les salaires les plus faibles.


On trie les salaires par ordre croissant et on
sélectionne les trois premiers résultats.
--------------------------------------------------------
*/

SELECT name, salary
FROM instructor
ORDER BY salary ASC
FETCH FIRST 3 ROWS ONLY;


/*
--------------------------------------------------------
Question 9
Afficher les noms des étudiants ayant suivi un cours
en automne 2009 en utilisant la clause IN.


La sous-requête retourne les identifiants des
étudiants inscrits à un cours durant le semestre
d'automne 2009.
--------------------------------------------------------
*/

SELECT name
FROM student
WHERE ID IN (
    SELECT ID
    FROM takes
    WHERE semester = 'Fall'
    AND year = 2009
);


/*
--------------------------------------------------------
Question 10
Même requête que précédemment mais en utilisant
l'opérateur SOME.


L'opérateur SOME vérifie si une valeur correspond
à au moins une des valeurs retournées par la
sous-requête.
--------------------------------------------------------
*/

SELECT name
FROM student
WHERE ID = SOME (
    SELECT ID
    FROM takes
    WHERE semester = 'Fall'
    AND year = 2009
);


/*
--------------------------------------------------------
Question 11
Afficher les noms des étudiants ayant suivi un cours
en automne 2009 en utilisant une jointure naturelle.


La jointure NATURAL JOIN relie automatiquement les
tables en utilisant les attributs ayant le même nom.
--------------------------------------------------------
*/

SELECT name
FROM student
NATURAL JOIN takes
WHERE semester = 'Fall'
AND year = 2009;


/*
--------------------------------------------------------
Question 12
Afficher les noms des étudiants ayant suivi un cours
en automne 2009 en utilisant EXISTS.


EXISTS permet de vérifier l'existence d'au moins
un enregistrement satisfaisant la condition.
--------------------------------------------------------
*/

SELECT name
FROM student s
WHERE EXISTS (
    SELECT *
    FROM takes t
    WHERE s.ID = t.ID
    AND semester = 'Fall'
    AND year = 2009
);


/*
--------------------------------------------------------
Question 13
Afficher toutes les paires d'étudiants ayant suivi
au moins un cours ensemble.


On réalise une auto-jointure sur la table takes afin
de trouver les étudiants inscrits dans le même cours.
--------------------------------------------------------
*/

SELECT DISTINCT t1.ID AS etudiant1, t2.ID AS etudiant2
FROM takes t1
JOIN takes t2
ON t1.course_id = t2.course_id
AND t1.ID <> t2.ID;


/*
--------------------------------------------------------
Question 14
Afficher pour chaque enseignant ayant donné un cours
le nombre total d'étudiants ayant suivi ses cours.


On effectue des jointures entre instructor,
teaches et takes puis on compte le nombre
d'étudiants.
--------------------------------------------------------
*/

SELECT i.name, COUNT(*) AS nombre_etudiants
FROM instructor i
JOIN teaches te ON i.ID = te.ID
JOIN takes t ON te.course_id = t.course_id
GROUP BY i.name
ORDER BY nombre_etudiants DESC;


/*
--------------------------------------------------------
Question 15
Même requête mais en incluant les enseignants
n'ayant jamais donné de cours.


Une jointure LEFT JOIN permet de conserver tous
les enseignants même s'ils ne sont associés à
aucun cours.
--------------------------------------------------------
*/

SELECT i.name, COUNT(t.ID) AS nombre_etudiants
FROM instructor i
LEFT JOIN teaches te ON i.ID = te.ID
LEFT JOIN takes t ON te.course_id = t.course_id
GROUP BY i.name
ORDER BY nombre_etudiants DESC;


/*
--------------------------------------------------------
Question 16
Afficher pour chaque enseignant le nombre de
notes A attribuées.

On filtre les résultats sur les notes égales
à 'A'.
--------------------------------------------------------
*/

SELECT i.name, COUNT(*) AS nombre_A
FROM instructor i
JOIN teaches te ON i.ID = te.ID
JOIN takes t ON te.course_id = t.course_id
WHERE t.grade = 'A'
GROUP BY i.name;


/*
--------------------------------------------------------
Question 17
Afficher toutes les paires enseignant–étudiant
ainsi que le nombre de fois où cet étudiant
a suivi un cours avec cet enseignant.
--------------------------------------------------------
*/

SELECT i.name, t.ID, COUNT(*) AS nombre_cours
FROM instructor i
JOIN teaches te ON i.ID = te.ID
JOIN takes t ON te.course_id = t.course_id
GROUP BY i.name, t.ID;


/*
--------------------------------------------------------
Question 18
Afficher les paires enseignant–étudiant pour
lesquelles l'étudiant a suivi au moins deux
cours avec le même enseignant.
--------------------------------------------------------
*/

SELECT i.name, t.ID
FROM instructor i
JOIN teaches te ON i.ID = te.ID
JOIN takes t ON te.course_id = t.course_id
GROUP BY i.name, t.ID
HAVING COUNT(*) >= 2;
