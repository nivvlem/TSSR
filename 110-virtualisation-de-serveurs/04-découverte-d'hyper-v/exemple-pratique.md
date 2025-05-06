# TP – Découverte d’Hyper-V

## 🛠️ Prérequis

- Avoir la VM **SRV_2K19** opérationnelle
- Travailler dans un environnement VMware Workstation

---

## 🔧 Étapes de réalisation

### 1. Préparation de la VM SRV_2K19 (dans VMware Workstation)

- Augmenter la mémoire vive de la VM à **8 Go**
- Ajouter un second **disque dur SCSI** de **100 Go**
- Démarrer la VM SRV_2K19

### 2. Préparer le volume de données

- Ouvrir **Gestion des disques**
- Initialiser le disque et créer un volume **NTFS** nommé `DATA`
- Monter le volume (ici, `D:`)

### 3. Installation du rôle Hyper-V

```powershell
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart
```

- Lors de l’ajout du rôle, choisir la carte **ethernet0** comme **commutateur externe**
- Ne pas activer la migration à chaud

### 4. Définir les emplacements de stockage Hyper-V

Dans la console Hyper-V, aller dans **Paramètres Hyper-V** :

- Emplacement des VMs : `D:\VMs`
- Emplacement des disques : `D:\VHDs`

### 5. Préparation de l’ISO

- Placer l’ISO de Windows Server 2019 sur le **bureau** de la VM SRV_2K19

### 6. Création de la première VM : `SRV_2K19-HV1`

Dans la console Hyper-V :

- Nom de la VM : `SRV_2K19-HV1`
- Type : **Génération 2**
- Mémoire : **2 Go**, **non dynamique**
- Carte réseau : associée à l’interface **ethernet0** (commutateur externe)
- Disque : **32 Go**, au format **VHDX**, dans `D:\VHDs`
- Ajouter l’ISO du bureau pour l’installation

### 7. Installation du système

- Démarrer la VM `SRV_2K19-HV1`
- Lancer l’installation de Windows Server 2019 depuis l’ISO

### 8. Exécution de Sysprep (généralisation)

Dans la VM :

```powershell
cd C:\Windows\System32\Sysprep
./Sysprep.exe
```

- Cochez **Generalize**
- Sélectionnez **Shutdown**

### 9. Exportation de la VM

Dans Hyper-V :

- Exporter la VM vers : `D:\VMs\EXPORT\Machines virtuelles\SRV_2K19-HV1`

### 10. Importation pour créer `SRV_2K19-HV2`

- Importer la machine exportée
- Choisir : **Copier la machine virtuelle**
- Emplacement VM : `D:\VMs\SRV_2K19-HV2`
- Emplacement disques : `D:\VHDs\SRV_2K19-HV2`
- Renommer la VM importée : `SRV_2K19-HV2`

### 11. Test réseau entre les deux VMs

- Démarrer `SRV_2K19-HV1` et `SRV_2K19-HV2`
- Relever leurs adresses IP via `ipconfig`
- Tester la connectivité :

```powershell
ping
```

- En cas d’échec :
    - Vérifier que les **profils réseau** sont en **Privé**
    - Autoriser les **ICMP Echo** dans le pare-feu Windows

### 12. Snapshot (facultatif selon contexte)

- Créer un **instantané** de `SRV_2K19` depuis VMware Workstation
- Nom : `Fin atelier 2`

---

## ✅ À retenir pour les révisions

- Hyper-V peut fonctionner **dans une VM**, si la virtualisation imbriquée est activée
- L’exportation permet la **clonage sécurisé** d’une VM
- L’utilisation d’un **switch externe** permet la communication réseau réelle
- `Sysprep` est essentiel avant un **clonage** pour éviter les conflits d’identifiants système

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Créer une structure de dossiers claire|Facilite la gestion, l’export et les backups de VM|
|Toujours utiliser Sysprep avant un clone|Évite les conflits de SID dans Active Directory ou le réseau|
|Nommer rigoureusement les VMs|Utile pour l’automatisation et la supervision|
|Utiliser un **commutateur dédié**|Garantit une bonne séparation des réseaux virtuels et physiques|
|Prendre un **instantané avant modifications**|Permet un retour arrière rapide en cas de problème|
