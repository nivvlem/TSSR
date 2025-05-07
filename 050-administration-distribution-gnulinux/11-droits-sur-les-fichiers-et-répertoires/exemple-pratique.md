# TP – Gestion des permissions 
## 📁 Création de la structure dans `/srv`

```bash
mkdir -p /srv/public /srv/depot /srv/admin /srv/documentation
```

---

## 📂 Public – accessible en lecture/écriture pour tous

```bash
chmod 777 /srv/public
```

---

## 📂 Dépôt – lecture/écriture pour tous, mais suppression uniquement par l’auteur

```bash
chmod 1777 /srv/depot  # 1 = Sticky Bit
```

---

## 📂 Admin – lecture/écriture uniquement pour le groupe `admin`

```bash
chgrp admin /srv/admin
chmod 770 /srv/admin
```

---

## 📂 Documentation – lecture pour tous, lecture/écriture pour le groupe `documentation`

```bash
chgrp documentation /srv/documentation
chmod 2754 /srv/documentation  # 2 = SetGID + droits rwxr-xr--
```

> Le **SetGID** sur le répertoire garantit que tout fichier créé hérite du groupe `documentation`

---

## 🧪 Vérifications conseillées

### Créer des fichiers avec différents comptes

```bash
su - francois     # utilisateur membre d’admin
su - fred         # utilisateur classique
su - doc_user     # utilisateur membre de documentation
```

### Vérifier la propriété des fichiers créés

```bash
ls -l /srv/*
```

### Tester la suppression dans `/srv/depot` par un autre utilisateur (doit échouer)

---

## ✅ À retenir pour les révisions

- `chmod 1777` permet de protéger les fichiers d’un répertoire partagé (Sticky Bit)
- `chmod 275X` applique SetGID sur un dossier : héritage du groupe
- Le FHS recommande l’usage de `/srv` pour les fichiers liés aux services
- `chgrp` + `chmod` sont essentiels pour appliquer des politiques de groupe

---

## 📌 Bonnes pratiques professionnelles

- Toujours tester les droits en conditions réelles (autres utilisateurs)
- Ne pas mettre 777 par défaut sauf cas très particulier (ex : `/srv/public`)
- Documenter la structure de stockage et les droits appliqués pour les équipes
- Utiliser des noms de groupe explicites : `admin`, `documentation`, etc.

---

## 🔗 Commandes utiles

```bash
mkdir -p /srv/{public,depot,admin,documentation}
chmod 777 /srv/public
chmod 1777 /srv/depot
chgrp admin /srv/admin && chmod 770 /srv/admin
chgrp documentation /srv/documentation && chmod 2754 /srv/documentation
ls -l /srv/
su - utilisateur_test
```

## Ressources complémentaires

- [Debian File Permissions](https://wiki.debian.org/FilePermissions)