# TP – Création de l’infrastructure de sauvegarde

## 🛠️ Prérequis

- Accès au **Gestionnaire Hyper-V**
- Accès au partage réseau `\\distrib`

---

## 🗂️ Étapes 1 à 2 – Préparation de l’environnement Hyper-V

1. Créer une **arborescence de stockage dédiée** sur `D:\` :
    - Exemple : `D:\TP_Sauvegarde\SRV-BACKUP`, `D:\TP_Sauvegarde\SRV-NAS`, etc.
2. Importer les machines virtuelles disponibles dans le bundle fourni :
    - Les machines **SRV-AD1** et **SRV-FIC1** sont déjà incluses dans la VM **SRV-HyperV**
    - À importer :

|Nom VM|OS / Distribution|Domaine|Utilisateur|Mot de passe|
|---|---|---|---|---|
|SRV-BACKUP|Windows Server 2019|mondomaine.local|Administrateur|Pa$$w0rd|
|SRV-NAS|FreeBSD (TrueNAS)|mondomaine.local|admin|*|
|SRV-ROUTEUR|FreeBSD (pfSense)|mondomaine.local|admin|*|
|SRV-HyperV|Windows Server 2019|WORKGROUP|Administrateur|*|

---

## 🧪 Étape 3 – Vérification et finalisation

### 3.1 Démarrage et connexion aux VMs

- Démarrer toutes les VMs : `SRV-BACKUP`, `SRV-NAS`, `SRV-ROUTEUR`, `SRV-AD1`, `SRV-FIC1`
- Se connecter à chaque VM avec :
    - `Administrateur / Pa$$w0rd`

### 3.2 Vérification de la connectivité

- Depuis `SRV-BACKUP`, tester les connexions vers :
    - `SRV-AD1`
    - `SRV-FIC1`
    - `SRV-NAS`
- Adapter les pare-feu Windows si nécessaire pour permettre les **pings entrants/sortants**

---

## 🔧 Étape 4 – Préparation du NAS (depuis SRV-BACKUP)

### 4.1 Accès au portail TrueNAS

- Ouvrir un navigateur
- Accéder à l’URL : `https://192.168.30.1`
- Connexion : `admin / Pa$$w0rd`

### 4.2 Vérification intégration AD

- Aller dans **Paramètres système > Console**
- Exécuter la commande :

```bash
sudo wbinfo -t
```

- Si le test est réussi, l’intégration à l’Active Directory est confirmée ✅

### 4.3 Activation du service iSCSI

- Naviguer vers **Services** > activer **iSCSI**
- Vérifier que le service démarre automatiquement

---

## ✅ À retenir pour les révisions

- Une infrastructure de test bien structurée permet de simuler un environnement de sauvegarde réaliste
- L’intégration AD du NAS est essentielle pour les futures opérations d’authentification et de permissions
- Chaque VM a un rôle spécifique (contrôleur AD, serveur de fichier, NAS, Hyper-V)

---

## 📌 Bonnes pratiques professionnelles

- Créer une **arborescence logique et lisible** pour les VMs
- Documenter les **IPs, rôles, utilisateurs** de chaque VM dès la mise en place
- Vérifier systématiquement la **connectivité inter-VM** avant tout déploiement logiciel
- Tester l’intégration AD et la disponibilité réseau des services essentiels (NAS, DNS…)

---

## 🔗 Outils / composants utilisés

- Hyper-V (Windows 10/11 Pro ou Windows Server)
- TrueNAS (192.168.30.1, accès web)
- pfSense (serveur routeur, utilisé dans les prochaines étapes)
- Navigateur (accès portail TrueNAS)
- Commande : `sudo wbinfo -t`