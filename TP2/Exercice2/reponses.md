Exercice 2 – Normalisation

Question 1

Relation :
R(A,B,C)

F = {A --> B, B --> C}

Par transitivité :
A --> C

Donc :
A --> B,C

A est une clé candidate.

Cependant la dépendance B --> C viole BCNF car B n’est pas une clé.

Décomposition :
R1(B,C)
R2(A,B)

Les deux relations sont en BCNF.


Question 2

R(A,B,C)

F = {A --> B, A --> C}

A détermine tous les attributs.

A est clé candidate.

La relation est en BCNF.


Question 3

R(A,B,C)

F = {AB --> C, C --> B}

Clé candidate :
AB

C --> B viole BCNF car C n’est pas une clé.

Décomposition :
R1(C,B)
R2(A,C)
