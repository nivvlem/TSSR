# TP – Gestion de parc
## 🧾 Prérequis

- GLPI fonctionnel avec **structure d’entités et de lieux** déjà en place
- OUs et utilisateurs **AD** créés

---

## 🏗️ Étapes détaillées

### 1️⃣ Datacenter et salle serveur

#### a) Centre de données

- Nom : `Olympus datacenter`
- Lieu : **Salle des trésors**

#### b) Salle serveur

- Salle `Salle serveur 1`
- 1 ligne, 1 colonne de baies

---

### 2️⃣ Gabarit Serveurs Proliant DL380 GEN

- Gabarit : `GAB-Proliant-DL380-GEN`
- Nom avec **incrémentation à 4 chiffres**
- Lieu : Salle de stock + Salle serveur
- Statut : En stock
- Type : Rack
- Fabricant : HP
- Modèle : Proliant-DL380
    - 15 kg, 2U, 2 alimentations
- Images : Avant / Arrière (fournies)

#### Ports réseau

|Numéro|Nom|Type|Vitesse|
|---|---|---|---|
|0|Port-|RJ45|10 Gbit/s|
|1-8|Port-|RJ45|1 Gbit/s|

#### OS

- `HPE iLO`, Architecture 64 bits

#### CPU

- 2 processeurs Intel 3.9 GHz, 28 cœurs

#### RAM

- 6 To (12 x 512 Go DDR4 2666 MHz, HP)

---

### 3️⃣ Baie serveur

- Gabarit : `GAB-Baie-HPE`
- Nom : `Baie-HPE-1`
- Lieu : Salle serveur → Salle serveur 1
- Orientation porte : Nord
- 42U
- Modèle : G2 Enterprise Pallet Rack
- Statut : En stock
- Dimensions :
    - Largeur : 59.78 cm
    - Hauteur : 200.66 cm
    - Profondeur : 112.52 cm
    - Poids max : 1361 kg
    - Couleur : noir

#### Installation

- Baie en **colonne A, ligne 1**, statut En place
- **Serveurs positionnés** :
    - U41-42 → `Proliant-DL380-GEN-0001`
    - U16-17 → `Proliant-DL380-GEN-0002`

---

### 4️⃣ PDU

- Gabarit : `GAB-PDU-HPE-G2-3.6kva`
- Lieu : Salle de stock
- Statut : En stock
- Type : HPE-G2-Horizontale
- Fabricant : HP
- Modèle : PDU-HPE-G2-3.6kVA
    - 3.9 kg, 1U, 8 connexions, 4 kVA
- Images fournies

#### Installation

- 2 PDU créés : `PDU-HPE-G2-3.6kva-1/2`
- U30 et U15-42 → Baie Salle serveur, statut En place

---

### 5️⃣ Commutateurs

#### a) Switch 48 ports

- Gabarit : `GAB-JL356A-ARUBA-2540-48P`
- Incrémentation à 4 chiffres
- Ports :
    - 0-3 → 100 Gbit/s RJ45
    - 4-47 → 10 Gbit/s RJ45
- Modèle : Switch-JL356A-48P
- Images fournies

#### Installation

- 4 Switchs créés `0001` à `0004`
- U40, U29, U14 → Baie Salle serveur

#### b) Switch 24 ports

- Gabarit : `GAB-JL356A-ARUBA-2540-24P`
- Incrémentation à 4 chiffres
- Ports :
    - 0-3 → 10 Gbit/s RJ45    
    - 4-23 → 1 Gbit/s RJ45
- Modèle : Switch-JL356A-24P
- Images fournies + Manuel PDF ajouté

#### Installation

- 6 Switchs créés `0001` à `0006`
- Lieux :
    - Temple de Zeus → 0001 / 0002
    - Salle des trésors → 0003
    - Temple d’Héra → 0004
    - Hôtellerie → 0005

#### Connexions inter-switchs

