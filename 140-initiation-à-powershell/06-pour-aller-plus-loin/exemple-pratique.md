# TP – Activités pour aller plus loin
## 🧠 Activité 1 – Comprendre et commenter un script PowerShell (Q1)

### Objectif : analyser un script d'automatisation AD

### Script commenté :

```powershell
# Module 06 – PowerShell : Pour aller plus loin
# Activité 1 – Comprendre et commenter un script

# Création de l’OU principale pour l’entreprise
$societe="_Entreprise"
New-ADOrganizationalUnit $societe -ProtectedFromAccidentalDeletion $false

# Création des OU enfants dans l'OU entreprise
$base = Get-ADOrganizationalUnit -Filter { name -like "_Ent*" }
New-ADOrganizationalUnit Groupes -Path $base -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit Utilisateurs -Path $base -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit Ordinateurs -Path $base -ProtectedFromAccidentalDeletion $false
Get-ADOrganizationalUnit -filter * -SearchBase $base | ft name,DistinguishedName -AutoSize

# Création de comptes utilisateurs modèles dans l’OU Utilisateurs
$ubase = Get-ADOrganizationalUnit -Filter { name -eq "Utilisateurs" }
$upn = "@ad30.societegb.fr"
New-ADUser -Name "_mod_dir" -SamAccountName "mod_dir" -Description "Modèle Direction" -City Nantes -PostalCode 44000 -Department Direction -Company "Société GB" -Path $ubase
New-ADUser -Name "_mod_info" -SamAccountName "mod_info" -Description "Modèle Informatique" -City Nantes -PostalCode 44000 -Department Informatique -Company "Société GB" -Path $ubase
New-ADUser -Name "_mod_util" -SamAccountName "mod_util" -Description "Modèle Utilisateurs" -Company "Société GB" -Path $ubase

# Paramétrage des heures de connexion pour le modèle utilisateur générique
[byte[]]$hours = @(0,0,0,192,255,15,192,255,15,192,255,15,192,255,15,192,255,15,192,255,15)
Set-ADUser -Identity "mod_util" -Replace @{logonhours = $hours}

# Création d’un utilisateur à partir du modèle Direction
$mdir = Get-ADUser -Filter { samaccountname -eq "mod_dir" } -Properties city,postalcode,department,company
$uname = "david"
New-ADUser -Instance $mdir -Name $uname -GivenName $uname -SamAccountName $uname -UserPrincipalName "$uname$upn" -Path $ubase -OfficePhone "504" -Title "Directeur Comptabilités Finances"

# Création de deux utilisateurs à partir du modèle Informatique
$minf = Get-ADUser -Filter { samaccountname -eq "mod_info" } -Properties city,postalcode,department,company
$unames = @("isabelle","ivan")
foreach ($uname in $unames) {
    New-ADUser -Instance $minf -Name $uname -GivenName $uname -SamAccountName $uname -UserPrincipalName "$uname$upn" -Path $ubase
}

# Modification de certains attributs post-création
Set-ADUser -Identity isabelle -Title "Administratrice SR" -OfficePhone "666"
Set-ADUser -Identity ivan -Title "Support Technique"

# Création d’utilisateurs génériques via modèle utilisateur
$mutil = Get-ADUser -Filter { samaccountname -eq "mod_util" } -Properties logonhours,company
$unames = @("christelle","christophe")
foreach ($uname in $unames) {
    New-ADUser -Instance $mutil -Name $uname -GivenName $uname -SamAccountName $uname -UserPrincipalName "$uname$upn" -Path $ubase
}

# Définition d’une date d’expiration pour un utilisateur temporaire
Set-ADAccountExpiration -Identity "christophe" -DateTime "01/01/2021"

# Définition et activation des mots de passe utilisateurs
$unames = @("david","isabelle","christelle")
$mdp = 'Pa$$w0rd'
foreach ($uname in $unames) {
    Set-ADAccountPassword $uname -NewPassword (ConvertTo-SecureString -AsPlainText $mdp -Force)
    Enable-ADAccount $uname
}

$unames = @("ivan","christophe")
foreach ($uname in $unames) {
    Set-ADAccountPassword $uname -NewPassword (ConvertTo-SecureString -AsPlainText $mdp -Force)
    Enable-ADAccount $uname
}

# Création de groupes dans l’OU Groupes
$gbase = Get-ADOrganizationalUnit -Filter { name -eq "Groupes" }
New-ADGroup G_Compta -Path $gbase -GroupScope Global -Description "Service Comptabilité"
New-ADGroup G_Direction -Path $gbase -GroupScope Global -Description "Service Direction" -OtherAttributes @{'mail'='direction@societegb.fr'}
New-ADGroup G_Info -Path $gbase -GroupScope Global -Description "Service Informatique"
New-ADGroup G_Info_Tech -Path $gbase -GroupScope Global -Description "Techniciens - Service Informatique"
New-ADGroup G_Interim -Path $gbase -GroupScope Global -Description "Personnel intérimaire"
Get-ADGroup -Filter { name -like "G_*" } | Format-Table name,DistinguishedName -AutoSize

# Attribution des membres aux groupes correspondants
Add-ADGroupMember G_Compta christelle,christophe
Add-ADGroupMember G_Direction david,mod_dir
Add-ADGroupMember G_Info isabelle,ivan,mod_info
Add-ADGroupMember G_Info_Tech ivan
Add-ADGroupMember G_Interim christophe

# Affichage des membres de chaque groupe
$gg = Get-ADGroup -Filter { name -like "G_*" }
foreach ($group in $gg) {
    $group.Name
    Get-ADGroupMember $group | Format-Table name,DistinguishedName -AutoSize
}

# Création de sous-OU dans l’OU Utilisateurs
$ubase = Get-ADOrganizationalUnit -Filter { name -eq "Utilisateurs" }
New-ADOrganizationalUnit S_Direction -Path $ubase -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit S_Compta -Path $ubase -ProtectedFromAccidentalDeletion $false
New-ADOrganizationalUnit S_Info -Path $ubase -ProtectedFromAccidentalDeletion $false

# Affichage des OU créées
$base = Get-ADOrganizationalUnit -Filter { name -like "_Ent*" }
Get-ADOrganizationalUnit -Filter * -SearchBase $base | Format-Table name,DistinguishedName -AutoSize

# Export des membres d’un groupe et des détails d’un utilisateur
Get-ADGroupMember G_Info | Select name,distinguishedname | Out-File -Encoding utf8 "c:\ctrl_membres_informatique.txt"
Get-ADUser david | Out-File -Encoding utf8 "c:\detail_user_david.txt"

# Création de groupes de sécurité pour la gestion des droits d’accès aux données
New-ADGroup DL_Racine_Data_CT -Path $gbase -GroupScope DomainLocal -Description "Racine DATA en CT"
New-ADGroup DL_Racine_Data_M -Path $gbase -GroupScope DomainLocal -Description "Racine DATA en M"
New-ADGroup DL_Racine_Data_L -Path $gbase -GroupScope DomainLocal -Description "Racine DATA en L"
New-ADGroup DL_Data_Doc_CT -Path $gbase -GroupScope DomainLocal -Description "DATA Docs en CT"
New-ADGroup DL_Data_Doc_M -Path $gbase -GroupScope DomainLocal -Description "DATA Docs en M"
New-ADGroup DL_Data_Doc_L -Path $gbase -GroupScope DomainLocal -Description "DATA Docs en L"
New-ADGroup DL_Data_Doc_Refus -Path $gbase -GroupScope DomainLocal -Description "DATA Docs en refus"
New-ADGroup DL_Data_Compta_CT -Path $gbase -GroupScope DomainLocal -Description "DATA Compta en CT"
New-ADGroup DL_Data_Compta_M -Path $gbase -GroupScope DomainLocal -Description "DATA Compta en M"
New-ADGroup DL_Data_Compta_L -Path $gbase -GroupScope DomainLocal -Description "DATA Compta en L"

# Vérification des groupes DL créés
Get-ADGroup -Filter { name -like "DL_*" } | Format-Table name,DistinguishedName -AutoSize

# Groupes hiérarchiques et de délégation
New-ADGroup G_Entreprise -Path $gbase -GroupScope Global -Description "Personnel de l'entreprise"
Add-ADGroupMember G_Entreprise G_Compta,G_Direction,G_Info
New-ADGroup G_Info_Adm -Path $gbase -GroupScope Global -Description "Administrateurs - Service Informatique"
Add-ADGroupMember G_Info_Adm isabelle

# Ajout de groupes à des groupes de délégation
Add-ADGroupMember DL_Racine_Data_CT G_Info_Adm
Add-ADGroupMember DL_Data_Doc_L G_Entreprise
Add-ADGroupMember DL_Data_Doc_Refus G_Interim
Add-ADGroupMember DL_Data_Compta_M G_Compta
Add-ADGroupMember DL_Data_Compta_L G_Direction

New-ADGroup DL_Delegu_Gestion_Comptes_Compta -Path $gbase -GroupScope DomainLocal -Description "Délégation gestion des comptes Compta"
New-ADGroup DL_Delegu_Gestion_Comptes -Path $gbase -GroupScope DomainLocal -Description "Délégation gestion des comptes entreprise - sauf Service Info"

New-ADGroup G_Direction_Resp -Path $gbase -GroupScope Global -Description "Responsable - Service Direction"
Add-ADGroupMember G_Direction_Resp david

Add-ADGroupMember DL_Delegu_Gestion_Comptes_Compta G_Direction_Resp
Add-ADGroupMember DL_Delegu_Gestion_Comptes G_Info_Tech
```


