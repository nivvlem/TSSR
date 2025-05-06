# TP – Découverte de vSphere 

## 🛠️ Prérequis

- VMware Workstation 17 installé
- ISO d’ESXi 7.x (ex: `VMware-VMvisor-Installer-7.0U3…`)
- ISO de Windows Server 2019 disponible

---

## 🔧 Étapes de réalisation

### 1. Préparation

- Éteindre la VM `SRV_2K19` si elle est en cours d'exécution

### 2. Création d’ESXi1 dans VMware Workstation

- Créer une VM nommée `ESXi1`
    - Type : Autre / VMware ESXi 7
    - Dossier : `D:\Machines virtuelles\ESXi1`
    - Processeur : 2 CPU / 1 cœur
    - RAM : 6 Go
    - Réseau : carte bridgée
    - Disques :
        - 40 Go (principal)
        - 200 Go SCSI (supplémentaire)
    - Image ISO montée en CD/DVD

### 3. Installation d’ESXi1

- Lancer l’installation
- Choisir le disque de 40 Go
- Définir un mot de passe root complexe
- Noter l’adresse IP obtenue automatiquement

### 4. Création d’ESXi2

- Répéter les étapes précédentes pour une VM `ESXi2`
    - Dossier : `D:\Machines virtuelles\ESXi2`
    - Configuration identique

### 5. Accès à la console Web d’ESXi1

- Depuis l’hôte Windows, ouvrir un navigateur :
    ```
    https://192.168.10.200                                   #IP ESXi
    ```
- Accepter le certificat
- Se connecter avec le compte root

### 6. Création du datastore « DS-Local »

- Aller dans **Stockage** > **Créer un nouveau datastore VMFS**
    - Nom : `DS-Local`
    - Utiliser le disque de 200 Go ajouté à `ESXi1`

### 7. Import de l’ISO Windows Server 2019

- Naviguer dans le **Navigateur de banque de données** de `DS-Local`
- Télécharger l’ISO depuis l’hôte

### 8. Création d’une VM `SRV-1` sous ESXi1

- Aller dans **Machines virtuelles** > **Créer une VM**
    - Nom : `SRV-1`
    - OS invité : Windows Server 2019
    - CPU : 1 cœur
    - RAM : 2 Go
    - Disque : 32 Go (VMFS)
    - ISO : fichier présent dans `DS-Local`

### 9. Installation de Windows Server

- Démarrer la VM `SRV-1`
- Lancer l’installation depuis l’ISO

### 10. Installation des VMware Tools

- Depuis la console de vSphere, monter l’image des VMware Tools
- Installer dans `SRV-1`

---

## ✅ À retenir pour les révisions

- ESXi peut être installé **dans une VM** via Workstation pour des tests
- Un **datastore VMFS** doit être créé manuellement après l’ajout d’un disque
- Une ISO peut être stockée **dans une banque de données** pour l’installation des VMs
- L’interface Web permet la **gestion complète** des VMs (création, déploiement, stockage)

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Attribuer des noms explicites aux hyperviseurs et VMs|Améliore la lisibilité et la supervision|
|Utiliser une carte **bridgée** pour tester l’accès réseau réel|Permet la connectivité avec d'autres hôtes de test|
|Toujours créer un **datastore** dédié pour les VMs|Séparer les fichiers système de ceux des machines virtuelles|
|Installer les **VMware Tools** dans toutes les VMs|Meilleure compatibilité et intégration avec l’hyperviseur|
|Sauvegarder les ISO dans les datastores|Facilité de réutilisation lors de déploiements multiples|
