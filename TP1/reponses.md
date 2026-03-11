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

* **Les Entités (les objets principaux) :**
  * **`department`** : Les départements de l'université.
  * **`course`** : Le catalogue des matières proposées.
  * **`student`** et **`instructor` (ou `teacher`)** : Les étudiants et les professeurs.
  * **`section`** : Représente la programmation physique d'un cours (un cours donné lors d'un semestre précis, une année précise, dans une salle spécifique).
  * **`classroom`** et **`time_slot`** : Les salles physiques et les créneaux horaires.

* **Les Associations (les liens entre les objets) :**
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
