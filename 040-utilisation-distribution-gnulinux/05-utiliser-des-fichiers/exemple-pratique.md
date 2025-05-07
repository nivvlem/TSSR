# TP 1 – Lire des fichiers sous Linux

## 🧱 Étapes détaillées

### ✍️ 1. Créer un fichier texte via `cat`

```bash
cat > MonDeuxiemeFichier
Conseil :
pour bien utiliser la ligne de commande
faire des étirements de doigts avant chaque repas.
# Finir avec Ctrl + D
```

### ✍️ 2. Créer un second fichier avec un autre contenu

```bash
cat > MonTroisiemeFichier
Ne pas oublier de lire au moins 4 pages de man
avant d'aller se coucher
# Ctrl + D pour enregistrer
```

### 📎 3. Concaténer les deux fichiers

```bash
cat MonDeuxiemeFichier MonTroisiemeFichier > fichier2+3
```

### 👥 4. Compter le nombre d’utilisateurs du système

```bash
wc -l /etc/passwd
```

Chaque ligne représente un compte utilisateur.

### 📄 5. Afficher les 2 premières lignes de `/etc/hosts`

```bash
head -n 2 /etc/hosts
```

---

## ✅ À retenir pour les révisions

- `cat > fichier` permet de créer un fichier avec saisie directe
- `wc -l fichier` compte les lignes (utile pour /etc/passwd)
- `head -n N fichier` affiche les N premières lignes

---

## 📌 Bonnes pratiques professionnelles

- Utiliser `cat` uniquement pour des petits fichiers texte
- Préférer `nano`, `vim`, ou `echo` pour éditer ou insérer rapidement du contenu
- S’assurer que les fichiers concaténés sont dans l’ordre attendu
- Toujours vérifier avec `cat` ou `less` le contenu final

---

# TP 2 – Gérer les liens sous Linux

## 🧱 Étapes détaillées

### 🔗 1. Créer un lien physique de `Edition` vers `edition1.txt`

```bash
ln Edition edition1.txt
cat edition1.txt  # Vérification
```

### 🔗 2. Créer un lien symbolique vers `/tmp/stagxx/edition2.txt`

```bash
mkdir -p /tmp/stagxx
ln -s $HOME/edition1.txt /tmp/stagxx/edition2.txt
cat /tmp/stagxx/edition2.txt
```

### 🔗 3. Créer un lien physique `edition3.txt` depuis `edition1.txt`

```bash
ln edition1.txt edition3.txt
cat edition3.txt
```

### 🔍 4. Afficher les caractéristiques des fichiers

```bash
ls -li edition* Edition /tmp/stagxx/edition2.txt
```

- Vérifier les inodes : identiques pour les liens physiques, différents pour les symbolique

### ❌ 5. Supprimer `edition1.txt` et tester les accès

```bash
rm edition1.txt
cat /tmp/stagxx/edition2.txt  # ❌ lien cassé
cat edition3.txt              # ✅ toujours accessible
```

---

## ✅ À retenir pour les révisions

- Les liens **physiques** partagent le même inode
- Les liens **symboliques** pointent vers un chemin
- Supprimer la **source** d’un lien symbolique le rend **invalide**
- Les liens physiques continuent d'exister tant qu’un lien subsiste

---

## 📌 Bonnes pratiques professionnelles

- Préférer les liens symboliques pour les scripts ou raccourcis visibles
- Utiliser les liens physiques uniquement dans la même partition pour fiabilité
- Toujours nommer les liens de manière explicite (éviter les confusions)
- Utiliser `ls -li` pour vérifier la nature réelle d’un lien
