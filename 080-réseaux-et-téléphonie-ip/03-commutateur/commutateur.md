# Le commutateur – VLAN, trunk, SVI, sécurité

## 🧱 VLAN – Virtual LAN

### Définition

- Segmentation logique du réseau sans ajout de matériel
- Chaque VLAN = **domaine de broadcast isolé**

### Avantages

|Bénéfice|Explication|
|---|---|
|Sécurité|Isolement des flux entre services|
|Performance|Réduction du trafic inutile|
|Gestion|Regroupement logique d’utilisateurs|
|Économie|Un switch physique → plusieurs LAN logiques|

### Types de VLAN

- **Données** : trafic utilisateurs (mail, web)
- **Voix** : QoS spécifique pour la téléphonie (priorité, faible latence)
- **Gestion** : administration réseau (SSH, Telnet)
- **Par défaut** : VLAN 1, utilisé à la sortie d’usine
- **Natif** : VLAN non tagué sur trunk (souvent VLAN 1, à changer pour des raisons de sécurité)

---

## 🔧 Commandes VLAN

### Création d’un VLAN

```shell
Switch(config)# vlan 30
Switch(config-vlan)# name Administration
```

### Affectation d’un port à un VLAN

```shell
Switch(config)# interface FastEthernet 0/1
Switch(config-if)# switchport mode access
Switch(config-if)# switchport access vlan 30
```

### Vérification

```shell
Switch# show vlan brief
```

---

## 🔁 Trunks (liaisons inter-switches)

### Rôle

- Transportent **plusieurs VLANs** sur un même lien physique
- Utilisent **802.1Q** pour taguer les trames

### Configuration

```shell
Switch(config)# interface fa0/1
Switch(config-if)# switchport mode trunk
Switch(config-if)# switchport trunk native vlan 99
Switch(config-if)# switchport trunk allowed vlan 10,20,30
```

### Vérification

```shell
Switch# show interface fa0/1 switchport
```

---

## 🌐 SVI – Interface VLAN pour l’administration

- Interface logique associée à un VLAN sur le switch
- Nécessaire pour **accéder au switch à distance** (via IP)

### Configuration

```shell
Switch(config)# interface vlan 10
Switch(config-if)# ip address 192.168.10.2 255.255.255.0
Switch(config-if)# no shutdown
```

---

## 🔐 Sécurisation du commutateur

### Recommandations clés

- **Supprimer ou désactiver les ports inutilisés**
- **Changer le VLAN natif** et éviter l’usage du **VLAN 1**
- **Forcer l’utilisation de SSH** (et non Telnet)

### Activer l’accès SSH sécurisé

```shell
Switch(config)# ip domain-name entreprise.local
Switch(config)# crypto key generate rsa
Switch(config)# username admin secret MonMotDePasseFort
Switch(config-line)# line vty 0 15
Switch(config-line)# login local
Switch(config-line)# transport input ssh
Switch(config)# ip ssh version 2
```

---

## ✅ À retenir pour les révisions

- Un **VLAN** segmente le réseau sans matériel supplémentaire
- Un **SVI** est nécessaire pour l’accès IP au switch
- Un **trunk** transporte plusieurs VLANs entre les switches
- Le **VLAN natif** ne doit pas être utilisé pour les données utilisateurs
- Le protocole **SSH** est obligatoire pour les connexions distantes sécurisées

---

## 📌 Bonnes pratiques professionnelles

- Toujours **changer le VLAN natif** et **désactiver les ports inutiles**
- Séparer les flux **voix, données, administration** sur des VLANs dédiés
- Utiliser des **trunks** pour interconnecter les switches
- Mettre en place une **authentification SSH** et des mots de passe complexes
- **Documenter** chaque VLAN, port, et rôle associé dans un fichier d’architecture réseau