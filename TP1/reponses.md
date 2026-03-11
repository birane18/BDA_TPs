# TP 1 : 

## Exercice 1 : 

### Question 1 : Définition de la table `section`

Voici la commande SQL pour définir la table `section` avec ses contraintes :

```sql
CREATE TABLE section(
    course_id varchar(8),
    sec_id varchar(8),
    semester varchar(6) check (semester in ('Fall', 'Winter', 'Spring', 'Summer')),
    year numeric(4,0),
    building varchar(15),
    room_number varchar(7),
    time_slot_id varchar(4),
    primary key (course_id, sec_id, semester, year),
    foreign key (course_id) references course,
    foreign key (building, room_number) references classroom
);
```

### Question 2 : Explication du diagramme entité-association

Le schéma relationnel fourni modélise l'organisation et la gestion pédagogique d'une université. Voici l'explication de sa structure :

* **Les Entités:**
  * **`department`** : Les départements de l'université.
  * **`course`** : Le catalogue des matières proposées.
  * **`student`** et **`teacher`** : Les étudiants et les professeurs.
  * **`section`** : Représente la programmation physique d'un cours (un cours donné lors d'un semestre précis, une année précise, dans une salle spécifique).
  * **`classroom`** et **`time_slot`** : Les salles physiques et les créneaux horaires.

* **Les Associations:**
  * **`takes`** : Relie un étudiant à une section (permet de savoir quel étudiant a suivi quelle classe et sa note).
  * **`teaches`** : Relie un professeur à une section (permet de savoir qui enseigne quoi et quand).
  * **`advisor`** : Un professeur qui joue le rôle de tuteur pour un étudiant.
  * **`prereq`** : Les prérequis pour pouvoir s'inscrire à un cours (ex: il faut avoir validé le cours A pour faire le cours B).

### Question 3 : Création et peuplement de la base

Les scripts fournis (`universityDB-createschema.sql` et `universityDB-data.sql`) ont été importés et exécutés directement dans l'environnement **Oracle APEX**. La création des tables et l'insertion des données se sont déroulées avec succès.

### Question 4 : Insertion d'un nouveau cours

Voici la requête SQL utilisée pour insérer le nouveau cours de Biologie demandé :

```sql
INSERT INTO course VALUES ('BIO-101', 'Intro. to Biology', 'Biology', '4');
```

## Exercice 2 : Requêtes SQL d'interrogation de la base

### Question 1 : Structure et contenu de la relation section
```sql
DESC section;
SELECT * FROM section;
```
**Explication :** La commande `DESC` permet d'inspecter le schéma de la table (colonnes, types, contraintes). Le `SELECT *` affiche ensuite l'ensemble des tuples stockés dans la relation.

### Question 2 : Renseignements sur les cours que l'on peut programmer
```sql
SELECT * FROM course;
```
**Explication :** Sélection de l'ensemble des enregistrements de la relation `course`.

### Question 3 : Titres des cours et départements qui les proposent
```sql
SELECT title, dept_name FROM course;
```
**Explication :** Projection sur les attributs `title` et `dept_name` pour isoler les intitulés et leurs départements respectifs.

### Question 4 : Noms des départements et leur budget
```sql
SELECT dept_name, budget FROM department;
```
**Explication :** Projection limitant l'affichage aux départements et à leurs budgets.

### Question 5 : Noms des enseignants et leur département
```sql
SELECT name, dept_name FROM teacher;
```
**Explication :** Projection sur la table `teacher` pour lister les enseignants avec leur rattachement administratif.

### Question 6 : Enseignants ayant un salaire strictement supérieur à 65.000 $
```sql
SELECT name FROM teacher WHERE salary > 65000;
```
**Explication :** Restriction sur la table `teacher` conditionnée par un salaire strictement supérieur à 65 000 $.

