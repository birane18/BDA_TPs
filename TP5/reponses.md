# TP n°5 : Transactions et contrôle de concurrence

 Exercice 1 — Atomicité d'une transaction

Ouverture de deux sessions S1 et S2. Dans chaque session :
```sql
SET AUTOCOMMIT OFF
```


Question 1 — Création de la table (session S1)
```sql
CREATE TABLE transaction (
    idTransaction  VARCHAR2(44),
    valTransaction NUMBER(10)
);
```


Question 2 — Insertions, modification, suppression puis ROLLBACK (session S2)
```sql
INSERT INTO transaction VALUES ('T1', 100);
INSERT INTO transaction VALUES ('T2', 200);
INSERT INTO transaction VALUES ('T3', 300);

UPDATE transaction SET valTransaction = 999 WHERE idTransaction = 'T1';
DELETE FROM transaction WHERE idTransaction = 'T2';

ROLLBACK;

SELECT * FROM transaction;
```

<img width="729" height="873" alt="1" src="https://github.com/user-attachments/assets/d418a481-ad95-4c94-8d3a-3e5e9ad8d6c0" />



La table est vide après le ROLLBACK. Toutes les opérations ont été annulées d'un coup. Pendant ce temps, S1 ne voyait aucune modification car les données non validées ne sont pas visibles par les autres sessions — c'est l'**isolation des transactions**. C'est aussi le principe d'**atomicité** : une transaction est soit entièrement validée, soit entièrement annulée.



Question 3 — Insertions puis `quit` (session S2)
```sql
INSERT INTO transaction VALUES ('T1', 100);
INSERT INTO transaction VALUES ('T2', 200);
INSERT INTO transaction VALUES ('T3', 300);

quit;
```

Consultation dans S1 :
```sql
SELECT * FROM transaction;
```

<img width="717" height="648" alt="2" src="https://github.com/user-attachments/assets/06b0190f-a9b9-4acd-bda6-f370f9fe60de" />


Anomalie par rapport à l'énoncé :L'énoncé supposait que quit provoquerait un ROLLBACK implicite et que la table serait vide. Or dans Oracle SQL*Plus, quit provoque un COMMIT implicite, les données sont donc sauvegardées. Pour quitter en annulant, il faut explicitement faire ROLLBACK avant quit.



Question 4 — Fermeture brutale de sqlplus (session S1)

Dans S1, on insère quelques lignes sans COMMIT puis on ferme brutalement le terminal :
```sql
INSERT INTO transaction VALUES ('T4', 400);
INSERT INTO transaction VALUES ('T5', 500);
```

Après reconnexion :
```sql
SELECT * FROM transaction;
```

<img width="740" height="772" alt="3" src="https://github.com/user-attachments/assets/7e9e0aa5-c6d5-4c3e-a036-f4cf8652400b" />


T4 et T5 ne sont pas présentes. Une fermeture brutale provoque un ROLLBACK implicite, Oracle détecte la déconnexion anormale et annule toutes les modifications non validées. Les données non committées sont définitivement perdues.



Question 5 — DDL et ROLLBACK (nouvelle session)
```sql
SET AUTOCOMMIT OFF

INSERT INTO transaction VALUES ('T6', 600);
INSERT INTO transaction VALUES ('T7', 700);

ALTER TABLE transaction ADD val2transaction NUMBER(10);

ROLLBACK;

SELECT * FROM transaction;
DESCRIBE transaction;
```
<img width="735" height="718" alt="image" src="https://github.com/user-attachments/assets/490bbd03-d780-4014-96c8-4d1f67ec5d1e" />


T6 et T7 sont présentes et la colonne val2transaction est bien ajoutée malgré le ROLLBACK. Tout ordre DDL (ALTER, CREATE, DROP) provoque un COMMIT implicite avant de s'exécuter , les insertions de T6 et T7 ont donc été validées automatiquement. Le ROLLBACK suivant ne trouve plus rien à annuler.


Question 6 

Une session est une connexion à la base de données, qui débute à la connexion et se termine à la déconnexion. Elle peut contenir plusieurs transactions exécutées en série.

Une transaction est une séquence d'opérations SQL formant une unité logique indivisible. Elle commence implicitement après un COMMIT ou ROLLBACK précédent et se termine par l'un ou l'autre.

- COMMIT valide définitivement toutes les modifications. Elles deviennent visibles pour toutes les sessions et ne peuvent plus être annulées.
- ROLLBACK annule toutes les modifications depuis le début de la transaction. La base retrouve son état au dernier COMMIT.
