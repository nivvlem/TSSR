# Téléphonie sur IP – ToIP
## 📞 Principes fondamentaux

### Définitions

- **VoIP** : Voice over IP, transport de la voix sur réseau IP
- **ToIP** : Téléphonie sur IP de bout en bout (du réseau de desserte au poste de travail)

### Types d’appels

- Internes : intra-entreprise
- Externes : via réseau commuté (RTC, GSM, Freebox…)

---

## 📈 ROI et motivations

### Pourquoi migrer ?

- Mutualisation de l’infrastructure : **un seul réseau** (données + voix)
- Réduction des coûts (appels internes gratuits, externalisation possible)
- Meilleure gestion : mobilité des postes, gestion centralisée (TaaS)
- Nouvelles fonctionnalités : SVI, conférences, call center, messagerie unifiée

### Retour sur investissement

- Économies opérateurs + réduction des équipements
- Simplification de l’administration et meilleure productivité
- Motivation accrue des équipes techniques

---

## 🛠️ Équipements & lignes

### IPBX et Centrex

- **IPBX** : autocom IP local avec options avancées (centre d’appel, CTI, hôtellerie)
- **Centrex IP** : service hébergé chez un opérateur, gestion mutualisée
- **Trunk SIP** : lien entre IPBX local et opérateur VoIP

### Serveurs de taxation

- Traçabilité des appels : n° appelant/appelé, durée, date, statistiques

### Softphones et terminaux

- **Softphones** : logiciel SIP avec micro-casque (Zoiper, Linphone, X-Lite…)
- **Téléphones IP** : POE, écran, mini-switch, avec ou sans vidéo

### Types de lignes

- **ADSL / SDSL / FttO / FTTH** : débits symétriques, garanties SLA pour la voix
- **Liaisons louées / MPLS** : lignes dédiées inter-agence, fiables et garanties

---

## 🌐 Protocoles & codecs

### SIP (Session Initiation Protocol)

- Signaling : ouverture / fermeture de session
- Ports : UDP 5060 / SIPS 5061 (TLS)
- Intègre RTP/RTCP pour les données multimédia

### RTP / RTCP

- **RTP** : transport voix en temps réel (port 5004)
- **RTCP** : statistiques QoS, synchronisation

### Codecs voix (MOS – qualité de voix)

|Codec|MOS|Débit|
|---|---|---|
|G.711|4.1|64 Kbps|
|G.729|3.9|8 Kbps|
|G.723.1|3.6|6.4 Kbps|
|GSM|3.5|1.3 Kbps|

### Autres protocoles

- **MGCP** : gestion centralisée (mode secours)
- **IAX** : entre serveurs Asterisk, économique en bande passante

---

## ⚙️ QoS – Qualité de Service

### Objectifs

- Prioriser les flux voix/vidéo dans un réseau mixte
- Garantir une latence < 150 ms, gigue < 30 ms, perte < 1 %

### Mise en œuvre

- Couches 2 (802.1p), 3 (DSCP), 4-5 (protocoles)
- Techniques : classification, marquage, files d’attente, priorité

### DSCP et marquage

|DSCP|Description|Type|
|---|---|---|
|EF (46)|Expedited Forwarding|Voix|
|AFxx|Assured Forwarding|Données sensibles|
|CSx|Class Selector|Catégorie générique|

---

## 📊 Dimensionnement

### Calcul bande passante

- Règle : 100 Kbps × nb appels simultanés (incluant overhead)

### Exemple

- Codec G.711 (64 kbps) sur SDSL 2 Mb/s → ~32 appels simultanés

---

## 📞 Circuits d’appel & SVI

### Circuits d’appel

- Identification des flux : internes ↔ internes, internes ↔ externes
- Répartition : par service, site, SDA, horaires…
- Retour à l’accueil, groupes d’appels, messagerie

### Serveur Vocal Interactif (SVI)

- Accueil, redirection, reconnaissance vocale ou DTMF
- Intégration possible avec SI métier (CRM, base de données…)

---

## 🛠️ Configuration XiVO

### Déploiement

- IPBX open source français (Debian + Asterisk)
- Gestion des lignes, utilisateurs, groupes, services
- Répertoires, musique d’attente, supervision

### Fichier `extensions.conf`

- Définition des règles d’appel : `exten => numéro, priorité, action`
- Contextes : [default], [local], etc.
- Actions : `Dial()`, `Hangup()`, `Voicemail()`, `Goto()`, `Playback()`

---

## ✅ À retenir pour les révisions

- La ToIP repose sur une **infrastructure IP convergente** (voix, data)
- **SIP + RTP** sont les protocoles centraux de la téléphonie IP
- La **QoS** est cruciale pour garantir qualité et fiabilité
- Un bon **dimensionnement** assure disponibilité et qualité
- **XiVO** est une solution complète et open source pour la ToIP

---

## 📌 Bonnes pratiques professionnelles

- Toujours **analyser l’existant** avant déploiement (audit)
- Prioriser la voix avec des **mécanismes QoS bout en bout**
- Choisir des **codecs adaptés** au lien Internet disponible
- Séparer **flux voix et data** par VLAN ou VRF
- Sécuriser le SIP avec TLS / SRTP
- Former les utilisateurs à la **téléphonie IP** et aux outils associés