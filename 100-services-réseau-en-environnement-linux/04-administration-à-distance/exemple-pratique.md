# TP  – Configuration du service SSH (Debian 12)

## 🧪 Étape 1 – Installation du serveur SSH sur tous les serveurs Debian

### 🔹 Machines concernées

- **Deb-S1**
- **Deb-S2**
- **RouTux**

### 🔹 Mise à jour du dépôt `sources.list`

Fichier : `/etc/apt/sources.list`

```bash
deb http://ftp.fr.debian.org/debian/ buster main
deb http://security.debian.org/debian-security buster/updates main
deb http://ftp.fr.debian.org/debian/ buster-updates main
```

### 🔹 Commandes à exécuter

```bash
apt update && apt install openssh-server -y
```

Vérification :

```bash
systemctl status ssh
```

✔️ Le service SSH doit être actif (`active (running)`)

---

## 🖥️ Étape 2 – Configuration d’un terminal centralisé avec Terminator

### 🔹 Sur la machine **Cli-db-12**

```bash
apt install terminator
```

- Lancer Terminator pour ouvrir plusieurs sessions vers les serveurs à administrer

---

## 🔐 Étape 3 – Authentification par clés SSH (connexion sans mot de passe)

### 🔹 Génération de la clé SSH sur **Cli-db-12**

```bash
ssh-keygen
```

- Ne pas saisir de phrase de passe pour permettre l’automatisation

### 🔹 Copie de la clé vers les utilisateurs des serveurs

```bash
ssh-copy-id user@192.168.100.11  # Deb-S1
ssh-copy-id user@192.168.100.12  # Deb-S2
ssh-copy-id user@192.168.100.13  # RouTux
```

✔️ Connexion possible sans mot de passe :

```bash
ssh user@192.168.100.11
```

### 🔹 Accès root sans mot de passe (optionnel)

```bash
su -
mkdir -p /root/.ssh
chmod 700 /root/.ssh
cp /home/user/.ssh/authorized_keys /root/.ssh/
```

Effectuer ces opérations sur **Deb-S1**, **Deb-S2** et **RouTux**.

---

## 📁 Étape 4 – Utilisation de `scp` pour copier des fichiers

### 🔹 Exemple : récupération du fichier `resolv.conf`

```bash
mkdir conf_deb-s1
scp root@192.168.100.11:/etc/resolv.conf conf_deb-s1/
```

✔️ Possibilité de centraliser les fichiers `/etc/network/interfaces`, `resolv.conf`, `sources.list`, etc.

---

## ✅ Vérifications finales

- SSH fonctionne sans mot de passe pour chaque utilisateur sur chaque serveur
- Les fichiers `.ssh/authorized_keys` sont bien copiés et accessibles à root si besoin
- Le service `ssh` est actif et configuré pour démarrer automatiquement
- L’utilisateur `cli-db-12` peut copier des fichiers avec `scp` entre toutes les machines Debian

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Ne pas autoriser la connexion root SSH directe|Réduire les risques de sécurité|
|Utiliser des clés SSH|Authentification plus robuste que les mots de passe|
|Tester chaque connexion après copie de clé|S’assurer du fonctionnement de l’automatisation|
|Copier et archiver les fichiers critiques|Facilite la restauration en cas de problème|
|Centraliser la supervision depuis un poste|Gain de temps et réduction des erreurs d’administration|
