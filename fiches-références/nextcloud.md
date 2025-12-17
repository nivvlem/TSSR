# ☁️ Nextcloud

## 📌 Présentation

**Nextcloud** est une plateforme **open source de collaboration et de stockage de fichiers** permettant aux utilisateurs de partager, synchroniser et travailler sur des données de manière sécurisée.

- **Type d’outil** : cloud collaboratif / partage de fichiers
- **Usage principal** : stockage, synchronisation et collaboration
- **Utilisateurs** : collaborateurs, équipes IT, administrateurs

👉 Nextcloud constitue une **alternative souveraine** aux solutions cloud propriétaires (Google Drive, OneDrive).

---

## 🏢 Cas d’usage en entreprise

En environnement professionnel, Nextcloud est utilisé pour :

- Centraliser les **documents professionnels**
- Permettre le **partage sécurisé** de fichiers
- Faciliter le **travail collaboratif**
- Accéder aux données depuis différents appareils
- Maîtriser l’**hébergement et la conformité RGPD**

👉 Nextcloud permet de garder la **maîtrise des données** tout en offrant des usages modernes.

---

## 🧠 Concepts et notions clés

> Cette section présente les notions essentielles à comprendre pour exploiter Nextcloud en contexte professionnel.

### 🔹 Instance Nextcloud

Serveur hébergeant l’application Nextcloud et les données associées.

### 🔹 Utilisateur

Compte permettant l’accès aux fichiers et services Nextcloud.

### 🔹 Groupe

Mécanisme permettant de gérer les droits de manière collective.

### 🔹 Partage

Fonctionnalité permettant de donner accès à des fichiers ou dossiers (interne ou externe).

### 🔹 Synchronisation

Mécanisme de mise à jour automatique des fichiers entre le serveur et les clients.

---

## ⚙️ Fonctionnement général

1. Nextcloud est installé sur un **serveur Linux** (on‑premise ou hébergé)
2. L’application web est accessible via **HTTPS**
3. Les utilisateurs s’authentifient (local, LDAP/AD, SSO selon configuration)
4. Les fichiers sont stockés sur le serveur (local ou stockage externe)
5. Les clients (web, desktop, mobile) synchronisent automatiquement les données
6. Les droits et partages contrôlent l’accès aux ressources

👉 Nextcloud agit comme un **hub central de données et de collaboration**.

---

## 🛠️ Rôle et responsabilités de l’ASR

Un ASR est typiquement responsable de :

- Installation et mises à jour de Nextcloud
- Gestion des utilisateurs, groupes et quotas
- Intégration à l’annuaire (LDAP / Active Directory)
- Paramétrage des partages internes et externes
- Sécurisation des accès (HTTPS, politiques d’authentification)
- Gestion du stockage et anticipation des saturations
- Mise en place et test des sauvegardes
- Documentation des usages et bonnes pratiques utilisateurs

👉 Nextcloud est un **service critique orienté utilisateurs**, nécessitant rigueur et anticipation.

---

## 🔐 Sécurité et bonnes pratiques

- Accès exclusivement en **HTTPS**
- Authentification forte si possible (MFA)
- Intégration LDAP / AD pour centraliser les identités
- Gestion fine des droits de partage (principe du moindre privilège)
- Chiffrement des données en transit et, si possible, au repos
- Journalisation des accès et actions
- Sauvegardes régulières et restaurations testées

👉 Nextcloud est directement concerné par les **exigences RGPD**.

---

## ⚠️ Erreurs fréquentes

- Laisser des partages publics ouverts
- Ne pas surveiller l’espace disque
- Absence de sauvegarde
- Trop de droits utilisateurs
- Mises à jour négligées

👉 Une mauvaise configuration expose les données de l’entreprise.

---

## 🚨 Gestion des incidents

Exemples d’incidents courants :

- indisponibilité de l’instance Nextcloud
- erreurs de synchronisation client
- saturation de l’espace disque
- accès non autorisé ou partage inapproprié

### 🔄 Traitement type

1. Détection (utilisateur ou supervision Zabbix)
2. Qualification de l’incident
3. Diagnostic (service, stockage, réseau, droits)
4. Action corrective (redémarrage, extension, correction)
5. Communication aux utilisateurs
6. Documentation et retour d’expérience

👉 Une bonne gestion des incidents limite l’impact utilisateur.

---

## 📊 Valeur ajoutée pour l’entreprise

- Centralisation et sécurisation des données
- Collaboration facilitée entre équipes
- Maîtrise de l’hébergement et des accès
- Conformité RGPD et souveraineté des données
- Image professionnelle vis‑à‑vis des partenaires

---

## ✅ À retenir pour un ASR

👉 **Je dois savoir expliquer :**

- le rôle d’un cloud collaboratif
- la différence entre stockage local et collaboratif
- les enjeux de sécurité et de conformité RGPD

👉 **Je dois savoir faire :**

- gérer utilisateurs, groupes et quotas
- sécuriser et auditer les partages
- restaurer des fichiers ou une instance

👉 **Je dois savoir surveiller :**

- l’espace disque (critique)
- la disponibilité du service
- les accès et partages sensibles
