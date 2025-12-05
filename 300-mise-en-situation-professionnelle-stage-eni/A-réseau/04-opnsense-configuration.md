# ⚙️ Configuration d’OPNsense

## 🔑 Création des alias
Aller dans **Firewall → Aliases** :

### Réseaux

- `LAN_CLIENTS` → 192.168.52.0/23
- `LAN_SERVEURS` → 192.168.55.0/25
- `DMZ` → 192.168.56.248/29
- `WAN_NET` → 192.168.1.0/24

### Hôtes

- `SRV-DC1` → 192.168.55.20
- `SRV-DC2` → 192.168.55.21
- `SRV-ERP` → 192.168.55.22
- `SRV-DFS` → 192.168.55.23
- `SRV-WSUS` → 192.168.55.24
- `SRV-RDS` → 192.168.55.25
- `SRV-FILES` → 192.168.55.26
- `SRV-DB` → 192.168.55.27
- `SRV-GLPI` → 192.168.55.28
- `SRV-ZABBIX` → 192.168.55.29
- `SRV-DNS` → 192.168.56.250
- `SRV-WEB` → 192.168.56.251

### Groupes

- `DCs` → {192.168.55.20, 192.168.55.21}
- **Optionnel** : `ADMINS_IT_IPS` → alias d’IP réservées aux postes administrateurs (ex. 192.168.52.50–52.60).  
⚠️ Ce n’est **pas un groupe AD**, mais un **alias réseau OPNsense** permettant de restreindre les flux d’administration.

---

## 🌉 Règles de firewall

Aller dans **Firewall → Rules**. Sélectionner chaque interface (LAN, SERVEURS, DMZ, WAN) et appliquer :

### LAN Clients → Serveurs

1. `LAN_CLIENTS → DCs` : DNS (53), Kerberos (88), LDAP (389/636), SMB/SYSVOL (445), RPC (135 + ports dynamiques), GC (3268/3269). **ALLOW**.
2. `LAN_CLIENTS → SRV-ERP` : TCP 443. **ALLOW**.
3. `LAN_CLIENTS → SRV-RDS` : TCP 3389. **ALLOW**.
4. `LAN_CLIENTS → SRV-FILES/SRV-DFS` : TCP 445. **ALLOW**.
5. `LAN_CLIENTS → SRV-WSUS` : TCP 8530/8531. **ALLOW**.
6. `LAN_CLIENTS → SRV-GLPI` : TCP 80/443. **ALLOW**.
7. `LAN_CLIENTS → SRV-WEB` : TCP 80/443. **ALLOW**.

### Administration (via alias optionnel `ADMINS_IT_IPS`)

8. `ADMINS_IT_IPS → LAN_SERVEURS` : TCP 3389. **ALLOW**.
9. `ADMINS_IT_IPS → LAN_SERVEURS/DMZ` : TCP 22. **ALLOW**.

➡️ Si l’alias `ADMINS_IT_IPS` n’est pas créé, remplacer par `LAN_CLIENTS` (moins sécurisé mais plus simple).

### Supervision

10. `SRV-ZABBIX → LAN_SERVEURS/DMZ` : TCP 10050 (agent passif). **ALLOW**.
11. `SRV-ZABBIX ↔ agents` : TCP 10051 (actif). **ALLOW**.

### DMZ

12. `SRV-WEB → SRV-DB` : TCP 3306. **ALLOW**.
13. `DCs → SRV-DNS` : UDP/TCP 53. **ALLOW**.
14. `SRV-DNS → WAN` : UDP/TCP 53. **ALLOW**.

### WAN

15. `WAN → SRV-WEB` : TCP 80/443. **ALLOW (DNAT)`.
16. `WAN → LAN/DMZ` (autres). **DENY**.

---

## 🔄 NAT

Aller dans **Firewall → NAT → Outbound**.
- Mode : **Hybrid Outbound NAT rule generation**.
- Ajouter règles SNAT :
  - LAN Clients (192.168.52.0/23) → WAN IP.
  - LAN Serveurs (192.168.55.0/25) → WAN IP.
  - DMZ (192.168.56.248/29) → WAN IP.

Aller dans **Firewall → NAT → Port Forward**.
- WAN → 192.168.56.251 (SRV-WEB). Ports TCP 80, 443.
- Rediriger HTTP 80 → HTTPS 443 côté SRV-WEB.

---

## 🛡️ Sécurité avancée

- **Bloquer accès GUI OPNsense depuis WAN**.
- Activer **logging** sur règles DENY WAN→LAN/DMZ.
- Restreindre les règles #8 / #9 (RDP/SSH admin) :
  - Source = `ADMINS_IT_IPS` (si utilisé).
  - Optionnel : **Time-based rules** (heures ouvrées).
- Activer **IDS/IPS Suricata** (option bonus) → interface WAN.
- Installer plugin **GeoIP blocking** (si souhaité) pour refuser IP hors FR.

---

## ✅ Validation

Depuis un poste client Windows (192.168.52.10) :
- `ping 8.8.8.8` → OK.
- `Resolve-DnsName qwant.com` → via DCs + SRV-DNS.
- `Test-NetConnection erp.stage.eni -Port 443` → OK.
- `mstsc /v:SRV-RDS` → ouverture bureau distant.
- `dir \\SRV-FILES\COMMUN` → accès partagé.

Depuis Internet (simulateur ou VM externe bridgée) :
- Accès HTTP/HTTPS → SRV-WEB (WordPress).
- Accès bloqué aux autres IP internes (test nmap sur WAN IP : seuls 80/443 ouverts).

---

## 📌 Bonnes pratiques appliquées

- **Principe du moindre privilège** : seules les règles nécessaires sont ALLOW.
- **Traçabilité** : labels explicites (`RULE#14_DNS_REDIRECTEUR`).
- **Robustesse** : NAT hybride pour flexibilité.
- **Durcissement** : GUI non exposée, SSH limité, logs centralisés (Zabbix/GLPI).
