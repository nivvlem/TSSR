# TP – Mise en œuvre VMware Workstation

## 🧩 Étapes de réalisation

### 1. ✅ Vérification des prérequis

- OS hôte : Windows Server 2019
- Adressage IP configuré en DHCP
- VMware Workstation 17 est installé (vérifier via le menu Aide ou dans les applications installées)

### 2. 📁 Préparation de l’environnement

- Créer un dossier `D:\Machines virtuelles` pour stocker les VMs

### 3. 💻 Création de la machine virtuelle `SRV_2K19`

**Paramètres à configurer dans l’assistant :**

- Type de système : _Microsoft Windows_ > _Windows Server 2019_
- Nom : `SRV_2K19`
- Dossier : `D:\Machines virtuelles\SRV_2K19`
- Processeur : 2 CPU, 1 cœur par CPU
- RAM : 2 Go
- Carte réseau : _Bridged_
- Disque : 60 Go, _single file_
- Activer la virtualisation avancée : cocher _Virtualize Intel VT-x/EPT or AMD-V/RVI_

### 4. 📦 Montage du média d’installation

- Aller dans les paramètres de la VM > CD/DVD
- Choisir : _Use ISO image file_ > Naviguer vers `\\distrib\iso\os\windows\WindowsServer2019.iso`

### 5. 🚀 Installation du système

- Lancer la VM
- Démarrer depuis l’image ISO
- Choisir l’installation de **Windows Server 2019 avec Expérience utilisateur**

### 6. 🧰 Installation des VMware Tools

- Une fois Windows installé, aller dans `VM > Install VMware Tools`
- Suivre l’assistant d’installation dans la VM
- Redémarrer la VM

### 7. 💾 Finalisation

- Nommer la VM dans Windows (ex : `SRV-2K19`)
- Arrêter proprement la VM depuis le menu `Démarrer > Arrêter`
- Créer un snapshot : `VM > Snapshot > Take Snapshot`, le nommer **Fin Atelier 1**

---

## ✅ À retenir pour les révisions

- Toujours créer un dossier dédié pour organiser ses machines
- Activer les options de virtualisation matérielle dans les paramètres VM
- Le mode _bridged_ permet à la VM d’être sur le même réseau que l’hôte
- L’installation des VMware Tools améliore la compatibilité, les performances, et l’ergonomie
- Créer des snapshots permet de revenir en arrière rapidement

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Stocker les VMs sur une partition dédiée|Améliore les performances, évite la saturation du disque système|
|Toujours utiliser des ISO depuis des sources fiables|Réduit les risques de corruption ou infection|
|Documenter les réglages de chaque VM|Facilite le support et la reproduction de l’environnement|
|Faire un snapshot avant chaque changement majeur|Permet un retour rapide en cas d’erreur|
