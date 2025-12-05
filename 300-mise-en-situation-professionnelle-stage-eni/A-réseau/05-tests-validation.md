# ✅ Tests & Validation réseau

## 🧪 Tests de connectivité de base
### Ping & routes

- `ping 192.168.52.254` → tester passerelle LAN Clients (OPNsense).
- `ping 192.168.55.20` → tester DC1 depuis un client.
- `ping 192.168.56.251` → tester SRV-WEB depuis LAN Clients.
- `tracert 8.8.8.8` (Windows) ou `traceroute 8.8.8.8` (Linux) → vérifier passage par OPNsense.

### Résolution DNS

- `Resolve-DnsName srv-dc1.stage.eni` (client Windows) → renvoie 192.168.55.20.
- `dig @192.168.55.20 srv-web.stage.eni` (client Linux) → résolution interne.
- `dig @192.168.56.250 google.com` (depuis DC) → redirection via SRV-DNS en DMZ.

---

## 🌐 Tests accès Internet

- Depuis un client :
  - `Test-NetConnection www.qwant.com -Port 443` (Windows).
  - `curl -I https://www.qwant.com` (Linux).
- Vérifier que seuls les ports 80/443 sortants sont ouverts.

---

## 🔒 Tests sécurité (DMZ & WAN)
### Publication Web

- Depuis une VM externe (bridgée) :
  - `curl -I http://<IP_WAN>` → redirection vers HTTPS.
  - `curl -I https://<IP_WAN>` → réponse SRV-WEB (WordPress).

### Restriction services

- `nmap -p- <IP_WAN>` → seuls ports 80 et 443 doivent apparaître ouverts.
- Tentative d’accès au port 53 (DNS) depuis WAN → **refusé**.
- Tentative d’accès RDP/SSH depuis WAN → **refusé**.

---

## 🖥️ Tests clients → serveurs

- `dir \\SRV-FILES\COMMUN` (Windows) → accès partage SMB.
- `smbclient -L //SRV-FILES -U user` (Linux) → listage partages.
- `mstsc /v:SRV-RDS` → connexion bureau à distance.
- `Test-NetConnection SRV-ERP -Port 443` → accès ERP via HTTPS.
- `Test-NetConnection SRV-WSUS -Port 8530` → vérification WSUS.
- `mysql -h SRV-DB -u test -p` (depuis SRV-WEB) → accès BDD WordPress.

---

## 📊 Tests supervision & exploitation

- `systemctl status zabbix-agent2` sur un serveur Linux → agent actif.
- `Get-Service "Zabbix Agent 2"` sur un serveur Windows → agent actif.
- Vérification interface Zabbix : hôtes → état **vert**.
- Connexion GLPI : https://srv-glpi.stage.eni → login avec utilisateur AD.
- Vérification FAQ utilisateur → affichage OK.

---

## 🕒 Tests NTP

- `w32tm /query /status` (Windows) → source = DC.
- `timedatectl status` (Linux) → synchro NTP active.

---

## 📌 Checklist finale

- [ ] Clients → Internet OK.
- [ ] Résolution DNS interne + externe OK.
- [ ] Accès ERP en HTTPS OK.
- [ ] Accès Web DMZ depuis WAN OK.
- [ ] Accès SMB/DFS depuis clients OK.
- [ ] Accès RDS depuis clients OK.
- [ ] Mises à jour WSUS OK.
- [ ] Supervision Zabbix OK.
- [ ] GLPI accessible + FAQ disponible.
- [ ] Accès bloqué par défaut depuis WAN (hors 80/443).
- [ ] NTP synchronisé pour Kerberos.

---

## 🔎 Bonnes pratiques de validation
- Automatiser une partie des tests via **scripts PowerShell/Bash**.
- Conserver des **captures d’écran** (Wireshark, Zabbix, GLPI) pour preuve documentaire.
- Centraliser résultats dans **GLPI → base de connaissances** (section FAQ technique).
