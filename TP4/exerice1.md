# TP n° 4 : Introduction au Procedural Language (PL/SQL) d'Oracle

## Exercice 1



### 1. Somme de deux entiers

Sous Oracle APEX, on ne peut pas interagir dynamiquement avec l'utilisateur via `&variable.` 
comme on le ferait en SQL*Plus. On **simule donc la saisie** en initialisant les valeurs 
directement dans la section `DECLARE`.

```sql
SET SERVEROUTPUT ON;
DECLARE
    -- Simulation de la saisie utilisateur
    v_entier1 NUMBER := 12;
    v_entier2 NUMBER := 25;
    v_somme   NUMBER;
BEGIN
    v_somme := v_entier1 + v_entier2;
    DBMS_OUTPUT.PUT_LINE('La somme de ' || v_entier1 || ' et ' || v_entier2 
                         || ' est égale à : ' || v_somme);
END;
```

 **Explication** : On déclare trois variables de type `NUMBER`. On affecte la somme 
 dans `v_somme`, puis on l'affiche avec `DBMS_OUTPUT.PUT_LINE`. 
 L'opérateur `||` sert à concaténer des chaînes de caractères.



### 2. Table de multiplication

On utilise une boucle `FOR ... LOOP` pour itérer de 1 à 10 et afficher chaque ligne 
de la table du nombre choisi.

```sql
SET SERVEROUTPUT ON;
DECLARE
    -- Simulation de la saisie utilisateur
    v_nombre NUMBER := 7;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Table de multiplication de ' || v_nombre || ' ---');
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE(v_nombre || ' x ' || i || ' = ' || (v_nombre * i));
    END LOOP;
END;
```

 **Explication** : La boucle `FOR i IN 1..10` crée automatiquement la variable 
 compteur `i` qui prend les valeurs de 1 à 10. À chaque tour, on calcule et affiche 
 `v_nombre * i`. Simple et efficace !



### 3. Fonction récursive x^n

On écrit une **fonction nommée** (pas un bloc anonyme cette fois) qui s'appelle 
elle-même pour calculer x à la puissance n.

```sql
SET SERVEROUTPUT ON;
CREATE OR REPLACE FUNCTION puissance(x IN NUMBER, n IN NUMBER) RETURN NUMBER IS
BEGIN
    -- Cas de base : n = 0 → x^0 = 1
    IF n = 0 THEN
        RETURN 1;
    ELSE
        -- Appel récursif : x^n = x * x^(n-1)
        RETURN x * puissance(x, n - 1);
    END IF;
END;
/

-- Test de la fonction
BEGIN
    DBMS_OUTPUT.PUT_LINE('2^10 = ' || puissance(2, 10));
    DBMS_OUTPUT.PUT_LINE('3^4  = ' || puissance(3, 4));
END;
/
```

 **Explication** : Le principe de la récursivité repose sur deux éléments :
 - Un **cas de base** qui arrête les appels (ici `n = 0`)
 - Un **appel récursif** qui réduit le problème (`n - 1`)
 
 Ainsi `puissance(2, 3)` donne `2 * puissance(2,2)` puis `2 * 2 * puissance(2,1)` 
 puis `2 * 2 * 2 * puissance(2,0)` et enfin `2 * 2 * 2 * 1 = 8`.



### 4. Factorielle avec stockage dans une table

On crée d'abord la table `resultatFactoriel`, puis on calcule la factorielle 
d'un nombre et on y stocke le résultat.

```sql
-- Création de la table de stockage
CREATE TABLE resultatFactoriel (
    nombre     NUMBER,
    factoriel  NUMBER
);
```

```sql
SET SERVEROUTPUT ON;
DECLARE
    -- Simulation de la saisie utilisateur
    v_nombre    NUMBER := 6;
    v_fact      NUMBER := 1;
    v_compteur  NUMBER := 1;
BEGIN
    -- Calcul de la factorielle avec une boucle LOOP
    LOOP
        EXIT WHEN v_compteur > v_nombre;
        v_fact := v_fact * v_compteur;
        v_compteur := v_compteur + 1;
    END LOOP;

    -- Stockage du résultat dans la table
    INSERT INTO resultatFactoriel (nombre, factoriel) VALUES (v_nombre, v_fact);
    COMMIT;

    DBMS_OUTPUT.PUT_LINE(v_nombre || '! = ' || v_fact);
END;
```

 **Explication** : On utilise une boucle `LOOP ... EXIT WHEN` pour multiplier 
 successivement tous les entiers de 1 jusqu'à `v_nombre`. Le résultat est ensuite 
 inséré dans la table avec `INSERT`, et la transaction est validée avec `COMMIT`.



### 5. Factorielles des 20 premiers entiers

On modifie le programme précédent pour boucler sur les 20 premiers entiers 
et stocker **chaque** factorielle dans la table `resultatsFactoriels`.

```sql
-- Création de la nouvelle table
CREATE TABLE resultatsFactoriels (
    nombre     NUMBER,
    factoriel  NUMBER
);
```

```sql
SET SERVEROUTPUT ON;
DECLARE
    v_fact NUMBER := 1;
BEGIN
    -- Boucle externe : on parcourt les 20 premiers entiers
    FOR n IN 1..20 LOOP
        v_fact := 1;

        -- Boucle interne : calcul de n!
        FOR i IN 1..n LOOP
            v_fact := v_fact * i;
        END LOOP;

        -- Insertion du résultat dans la table
        INSERT INTO resultatsFactoriels (nombre, factoriel) VALUES (n, v_fact);
        DBMS_OUTPUT.PUT_LINE(n || '! = ' || v_fact);
    END LOOP;

    COMMIT;
END;
```

**Explication** : On imbrique deux boucles `FOR`. La boucle externe fait varier 
`n` de 1 à 20. Pour chaque `n`, la boucle interne recalcule `n!` depuis zéro 
(d'où le `v_fact := 1` au début de chaque tour). On insère et on affiche au fur 
et à mesure. Le `COMMIT` final valide toutes les insertions en une fois.
