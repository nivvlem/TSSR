# Les utilisateurs et les groupes sous Windows

## 👤 La notion d’utilisateur

- Un utilisateur représente un **compte identifié** permettant d’accéder aux ressources du système.
- Authentification par :
    - **Identifiant + mot de passe**
    - **Biométrie (Windows Hello)**
    - **Objet physique** : carte à puce, badge, etc.
    - **Authentification multifacteur** : SMS, validation par mail, etc.
- L’utilisateur peut être local (lié à un PC) ou du domaine (lié à Active Directory)

> 📌 Chaque utilisateur est identifié de manière unique par un **SID** (Security Identifier).

---

## 🗂️ Les profils utilisateurs

|Type de profil|Description|
|---|---|
|Profil local|Créé dans `C:\Users` lors de la première connexion|
|Profil par défaut|Modèle utilisé pour la création des nouveaux profils|
|Profil public|Contenu accessible par tous les utilisateurs de l’ordinateur|

- Un profil contient les répertoires **Documents**, **Images**, **Téléchargements**, **Bureau**...
- **Ne jamais modifier ou supprimer manuellement** les dossiers de `C:\Users` !
- Utiliser `sysdm.cpl` > Paramètres système avancés > Profils utilisateurs

---

## 👥 Gestion des groupes

- Un groupe est un **ensemble d'utilisateurs** partageant les mêmes autorisations
- Chaque groupe possède également un **SID** et ajoute ses autorisations au jeton de sécurité de l’utilisateur

### 🔹 Types de groupes :

- **Groupes locaux** : présents uniquement sur un ordinateur (ex : `Administrateurs`, `Utilisateurs`)
- **Groupes prédéfinis** : livrés avec le système (ex : `Opérateurs de sauvegarde`, `Invités`)
- **Entités intégrées de sécurité** : invisibles mais utilisés par le système (`Tout le monde`, `Utilisateurs authentifiés`)

---

## 🧰 Outils de gestion des utilisateurs et groupes

### 🔸 Interface graphique

|Console / outil|Utilité principale|
|---|---|
|`lusrmgr.msc`|Gérer les utilisateurs et groupes **locaux**|
|`compmgmt.msc`|Gestion de l’ordinateur, accès à `lusrmgr` et `diskmgmt`|
|`Panneau de configuration`|Gestion orientée utilisateur des comptes|

### 🔸 CMD classique

```bash
net user               # Liste les utilisateurs locaux
net user utilisateur   # Affiche les détails d’un utilisateur
net localgroup         # Liste les groupes locaux
net localgroup groupe  # Affiche les membres du groupe
```

### 🔸 PowerShell moderne

|Cmdlet|Rôle|
|---|---|
|`Get-LocalUser`|Affiche les comptes utilisateurs locaux|
|`New-LocalUser`|Crée un nouvel utilisateur|
|`Set-LocalUser`|Modifie un utilisateur|
|`Rename-LocalUser`|Renomme un utilisateur|
|`Enable-LocalUser`|Active un compte|
|`Disable-LocalUser`|Désactive un compte|
|`Remove-LocalUser`|Supprime un utilisateur|
|`Get-LocalGroup`|Affiche les groupes locaux|
|`Add-LocalGroupMember`|Ajoute un utilisateur à un groupe|
|`Remove-LocalGroupMember`|Supprime un utilisateur d’un groupe|

---

## 🛡️ UAC – Contrôle de compte utilisateur

- UAC = **User Account Control**
- Même les administrateurs doivent valider les actions sensibles

### 🔹 Objectifs de l’UAC :

- Prévenir les actions malveillantes
- Avertir lors de modifications critiques

### 🔹 Comportement :

- Demande de **validation** pour un administrateur
- Demande d’**authentification** pour un utilisateur standard

### 🔹 Configuration :

- **Panneau de configuration** > `Comptes d’utilisateurs` > `Modifier les paramètres de contrôle`...
- Ou via stratégie de sécurité locale : `secpol.msc` > `Stratégies locales > Options de sécurité`

---

## ✅ À retenir pour les révisions

- **Un utilisateur ≠ un profil** : le profil est généré à la première connexion
- L’UAC est actif même pour les administrateurs
- Les **groupes** définissent les autorisations d'accès
- Utiliser `net user`, `lusrmgr.msc` ou **PowerShell** pour une gestion avancée
- Les comptes désactivés (Administrateur, Invité) peuvent être réactivés via PowerShell

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Créer un compte standard pour l’utilisateur|Limiter les droits et réduire la surface d’attaque|
|Désactiver les comptes inutilisés|Réduire les risques d’accès non autorisés|
|Utiliser des mots de passe robustes|Protéger les comptes contre les attaques|
|Documenter les groupes et rôles attribués|Faciliter la maintenance et la traçabilité|
|Automatiser la gestion avec PowerShell|Gain de temps et réduction des erreurs humaines|
