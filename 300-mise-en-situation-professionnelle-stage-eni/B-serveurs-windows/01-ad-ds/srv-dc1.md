# 🏰 SRV-DC1 — Installation & configuration d’Active Directory (AD DS) + DNS

> Hôte : **SRV-DC1** — IP : **192.168.55.20/25** — Passerelle : **192.168.55.1** — DNS : **192.168.55.20 (primaire)** / **192.168.55.21 (secondaire après DC2)** — Domaine : **stage.eni** — Forêt : **STAGE.ENI**

## 0) Pré-requis système

1. **Nom d’hôte** : `SRV-DC1`  
   - *Justif.* : convention homogène « SRV-<Rôle> ».
2. **Adresse IP fixe** :
   - IPv4 : `192.168.55.20/25`  
   - Passerelle : `192.168.55.1` (OPNsense)  
   - DNS : `192.168.55.20` (lui-même)  
   - *Justif.* : le DC pointe sur **lui‑même** pour la résolution AD.
3. **Heure (NTP)** : synchronisé sur l’OPNsense ou source fiable interne (temporaire).  
   - *Justif.* : Kerberos exige un faible décalage (<5 min).
4. **MAJ système** : Windows Update appliquées.

> **Vérif rapide (PowerShell)**  
> `Get-NetIPConfiguration` 
> `Resolve-DnsName SRV-DC1` → doit renvoyer 192.168.55.20

---

## 1) Installation des rôles AD DS & DNS

### Méthode GUI (Gestionnaire de serveur)

`Gérer → Ajouter des rôles et fonctionnalités` :
- Rôles : **Services AD DS** et **DNS Server**.
- **Redémarrage automatique** autorisé.

### Méthode PowerShell (recommandée)

```powershell
# Installe AD DS + DNS
Install-WindowsFeature AD-Domain-Services, DNS -IncludeManagementTools
```
- `Install-WindowsFeature` : installe des rôles/ fonctionnalités.  
- `-IncludeManagementTools` : ajoute RSAT AD/DNS.

---

## 2) Promotion en contrôleur de domaine (création de forêt)

### GUI

Dans le **Gestionnaire de serveur** (notification jaune) → `Promouvoir ce serveur en contrôleur de domaine` :
- **Ajouter une nouvelle forêt** : `stage.eni`  
- **Niveau fonctionnel** : **Windows Server 2025** (ou le plus élevé proposé)  
- **Options** : DNS intégré, **mot de passe DSRM** fort  
- **NetBIOS** : `STAGE`  
- Valider les prérequis → Installer → redémarrage.

### PowerShell

```powershell
# Crée la forêt STAGE.ENI, DNS intégré
Install-ADDSForest -DomainName "stage.eni" -DomainNetbiosName "STAGE" -CreateDnsDelegation:$false \
  -ForestMode WinThreshold -DomainMode WinThreshold -InstallDns:$true -DatabasePath "C:\\Windows\\NTDS" \
  -LogPath "C:\\Windows\\NTDS" -SysvolPath "C:\\Windows\\SYSVOL" -SafeModeAdministratorPassword (Read-Host -AsSecureString)
```
**Paramètres clés :**
- `-ForestMode / -DomainMode` : niveaux fonctionnels **Windows Server 2025** (valeur `WinThreshold` sur builds récentes).  
- `-InstallDns:$true` : installe DNS AD‑intégré.  
- `-SafeModeAdministratorPassword` : mot de passe DSRM.

> **Après reboot** : ouverture de session sur `STAGE\\Administrator`.

---

## 3) DNS — Zones et redirecteurs
### 3.1 Zones AD intégrées

1. **Zone de recherche directe** : `stage.eni` (créée automatiquement).  
2. **Zone de recherche inversée (PTR)** :
   - `55.168.192.in-addr.arpa` (pour 192.168.55.0/25)  
   - `52-53.168.192.in-addr.arpa` si nécessaire côté /23 clients (optionnel côté DC1).

**PowerShell (ex.)**

```powershell
Add-DnsServerPrimaryZone -NetworkId 192.168.55.0/25 -ReplicationScope Forest
# Exemple /23 (clients) si hébergé aussi côté DCs
# Add-DnsServerPrimaryZone -NetworkId 192.168.52.0/23 -ReplicationScope Forest
```
- `-NetworkId` : crée la zone inverse du sous-réseau.  
- `-ReplicationScope Forest` : multi-DCs automatiquement.

### 3.2 Redirecteurs conditionnels

- **Vers DNS cache en DMZ** : `SRV-DNS (192.168.56.250)` pour la **résolution externe**.

```powershell
Add-DnsServerForwarder -IPAddress 192.168.56.250 -PassThru
```
> *Justif.* : les **DCs AD** résolvent en interne et délèguent l’externe au **DNS cache** de la DMZ.

### 3.3 Enregistrements essentiels

