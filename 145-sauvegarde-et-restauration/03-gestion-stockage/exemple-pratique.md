# TP – Sauvegarde et restauration avec Veeam Backup & Replication

## 🛠️ Prérequis


- TP précédent réalisé (environnement complet fonctionnel)
- Port **445 (NP-in)** ouvert sur `SRV-HyperV`

---

## Étapes de réalisation

### 🔹 Sur `SRV-BACKUP`

#### 1. Préparation

- Désinstaller **Backup Exec** s’il est encore présent

#### 2. Installation de Veeam Backup & Replication v12

- Suivre l’assistant d’installation standard (configuration par défaut possible)

#### 3. Ajout du serveur Hyper-V

- Dans le menu **Inventory**, cliquer sur `Add Server`
    - **Nom** : `SRV-HyperV`
    - **Type** : Microsoft Hyper-V Server (Standalone)
    - **Identifiants** : `SRV-HyperV\Administrateur`
    - **Task Limit** : 4

> Vérifier que les VMs `SRV-AD1` et `SRV-FIC1` apparaissent bien une fois le serveur ajouté

---

### 🔹 Création d’un job de sauvegarde pour `SRV-FIC1`

- Menu **Home > Backup Job > Virtual Machine**
- Paramètres :
    - **Nom** : `SVGD-FIC1`
    - **VM** : `Srv-Fic1`
    - **Storage** : Default Backup Repository
    - **Task Limit** : 4
- Lancer l’exécution immédiate

### 🔍 Vérification

- Vérifier la complétion **sans erreur** du job

---

## 🔁 Restauration complète

### 1. Suppression manuelle de la VM

- Supprimer `SRV-FIC1` depuis Hyper-V (attention à bien noter ses paramètres avant)

### 2. Restauration via Veeam

- Depuis Veeam, lancer une **restauration complète** de la VM supprimée
- Choisir la dernière sauvegarde complète disponible
- Laisser les options par défaut (emplacement identique, nom identique)
- Attendre la fin de la restauration

### 3. Vérification post-restauration

- Vérifier que :
    - La VM `SRV-FIC1` redémarre correctement
    - Le réseau, les rôles installés et la connectivité sont pleinement fonctionnels

---

## ✅ À retenir pour les révisions

- Veeam permet la **sauvegarde complète et la restauration totale** d’une VM Hyper-V
- L’ajout d’un hôte Hyper-V s’effectue via le menu Inventory > Add Server
- Un job de sauvegarde peut être exécuté immédiatement après sa création
- La restauration d’une VM supprimée doit respecter ses **paramètres initiaux**

---

## 📌 Bonnes pratiques professionnelles

- Vérifier systématiquement le port 445 (NP-in) sur l’hôte Hyper-V
- Tester la **restauration complète** en environnement contrôlé
- Conserver les paramètres techniques de la VM supprimée (RAM, disque, nom, carte réseau)
- Utiliser des **noms clairs et normalisés** pour les jobs (`SVGD-FIC1`, `RSTR-FIC1`, etc.)

---

## 🔗 Outils et composants utilisés

- **Veeam Backup & Replication v12**
- Hyper-V (SRV-HyperV)
- VMs : `SRV-FIC1`, `SRV-AD1`
- Port 445 (NP-in)