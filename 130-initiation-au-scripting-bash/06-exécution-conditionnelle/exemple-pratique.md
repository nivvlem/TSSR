# TP1 – Gestion conditionnelle d’un compte utilisateur

## 📄 Énoncé

Vous devez créer un script `usersmgmt.sh` permettant de gérer un **compte utilisateur** donné (identifiant fourni par l'utilisateur).

Le menu proposé contiendra les options suivantes :

- **C** – Créer le compte
- **M** – Modifier le mot de passe
- **S** – Supprimer le compte
- **V** – Vérifier si le compte existe
- **Q** – Quitter le script

### Exemple d’exécution :

```text
Saisir l'identifiant utilisateur souhaité : Ryuji
GESTION DES UTILISATEURS : Ryuji
--------------------------
C - Créer le compte utilisateur
M - Modifier le mot de passe de l'utilisateur
S - Supprimer le compte utilisateur
V - Vérifier si le compte utilisateur existe
Q - Quitter
Votre choix : v
Vérification de l'existence du compte
Compte utilisateur de Ryuji INEXISTANT
```

---

## 🧪 Script Bash

```bash
#!/bin/bash

read -p "Saisir l'identifiant utilisateur souhaité : " identifiant

while true; do
  echo -e "\nGESTION DES UTILISATEURS : $identifiant"
  echo "--------------------------"
  echo "C - Créer le compte utilisateur"
  echo "M - Modifier le mot de passe de l'utilisateur"
  echo "S - Supprimer le compte utilisateur"
  echo "V - Vérifier si le compte utilisateur existe"
  echo "Q - Quitter"

  read -p "Votre choix : " choix

  case $choix in
    C|c)
      if id "$identifiant" &>/dev/null; then
        echo "L'utilisateur existe déjà."
      else
        sudo useradd "$identifiant" && echo "Utilisateur créé."
      fi
      ;;

    M|m)
      if id "$identifiant" &>/dev/null; then
	    sudo passwd "$identifiant"
      else
        echo "Utilisateur inexistant."
      fi
      ;;

    S|s)
      if id "$identifiant" &>/dev/null; then
        sudo userdel "$identifiant" && echo "Utilisateur supprimé."
      else
        echo "Utilisateur inexistant."
      fi
      ;;

    V|v)
      echo "Vérification de l'existence du compte"
      if id "$identifiant" &>/dev/null; then
        echo "Compte utilisateur de $identifiant EXISTANT"
      else
        echo "Compte utilisateur de $identifiant INEXISTANT"
      fi
      ;;

    Q|q)
      echo "Sortie du script."
      break
      ;;

    *)
      echo "Choix invalide."
      ;;
  esac

done
```

---

## ✅ À retenir pour les révisions

- Utiliser la structure `case` pour gérer plusieurs actions utilisateur.
- Vérifier l’existence d’un utilisateur avec `id utilisateur`
- Utiliser `sudo` pour les commandes système sensibles (`useradd`, `passwd`, `userdel`)
- Toujours prévoir une sortie du script (`break` dans `while` ou `exit` hors menu)

---

## 📌 Bonnes pratiques professionnelles

|Pratique recommandée|Pourquoi ?|
|---|---|
|Utiliser `id` pour tester l'existence d'un compte|C’est la méthode standard et portable pour vérifier un utilisateur|
|Filtrer les commandes système avec `sudo`|Évite les erreurs de permissions et protège le système|
|Valider les entrées utilisateurs (`case`, `read`)|Garantit la robustesse et empêche les comportements inattendus|
|Mettre les messages importants sur des lignes claires|Améliore l’expérience utilisateur et la lisibilité|
|Grouper les actions dans une boucle `while`|Permet d’exécuter plusieurs opérations sans relancer le script|
|Nommer les variables de façon explicite|Clarifie la fonction du script et facilite sa maintenance|

---
---

# TP2 – Enchaînements conditionnels

## 📄 Énoncé

Ce TP se divise en deux parties :

### Partie 1 – Analyse du script `13.sh`

Le script `13.sh` permet d’identifier les mois d’une année donnée contenant un **vendredi 13**. À partir de là, il affiche une **évaluation du niveau de vigilance** en fonction du nombre de mois concernés.

#### 🧠 Explication du fonctionnement :

- Le script prend l’année à analyser comme **argument**.
- Il utilise une **boucle `until`** pour tester les mois de janvier à décembre.
- À chaque mois, la commande `cal` permet de récupérer le calendrier mensuel.
- Il recherche si le **13 du mois tombe un vendredi** (`cal` suivi de `grep 13` puis analyse du motif `13 14`).
- Il stocke le **nom du mois** (`date --date "$nummois/01" +%B`) et incrémente un compteur.
- Enfin, il affiche les mois sensibles et une **catégorie de vigilance** colorée selon le nombre de cas :
    - 1 mois = calme
    - 2 mois = vigilance moyenne
    - ≥3 mois = forte vigilance

#### ✅ Extraits clés du script commentés :

```bash
[[ -z $1 ]] && { echo -e "Syntaxe d'utilisation : $0 \033[31m <annee> \033[0m"; exit 13; }
```

> Vérifie que l’utilisateur a fourni une année en argument.

```bash
ligne13=$(cal $nummois $annee | grep 13)
ligne13=$(echo $ligne13)
```

> On récupère toutes les lignes contenant un 13, puis on les nettoie pour traitement.

```bash
if [[ $ligne13 = *13\ 14 ]] ; then ... fi
```

> Si le 13 est suivi du 14 dans le calendrier, alors **le 13 est un vendredi** (car il est en 6ᵉ position sur la ligne du `cal`).

```bash
case $nbremois in
  1) niveau="calme"; color="$vert";;
  2) niveau="moyenne"; color="$orange";;
  *) niveau="a forte vigilance"; color="$rouge";;
esac
```

> Le niveau de vigilance est défini selon le nombre de mois détectés.

#### 💬 Message final coloré :

```bash
echo -e "$annee sera une annee ${color}$niveau $noir( $nbremois )"
```

> Affiche une ligne de synthèse en couleur.

---

### Partie 2 – Création du script `29.sh`

Créer un script qui, à partir d’une **plage d’années**, détermine le nombre d’années bissextiles dans cette plage.

#### Étapes attendues :

1. Demander à l’utilisateur de saisir une année de début et une année de fin.
2. Vérifier que la saisie est valide (nombres entiers et début ≤ fin).
3. Boucler sur les années dans l’intervalle et compter celles qui sont bissextiles.
4. Afficher le total à la fin.

> 💡 Une année est bissextile si elle est divisible par 4 **et** (pas divisible par 100 **ou** divisible par 400).

---

## 🧪 Script `29.sh`
```bash
#!/bin/bash

read -p "Année de début : " debut
read -p "Année de fin   : " fin

# Vérification de la saisie
if ! [[ "$debut" =~ ^[0-9]+$ && "$fin" =~ ^[0-9]+$ ]]; then
  echo "Saisie invalide. Veuillez entrer uniquement des nombres entiers."
  exit 1
fi

if [ "$debut" -gt "$fin" ]; then
  echo "Erreur : l’année de début est supérieure à celle de fin."
  exit 2
fi

nb_bissextiles=0

for (( an=$debut; an<=$fin; an++ )); do
  if (( an % 4 == 0 && (an % 100 != 0 || an % 400 == 0) )); then
    echo "$an est bissextile"
    ((nb_bissextiles++))
  fi
done

echo "Nombre total d’années bissextiles : $nb_bissextiles"
```

---

## ✅ À retenir pour les révisions

- Utiliser `[[ ... ]]` avec regex pour tester un format numérique.
- Utiliser `for (( ... ))` pour itérer sur des plages de nombres.
- Appliquer la condition des années bissextiles avec `&&` et `||` imbriqués.
- Toujours vérifier les entrées utilisateur pour éviter les erreurs.
- Analyser un script inconnu par blocs et commentaires explicites.

---

## 📌 Bonnes pratiques professionnelles

|Pratique recommandée|Pourquoi ?|
|---|---|
|Vérifier la validité des entrées utilisateur|Évite les plantages ou comportements inattendus|
|Ajouter des messages explicites en cas d’erreur|Améliore l’expérience utilisateur|
|Tester les nombres avec des regex `^[0-9]+$`|Permet de valider proprement les saisies numériques|
|Utiliser des noms de variables clairs (`debut`, `fin`, `nb_bissextiles`)|Rend le script lisible et compréhensible|
|Ajouter des commentaires dans les scripts|Facilite la maintenance et le partage entre collègues|
|Respecter la logique de retour avec `exit` + code|Permet d’identifier les erreurs à l’exécution ou en appel automatisé|
|Lire et compléter un script existant de façon rigoureuse|Préparation à la maintenance de code tiers|

