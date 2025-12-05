# 🖥️ SRV-RDS — Remote Desktop Services (session host + web access, TLS via PKI)

> Hôte : **SRV-RDS** — IP : **192.168.55.25/25** — Passerelle : **192.168.55.1** — DNS : **192.168.55.20 / 192.168.55.21**  
> Domaine : **stage.eni** — FQDN : **srv-rds.stage.eni**  
> Rôles visés (déploiement simple **monoserveur**) : **RD Connection Broker**, **RD Web Access**, **RD Session Host**, **RD Licensing**  
> Publication externe : **aucune** (usage **interne** depuis LAN Clients uniquement)

## 0) Pré‑requis

- **PKI interne (AD CS)** opérationnelle (chaîne de confiance déployée dans le domaine).
- **DNS** : enregistrement `srv-rds.stage.eni` dans la zone `stage.eni`.
- **GPO** : prévoir une OU dédiée au serveur `SRV-RDS` (ex. `OU=_SERVEURS`), où l’on pourra lier les GPO RDS.
- **OPNsense** : règle **LAN Clients → SRV-RDS** TCP **3389** (et **443** si RD Web utilisé), **pas de WAN**.

---

## 1) Installation des rôles RDS
### GUI (Server Manager)

`Gérer → Ajouter des rôles et fonctionnalités → Installation basée sur un rôle…`  
Sélectionner **Remote Desktop Services** puis **Scenario-Based Installation** → **Quick Start** → **Session-based desktop deployment** → ajouter **SRV-RDS** pour **Connection Broker**, **Web Access**, **Session Host** → Installer (redémarrages possibles).

### PowerShell (équivalent)

```powershell
# Rôles RDS + outils d’admin
Install-WindowsFeature RDS-Connection-Broker, RDS-Web-Access, RDS-RD-Server, RDS-Licensing -IncludeManagementTools

# Déploiement RDS monoserveur
Import-Module RemoteDesktop
New-RDSessionDeployment -ConnectionBroker "srv-rds.stage.eni" -WebAccessServer "srv-rds.stage.eni" -SessionHost "srv-rds.stage.eni"

# Déclarer le serveur de licences (même hôte) en mode Par Utilisateur
Add-RDServer -Server "srv-rds.stage.eni" -Role RDS-LICENSING -ConnectionBroker "srv-rds.stage.eni"
Set-RDLicenseConfiguration -ConnectionBroker "srv-rds.stage.eni" -Mode PerUser -LicenseServer "srv-rds.stage.eni"
```
> **Licences** : un **délai de grâce (~120 jours)** existe en labo. Documenter le **mode** (Per User) et l’hôte **Licence**.

---

## 2) Collection RDS & droits d’accès

Créer une **collection de sessions** pour publier soit le **bureau complet**, soit des **RemoteApps**.

```powershell
# Créer la collection
New-RDSessionCollection -CollectionName "COL-Apps" -CollectionDescription "Applications métier" `
  -SessionHost "srv-rds.stage.eni" -ConnectionBroker "srv-rds.stage.eni"

# Autoriser un groupe d’utilisateurs du domaine (AGDLP recommandé)
# Exemple : créer un GG dédié aux utilisateurs RDS
Import-Module ActiveDirectory
New-ADGroup -Name "GG_Users_RDS" -GroupScope Global -Path "OU=_GROUPES,DC=stage,DC=eni"
Set-RDSessionCollectionConfiguration -CollectionName "COL-Apps" -UserGroup "STAGE\\GG_Users_RDS" -ConnectionBroker "srv-rds.stage.eni"
```

**Option RemoteApps (exemples)**

```powershell
# Publier quelques applis (adapter selon logiciels présents)
Publish-RDRemoteApp -CollectionName "COL-Apps" -DisplayName "Bloc-notes" -FilePath "C:\\Windows\\System32\\notepad.exe" -ConnectionBroker "srv-rds.stage.eni"
Publish-RDRemoteApp -CollectionName "COL-Apps" -DisplayName "Paint" -FilePath "C:\\Windows\\System32\\mspaint.exe" -ConnectionBroker "srv-rds.stage.eni"
```

> **Accès** :
> - **Bureau complet** : `mstsc /v:srv-rds.stage.eni`
> - **RD Web** : `https://srv-rds.stage.eni/RDWeb` (si utilisé)

---

## 3) Certificats RDS (PKI)

Créer/obtenir un certificat **Web Server** pour `srv-rds.stage.eni` (auto‑inscription machine ou demande manuelle). Puis l’affecter aux rôles RDS.

