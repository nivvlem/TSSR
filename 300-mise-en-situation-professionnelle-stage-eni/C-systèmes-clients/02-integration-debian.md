
# 🐧 CLIENT-DEBIAN — Intégration au domaine (Kerberos, SSSD, services, supervision)

- **Hôte** : CLIENT-DEBIAN — **OS** : Debian 12 — **IP** : `192.168.52.12/23` — **Passerelle** : `192.168.52.254` — **DNS** : `192.168.55.20` / `192.168.55.21`
- **Domaine** : `stage.eni` — **REALM** Kerberos : `STAGE.ENI`
- **OU cible** : `_POSTESCLIENTS` (Linux) ; GPO/paramètres AD appliqués via Kerberos/SSSD.
- **Services visés** : DFS/Samba (via Kerberos), GLPI, ERP (HTTPS), RDS, DNS/NTP.
- **Publication externe** : aucune (usage interne LAN Clients).

---

## 0) Pré-requis

- **Debian 12** installé, paquetages et kernel à jour :

```bash
apt update && apt upgrade -y
```

- Paquets nécessaires :

```bash
apt install -y realmd sssd sssd-tools adcli samba-common-bin oddjob oddjob-mkhomedir packagekit libnss-sss libpam-sss krb5-user
```

- DNS configurés vers DCs (`192.168.55.20` / `192.168.55.21`).
- Heure synchronisée via NTP :

```bash
apt install -y chrony
systemctl enable --now chrony
chronyc sources -v
```

- Compte admin domaine : `stage\\Administrateur`.

---

## 1) Vérification réseau & DNS

```bash
ip a       # Vérifier IP et masque (/23)
ip r       # Vérifier passerelle 192.168.52.254
ping -c 4 192.168.55.20   # Test DC1
ping -c 4 192.168.55.21   # Test DC2

# Résolution DNS interne
resolvectl status
host srv-dc1.stage.eni
host erp.stage.eni
```

---

## 2) Configuration Kerberos (/etc/krb5.conf)

**Configuration complète validée pour le projet** (AD = SRV-DC1/SRV-DC2, domaine = stage.eni) :

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
  # Stockage du ticket côté utilisateur (Debian 12)
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

> **Pourquoi ces choix ?**
> 
> - `dns_lookup_* = false` : on **force** l’utilisation des DC connus (plus prévisible en labo).
> - `rdns = false` : évite les inversions PTR qui cassent parfois l’obtention de tickets.
> - `default_ccache_name` : stockage moderne des TGT dans le **keyring** utilisateur.

**Tests immédiats** :

```bash
kinit Administrateur@STAGE.ENI
klist    # TGT présent, validité 24h
```

---

## 3) Intégration domaine (realmd + SSSD)

### Détection domaine

```bash
realm discover stage.eni
```

### Joindre le domaine

```bash
realm join -U Administrateur stage.eni
```

Saisir mot de passe admin domaine.

### Vérification

```bash
realm list
id administrateur@stage.eni
getent passwd utilisateur@stage.eni
```

> Attendu : mapping correct des comptes AD.

---

## 4) Configuration SSSD (/etc/sssd/sssd.conf)

**Fichier complet (droits 600, propriétaire root:root)** :

```ini
[sssd]
services = nss, pam, sudo, ssh
config_file_version = 2
# Nom du/ des domaines gérés par SSSD
domains = stage.eni

[domain/stage.eni]
# Cœur de l’intégration AD
ad_domain = stage.eni
krb5_realm = STAGE.ENI
realmd_tags = manages-system joined-with-adcli

# Providers
id_provider = ad
auth_provider = ad
access_provider = ad
sudo_provider = ad

# Résolution identités & login
use_fully_qualified_names = False   # permet "utilisateur" au lieu de "utilisateur@stage.eni"
ldap_id_mapping = True              # mappage UID/GID auto (pas de schéma étendu)
cache_credentials = True

# Comptes / Shell / Répertoire perso
fallback_homedir = /home/%u
override_homedir = /home/%u
default_shell = /bin/bash

# Kerberos
krb5_renew_interval = 3600
krb5_store_password_if_offline = True

# GPO/contrôle d’accès (permissif pour la maquette)
ad_gpo_access_control = permissive

# DynDNS (non utilisé ici)
dyndns_update = False
```

Appliquer et vérifier :

