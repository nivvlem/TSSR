# Gestion de parc & Inventaire informatique
## 🧩 Les éléments d’inventaire

GLPI permet d’inventorier **tous les éléments du SI** :

|Élément|Description|
|---|---|
|Ordinateurs|Fixes, portables, serveurs|
|Composants|CPU, RAM, disques…|
|Logiciels & licences|Logiciels installés et leur gestion de licences|
|Moniteurs|Écrans associés aux postes|
|Matériel réseau|Switchs, routeurs, firewalls, bornes Wi-Fi|
|Imprimantes|Avec gestion des consommables|
|Téléphones|Fixes, mobiles|
|Périphériques|Autres matériels connectés|
|Centres de données|Baies, onduleurs, serveurs rackés|

---

## 🏷️ Plan de nommage

### Pourquoi ?

- Permet une **recherche rapide**
- Facilite les **rapprochements** (factures, étiquetage, supervision)
- Doit être **homogène et documenté**

### Exemple de convention

```text
Type Service DateAchat Index
Exemple : PC DIR 202503 012
```

- PC = type matériel
- DIR = Direction
- 202503 = Mars 2025
- 012 = n° d’inventaire

---

## 🛠️ Gestion des ordinateurs

### Composants

- Gestion **par composant** : RAM, CPU, carte réseau…
- Gérés dans **Configuration > Composants**
- Peuvent être remplis dynamiquement via un outil d’inventaire (FusionInventory, OCS)

### Logiciels & licences

1️⃣ Créer une **catégorie** de logiciel (ex: Bureautique)  
2️⃣ Créer le **logiciel** (ex: Office)  
3️⃣ Créer la **version** (ex: Office 365 ProPlus)  
4️⃣ Créer les **licences** (quantité, clé, affectation poste)

### Connexions

- **Connexions physiques** : USB, HDMI…
- **Connexions réseau** : Ethernet, Wi-Fi, VLAN
- Permet de modéliser le **réseau physique** et logique

### Ports réseau

- Création de **ports réseau** sur les éléments matériels
- Permet la **cartographie réseau complète**

---

## 🖥️ Gestion des moniteurs

- Renseignements : modèle, fabricant, type, taille, connectique
- Liaison avec un **utilisateur ou un poste**
- Gestion globale ou unitaire

---

## 🌐 Gestion du matériel réseau

- Types : switch, routeur, firewall, AP Wi-Fi…
- Importance des **ports réseau** pour cartographier les liaisons
- Utilisation de **gabarits** pour modèles courants

---

## 🖨️ Gestion des imprimantes

- Gestion complète :
    - Caractéristiques
    - **Consommables** (cartouches)
    - Connexions réseau ou directe
    - Usagers associés

### Gestion des consommables

1️⃣ Créer le **modèle de l’imprimante**  
2️⃣ Créer le **modèle de cartouche**  
3️⃣ Ajouter les **cartouches** en stock  
4️⃣ Installer les **cartouches sur l’imprimante**  
5️⃣ Suivre la **durée de vie** et les niveaux d’alerte

---

## 📞 Téléphones & périphériques

- Gestion de **tous les équipements non standards**
- Liaison directe et réseau possible
- Associable à un ticket
- Périphériques : casques, tablettes, terminaux divers

---

## 🏢 Gestion des centres de données

- **Datacenters**, salles serveurs
- **Baies** avec U (rack)
- Matériel racké : serveurs, PDU (onduleurs), appliances
- Gestion des **emplacements physiques**

### Exemple de création

1️⃣ Créer un **datacenter**  
2️⃣ Créer une **salle serveur**  
3️⃣ Créer une **baie** (ex: 42U)  
4️⃣ Créer le matériel racké (avec modèle et image)

---

## 📆 Gestion des réservations

- Tout matériel peut être rendu **réservable**
- Exemples : salles, vidéoprojecteurs, PC portables…
- Statuts :
    - Disponible
    - Indisponible
    - Réservable ou non autorisé

---

## 🧰 Gabarits et automatisation

### Gabarits

- **Pré-remplissage** de champs pour un modèle d’équipement
- Exemple : modèles de PC fixes Lenovo M720
- Simplifie la saisie **massive** d’équipements

### Incrémentation automatique

- Format `<XXX####>`
- Exemples :

```text
PC-2023-####
SERV-\Y-\m-###
```

- Variables :
    - `\Y` = année (4 chiffres)
    - `\y` = année (2 chiffres)
    - `\m` = mois
    - `\d` = jour

---

## ⚙️ Champs récurrents importants

|Champ|Usage|
|---|---|
|Nom|Identifiant unique|
|Lieu|Position géographique|
|Statut|En stock, en prod, réformé...|
|Type|Catégorie (PC, serveur, imprimante...)|
|Fabricant|Marque|
|Modèle|Modèle commercial|
|N° inventaire|N° interne ou externe|
|Responsable|Responsable technique|
|Utilisateur|Usager du matériel|
|Commentaire|Notes diverses|

---

## ✅ À retenir pour les révisions

- L’inventaire GLPI permet une gestion **très fine** du parc
- Un **plan de nommage clair** est indispensable
- Les **connexions réseau** permettent la **cartographie physique**
- Les **gabarits** facilitent l’ajout de matériel
- Tous les éléments peuvent être **réservables**

---

## 📌 Bonnes pratiques professionnelles

- **Documenter** le plan de nommage
- Renseigner systématiquement les **champs critiques** (lieu, statut...)
- Centraliser la gestion des **logiciels & licences**
- Utiliser les **gabarits** pour automatiser la saisie
- Tenir à jour la **cartographie réseau**
- Réaliser des **revues régulières** du parc (audit)
- Sauvegarder les **données de l’inventaire** (base GLPI + `/var/lib/glpi`)
