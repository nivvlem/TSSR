# TP – Création de l'infrastructure de sauvegarde

## 🧰 Prérequis

- Disposer du rôle **Hyper-V activé** sur votre poste
- Avoir accès au partage `\\distrib` contenant les bundles VM à importer

---

## 🗂️ Étapes détaillées

### 📁 1. Organisation du stockage

1. Créer une arborescence dédiée sur le *disque D:* :
    - D:\VMs\SRV-Backup
    - D:\VMs\SRV-HyperV
    - D:\VMs\SRV-NAS
    - D:\VMs\SRV-AD1 (si nécessaire)
    - D:\VMs\SRV-FIC1 (si nécessaire)
    - D:\VMs\Routeur

### 🖥️ 2. Importation des VMs dans Hyper-V

Importer les VMs depuis le bundle fourni. L’importation doit être réalisée via **le gestionnaire Hyper-V** :

|Nom de VM|Système|Domaine / Groupe de travail|Login|Mot de passe|
|---|---|---|---|---|
|SRV-Backup|Windows Server 2019|Mondomaine.local|Administrateur|Pa$$w0rd|
|SRV-HyperV|Windows Server 2019|WORKGROUP|Administrateur|*|
|SRV-NAS|FreeBSD / TrueNAS|Mondomaine.local|admin|*|
|Routeur|FreeBSD / pfSense|Mondomaine.local|admin|*|
|SRV-AD1|Windows Server 2019|Mondomaine.local|Administrateur|*|
|SRV-FIC1|Windows Server 2019|Mondomaine.local|Administrateur|*|

📝 Remarque : les VMs **SRV-AD1** et **SRV-FIC1** peuvent être déjà intégrées dans **SRV-HyperV**.

---

## 🔎 3. Démarrage et vérification

1. Démarrer toutes les VMs.
2. Se connecter à toutes les machines avec :
    - Utilisateur : `Administrateur`
    - Mot de passe : `Pa$$w0rd`
3. Vérifier l’état réseau de chaque VM.

### 🔗 Connectivité à tester depuis **SRV-Backup**

- Ping vers :
    - SRV-AD1
    - SRV-FIC1
    - SRV-NAS

🛠️ Si nécessaire, ajuster les **pare-feu Windows** pour permettre les connexions ICMP entrantes.

---

## 🌐 4. Préparation de l’interface NAS

1. Depuis SRV-Backup, ouvrir un navigateur
2. Se connecter au portail **TrueNAS** : `https://192.168.30.1`
    - Login : `admin`
    - Mot de passe : `Pa$$w0rd`

### Vérifications système :

- Dans Paramètres Système > Console : exécuter :

```bash
sudo wbinfo -t
```

➡️ Ceci teste l’intégration dans le domaine AD.

### Activer le service iSCSI :

- Aller dans le menu **Services**
- Activer le **service iSCSI** pour les tests de stockage ultérieurs

---

## ✅ À retenir pour les révisions

- Toujours organiser l’emplacement des VMs dans des **dossiers distincts**
- Le **rôle Hyper-V** doit être activé pour pouvoir importer les machines
- Tester la **connectivité réseau** et les **services** (DNS, Web, ICMP) immédiatement après démarrage
- L’activation du **service iSCSI** sur le NAS est cruciale pour les futurs ateliers
- La **commande `wbinfo -t`** valide l’intégration Active Directory de TrueNAS

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Utiliser des noms de dossiers clairs|Facilite la gestion et le nettoyage de l’environnement|
|Nommer les VMs selon leur rôle|Aide à la documentation et au repérage rapide|
|Désactiver le pare-feu ou ajuster les règles|Garantir la communication entre les composants|
|Centraliser les machines sur un seul hôte Hyper-V|Réduit les risques d’erreurs de configuration réseau|
|Vérifier les services Web, DNS et ICMP|Valide le bon fonctionnement des futures sauvegardes|
