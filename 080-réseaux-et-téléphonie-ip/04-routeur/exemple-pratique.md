# TP – Configuration de routeurs, routage statique, inter-VLAN et RIP

## 🧠 Objectif

Regrouper les manipulations clés liées à la configuration initiale d’un routeur, au **routage statique**, au **router-on-a-stick**, à la **double pile IPv4/IPv6** et au **protocole RIP**, sur la base des TPs Packet Tracer associés.

---

## 🧾 Contexte

Ce TP synthétise :

- Les bases de configuration d’un routeur
- Le dépannage de passerelle par défaut
- Le routage inter-VLAN avec sous-interfaces (802.1Q)
- L’adressage IPv4/IPv6, la connectivité et la commande `ping`
- La configuration de RIP v2 et l’optimisation via les interfaces passives

---

## 🔧 Étapes de configuration

### 1. Paramétrage initial du routeur

```shell
hostname R1
enable secret itsasecret
line console 0
 password letmein
 login
line vty 0 4
 password cisco
 login
service password-encryption
banner motd #Unauthorized access is strictly prohibited#
```

### Sauvegarde de la configuration

```shell
copy running-config startup-config
```

### Vérification mémoire

```shell
show running-config
show startup-config
show flash
```

---

### 2. Vérification et dépannage passerelle par défaut

- Tester la **connectivité locale** (ping entre hôtes et switch)
- Tester la **connectivité distante** (ping entre réseaux)
- Corriger les **erreurs d’adressage IP / masque / passerelle**
- Ajouter une configuration de **gateway sur les switches**

```shell
ip default-gateway 192.168.X.1
```

---

### 3. Routage inter-VLAN – Router-on-a-Stick

```shell
interface g0/0.10
 encapsulation dot1Q 10
 ip address 192.168.10.1 255.255.255.0
interface g0/0.30
 encapsulation dot1Q 30
 ip address 192.168.30.1 255.255.255.0
```

### Activation de l’interface physique

```shell
interface g0/0
 no shutdown
```

> Ne pas oublier : port G0/1 du switch en mode **trunk**

```shell
switchport mode trunk
```

---

### 4. Vérification connectivité IPv4 / IPv6

#### Depuis un PC

```shell
ipconfig
ping [adresse IP]
ipv6config
ping [adresse IPv6]
```

#### Tracer les routes

```shell
tracert 192.168.X.X
tracert 2001:db8::1
```

---

### 5. Configuration RIP v2

#### R1

```shell
ip route 0.0.0.0 0.0.0.0 s0/0/1
router rip
 version 2
 no auto-summary
 network 192.168.1.0
 network 192.168.2.0
 passive-interface g0/0
 default-information originate
```

#### R2 / R3

```shell
router rip
 version 2
 no auto-summary
 network 192.168.2.0
 network 192.168.3.0
 passive-interface g0/0
```

---

### 6. Routage statique flottant IPv4 & IPv6

```shell
ip route 0.0.0.0 0.0.0.0 10.10.10.1
ip route 0.0.0.0 0.0.0.0 10.10.10.5 5
ipv6 route ::/0 2001:db8:a:1::1
ipv6 route ::/0 2001:db8:a:2::1 5
```

### Routes hôte spécifiques

```shell
ip route 198.0.0.10 255.255.255.255 s0/0/0
ip route 198.0.0.10 255.255.255.255 s0/0/1 5
```

---

## ✅ À retenir pour les révisions

- Toujours activer physiquement les interfaces (`no shutdown`)
- Les **sous-interfaces** permettent le routage inter-VLAN via une interface unique
- RIP est utile pour les topologies simples (à éviter en production)
- Un routeur ne transmet un paquet hors du réseau que via sa **gateway** ou une route connue
- Le **routage statique flottant** permet la **redondance** avec DA supérieure

---

## 📌 Bonnes pratiques professionnelles

- Sauvegarder toute configuration (`copy running-config startup-config`)
- Vérifier les tables de routage (`show ip route` et `show ipv6 route`)
- Configurer les routes passives pour éviter les annonces RIP inutiles
- Documenter les plans d’adressage et la topologie
- Sécuriser les accès CLI (console, vty) avec mots de passe + bannière
- Vérifier l’activité avec `ping` et `tracert` pour les deux piles