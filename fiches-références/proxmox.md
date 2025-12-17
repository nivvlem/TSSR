# 🧱 Proxmox VE (Virtual Environment)

## 📌 Présentation

**Proxmox VE** est une plateforme de **virtualisation open source** permettant de gérer des **machines virtuelles (VM)** et des **conteneurs** depuis une interface web centralisée.

- **Type d’outil** : Hyperviseur de type 1 (bare-metal)
- **Basé sur** : Debian GNU/Linux
- **Technologies principales** :
    - KVM (Kernel-based Virtual Machine) pour les VM
    - LXC pour les conteneurs    
- **Usage principal** : hébergement et gestion d’infrastructures virtualisées

👉 Proxmox constitue très souvent le **socle d’infrastructure** d’un SI moderne on-premise ou hybride.

---

## 🏢 Cas d’usage en entreprise

En environnement professionnel, Proxmox est utilisé pour :

- Héberger des **serveurs Linux et Windows** (Moodle, bases de données, supervision, stockage…)
- Mutualiser les ressources matérielles (CPU, RAM, stockage)
- Faciliter :
    - la **création rapide de serveurs**
    - les **snapshots**
    - les **sauvegardes**
    - la **reprise après incident**
- Centraliser l’administration via une **interface web unique**

👉 C’est une alternative sérieuse à VMware ESXi, souvent choisie pour :

- sa **licence open source**
- sa **souplesse**
- sa **richesse fonctionnelle native**

---

## 🧠 Concepts et notions clés

> Cette section regroupe les notions **indispensables** à maîtriser pour comprendre, exploiter et expliquer Proxmox en contexte professionnel.

### 🔹 Hyperviseur

Logiciel qui permet d’exécuter plusieurs systèmes d’exploitation sur une même machine physique.

- Proxmox est un **hyperviseur de type 1** : il s’exécute directement sur le matériel.

### 🔹 VM (Machine Virtuelle)

- Virtualisation complète
- Chaque VM a son propre noyau
- Exemples : Windows Server, Debian, Rocky Linux

### 🔹 Conteneur (LXC)

- Virtualisation légère
- Partage le noyau de l’hôte
- Plus rapide, moins gourmand
- Adapté à des services Linux simples

### 🔹 Nœud (node)

Serveur physique sur lequel est installé Proxmox.

### 🔹 Cluster

Ensemble de nœuds Proxmox interconnectés permettant :

- la haute disponibilité
- la migration à chaud
- la gestion centralisée

### 🔹 Stockage

Proxmox supporte plusieurs types de stockage, qui conditionnent fortement les performances, la résilience et les possibilités de reprise :

- **Local** : stockage directement sur le disque du nœud (rapide mais peu résilient)
- **NFS** : stockage réseau simple, souvent utilisé pour les sauvegardes
- **iSCSI** : stockage bloc distant, plus performant mais plus complexe
- **ZFS** : système de fichiers avancé avec gestion de volumes, snapshots et intégrité des données
- **Ceph** : stockage distribué hautement disponible (en cluster)

👉 Le choix du stockage est un **point critique d’architecture ASR**.

---

## ⚙️ Fonctionnement général

1. Proxmox est installé **directement sur le serveur physique** (bare-metal)
2. Le serveur devient un **nœud Proxmox** administrable via HTTPS
3. Les ressources matérielles (CPU, RAM, disques, réseau) sont virtualisées
4. Les VM et conteneurs consomment ces რესsources via des abstractions logicielles
5. Les réseaux virtuels reposent sur des **bridges Linux**
6. Les sauvegardes sont planifiées et stockées localement ou à distance

👉 Toute l’administration passe par :

- l’interface web
- ou la ligne de commande

---

## 🛠️ Actions / opérations côté ASR

Un ASR est typiquement responsable de :

- Installation et mise à jour de Proxmox
- Intégration du serveur dans l’architecture réseau existante
- Création / suppression de :
    - VM
    - conteneurs
- Gestion :
    - du stockage (local, NFS, ZFS…)
    - du réseau virtuel (bridges, VLAN)
    - des sauvegardes (planification, rétention)
- Supervision de :
    - la charge CPU
    - la RAM
    - l’espace disque
- Gestion des droits utilisateurs Proxmox
- Documentation de l’infrastructure (inventaire VM, rôles, dépendances)

👉 Proxmox est **un outil central**, donc critique pour la continuité de service.

---

## 🔐 Sécurité et bonnes pratiques

- Accès à l’interface web **uniquement en HTTPS**
- Restreindre l’accès réseau à l’interface d’administration (pare-feu)
- Utiliser :
    - des comptes nominatifs
    - des rôles adaptés (RBAC)
- Ne pas utiliser le compte `root` pour l’administration quotidienne
- Sauvegardes **hors du nœud Proxmox**
- Tester régulièrement les restaurations
- Mises à jour régulières (OS + Proxmox)
- Séparation logique ou physique des réseaux :
    - administration
    - VM / production
    - sauvegarde (si possible)

👉 La sécurité de Proxmox conditionne celle de **tout le SI hébergé**.

---

## ⚠️ Erreurs fréquentes

- Utiliser uniquement le stockage local sans stratégie de sauvegarde
- Ne jamais tester les restaurations de VM
- Sur-allouer CPU / RAM aux VM (overcommit non maîtrisé)
- Exposer l’interface web Proxmox directement sur Internet
- Administrer uniquement en root
- Absence de documentation des VM hébergées
- Mélanger réseau admin et réseau production

👉 Ces erreurs sont **très fréquentes**.

---

## ✅ À retenir pour un TSSR / ASR

👉 **Je dois savoir expliquer :**

- ce qu’est un hyperviseur de type 1
- la différence entre VM et conteneur
- pourquoi Proxmox est un socle d’infrastructure
- l’impact du stockage et du réseau sur les performances

👉 **Je dois savoir faire :**

- créer et configurer une VM
- planifier et restaurer une sauvegarde
- analyser une saturation CPU, RAM ou disque
- intervenir lors d’un arrêt de VM ou de nœud

👉 **Je dois savoir surveiller :**

- l’espace disque (critique)
- la charge globale du nœud
- l’état des sauvegardes
- les alertes matérielles (SMART, RAID)
