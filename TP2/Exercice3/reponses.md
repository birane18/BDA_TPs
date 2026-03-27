Exercice 3 – Dépendances fonctionnelles

Question 1

R(A,B,C,D,E)

F = {A --> BC, CD --> E, B --> D, E --> A}

Exemples de dépendances dérivées :

A --> B
A --> C
A --> D
A --> E
A --> BCDE

E --> A
E --> B
E --> C
E --> D

CD --> E
CD --> A
CD --> B
CD --> C
CD --> D

Cela permet de générer plus de 16 dépendances fonctionnelles.


Question 2

Relation :

R(A,B,C,D,E,F)

F = {A --> B,C,D ; BC --> D,E ; B --> D ; D --> A}

Fermeture de B :

B⁺ = {B,D,A,C,E}

Fermeture de {A,B} :

{A,B}⁺ = {A,B,C,D,E}

Super-clé :

{A,F}⁺ = {A,B,C,D,E,F}

Donc {A,F} est une super-clé.



BCNF

Certaines dépendances violent BCNF car la partie gauche n’est pas une clé.

La relation doit donc être décomposée selon l’algorithme de décomposition BCNF.



Question 3

Décomposition 1

R1(A,B,C)

R2(A,D,E)

Intersection = A

A est clé dans R1

Donc décomposition sans perte.



Décomposition 2

R1(A,B,C)

R2(C,D,E)

Intersection = C

C n’est pas clé

Décomposition avec perte.
