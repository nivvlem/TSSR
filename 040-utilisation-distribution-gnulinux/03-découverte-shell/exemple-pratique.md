# TP – Premières commandes sous GNU/Linux

## 🧩 Pré-requis

- Être connecté à une VM Linux via une console ou terminal SSH

---

## 🧱 Étapes détaillées

### 🔐 1. Changer son mot de passe

```bash
passwd
```

- Saisir l’ancien mot de passe
- Entrer un nouveau mot de passe (deux fois)
- Se déconnecter puis se reconnecter pour vérifier le changement

---

### 👥 2. Informations utilisateur et session

#### Depuis quand êtes-vous connecté ?

```bash
who am i
```

#### Quels sont les utilisateurs connectés ?

```bash
who
```

#### Temps d'inactivité des utilisateurs

```bash
who -uH
```

#### PID (n° de processus de votre session)

```bash
who -umH
```

#### UID, GID et groupes d'appartenance

```bash
id
```

---

### 🕒 3. Afficher heure et date

#### Heure uniquement

```bash
date +%R
```

#### Date au format « lundi 24 septembre 2009 »

```bash
date "+%A %d %B %Y"
```

---

### 📆 4. Affichage de calendriers

#### Calendrier de janvier 1900

```bash
cal 1 1900
```

#### Calendrier de toute l’année 1900

```bash
cal 1900
```

#### Janvier de l’année en cours (ex. 2025)

```bash
cal 1 2025
```

#### Septembre 1752 (cas particulier)

```bash
cal 9 1752
```

📌 Ce mois contient un saut de 11 jours (du 3 au 13) dû au passage du calendrier julien au calendrier grégorien.

---

## ✅ À retenir pour les révisions

- `who`, `id`, `passwd`, `date`, `cal` : commandes essentielles d'exploration du système
- La commande `passwd` permet à chaque utilisateur de modifier son propre mot de passe
- `cal 9 1752` illustre un événement historique important lié au calendrier

---

## 📌 Bonnes pratiques professionnelles

- Toujours tester les commandes sans option destructrice
- Ne jamais ignorer les erreurs de mot de passe (`passwd` peut échouer si le mot est trop faible)
- Prendre l’habitude de consulter l’aide intégrée des commandes : `man`, `--help`
- Utiliser les formats de date explicites pour éviter toute confusion
