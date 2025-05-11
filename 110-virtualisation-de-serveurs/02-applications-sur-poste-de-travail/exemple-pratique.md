# TP – Mise en situation VMware Workstation

## 📝 Étapes

### 1. Vérification de l’environnement

- Vérifier que **VMware Workstation 17** est bien installé sur la machine physique (Windows Server 2019).
- S’assurer que **la virtualisation est activée dans le BIOS** (Intel VT-x ou AMD-V).

### 2. Création d’un dossier de stockage

- Créer un dossier `D:\Machines virtuelles` destiné à contenir toutes les VMs futures.

### 3. Création de la VM `SRV_2K19`

#### Paramètres à appliquer :

- **Système invité** : Windows Server 2019
- **Nom de la VM** : `SRV_2K19`
- **Stockage** : `D:\Machines virtuelles\SRV_2K19`
- **CPU** : 2 processeurs / 1 cœur
- **Mémoire RAM** : 2 Go
- **Disque dur** : 60 Go en **single file**
- **Carte réseau** : mode **Bridged**
- **Option CPU** : cocher "Virtualize Intel VT-x/EPT or AMD-V/RVI"

### 4. Configuration du média d’installation

- Récupérer le fichier ISO de Windows Server 2019 à partir du partage réseau `\\distrib\iso\os\windows\`.
- Ajouter ce fichier ISO comme **CD-ROM bootable** dans la VM.

### 5. Installation de l’OS

- Démarrer la VM sur l’ISO.
- Installer **Windows Server 2019** en mode **Expérience utilisateur (Desktop Experience)**.

### 6. Installation des VMware Tools

- Une fois l’OS installé, insérer les **VMware Tools** via `VM > Install VMware Tools`.
- Suivre l’assistant d’installation à l’intérieur de la VM.

### 7. Finalisation

- Éteindre proprement la VM.
- Renommer clairement la VM.
- Créer un **snapshot nommé “Fin Atelier 1”** :
    - Clic droit sur la VM > Snapshots > Take Snapshot

---

## ✅ À retenir pour les révisions

- Toujours choisir **un emplacement personnalisé** et bien structuré pour stocker ses VMs.
- Utiliser **l’option d’installation manuelle** pour un meilleur contrôle.
- Le mode **bridged** permet une intégration réseau totale comme une machine physique.
- Les **VMware Tools** sont essentiels pour les performances, la résolution graphique et l’intégration.

---

## 📌 Bonnes pratiques professionnelles

- Organiser les VMs dans des **dossiers nommés selon les projets ou systèmes**.
- Utiliser des noms de VM **cohérents et explicites**.
- Toujours créer un **snapshot après configuration** initiale stable.
- Activer les options de virtualisation avancées pour compatibilité maximale avec les OS modernes.
