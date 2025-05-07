# TP – Debian en mode maintenance (Module 04)

# 🧱 Partie 1 – Maintenance via GRUB (sans mot de passe root)

### 🧭 Étapes à suivre :

1. Redémarrer et appuyer sur `e` dans GRUB
2. Modifier la ligne du noyau :

```bash
quiet ➜ init=/bin/bash
```

3. Valider avec `F10` ou `Ctrl+X`
4. Remonter le système de fichiers en lecture/écriture :

```bash
mount -o remount,rw /
```

### 🧪 Vérifications

- Créer un fichier dans `/root` :

```bash
touch /root/test.txt
```

✔️ Fichier créé → accès OK

- Accéder à `/home/utilisateur` :

```bash
cd /home/<utilisateur>  # échoue car /home sur LVM séparé
```

❌ Accès impossible → normal, car seul `/` est monté par défaut

- Finaliser la session :

```bash
sync
# Puis extinction matérielle via l’interface de la VM
```

---

# 🧱 Partie 2 – Maintenance via ISO Debian (Rescue Mode)

### 🧭 Étapes à suivre :

1. Vérifier que l’image ISO est connectée au démarrage
2. Au démarrage VMware, appuyer sur `Échap`, puis démarrer sur le CD
3. Choisir : `Advanced options` → `Rescue mode`
4. Suivre l’assistant :
    - Langue
    - Clavier
    - Nom de machine
    - Volume racine à monter (ex: `VROOT`)
5. Un shell root s’ouvre **sans mot de passe**

### 🧪 Vérifications

- Lire `/etc/passwd`

```bash
cat /etc/passwd
```

- Modifier le fichier :

```bash
vi /etc/passwd
# Ajouter une ligne fictive, enregistrer (:w), puis supprimer avec 'dd', enregistrer et quitter (:wq)
```

✔️ Modification possible

- Vérifier l’utilisateur courant :

```bash
echo $USER   # ➜ root
```

- Aucun mot de passe n’a été requis pour cette session.

---

## ✅ À retenir pour les révisions

- `init=/bin/bash` permet d’entrer en maintenance sans authentification (mais accès limité)
- `/home` sur LVM peut ne pas être monté automatiquement
- En mode Rescue via ISO, un shell root est fourni sans mot de passe, utile pour réparer ou éditer
- Clavier QWERTY par défaut en GRUB

---

## 📌 Bonnes pratiques professionnelles

- Ne jamais quitter un mode maintenance sans `sync`
- Documenter toute modification manuelle (notamment sur `/etc/passwd`)
- Utiliser des noms explicites pour les volumes et groupes LVM
- Ne pas abuser du mode maintenance pour des modifications non urgentes

---

## 🔗 Commandes utiles

```bash
mount -o remount,rw /
cat /etc/passwd
vi /etc/passwd
sync
```

## Ressources complémentaires

- [Debian Rescue Wiki](https://wiki.debian.org/Rescue)