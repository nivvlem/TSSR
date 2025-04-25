# Mise en situation professionnelle : Services réseau

## Structure AD

## 🏗️ 1. Création des Unités d’Organisation (OU)

### 🧱 Bonnes pratiques Microsoft

- Une OU **par service métier**
- Une OU pour les **comptes machines (clients)**
- Une OU pour les **comptes serveurs**

### 📂 Structure proposée

```
TSSR.LOCAL (melvin13.domaine.tssr)
│
├── Utilisateurs
│   ├── Direction
│   ├── Comptabilité
│   ├── Secrétariat
│   ├── Production
│   └── Support-Informatique
│
├── Postes
│   ├── Clients
│   └── Serveurs
```

### 🛠️ Création via PowerShell

```powershell
New-ADOrganizationalUnit -Name "Utilisateurs" -Path "DC=melvin13,DC=domaine,DC=tssr"
New-ADOrganizationalUnit -Name "Direction" -Path "OU=Utilisateurs,DC=melvin13,DC=domaine,DC=tssr"
New-ADOrganizationalUnit -Name "Comptabilité" -Path "OU=Utilisateurs,DC=melvin13,DC=domaine,DC=tssr"
...
```

> Répéter pour chaque service et pour `Postes > Clients` et `Postes > Serveurs`.

---

## 👥 2. Création des utilisateurs

### Convention de nommage

**Identifiant** = première lettre du prénom + nom de famille (en minuscule)

### Exemple (Direction)

|Nom complet|Identifiant|Service|
|---|---|---|
|Christian Hef|chef|Direction|
|Pauline Atron|patron|Direction|
|Pascaline Résident|president|Direction|

> Répéter l’opération pour les autres services.

### Création via PowerShell

```powershell
New-ADUser -Name "Christian Hef" -SamAccountName chef -UserPrincipalName chef@melvin13.domaine.tssr -AccountPassword (ConvertTo-SecureString "P@ssword2024" -AsPlainText -Force) -Enabled $true -Path "OU=Direction,OU=Utilisateurs,DC=melvin13,DC=domaine,DC=tssr"
```

---

## 🧑‍🤝‍🧑 3. Création des groupes

### Objectif

Créer un groupe par service pour la gestion des partages, GPO, accès.

### Exemple :

```powershell
New-ADGroup -Name "G_Direction" -GroupScope Global -GroupCategory Security -Path "OU=Direction,OU=Utilisateurs,DC=melvin13,DC=domaine,DC=tssr"
Add-ADGroupMember -Identity "G_Direction" -Members chef, patron, president
```

> Répéter pour tous les services

---

## 🧪 4. Tests d’ouverture de session

### Sur CLT-WIN-MD

1. Connexion avec un utilisateur nouvellement créé (ex : `chef`).
2. Vérification que la session s’ouvre sans erreur.
3. Validation la connexion au domaine avec :

```powershell
whoami /upn
```

> Optionnel : créer un fichier texte dans `C:\Users\<identifiant>` pour chaque test utilisateur

---

## 🧠 Synthèse

|Élément|Détails|
|---|---|
|OU métiers|Direction, Comptabilité, Secrétariat…|
|OU techniques|Clients, Serveurs|
|Utilisateurs|Identifiants : pnom (ex: chef)|
|Groupes|G_ (ex: G_Direction)|
|Tests de session|Réalisés sur CLT-WIN-MD|
