# 🐧 CLIENT-ROCKY — Intégration au domaine (Kerberos, SSSD, CIFS/DFS, SELinux, supervision)

- **Hôte** : CLIENT-ROCKY — **OS** : Rocky Linux 10 (Workstation)
- **IP** : `192.168.52.11/23` — **Passerelle** : `192.168.52.254` — **DNS** : `192.168.55.20` / `192.168.55.21`
- **Domaine** : `stage.eni` — **REALM** : `STAGE.ENI`
- **OU cible** : `_POSTESCLIENTS` (Linux)
- **Services visés** : DFS/Samba (sec=krb5), ERP (HTTPS), GLPI, RDS, DNS/NTP
- **Publication externe** : aucune (usage interne LAN Clients)

---

## 0) Pré‑requis

- Compte **admin domaine** : `stage\\Administrateur` (ou compte délégué).
- **Paquets** (root) :

```bash
dnf -y install realmd sssd sssd-tools adcli oddjob oddjob-mkhomedir \
               krb5-workstation samba-common samba-common-tools cifs-utils \
               policycoreutils-python-utils authselect chrony
```

- **DNS** du poste → DCs (`192.168.55.20` / `192.168.55.21`).
- **Temps** synchronisé (Kerberos intolérant au décalage > 5 min).

---

## 1) Vérifications réseau & DNS

```bash
ip a             # IP / masque (/23)
ip r             # Route par défaut -> 192.168.52.254
ping -c 4 192.168.55.20  # DC1
ping -c 4 192.168.55.21  # DC2

# Résolution DNS interne
resolvectl status | sed -n '1,80p'
host srv-dc1.stage.eni
host erp.stage.eni
```

---

## 2) Configuration Kerberos (/etc/krb5.conf)

**Version complète utilisée dans le projet** :

```ini
[libdefaults]
  default_realm = STAGE.ENI
  dns_lookup_realm = false
  dns_lookup_kdc   = false
  rdns = false
  dns_canonicalize_hostname = false
  ticket_lifetime = 24h
  renew_lifetime  = 7d
  forwardable = true
  proxiable   = true
  default_ccache_name = KEYRING:persistent:%{uid}

[realms]
  STAGE.ENI = {
    kdc = srv-dc1.stage.eni
    kdc = srv-dc2.stage.eni
    admin_server = srv-dc1.stage.eni
  }

[domain_realm]
  .stage.eni = STAGE.ENI
  stage.eni  = STAGE.ENI
```

**Tests Kerberos** :

```bash
kinit Administrateur@STAGE.ENI
klist    # TGT présent (24h)
```

---

## 3) Intégration au domaine (realmd + authselect)

### Détection & jonction

```bash
realm discover stage.eni
realm join -U Administrateur stage.eni
```

> Saisir le mot de passe admin domaine.

### Sélection du profil d’authentification (PAM/SSSD)

```bash
authselect select sssd with-mkhomedir --force
systemctl enable --now sssd oddjobd chronyd
```

### Vérifications

```bash
realm list
id administrateur@stage.eni
getent passwd administrateur@stage.eni
```

---

## 4) Configuration SSSD (/etc/sssd/sssd.conf)

**Fichier complet validé (droits 600)** :

```ini
[sssd]
services = nss, pam, sudo, ssh
config_file_version = 2

domains = stage.eni

[domain/stage.eni]
ad_domain = stage.eni
krb5_realm = STAGE.ENI
realmd_tags = manages-system joined-with-adcli

id_provider = ad
auth_provider = ad
access_provider = ad
sudo_provider = ad

use_fully_qualified_names = False
ldap_id_mapping = True
cache_credentials = True
fallback_homedir = /home/%u
override_homedir  = /home/%u
default_shell     = /bin/bash

krb5_renew_interval = 3600
krb5_store_password_if_offline = True

ad_gpo_access_control = permissive

dyndns_update = False
```

Application :

```bash
chmod 600 /etc/sssd/sssd.conf && chown root:root /etc/sssd/sssd.conf
systemctl restart sssd && systemctl status sssd --no-pager
```

### Test connexion

```bash
su - utilisateur@stage.eni
pwd     # /home/utilisateur (créé, via with-mkhomedir)
exit
```

---

## 5) Montage CIFS/DFS avec Kerberos

### Paquets & clés

```bash
dnf -y install keyutils cifs-utils
klist        # s’assurer d’avoir un TGT actif
```

### Test de listing avec smbclient

```bash
smbclient -L //SRV-FILES -k   # -k = Kerberos
```

### Montage ponctuel (sec=krb5)

```bash
mkdir -p /mnt/dfs
mount -t cifs //SRV-FILES/COMMUN /mnt/dfs -o sec=krb5,cruid=$(id -u),multiuser
ls /mnt/dfs
```

> `cruid` : utilise le ticket Kerberos de l’utilisateur courant.

### Fstab (montage auto pour tous)

> **Optionnel en maquette** (sinon préférer un **script login**/autofs) :

```bash
echo "//SRV-FILES/COMMUN  /mnt/dfs  cifs  sec=krb5,multiuser,cruid=1000,_netdev  0  0" >> /etc/fstab
systemctl daemon-reload && mount -a
```

