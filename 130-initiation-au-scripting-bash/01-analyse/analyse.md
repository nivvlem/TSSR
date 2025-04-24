# 01 - Analyse préalable à l'écriture d'un script Bash

## Introduction au scripting Shell

Un **script Shell** est un fichier texte contenant une suite de commandes Shell, exécutées de manière séquentielle.

### ⚙️ Étapes de création d'un script :
1. **Énoncé du problème** : définir ce que l'on cherche à résoudre.
2. **Cahier des charges** : lister les contraintes et les exigences.
3. **Algorithme / pseudo-code** : décrire les actions pas à pas.
4. **Écriture du script** : passage au code réel.

> 💡 Avant d’écrire un script, il est fondamental de passer par une phase **d’analyse** rigoureuse.

---

## Énoncé du problème et cahier des charges

### 🎯 Identifier le besoin
Le besoin est généralement exprimé par un utilisateur ou une équipe métier. Exemple :

> *"Nous avons besoin d’un outil qui affiche les derniers échecs de connexion utilisateur."*

Le **porteur du besoin** n’a pas à connaître les aspects techniques. Son rôle est de formuler clairement ce qu’il souhaite obtenir.

### 📋 Définir les contraintes
C’est à l’administrateur d’identifier les contraintes techniques liées au besoin :

#### Exemple de cahier des charges :
- Le script sera utilisé sur un **serveur Debian 10**.
- Il sera écrit en **Bash**.
- Il **n’aura pas de dépendances**.
- Le nombre d’échecs à afficher sera **paramétrable**.
- Une **valeur par défaut** sera définie si aucun paramètre n’est fourni.
- Il pourra être **lancé manuellement ou automatiquement** (via cron, par exemple).

> ✅ **Bonne pratique professionnelle** : documenter précisément les contraintes (OS, droits nécessaires, fréquence d’exécution, logs…).

---

## Réflexion sur la solution

Il est essentiel de **structurer sa pensée** avant de coder.

### 💭 Étapes de réflexion :
- Analyser le besoin.
- Identifier les traitements nécessaires.
- Déterminer l’ordre des instructions.

C’est à ce moment qu’on conçoit **l’algorithme**.

---

## Algorithme et pseudo-code

### 🧠 Qu’est-ce qu’un algorithme ?
C’est une **description textuelle** et structurée des instructions qui mèneront au résultat attendu. On peut le rédiger sous forme de :
- **pseudo-code** (texte libre respectant une logique de programmation)
- **organigramme** (diagramme visuel)

### ✏️ Exemple de pseudo-code :

```
log ← /var/log/secure
nbdefaut ← 42

Si (nombre d’arguments = 1)
  alors nb ← argument
Fin Si

Si (nb est nul OU nb n’est pas un entier)
  alors nb ← nbdefaut
Fin Si

Afficher les nb derniers échecs de connexion du fichier log
Journaliser "exécution de logonfails.sh"

```


> 🔎 **À noter** : le pseudo-code n'est pas du Bash, mais une manière de penser son script sans se soucier de la syntaxe exacte.

### 📈 Exemple d’organigramme simplifié :
- **DÉBUT**
- Initialisation des variables `log` et `nbdefaut`
- Vérification de la présence d’un argument
- Vérification de la validité de la valeur
- Affichage du résultat
- Journalisation
- **FIN**

> ✅ **Bonne pratique professionnelle** : concevoir systématiquement un algorithme/pseudo-code pour des scripts complexes ou critiques.

---

## 🧠 À retenir pour les révisions

- Toujours analyser le besoin avant d’écrire un script.
- Le cahier des charges sert de guide technique et fonctionnel.
- L’algorithme permet d’éviter les erreurs de logique en structurant le script avant l’écriture.
- Le pseudo-code et les organigrammes sont des outils puissants pour mieux comprendre et planifier son script.

---

## 🌐 Bonnes pratiques

- **Comment automatiser un script ?** → via `cron` ou `systemd timer`
- **Comment journaliser proprement ?** → via `logger` ou fichiers dans `/var/log/mon-script.log`
- **Comment valider un script ?** → tests unitaires, `shellcheck`, retour utilisateur
- **Comment bien commenter un script ?** → un en-tête clair avec auteur, date, but du script et prérequis techniques