---

## 🛠️ Activité 2 – Correction d’un script contenant des bugs (Q2)

### Objectif : corriger un script erroné de configuration DNS

### Script corrigé :

```powershell
# Module 06 – PowerShell : Pour aller plus loin
# Activité 2 – Correction de bugs dans un script DNS

# Installation du rôle DNS avec les outils de gestion
Install-WindowsFeature DNS -IncludeManagementTools

# Définition du serveur DNS préféré pour la carte réseau (Index à adapter)
Set-DnsClientServerAddress -InterfaceIndex 12 -ServerAddresses 172.20.0.2 -PassThru

# Configuration du suffixe DNS principal
Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name Domain -Value "gilles.eni"
Restart-Computer

# CONFIGURATION DES REDIRECTEURS

# Redirecteur conditionnel vers gilles.eni
Add-DnsServerConditionalForwarderZone -Name "gilles.eni" -MasterServers 172.20.0.1

# Redirecteur vers S1-GL et ENI (à adapter selon usage réel)
Set-DnsServerForwarder -IPAddress 10.0.0.3,10.100.0.3 -PassThru

# ZONE PRIMAIRE ENFANT

# Création de la zone DNS primaire "ad.gilles.eni"
Add-DnsServerPrimaryZone -Name "ad.gilles.eni" -ZoneFile "ad.gilles.eni.dns" -DynamicUpdate Secure

# Ajout d’un enregistrement Glue DNS pour le serveur s2-w-cd
Add-DnsServerResourceRecordA -Name "s2-w-cd" -IPv4Address 172.20.0.1 -ZoneName "ad.gilles.eni"

# Ajout d’un enregistrement A pour dns1 dans la zone
Add-DnsServerResourceRecordA -Name "dns1" -IPv4Address 172.20.0.2 -ZoneName "ad.gilles.eni"

# Ajout d’un enregistrement CNAME (alias)
Add-DnsServerResourceRecordCName -Name "dns2" -HostNameAlias "s3-gl.gilles.eni" -ZoneName "ad.gilles.eni"

# Lister les enregistrements de la zone
Get-DnsServerResourceRecord -ZoneName "ad.gilles.eni" | Format-Table -AutoSize

# Activation de la mise à jour dynamique (Secure)
Set-DnsServerPrimaryZone -Name "ad.gilles.eni" -DynamicUpdate Secure

# CONFIGURATION DU SERVEUR SECONDAIRE

# Ajout du serveur secondaire s3-gl.gilles.eni
Add-DnsServerResourceRecordNS -Name "ad.gilles.eni" -NameServer "s3-gl.gilles.eni" -ZoneName "ad.gilles.eni"
Add-DnsServerResourceRecordA -Name "s3-gl" -IPv4Address 172.20.8.3 -ZoneName "ad.gilles.eni"

# Ou autre serveur secondaire : s4-w-sm
Add-DnsServerResourceRecordNS -Name "ad.gilles.eni" -NameServer "s4-w-sm" -ZoneName "ad.gilles.eni"
Add-DnsServerResourceRecordA -Name "s4-w-sm" -IPv4Address 172.20.8.4 -ZoneName "ad.gilles.eni"

# ZONE INVERSE

# Création d'une zone inverse pour 172.20.0.0/16
Add-DnsServerPrimaryZone -NetworkId "172.20.0.0/16" -ZoneFile "20.172.dns" -DynamicUpdate NonsecureAndSecure
# OU :
# Add-DnsServerPrimaryZone -Name "20.172.in-addr.arpa" -ZoneFile "20.172.dns" -DynamicUpdate NonsecureAndSecure

# Ajout d’enregistrements PTR (reverse DNS)
Add-DnsServerResourceRecordPtr -Name "1.0" -ZoneName "20.172.in-addr.arpa" -AllowUpdateAny -PtrDomainName "s1-gl.gilles.eni"
Add-DnsServerResourceRecordPtr -Name "2.0" -ZoneName "20.172.in-addr.arpa" -AllowUpdateAny -PtrDomainName "s2-w-cd.gilles.eni"
Add-DnsServerResourceRecordPtr -Name "3.8" -ZoneName "20.172.in-addr.arpa" -AllowUpdateAny -PtrDomainName "s3-gl.gilles.eni"
Add-DnsServerResourceRecordPtr -Name "4.8" -ZoneName "20.172.in-addr.arpa" -AllowUpdateAny -PtrDomainName "s4-w-sm.gilles.eni"
Add-DnsServerResourceRecordPtr -Name "254.7" -ZoneName "20.172.in-addr.arpa" -AllowUpdateAny -PtrDomainName "routeur.gilles.eni"
Add-DnsServerResourceRecordPtr -Name "254.15" -ZoneName "20.172.in-addr.arpa" -AllowUpdateAny -PtrDomainName "routeur.gilles.eni"

# Lister les enregistrements de la zone inverse
Get-DnsServerResourceRecord -ZoneName "20.172.in-addr.arpa" | Format-Table -AutoSize
```

