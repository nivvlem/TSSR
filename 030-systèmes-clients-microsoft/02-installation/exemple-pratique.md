# TP  – Installation de Windows 10 sous VMware Workstation

## 🧪 Étape 1 – Préparer l'environnement

### 🔹 Création des dossiers

- `D:\ISO`
- `D:\Procédures`
- `D:\VMs-WorkStation`

### 🔹 Préparation des fichiers

- Copier l’ISO de Windows 10 dans `D:\ISO`
- Copier l’archive `Discovery.ova` (VM existante) dans `D:\VMs-WorkStation\Discovery`

---

## 🛠️ Étape 2 – Création de la VM Windows 10

### 🔹 Paramètres de la machine

| Élément             | Valeur                        |
| ------------------- | ----------------------------- |
| Type d'installation | Typical                       |
| OS invité           | Windows 10 x64                |
| Nom de la VM        | Win10-MD                      |
| Emplacement         | `C:\VMs-WorkStation\Win10-MD` |
| Disque dur          | 32 Go (Store as single file)  |
| RAM                 | 4 Go                          |
| Processeur          | 1 processeur, 1 cœur          |
| Réseau              | Host-Only                     |

✔️ Finaliser et vérifier que la VM apparaît bien dans VMware Workstation.

---

## 🖥️ Étape 3 – Installation de Windows 10 Professionnel

### 🔹 Support ISO

- Monter l’ISO Windows 10 dans le lecteur DVD virtuel de la VM.

### 🔹 Lancement de l’installation

- Démarrer la VM.
- Appuyer sur une touche pour booter sur l’ISO.

### 🔹 Enregistrement de l'installation

- Lancer l’outil **PSR** (`psr.exe`) avant de démarrer l'installation.
- Capturer l’ensemble du processus.
- Enregistrer le fichier dans `D:\Procédures\psr-install-Win10.zip`

### 🔹 Paramètres de l’installation

|Paramètre|Valeur|
|---|---|
|Langue|Français|
|Clavier|Français|
|Clé produit|Non renseignée (délai de grâce)|
|Version|Windows 10 Professionnel|
|Type d'installation|Personnalisée (installation avancée)|
|Partitionnement|Utiliser tout l’espace non alloué|

✔️ Patienter jusqu’aux redémarrages automatiques.

---

## ⚙️ Étape 4 – Configuration initiale de Windows 10

| Élément                                   | Paramètre choisi                             |
| ----------------------------------------- | -------------------------------------------- |
| Région                                    | France                                       |
| Clavier                                   | Français                                     |
| Connexion internet                        | Aucune pour l’instant (installation limitée) |
| Compte local                              | nivvlem                                      |
| Historique d’activités                    | Non                                          |
| Cortana                                   | Non                                          |
| Diagnostics et données                    | Envoi basique                                |
| Localisation, publicité, personnalisation | Tout désactivé                               |

---

## 🔧 Étape 5 – Finalisation post-installation

### 🔹 Installation des VMware Tools

- Menu VM > `Install VMware Tools`
- Dans la VM : ouvrir l’explorateur > Exécuter `setup64.exe`
- Suivre les étapes par défaut.
- Redémarrer la VM.

### 🔹 Nettoyage

- Éjecter l’ISO VMware Tools.
- Éteindre proprement la VM.

### 🔹 Snapshot

- Prendre un Snapshot nommé **TP1 terminé**.

---

## 📦 Étape 6 – Importer la VM Discovery

### 🔹 Processus

- Dans VMware Workstation > Open a Virtual Machine
- Sélectionner l'OVA `D:\VMs-WorkStation\Discovery\Discovery.ova`
- Importer dans `D:\VMs-WorkStation\Discovery`

### 🔹 Paramètres Discovery

|Élément|Valeur|
|---|---|
|Nombre de disques|4|
|RAM|4 Go|
|Processeur|1 processeur|
|Carte réseau|Host-Only|

### 🔹 Vérifications

- Lancer Discovery.
- Se connecter avec :

```bash
Utilisateur : adm
Mot de passe : Pa$$w0rd
```

- Exécuter `reinit.bat` en tant qu’administrateur.
- Redémarrer Discovery.
- Vérifier la présence des **VMware Tools** (Panneau de configuration > Programmes).

✔️ Discovery est prête pour une utilisation ultérieure.

---

## ✅ Vérifications finales

- Windows 10 est installé et configuré proprement sur Win10-XX.
- Les VMware Tools sont installés et actifs.
- Un Snapshot de référence a été créé.
- La VM Discovery est importée, fonctionnelle, et conforme aux attentes.

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Capturer toute installation critique|Documenter et faciliter la répétition des procédures|
|Prendre des snapshots réguliers|Revenir en arrière en cas d’erreur|
|Installer les VMware Tools dès que possible|Améliorer les performances et la compatibilité|
|Utiliser Host-Only pour les VMs isolées|Protéger le réseau physique et simuler des labos locaux|
|Utiliser l’outil PSR pour la documentation|Aide à la création de procédures internes claires|
