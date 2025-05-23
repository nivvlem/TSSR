# Administration Microsoft 365
## 👥 Utilisateurs et groupes dans Microsoft 365

### Types d’utilisateurs

|Type|Description|
|---|---|
|Cloud only|Créés directement dans M365, mot de passe géré par Azure AD|
|Synchronisés|Créés dans l’AD local, synchronisés via Azure AD Connect|

### Création d’un utilisateur

- Via le portail d’administration M365
- En masse via fichier `.csv`
- En **PowerShell** :

```powershell
New-MsolUser -UserPrincipalName snatsuki@domaine.tld -DisplayName "Subaru Natsuki" -FirstName Subaru -LastName Natsuki -Password "Pa55w.rd" -UsageLocation JP
```

### Suppression / restauration

```powershell
Remove-MsolUser -UserPrincipalName snatsuki@domaine.tld
Restore-MsolUser -UserPrincipalName snatsuki@domaine.tld
```

### Affectation d’un rôle

```powershell
Add-MsolRoleMember -RoleName "User Account Administrator" -RoleMemberEmailAddress admin@domaine.tld
```

---

## 🔐 Connexion à M365 en PowerShell

### Modules à connaître

- **MSOnline**
- **ExchangeOnlineManagement**
- **MicrosoftTeams**

### Connexion

```powershell
Connect-MsolService
Connect-ExchangeOnline -UserPrincipalName admin@domaine.onmicrosoft.com
Connect-MicrosoftTeams
Connect-IPPSSession -UserPrincipalName admin@domaine.onmicrosoft.com
```

---

## 💳 Gestion des licences

### Vérification

```powershell
Get-MsolAccountSku
```

### Attribution / retrait

```powershell
Set-MsolUserLicense -UserPrincipalName snatsuki@domaine.tld -AddLicenses "tenant:ENTERPRISEPACK"
Set-MsolUserLicense -UserPrincipalName snatsuki@domaine.tld -RemoveLicenses "tenant:ENTERPRISEPACK"
```

### Affectation groupée

```powershell
Get-MsolUser -All -Department Comptabilité -UnlicensedUsersOnly | ForEach-Object { Set-MsolUserLicense -UserPrincipalName $_.UserPrincipalName -AddLicenses "tenant:ENTERPRISEPACK" }
```

---

## 📬 Gestion Exchange Online

### Types de boîtes aux lettres

- **Utilisateur** : standard, avec licence
- **Partagée** : plusieurs accès, sans licence
- **Ressource** : salles, équipements
- **Contact / utilisateur de messagerie** : adresse externe

### Gestion en PowerShell

```powershell
Set-Mailbox -Identity "Subaru Natsuki" -IssueWarningQuota 49gb -ProhibitSendQuota 49.5gb -ProhibitSendReceiveQuota 50gb -UseDatabaseQuotaDefaults $false
```

### Boîte d’archive & rétention

```powershell
Set-Mailbox -Identity "Subaru Natsuki" -RetainDeletedItemsFor 30
Enable-Mailbox -Identity "Subaru Natsuki" -Archive
```

### Création boîte partagée + délégations

```powershell
New-Mailbox -Shared -Name "Support" -DisplayName "Support"
Add-MailboxPermission -Identity "Support" -User "Subaru Natsuki" -AccessRights FullAccess
Set-Mailbox -Identity "Support" -GrantSendOnBehalfTo "Subaru Natsuki"
```

---

## 📩 Connecteurs et règles de transport

- Connecteurs SMTP = lien entre équipements locaux et M365
- Règles de transport : modifient ou redirigent les mails (compliance, antispam)

### Exemple de connecteur

- Scanner réseau interne → smtp.office365.com:587
- Authentification obligatoire avec un compte Exchange

---

## 📱 Gestion des appareils mobiles (MDM)

### Types de gestion

|Type|Description|
|---|---|
|BYOD|Appareil personnel (Bring Your Own Device)|
|COPE|Entreprise fournit le matériel (Corporate Owned, Personally Enabled)|
|CYOD|Choix parmi une liste|

### Stratégies MDM

- Exiger chiffrement
- Verrouillage automatique
- Interdire app store, captures écran…

### DNS requis

```dns
CNAME EnterpriseEnrollment → EnterpriseEnrollment.manage.microsoft.com
CNAME EnterpriseRegistration → EnterpriseRegistration.windows.net
```

---

## 🔁 Azure AD Connect

### Fonction

- Synchronise les utilisateurs/groupes/contacts de l’AD local vers Azure AD
- Possible synchronisation mot de passe (hash SHA256)
- Nécessite un **compte de service dédié**

### Installation

1. Créer un suffixe UPN dans l’AD local
2. Installer **AzureADConnect.msi**
3. Associer tenant M365 avec AD local
4. Utiliser :

```powershell
Start-ADSyncSyncCycle -PolicyType Delta
```

---

## 🛡️ RBAC – Gestion des rôles administratifs

### Rôles prédéfinis

|Rôle|Nom PowerShell|Droit|
|---|---|---|
|Admin général|CompanyAdministrator|Tout accès|
|Admin mot de passe|HelpdeskAdministrator|Réinitialisation MDP|
|Admin utilisateurs|UserAccountAdministrator|Création/suppression|

### Commandes utiles

```powershell
Get-MsolRole
Get-MsolUserRole -UserPrincipalName snatsuki@domaine.tld
Add-MsolRoleMember -RoleName "Company Administrator" -RoleMemberEmailAddress admin@domaine.tld
```

---

## ✅ À retenir pour les révisions

- Microsoft 365 se pilote via **console web ET PowerShell**
- L’usage de **boîtes partagées** permet d’économiser des licences
- Azure AD Connect permet la **cohérence identitaire** entre AD local et Azure
- La gestion fine des accès se fait via le **RBAC**

---

## 📌 Bonnes pratiques professionnelles

- Toujours utiliser un **compte de service dédié** pour les synchronisations
- Documenter les affectations de rôles, quotas, délégations
- Ne jamais donner le rôle **Company Administrator** à plusieurs personnes
- Tester les connecteurs SMTP avec des outils en ligne (MXToolbox)
- Séparer les **stratégies MDM par profil utilisateur** (exécutif, technicien, terrain)