- `0001`/`0002` (Temple de Zeus) → ports 1/2 du `48P-0001`
- `0003`/`0004` (Salle des trésors / Temple d’Héra) → ports 1/2 du `48P-0002`
- `0005` (Hôtellerie) → port 1 du `48P-0003`

---

### 6️⃣ Gabarit PC portable Alienware M17

- Gabarit : `GAB-Alienware-M17`
- Incrémentation à 3 chiffres
- Lieu : Salle de stock
- Statut : En stock
- Type : Portable
- Fabricant : DELL
- Modèle : Alienware-M17
    - 3 kg, 250 W

#### Composants

- CPU : i7-10750H → 2.6 MHz (base), 5 GHz (boost), 6 cœurs / 12 threads
- Carte réseau RJ45 : Killer E3000 (10/100/1000)
- Wi-Fi : Killer AX1650 (2.4 Gbit/s)
- GPU : Nvidia RTX 2070 (8096 Mio, PCIe)
- SSD : 2x PCIe M.2 (488281 Mio)
- RAM : 2x Corsair 8 Go DDR4 2666 MHz

#### Ports réseau

- 1 port Ethernet RJ45 → Killer E3000
- 1 port Wi-Fi → Killer AX1650 (mode Géré)

#### OS et logiciels

- Windows 10 Pro, version 20H2
- Logiciel : Office365-ProPlus
    - 60 licences créées, statut attribué, volume
    - Licence affectée au gabarit + installation du logiciel

---

### 7️⃣ Prises réseau par lieu

Créer des **prises** dans :

|Lieu|Nb prises|
|---|---|
|Salle des trésors|4|
|Hôtellerie|2|
|Temple d’Héra|4|
|Temple de Zeus|2|

Nom : `Prise-1`, `Prise-2`, etc.

---

### 8️⃣ Portables Alienware - Affectation

- Créer **12 portables Alienware**
- Affecter 1 portable **par utilisateur Olympus** (via la liaison AD)
- Connecter chaque portable à un **port de switch disponible** dans le lieu (via les prises réseau créées)

---

### 9️⃣ Réservation

- Créer **2 portables Alienware supplémentaires** → rendre **réservables**
- Faire une **réservation pour 1 mois** au nom de **Zeus**

---

### 1️⃣0️⃣ Écrans

- Ajouter **2 écrans E1913 S 19**
- Lier 1 écran à un **Optiplex** et 1 en stock

---

### 1️⃣1️⃣ Imprimantes

- 5 imprimantes Aficio MP C5502AD
- Ajouter les **cartouches** + stock papier :
    - 1 imprimante dans le hall
    - 4 dans les autres salles (au choix)
    - Prévoir 1 jeu de toner en spare + papier supplémentaire

---

### 1️⃣2️⃣ Autres matériels

- **1 BlackBerry Z30** → assigné au Directeur
- **1 Webcam Logitech C920** → assignée au Hall

---

## ✅ À retenir pour les révisions

- Les **gabarits** sont essentiels pour normaliser l’inventaire
- Toujours prévoir un **plan de nommage cohérent**
- Les **connexions réseau** permettent une **cartographie précise**
- La gestion des **licences et réservations** est indispensable en production
- GLPI peut tout gérer : **datacenter, matériel, périphériques, logiciels, consommables, utilisateurs, lieux**

---

## 📌 Bonnes pratiques professionnelles

- Renseigner **systématiquement** les champs critiques : modèle, lieu, statut, utilisateur
- Créer un **plan d’adressage logique des ports réseau**
- **Documenter** toutes les conventions de nommage et de gabarits
- Prévoir une **revue régulière de l’inventaire** (audits, cohérence)
- Gérer les licences avec un **suivi strict** (éviter les dépassements)
- Anticiper les besoins en **réservations**
- Utiliser les fonctionnalités avancées de GLPI (supervision, intégration FusionInventory)
