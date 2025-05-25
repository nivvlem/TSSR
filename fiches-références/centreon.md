# Centreon (Supervision réseau et systèmes)

## 📌 Présentation

**Centreon** est une solution open source de supervision permettant de surveiller l’état de santé d’un système d’information (serveurs, équipements réseau, services, applications, etc.). Basée sur Nagios au départ, elle propose une **interface web** conviviale pour créer des hôtes, définir des seuils d’alerte, visualiser les performances et centraliser les notifications.

C’est un outil incontournable dans les métiers de supervision, d’exploitation ou d’administration système/réseau.

---

## 🧱 Architecture
| Composant            | Rôle                                          |
| -------------------- | --------------------------------------------- |
| **Centreon Web**     | Interface de configuration et de supervision  |
| **Centreon Engine**  | Moteur de supervision (exécute les checks)    |
| **Centreon Broker**  | Collecte et transfert des résultats           |
| **Centreon Plugins** | Scripts ou commandes supervisant les services |
| **Base de données**  | Historique des statuts, graphes, logs         |

---

## 🚀 Mise en place (schéma classique)

- Déploiement de Centreon sur une VM (CentOS / AlmaLinux)
- Configuration réseau (accès web via `https://ip_centreon/`)
- Définition d’hôtes (serveurs, switchs, etc.) et de leurs services
- Application de templates et envoi de notifications

---

## 🧰 Tâches courantes
### ➕ Ajouter un hôte

1. Configuration > Hôtes > Ajouter
2. Définir : nom, adresse IP, groupe, modèle (template)

### 🔍 Surveiller un service (checks)

- Les checks sont réalisés par des **plugins Centreon**, qui appellent des scripts (`check_...`) retournant un statut Nagios compatible : `0=OK`, `1=WARNING`, `2=CRITICAL`, `3=UNKNOWN`

#### Exemples de plugins et checks disponibles :

| Plugin            | Exemple de commande                               | Description                               |
| ----------------- | ------------------------------------------------- | ----------------------------------------- |
| `check_ping`      | `check_ping -H 192.168.0.1 -w 100,20% -c 200,50%` | Vérifie la latence et la perte de paquets |
| `check_http`      | `check_http -H site.local -p 80`                  | Vérifie que le site web répond            |
| `check_disk`      | `check_disk -w 20% -c 10% -p /`                   | Vérifie l’espace disque restant           |
| `check_cpu`       | `check_cpu -w 80 -c 90`                           | Charge CPU                                |
| `check_snmp_load` | SNMP → CPU Load                                   | Pour des switchs ou équipements via SNMP  |
| `check_mysql`     | `check_mysql -H 127.0.0.1 -u centreon -p ...`     | Vérifie le service MySQL                  |

- Chaque plugin peut être **personnalisé** avec des arguments définis dans un modèle ou manuellement
- Il est essentiel de **valider les seuils** `-w` (warning) et `-c` (critical)

### ⚙️ Modèles personnalisés et packs

- Utiliser les **Plugin Packs** Centreon (via le dépôt RPM ou marketplace)
- Appliquer un **template de service** contenant :
  - Nom du plugin
  - Arguments par défaut (ex : seuils dynamiques)
  - Données de performance pour les graphes
- Tu peux créer tes propres modèles (Configuration > Modèles > Services)

### 🧪 Tester un plugin manuellement

Depuis la ligne de commande du Centreon Poller :

```bash
/usr/lib/centreon/plugins/centreon_plugins.pl \
  --plugin=os::linux::local::plugin \
  --mode=cpu \
  --warning='70' --critical='90'
```

Cela permet de tester un plugin et valider les seuils AVANT de l’associer à un hôte/service.

---

## 🧪 États

| État     | Code | Couleur | Signification               |
| -------- | ---- | ------- | --------------------------- |
| OK       | 0    | Vert    | Service nominal             |
| WARNING  | 1    | Jaune   | Seuil de pré-alerte dépassé |
| CRITICAL | 2    | Rouge   | Panne ou anomalie           |
| UNKNOWN  | 3    | Gris    | Inconnu ou erreur de check  |

### 📊 Graphes & historique

- Menu : Supervision > Vue graphique ou Liste > Graphiques RRD
- Stockés via RRDtool et accessibles par service

### 📧 Notifications

- Déclenchées selon les plages horaires et contacts définis
- Supportent email, SMS, webhook, scripts personnalisés

---

## 🔎 Cas d’usage courant

- Suivi de disponibilité (uptime) de serveurs et services critiques
- Détection proactive de problèmes de capacité (disque plein, charge CPU…)
- Supervision réseau (ping, ports, VLAN, SNMP)
- Centralisation des alertes IT avec escalade

---

## ⚠️ Erreurs fréquentes

- Mauvaise plage horaire → notifications manquantes
- Plugin non installé côté cible ou non autorisé
- Paramétrage incomplet des seuils WARNING/CRITICAL
- Erreur de firewall bloquant les checks à distance

---

## ✅ Bonnes pratiques

- Appliquer des modèles (templates) pour homogénéiser la supervision
- Créer des groupes d’hôtes et de services pour simplifier la gestion
- Vérifier régulièrement les logs de supervision (`/var/log/centreon/`, `/var/log/centengine/`)
- Utiliser Centreon CLAPI ou API REST pour automatiser
- Documenter les stratégies d’escalade et de notifications

---

## 📚 Ressources complémentaires

- [Documentation officielle Centreon](https://docs.centreon.com/)
- [Formation Centreon ITSM](https://training.centreon.com)
