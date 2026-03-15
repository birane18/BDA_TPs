from algorithmes import *

def main():
    print("=== BDA TP2 - Exercice 4 : Algorithmes de Normalisation ===\n")

    # Déclaration des relations fournies dans le sujet
    myrelations = [
        {'A', 'B', 'C', 'G', 'H', 'I'},
        {'X', 'Y'}
    ]
    
    # Déclaration des dépendances fournies dans le sujet
    mydependencies = [
        [{'A'}, {'B'}],       # A -> B
        [{'A'}, {'C'}],       # A -> C
        [{'C', 'G'}, {'H'}],  # CG -> H
        [{'C', 'G'}, {'I'}],  # CG -> I
        [{'B'}, {'H'}]        # B -> H
    ]

    print("--- Question 1 : Liste des dépendances fonctionnelles ---")
    printDependencies(mydependencies)
    print("\n")

    print("--- Question 2 : Liste des relations (Schéma initial) ---")
    printRelations(myrelations)
    print("\n")

    # Test : Calcul de la fermeture de {C, G}
    K_test = {'C', 'G'}
    print(f"--- Question 4 : Fermeture de l'ensemble {K_test} ---")
    fermeture = computeAttributeClosure(mydependencies, K_test)
    print(f"({K_test})+ = {fermeture}\n")

    # Test : Clés candidates pour la relation R1
    R1 = myrelations[0]
    print(f"--- Question 9 : Clés candidates pour la relation {R1} ---")
    cles_candidates = computeAllCandidateKeys(mydependencies, R1)
    print(f"Clés candidates trouvées : {cles_candidates}\n")

    # Test : Décomposition en BCNF
    print("--- Question 14 : Décomposition en BCNF du schéma ---")
    schema_decompose = computeBCNFDecomposition(mydependencies, myrelations)
    print("Schéma final décomposé :")
    printRelations(schema_decompose)

if __name__ == "__main__":
    main()
