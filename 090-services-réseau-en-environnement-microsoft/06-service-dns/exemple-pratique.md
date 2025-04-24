# TP 1 à 4 – Service DNS : Résolveur, Hébergeur, Redondance, Délégation

## ✅ TP 1 – DNS Résolveur

### 🔹 Étapes de configuration

1. **Installation du rôle DNS** sur SRV-DNS (non-contrôleur de domaine)

```powershell
Install-WindowsFeature -Name DNS -IncludeManagementTools
```

2. **Paramétrage de la carte réseau** pour utiliser 127.0.0.1 en DNS local

```powershell
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 127.0.0.1
```

3. **Test sans redirecteur** :

```bash
nslookup www.google.com → échec attendu
```

4. **Ajout des redirecteurs ENI** dans la console DNS

```bash
Propriétés du serveur > Redirecteurs > Ajouter : 194.2.0.20 / 8.8.8.8
```

5. **Test post-redirecteurs** :

```bash
nslookup www.google.com → succès
```

6. **Afficher et vider le cache DNS** :

```powershell
dnscmd /displaycache
Clear-DnsServerCache
```

7. **DHCP** : ajouter 192.168.1.254 comme DNS par défaut à propager aux clients

---

## ✅ TP 2 – DNS Hébergeur

### 🔹 Zone directe : `infraMD.net`

- Créée dans DNS Manager ou avec :

```powershell
Add-DnsServerPrimaryZone -Name "infraMD.net" -DynamicUpdate Secure
```

### 🔹 Ajout des enregistrements manuels

```powershell
Add-DnsServerResourceRecordA -ZoneName "infraMD.net" -Name "srvweb" -IPv4Address "192.168.10.10"
```

### 🔹 Zone inverse : `10.168.192.in-addr.arpa`

```powershell
Add-DnsServerPrimaryZone -NetworkId "192.168.10.0/24" -ZoneFile "10.168.192.in-addr.arpa.dns"
Add-DnsServerResourceRecordPtr -ZoneName "10.168.192.in-addr.arpa" -Name "10" -PtrDomainName "srvweb.infraMD.net"
```

### 🔹 Clients : suffixe DNS + test

```powershell
Set-DnsClient -InterfaceAlias Ethernet -ConnectionSpecificSuffix "infraMD.net"
```

- Résolution par nom simple `ping srvweb` et FQDN `ping srvweb.infraMD.net` : ✔️

---

## ✅ TP 3 – DNS Hébergeur et Redondance

### 🔹 Objectif : Zone secondaire entre SRV-DNS-1 et SRV-DNS-2

1. **Zone primaire sur SRV-DNS-1**

```powershell
Add-DnsServerPrimaryZone -Name "infraMD.net" -ReplicationScope "Domain"
```

2. **Autoriser le transfert de zone** vers SRV-DNS-2 dans les propriétés de la zone
3. **Zone secondaire sur SRV-DNS-2**

```powershell
Add-DnsServerSecondaryZone -Name "infraMD.net" -MasterServers 192.168.10.1
```

4. **Test propagation** :

- Ajouter un A record sur SRV-DNS-1 → vérifier sa présence sur DNS-2

4. **Ajout dans DHCP** des deux serveurs DNS comme options 006 : clients ont double résolution
5. **Simulation panne** DNS-1 : clients résolvent via DNS-2

---

## ✅ TP 4 – DNS Délégation et Redirections

### 🔹 Hiérarchie à configurer

```
eni.fr (DNS1) → nantes.eni.fr (DNS2) → res.nantes.eni.fr (DNS3)
```

### 🔹 Sur DNS1

- Zone primaire : `eni.fr`
- Délégation vers `nantes.eni.fr` :

```powershell
Add-DnsServerZoneDelegation -Name "nantes" -ParentZone "eni.fr" -NameServer "dns2.eni.fr" -IPAddress "10.0.0.2"
```

### 🔹 Sur DNS2

- Zone primaire : `nantes.eni.fr`
- Délégation vers `res.nantes.eni.fr`

### 🔹 Sur DNS3

- Zone primaire : `res.nantes.eni.fr`
- Ajout de `srv1.res.nantes.eni.fr`

### 🔹 Tests

```powershell
nslookup srv1.res.nantes.eni.fr
```

- Tracés des requêtes possibles (depuis clients pointant vers DNS1)

### 🔹 Ajout de redirection conditionnelle

- DNS1 > redirecteur conditionnel `*.nantes.eni.fr` vers DNS2
- DNS2 > redirecteur conditionnel `*.res.nantes.eni.fr` vers DNS3

---

## 🧠 À retenir pour les révisions

- La délégation permet la répartition de la gestion DNS
- Les zones secondaires assurent une lecture redondée
- La résolution conditionnelle optimise le routage DNS entre entités

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Nommer les serveurs en cohérence avec le FQDN|Facilite la lecture et la maintenance|
|Activer le transfert de zone uniquement vers IPs autorisées|Renforce la sécurité|
|Tester chaque niveau de délégation avec `nslookup`|Déboguer la chaîne de résolution|
|Redonder les zones critiques|Haute disponibilité sans duplication manuelle|
|Utiliser des redirecteurs conditionnels pour l’inter-site|Améliore performance et contrôle DNS interne|
