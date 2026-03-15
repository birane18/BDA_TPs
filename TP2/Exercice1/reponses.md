# TP2

## Exercice 1 : Requêtes SQL

Cet exercice consiste à écrire différentes requêtes SQL permettant d’interroger une base de données universitaire.

Les requêtes utilisent notamment :

- des fonctions d’agrégation  
- des sous-requêtes  
- la clause `HAVING`  
- des jointures  
- les opérateurs `IN`, `SOME` et `EXISTS`.

---

## Question 1 : Département ayant le budget le plus élevé

```sql
SELECT dept_name
FROM department
WHERE budget = (
    SELECT MAX(budget)
    FROM department
);
```

**Explication :**

La sous-requête calcule le **budget maximal** présent dans la table `department` grâce à la fonction d’agrégation `MAX`.  
La requête principale sélectionne ensuite le **département dont le budget correspond à cette valeur maximale**.

---

## Question 2 : Enseignants gagnant plus que le salaire moyen

```sql
SELECT name, salary
FROM instructor
WHERE salary > (
    SELECT AVG(salary)
    FROM instructor
);
```

**Explication :**

La fonction `AVG` permet de calculer le **salaire moyen des enseignants**.  
La requête principale sélectionne ensuite les enseignants dont le **salaire est supérieur à cette moyenne**.

---

## Question 3 : Étudiants ayant suivi plus de deux cours avec un enseignant

```sql
SELECT i.name, t.ID, COUNT(*) AS nombre_cours
FROM instructor i
JOIN teaches te ON i.ID = te.ID
JOIN takes t ON te.course_id = t.course_id
GROUP BY i.name, t.ID
HAVING COUNT(*) > 2;
```

**Explication :**

Cette requête effectue une **jointure entre les tables `instructor`, `teaches` et `takes`** afin de relier les enseignants aux étudiants.

- `GROUP BY` regroupe les résultats par **enseignant et étudiant**
- `COUNT(*)` calcule le **nombre de cours suivis**
- `HAVING COUNT(*) > 2` conserve uniquement les groupes ayant **plus de deux cours**

---

## Question 4 : Même requête sans utiliser HAVING

```sql
SELECT name, ID, nombre_cours
FROM (
    SELECT i.name, t.ID, COUNT(*) AS nombre_cours
    FROM instructor i
    JOIN teaches te ON i.ID = te.ID
    JOIN takes t ON te.course_id = t.course_id
    GROUP BY i.name, t.ID
) temp
WHERE nombre_cours > 2;
```

**Explication :**

Une **sous-requête** calcule d’abord le nombre de cours suivis par étudiant avec chaque enseignant.

La requête externe applique ensuite une **condition de filtrage (`nombre_cours > 2`)**.

---

## Question 5 : Étudiants n’ayant pas suivi de cours avant 2010

```sql
SELECT ID, name
FROM student
WHERE ID NOT IN (
    SELECT ID
    FROM takes
    WHERE year < 2010
);
```

**Explication :**

La sous-requête sélectionne les **étudiants ayant suivi un cours avant 2010**.

La requête principale utilise `NOT IN` afin de récupérer les étudiants **qui ne figurent pas dans cette liste**.

---

## Question 6 : Enseignants dont le nom commence par E

```sql
SELECT *
FROM instructor
WHERE name LIKE 'E%';
```

**Explication :**

L’opérateur `LIKE` permet de rechercher un **motif dans une chaîne de caractères**.

`'E%'` signifie **toutes les chaînes commençant par la lettre E**.

---

## Question 7 : Enseignant ayant le quatrième salaire le plus élevé

```sql
SELECT name, salary
FROM instructor
ORDER BY salary DESC
OFFSET 3 ROWS FETCH NEXT 1 ROW ONLY;
```

**Explication :**

Les salaires sont **triés par ordre décroissant**.

- `OFFSET 3` ignore les **trois premiers résultats**
- `FETCH NEXT 1` récupère le **quatrième salaire le plus élevé**

---

## Question 8 : Trois enseignants ayant les salaires les plus faibles

```sql
SELECT name, salary
FROM instructor
ORDER BY salary ASC
FETCH FIRST 3 ROWS ONLY;
```

**Explication :**

Les salaires sont triés **par ordre croissant** et on sélectionne les **trois premiers résultats**.

---

## Question 9 : Étudiants ayant suivi un cours en automne 2009 (IN)