### ✅ Corrections effectuées :

1. **Cmdlets mal orthographiées :**
    - `Set-DnsClientServerAddresse` → `Set-DnsClientServerAddress`
    - `Add-DnsServerRessourceRecord` → `Add-DnsServerResourceRecord`
    - `Add-DnsServerRessourceRecordPtr` → `Add-DnsServerResourceRecordPtr`
    - `Get-DnsServerRessourceRecord` → `Get-DnsServerResourceRecord`
    - `Add-DnsServerfirstZone` → remplacé par `Add-DnsServerPrimaryZone`
    - `Set-DnsServerconditionalForwarder` → `Set-DnsServerForwarder`
    - `Set-DnsServer` → corrigé en `Set-DnsServerPrimaryZone` avec paramètre valide `-DynamicUpdate`
2. **Paramètres incorrects ou absents :**
    - `-IncludedManagementTools` corrigé en `-IncludeManagementTools`
    - Ajout de `-ZoneName` manquant dans plusieurs commandes `Add-DnsServerResourceRecordA`
    - Utilisation correcte de `-ZoneFile`, `-ZoneName`, `-NameServer`, `-HostNameAlias`
3. **Syntaxe PowerShell corrigée :**
    - Remplacement de guillemets typographiques `“ ”` par des guillemets standards `"` dans les chemins de registre
    - Ajout d’un `Restart-Computer` après modification du registre
