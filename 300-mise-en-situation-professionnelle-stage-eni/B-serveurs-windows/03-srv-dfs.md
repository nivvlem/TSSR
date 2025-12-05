# 🗂️ SRV-DFS — DFS Namespace (et préparation à la réplication)

> Hôte : **SRV-DFS** — IP : **192.168.55.23/25** — Passerelle : **192.168.55.1** — DNS : **192.168.55.20 / 192.168.55.21**  
> Volume données : **E:\(exigé)  
> Domaine : stage.eni**  
> Namespace attendu : `\\stage.eni\\DFSROOT`

## 0) Pré‑requis

- **AD DS** opérationnel (SRV-DC1 / SRV-DC2).  
- **OUs** et **groupes AGDLP** existants : `GG_Users_*`, `DL_Acces_*`. 
- **OPNsense** : flux SMB/DFS autorisés depuis les clients (TCP 445) → cf. matrice de flux.  
- **Nom NETBIOS** : `STAGE`.

---

## 1) Arborescence sur disque (E:\)

Créer l’arborescence **sur SRV-DFS** :

```powershell
$root = "E:\\PARTAGES"
$paths = @(
  "$root\\COMMUN",
  "$root\\RH",
  "$root\\IT",
  "$root\\PRODUCTION",
  "$root\\LOGICIELS"
)
$paths | ForEach-Object { New-Item -ItemType Directory -Path $_ -Force | Out-Null }
```

### Partages SMB (cibles)

> On **partage** chaque dossier (cibles DFS) + un **dossier racine** pour héberger le namespace (caché `$`).

```powershell
# Dossier hôte du namespace (racine hébergée)
New-Item -ItemType Directory -Path "E:\\DFSROOT" -Force | Out-Null
New-SmbShare -Name "DFSROOT$" -Path "E:\\DFSROOT" -ChangeAccess "Domain Admins" -FullAccess "Domain Admins"

# Cibles métier
New-SmbShare -Name "COMMUN$"     -Path "E:\\PARTAGES\\COMMUN"     -ChangeAccess "Domain Users" -FullAccess "Domain Admins"
New-SmbShare -Name "RH$"         -Path "E:\\PARTAGES\\RH"         -FullAccess "Domain Admins"
New-SmbShare -Name "IT$"         -Path "E:\\PARTAGES\\IT"         -FullAccess "Domain Admins"
New-SmbShare -Name "PRODUCTION$" -Path "E:\\PARTAGES\\PRODUCTION" -FullAccess "Domain Admins"
New-SmbShare -Name "LOGICIELS$"  -Path "E:\\PARTAGES\\LOGICIELS"  -ChangeAccess "Domain Users" -FullAccess "Domain Admins"
```

### NTFS (AGDLP)

> On applique **les droits NTFS** via `DL_Acces_*` et **jamais** directement aux utilisateurs.

```powershell
# Exemple RH : Lecture/Écriture
icacls "E:\\PARTAGES\\RH" /inheritance:r
icacls "E:\\PARTAGES\\RH" /grant "STAGE\\DL_Acces_RH_RW:(OI)(CI)M" "STAGE\\Domain Admins:(OI)(CI)F"

# Lecture seule (si besoin)
icacls "E:\\SHARES\\RH" /grant "STAGE\\DL_Acces_RH_R:(OI)(CI)R"

# IT/PRODUCTION/… (adapter aux DL existants)
icacls "E:\\SHARES\\IT"          /inheritance:r
icacls "E:\\SHARES\\IT"          /grant "STAGE\\DL_Acces_IT_RW:(OI)(CI)M" "STAGE\\Domain Admins:(OI)(CI)F"

icacls "E:\\SHARES\\PRODUCTION"  /inheritance:r
icacls "E:\\SHARES\\PRODUCTION"  /grant "STAGE\\DL_Acces_Production_RW:(OI)(CI)M" "STAGE\\Domain Admins:(OI)(CI)F"

# COMMUN/LOGICIELS : lecture pour tous (ex.)
icacls "E:\\SHARES\\COMMUN"    /inheritance:r
icacls "E:\\SHARES\\COMMUN"    /grant "STAGE\\Domain Users:(OI)(CI)R" "STAGE\\Domain Admins:(OI)(CI)F"

icacls "E:\\SHARES\\LOGICIELS" /inheritance:r
icacls "E:\\SHARES\\LOGICIELS" /grant "STAGE\\Domain Users:(OI)(CI)R" "STAGE\\Domain Admins:(OI)(CI)F"
```

> **Justification :** NTFS = **sécurité effective** ; **Share** = large (Change pour Domain Users si besoin). On s’appuie sur `DL_Acces_*` (AGDLP) pour rester lisible et **évolutif**.

---

## 2) Créer le namespace **domaine‑based**

> GUI : `dfsmgmt.msc` → **Namespaces** → New Namespace → Server **SRV-DFS** → \`SRV-DFS\DFSROOT$` → **Domain‑based** → Name = `DFSROOT` → Options **Windows Server 2008 mode** (ou + récent) → **Enable access‑based enumeration (ABE)**.

### PowerShell (recommandé)

```powershell
Import-Module DFSN
# Namespace domaine hébergé par SRV-DFS\ nNew-DfsnRoot -TargetPath "\\SRV-DFS\\DFSROOT$" -Type DomainV2 -Path "\\stage.eni\\DFSROOT" -EnableAccessBasedEnumeration $true
```

**Options clés :**
- **Domain‑based (V2)** : publication en AD, haute évolutivité.  
- **ABE** : l’utilisateur **ne voit** que les dossiers pour lesquels il a un **droit** (via `DL_Acces_*`).

---

