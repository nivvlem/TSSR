# 📊 Connaissances des notions de base Excel

## 📁 Notions de base sur les classeurs

### Création et ouverture

- Nouveau classeur : vierge ou modèle
- Ouverture : fichiers récents, local ou réseau

### Limitations d’un classeur

- 255 feuilles max
- Feuille : 1 048 576 lignes, 16 384 colonnes (A1 à XFD1048576)
- Cellule :
    - Texte : jusqu’à 32 767 caractères
    - Formule : jusqu’à 8 192 caractères
    - Chiffre : 11 chiffres affichables (au-delà : notation exponentielle)
- Nom de feuille : 31 caractères max

---

## 🧮 Calculs et opérateurs

- **Excel ≈ Calculatrice**
- Opérateurs : `+`, `-`, `*`, `/`, `^`, `%`
- Priorité : `%`, `^` > `*`, `/` > `+`, `-`
- Utiliser les **parenthèses** pour forcer l’ordre de calcul

---

## 🔲 Cellules et pointeurs

### Références de cellules

- A1 (colonne A, ligne 1)
- Remplaçables par un **nom personnalisé** (menu Formules > Gestionnaire de noms)

### Types de pointeurs

- **Croix blanche** : sélection
- **Flèche blanche** : déplacement
- **Flèche + croix fléchée** : copie avec CTRL
- **Croix noire** (coin bas droit) : recopie automatique ou incrémentée

### Listes personnalisées

- Créer/modifier via Options Excel > Options avancées > Listes personnalisées

---

## 🧠 Fonctions Excel utiles

### Fonctions mathématiques

- =alea()*100 : nombre aléatoire
- =arrondi(3,14;2) : 3,14
- =ent(3,14) : 3
- =produit(A1:A3) : produit des valeurs
- =somme(A1:A3) : somme des valeurs
- =quotient(5;2) : 2
- =mod(5;2) : 1

### Fonctions texte

- =concat("Hello";" ";"World")
- =droite("Hello";2) : "lo"
- =gauche("Hello";4) : "Hell"
- =majuscule("test") : "TEST"
- =nbcar("Bonjour") : 7
- =texte(17,12) : "17,12"
- =cnum("17,12") : 17,12

### Fonctions de recherche

- =colonne(E3) : 5
- =ligne(E3) : 3
- =recherchev(3;A2:E5;4) : valeur de la 4e colonne
- =rechercheh("Ville";A2:E5;3) : valeur sur la 3e ligne
- =trouve("o";"Bonjour") : 2

### Fonctions logiques

- =SI(B5="Yann";"Vrai";"Faux")
- =ET(A2<A5;A3<3)
- =OU(B2="X";A3>=2)
- =SIERREUR(moy(E2:E5);"Erreur")

---

## 🧩 Utilisation des fonctions

- Taper = puis le début de la fonction → suggestions d'Excel
- Double clic sur la fonction pour aide rapide
- Aide avancée disponible via l’interface

### Recopie des formules

- **Croix noire** = recopie formule (verticale/horizontale)
- **Copier/Coller spécial** pour ne recopier que la formule

### Références relatives / absolues

- Relative : `A1`
- Absolue : `$A$1`
- Colonne absolue : `$A1`, ligne absolue : `A$1`
- Touche **F4** : basculer entre les types

---

## 🔗 Excel et SharePoint

- Fichiers sur SharePoint = sauvegarde automatique
- Historique des versions et des modifications
- Possibilité de revenir à une version antérieure sans perte

---

## 📘 À retenir pour l'examen

- Excel fonctionne avec **cellules, formules, références**
- Les **fonctions de base** (somme, produit, si, etc.) sont prioritaires
- Savoir différencier **références relatives/absolues**
- Comprendre la structure : **classeur, feuille, cellule**
- Recopie automatique et outils de suggestion = gain de temps

## 🧑‍💼 Bonnes pratiques professionnelles

- Toujours nommer les plages importantes via le gestionnaire de noms
- Utiliser les **styles de tableau** pour une meilleure lisibilité
- Protéger les feuilles contenant des formules importantes
- Centraliser les documents sur SharePoint pour éviter les doublons
- Favoriser l’utilisation de **modèles (.xltx)** avec formules préconfigurées
