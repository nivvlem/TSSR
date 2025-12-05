# 🔄 SRV-WSUS — Windows Server Update Services (HTTPS 8531 via PKI)

> Hôte : **SRV-WSUS** — IP : **192.168.55.24/25** — Passerelle : **192.168.55.1** — DNS : **192.168.55.20 / 192.168.55.21**  
> Domaine : **stage.eni** — FQDN : **srv-wsus.stage.eni**  
> Stockage contenu : **E:\WSUS** (recommandé)  
> Base : **WID** (Windows Internal Database)  
> Ports : **8530 (HTTP)** / **8531 (HTTPS)** — on **force HTTPS 8531** (PKI ADCS déjà en place)

## 0) Pré‑requis

- **PKI d’entreprise** opérationnelle (AD CS) — les membres du domaine **font confiance** aux certificats émis.  
- **Espace disque** sur `E:\` (> 50–100 Go selon produits/langues).  
- **Flux sortants** SRV-WSUS → Internet : TCP **80/443** (téléchargement auprès de Microsoft).  
- **Flux internes** (cf. matrice) : Clients → SRV-WSUS TCP **8531** autorisé.

---

## 1) Installation du rôle WSUS (PowerShell)

Sur **SRV-WSUS** (Windows Server 2025) :

```powershell
# 1) Rôle WSUS + Outils d’admin
Install-WindowsFeature UpdateServices, UpdateServices-WidDB, UpdateServices-Services -IncludeManagementTools

# 2) Post-install : dossier de contenu sur E:\
& "C:\\Program Files\\Update Services\\Tools\\WsusUtil.exe" postinstall CONTENT_DIR=E:\\WSUS
```

Vérifs :

```powershell
Get-Service W3SVC, WSUSService | ft Name,Status
Test-Path E:\\WSUS
```

---

## 2) DNS & Certificat serveur (HTTPS)
### 2.1 Enregistrement DNS

Sur un DC :

```powershell
Add-DnsServerResourceRecordA -ZoneName "stage.eni" -Name "srv-wsus" -IPv4Address 192.168.55.24
# (Optionnel) Alias convivial
Add-DnsServerResourceRecordCName -ZoneName "stage.eni" -Name "wsus" -HostNameAlias "srv-wsus.stage.eni"
```

### 2.2 Certificat « Web Server » (PKI ADCS)

- **Auto-enrollement** via GPO (idéal) OU **demande manuelle** dans `certlm.msc` (Local Computer) → modèle **Web Server** → **CN = srv-wsus.stage.eni** (SAN DNS idem).
- Vérifier présence du cert dans **Ordinateur local → Personnel**.

---

## 3) IIS — Binding HTTPS 8531 + WSUS en SSL
### 3.1 Créer le binding 8531 (SNI)

IIS Manager → **Sites → WSUS Administration → Bindings… → Add** :
- **Type** = https, **Port** = 8531, **Host name** = `srv-wsus.stage.eni`, **SNI** = ✓, **Certificat** = `CN=srv-wsus.stage.eni`.

### 3.2 Dire à WSUS d’utiliser SSL

```powershell
& "C:\\Program Files\\Update Services\\Tools\\WsusUtil.exe" configuressl srv-wsus.stage.eni
```
- Ouvrir la **console WSUS** → **Options → Update Source and Proxy Server** : l’URL doit apparaître en **https://srv-wsus.stage.eni:8531**.  
- Dans **WSUS Administration (IIS) → SSL Settings** : laisser **Require SSL** uniquement là où Microsoft le recommande (par défaut le site WSUS gère cela ; ne force pas le SSL sur les répertoires de contenu `Content`).

---

## 4) Assistant WSUS — Paramétrage initial

**Options → Update Source and Proxy Server**  
- Source : **Synchronize from Microsoft Update** (proxy : non à domicile ; *oui* si besoin en école ENI).  

**Options → Products and Classifications**  
- **Products** :
  - **Windows 11**
  - **Windows Server 2025** (et **Windows Server LTSC** si libellé diffère)
  - **Microsoft Defender Antivirus**
  - **.NET** (si utilisé)
- **Classifications** :
  - **Critical Updates**, **Security Updates**, **Updates**, **Definition Updates** (Defender)
  - (Refuser Drivers / Feature on Demand au départ pour limiter le volume)

**Options → Languages** : `fr-FR` (+ `en-US` au besoin).  
**Options → Synchronization Schedule** : **Daily** à **02:00** (ou **Manual** pendant la mise en place).  
**Launch Synchronization** (premier sync peut être long).

---

## 5) Groupes ordinateurs & règles d’approbation
### 5.1 Groupes ordinateurs (WSUS)

```powershell
Import-Module UpdateServices
$wsus = Get-WsusServer -Name "srv-wsus" -PortNumber 8531 -UseSsl
$wsus.CreateComputerTargetGroup("Workstations") | Out-Null
$wsus.CreateComputerTargetGroup("Servers")      | Out-Null
$wsus.CreateComputerTargetGroup("Pilot")        | Out-Null
```

### 5.2 Approbations automatiques (optionnelles)

Console WSUS → **Options → Automatic Approvals** :
- **Rule 1** : *Definition Updates* → **Approve for Install** pour `Workstations` & `Servers`.
- **Rule 2** : *Critical & Security Updates* → **Approve** pour `Pilot` (validation), puis approbation manuelle vers `Workstations`/`Servers`.

> **Bonne pratique** : déployer d’abord sur **Pilot** (1–2 VM) avant généralisation.

---

## 6) GPO clients — Ciblage & planification

Créer **deux GPO** (postes & serveurs) pour plus de clarté.

### 6.1 `GPO_WSUS_Workstations` *(lien : OU **_POSTESCLIENTS**)*

`Computer Configuration → Policies → Administrative Templates → Windows Components → Windows Update` :
- **Specify intranet Microsoft update service location** → **Enabled**  
  - Set the intranet update service for detecting updates: `https://srv-wsus.stage.eni:8531`  
  - Set the intranet statistics server: `https://srv-wsus.stage.eni:8531`
