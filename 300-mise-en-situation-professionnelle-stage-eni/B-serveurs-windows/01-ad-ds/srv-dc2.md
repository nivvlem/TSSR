# 🏰 SRV-DC2 — Installation & configuration du second contrôleur de domaine (AD DS + DNS)

> Hôte : **SRV-DC2** — IP : **192.168.55.21/25** — Passerelle : **192.168.55.1** — DNS : **192.168.55.21 (lui‑même)** / **192.168.55.20 (DC1)** — Domaine : **stage.eni**

## 0) Pré-requis système

1. **Nom d’hôte** : `SRV-DC2`.  
2. **Adresse IP fixe** :
   - IPv4 : `192.168.55.21/25`  
   - Passerelle : `192.168.55.1` (OPNsense)  
   - DNS : `192.168.55.21` (primaire), `192.168.55.20` (secondaire).  
   - *Justif.* : chaque DC pointe d’abord sur lui‑même, puis sur l’autre DC.
3. **MAJ système** appliquées.

> **Vérif rapide (PowerShell)**  
> `Get-NetIPConfiguration`  
> `Resolve-DnsName srv-dc2.stage.eni`

---

## 1) Installation du rôle AD DS + DNS

### GUI

`Gérer → Ajouter des rôles et fonctionnalités` :
- Sélectionner **AD DS** + **DNS**.

### PowerShell

```powershell
Install-WindowsFeature AD-Domain-Services, DNS -IncludeManagementTools
```

---

## 2) Promotion en contrôleur de domaine secondaire

### GUI

Dans **Gestionnaire de serveur** → Notification → `Promouvoir ce serveur en contrôleur de domaine` :
- **Ajouter un contrôleur de domaine à une forêt existante**.
- Domaine : `stage.eni`.
- Choisir un compte admin du domaine (STAGE\\Administrateur).
- Options : DNS intégré, catalogue global activé.
- Mot de passe DSRM (sûr, stocké).
- Vérifier la connectivité avec DC1 → Installer → reboot.

### PowerShell

```powershell
Install-ADDSDomainController -DomainName "stage.eni" -InstallDns:$true -Credential (Get-Credential) -SiteName "Default-First-Site-Name" -DatabasePath "C:\\Windows\\NTDS" -LogPath "C:\\Windows\\NTDS" -SysvolPath "C:\\Windows\\SYSVOL" -SafeModeAdministratorPassword (Read-Host -AsSecureString)
```

---

## 3) Vérifications post-installation
### Réplication AD

```powershell
repadmin /replsummary
repadmin /showrepl
```
- Attendu : **0 erreur**, latence faible.

### Santé DC

```powershell
dcdiag /v
Get-ADDomainController -Filter * | ft HostName,IsGlobalCatalog
```
- Attendu : DC1 et DC2 listés, GC=True.

### DNS

- Vérifier que la zone `stage.eni` et la zone inverse sont bien **répliquées**.
- Test enregistrement :

```powershell
Resolve-DnsName srv-dc1.stage.eni
Resolve-DnsName srv-dc2.stage.eni
```

### Sysvol
Vérifier partage SYSVOL :

```powershell
net share
```
- Attendu : `NETLOGON` et `SYSVOL` présents.

---

## 4) Configuration DNS secondaire

- DC2 devient résolveur DNS secondaire.
- Ajouter redirecteur vers SRV-DNS (192.168.56.250) :

```powershell
Add-DnsServerForwarder -IPAddress 192.168.56.250 -PassThru
```
- Vérifier propagation :

```powershell
Resolve-DnsName google.com
```

---

## 5) FSMO & rôles

- DC1 reste détenteur des rôles FSMO par défaut.  
- Vérif :

```powershell
netdom query fsmo
```
- Attendu : tous les rôles sur SRV-DC1.  
- Possibilité de transférer en cas de panne planifiée.

---

## 6) Intégration avec DC1

- Vérifier réplication automatique des **GPOs**.
- Lancer un `gpupdate /force` sur un poste client, puis tester connexion même si DC1 éteint.

---

## 7) Sauvegarde état système

Planifier sauvegarde régulière :

```powershell
wbadmin start systemstatebackup -backuptarget:E: -quiet
```
- À faire sur **DC1 et DC2**.

---

## ✅ Checklist

- [ ] SRV-DC2 hostname/IP fixe OK.
- [ ] Rôles AD DS + DNS installés.
- [ ] Ajout au domaine `stage.eni` réussi.
- [ ] Catalogue global activé.
- [ ] Zones DNS répliquées.
- [ ] Réplication AD OK (`repadmin`).
- [ ] `dcdiag` sans erreurs.
- [ ] SYSVOL partagé.
- [ ] Redirecteur DNS vers SRV-DNS (192.168.56.250).
- [ ] Sauvegarde état système prévue.

---

## 📝 Notes & bonnes pratiques

- Toujours avoir **au moins 2 DCs** pour redondance.
- DNS AD doivent rester **intégrés et répliqués**.
- SRV-DC2 doit être **GC** (catalogue global) pour authentification universelle.
- Documenter captures (`repadmin`, `dcdiag`, DNS Manager).
