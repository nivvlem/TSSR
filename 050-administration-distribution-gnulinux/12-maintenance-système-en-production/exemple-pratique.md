# TP – Maintenance d’un système en production 
# 🧱 TP1 – Gestion de la journalisation

## 🔍 Rechercher des ouvertures de session

```bash
grep 'opened' /var/log/auth.log | grep -v CRON > /adm/sessions.txt
```

## 🔎 Trouver les infos sur `/dev/sda`

```bash
journalctl | grep sda
# ou plus ciblé
journalctl --dmesg | grep sda
```

## ⚙️ Configurer `rsyslog` pour :

- activer la journalisation de `cron`
- écrire `/adm/logs/cron.log` et `/adm/logs/warnings.log`

Fichier : `/etc/rsyslog.conf`

```ini
cron.*    /adm/logs/cron.log
*.warn    /adm/logs/warnings.log
```

Créer les répertoires :

```bash
mkdir -p /adm/logs
systemctl restart rsyslog
```

## 🧪 Générer des logs de test

```bash
logger -p cron.warning "Test CRON WARNING"
logger -p daemon.info "Test DAEMON INFO"
```

Vérifier :

```bash
cat /adm/logs/cron.log
cat /adm/logs/warnings.log
```

---

# 🧱 TP2 – Planification des tâches

## 👤 Tâches crontab utilisateur François

### Archive tous les jours ouvrables à 9h15

```cron
15 9 * * 1-5 tar -uf /srv/depot/francois.tar /home/francois
```

### Compression tous les samedis à 10h

```cron
0 10 * * 6 bzip2 -kf /srv/depot/francois.tar
```

Éditer avec :

```bash
crontab -e -u francois
```

## 🖥️ Tâche crontab système (surveillance process)

Fichier : `/etc/crontab`

```cron
*/30 * * * 2 root date >> /var/log/procstatus.log && ps faux >> /var/log/procstatus.log
```

---

# 🧱 TP3 – Informations système et processus

## 📊 Informations mémoire

```bash
free -h
```

- RAM utilisée, swap utilisée, RAM libre réelle = `free + buffers/cache`

## 🔎 Informations CPU et mémoire

```bash
lscpu
lsmem -a
```

## 🔍 Daemon en cours d'exécution

```bash
ps -ef | grep -E 'd |d$' | grep -v grep
```

Nombre :

```bash
... | wc -l
```

## 🖥️ Intervention utilisateur sur Putty

### Lister les processus de l’utilisateur

```bash
ps -fux
```

### Lister les connexions Putty

```bash
ps -ef | grep putty > ~/putty_procs.txt
```

### Stopper un shell ouvert depuis une autre session

```bash
# Identifier le PID via ps\kill <PID>        # signal par défaut (TERM)
kill -1 <PID>      # signal SIGHUP pour forcer la fermeture
```

---

## ✅ À retenir pour les révisions

- `journalctl`, `logger`, `rsyslog`, `crontab`, `ps`, `kill`, `free`, `lscpu` sont essentiels
- `crontab -e -u user` permet de gérer les tâches utilisateur
- `/etc/crontab` permet de planifier des tâches système avec utilisateur défini
- La journalisation personnalisée est puissante et flexible

---

## 📌 Bonnes pratiques professionnelles

- Tester les expressions cron avant mise en production
- Utiliser `logger` pour tester la configuration syslog
- Éviter de tuer un processus sans savoir ce qu’il fait (préférer TERM à KILL)
- Archiver les logs critiques séparément et en rotation via `logrotate`

---

## 🔗 Commandes utiles

```bash
journalctl, systemctl, logger, rsyslog.conf
crontab, /etc/crontab
ps, top, htop, kill, free, lscpu, lsmem
```

## Ressources complémentaires

- [Debian Logging](https://wiki.debian.org/Logging)