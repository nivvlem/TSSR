# ⚙️ Rundeck

## 📌 Présentation

**Rundeck** est un outil d’**automatisation opérationnelle** (Runbook Automation) permettant d’exécuter, centraliser et tracer des **actions techniques** sur des systèmes informatiques.

- **Type d’outil** : automatisation / orchestration / runbooks
- **Usage principal** : exécution contrôlée de tâches systèmes
- **Utilisateurs** : administrateurs systèmes, équipes IT

👉 Rundeck permet de **sécuriser, standardiser et tracer** les actions techniques récurrentes ou sensibles.

---

## 🏢 Cas d’usage en entreprise

En environnement professionnel, Rundeck est utilisé pour :

- Centraliser des **scripts d’administration** (Linux / Windows)
- Automatiser des actions récurrentes :
    - redémarrage de services
    - déploiements
    - opérations de maintenance
- Permettre l’exécution d’actions techniques **sans accès direct aux serveurs**
- Tracer qui a fait quoi, quand et comment

👉 Rundeck réduit les erreurs humaines et améliore la **sécurité opérationnelle**.

---

## 🧠 Concepts et notions clés

> Cette section présente les notions indispensables pour comprendre le fonctionnement de Rundeck.

### 🔹 Job

Action automatisée définissant :

- les commandes à exécuter
- les options
- les cibles

### 🔹 Node

Système cible sur lequel Rundeck exécute des actions (serveur, VM, conteneur).

### 🔹 Project

Espace logique regroupant jobs, nœuds et configurations.

### 🔹 Execution

Lancement d’un job, avec historisation complète.

### 🔹 Runbook

Procédure opérationnelle automatisée décrivant une suite d’actions.

---

## ⚙️ Fonctionnement général

1. L’ASR définit un **projet Rundeck** correspondant à un périmètre (ex : production, préproduction)
2. Les **nœuds** (serveurs, VM) sont déclarés ou importés automatiquement
3. Un **job** est créé pour formaliser une action technique
4. Les accès sont contrôlés par rôles et permissions
5. Le job est exécuté manuellement ou automatiquement
6. Chaque exécution génère des **logs détaillés et horodatés**
7. Les résultats sont conservés pour audit et traçabilité

👉 Rundeck agit comme une **couche d’orchestration sécurisée** entre l’humain et les systèmes.

---

## 🛠️ Actions / opérations côté ASR

Un ASR est typiquement responsable de :

- Installation et mise à jour de Rundeck
- Définition de l’architecture projets / environnements
- Déclaration et maintenance des nœuds
- Création de jobs standards et sécurisés
- Gestion des rôles et permissions
- Intégration de scripts existants (bash, PowerShell…)
- Analyse des logs d’exécution
- Documentation des runbooks automatisés

👉 Rundeck permet à l’ASR de **standardiser les actions** et de réduire les risques humains.

---

## 🔐 Sécurité et bonnes pratiques

- Utiliser uniquement des **comptes nominatifs**
- Appliquer le principe du **moindre privilège**
- Séparer les environnements (prod / préprod)
- Externaliser les secrets (vault, variables sécurisées)
- Désactiver toute exécution non tracée
- Auditer régulièrement les jobs et permissions

👉 Rundeck est un **outil à haut impact**, sa sécurité est critique.

---

## ⚠️ Erreurs fréquentes

- Donner des droits d’exécution trop larges
- Créer des jobs sans validation ou documentation
- Stocker des secrets en clair dans les scripts
- Automatiser des actions critiques sans contrôle
- Ne pas relire les logs d’exécution

👉 Une mauvaise utilisation peut transformer Rundeck en **point de risque majeur**.

---

## 🚨 Gestion des incidents

Rundeck intervient comme **outil de remédiation contrôlée** lors des incidents.

### 🔄 Cycle type avec supervision

1. Détection d’un incident (ex : alerte Zabbix)
2. Création ou mise à jour d’un ticket (Rundesk)
3. Analyse par l’ASR
4. Exécution d’un job Rundeck validé
5. Vérification du retour à la normale
6. Traçabilité complète des actions

👉 Rundeck réduit fortement le **MTTR** tout en gardant un contrôle humain.

---

## 📊 Valeur ajoutée pour l’entreprise

- Réduction des erreurs humaines
- Gain de temps opérationnel
- Amélioration de la sécurité
- Traçabilité et audit des actions

👉 Rundeck contribue directement à la **qualité de service** et à la **maturité du SI**.

---

## ✅ À retenir pour un ASR

👉 **Je dois savoir expliquer :**

- l’intérêt de l’automatisation contrôlée
- la différence entre script et runbook
- le rôle de Rundeck dans la chaîne d’exploitation

👉 **Je dois savoir faire :**

- créer un job sécurisé
- gérer les permissions
- analyser une exécution et ses logs

👉 **Je dois savoir surveiller :**

- les jobs sensibles
- les erreurs récurrentes
- les accès utilisateurs
