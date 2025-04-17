# Administration Windows Server

## 🧱 1. Installation de Windows Server

### Prérequis
- Image ISO de Windows Server (ex. : `en_windows_server_2019_x64.iso`)
- Logiciel de virtualisation (VMware Workstation, VirtualBox...)
- Minimum 1 disque dur virtuel configuré
- Accès à un clavier, souris, et un affichage graphique

### Étapes principales
1. **Création de la VM**
   - Attribuer un nom, définir la RAM (ex. 4 Go), CPU (2 cœurs), disque virtuel (ex. 40 Go).
2. **Démarrage de la VM**
   - Boot sur l’ISO.
   - Appuyer sur une touche pour lancer l’installation.

3. **Configuration initiale**
   - Langue : Anglais (installation)
   - Clavier : Français
   - Fuseau horaire : Paris

4. **Choix de l'édition**
   - Ex. : Windows Server 2019 Standard (Desktop Experience)

5. **Type d’installation**
   - Choix : `Custom: Install Windows only (advanced)`

6. **Installation**
   - Choix du disque, validation de la licence, début de l’installation.

7. **Post-installation**
   - Définition du mot de passe administrateur
   - Connexion à la session (`Ctrl + Alt + Inser`)

8. **VMware Tools (optionnel mais recommandé)**
   - Ajout du presse-papier, glisser-déposer...
   - Nécessite un redémarrage

---

## 🧰 2. Ajout de rôles et de fonctionnalités

### Objectif
Configurer le serveur avec des services utiles (ex. : WDS, sauvegarde…).

### Étapes
1. **Lancement du gestionnaire de serveur**
   - Le Server Manager démarre automatiquement à la connexion.

2. **Ajout de rôles**
   - Menu `Gérer > Ajouter des rôles et fonctionnalités`
   - Choix du serveur local
   - Exemple : `Windows Deployment Services (WDS)`
   - Ajout automatique des dépendances si nécessaire

3. **Ajout de fonctionnalités**
   - Ex. : `Windows Server Backup`

4. **Options supplémentaires**
   - Redémarrage automatique du serveur si requis
   - Suivi de l’installation jusqu’à la fin

---

## 💾 3. Gestion du stockage & disques

### Objectif
Gérer les volumes, partitions, RAID logiciels depuis l'interface Windows.

### Étapes

#### 🧩 Ajout de disques
- Depuis VMware : ajout de 3 disques de 20 Go
- Vérification dans la configuration matérielle de la VM

#### ⚙️ Mise en ligne et initialisation
- Accès via `Server Manager > Tools > Computer Management > Disk Management`
- Mise en ligne des disques
- Initialisation en GPT

#### 📁 Types de volumes

| Type | Nom | Disques | Description |
|------|-----|---------|-------------|
| Volume fractionné | Volume Fractionné (F:) | 2 | Combine plusieurs disques, non redondant |
| RAID 0 | RAID0 (G:) | 2 | Performances ↑, mais sans tolérance de panne |
| RAID 1 | RAID1 (H:) | 2 | Miroir (tolérance de panne ↑, stockage ÷ 2) |
| RAID 5 | RAID5 (E:) | 3 | Performances et redondance avec parité |

#### 🔄 Vérification
- Vérification visuelle des volumes dans le gestionnaire de disques
- Formatage avec étiquette (label) de volume

---

## 🧠 Synthèse

| Étape | Action principale | Objectif |
|-------|-------------------|----------|
| 1. Installation | Déployer le système | Base du serveur |
| 2. Rôles | Ajouter des services | Rendre le serveur utile |
| 3. Stockage | Gérer les volumes | Organiser les données |

---

## 📌 Bonnes pratiques
- Toujours prendre des **instantanés de VM (snapshots)** avant des opérations sensibles
- Choisir la **version Desktop Experience** si interface graphique nécessaire
- Préférer l’**initialisation GPT** pour les disques > 2 To ou futurs RAID
- Documenter chaque étape pour reproductibilité (comme ici 😉)

---

## 🔗 Aller plus loin
- [Documentation Microsoft Windows Server](https://learn.microsoft.com/fr-fr/windows-server/)