```sql
SELECT name
FROM student
WHERE ID IN (
    SELECT ID
    FROM takes
    WHERE semester = 'Fall'
    AND year = 2009
);
```

**Explication :**

La sous-requête retourne les **identifiants des étudiants inscrits à un cours durant le semestre Fall 2009**.

---

## Question 10 : Même requête avec SOME

```sql
SELECT name
FROM student
WHERE ID = SOME (
    SELECT ID
    FROM takes
    WHERE semester = 'Fall'
    AND year = 2009
);
```

**Explication :**

L’opérateur `SOME` vérifie si une valeur correspond **à au moins une valeur retournée par la sous-requête**.

---

## Question 11 : Étudiants ayant suivi un cours en automne 2009 (NATURAL JOIN)

```sql
SELECT name
FROM student
NATURAL JOIN takes
WHERE semester = 'Fall'
AND year = 2009;
```

**Explication :**

La jointure `NATURAL JOIN` relie automatiquement les tables **sur les attributs ayant le même nom**.

---

## Question 12 : Étudiants ayant suivi un cours en automne 2009 (EXISTS)

```sql
SELECT name
FROM student s
WHERE EXISTS (
    SELECT *
    FROM takes t
    WHERE s.ID = t.ID
    AND semester = 'Fall'
    AND year = 2009
);
```

**Explication :**

`EXISTS` vérifie l’existence **d’au moins un enregistrement satisfaisant la condition**.

---

## Question 13 : Paires d’étudiants ayant suivi un cours ensemble

```sql
SELECT DISTINCT t1.ID AS etudiant1, t2.ID AS etudiant2
FROM takes t1
JOIN takes t2
ON t1.course_id = t2.course_id
AND t1.ID <> t2.ID;
```

**Explication :**

Une **auto-jointure sur la table `takes`** permet de trouver les étudiants inscrits dans le **même cours**.

---

## Question 14 : Nombre total d’étudiants par enseignant

```sql
SELECT i.name, COUNT(*) AS nombre_etudiants
FROM instructor i
JOIN teaches te ON i.ID = te.ID
JOIN takes t ON te.course_id = t.course_id
GROUP BY i.name
ORDER BY nombre_etudiants DESC;
```

**Explication :**

On joint les tables `instructor`, `teaches` et `takes`, puis on compte le **nombre total d’étudiants par enseignant**.

---

## Question 15 : Nombre d’étudiants par enseignant (y compris ceux sans cours)

```sql
SELECT i.name, COUNT(t.ID) AS nombre_etudiants
FROM instructor i
LEFT JOIN teaches te ON i.ID = te.ID
LEFT JOIN takes t ON te.course_id = t.course_id
GROUP BY i.name
ORDER BY nombre_etudiants DESC;
```

**Explication :**

La jointure `LEFT JOIN` permet de **conserver tous les enseignants**, même ceux n’ayant jamais donné de cours.

---

## Question 16 : Nombre de notes A attribuées par enseignant

```sql
SELECT i.name, COUNT(*) AS nombre_A
FROM instructor i
JOIN teaches te ON i.ID = te.ID
JOIN takes t ON te.course_id = t.course_id
WHERE t.grade = 'A'
GROUP BY i.name;
```

**Explication :**

La condition `grade = 'A'` filtre uniquement les **notes A**, puis `COUNT` calcule leur nombre par enseignant.

---

## Question 17 : Nombre de cours suivis avec chaque enseignant

```sql
SELECT i.name, t.ID, COUNT(*) AS nombre_cours
FROM instructor i
JOIN teaches te ON i.ID = te.ID
JOIN takes t ON te.course_id = t.course_id
GROUP BY i.name, t.ID;
```

**Explication :**

Cette requête affiche chaque **paire enseignant-étudiant** ainsi que le **nombre de cours suivis ensemble**.

---

## Question 18 : Étudiants ayant suivi au moins deux cours avec un enseignant

```sql
SELECT i.name, t.ID
FROM instructor i
JOIN teaches te ON i.ID = te.ID
JOIN takes t ON te.course_id = t.course_id
GROUP BY i.name, t.ID
HAVING COUNT(*) >= 2;
```

**Explication :**

La clause `HAVING` permet de filtrer les groupes afin de conserver uniquement les **paires enseignant-étudiant ayant suivi au moins deux cours ensemble**.
