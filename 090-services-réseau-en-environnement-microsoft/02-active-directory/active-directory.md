# Active Directory

## 🌐 Concepts fondamentaux d’Active Directory

|Élément|Rôle|
|---|---|
|**Domaine**|Regroupe objets (utilisateurs, groupes, ordinateurs) et règles associées|
|**Forêt**|Ensemble de domaines partageant le même schéma et configuration|
|**Contrôleur de domaine (DC)**|Serveur qui héberge AD DS et gère l’authentification|
|**OU (Organizational Unit)**|Conteneur logique permettant l’organisation des objets|
|**Sites**|Optimisent la réplication entre sous-réseaux géographiques|

> 🔐 Protocoles utilisés : LDAP (annuaire), DNS (résolution), Kerberos (authentification)

---

## 🏗️ Déploiement et installation d’Active Directory

### 🔹 Prérequis

- Nom d’hôte et IP fixe
- Composants AD DS installés

### 🔹 Installation via GUI

- `Server Manager` > `Add roles and features` > Active Directory Domain Services
- Puis promotion via `Promote this server to a domain controller`

### 🔹 Installation via PowerShell

```powershell
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "domaine.local"
```

---

## 👥 Gestion des objets AD

### 🔹 Création d’OU, utilisateurs, ordinateurs, groupes (via GUI ou PowerShell)

```powershell
New-ADOrganizationalUnit -Name "MonEntreprise"
New-ADUser -Name "Edward" -GivenName "FullMetal" -Surname "Elric" -SamAccountName "edward" -AccountPassword (ConvertTo-SecureString "MotDePasse123" -AsPlainText -Force) -Enabled $true
New-ADComputer -Name "PC-Edward"
New-ADGroup -Name "GG_Alchimie_CentralCity" -GroupScope Global -GroupCategory Security
```

### 🔹 Modèle d’utilisateur

- Créer un compte modèle (prérempli, désactivé)
- Le dupliquer pour générer rapidement de nouveaux comptes cohérents

### 🔹 Profils itinérants

- Stockés sur un partage réseau
- Synchronisés à l’ouverture et fermeture de session

---

## 🔐 Gestion des accès : AGDLP

### Méthodologie AGDLP

- **A** : Utilisateur
- **G** : Groupe Global → regroupe les utilisateurs par rôle/fonction
- **DL** : Groupe Domaine Local → regroupe les G pour une ressource spécifique
- **P** : Ressource protégée (NTFS ou partage)

### 🔹 Exemple

```
Edward → GG_Alchimie_CentralCity → DL_Alchimiste_Sur_SRVFIC_CT → Dossier Alchimie (Contrôle total)
```

### 🔹 Attributions NTFS

- Lecture, Écriture, Modification, Contrôle total, etc.
- Héritage possible ou à casser selon besoins

---

## 📂 Gestion du partage de fichiers

- Créer un dossier → clic droit > `Partage avancé` > Ajouter les DL
- Attribuer les droits dans l’onglet **Sécurité** (NTFS) + **Partage**
- Publier dans l’AD pour accès rapide via la recherche réseau

### 🔹 Bonnes pratiques

- N’attribuer les droits **qu’aux groupes**
- Ne jamais cumuler **autorisations utilisateur + groupe**
- Le refus **l’emporte** toujours

---

## 🖨️ Gestion des impressions en environnement AD

### 🔹 Installation du rôle (GUI ou PowerShell)

```powershell
Install-WindowsFeature -Name Print-Services -IncludeManagementTools
```

### 🔹 Étapes (via Print Management)

1. Ajouter un **driver** (HP, Canon…)
2. Créer un **port** (IP ou local)
3. Ajouter une **imprimante** associée à un driver et un port
4. Partager l’imprimante → elle est alors accessible à tous les clients du domaine

### 🔹 Déploiement client

- Manuel (via `\\NomServeur`)
- Automatique par **stratégie de groupe** (GPO)

---

## 🧠 À retenir pour les révisions

- L’AD centralise l’authentification et la gestion des ressources dans un domaine
- Tous les objets AD ont des propriétés spécifiques manipulables en GUI ou PowerShell
- Les OU permettent une organisation logique et délégation d’administration
- AGDLP = méthode de sécurité structurée, adoptée en entreprise
- Le serveur d’impression simplifie la gestion et déploiement d’imprimantes en réseau

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Ne jamais donner de droits à un utilisateur seul|Utiliser des groupes pour la gestion des accès|
|Isoler comptes, groupes et machines dans des OU dédiées|Organisation et GPO ciblées|
|Utiliser des noms explicites pour les objets|Lisibilité et traçabilité dans l’AD|
|Documenter l’arborescence OU et le plan AGDLP|Facilite l’audit et le transfert de responsabilités|
|Tester les droits via un utilisateur de test|Vérification concrète de la chaîne AGDLP|