- **Configure Automatic Updates** → **Enabled**  
  - Option `4 - Auto download and schedule the install`  
  - **Every day @ 03:00**
- **Automatic Updates detection frequency** → **6 hours**
- **No auto-restart with logged on users** → **Enabled**
- **Do not connect to any Windows Update Internet locations** → **Enabled**
- **Enable client-side targeting** → **Enabled** → **Target group name** = `Workstations`

### 6.2 `GPO_WSUS_Servers` *(lien : OU **_SERVEURS**)*

- Même paramètres, mais :  
  - **Configure Automatic Updates** = `3 - Auto download and notify for install` (installation manuelle/maintenance)  
  - **Target group name** = `Servers`

**Vérifs côté client**

```powershell
# Forcer application GPO
gpupdate /force
# Vérifier registre WSUS
Get-ItemProperty 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' | select WUServer,WUStatusServer,TargetGroup
# Déclencher un scan (Win10/11)
UsoClient StartScan
UsoClient StartDownload
UsoClient StartInstall
```

---

## 7) Pare‑feu & OPNsense

- **OPNsense** : autoriser **LAN Clients → SRV-WSUS (55.24)** TCP **8531** (et/ou 8530 si HTTP).  
- **SRV-WSUS** (Pare-feu Windows) : ouvrir **TCP 8530/8531** en entrant si nécessaire.  
- **Sortant** vers Microsoft Update : **TCP 80/443** (déjà OK via NAT sortant).

---

## 8) Premier cycle de mises à jour

1. **Synchroniser** WSUS manuellement (jusqu’à fin de catalogue).  
2. **Rechercher** mises à jour côté client (UsoClient StartScan).  
3. **Voir apparaître** les clients dans **WSUS → Computers** (première remontée).  
4. **Déplacer** (si nécessaire) les clients dans les groupes ou utiliser **client-side targeting** (GPO).  
5. **Approuver** des mises à jour pour `Pilot` → tester → approuver pour `Workstations`/`Servers`.

---

## 9) Maintenance & nettoyage (indispensable)

- **Server Cleanup Wizard** (Options) :
  - Unused updates and update revisions
  - Computers not contacting WSUS
  - Superseded updates
  - Unneeded update files
- **Compression BDD / Reindex** (mensuel) :

```powershell
Invoke-WsusServerCleanup -CleanupObsoleteComputers -CleanupObsoleteUpdates -CompressUpdates -DeclineExpiredUpdates -DeclineSupersededUpdates
# (Si indisponible, utiliser les méthodes .NET via $wsus.GetCleanupManager())
```
- **Optimisations** : limiter **Products/Languages**, décliner les **Drivers** si non utilisés.

---

## 🔎 Dépannage rapide

- **Certificat** : cadenas absent → vérifier binding IIS 8531 + chaîne de confiance (cert racine AD CS installé sur clients).  
- **Client n’apparaît pas** : GPO bien appliquée ? Registre `WUServer`/`WUStatusServer` ok ?  
- **Scan KO** : `Get-WindowsUpdateLog` (Win10/11), service **wuauserv** en Running, proxy WinHTTP (`netsh winhttp show proxy`).  
- **Téléchargement lent** : vérifier espace `E:\WSUS`, limiter produits/langues.

---

## ✅ Checklist

- [ ] Rôle WSUS installé (WID) + contenu sur **E:\WSUS**.  
- [ ] Binding **HTTPS:8531** avec certificat `srv-wsus.stage.eni`.  
- [ ] `wsusutil configuressl` exécuté ; URL en **https** dans Options.  
- [ ] Produits/classifications/langues sélectionnés (Win11/WS2025, Security/Updates/Defs, fr‑FR).  
- [ ] Groupes **Workstations/Servers/Pilot** créés.  
- [ ] GPO **Workstations** & **Servers** déployées (client‑side targeting).  
- [ ] Première synchro ok ; premiers clients remontés.  
- [ ] Approbations testées (Pilot → généralisation).  
- [ ] Maintenance planifiée (Cleanup + reindex).  

---

## 🧠 Justifications & bonnes pratiques

- **HTTPS 8531** : chiffrage + intégrité, aucun warning sur les postes (PKI de domaine).  
- **Client‑side targeting** : cohérent avec **AGDLP** (pilotage côté AD/GPO).  
- **WID + E:\WSUS** : simple et suffisant pour ta maquette ; SQL inutile.  
- **Pilot** : réduit le risque de déployer une mise à jour problématique sur toute la flotte.  
- **Nettoyage régulier** : WSUS gonfle vite ; maintenance = performance & espace.
