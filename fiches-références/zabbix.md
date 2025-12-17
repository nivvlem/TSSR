# 📊 Zabbix

## 📌 Présentation

**Zabbix** est une solution de **supervision open source** permettant de surveiller l’état, la disponibilité et les performances d’un **système d’information**.

- **Type d’outil** : supervision / monitoring
- **Usage principal** : détection d’incidents, anticipation des pannes, suivi des performances
- **Cibles surveillées** : serveurs, VM, services, équipements réseau, applications

👉 Zabbix est un **outil clé**, car il permet de passer d’une gestion réactive à une gestion proactive du SI.

---

## 🏢 Cas d’usage en entreprise

En environnement professionnel (comme chez **Ingenium**), Zabbix est utilisé pour :

- Surveiller la disponibilité des **serveurs Linux et Windows**
- Contrôler l’état des **VM hébergées sur Proxmox**
- Anticiper les saturations :
    - CPU
    - RAM
    - espace disque
- Être alerté rapidement en cas de :
    - panne
    - service arrêté
    - dépassement de seuil

👉 Il permet de **réduire les interruptions de service** et d’améliorer la qualité globale du SI.

---

## 🧠 Concepts et notions clés

> Cette section présente les notions indispensables pour comprendre le fonctionnement de Zabbix et être capable de les expliquer en contexte professionnel.

### 🔹 Supervision

Processus consistant à collecter, analyser et afficher des données techniques afin de détecter des anomalies.

### 🔹 Hôte (Host)

Élément supervisé par Zabbix :

- serveur
- VM
- équipement réseau

### 🔹 Item

Élément mesuré sur un hôte (ex : charge CPU, mémoire libre, espace disque).

### 🔹 Trigger

Condition logique basée sur un ou plusieurs items permettant de **déclencher une alerte**.

### 🔹 Événement

Résultat du déclenchement d’un trigger (problème ou retour à la normale).

### 🔹 Agent Zabbix

Programme installé sur la machine surveillée pour remonter des métriques détaillées (CPU, mémoire, disque, services).

👉 L’agent permet une supervision **fine et précise**, contrairement aux simples tests réseau.

---

## ⚙️ Fonctionnement général

1. **Zabbix Server** centralise la supervision et stocke les données
2. Les **hôtes** sont déclarés (serveurs, VM, équipements)
3. Les données sont collectées via :
    - agent Zabbix
    - SNMP
    - checks ICMP / TCP
4. Les **items** collectent les métriques
5. Les **triggers** analysent les valeurs selon des seuils
6. Des **événements** sont générés (problème / OK)
7. Des **alertes** sont envoyées selon la criticité (mail, webhook…)

👉 Zabbix repose sur une **logique d’analyse par seuils**, pas uniquement sur l’état "up/down".

---

## 🛠️ Actions / opérations côté ASR

Un ASR est typiquement responsable de :

- Installation et mise à jour de Zabbix Server
- Déploiement et configuration des agents Zabbix
- Déclaration des hôtes et groupes d’hôtes
- Application et personnalisation des templates
- Création et ajustement des triggers
- Définition des seuils de criticité
- Configuration des notifications
- Analyse et qualification des alertes
- Documentation des règles et incidents

👉 Zabbix est un **outil central dans la chaîne d’exploitation** du SI.

---

## 🔐 Sécurité et bonnes pratiques

- Restreindre l’accès à l’interface web Zabbix (pare-feu)
- Utiliser des comptes nominatifs et des rôles adaptés
- Sécuriser les communications agent ↔ serveur (TLS)
- Limiter l’exposition des ports Zabbix
- Mettre en place une hiérarchisation des alertes
- Sauvegarder régulièrement la base de données Zabbix

👉 Une mauvaise sécurisation de Zabbix peut exposer des **informations sensibles sur le SI**.

---

## ⚠️ Erreurs fréquentes

- Surveiller trop d’éléments sans hiérarchisation
- Définir des seuils irréalistes ou génériques
- Générer trop d’alertes (alert fatigue)
- Ne pas qualifier les alertes avant escalade
- Ne pas documenter les incidents
- Installer Zabbix sans réflexion sur l’architecture globale

👉 Une supervision mal pensée devient **contre-productive**.

---

## 🚨 Gestion des incidents

Zabbix joue un rôle clé dans la **détection et le traitement des incidents**.

### 🔄 Cycle type d’un incident

1. Détection automatique par Zabbix (trigger)
2. Génération d’un événement
3. Envoi d’une alerte à l’ASR
4. Analyse de la cause (ressource, service, réseau)
5. Action corrective (redémarrage, extension, correction)
6. Retour à la normale (OK)
7. Documentation de l’incident

👉 Zabbix permet de **réagir vite**, mais aussi d’**analyser a posteriori**.

---

## ✅ À retenir pour un ASR

👉 **Je dois savoir expliquer :**

- ce qu’est la supervision
- la différence entre item, trigger et événement
- le rôle de Zabbix dans la gestion des incidents

👉 **Je dois savoir faire :**

- ajouter un hôte et un template
- analyser une alerte
- qualifier un incident

👉 **Je dois savoir surveiller :**

- les ressources critiques (CPU, RAM, disque)
- la disponibilité des services
- les alertes à fort impact