```powershell
# Récupérer l’empreinte du certificat serveur issu de la PKI
$cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -like "*CN=srv-rds.stage.eni*" } | Select-Object -First 1
$thumb = $cert.Thumbprint

# Affecter le même certificat aux différents rôles RDS
# Publishing, Web Access, Redirector (Gateway non utilisé ici)
Set-RDCertificate -Role RDPublishing  -Thumbprint $thumb -ConnectionBroker "srv-rds.stage.eni" -Force
Set-RDCertificate -Role RDWebAccess   -Thumbprint $thumb -ConnectionBroker "srv-rds.stage.eni" -Force
Set-RDCertificate -Role RDRedirector  -Thumbprint $thumb -ConnectionBroker "srv-rds.stage.eni" -Force
```

> **But** : éviter les alertes de certificat sur RD Web et les connexions RDP (TLS).  
> **Remarque** : si un **nom de ferme** est introduit plus tard, un certificat incluant ce **FQDN** sera requis (SAN).

---

## 4) Paramètres RDS essentiels (sécurité & expérience)

### GPO **Serveur RDS** (lien : OU du serveur `SRV-RDS`)

`Computer Configuration → Policies → Administrative Templates → Windows Components → Remote Desktop Services → Remote Desktop Session Host`
- **Security** :
  - *Require user authentication for remote connections by using NLA* → **Enabled**
  - *Set client connection encryption level* → **High**
  - *Require use of specific security layer for RDP connections* → **SSL (TLS)**
- **Connections** :
  - *Allow users to connect remotely* → **Enabled** (ou via propriété système)
  - *Limit number of connections* → adapter (ex. 20)
- **Sessions** :
  - *Set time limit for active but idle Remote Desktop Services sessions* → **1h**
  - *Set time limit for disconnected sessions* → **30 min**
  - *End session when time limits are reached* → **Enabled**
- **Device and Resource Redirection** :
  - *Do not allow drive redirection* → **Enabled** (ou autoriser selon besoin)
  - *Clipboard redirection* → **Enabled** (confort) ou **Disabled** (sécurité)

### GPO **Utilisateurs RDS** (boucle de rappel)

- Activer **User Group Policy loopback processing mode** = **Merge** (sur l’OU du serveur RDS).  
- Configurer les paramètres **User Configuration** (menu démarrer, restrictions, profils itinérants si utilisés, imprimantes, etc.) pour les sessions RDS.

---

## 5) Pare‑feu & OPNsense

- **OPNsense** : autoriser **LAN Clients → SRV-RDS (55.25)** TCP **3389** (Bureau à distance) et **443** si RD Web.  
- **Windows Firewall (SRV-RDS)** : activer les règles prédéfinies **Remote Desktop (TCP‑In)**.  
- **Aucun** flux depuis **WAN**.

---

## 6) Tests & validation

Depuis un **poste client** membre du domaine :

```powershell
# Connectivité
Test-NetConnection srv-rds.stage.eni -Port 3389

# Bureau complet
mstsc /v:srv-rds.stage.eni

# RD Web (facultatif)
Start-Process https://srv-rds.stage.eni/RDWeb
```

Vérifier :
- Authentification via **NLA** (pas de prompt classique si SSO/SSPI).  
- Avertissements **certificat** absents.  
- Application des **GPO** (idle timeout, redirections, etc.).  
- **RemoteApps** présents si publiés.

---

## 7) Supervision & exploitation

- **Services** à surveiller : `TermService`, `SessionEnv`, `Tssdis`, `Rdms`.  
- **Perf** : sessions actives, CPU/RAM, latence RDP.  
- **Zabbix** : ajouter `SRV-RDS` au groupe Windows Servers, surveiller port **3389**, **Cert expiration** (script/LLD optionnel).  
- **Journaux** : `Microsoft-Windows-TerminalServices-*` dans **Event Viewer**.

---

## ✅ Checklist

- [ ] Déploiement **monoserveur** (Broker/Web/Host/Licensing) installé.  
- [ ] Collection **COL-Apps** créée ; groupe **STAGE\\GG_Users_RDS** autorisé.  
- [ ] Certificat PKI appliqué aux rôles **Publishing/Web/Redirector**.  
- [ ] GPO serveur (NLA, TLS, sessions) appliquées ; **loopback** pour paramètres utilisateur.  
- [ ] OPNsense : **LAN Clients → 3389/443** autorisé vers SRV-RDS ; **WAN** bloqué.  
- [ ] Tests **mstsc** / **RD Web** OK, sans alertes de certificat.  
- [ ] Supervision services RDS & journaux en place.  
- [ ] Licensing mode **Per User** défini (grace period si labo).

---

## 🧠 Justifications & bonnes pratiques

- **Monoserveur** : suffisant en maquette ; simplifie la PKI & les bindings.  
- **TLS via PKI** : confiance interne et SSO Kerberos sans avertissements.  
- **Loopback (Merge)** : applique une expérience utilisateur **spécifique aux sessions RDS**.  
- **Principe du moindre privilège** : restreindre l’accès RDS aux seuls membres de `GG_Users_RDS`.  
- **Aucune exposition WAN** : réduit drastiquement la surface d’attaque.
