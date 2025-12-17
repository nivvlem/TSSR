# 🧩 Notion de nœud (Node)

## 📌 Présentation

Un **nœud (node)** désigne un **élément technique identifié** au sein d’un système informatique distribué ou d’une infrastructure.

- **Type de notion** : concept transverse (infra, supervision, automatisation)
- **Usage principal** : identifier une machine, un service ou une entité technique
- **Contextes concernés** : virtualisation, supervision, automatisation, cluster

👉 La notion de nœud est **fondamentale en administration systèmes**, car elle permet de raisonner en **architecture distribuée** plutôt qu’en machines isolées.

---

## 🏢 Cas d’usage en entreprise

En environnement professionnel, la notion de nœud est utilisée pour :

- Identifier des **serveurs physiques ou virtuels**
- Structurer des **clusters** (Proxmox, stockage, haute disponibilité)
- Cibler des machines dans des outils de **supervision** (Zabbix)
- Exécuter des actions automatisées sur des systèmes précis (Rundeck)
- Documenter l’architecture du SI

👉 Le nœud est l’**unité de base** sur laquelle s’appliquent supervision, automatisation et exploitation.

---

## 🧠 Concepts et notions clés

> Cette section présente les différentes acceptions du terme _nœud_ selon les outils et contextes.

### 🔹 Nœud physique

Machine matérielle réelle (serveur, appliance).

### 🔹 Nœud virtuel

Machine virtuelle hébergée sur un hyperviseur (ex : Proxmox).

### 🔹 Nœud de cluster

Élément faisant partie d’un ensemble coordonné pour assurer disponibilité et résilience.

### 🔹 Nœud supervisé

Entité déclarée dans un outil de supervision (ex : hôte Zabbix).

### 🔹 Nœud cible

Système sur lequel une action automatisée est exécutée (ex : node Rundeck).

---

## ⚙️ Fonctionnement général

1. Un nœud est **identifié de manière unique** (nom, IP, ID)
2. Il appartient à un **périmètre logique** (cluster, groupe, projet)
3. Des services ou rôles lui sont associés
4. Il communique avec d’autres nœuds via le réseau
5. Il peut être surveillé, administré ou automatisé

👉 Le nœud est une **brique fonctionnelle** du SI.

---

## 🛠️ Rôle et responsabilités de l’ASR

Un ASR est typiquement responsable de :

- L’identification claire des nœuds
- Le nommage cohérent (hostname, FQDN)
- L’intégration des nœuds aux outils (Zabbix, Rundeck, Proxmox)
- La documentation des rôles des nœuds
- La supervision de leur état
- La gestion du cycle de vie (création, exploitation, retrait)

👉 Une mauvaise gestion des nœuds entraîne **confusion, erreurs et risques**.

---

## 🔐 Sécurité et bonnes pratiques

- Nommer les nœuds de façon explicite
- Ne jamais exposer inutilement un nœud
- Appliquer le principe du moindre privilège
- Segmenter les nœuds par rôle et environnement
- Documenter les accès et flux

👉 Chaque nœud représente une **surface d’attaque potentielle**.

---

## ⚠️ Erreurs fréquentes

- Confondre nœud, service et application
- Nommage incohérent ou non documenté
- Absence de supervision des nœuds
- Mélange des environnements (prod / test)
- Oubli de retirer des nœuds obsolètes

👉 Ces erreurs compliquent fortement l’exploitation du SI.

---

## 📊 Valeur ajoutée pour l’entreprise

- Architecture claire et lisible
- Exploitation facilitée
- Réduction des erreurs humaines
- Meilleure sécurité
- Scalabilité du SI

---

## ✅ À retenir pour un ASR

👉 **Je dois savoir expliquer :**

- ce qu’est un nœud
- les différents types de nœuds
- pourquoi cette notion est centrale en SI

👉 **Je dois savoir faire :**

- identifier et nommer un nœud
- l’intégrer à la supervision et à l’automatisation
- documenter son rôle

👉 **Je dois savoir surveiller :**

- la disponibilité des nœuds
- leur charge et leur état
- les nœuds critiques

