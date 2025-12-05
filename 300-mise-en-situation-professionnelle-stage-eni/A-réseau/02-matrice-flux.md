# 🔐 Matrice de flux réseau

## 🧭 Politique générale

- Pare‑feu **stateful** (OPNsense) : autorise les paquets de **retour** des sessions initiées.
- **Par défaut : DENY** entre zones (LAN Clients ↔ LAN Serveurs ↔ DMZ ↔ WAN).
- Résolution **DNS** :
  - Clients/Serveurs → **DCs** (55.20/55.21).
  - DCs → **DNS cache** en DMZ (56.250) via **redirecteur**.
  - DNS cache → **DNS FAI** (WAN).
- **NTP** (horodatage Kerberos) : tous membres du domaine → DCs (UDP/123).
- Trafic **administration** (RDP/SSH) réservé au groupe **Admins IT** du LAN Clients (alias d’IP).

---

## 🗺️ Vue matricielle (synthèse)

| From \ To        | LAN Clients                    | LAN Serveurs                                        | DMZ                                         | WAN                         |
|------------------|--------------------------------|-----------------------------------------------------|---------------------------------------------|-----------------------------|
| **LAN Clients**  | —                              | AD/DNS, DFS/SMB, WSUS, GLPI, RDS, ERP               | Web (HTTP/HTTPS → 56.251)                   | HTTP/HTTPS via NAT sortant  |
| **LAN Serveurs** | RAS (retour seul)              | Inter‑serveurs (AD/DB/Zabbix selon règles ciblées)  | DCs → DNS cache (53), Web ↔ DB (3306)       | DNS cache → DNS FAI (53)    |
| **DMZ**          | RAS (retour seul)              | Web → DB (3306), DNS cache ← DCs (53)               | —                                           | Publication WEB seulement   |
| **WAN**          | Interdit                       | Interdit                                            | HTTP/HTTPS vers 56.251 (DNAT)               | —                           |

RAS = Rien À Signaler (aucune session **initiée** permise par défaut).

---

## 📜 Règles de filtrage (OPNsense)

> Numérotation indicative pour retrouver rapidement une règle dans l’UI.

| # | Source (zone/host)           | → Destination (zone/host)         | Proto/Ports                      | Objet / Justification                         | Action |
|---|------------------------------|-----------------------------------|----------------------------------|-----------------------------------------------|--------|
| 1 | LAN Clients (tous)           | WAN (Internet)                    | TCP 80,443                       | Navigation web utilisateurs (NAT sortant)     | ALLOW  |
| 2 | LAN Clients (tous)           | SRV‑WEB (DMZ 56.251)              | TCP 80,443                       | Accès site vitrine/WordPress                  | ALLOW  |
| 3 | LAN Clients (tous)           | SRV‑ERP (55.22)                   | TCP 443                          | ERP via PKI (HTTPS)                           | ALLOW  |
| 4 | LAN Clients (tous)           | SRV‑RDS (55.25)                   | TCP 3389                         | Accès Bureau à Distance                       | ALLOW  |
| 5 | LAN Clients (tous)           | SRV‑DFS (55.23), SRV‑FILES (55.26)| TCP 445                          | Partages/DFS, profils itinérants              | ALLOW  |
| 6 | LAN Clients (tous)           | SRV‑WSUS (55.24)                  | TCP 8530 (ou 8531/HTTPS)         | Mises à jour Windows                          | ALLOW  |
| 7 | LAN Clients (tous)           | DCs (55.20/55.21)                 | UDP/TCP 53,88,389,445,135,3268   | Auth AD, DNS, SYSVOL/RPC, GC                  | ALLOW  |
| 8 | LAN Clients (tous)           | SRV‑GLPI (55.28)                  | TCP 80,443                       | Portail GLPI / FAQ                            | ALLOW  |
| 9 | LAN Clients (Admins IT)      | Windows servers (55.x)            | TCP 3389                         | Administration RDP                             | ALLOW  |
|10 | LAN Clients (Admins IT)      | Linux servers (55.x/56.x)         | TCP 22                           | Administration SSH                             | ALLOW  |
|11 | SRV‑WEB (56.251)             | SRV‑DB (55.27)                    | TCP 3306                         | WordPress → MariaDB                           | ALLOW  |
|12 | DCs (55.20/55.21)            | SRV‑DNS (56.250)                  | UDP/TCP 53                       | Redirecteur DNS externe                        | ALLOW  |
|13 | SRV‑DNS (56.250)             | WAN (DNS FAI)                     | UDP/TCP 53                       | Résolution vers amont                          | ALLOW  |
|14 | SRV‑ZABBIX (55.29)           | Tous serveurs (55.x / 56.251)     | TCP 10050                        | Supervision agents (mode passif)               | ALLOW  |
|15 | SRV‑ZABBIX (55.29) ⟵ agents  | SRV‑ZABBIX (55.29)                | TCP 10051                        | Supervision agents (mode actif)                | ALLOW  |
|16 | Postes Linux (LAN Clients)   | SRV‑FILES (55.26)                 | TCP 445                          | Accès Samba depuis Linux                       | ALLOW  |
|17 | Tous membres du domaine      | DCs (55.20/55.21)                 | UDP 123                          | NTP / synchro temps                            | ALLOW  |
|18 | DMZ (hors 56.251/56.250)     | LAN Serveurs                      | —                                | Aucune ouverture par défaut                    | DENY   |
|19 | WAN                          | SRV‑WEB (56.251)                  | TCP 80,443                       | Publication HTTP/HTTPS (DNAT)                  | ALLOW  |
|20 | WAN                          | SRV‑DNS (56.250)                  | —                                | Pas de DNS public                              | DENY   |
|21 | WAN                          | LAN Serveurs / LAN Clients        | —                                | Protection périmètre                           | DENY   |

