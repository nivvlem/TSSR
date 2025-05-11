# TP – Installation, sauvegarde et restauration avec Backup Exec

## Partie 1 – Installation et configuration de Backup Exec

### 🔹 Sur `SRV-AD1`

- Créer un **utilisateur de test dans l’Active Directory**
- Tester la connexion avec ce compte sur le domaine

### 🔹 Sur `SRV-BACKUP`

#### Installation de Backup Exec

- Lancer le **setup**
- Options à choisir :
    - Langue : Français
    - Type : **Personnalisée**
    - Menu : **Installation locale du logiciel + fonctions**
    - Ignorer les warnings environnement
    - Avancer sans licence (valider infobulle)
    - Composants à activer : NDMP, Advanced Disk-based Backup
    - Compte de service : **Administrateur du domaine**
    - SQL Server : créer une **instance locale de SQL Express**

#### Configuration iSCSI

- Ouvrir l’**Initiateur iSCSI** > onglet Découverte > Ajouter le portail `192.168.30.1`
- Cible > Connexion (laisser par défaut) > Vérifier que le statut est **connecté**
- Formater le nouveau **disque iSCSI (80 Go)** dans le Gestionnaire de disques

#### Création du stockage Backup

- Onglet **Stockage > Configurer le stockage**
    - Type : Stockage sur disque
    - Nom : `backup`
    - Emplacement : le disque iSCSI nouvellement formaté
    - Écriture simultanée : 4

#### Ajout de serveurs et création des jobs

- `Serveurs et hôtes virtuels > Ajouter > Ajouter un serveur`
    - Type : Microsoft Windows
    - Cible : `SRV-AD1` (mise à jour agent = Oui)
- Créer un **job de sauvegarde** :
    - Type : complète puis incrémentale
    - Stockage : basé sur disque
    - Nom : `srv-ad1 job`
    - Sauvegarde complète initiale immédiate : Oui
- Répéter l’opération pour `SRV-FIC1`
    - Type : sauvegarde complète uniquement
    - En cas d’erreur (code `0xe00086ce`) :
        1. Copier `C:\Program Files\Veritas\Backup Exec\Agents` vers `C:\` sur `SRV-FIC1`
        2. Exécuter `C:\Agents\RAWSX64\setup.exe`
        3. Réessayer l’ajout depuis `SRV-BACKUP`

---

## Partie 2 – Restauration et duplication

### 🔹 Restauration granulaire dans Active Directory

- Supprimer l’utilisateur créé précédemment depuis `SRV-AD1`
- Depuis Backup Exec :
    - Lancer une **restauration granulaire** > sélectionner **utilisateur supprimé uniquement**
    - Restaurer l’utilisateur dans son **emplacement d’origine**
    - Valider la restauration et **tester une reconnexion** avec cet utilisateur

### 🔹 Mise en place d’un partage NTFS externe

- Sur `SRV-FIC1`, ajouter un **HDD de 45 Go** via Hyper-V
- Créer un **dossier partagé** nommé `backup-fic1`

### 🔹 Duplication depuis `SRV-BACKUP`

- Ajouter `\\SRV-FIC1\backup-fic1` au **pool de stockage** dans Backup Exec
- Modifier le **job de sauvegarde srv-ad1** :
    - Après la sauvegarde complète : **dupliquer vers `backup-fic1`**
    - Après chaque incrémentale : **dupliquer également**
- Lancer une nouvelle **sauvegarde complète** pour valider la duplication

---

## ✅ À retenir pour les révisions

- Backup Exec permet la **sauvegarde complète, incrémentale et la duplication** vers stockage secondaire
- La **restauration granulaire** est essentielle pour Active Directory
- Les partages iSCSI et NTFS sont gérés comme des **cibles de stockage distinctes**

---

## 📌 Bonnes pratiques professionnelles

- Toujours tester la **restauration granulaire** sur comptes critiques
- Nommer clairement les jobs (`srv-ad1 job`, `duplication fic1`, etc.)
- Conserver une trace écrite des **mises à jour d’agents** et des erreurs rencontrées
- Séparer les **volumes de stockage principal et de duplication**
- Programmer les duplications à horaires décalés des sauvegardes principales

---

## 🔗 Outils / composants utilisés

- Veritas Backup Exec (console, agent, stockage)
- iSCSI Initiator
- Console AD / DNS
- Gestionnaire de disques
- Partage NTFS via Hyper-V (FIC1)
- SQL Express (intégré)