# TP – Installation d'une PKI interne et remplacement du certificat IIS

## 🧠 Objectif

Mettre en œuvre une **infrastructure PKI interne** complète pour émettre un certificat signé, remplacer un certificat autosigné IIS et tester l'accès sécurisé au site web via HTTPS sans alerte de sécurité.

---

## 🧾 Environnement de travail

- Serveur d'annuaire : `AD-DNS` (Windows Server)
- Serveur web IIS : `SRV-IIS`
- Nom de domaine interne : `nivvlem.md`
- Nom DNS du site : `wwi.nivvlem.md`

---

## 🏗️ Étapes de déploiement de la PKI

### 1. Installation du rôle ADCS sur `AD-DNS`

- Ouvrir **Gestionnaire de serveur** > **Ajouter des rôles**
- Sélectionner **Services de certificats Active Directory**
- Ajouter les services :
    - **Autorité de certification**
    - **Inscription via le Web (Web Enrollment)**

### 2. Configuration de l’autorité de certification

- Post-installation : configurer les rôles choisis
- Choisir :
    - **Autorité d’entreprise**
    - **AC racine**
    - Clé privée à générer
    - Fournisseur : `RSA Microsoft Software Key Storage Provider`
    - Longueur de clé : **2048 bits**
    - Hash : **SHA512**
- Nom commun de l’AC : `pki.nivvlem.md`

---

## 🔧 Création d’un modèle de certificat pour IIS

### 1. Dupliquer un modèle existant

- Ouvrir la console MMC **Autorité de certification** > clic droit **Modèles de certificats** > **Gérer**
- Sélectionner `Serveur Web` > clic droit > **Dupliquer le modèle**

### 2. Modifier les paramètres du modèle

- **Compatibilité** : ajuster selon les OS du domaine
- **Général** :
    - Nom du modèle : `srv-iis.nivvlem.md`
- **Sécurité** :
    - Ajouter le compte **Ordinateur** de `SRV-IIS`
    - Autoriser les droits **Lecture** et **Inscription**

### 3. Publier le modèle

- Retour dans **Autorité de certification** > clic droit **Modèles de certificats** > **Nouveau** > **Modèle à émettre**
- Sélectionner `srv-iis.nivvlem.md` > Valider

---

## 📝 Demande et obtention du certificat signé (SRV-IIS)

### 1. Ouvrir la console MMC sur `SRV-IIS`

- Lancer `certlm.msc`
- Dans `Personnel` > clic droit > **Toutes les tâches** > **Demander un nouveau certificat**

### 2. Sélectionner la stratégie d’inscription

- Choisir : **Stratégie d’inscription à Active Directory**
- Sélectionner le modèle `srv-iis.nivvlem.md`

### 3. Renseigner les champs de la demande

- Onglet **Objet** : `Nom du sujet = wwi.nivvlem.md`
- Onglet **Général** :
    - Nom convivial : `Certificat SSL pour SRV-IIS`
    - Description : `Certificat serveur Web signé pour site HTTPS`
- Valider la demande et inscrire le certificat

---

## 🌐 Remplacement du certificat autosigné dans IIS

### 1. Ouvrir IIS Manager

- Aller dans **Certificats de serveur** > vérifier présence du certificat signé

### 2. Modifier la liaison HTTPS du site `wwi.nivvlem.md`

- Aller dans **Sites > wwi** > clic droit > **Modifier les liaisons**
- Modifier ou ajouter une liaison **https**, sélectionner le **certificat signé**

### 3. Redémarrer IIS

```powershell
iisreset
```

### 4. Tester la connexion HTTPS

- Naviguer vers : `https://wwi.nivvlem.md`
- Si tout est configuré, **aucun avertissement** de sécurité ne doit s'afficher

---

## 🔧 Déploiement du certificat racine sur les postes clients

### Cas des machines **dans le domaine**

- Le certificat racine est automatiquement déployé via l’AD (GPO)
- Un redémarrage du poste client peut accélérer la prise en compte

### Cas des machines **hors domaine**

- Récupérer le certificat de l’AC racine depuis `http://AD-DNS/certsrv`
- Installer manuellement dans **Autorités de certification racines de confiance** via `certmgr.msc`

---

## ✅ À retenir pour les révisions

- Une **PKI interne** permet de délivrer des certificats valides en environnement privé
- Le remplacement du certificat autosigné par un **certificat signé** supprime les alertes de sécurité
- Un **modèle personnalisé** simplifie les demandes futures
- L’AC racine doit être **fiable** et **accessible** pour que le certificat soit reconnu

---

## 📌 Bonnes pratiques professionnelles

- Toujours documenter les **modèles, certificats émis, durée, machines concernées**
- Conserver une **sauvegarde sécurisée** de l’AC racine
- Prévoir un **plan de révocation et renouvellement** des certificats
- Tester tous les accès HTTPS depuis **plusieurs postes clients**
- Mettre en place une **supervision des expirations de certificats**