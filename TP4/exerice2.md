## Exercice 2

On travaille avec une table `emp` représentant les employés d'une entreprise. On commence par la créer et y insérer quelques données.

```sql
CREATE TABLE emp (
    matr    NUMBER(10)    NOT NULL,
    nom     VARCHAR2(50)  NOT NULL,
    sal     NUMBER(7,2),
    adresse VARCHAR2(96),
    dep     NUMBER(10)    NOT NULL,
    CONSTRAINT emp_pk PRIMARY KEY (matr)
);
```


### 1. Insérer un nouvel employé

On utilise le type %ROWTYPE pour déclarer une variable qui représente une ligne entière de la table, puis on insère cette ligne.

```sql
SET SERVEROUTPUT ON;
DECLARE
    v_employe emp%ROWTYPE;
BEGIN
    v_employe.matr    := 4;
    v_employe.nom     := 'Youcef';
    v_employe.sal     := 2500;
    v_employe.adresse := 'avenue de la République';
    v_employe.dep     := 92002;

    INSERT INTO emp VALUES v_employe;
    COMMIT;
END;
```

**Explication** : %ROWTYPE permet de déclarer une variable qui a exactement la même structure que la table emp. On remplit chaque champ un par un, puis on insère la ligne entière d'un coup avec INSERT INTO emp VALUES v_employe.



### 2. Supprimer des employés et afficher le nombre de lignes supprimées

On supprime tous les employés d'un département donné, et on utilise SQL%ROWCOUNT pour savoir combien de lignes ont été affectées.

```sql
SET SERVEROUTPUT ON;
DECLARE
    v_nb_lignes NUMBER;
BEGIN
    DELETE FROM emp WHERE dep = 10;
    v_nb_lignes := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Nombre de lignes supprimées : ' || v_nb_lignes);
    COMMIT;
END;
```

**Explication** : Après chaque instruction DML (DELETE, INSERT, UPDATE), Oracle met à jour automatiquement SQL%ROWCOUNT avec le nombre de lignes concernées. On récupère cette valeur juste après le DELETE pour l'afficher.


### 3. Somme des salaires avec un curseur explicite et LOOP

On utilise un curseur explicite pour parcourir les salaires un par un et les additionner manuellement.

```sql
SET SERVEROUTPUT ON;
DECLARE
    v_salaire EMP.sal%TYPE;
    v_total   EMP.sal%TYPE := 0;
    CURSOR c_salaires IS
        SELECT sal FROM emp;
BEGIN
    OPEN c_salaires;
    LOOP
        FETCH c_salaires INTO v_salaire;
        EXIT WHEN c_salaires%NOTFOUND;
        IF v_salaire IS NOT NULL THEN
            v_total := v_total + v_salaire;
        END IF;
    END LOOP;
    CLOSE c_salaires;

    DBMS_OUTPUT.PUT_LINE('Somme des salaires : ' || v_total);
END;
```

**Explication** : Un curseur explicite fonctionne en 3 étapes : on l'ouvre avec OPEN, on lit ligne par ligne avec FETCH, et on le ferme avec CLOSE. La condition EXIT WHEN %NOTFOUND arrête la boucle quand il n'y a plus de lignes à lire. On vérifie aussi que le salaire n'est pas NULL avant de l'additionner.



### 4. Salaire moyen avec un curseur explicite et LOOP

On adapte le programme précédent pour calculer la moyenne : il suffit de compter le nombre d'employés et de diviser la somme à la fin.

```sql
SET SERVEROUTPUT ON;
DECLARE
    v_salaire  EMP.sal%TYPE;
    v_total    EMP.sal%TYPE := 0;
    v_nb       NUMBER := 0;
    v_moyenne  EMP.sal%TYPE;
    CURSOR c_salaires IS
        SELECT sal FROM emp;
BEGIN
    OPEN c_salaires;
    LOOP
        FETCH c_salaires INTO v_salaire;
        EXIT WHEN c_salaires%NOTFOUND;
        IF v_salaire IS NOT NULL THEN
            v_total := v_total + v_salaire;
            v_nb    := v_nb + 1;
        END IF;
    END LOOP;
    CLOSE c_salaires;

    IF v_nb > 0 THEN
        v_moyenne := v_total / v_nb;
        DBMS_OUTPUT.PUT_LINE('Salaire moyen : ' || v_moyenne);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Aucun employé trouvé.');
    END IF;
END;
```

**Explication** : On ajoute un compteur v_nb qui s'incrémente à chaque salaire non NULL. À la fin, on divise v_total par v_nb pour obtenir la moyenne. On vérifie que v_nb est supérieur à 0 pour éviter une division par zéro.


### 5. Réécriture avec la boucle FOR IN

La boucle FOR IN sur un curseur est plus concise : elle ouvre, parcourt et ferme le curseur automatiquement.

**Somme des salaires :**

```sql
SET SERVEROUTPUT ON;
DECLARE
    v_total EMP.sal%TYPE := 0;
BEGIN
    FOR v_ligne IN (SELECT sal FROM emp) LOOP
        IF v_ligne.sal IS NOT NULL THEN
            v_total := v_total + v_ligne.sal;
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Somme des salaires : ' || v_total);
END;
```

**Salaire moyen :**

```sql
SET SERVEROUTPUT ON;
DECLARE
    v_total   EMP.sal%TYPE := 0;
    v_nb      NUMBER := 0;
BEGIN
    FOR v_ligne IN (SELECT sal FROM emp) LOOP
        IF v_ligne.sal IS NOT NULL THEN
            v_total := v_total + v_ligne.sal;
            v_nb    := v_nb + 1;
        END IF;
    END LOOP;

    IF v_nb > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Salaire moyen : ' || (v_total / v_nb));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Aucun employé trouvé.');
    END IF;
END;
```

**Explication** : Avec FOR IN, plus besoin de OPEN, FETCH ni CLOSE. Oracle gère tout seul. La variable v_ligne prend automatiquement les valeurs de chaque ligne renvoyée par la requête. C'est la façon la plus simple et lisible d'utiliser un curseur.


### 6. Afficher les employés de deux départements avec un curseur paramétré

Un curseur paramétré accepte une valeur en entrée, ce qui permet de le réutiliser pour différents départements.

```sql
SET SERVEROUTPUT ON;
DECLARE
    CURSOR c(p_dep EMP.dep%TYPE) IS
        SELECT dep, nom
        FROM emp
        WHERE dep = p_dep;
BEGIN
    FOR v_employe IN c(92000) LOOP
        DBMS_OUTPUT.PUT_LINE('Dep 92000 : ' || v_employe.nom);
    END LOOP;

    FOR v_employe IN c(75000) LOOP
        DBMS_OUTPUT.PUT_LINE('Dep 75000 : ' || v_employe.nom);
    END LOOP;
END;
```

**Explication** : On déclare le curseur avec un paramètre p_dep, comme une fonction. Quand on l'appelle avec c(92000) puis c(75000), Oracle exécute la requête avec la valeur passée à chaque fois. Cela évite de réécrire deux curseurs différents.