### Question 7 : Enseignants ayant un salaire compris entre 55.000 $ et 85.000 $
```sql
SELECT name FROM teacher WHERE salary BETWEEN 55000 AND 85000;
```
**Explication :** Filtrage sur un intervalle de valeurs pour le salaire via l'opérateur inclusif `BETWEEN`.

### Question 8 : Départements utilisant la relation teacher (sans doublons)
```sql
SELECT DISTINCT dept_name FROM teacher;
```
**Explication :** La clause `DISTINCT` élimine les doublons dans les résultats, ce qui est nécessaire ici pour obtenir l'ensemble unique des départements puisqu'un département héberge généralement plusieurs enseignants.

### Question 9 : Enseignants du département informatique avec salaire > 65.000 $
```sql
SELECT name FROM teacher WHERE salary > 65000 AND dept_name = 'Comp. Sci.';
```
**Explication :** Application de deux critères de sélection conjonctifs (salaire et département).

### Question 10 : Cours proposés au printemps 2010
```sql
SELECT * FROM section WHERE semester = 'Spring' AND year = 2010;
```
**Explication :** Filtrage temporel sur la table `section` pour extraire les tuples d'une session académique précise.

### Question 11 : Cours d'informatique de plus de 3 crédits
```sql
SELECT title FROM course WHERE dept_name = 'Comp. Sci.' AND credits > 3;
```
**Explication :** Sélection croisant un critère qualitatif d'appartenance à un département et un critère quantitatif sur le nombre de crédits.

### Question 12 : Enseignants, départements et bâtiments associés
```sql
SELECT teacher.name, teacher.dept_name, department.building 
FROM teacher, department 
WHERE teacher.dept_name = department.dept_name;
```
**Explication :** Jointure interne (équijointure) entre `teacher` et `department` via la clé `dept_name` pour récupérer le nom du bâtiment associé au département de chaque enseignant.

### Question 13 : Étudiants ayant suivi au moins un cours en informatique
```sql
SELECT DISTINCT student.name 
FROM student, takes, course 
WHERE student.ID = takes.ID 
  AND takes.course_id = course.course_id 
  AND course.dept_name = 'Comp. Sci.';
```
**Explication :** Double jointure (`student` -> `takes` -> `course`) pour lier l'étudiant aux départements de ses cours suivis. L'utilisation de `DISTINCT` prévient les doublons si un étudiant a suivi plusieurs cours différents en informatique.

### Question 14 : Étudiants ayant suivi un cours avec Einstein
```sql
SELECT DISTINCT student.name 
FROM student, teacher, takes, teaches 
WHERE student.ID = takes.ID 
  AND takes.course_id = teaches.course_id 
  AND takes.sec_id = teaches.sec_id 
  AND takes.semester = teaches.semester 
  AND takes.year = teaches.year 
  AND teaches.ID = teacher.ID 
  AND teacher.name = 'Einstein';
```
**Explication :** Jointure complexe entre 4 relations. La liaison entre les tables `takes` (cours suivis) et `teaches` (cours dispensés) nécessite une égalité stricte sur les 4 attributs composant la clé primaire composite de l'instance de cours (`course_id`, `sec_id`, `semester`, `year`).

### Question 15 : Identifiants des cours et enseignants les ayant assurés
```sql
SELECT teacher.name, teaches.course_id 
FROM teacher, teaches 
WHERE teacher.ID = teaches.ID;
```
**Explication :** Jointure entre l'entité `teacher` et la relation `teaches` pour associer l'identifiant des cours aux noms des enseignants correspondants.

### Question 16 : Nombre d'inscrits par enseignement au printemps 2010
```sql
SELECT takes.course_id, takes.sec_id, takes.semester, takes.year, count(*) 
FROM takes 
WHERE takes.semester = 'Spring' AND takes.year = 2010 
GROUP BY takes.course_id, takes.sec_id, takes.semester, takes.year;
```
**Explication :** Après filtrage temporel (`WHERE`), la requête effectue un partitionnement (`GROUP BY`) sur la clé composite de la section. La fonction d'agrégation `COUNT(*)` calcule la cardinalité de chaque groupe pour obtenir le nombre d'inscrits exact par cours.

