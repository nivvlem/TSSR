# Écriture d’un script Bash

## 📄 Création d’un script

Un script Shell est un **fichier texte contenant une suite de commandes** Bash.

> 🛠️ On recommande l’éditeur `vim` (ou `nano`, `code`, etc.) pour l’éditer.

```bash
$ vim monscript.sh
```

Les commandes sont **lues séquentiellement** par l’interpréteur du Shell.

---

## ⚙️ Le shebang (`#!`)

Le shebang est une **bonne pratique essentielle** pour indiquer au système **quel interpréteur utiliser** pour exécuter le script.

Il doit être placé **en première ligne** :

```bash
#!/bin/bash
```

Autres exemples possibles : `#!/bin/sh`, `#!/usr/bin/env python3`, `#!/usr/bin/perl`

> 💡 Utiliser `which bash` pour connaître le chemin exact de l’interpréteur sur ta machine.

---

## 📝 Commenter son code

### Pourquoi commenter ?

- Pour faciliter les futures modifications (par toi ou d’autres).
- Pour clarifier l’intention derrière chaque bloc de code.

### Comment commenter ?

```bash
# Ceci est un commentaire

echo "Hello World!" # Ce commentaire suit une commande
```

### Bonnes pratiques : entête de script

```bash
#!/bin/bash
#==============================================================
# FILE: monscript.sh
# USAGE: ./monscript.sh
# DESCRIPTION: Script d’exemple d’affichage simple
# AUTHOR: Ton Nom, ton.email@example.com
# CREATED: 2025-04-22
# REVISION: 1.0
#==============================================================
```

> ✅ Professionnellement, un entête est **fortement recommandé**.

---

## 🔓 Rendre un script exécutable

### Commande pour accorder l’exécution :

```bash
chmod +x monscript.sh        # pour l’utilisateur
chmod ug+x monscript.sh      # pour l’utilisateur et le groupe
```

Ensuite, on peut l’exécuter avec :

```bash
./monscript.sh
```

---

## 🐞 Suivre l’exécution d’un script (debugging)

### Mode trace : exécute et affiche chaque commande précédée de `+`

```bash
bash -x monscript.sh
```

### Exemple :

```
+ echo Hello world
Hello world
```

### Debug manuel (affichage des valeurs internes)

```bash
echo "Entrez votre nom :"
read nom

# DEBUG
echo "Valeur saisie : $nom"
read # pause pour vérifier le contenu
# FIN DEBUG

echo "Bienvenue $nom sur $(hostname)"
```

> 💡 **Commenter les lignes de debug** avant mise en production :

```bash
#echo "Valeur saisie : $nom"
#read
```

---

## ✅ À retenir pour les révisions

- Un script Bash est un simple fichier texte interprété ligne par ligne.
- Toujours commencer par `#!/bin/bash` (ou un autre shebang adapté).
- Les commentaires commencent par `#` et sont **indispensables**.
- Donner les **droits d’exécution** avec `chmod +x`.
- Le **mode `bash -x`** est utile pour tracer l’exécution d’un script.
- Penser à retirer ou commenter les lignes de debug avant livraison ou automatisation.

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Ajouter un entête descriptif|Identification rapide du script|
|Utiliser des commentaires clairs|Aide à la maintenance / relecture|
|Éviter les chemins relatifs flous|Préférer `$(dirname "$0")` si besoin de robustesse|
|Logger les erreurs|Avec `echo "..." >&2` ou `logger`|
|Valider les entrées utilisateur|Test avec `[[ ]]`, `-z`, `-n`, regex|