```bash
chmod 600 /etc/sssd/sssd.conf && chown root:root /etc/sssd/sssd.conf
systemctl restart sssd
systemctl status sssd --no-pager
```

### PAM : création auto du HOME (Debian)

> Avec realmd, l’empilement PAM est déjà ajusté. Si besoin, ajouter manuellement :

```bash
echo 'session required pam_mkhomedir.so skel=/etc/skel umask=0077' | sudo tee -a /etc/pam.d/common-session > /dev/null
```

**Vérification login domaine** :

```bash
# Ouvrir une session shell pour un compte AD (ex. utilisateur)
su - utilisateur@stage.eni
pwd   # /home/utilisateur (créé automatiquement)
```

---

## 5) Authentification & création profil

- PAM configuré automatiquement par realmd.
- Test connexion utilisateur domaine :

```bash
su - utilisateur@stage.eni
pwd   # home créé automatiquement (/home/utilisateur@stage.eni)
```

---

## 6) Accès aux services

### Samba/DFS (SRV-FILES)

```bash
smbclient -L //SRV-FILES -U utilisateur@stage.eni
mount -t cifs //SRV-FILES/COMMUN /mnt/dfs -o username=utilisateur@stage.eni,domain=STAGE,sec=krb5
```

### ERP / GLPI / RDS

```bash
curl -I https://erp.stage.eni
curl -I https://srv-glpi.stage.eni
# RDP client :
sudo apt install -y remmina
remmina -c rdp://utilisateur@SRV-RDS
```

---

## 7) Supervision & sauvegarde

- **Supervision** : installation agent Zabbix :

```bash
wget https://repo.zabbix.com/zabbix/7.4/debian/pool/main/z/zabbix-release/zabbix-release_7.4-1+debian12_all.deb
dpkg -i zabbix-release_7.4-1+debian12_all.deb
apt update
apt install -y zabbix-agent2
systemctl enable --now zabbix-agent2
```

Configurer `/etc/zabbix/zabbix_agent2.conf` :

```
Server=192.168.55.29
ServerActive=192.168.55.29
Hostname=CLIENT-DEBIAN
```

Redémarrage :

```bash
systemctl restart zabbix-agent2
```

- **Sauvegarde** : script `rsync` vers `\\SRV-FILES\\backups` via tâche cron.

```bash
0 22 * * * rsync -avh --delete /home/ /mnt/dfs/backups/CLIENT-DEBIAN/
```

---

## 8) Intégration matrice de flux

- Client Debian → DCs : DNS (53), Kerberos (88), LDAP (389), RPC (135), SMB (445), GC (3268).
- Client Debian → SRV-FILES : 445.
- Client Debian → SRV-ERP : 443.
- Client Debian → SRV-RDS : 3389.
- Client Debian → SRV-GLPI : 80/443.
- Client Debian → SRV-ZABBIX : 10050 (agent).

---

## 9) Validation — commandes clés

```bash
realm list
klist
id utilisateur@stage.eni
getent passwd utilisateur@stage.eni
smbclient -L //SRV-FILES -U utilisateur@stage.eni
curl -I https://erp.stage.eni
systemctl status sssd
systemctl status zabbix-agent2
```

---

## ✅ Checklist

-  IP/DNS configurés correctement.
-  Résolution DNS interne/externe OK.
-  Ticket Kerberos valide (`klist`).
-  Poste joint au domaine (`realm list`).
-  Authentification domaine fonctionnelle.
-  Montage Samba/DFS OK.
-  Accès ERP/GLPI/RDS OK.
-  Agent Zabbix joignable.
-  Cron sauvegarde actif.

---

## 🧠 Justifications & bonnes pratiques

- **DNS AD** : obligatoire pour Kerberos/SSSD.
- **Kerberos + SSSD** : assure SSO et gestion centralisée des identités.
- **LDAP id_mapping** : simplifie les UID/GID sans schéma AD personnalisé.
- **Automatisation via cron + rsync** : fiabilise sauvegardes utilisateurs.
- **Supervision Zabbix** : cohérence de suivi Linux/Windows.

---

## 🔗 Références

- Debian Wiki — [SSSD and Active Directory](https://wiki.debian.org/SSSD)
- Red Hat — [Integrating Linux systems with Active Directory](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html-single/integrating_rhel_systems_directly_with_windows_active_directory/index)