4. **Correction du nom de la zone :**
    - Utilisation systématique de `"ad.gilles.eni"` pour assurer la cohérence
    - Cohérence dans l’usage de zones inverses : `"20.172.in-addr.arpa"`
5. **Correction des IP et noms d’hôtes :**
    - Les enregistrements PTR sont associés à des adresses cohérentes (e.g. `3.8` ↔ `s3-gl.gilles.eni`)
6. **Ajout de commentaires explicatifs :**
    - Chaque bloc est précédé d’un titre en commentaire 
    - Explication de chaque action DNS : zone, record, redirection, glue, etc.
7. **Uniformisation des noms et styles :**
    - Ajout de `Format-Table -AutoSize` pour l’affichage clair des listes
    - Respect des bonnes pratiques de nommage et indentation

---

## 🧾 Activité 3 – Rédaction d’un script complet

### Objectif : écrire un script structuré selon 1 des 2 sujets suivants :

#### Option 1 – Script de configuration réseau

```powershell
# Module 06 – PowerShell : Pour aller plus loin
# Activité 3 – Écriture de scripts

# Script 1 – Configuration réseau locale

Function Configurer-IPStatique {
    Param(
        [string]$InterfaceAlias = "Ethernet",
        [string]$AdresseIP = "192.168.1.100",
        [string]$Masque = "24",
        [string]$Passerelle = "192.168.1.1",
        [string[]]$DNS = @("8.8.8.8", "1.1.1.1")
    )

    Try {
        New-NetIPAddress -InterfaceAlias $InterfaceAlias -IPAddress $AdresseIP -PrefixLength $Masque -DefaultGateway $Passerelle -ErrorAction Stop
        Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ServerAddresses $DNS -ErrorAction Stop
        Write-Host "Configuration IP statique appliquée."
    } Catch {
        Write-Warning "Erreur lors de la configuration IP : $($_.Exception.Message)"
    }
}

Function Configurer-DHCP {
    Param(
        [string]$InterfaceAlias = "Ethernet"
    )

    Try {
        Set-NetIPInterface -InterfaceAlias $InterfaceAlias -Dhcp Enabled -ErrorAction Stop
        Set-DnsClientServerAddress -InterfaceAlias $InterfaceAlias -ResetServerAddresses
        Write-Host "DHCP activé sur l’interface $InterfaceAlias."
    } Catch {
        Write-Warning "Erreur DHCP : $($_.Exception.Message)"
    }
}

# Exécution (exemple à commenter ou adapter)
# Configurer-IPStatique -InterfaceAlias "Ethernet" -AdresseIP "192.168.1.50" -Masque 24 -Passerelle "192.168.1.1"
# Configurer-DHCP -InterfaceAlias "Ethernet"

```

