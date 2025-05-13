# TP – VLAN, trunk, sécurité des commutateurs

## 🧠 Objectif

Appliquer la configuration complète d’un réseau segmenté par **VLAN**, interconnecté via des **trunks**, et sécurisé selon les recommandations ITIL et ANSSI, à l’aide de **commutateurs Cisco** dans Packet Tracer.

---

## 🧾 Contexte

Ce TP regroupe les manipulations suivantes :

- Création et affectation de VLANs
- Configuration des trunks entre commutateurs
- Mise en place de la sécurité (SSH, mots de passe, ports)
- Activation de fonctionnalités avancées (QoS, snooping DHCP, Port Security)

---

## 🔧 Étapes de configuration

### 1. Création des VLANs

```shell
vlan 10
 name Faculty/Staff
vlan 20
 name Students
vlan 30
 name Guests
vlan 99
 name Management
vlan 100
 name Native
vlan 150
 name Voice
vlan 999
 name BlackHole
```

### 2. Affectation des ports d’accès

```shell
interface f0/11
 switchport mode access
 switchport access vlan 10
!
interface f0/18
 switchport mode access
 switchport access vlan 20
!
interface f0/6
 switchport mode access
 switchport access vlan 30
```

### 3. VLAN voix et QoS

```shell
interface f0/11
 switchport mode access
 switchport access vlan 10
 mls qos trust cos
 switchport voice vlan 150
```

---

## 🔁 Trunking VLAN entre commutateurs

### Ports trunk (G0/1 et G0/2)

```shell
interface range g0/1 - 2
 switchport mode trunk
 switchport trunk native vlan 100
 switchport trunk allowed vlan 10,20,30,99,150
 switchport nonegotiate
```

---

## 🔐 Sécurisation du commutateur

### Désactivation des ports inutilisés

```shell
interface range f0/3 - 9, f0/12 - 23
 switchport access vlan 999
 shutdown
```

### Port Security sur ports actifs

```shell
interface f0/1
 switchport port-security
 switchport port-security maximum 4
 switchport port-security mac-address sticky
 switchport port-security violation restrict
```

### Sécurisation SSH

```shell
hostname SW1
ip domain-name entreprise.local
crypto key generate rsa
username admin secret MotDePasseComplexe
ip ssh version 2
line vty 0 4
 login local
 transport input ssh
 exec-timeout 6
```

---

## 🌐 Fonctionnalités supplémentaires

### DHCP Snooping

```shell
ip dhcp snooping
ip dhcp snooping vlan 10,20,30,99
interface range g0/1 - 2
 ip dhcp snooping trust
interface range f0/1 - 24
 ip dhcp snooping limit rate 5
```

### STP – PortFast et BPDU Guard

```shell
spanning-tree portfast default
interface f0/1
 spanning-tree portfast
 spanning-tree bpduguard enable
```

---

## ✅ À retenir pour les révisions

- Le **trunk** transporte tous les VLANs inter-switch
- Le **VLAN natif** doit être changé (ex : 100) pour éviter les attaques VLAN hopping
- Le **VLAN voix** doit être isolé et priorisé
- La **sécurité des ports** limite les MAC autorisées
- Le **snooping DHCP** protège des attaques DHCP rogue
- **SSH** est impératif pour l’accès distant sécurisé

---

## 📌 Bonnes pratiques professionnelles

- Créer un **VLAN poubelle** (BlackHole) pour les ports non utilisés
- Toujours configurer une **authentification SSH avec timeout**
- Vérifier les trunks avec `show interfaces trunk`
- Utiliser les commandes `show vlan brief` et `show running-config` pour contrôler
- Désactiver DTP pour éviter la négociation indésirable de trunks (`nonegotiate`)
- Appliquer **PortFast + BPDU Guard** sur tous les ports d’accès