## Exercice 3

On implémente un package de gestion des clients. Un package en PL/SQL regroupe des procédures et fonctions liées dans un même bloc. Il se compose de deux parties : la spécification (ce qu'on expose) et le corps (ce qu'on implémente).

La surcharge est possible en PL/SQL : deux procédures peuvent porter le même nom à condition d'avoir des paramètres différents.



### Création de la table client

```sql
CREATE TABLE client (
    id_client  NUMBER(10)   NOT NULL,
    nom        VARCHAR2(50) NOT NULL,
    email      VARCHAR2(100),
    telephone  VARCHAR2(20),
    CONSTRAINT client_pk PRIMARY KEY (id_client)
);
```



### Spécification du package

La spécification déclare les deux procédures ajouterClient : l'une avec tous les détails, l'autre avec seulement le nom.

```sql
CREATE OR REPLACE PACKAGE pkg_clients AS

    -- Version complète : avec email et téléphone
    PROCEDURE ajouterClient(
        p_id        IN client.id_client%TYPE,
        p_nom       IN client.nom%TYPE,
        p_email     IN client.email%TYPE,
        p_telephone IN client.telephone%TYPE
    );

    -- Version simplifiée : avec le nom uniquement
    PROCEDURE ajouterClient(
        p_id  IN client.id_client%TYPE,
        p_nom IN client.nom%TYPE
    );

END pkg_clients;
/
```



### Corps du package

On implémente les deux procédures et on gère les exceptions pour chacune.

```sql
CREATE OR REPLACE PACKAGE BODY pkg_clients AS

    -- Version complète
    PROCEDURE ajouterClient(
        p_id        IN client.id_client%TYPE,
        p_nom       IN client.nom%TYPE,
        p_email     IN client.email%TYPE,
        p_telephone IN client.telephone%TYPE
    ) IS
    BEGIN
        INSERT INTO client (id_client, nom, email, telephone)
        VALUES (p_id, p_nom, p_email, p_telephone);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Client ajouté avec succès : ' || p_nom);

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : un client avec cet identifiant existe déjà.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur inattendue : ' || SQLERRM);
            ROLLBACK;
    END ajouterClient;


    -- Version simplifiée
    PROCEDURE ajouterClient(
        p_id  IN client.id_client%TYPE,
        p_nom IN client.nom%TYPE
    ) IS
    BEGIN
        INSERT INTO client (id_client, nom)
        VALUES (p_id, p_nom);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Client ajouté avec succès (sans détails) : ' || p_nom);

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Erreur : un client avec cet identifiant existe déjà.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erreur inattendue : ' || SQLERRM);
            ROLLBACK;
    END ajouterClient;

END pkg_clients;
/
```

**Explication** : Le corps implémente chaque version d'ajouterClient séparément. Dans chaque procédure, on gère deux exceptions : DUP_VAL_ON_INDEX se déclenche si on essaie d'insérer un identifiant déjà existant (violation de clé primaire), et WHEN OTHERS attrape tout autre problème inattendu. SQLERRM contient le message d'erreur Oracle correspondant. En cas d'erreur grave, on annule l'insertion avec ROLLBACK.


### Test du package

```sql
SET SERVEROUTPUT ON;
BEGIN
    -- Appel de la version complète
    pkg_clients.ajouterClient(1, 'Alice', 'alice@email.com', '0601020304');

    -- Appel de la version simplifiée
    pkg_clients.ajouterClient(2, 'Bob');

    -- Test de la gestion d'erreur : identifiant déjà existant
    pkg_clients.ajouterClient(1, 'Doublon');
END;
/
```

**Explication** : Oracle choisit automatiquement quelle version d'ajouterClient appeler selon le nombre de paramètres passés. C'est le principe de la surcharge. Le troisième appel provoque volontairement une erreur pour vérifier que l'exception est bien interceptée.