#### Option 2 – Menu de gestion Active Directory

```powershell
# Module 06 – PowerShell : Pour aller plus loin
# Activité 3 – Écriture de scripts

# Script 2 – Menu de gestion des utilisateurs AD

Function Creer-Utilisateur {
    $nom = Read-Host "Nom"
    $prenom = Read-Host "Prénom"
    $login = Read-Host "Identifiant"
    $mdp = Read-Host "Mot de passe" -AsSecureString
    $ou = Read-Host "OU cible (ex : OU=Utilisateurs,DC=domaine,DC=local)"

    Try {
        New-ADUser -Name "$prenom $nom" -GivenName $prenom -Surname $nom -SamAccountName $login -UserPrincipalName "$login@domaine.local" -AccountPassword $mdp -Enabled $true -Path $ou
        Write-Host "Utilisateur $prenom $nom créé."
    } Catch {
        Write-Warning "Erreur de création : $($_.Exception.Message)"
    }
}

Function Supprimer-Utilisateur {
    $login = Read-Host "Identifiant à supprimer"
    Try {
        Remove-ADUser -Identity $login -Confirm:$false
        Write-Host "Utilisateur $login supprimé."
    } Catch {
        Write-Warning "Erreur suppression : $($_.Exception.Message)"
    }
}

Function Ajouter-A-Groupe {
    $login = Read-Host "Utilisateur à ajouter"
    $groupe = Read-Host "Nom du groupe"
    Try {
        Add-ADGroupMember -Identity $groupe -Members $login
        Write-Host "$login ajouté au groupe $groupe."
    } Catch {
        Write-Warning "Erreur ajout groupe : $($_.Exception.Message)"
    }
}

Function Export-UtilisateursCSV {
    $chemin = Read-Host "Chemin du fichier CSV (ex: C:\\export.csv)"
    Try {
        Get-ADUser -Filter * -Properties * | Select Name,SamAccountName,Enabled,Department | Export-Csv -Path $chemin -NoTypeInformation -Encoding UTF8
        Write-Host "Export terminé."
    } Catch {
        Write-Warning "Erreur export : $($_.Exception.Message)"
    }
}

# Menu principal
Do {
    Clear-Host
    Write-Host "=== Menu de gestion AD ==="
    Write-Host "1. Créer un utilisateur"
    Write-Host "2. Supprimer un utilisateur"
    Write-Host "3. Ajouter à un groupe"
    Write-Host "4. Exporter les utilisateurs"
    Write-Host "5. Quitter"
    $choix = Read-Host "Votre choix"

    Switch ($choix) {
        "1" { Creer-Utilisateur }
        "2" { Supprimer-Utilisateur }
        "3" { Ajouter-A-Groupe }
        "4" { Export-UtilisateursCSV }
        "5" { Write-Host "Fermeture..." }
        Default { Write-Warning "Choix invalide."; Pause }
    }
} While ($choix -ne "5")

```


