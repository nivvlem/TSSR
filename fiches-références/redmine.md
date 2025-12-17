# 🧩 Redmine

## 📖 Présentation

- **Définition simple** : Redmine est un outil web open source de **gestion de projets** et de **suivi de tickets** (issues).
- **Type d’outil** : Gestion de projet / suivi d’incidents et de tâches.
- **Objectif principal** : Centraliser les demandes, structurer le travail et assurer la **traçabilité** des actions.

---

## 🏢 Cas d’usage en entreprise

- **Pourquoi on l’utilise** :
    - Suivre les projets et les tâches
    - Gérer les incidents et demandes utilisateurs
    - Coordonner plusieurs équipes
- **Dans quel contexte** :
    - Services IT / ASR
    - Développement applicatif
    - Projets internes ou clients
- **Exemples concrets** :
    - Suivi des incidents sur une plateforme Moodle
    - Gestion des évolutions d’un SI
    - Centralisation des demandes internes

---

## 🧱 Concepts et notions clés

- **Projet** : conteneur principal (client, plateforme, périmètre technique).
- **Ticket (issue)** : unité de travail (incident, tâche, demande).
- **Tracker** : type de ticket (bug, tâche, évolution…).
- **Statut** : état d’avancement du ticket.
- **Rôle** : définit les permissions utilisateur.
- **Workflow** : règles de transition entre statuts.

---

## ⚙️ Fonctionnement général

- Redmine est organisé par **projets**.
- Les utilisateurs interagissent via des **tickets**.
- Chaque ticket suit un **workflow** défini.
- Les actions sont historisées (commentaires, changements, temps passé).
- Les notifications informent les acteurs concernés.

---

## 🛠️ Actions / opérations côté ASR

- **Administrer** :
    - Création et paramétrage des projets
    - Gestion des rôles et permissions
    - Configuration des trackers et workflows
    - Création de champs personnalisés (SLA, environnement, client…)
- **Surveiller** :
    - Tickets bloqués ou sans assignation
    - Respect des priorités et délais
    - Charge par utilisateur / équipe
- **Maintenir** :
    - Mises à jour Redmine et plugins
    - Sauvegardes de la base de données
    - Disponibilité du service (web / base)
    - Vérification des performances (base, cache, stockage)

---

## 🔐 Sécurité et bonnes pratiques

- Accès en **HTTPS** (reverse proxy recommandé)
- Principe du **moindre privilège**
- Comptes administrateurs strictement limités
- Sauvegardes régulières (base + fichiers)
- Authentification centralisée possible (LDAP / SSO)
- Journalisation des actions utilisateurs
- Séparation projets internes / clients

---

## ⚠️ Erreurs fréquentes

- Rôles trop permissifs
- Workflow trop complexe ou mal documenté
- Tickets mal qualifiés (titre, priorité, description)
- Absence de responsable assigné
- Manque de priorisation
- Redmine utilisé comme simple messagerie

---

## 🧠 À retenir pour un ASR

- **Savoir expliquer** :
    - Ce qu’est Redmine et sa différence avec GLPI ou Jira
    - La notion de projet, ticket, tracker et workflow
    - L’intérêt de la traçabilité
- **Savoir faire** :
    - Créer un projet structuré
    - Paramétrer un workflow simple et cohérent
    - Gérer les rôles et permissions
    - Exploiter le suivi du temps
- **Savoir surveiller** :
    - Les tickets bloqués ou sans suivi
    - Les incidents récurrents
    - La charge globale et les délais

---

## 🧩 Enrichissement : Redmine & gestion des incidents IT

### 🔗 Lien avec la supervision (ex : Zabbix)

- Zabbix détecte une anomalie
- Un ticket Redmine est créé (manuel ou automatisé)
- Le ticket devient le point de référence de l’incident

### 🔁 Cycle type d’un incident

```
Détection → Ticket créé → Analyse → Correction → Validation → Clôture
```

### 🎯 Intérêt pour l’ASR

- Historique complet des incidents
- Capitalisation des résolutions
- Amélioration continue
- Support à la VAE et aux audits

---

## 🧩 Enrichissement : Redmine vs GLPI

|Outil|Usage principal|
|---|---|
|Redmine|Suivi projet / tâches / incidents structurés|
|GLPI|Support ITSM, parc, utilisateurs|

👉 Les deux outils sont **complémentaires**, pas concurrents.