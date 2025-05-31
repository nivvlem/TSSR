# Présentation des plug-ins – Inventaire avec FusionInventory
## 🧩 Présentation des plug-ins dans GLPI

### Pourquoi utiliser des plug-ins ?

- Étendre les fonctionnalités de GLPI **sans modifier le cœur** de l’application

### Principaux domaines couverts par les plug-ins

|Domaine|Exemples|
|---|---|
|Rapports / Graphiques|Dashboards, statistiques|
|Inventaire|FusionInventory, OCS Inventory|
|Réseau|Découverte SNMP, Wake-on-LAN|
|Gestion administrative|Budgets avancés, contrats|
|HelpDesk|Escalades avancées, templates de notifications|
|Import|Data Injection|

### Catalogue officiel

- [https://plugins.glpi-project.org/](https://plugins.glpi-project.org/)

---

## 🚀 Installation des plug-ins

### Installation manuelle

1️⃣ Télécharger le plugin depuis le **catalogue officiel**  
2️⃣ Extraire dans :

```text
/var/www/glpi/plugins
```

3️⃣ Activation dans **GLPI > Configuration > Plugins**

### Installation via Marketplace (recommandée)

1️⃣ Inscription gratuite sur :

```text
https://services.glpi-network.com/register
```

2️⃣ Récupérer la clé d’enregistrement  
3️⃣ Coller dans **Configuration > Générale**  
4️⃣ Accéder au **Marketplace** depuis l’interface GLPI

### Attention

- Chaque version de plugin est **liée à une version GLPI**
- Une mise à jour GLPI peut nécessiter la mise à jour des plug-ins !

---

## 🛠️ Plugin FusionInventory

### Rôle

- Automatiser l’**inventaire matériel et logiciel**
- Déploiement d’applications
- Découverte réseau (SNMP)
- Wake-on-LAN

### Architecture

|Élément|Rôle|
|---|---|
|Plugin GLPI|Partie serveur, reçoit les données|
|Agent FusionInventory|Client installé sur les postes|

### Clients disponibles

- Windows
- Linux
- macOS
- Android

### Communication

- Modèle **client/serveur**
- **Protocole HTTP** (documents XML)
- L’agent contacte le serveur à **intervalle régulier**
- Le serveur peut **réveiller l’agent** (Wake-on-LAN)

---

## ⚙️ Préparation de l’inventaire automatique

### 1️⃣ Préparer le serveur GLPI

- Installer le plugin **FusionInventory**
- Vérifier l’état dans **Configuration > Plugins**

### 2️⃣ Préparer les dictionnaires et règles

#### Dictionnaires

**Administration > Dictionnaires**

- Harmonisation des valeurs collectées (modèles, fabricants...)

#### Règles Fusion

**Administration > Fusion > Règles**

|Règle|Objectif|
|---|---|
|Règles d’informations ordinateur|Modifier dynamiquement les infos collectées|
|Règles de lieu|Affecter automatiquement un **lieu** aux équipements|
|Règles sur l’entité ordinateur|Affecter automatiquement une **entité**|
|Règles d’import et de liaison des matériels|Contrôler ce qui est importé et mis à jour|
|Matériels ignorés durant l’import|Équipements à ignorer lors de la découverte|

### 3️⃣ Cohérence utilisateur ↔ ordinateur

- **Maintenir la relation logique** : qui utilise quoi ?
- Règles d’affectation adaptées (UserPrincipalName, adresse IP, MAC...)

### 4️⃣ Gestion du volume

- L’inventaire automatique génère beaucoup d’informations !
- Nécessité de **limiter ce qui est utile** :
    - Liste noire
    - Règles d’import précises

---

## 🔍 Forçage d’un inventaire (agent)

### Sous Windows

```powershell
"C:\Program Files\FusionInventory-Agent\fusioninventory-agent.exe" --force --no-task-network --no-task-deploy --server=http://monserveurglpi/glpi/plugins/fusioninventory/
```

### Log de l’agent

```text
C:\Program Files\FusionInventory-Agent\fusioninventory-agent.log
```

---

## 📥 Plugin Data Injection

### Rôle

- Permet **d’injecter des données** dans GLPI depuis un fichier `.csv`

### Ce qu’on peut importer

|Importable|Exemple|
|---|---|
|Ordinateur|Parc existant|
|Imprimante|Gestion des imprimantes|
|Matériel réseau|Switchs, AP...|
|Téléphone|Mobiles|
|Périphériques|Casques, webcams...|
|Utilisateurs|Import de masse|
|Groupes|Import des groupes AD|
|Licences|Gestion des licences|
|...|Contrats, Fournisseurs, Documents...|

### Ce qu’on ne peut pas importer

- Données liées au HelpDesk :
    - Catégories de tickets
    - Tickets eux-mêmes
    - Base de connaissance

### Processus d’utilisation

1️⃣ Créer un **modèle d’import**  
2️⃣ Préparer un fichier `.csv` :

- **UTF-8** (Linux) ou **ISO8859-1** (Windows)
- Respecter l’ordre logique : fabricant → composant → équipement

3️⃣ Correspondance colonnes ↔ champs GLPI  
4️⃣ Procéder à l’import

### Attention

- Droits des utilisateurs importants !
- Si un utilisateur ne peut pas créer un composant, il ne sera pas créé

### Quand utiliser Data Injection ?

- Utile pour **importer un existant** (migration initiale)
- Moins utile si vous utilisez déjà **FusionInventory** (redondance possible)

---

## ✅ À retenir pour les révisions

- Les **plug-ins** étendent les fonctionnalités sans modifier le cœur de GLPI
- **FusionInventory** est la solution la plus courante pour l’inventaire auto
- Préparer les **dictionnaires** et **règles** est crucial pour un inventaire cohérent
- L’agent FusionInventory fonctionne en **client/serveur**, en HTTP
- **Data Injection** permet d’importer facilement des données tierces

---

## 📌 Bonnes pratiques professionnelles

- **Documenter** les versions des plugins installés
- Vérifier la **compatibilité** plugin ↔ version GLPI avant chaque mise à jour
- Ne jamais activer **toutes les tâches FusionInventory** par défaut (maîtriser le volume)
- Construire et tester les **règles de lieu** et d’entité avant déploiement large
- Planifier les **scans réseau** de manière contrôlée (risques de saturation)
- Prioriser les imports via **FusionInventory** (auto-maintenance) → utiliser Data Injection uniquement pour les imports “one-shot” ou métiers spécifiques
- Bien gérer les **droits** sur les tâches d’import et d’inventaire
- Mettre en place une **politique de révision des règles** (au fil des évolutions du SI)
