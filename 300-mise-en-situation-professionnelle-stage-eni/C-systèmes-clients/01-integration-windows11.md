# 💻 CLIENT-WIN11 — Intégration au domaine (GPO, services, WSUS, supervision)

- **Hôte** : CLIENT-WIN11 — **IP** : `192.168.52.10/23` — **Passerelle** : `192.168.52.254` — **DNS** : `192.168.55.20` / `192.168.55.21`
- **Domaine** : `stage.eni` — **FQDN** : `client-win11.stage.eni`
- **OU cible** : `_POSTESCLIENTS` ; GPO liées : sécurité, redirection de dossiers, WSUS, montages DFS.
- **Services visés** : DFS/Samba, ERP (HTTPS via PKI), RDS, GLPI, DNS/NTP, WSUS.
- **Publication externe** : aucune (usage interne LAN Clients).

---

## 0) Pré-requis

- Windows **11 Pro** (édition requise pour joindre un domaine).
- Accès réseau LAN Clients (`192.168.52.0/23`) via OPNsense.
- Compte admin domaine : `stage\\Administrateur`.
- Certificat de la CA interne déployé par GPO.
- Horloge système synchronisée avec les DC (Kerberos).

---

## 1) Préparation réseau

### GUI

1. **Paramètres → Réseau & Internet → Ethernet → Modifier**.
2. Configurer IP `192.168.52.10`, masque `255.255.254.0`, passerelle `192.168.52.254`, DNS `192.168.55.20` & `192.168.55.21`.

### PowerShell

```powershell
Get-NetIPConfiguration
Get-DnsClientServerAddress
```

---

## 2) Vérifications de base

```powershell
Test-Connection 192.168.55.20 -Count 4   # Ping SRV-DC1
Test-Connection 192.168.55.21 -Count 4   # Ping SRV-DC2
Resolve-DnsName srv-dc1.stage.eni
Resolve-DnsName erp.stage.eni
w32tm /query /status
```

---

## 3) Joindre le domaine

### Méthode GUI

1. **Paramètres → Système → Informations → Renommer ce PC (avancé)**.
2. Onglet **Nom de l’ordinateur → Modifier**.
3. Sélectionner **Domaine** et saisir `stage.eni`.
4. Authentification `stage\\Administrateur`.
5. Redémarrer.

### Méthode PowerShell

```powershell
Rename-Computer -NewName "CLIENT-WIN11" -Force
Add-Computer -DomainName stage.eni -Credential stage\Administrator -Force -Restart
```

---

## 4) Contrôles post-jonction & GPO

```powershell
Test-ComputerSecureChannel -Verbose
whoami /all
gpresult /r
gpupdate /force
```

Attendu : appartenance aux groupes du domaine et GPO appliquées.

---

## 5) Accès aux services

### DFS/Samba

```powershell
net use Z: \\SRV-FILES\COMMUN /persistent:yes
Get-SmbShare -CimSession SRV-FILES
```

### ERP

```powershell
Test-NetConnection erp.stage.eni -Port 443
start https://erp.stage.eni
```

### RDS

```powershell
mstsc /v:SRV-RDS
Test-NetConnection SRV-RDS -Port 3389
```

### GLPI

Ouvrir navigateur → `https://srv-glpi.stage.eni/`

---

## 6) WSUS

```powershell
UsoClient StartScan
UsoClient StartDownload
UsoClient StartInstall
```

---

## 7) Supervision & sauvegarde

- **Supervision** : installation de l’agent Zabbix 2 avec configuration vers SRV-ZABBIX (`192.168.55.29`).
- **Sauvegarde** : tâche planifiée exécutant `backup_user.ps1` vers `\\SRV-FILES\backups` avec compte `svc-backup`.

---

## 8) Intégration matrice de flux

- Client → DCs : 53, 88, 389, 445, 135, 3268.
- Client → SRV-FILES/DFS : 445.
- Client → SRV-ERP : 443.
- Client → SRV-RDS : 3389.
- Client → SRV-WSUS : 8530/8531.
- Client → SRV-GLPI : 80/443.

---

## 9) Validation — commandes clés

```powershell
Get-NetIPConfiguration
Resolve-DnsName srv-dc1.stage.eni
Test-ComputerSecureChannel -Verbose
whoami /all
gpresult /r
net use Z: \\SRV-FILES\COMMUN
Test-NetConnection erp.stage.eni -Port 443
mstsc /v:SRV-RDS
UsoClient StartScan
```

---

## ✅ Checklist

-  IP/DNS configurés correctement.
-  Pings SRV-DC1/SRV-DC2 OK.
-  Résolution DNS interne/externe OK.
-  Poste joint au domaine.
-  GPO appliquées.
-  DFS/Samba accessibles.
-  ERP en HTTPS accessible sans erreur cert.
-  RDS fonctionnel.
-  GLPI accessible.
-  WSUS actif.
-  Zabbix agent en supervision.
-  Sauvegarde utilisateurs automatisée.

---

## 🧠 Justifications & bonnes pratiques

- **Windows 11 Pro** : seule édition permettant la jonction AD.
- **DNS AD** : indispensable pour Kerberos et la localisation des services AD.
- **AGDLP** : gestion évolutive et sécurisée des droits.
- **Supervision Zabbix** : centralisation de l’état des postes.
- **Sauvegarde automatisée** : fiabilité accrue, limite les erreurs humaines.

---

## 🔗 Références

- Microsoft — [Group Policy overview](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/gpresult)