- `A` : `srv-dc1.stage.eni → 192.168.55.20` (normalement créé).  
- `NS` : contrôlé automatiquement.  
- Vérifier `SRV` (_ldap._tcp, _kerberos._tcp) créés par AD.

**Vérifs**

```powershell
Resolve-DnsName srv-dc1.stage.eni
Resolve-DnsName -Type PTR 192.168.55.20
Resolve-DnsName -Type SRV _ldap._tcp.dc._msdcs.stage.eni
```

---

## 4) NTP / Temps — Source de référence

Par défaut, le **PDC Emulator** est source de temps interne. Comme DC1 sera PDC (au début) :

```powershell
# Exemple : synchroniser sur l’OPNsense (remplacer par IP/NTP de référence)
w32tm /config /manualpeerlist:"192.168.55.1" /syncfromflags:manual /reliable:yes /update
w32tm /resync
w32tm /query /status
```
- `manualpeerlist` : pairs NTP.  
- `reliable:yes` : source fiable pour le domaine.

> *Justif.* : une horloge cohérente = **Kerberos OK**.

---

## 5) OU de base & comptes de service (AGDLP ready)

Créer l’ossature minimale (évolutive) :
- `OU=_SERVEURS`, `OU=_POSTESCLIENTS`, `OU=_UTILISATEURS`, `OU=_GROUPES`  
- *(option)* : sous-OUs par service (EX : `_GROUPES\\DL_Acces_*`, `_GROUPES\\GG_*`).

**PowerShell (ex.)**

```powershell
Import-Module ActiveDirectory
New-ADOrganizationalUnit -Name "_SERVEURS" -Path "DC=stage,DC=eni"
New-ADOrganizationalUnit -Name "_POSTESCLIENTS" -Path "DC=stage,DC=eni"
New-ADOrganizationalUnit -Name "_UTILISATEURS" -Path "DC=stage,DC=eni"
New-ADOrganizationalUnit -Name "_GROUPES" -Path "DC=stage,DC=eni"
```
> *Justif.* : préparer **AGDLP** (comptes → groupes globaux → groupes locaux de domaine → permissions).

---

## 6) Durcissement initial (GPO Domaine)

1. **Mot de passe** : longueur ≥ 12, complexité activée.  
2. **Verrouillage de compte** : seuil 10, reset 15 min.  
3. **Pare-feu Windows** : profil Domaine activé.  
4. **Désactiver SMBv1** (héritage) : via GPO Préférences ou Feature.

**Rappels commandes utiles**

```powershell
# Désactiver SMBv1 (serveur)
Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart
# Vérifier profils pare-feu
Get-NetFirewallProfile
```

---

## 7) Vérifications santé AD

Après promotion et 1er démarrage :

```powershell
# État du DC
Get-ADDomainController -Filter * | ft HostName,Site,IsGlobalCatalog
# Diagnostic AD
dcdiag /v
# Réplication (quand DC2 sera en place)
repadmin /replsummary
repadmin /showrepl
```
**Résultats attendus :** pas d’erreurs critiques, **GC = True**, services `NTDS`, `DNS`, `NetLogon` en **Running**.

---

## 8) Sauvegardes & restauration d’autorité (DSRM)

- Conserver le **mot de passe DSRM** (coffre).  
- Préparer une **sauvegarde système** (état du système) :

```powershell
wbadmin start systemstatebackup -backuptarget:E: -quiet
```
> *Justif.* : l’état du système contient **AD DS + SYSVOL + Registre**.

---

## 9) Spécificités projet

- **Redirecteur DNS** → `SRV-DNS (192.168.56.250)` selon la matrice de flux.  
- **Intégration DC2** : DNS secondaire `192.168.55.21` sera ajouté sur clients/serveurs après création de **SRV-DC2**.

---

## ✅ Checklist

- [ ] Nom d’hôte = SRV-DC1 & IP fixe 192.168.55.20/25.  
- [ ] Rôles AD DS + DNS installés.  
- [ ] Forêt `stage.eni` créée (niveau 2025).  
- [ ] Zones DNS directe + inverse OK, enregistrements SRV présents.  
- [ ] Redirecteur → 192.168.56.250 opérationnel.  
- [ ] NTP configuré (source fiable).  
- [ ] OUs de base créées (AGDLP ready).  
- [ ] GPO de durcissement appliquées.  
- [ ] `dcdiag` sans erreurs.

---

## 📝 Notes & bonnes pratiques

- **DNS du DC** : le DC se pointe **sur lui-même** (pas de DNS externe sur une NIC de DC).  
- **Reverse PTR** : indispensable pour diagnostics & certains services.  
- **NTP & Kerberos** : surveiller l’écart de temps (`w32tm /query /status`).  
- **Sauvegarde état système** : à planifier après chaque changement majeur (ex. ajout DC2).  
- **Documentation** : capturer écrans de l’assistant AD, `dcdiag`, zones DNS et joindre aux **Annexes**.
