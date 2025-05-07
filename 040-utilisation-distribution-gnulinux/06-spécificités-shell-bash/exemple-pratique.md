# TP – Recherches et expressions régulières

## 🧱 Étapes détaillées

### 🔍 1. Rechercher toutes les lignes contenant « Dupont » dans le fichier `Edition`

```bash
grep Dupont Edition
```

### 🔍 2. Même recherche, mais insensible à la casse

```bash
grep -i dupont Edition
```

### 🔎 3. Afficher uniquement les lignes **non vides** du fichier `Edition`

```bash
grep -v '^$' Edition
```

### 🗂️ 4. Rechercher les fichiers dans `/etc` (sans descente récursive) contenant « localhost »

```bash
grep -sl localhost /etc/*
```

### 📁 5. Rechercher tous les fichiers standards (type `-f`) dans `/etc` commençant par `ho`

```bash
find /etc -type f -name "ho*"
```

### 🏠 6. Rechercher tous les **répertoires** dans le dossier personnel

```bash
find ~ -type d
```

### 💾 7. Rechercher tous les fichiers `.txt` dans le dossier personnel et créer une copie `.save`

```bash
find ~ -type f -name "*.txt" -exec cp {} {}.save \;
```

---

## ✅ À retenir pour les révisions

- `grep motif fichier` pour les recherches textuelles simples
- `grep -i`, `grep -v`, `grep -n` enrichissent la recherche
- `find` permet de filtrer sur type, nom, taille, date…
- `-exec` automatise une commande sur chaque résultat
- `'^$'` est une regex pour détecter les lignes vides

---

## 📌 Bonnes pratiques professionnelles

- Toujours tester les regex avec `grep` avant de les intégrer dans un script
- Utiliser `-exec` avec précaution (préférer `-print` pour debug)
- Ajouter des guillemets autour des motifs de `find` pour éviter les expansions indésirables
- Sauvegarder les résultats avant traitement si les actions sont destructrices
