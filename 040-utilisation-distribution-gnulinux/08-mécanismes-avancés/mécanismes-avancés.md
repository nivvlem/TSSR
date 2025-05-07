# Mécanismes Linux et Bash Avancé

## 🧠 Gestion des processus

### 🔍 Visualiser les processus

```bash
ps -ef         # tous les processus
ps -u <user>   # processus d’un utilisateur
ps -faux       # vue en arbre complète
```

### 🔪 Terminer un processus

```bash
kill <pid>         # envoie SIGTERM (15) par défaut
kill -9 <pid>      # envoie SIGKILL (mort immédiate)
kill -2 <pid>      # équivalent Ctrl+C (SIGINT)
```

### 🔁 Terminer par nom de commande

```bash
pkill firefox      # tue tous les processus nommés "firefox"
```

### 🧵 Processus en arrière-plan

```bash
commande &         # exécution en tâche de fond
jobs -l            # liste les jobs (avec PID)
nohup commande &   # détache du terminal + log dans nohup.out
```

### ⏱️ Mesurer le temps d’exécution

```bash
time commande
```

---

## 🔄 Redirections Bash

### 🔀 Types de flux

|Nom|Abréviation|Descripteur|
|---|---|---|
|Entrée standard|stdin|0|
|Sortie standard|stdout|1|
|Sortie erreur|stderr|2|

### 📤 Redirections simples

```bash
commande > sortie.txt         # stdout vers fichier
commande >> sortie.txt        # ajout
commande 2> erreur.txt        # stderr vers fichier
commande &> tout.txt          # stdout + stderr
commande 2>&1                 # stderr vers stdout
```

### 📥 Redirection d’entrée

```bash
commande < fichier.txt
```

### 📑 Double affichage avec `tee`

```bash
commande | tee -a log.txt     # affiche + écrit dans log.txt
```

---

## 📦 Archivage et compression avec `tar`

### 📁 Créer une archive

```bash
tar -cvf archive.tar fichier1 fichier2 dossier/
```

### 📚 Ajouter des fichiers à une archive existante

```bash
tar -uvf archive.tar nouveau.txt
```

### 📦 Compression gzip / bzip2

```bash
tar -czf archive.tar.gz dossier/
tar -cjvf archive.tar.bz2 fichier*
```

### 📂 Extraire une archive

```bash
tar -xf archive.tar.gz
```

### 📋 Lister le contenu

```bash
tar -tf archive.tar.gz
```

### 📍 Emplacement personnalisé

```bash
tar -xvf archive.tar.gz -C mon_dossier
```

---

## ⚙️ Alias dans Bash

### 🧷 Créer des alias

```bash
alias ll='ls -l'
alias rm='rm -i'
alias ipa="ip address show dev ens33 | grep 'inet '"
```

### 📁 Sauvegarde dans `~/.bashrc`

```bash
vim ~/.bashrc
# Ajouter les alias en fin de fichier
. ~/.bashrc     # ou source ~/.bashrc
```

### ❌ Supprimer un alias

```bash
unalias ll
```

---

## 📌 Variables Bash avancées

### 🧠 Déclaration et lecture

```bash
prenom="Romain"
echo $prenom
```

### 🌍 Exporter dans l’environnement

```bash
export prenom
```

### ❌ Supprimer une variable

```bash
unset prenom
```

### 📆 Variable depuis commande

```bash
heure=$(date +%Hh%M)
```

### 🛤️ Variable PATH

```bash
echo $PATH
/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
```

---

## ✅ À retenir pour les révisions

- `ps`, `jobs`, `kill`, `pkill`, `nohup`, `time` pour gérer les processus
- `>`, `2>`, `>>`, `&>`, `| tee` pour rediriger les flux
- `tar` permet d’archiver, compresser, extraire
- `alias` raccourcit les commandes répétitives, et s’intègre dans `.bashrc`
- Les variables sont locales par défaut, utilisables via `$var`, et exportables avec `export`

---

## 📌 Bonnes pratiques professionnelles

- Toujours vérifier les PID avant de `kill`
- Utiliser `nohup` pour les scripts longs en tâche de fond
- Documenter clairement les alias dans `.bashrc`
- Ne jamais ajouter de chemins non sûrs dans `$PATH`
- Préférer `$(commande)` à la syntaxe obsolète `` `commande` ``

---

## 🔗 Liens utiles

- [Cheat.sh – Bash redirections](https://cheat.sh/bash+redirection)
- [Cheat.sh – tar](https://cheat.sh/tar)