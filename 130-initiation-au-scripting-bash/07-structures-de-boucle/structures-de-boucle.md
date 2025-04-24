# Les structures de boucle dans les scripts Bash

## 🔄 Introduction aux boucles

Une **boucle** permet de **répéter un bloc d’instructions** plusieurs fois, jusqu’à ce qu’une condition soit remplie ou qu’une liste soit entièrement traitée.

> 💡 Lorsqu’on utilise une condition, **ne pas oublier de faire évoluer les variables** testées dans la condition !

---

## 🔁 Boucle `while` (tant que)

```bash
while CONDITION ; do
  COMMANDES
done
```

Tant que la condition est **vraie** (`code retour = 0`), le bloc est exécuté.

### Exemple : demander un nom à l’utilisateur

```bash
while [[ -z "$nom" ]]; do
  read -p "Veuillez entrer votre nom : " nom
done
echo "Bonjour $nom"
```

### Boucle infinie (menu par exemple) :

```bash
while true; do
  echo "1) sauvegarde"
  echo "2) restauration"
  echo "q) quitter"
  read -p "Choix : " choix
  case $choix in
    1) echo "Sauvegarde...";;
    2) echo "Restauration...";;
    q) break;;
    *) echo "Choix invalide";;
  esac
done

echo "Fin du programme, merci !"
```

---

## ⏳ Boucle `until` (jusqu’à)

```bash
until CONDITION ; do
  COMMANDES
done
```

Le bloc est exécuté **tant que la condition est fausse**.

### Exemple :

```bash
until [[ -n "$age" ]]; do
  read -p "Entrez votre âge : " age
done
```

> 💡 Boucle infinie avec `until false`.

---

## 📚 4. Boucle `for`

### Boucle sur une **liste de valeurs** :

```bash
for val in un deux trois; do
  echo "Valeur : $val"
done
```

### Boucle **arithmétique** (avec incrémentation) :

```bash
for (( i=1; i<=5; i++ )); do
  echo "Itération $i"
done
```

---

## 🧾 Lecture de fichiers ligne à ligne

### Mauvaise pratique avec `for` (perd les champs)

```bash
for ligne in $(cat fichier.txt); do
  echo "$ligne"
done
```

### Bonne pratique avec `while read` :

```bash
while read nom prenom reste; do
  echo "$prenom $nom"
done < fichier.txt
```

### Variante avec `cat | while read` (moins recommandé si on modifie des variables dans la boucle)

```bash
cat fichier.txt | while read nom prenom reste; do
  echo "$prenom $nom"
done
```

> 📌 Utiliser `</dev/tty` pour permettre un `read` interactif à l’intérieur d’un `while read`.

---

## ✅ À retenir pour les révisions

- `while` : tant que condition vraie → on boucle
- `break` : interrompt la boucle
- `exit 0` : interrompt le script
- `until` : tant que condition fausse → on boucle
- `for` : liste ou compteur → itérations déterminées
- `while read` : traitement ligne par ligne d’un fichier
- Penser à **initialiser les compteurs et variables**, et à **modifier les conditions dans les boucles**

---

## 📌 Bonnes pratiques professionnelles

|Pratique recommandée|Pourquoi ?|
|---|---|
|Toujours prévoir une condition de sortie|Évite les boucles infinies involontaires|
|Préférer `while read` à `for` pour les fichiers|Conserve la structure ligne / champ|
|Ajouter des commentaires dans les boucles|Aide à la compréhension, surtout pour les scripts longs|
|Vérifier les entrées utilisateur dans les boucles|Sécurise les scripts interactifs|
|Utiliser `(( i++ ))` ou `let` pour les compteurs|Plus lisible que `expr` et mieux intégré au Shell|
