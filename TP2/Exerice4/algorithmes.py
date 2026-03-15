import itertools

# 1. Affichage d'une liste de dépendances fonctionnelles
def printDependencies(F: "list of dependencies"):
    for alpha, beta in F:
        print("\t", alpha, "-->", beta)

# 2. Affichage d'un ensemble de relations
def printRelations(T: "list of relations"):
    for R in T:
        print("\t", R)

# 3. Génération de tous les sous-ensembles (Ensemble des parties P(E))
def powerSet(inputset: "set"):
    _result = []
    for r in range(1, len(inputset) + 1):
        _result += map(set, itertools.combinations(inputset, r))
    return _result

# 4. Calcul de la fermeture d'un ensemble d'attributs K
def computeAttributeClosure(F: "list of dependencies", K: "set of attributes"):
    K_plus = set(K)
    size = 0
    while size != len(K_plus):
        size = len(K_plus)
        for alpha, beta in F:
            if alpha.issubset(K_plus):
                K_plus.update(beta)
    return K_plus

# 5. Calcul de la clôture de F (toutes les dépendances déductibles)
def computeDependenciesClosure(F: "list of dependencies"):
    R = set()
    for alpha, beta in F: 
        R.update(alpha | beta)
    
    F_plus = []
    for K in powerSet(R):
        for beta in powerSet(computeAttributeClosure(F, K)):
            F_plus.append([K, beta])
    return F_plus

# 6. Vérifier si alpha détermine beta (a --> B)
def isDependency(F: "list of dependencies", alpha: "set of attributes", beta: "set of attributes"):
    return beta.issubset(computeAttributeClosure(F, alpha))

# 7. Vérifier si K est une super-clé de la relation R
def isSuperKey(F: "list of dependencies", R: "set defining a relation", K: "set of attributes"):
    return R.issubset(computeAttributeClosure(F, K))

# 8. Vérifier si K est une clé candidate de la relation R
def isCandidateKey(F: "list of dependencies", R: "set defining a relation", K: "set of attributes"):
    if not isSuperKey(F, R, K): 
        return False
    for A in K:
        K1 = set(K)
        K1.discard(A)
        if isSuperKey(F, R, K1): 
            return False
    return True

# 9. Retourner la liste de toutes les clés candidates d'une relation R
def computeAllCandidateKeys(F: "list of dependencies", R: "set defining a relation"):
    result = []
    for K in powerSet(R):
        if isCandidateKey(F, R, K):
            result.append(K)
    return result

# 10. Retourner la liste de toutes les super-clés d'une relation R
def computeAllSuperKeys(F: "list of dependencies", R: "set defining a relation"):
    result = []
    for K in powerSet(R):
        if isSuperKey(F, R, K):
            result.append(K)
    return result

# 11. Retourner une seule clé candidate d'une relation R
def computeOneCandidateKey(F: "list of dependencies", R: "set defining a relation"):
    K = set(R)
    while not isCandidateKey(F, R, K):
        for A in K:
            if isSuperKey(F, R, K.difference({A})):
                K.remove(A)
                break
    return K

# 12. Vérifier si une relation R est en BCNF
def isBCNFRelation(F: "list of dependencies", R: "set defining a relation"):
    for K in powerSet(R):
        K_plus = computeAttributeClosure(F, K)
        Y = K_plus.difference(K)
        if not R.issubset(K_plus) and not Y.isdisjoint(R):
            return False, [K, Y & R]
    return True, [{}, {}]

# 13. Vérifier si un ensemble de relations T est en BCNF
def isBCNFRelations(F: "list of dependencies", T: "list of relations"):
    for R in T:
        is_bcnf, _ = isBCNFRelation(F, R)
        if is_bcnf == False:
            return False, R
    return True, {}

# 14. Implémentation de l'algorithme de décomposition en BCNF
def computeBCNFDecomposition(F: "list of dependencies", T: "list of relations"):
    OUT = list(T)
    size = 0
    while size != len(OUT):
        size = len(OUT)
        for R in OUT:
            isR_BCNF, [alpha, beta] = isBCNFRelation(F, R)
            if isR_BCNF == False:
                if (alpha | beta) not in OUT:
                    OUT.append(alpha | beta)
                if R.difference(beta) not in OUT:
                    OUT.append(R.difference(beta))
                OUT.remove(R)
                break
    return OUT
