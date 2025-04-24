# 📧 Exploiter Outlook et savoir le dépanner

## 📬 Cheminement d’un email

### Analogie postale (lettre physique)

- Envoi → collecte → tri → transfert → réception → lecture

### Étapes d’un mail (comparaison technique)

1. Envoi via client mail (Outlook, Thunderbird, etc.)
2. Serveur SMTP (soumission)
3. Transport vers serveur destinataire
4. Téléchargement via **POP/IMAP/ActiveSync/HTTPS/MAPI**
5. Affichage dans la boîte de réception

**Protocoles utilisés :**

- **SMTP** : envoi
- **POP / IMAP / HTTPS** : réception

---

## 🌐 Ports & Protocoles utilisés

|Protocole|Non sécurisé|Sécurisé (TLS/SSL)|
|---|---|---|
|HTTP|80|443|
|POP3|110|995|
|IMAP4|143|993|
|SMTP|25|587, 2525 (465 déprécié)|

**Bonnes pratiques** :

- N’utiliser que les versions **sécurisées** (TLS/SSL)
- **Vérifier les ports ouverts** sur les pare-feu d’entreprise

---

## 🔧 Installation & Configuration Outlook

### Installation depuis Microsoft 365

- Accès via [https://portal.office.com](https://portal.office.com)
- Saisie de l’adresse email et vérification d’identité

### Autodiscover

- Configuration automatique via adresse email
- Outlook récupère un fichier `.xml` avec les paramètres (serveur, ports, etc.)
- Détection des options de configuration sans intervention manuelle

### Outils de test

- `CTRL + clic droit` sur l'icône Outlook > **État de la connexion** / **Test automatique**
- Retour HTTP interprété :
    - `2xx` succès / `4xx` erreur client / `5xx` serveur

---

## 💻 Présentation d’Outlook

### Versions disponibles

- **Outlook 365 / 2019** (client local) : nécessite installation, accès hors ligne (fichier .ost)
- **Outlook Online** : via navigateur, pas de comptes IMAP externes

### Fonctionnalités principales

- Messagerie électronique
- Calendrier
- Réunions
- Contacts
- Tâches

---

## 📨 Messagerie Outlook

### Fonctionnalités

- Affichage en **conversation** : messages regroupés
- **Réponses automatiques** : en cas d’absence
- **Règles de message** : tri, déplacement, suppression auto
- **Rappel/remplacement** d’un message non lu

---

## 📅 Calendrier Outlook

### Événements

- **Rendez-vous** : temps bloqué seul
- **Réunion** : invitation d'autres personnes
- **Événement** : toute la journée, non bloquant

### Tâches & groupes de calendrier

- Visualisation combinée de plusieurs calendriers
- Attribution et suivi des tâches

---

## 🗂️ Autres éléments & fonctionnalités

- **Éléments Outlook** : messages, réunions, tâches…
- **Catégories** : marquer, trier, prioriser
- **Archivage automatique** : libération d’espace boîte aux lettres
- **Raccourcis clavier** disponibles (voir documentation Microsoft officielle)

---

## 🛠️ Dépannage Outlook

### Outils et techniques

- **Mode sans échec** : désactivation des modules complémentaires
- **Journalisation** : log d’erreurs réseau ou connexion
- **Recréer un profil** : pour résoudre des erreurs persistantes
- **Fichiers .ost / .pst** :
    - `.ost` : données hors ligne Exchange
    - `.pst` : données locales POP/IMAP
    - Taille max recommandée : 50 Go (voir `MaxFileSize`)

### Outils de réparation

- `SCANPST.EXE` : diagnostic & réparation des fichiers .pst/.ost
- **EasyFix** ou Microsoft Support Diagnostics
- `Test-OutlookConnectivity` : test Outlook Anywhere (PowerShell)

---

## 📘 À retenir pour l’examen

- Le **cheminement d’un mail** = SMTP (envoi) + IMAP/POP/HTTPS (réception)
- L’**Autodiscover** permet la configuration automatique d’Outlook
- Les **protocoles sécurisés** doivent être privilégiés : 993 (IMAP), 995 (POP), 587 (SMTP)
- Savoir **créer des règles**, planifier des rendez-vous et gérer les réponses automatiques
- Distinguer les fichiers `.pst` et `.ost`

## 🧑‍💼 Bonnes pratiques professionnelles

- Toujours utiliser **Outlook 365 à jour** avec TLS activé
- Centraliser les **modèles de réponse**, règles et signatures
- Activer les **règles automatiques de tri** pour limiter les boîtes surchargées
- **Désactiver les modules inutiles** pour optimiser les performances
- **Documenter les profils Outlook** (fichiers, chemins, sauvegardes)