### Question 17 : Salaires maximum par département
```sql
SELECT dept_name, max(salary) 
FROM teacher 
GROUP BY dept_name;
```
**Explication :** Regroupement des enseignants par département pour appliquer la fonction d'agrégation `MAX()` sur la colonne des salaires.

### Question 18 : Nombre d'inscrits pour chaque enseignement
```sql
SELECT takes.course_id, takes.sec_id, takes.semester, takes.year, count(*) 
FROM takes 
GROUP BY takes.course_id, takes.sec_id, takes.semester, takes.year;
```
**Explication :** Même logique d'agrégation que la question 16, mais appliquée sans restriction préalable afin de calculer le total d'inscrits pour toutes les sessions historiques de la base.

### Question 19 : Total de cours par bâtiment (Automne 2009 et Printemps 2010)
```sql
SELECT building, count(*) 
FROM section 
WHERE (semester, year) IN (('Fall', 2009), ('Spring', 2010)) 
GROUP BY building;
```
**Explication :** Le prédicat `IN` filtre les tuples sur un ensemble de paires `(semester, year)`. Le jeu de résultats est ensuite regroupé par attribut spatial (`building`) pour en compter les occurrences.

### Question 20 : Cours dispensés dans le bâtiment propre au département
```sql
SELECT department.dept_name, count(*) 
FROM section, department, teacher, teaches 
WHERE (section.course_id, section.sec_id, section.semester, section.year) = (teaches.course_id, teaches.sec_id, teaches.semester, teaches.year) 
  AND teaches.ID = teacher.ID 
  AND teacher.dept_name = department.dept_name 
  AND department.building = section.building 
GROUP BY department.dept_name;
```
**Explication :** Outre les jointures reliant la section au département de l'enseignant, on ajoute une condition sémantique métier forte (`department.building = section.building`) avant d'agréger et de compter le tout par département.

### Question 21 : Titres des cours, enseignants correspondants avec tri
```sql
SELECT course.title, teacher.name 
FROM section, teacher, teaches, course 
WHERE (section.course_id, section.sec_id, section.semester, section.year) = (teaches.course_id, teaches.sec_id, teaches.semester, teaches.year) 
  AND teaches.ID = teacher.ID 
  AND section.course_id = course.course_id 
ORDER BY course.title;
```
**Explication :** Jointures multiples pour substituer les clés étrangères par leurs libellés explicites (`title`, `name`), suivies d'un tri lexical ascendant (`ORDER BY`) sur le titre du cours.

### Question 22 : Total de cours par période académique
```sql
SELECT semester, count(*) 
FROM section 
GROUP BY semester;
```
**Explication :** Regroupement simple sur l'axe des périodes académiques (`semester`) couplé au comptage des instances de cours planifiées.

### Question 23 : Crédits obtenus par étudiant hors de son département
```sql
SELECT student.name, sum(course.credits) 
FROM student, course, takes 
WHERE student.ID = takes.ID 
  AND takes.course_id = course.course_id 
  AND student.dept_name != course.dept_name 
GROUP BY student.name;
```
**Explication :** Après les jointures nécessaires, l'opérateur d'inégalité (`!=`) permet d'isoler les cours suivis en dehors du département de tutelle de l'étudiant. La fonction `SUM()` calcule ensuite le total des crédits par étudiant (via le `GROUP BY`).

### Question 24 : Total des crédits de cours par bâtiment
```sql
SELECT section.building, sum(course.credits) 
FROM section, course 
WHERE section.course_id = course.course_id 
GROUP BY section.building;
```
**Explication :** Jointure entre `section` et `course` pour récupérer le poids en crédits de chaque cours planifié, suivie d'une agrégation spatiale par bâtiment avec calcul de la somme des crédits concernés.
