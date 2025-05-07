# Démarrage d’une distribution Debian GNU/Linux

## ⚙️ Étapes de démarrage d’un système Debian

1. **BIOS/UEFI** → configuration matérielle
2. **MBR (Master Boot Record)** → lance le chargeur d’amorçage
3. **GRUB (GRand Unified Bootloader)**
    - `Stage 1` → dans le MBR (512 premiers octets du disque)
    - `Stage 1.5` → zone entre MBR et première partition
    - `Stage 2` → fichiers GRUB dans `/boot/grub/`
4. **Noyau Linux (vmlinuz)** → avec `initrd.img` pour matériel et options spécifiques
5. **SystemD (PID 1)** → gestionnaire de services, lancement parallèle des unités

---

## 🧰 GRUB – Configuration et gestion

### Fichiers importants

- `/boot/grub/grub.cfg` (ne pas modifier directement)
- `/etc/default/grub` (modifications recommandées)
- `/etc/grub.d/` (scripts générant la config)

### Commandes de régénération

```bash
sudo update-grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Modifier une entrée GRUB au démarrage

- Appuyer sur `e` → mode édition
- Modifier la ligne commençant par `linux`

```bash
linux /vmlinuz... root=/dev/... ro quiet
```

|Option|Rôle|
|---|---|
|`ro`|Monté en lecture seule (vérification FS)|
|`quiet`|Masque les messages systèmes|

---

## 🧩 SystemD – Gestionnaire de services

### Fonction

- Lance les services de manière **parallèle** selon leurs dépendances
- PID 1 : premier processus utilisateur

### 📁 Répertoire des unités

- `/lib/systemd/system/` → services, cibles, sockets...

### Cibles principales (targets)

|Cible|But|Équivalent SysV|
|---|---|---|
|`poweroff.target`|Arrêt système|0|
|`rescue.target`|Mode maintenance|1|
|`multi-user.target`|Mode multi-utilisateur (console)|3|
|`graphical.target`|Interface graphique|5|
|`reboot.target`|Redémarrage|6|

---

## 🔧 Commandes `systemctl`

### 🔎 Gestion des cibles

```bash
systemctl get-default               # cible par défaut
systemctl set-default multi-user.target
systemctl isolate rescue.target     # basculer vers une cible
```

### 🔎 Services (exemple : cron)

```bash
systemctl status cron.service       # état du service
systemctl start cron.service        # démarrage
systemctl stop cron.service         # arrêt
systemctl restart cron.service      # redémarrage
systemctl enable cron.service       # activer au démarrage
systemctl disable cron.service      # désactiver
```

### 🔎 Lister unités

```bash
systemctl list-units               # unités actives
systemctl list-units --all         # toutes unités
```

---

## 🔌 Commandes d’arrêt et redémarrage

### Arrêter ou redémarrer

```bash
shutdown -h now                    # arrêt immédiat
shutdown -h +10 "Message"         # arrêt dans 10 minutes
shutdown -r now                    # redémarrage immédiat
shutdown -r 16:30 "Redémarrage"
reboot                             # redémarrage immédiat
```

### Annuler un shutdown en attente

```bash
shutdown -c
```

---

## ✅ À retenir pour les révisions

- **GRUB** est responsable du lancement du noyau Linux
- Le **noyau** utilise `initrd.img` pour la compatibilité matérielle
- **SystemD** est un gestionnaire moderne de services basé sur des **cibles**
- `systemctl` centralise la gestion des services et du système
- `shutdown`, `reboot`, `systemctl isolate` permettent de gérer le cycle de vie système

---

## 📌 Bonnes pratiques professionnelles

- Ne jamais modifier directement `/boot/grub/grub.cfg`
- Toujours vérifier l’état d’un service après modification
- Créer des unités personnalisées dans `/etc/systemd/system/`
- Documenter les cibles utilisées dans des environnements multi-niveaux

---

## 🔗 Liens utiles

- [SystemD – freedesktop.org](https://www.freedesktop.org/wiki/Software/systemd/)