### SELinux (contexte CIFS)

```bash
# Autoriser les montages CIFS côté client si nécessaire
setsebool -P virt_use_samba 1 || true   # (utile sur certains environnements virtualisés)
```

---

## 6) Accès applicatifs (ERP / GLPI / RDS)

```bash
# ERP / GLPI (PKI interne) :
curl -I https://erp.stage.eni
curl -I https://srv-glpi.stage.eni

# RDP (client FreeRDP ou Remmina)
dnf -y install freerdp
xfreerdp /v:SRV-RDS /u:utilisateur /d:STAGE
```

---

## 7) Supervision & sauvegarde (poste Rocky)

### Zabbix Agent 2 (si suivi des postes)

```bash
# Exemple générique (adapter selon dépôt disponible pour Rocky 10)
# 1) Installer le repo Zabbix adapté, puis :
dnf -y install zabbix-agent2
systemctl enable --now zabbix-agent2

# 2) Config minimale
sed -i 's/^Server=.*/Server=192.168.55.29/' /etc/zabbix/zabbix_agent2.conf
sed -i 's/^ServerActive=.*/ServerActive=192.168.55.29/' /etc/zabbix/zabbix_agent2.conf
echo "Hostname=CLIENT-ROCKY" >> /etc/zabbix/zabbix_agent2.conf
systemctl restart zabbix-agent2
```

### Sauvegarde profils (rsync → SRV-FILES)

```bash
mkdir -p /mnt/backups
mount -t cifs //SRV-FILES/backups /mnt/backups -o sec=krb5,cruid=$(id -u),multiuser
cat >/usr/local/bin/backup_home.sh <<'END'
#!/usr/bin/env bash
set -euo pipefail
DATE=$(date +%F)
RSRC=/home/
RDST=/mnt/backups/CLIENT-ROCKY/${DATE}/
mkdir -p "$RDST"
rsync -avh --delete "$RSRC" "$RDST"
END
chmod +x /usr/local/bin/backup_home.sh

# Cron quotidien 22:00
(crontab -l 2>/dev/null; echo "0 22 * * * /usr/local/bin/backup_home.sh") | crontab -
```

---

## 8) Intégration matrice de flux

- Client Rocky → **DCs (55.20/55.21)** : 53/UDP,TCP ; 88/UDP,TCP ; 389/TCP ; 445/TCP ; 135/TCP + RPC dyn. ; 3268/TCP.
- Client Rocky → **SRV-FILES/DFS** : 445/TCP.
- Client Rocky → **SRV-ERP** : 443/TCP.
- Client Rocky → **SRV-RDS** : 3389/TCP.
- Client Rocky → **SRV-GLPI** : 80/443/TCP.
- Client Rocky → **SRV-ZABBIX** : 10050/TCP (agent) si installé.

---

## 9) Validation — commandes clés

```bash
# Kerberos
klist

# Domaine / identités
realm list
id utilisateur@stage.eni
getent passwd utilisateur@stage.eni

# CIFS/DFS
smbclient -L //SRV-FILES -k
mount | grep -i cifs

# Accès applicatifs
curl -I https://erp.stage.eni
xfreerdp /v:SRV-RDS /u:utilisateur /d:STAGE +fonts /cert:ignore

# Zabbix (si agent)
systemctl status zabbix-agent2 --no-pager
```

---

## ✅ Checklist

-  DNS du poste → **55.20/55.21** ; ping/résolution OK.
-  **krb5.conf** appliqué, `kinit`/`klist` OK.
-  Poste **joint** à `stage.eni` ; `realm list` OK.
-  **SSSD** actif ; `id utilisateur@stage.eni` retourne UID/GID.
-  Montage **CIFS** `sec=krb5` opérationnel (/mnt/dfs).
-  Accès **ERP/GLPI/RDS** OK.
-  (Option) **Zabbix agent2** en service.
-  Cron **sauvegarde** daily vers `\\SRV-FILES\backups`.

---

## 🧠 Justifications & bonnes pratiques

- **DNS AD only** : indispensable pour Kerberos/LDAP & découverte AD.
- **authselect with‑mkhomedir** : provisionne les HOME à la 1re connexion (propre et réversible).
- **SSSD provider = ad** + `ldap_id_mapping` : évite le schéma étendu, simplifie UID/GID.
- **sec=krb5** sur CIFS : SSO sécurisé sans stocker de mot de passe ; `multiuser` permet plusieurs UID.
- **SELinux** : conserver _enforcing_ ; n’ouvrir que les booléens nécessaires.
- **Supervision** des postes (option) : utile au capacity planning (CPU/RAM/disque) et au dépannage.

---

## 🔗 Références

- Red Hat — _Integrating Linux with Active Directory (SSSD/realmd)_
- Rocky — _authselect_ & _SSSD_ (man pages : `man authselect`, `man sssd-ad`)
- Samba — _Mounting SMB shares with Kerberos (sec=krb5)_
- FreeRDP — _xfreerdp usage_
- Zabbix — _Agent 2 for RPM-based systems_