# TP 1

## Exercice 1

### Question 1 : Définition de la table `section`

Voici la commande SQL permettant de créer la table `section` avec ses contraintes :

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

Cette table représente une **instance d’un cours** donnée à un semestre et une année précis.  
La clé primaire est composée de `(course_id, sec_id, semester, year)` car un même cours peut être proposé plusieurs fois selon la section et la période.

-

### Question 2 : Explication du diagramme entité-association

Le schéma relationnel représente l’organisation pédagogique d’une université et les relations entre ses différentes entités.

**Les principales entités :**

- `department` : représente les départements de l’université.
- `course` : contient la liste des cours proposés.
- `student` : représente les étudiants.
- `teacher` : représente les enseignants.
- `section` : correspond à une session précise d’un cours (semestre, année, salle).
- `classroom` : représente les salles de cours.
- `time_slot` : correspond aux créneaux horaires.

**Les relations entre ces entités :**

- `takes` : relie les étudiants aux sections qu’ils suivent et peut contenir la note obtenue.
- `teaches` : relie les enseignants aux sections qu’ils enseignent.
- `advisor` : indique quel enseignant est le tuteur d’un étudiant.
- `prereq` : définit les prérequis nécessaires pour suivre un cours.

Ce modèle permet donc de représenter les **cours, les enseignants, les étudiants et leurs interactions**.

---

### Question 3 : Création et peuplement de la base

Les scripts fournis (`universityDB-createschema.sql` et `universityDB-data.sql`) ont été exécutés dans **Oracle APEX**.

Le premier script crée les tables et leurs contraintes, tandis que le second insère les données dans la base.  
L’exécution s’est déroulée correctement et la base a été créée sans erreur.

---

### Question 4 : Insertion d’un nouveau cours

Requête SQL utilisée pour ajouter un cours de biologie :

```sql
INSERT INTO course VALUES ('BIO-101', 'Intro. to Biology', 'Biology', '4');
```

Cette instruction insère un nouveau tuple dans la relation `course`.

---

# Exercice 2 : Requêtes SQL

### Question 1 : Structure et contenu de la relation `section`

```sql
DESC section;
SELECT * FROM section;
```

**Explication :**

- `DESC section` permet d’afficher la **structure de la relation** (colonnes et types).
- `SELECT *` permet d’afficher **tous les tuples** présents dans la table.

---

### Question 2 : Liste des cours disponibles

```sql
SELECT * FROM course;
```

**Explication :**

Cette requête effectue une **sélection complète** de la relation `course`.

---

### Question 3 : Titres des cours et départements

```sql
SELECT title, dept_name FROM course;
```

**Explication :**

On effectue une **projection** sur les attributs `title` et `dept_name` afin d’obtenir le titre des cours et le département qui les propose.

---

### Question 4 : Départements et leur budget

```sql
SELECT dept_name, budget FROM department;
```

**Explication :**

Projection des attributs `dept_name` et `budget` de la relation `department`.

---

### Question 5 : Enseignants et leur département

```sql
SELECT name, dept_name FROM teacher;
```

**Explication :**

On affiche le nom des enseignants ainsi que leur département.

---

### Question 6 : Enseignants ayant un salaire supérieur à 65 000 $

```sql
SELECT name FROM teacher WHERE salary > 65000;
```

**Explication :**

On applique une **sélection** sur la relation `teacher` avec la condition `salary > 65000`.

---

### Question 7 : Enseignants avec un salaire entre 55 000 et 85 000

```sql
SELECT name FROM teacher WHERE salary BETWEEN 55000 AND 85000;
```

**Explication :**

La clause `BETWEEN` permet de sélectionner les enseignants dont le salaire appartient à cet intervalle.

---

### Question 8 : Départements présents dans la table `teacher`

```sql
SELECT DISTINCT dept_name FROM teacher;
```

**Explication :**

`DISTINCT` permet d’éliminer les doublons et d’obtenir chaque département une seule fois.

---

### Question 9 : Enseignants du département informatique avec salaire > 65 000

```sql
SELECT name FROM teacher 
WHERE salary > 65000 AND dept_name = 'Comp. Sci.';
```

**Explication :**

On applique une **sélection avec deux conditions** : le salaire et le département.

---

### Question 10 : Cours proposés au printemps 2010

```sql
SELECT * FROM section 
WHERE semester = 'Spring' AND year = 2010;
```

**Explication :**

Sélection des sections correspondant au semestre Spring de l’année 2010.

---

### Question 11 : Cours d’informatique avec plus de 3 crédits

```sql
SELECT title FROM course 
WHERE dept_name = 'Comp. Sci.' AND credits > 3;
```

**Explication :**

Sélection des cours du département informatique ayant plus de 3 crédits.

---

### Question 12 : Enseignants, département et bâtiment

```sql
SELECT teacher.name, teacher.dept_name, department.building
FROM teacher, department
WHERE teacher.dept_name = department.dept_name;
```