**Remarques :**
- Règle **#7** (ports AD) peut être **segmentée** en règles fines par service si besoin (Kerberos 88, LDAP 389/636, DNS 53, SMB/SYSVOL 445, RPC 135 + plage dynamique, GC 3268/3269).
- Pour **WSUS**, privilégier **8531/HTTPS** si ta PKI domaine est en place.
- Pour **Zabbix**, favoriser l’**agent passif** (#14) pour limiter les flux entrants DMZ→LAN.

---

## 🌉 Règles NAT

### NAT sortant (SNAT / Masquerade)

- LAN Clients **192.168.52.0/23**  → WAN : masquerade via IP WAN OPNsense.
- LAN Serveurs **192.168.55.0/25** → WAN : idem.
- DMZ **192.168.56.248/29**       → WAN : idem (nécessaire pour le DNS cache en DMZ).

### NAT entrant (DNAT)

- WAN → **SRV‑WEB (56.251)** : TCP **80, 443** (option côté serveur : redirection 80 → 443).
- Aucun DNAT pour **SRV‑DNS** (cache interne uniquement, non exposé publiquement).

---

## 🧱 Objets & alias conseillés (OPNsense)

- **ALIASES Réseaux** : `LAN_CLIENTS`, `LAN_SERVEURS`, `DMZ`, `WAN_NET`.
- **ALIASES Hôtes** : `SRV_WEB`, `SRV_DNS_DMZ`, `SRV_DB`, `SRV_DFS`, `SRV_FILES`, `SRV_WSUS`, `SRV_RDS`, `SRV_ERP`, `SRV_ZABBIX`, `DCs`.
- **ALIASES Admin** : `ADMINS_IT_IPS` (IP sources autorisées pour RDP/SSH), éventuellement **time‑based** (ex. heures ouvrées) pour durcir.

---

## 🛡️ Journalisation & visibilité

- **Log en Alert** : tous les **DENY** en entrée depuis **WAN** vers **LAN/DMZ**.
- Active les **labels** de règles (ex. `RULE#14_ZABBIX_AGENT_PASSIVE`) pour faciliter les corrélations.
- Exporte les logs vers **Zabbix**/**GLPI** (ou syslog distant) pour historiser les changements.

---

## ✅ Checklist de validation

1. **DNS** : depuis un client → `Resolve-DnsName` interne/externe ; côté DC → `forwarder` = 56.250 ; côté SRV‑DNS → test récursif vers FAI.
2. **HTTP/HTTPS** : client ↔ 56.251 ; extérieur ↔ 56.251 (si DNAT activé).
3. **ERP** : `Test-NetConnection erp.stage.eni -Port 443`.
4. **RDP** : clients autorisés ↔ 55.25.
5. **SMB/DFS** : `Test-NetConnection SRV-FILES -Port 445` + accès aux partages.
6. **WSUS** : client → 55.24 (8530/8531), lancer un scan.
7. **Zabbix** : 55.29 ↔ agents (10050/10051).
8. **NTP** : `w32tm /query /status` côté clients.

---

## 🔎 Justification sécurité (principe du moindre privilège)

- **Segmentation** stricte par zones, **aucun flux direct WAN→LAN**.
- **DMZ** exposée uniquement pour **HTTP/HTTPS** ; DNS en **cache interne** non publié.
- **Flux administratifs** réduits aux IP **Admins IT** (+ option time‑based).
- **Traçabilité** par journalisation ciblée des refus et labellisation des règles.
