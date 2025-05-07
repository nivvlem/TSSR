# Debian en mode maintenance

## 🛠️ Quand utiliser le mode maintenance ?

- Perte du mot de passe root
- Blocage au démarrage suite à une mise à jour
- Récupération de fichiers
- Réparation de volumes logiques ou d’erreurs système

---

## 🧩 Méthode 1 – Démarrage en mode maintenance **avec mot de passe root** via GRUB

### 🔧 Étapes :

1. Redémarrer et **interrompre GRUB** (touche `e` sur l'entrée du noyau)
2. Modifier la ligne du noyau pour y ajouter à la fin :

```bash
single
```

Exemple complet :

```bash
linux /vmlinuz-... root=/dev/mapper/... ro single
```

3. Valider avec `[Ctrl + X]` ou `[F10]`
4. Saisir le **mot de passe root**
5. Une fois la maintenance terminée :

```bash
Ctrl + D  # pour reprendre l’amorçage normal
```

📌 Clavier en QWERTY (en-US) : attention à la saisie du mot de passe

---

## 🧩 Méthode 2 – Maintenance **sans mot de passe root** via GRUB

### 🔧 Étapes :

1. Accéder au menu GRUB (`e` sur l'entrée du noyau)
2. Modifier la ligne du noyau pour :

```bash
init=/bin/bash
```

Exemple :

```bash
linux /vmlinuz-... root=/dev/mapper/... ro init=/bin/bash
```

3. Valider `[Ctrl + X]` ou `[F10]`
4. Remonter `/` en lecture-écriture :

```bash
mount -o remount,rw /
```

5. Exécuter les actions nécessaires (modification de mot de passe, nettoyage, etc.)
6. Synchroniser les écritures disque :

```bash
sync
```

7. ⚠️ Éteindre manuellement l’ordinateur (pas de redémarrage propre possible)

---

## 💿 Méthode 3 – Démarrage en maintenance via CD d’installation Debian

### Avantages :

- Accès à un environnement Linux complet
- Interface parfois en français
- Pas besoin du mot de passe root
- Possibilité d'éteindre proprement

### Inconvénients :

- Support physique (ou image ISO) requis
- Parfois moins intuitif sous virtualisation

---

## ✅ À retenir pour les révisions

- `single` : active le mode maintenance **avec authentification root**
- `init=/bin/bash` : mode maintenance **sans authentification**, mais accès limité
- Le système est en lecture seule par défaut → penser à `mount -o remount,rw /`
- Utiliser `sync` avant de forcer une extinction en mode GRUB/Bash

---

## 📌 Bonnes pratiques professionnelles

- Tester ces procédures sur VM avant de les pratiquer en environnement réel
- Toujours **documenter les interventions de maintenance**
- S’assurer que les utilisateurs connaissent le mode `Ctrl + D` pour relancer un boot
- Prévoir un accès ISO/CD pour le dépannage sur serveur distant

---

## 🔗 Liens utiles

- [GRUB manual (GNU)](https://www.gnu.org/software/grub/manual/grub/grub.html)