**Explication :**

On réalise une **jointure entre `teacher` et `department`** sur l’attribut `dept_name` afin d’obtenir le bâtiment du département de chaque enseignant.

---

### Question 13 : Étudiants ayant suivi un cours d’informatique

```sql
SELECT DISTINCT student.name
FROM student, takes, course
WHERE student.ID = takes.ID
AND takes.course_id = course.course_id
AND course.dept_name = 'Comp. Sci.';
```

**Explication :**

On effectue une **jointure entre `student`, `takes` et `course`** pour identifier les étudiants ayant suivi au moins un cours du département informatique.

---

### Question 14 : Étudiants ayant eu un cours avec Einstein

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

**Explication :**

On réalise plusieurs **jointures entre `student`, `takes`, `teaches` et `teacher`** afin d’identifier les étudiants ayant suivi une section enseignée par Einstein.

---

### Question 15 : Cours enseignés par chaque professeur

```sql
SELECT teacher.name, teaches.course_id
FROM teacher, teaches
WHERE teacher.ID = teaches.ID;
```

**Explication :**

Jointure entre `teacher` et `teaches` afin d’associer chaque enseignant aux cours qu’il a enseignés.

---

### Question 16 : Nombre d’étudiants par section (Spring 2010)

```sql
SELECT takes.course_id, takes.sec_id, takes.semester, takes.year, count(*)
FROM takes
WHERE takes.semester = 'Spring' AND takes.year = 2010
GROUP BY takes.course_id, takes.sec_id, takes.semester, takes.year;
```

**Explication :**

Après une **sélection sur la période**, on effectue une **agrégation avec `COUNT`** et un `GROUP BY` afin de compter le nombre d’étudiants par section.

---

### Question 17 : Salaire maximum par département

```sql
SELECT dept_name, max(salary)
FROM teacher
GROUP BY dept_name;
```

**Explication :**

On regroupe les enseignants par département puis on applique la fonction d’agrégation `MAX`.

---

### Question 18 : Nombre d’étudiants par section

```sql
SELECT takes.course_id, takes.sec_id, takes.semester, takes.year, count(*)
FROM takes
GROUP BY takes.course_id, takes.sec_id, takes.semester, takes.year;
```

**Explication :**

Agrégation sur les sections pour compter le nombre d’inscrits dans chacune d’elles.

---

### Question 19 : Nombre de cours par bâtiment

```sql
SELECT building, count(*)
FROM section
WHERE (semester, year) IN (('Fall', 2009), ('Spring', 2010))
GROUP BY building;
```

**Explication :**

On filtre les sections correspondant aux périodes demandées puis on compte le nombre de cours par bâtiment.

---

### Question 20 : Cours dispensés dans le bâtiment du département

```sql
SELECT department.dept_name, count(*)
FROM section, department, teacher, teaches
WHERE (section.course_id, section.sec_id, section.semester, section.year) =
(teaches.course_id, teaches.sec_id, teaches.semester, teaches.year)
AND teaches.ID = teacher.ID
AND teacher.dept_name = department.dept_name
AND department.building = section.building
GROUP BY department.dept_name;
```

**Explication :**

On réalise plusieurs **jointures entre `section`, `teaches`, `teacher` et `department`** et on conserve uniquement les cours qui ont lieu dans le bâtiment du département de l’enseignant.

---

### Question 21 : Titres des cours et enseignants

```sql
SELECT course.title, teacher.name
FROM section, teacher, teaches, course
WHERE (section.course_id, section.sec_id, section.semester, section.year) =
(teaches.course_id, teaches.sec_id, teaches.semester, teaches.year)
AND teaches.ID = teacher.ID
AND section.course_id = course.course_id
ORDER BY course.title;
```

**Explication :**

Jointure entre plusieurs relations afin d’obtenir le titre des cours et le nom des enseignants, puis tri avec `ORDER BY`.

---

### Question 22 : Nombre de cours par semestre

```sql
SELECT semester, count(*)
FROM section
GROUP BY semester;
```

**Explication :**

On regroupe les sections par semestre et on compte le nombre de cours pour chaque période.

---

### Question 23 : Crédits obtenus hors département

```sql
SELECT student.name, sum(course.credits)
FROM student, course, takes
WHERE student.ID = takes.ID
AND takes.course_id = course.course_id
AND student.dept_name != course.dept_name
GROUP BY student.name;
```

**Explication :**

Jointure entre `student`, `takes` et `course`.  
On garde uniquement les cours suivis **en dehors du département de l’étudiant** puis on calcule la somme des crédits.

---

### Question 24 : Total des crédits par bâtiment

```sql
SELECT section.building, sum(course.credits)
FROM section, course
WHERE section.course_id = course.course_id
GROUP BY section.building;
```

**Explication :**

Jointure entre `section` et `course` pour récupérer les crédits des cours, puis agrégation avec `SUM` afin d’obtenir le total par bâtiment.