---

## ✅ À retenir pour les révisions

- Un bon script PowerShell est **structuré, commenté et modulaire** (fonctions, paramètres, logique claire).
- `Get-Credential` permet de capturer un identifiant de façon sécurisée, sans stocker le mot de passe en clair.
- `Try/Catch` permet de gérer les erreurs sans interrompre l’exécution du script.
- Le remoting (`Invoke-Command`, `New-PSSession`) permet de piloter plusieurs machines à distance.
- `New-ADUser`, `Set-ADUser`, `Add-ADGroupMember`, `Remove-ADUser` sont les piliers de l’automatisation AD.
- Les scripts peuvent interagir avec la configuration réseau via `New-NetIPAddress`, `Set-DnsClientServerAddress`, `Set-NetIPInterface`.
- Le menu interactif avec `Switch` permet de centraliser plusieurs actions dans un seul script.

---

## 📌 Bonnes pratiques professionnelles

- Toujours **commenter** chaque bloc d’un script pour faciliter la lecture et la maintenance.
- Ne jamais coder de mot de passe en clair : utiliser `Get-Credential` ou `ConvertTo-SecureString`.
- Tester les scripts sur un environnement de **pré-production** avant toute mise en œuvre en production.
- Regrouper les actions répétées dans des **fonctions réutilisables**.
- Capturer et rediriger les erreurs avec `-ErrorAction` et `-ErrorVariable`.
- **Personnaliser les scripts** : nom des OU, groupes, domaines, selon le contexte de l’infrastructure cible.
- S’assurer que les droits d’exécution (`ExecutionPolicy`) sont correctement définis.
- Archiver les exports (`Export-Csv`) avec nom explicite, date et encodage `UTF8`.

---

## 🔗 Commandes utiles

```powershell
# Authentification et sécurité
$cred = Get-Credential
Invoke-Command -ComputerName SRV -Credential $cred -ScriptBlock { ... }

# Gestion Active Directory
New-ADUser, Set-ADUser, Remove-ADUser, Enable-ADAccount
Add-ADGroupMember, Get-ADUser, Get-ADGroupMember, New-ADOrganizationalUnit

# Réseau
New-NetIPAddress, Set-DnsClientServerAddress, Set-NetIPInterface

# Erreurs et tests
Try { ... } Catch { ... }
$ErrorActionPreference = "Stop"

# Menu et interaction
Switch ($choix) { ... }
Read-Host, Write-Host

# Exportation
Export-Csv -Path .\utilisateurs.csv -Encoding UTF8 -NoTypeInformation