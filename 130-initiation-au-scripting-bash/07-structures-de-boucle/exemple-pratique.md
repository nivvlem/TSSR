# 🧪 TP 1 – Analyse de fichiers par extension avec `for`

## 📄Énoncé

Créer un script nommé `fictype.sh` qui :

1. Prend **un seul argument** : le **nom d’un répertoire**.
2. Refuse de s’exécuter si **aucun** ou **plus d’un** argument est fourni.
3. Lit les **extensions** autorisées depuis un fichier texte (une par ligne).
4. Affiche le **nombre total de fichiers** présents dans le répertoire.
5. Pour chaque extension autorisée, **compte et affiche** :
    - le **nombre de fichiers** correspondants,
    - leur **pourcentage** par rapport au total.

## 💡 Exemple de sortie attendue :

```bash
# ./fictype.sh /tmp
Nombre total de fichiers dans /tmp : 20
--------------
     .sh
--------------
-> 6 fichiers
-> 30% des fichiers du répertoire
--------------
     .txt
--------------
-> 4 fichiers
-> 20% des fichiers du répertoire
```

## ✅ Résolution complète – `fictype.sh`

```bash
#!/bin/bash

# Vérification des arguments
if [[ $# -ne 1 ]]; then
  echo "Syntaxe : $0 <répertoire>"
  exit 1
fi

rep="$1"
extfile="extensions.txt"

# Vérification du fichier contenant les extensions
if [[ ! -f $extfile ]]; then
  echo "Le fichier $extfile est introuvable."
  exit 2
fi

# Récupération du nombre total de fichiers
total=$(find "$rep" -type f | wc -l)
echo "Nombre total de fichiers dans $rep : $total"

# Lecture des extensions à tester
while read ext; do
  [[ -z "$ext" ]] && continue  # ignorer lignes vides
  count=$(find "$rep" -type f -name "*.$ext" | wc -l)
  if [[ $count -gt 0 ]]; then
    pourcentage=$(( 100 * count / total ))
    echo "--------------"
    echo "     .$ext"
    echo "--------------"
    echo "-> $count fichiers"
    echo "-> $pourcentage% des fichiers du répertoire"
  fi
done < "$extfile"
```

---

# 🧪 TP 2 – Affichage des informations utilisateurs avec `while/read`

## 📄Énoncé

Créer un script nommé `infousers.sh` qui :

1. Récupère les informations utilisateurs depuis `/etc/passwd`.
2. Reformate les lignes pour afficher **nom des champs + valeur**.
3. Utilise une **boucle `while read`** pour afficher les données ligne par ligne.
4. **Ignore** les champs non renseignés.

## Informations à afficher par utilisateur :

- Identifiant (nom d’utilisateur)
- UID, GID
- Description (champ GECOS)
- Répertoire personnel
- Shell

## 💡 Exemple de sortie attendue :

```
-------------------------
Identifiant :    Konekomaru
-  -  -  -  -  -  -  -  -
UID : 1000       GID : 1000
Description :    Konekomaru,,,
Répertoire personnel :   /home/Konekomaru
Shell :          /bin/bash
```

## ✅ Résolution complète – `infousers.sh`

```bash
#!/bin/bash

# Prétraitement du fichier passwd
cat /etc/passwd | sed -e 's/::/:x:/g' -e 's/:/ /g' |
while read identifiant x uid gid desc home shell; do
  echo "-------------------------"
  echo "Identifiant :    $identifiant"
  echo "-  -  -  -  -  -  -  -  -"

  [[ -n "$uid" ]] && echo -n "UID : $uid"
  [[ -n "$gid" ]] && echo -e "\tGID : $gid"
  [[ -n "$desc" ]] && echo "Description :    $desc"
  [[ -n "$home" ]] && echo "Répertoire personnel :   $home"
  [[ -n "$shell" ]] && echo "Shell :          $shell"
  echo

done
```

---

## ✅ À retenir pour les révisions

- La boucle `for` est idéale pour parcourir des listes (extensions, valeurs, etc.).
- La boucle `while/read` est la méthode recommandée pour lire **ligne par ligne** un fichier structuré.
- Toujours vérifier les arguments passés au script.
- Filtrer et afficher uniquement les informations utiles à l’utilisateur.
- Utiliser des fichiers d’entrée pour rendre les scripts plus dynamiques et réutilisables.