## 3) Ajouter les **dossiers du namespace** (liens)

Chaque dossier **DFS** pointe vers une **cible** (le partage SMB) — on peut en ajouter plusieurs **plus tard** quand un 2ᵉ serveur sera disponible.

```powershell
# Commun
New-DfsnFolder -Path "\\stage.eni\\DFSROOT\\COMMUN"     -TargetPath "\\SRV-DFS\\COMMUN$"
# RH
New-DfsnFolder -Path "\\stage.eni\\DFSROOT\\RH"         -TargetPath "\\SRV-DFS\\RH$"
# IT
New-DfsnFolder -Path "\\stage.eni\\DFSROOT\\IT"         -TargetPath "\\SRV-DFS\\IT$"
# Production
New-DfsnFolder -Path "\\stage.eni\\DFSROOT\\PRODUCTION" -TargetPath "\\SRV-DFS\\PRODUCTION$"
# Logiciels
New-DfsnFolder -Path "\\stage.eni\\DFSROOT\\LOGICIELS"  -TargetPath "\\SRV-DFS\\LOGICIELS$"
```

### Sécurité des dossiers **DFS** (ABE)

> Pour que l’ABE soit efficace, ajouter **au niveau du dossier DFS** les groupes autorisés (lecture/énumération).  
> GUI : `dfsmgmt.msc` → dossier → **Properties** → **Security**.

- `RH` → `DL_Acces_RH_R` (Read), `DL_Acces_RH_RW` (Read).  
- `IT` → `DL_Acces_IT_*` …  
- `COMMUN/LOGICIELS` → `Domain Users` (Read).

> **Justification :** L’ABE s’appuie sur les **droits du dossier DFS** (métadonnées de l’espace de noms) pour **masquer** ce que l’utilisateur ne doit pas voir.

---

## 4) (Option) Préparation à **DFSR**

> **Important :** **DFS Replication** (DFSR) nécessite **au moins deux serveurs Windows**.  
> La **réplication sur un autre disque du même serveur** n’est **pas supportée** par DFSR.  
> Alternatives immédiates :
- **Windows Server Backup** (état système + données E:\SHARES).  
- **Shadow Copies** (versions précédentes) pour l’utilisateur.  
- **Robocopy planifié** vers un **disque externe** ou un **NAS** (sauvegarde, pas haute dispo).  
- Prévoir à terme **SRV-DFS2** pour activer une vraie **tolérance de panne** avec DFSR.

---

## 5) Intégration **GPO (mappage)**

Mappage automatique par service (ciblage `GG_Users_*`) :
- `R:` → `\\stage.eni\\DFSROOT\\RH` (ciblage **`GG_Users_RH`**).  
- `I:` → `\\stage.eni\\DFSROOT\\IT` (ciblage **`GG_Users_IT`**).  
- `P:` → `\\stage.eni\\DFSROOT\\PRODUCTION` …

---

## 6) Tests & validation

Depuis un **client Windows** membre du domaine :

```powershell
# Voir le cache DFS (côté client)
dfsutil /pktinfo

# Accès logique
Test-NetConnection SRV-DFS -Port 445
ls \\stage.eni\DFSROOT
ls \\stage.eni\DFSROOT\RH

# Écriture si membre RH
"test" | Out-File \\stage.eni\DFSROOT\RH\test.txt
```

Vérifier :
- Les non‑membres RH **ne voient pas** `RH` (ABE).  
- Les utilisateurs RH **écrivent** dans `RH`.  
- Les chemins DFS **restent stables** même si on déplace les données.

---

## 7) Supervision & exploitation

- **Zabbix agent** sur SRV-DFS (CPU, RAM, disque E:\, sessions SMB).  
- **Logs** : `C:\Windows\System32\Winevt\Logs\Microsoft-Windows-DFSN-Server%4Operational.evtx`.  
- **Sauvegarde** : inclure **données E:\SHARES** + **config DFS** (export `dfsn` via script si besoin).  

Exemple export des objets DFS :

```powershell
Get-DfsnRoot -Path "\\stage.eni\\DFSROOT" | fl *
Get-DfsnFolder -Path "\\stage.eni\\DFSROOT\*" | Select-Object Path,State | ft -AutoSize
Get-DfsnFolderTarget -Path "\\stage.eni\\DFSROOT\*" | ft Path,TargetPath -Auto
```

---

## ✅ Checklist

- [ ] Arborescence **E:\PARTAGES** créée.  
- [ ] Partages **COMMUN$**, **RH$**, **IT$**, **PRODUCTION$**, **LOGICIELS$** publiés.  
- [ ] NTFS appliqué via **DL_Acces_* (AGDLP)**.  
- [ ] Namespace **domaine** `\\stage.eni\\DFSROOT` créé (ABE **ON**).  
- [ ] Dossiers DFS + cibles ajoutés (une cible / dossier pour l’instant).  
- [ ] Mappage lecteurs via **GPO** par service.  
- [ ] Tests ABE / droits OK.  
- [ ] Supervision + sauvegarde prévues.  
- [ ] Note : réplication **DFSR** prête quand **SRV-DFS2** sera ajouté.

---

## 🧠 Justifications & bonnes pratiques

- **Domain‑based namespace** : résilient car stocké dans l’AD ; transparent pour les clients.  
- **ABE** : évite la **sur‑exposition** des dossiers ; réduit les erreurs utilisateur.  
- **AGDLP** : droits **lisibles** et **faciles à maintenir**.  
- **Cibles en `$`** (cachées) : seuls les chemins DFS sont communiqués (UX + sécurité).  
- **Préparer DFSR** : anticiper la création d’un **second serveur** pour la haute dispo ; en attendant, **sauvegarder**.
