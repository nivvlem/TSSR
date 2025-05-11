# Mise en situation professionnelle : Systèmes clients

## Synthèse

## 🛠️ Commandes utiles à retenir

### 🪟 Windows 10 (CMD / PowerShell)

```powershell
net user <utilisateur> <mdp> /add /time:M-F,09:00-12:00
New-LocalGroup / Add-LocalGroupMember / net localgroup
Set-NetFirewallProfile -Enabled True
Start-Process "7z.exe" -ArgumentList "/S"
xcopy / robocopy / net share / schtasks
```

### 🐧 Debian 10 (Bash)

```bash
fdisk / mkfs.ext4 / mkfs.xfs / mount /etc/fstab
useradd / passwd / chage / groupadd / chmod / chown
pvcreate / vgcreate / lvcreate / mkfs /etc/fstab
rsync / tar / scp / crontab -e
apt install remmina webmin cifs-utils openssh-server
```

---

## 🧠 Bonnes pratiques à appliquer

- Toujours appliquer une **convention de nommage homogène** : VMs (`W10-MD`, `DEB10-MD`), utilisateurs (`rgrimes`), groupes (`GG_Comptabilité`)
- Ne jamais modifier /home sans en avoir **sauvegardé** le contenu (`rsync` vers la nouvelle cible)
- Ajouter systématiquement les montages au fichier `/etc/fstab` sous Debian
- Activer les **pare-feux sur les deux systèmes**, tous profils compris
- Planifier ses sauvegardes à des horaires différents pour éviter la charge simultanée
- Utiliser des **scripts réutilisables** (.sh, .bat, .ps1) et bien les commenter
- Prévoir des snapshots VMware aux jalons importants : post-installation, post-GPO, post-sauvegarde, etc.
- Tester **chaque étape sur les deux systèmes**, y compris les connexions croisées (RDP/Remmina, SSH)

---

## ⚠️ Pièges courants à éviter

- Ne pas ajouter de point de montage dans `/etc/fstab` → perte au redémarrage
- Supprimer /home sans migration → perte des comptes utilisateurs
- Échec de `cron` à cause de chemins relatifs ou permissions insuffisantes
- Ne pas tester le port 3389 → impossible pour le binôme de se connecter
- Absence de clé SSH pour `scp` → empêche la duplication automatisée
- Installer `rdesktop` incompatible NLA → échec connexion RDP
- Oublier le SGID (`chmod g+s`) sur `/services/*` → perte d’héritage du groupe

---

## 📦 Scripts recommandés

### Sauvegarde `tar` planifiée (Debian)

```bash
#!/bin/bash
DATE=$(date +%F)
tar -czf /var/backups/home_$DATE.tar.gz /home
```

### Duplication distante (Debian)

```bash
scp /var/backups/*.tar.gz md@10.107.200.84:/home/backup-md/
```

### Script de sauvegarde planifiée Windows (xcopy)

```bat
@echo off
xcopy D:\Support_Info \\W10-Binome\Support_Info$\Sauvegarde_MD /E /I /Y
```

### Script PowerShell de mappage lecteur réseau

```powershell
New-PSDrive -Name "U" -PSProvider FileSystem -Root "\\W10-MD\Support_Info$" -Persist
```

---

## ✅ Récapitulatif des points techniques clés

|Système|Tâche clé|Outils / Méthode utilisés|
|---|---|---|
|Windows|Création comptes et groupes|net user, PowerShell, GPO locales|
|Debian|Redéfinition de /home|rsync + fstab + LABEL|
|Windows|Partitionnement disque D:|DISKPART|
|Debian|Partage /services + droits|mkdir, chmod 770, SGID|
|Windows|Partage Support_Info$|Partage masqué, droits filtrés|
|Debian|LVM `/opt` + `/var/log`|pvcreate + mount + fstab|
|Windows|Image système + points de restauration|Sauvegarder et restaurer (Windows 7)|
|Debian|Remmina RDP + Webmin|apt install remmina/webmin, tests binôme|
|Linux → Win|`scp`, `cron`, duplication|scp automatisé + clé SSH|
