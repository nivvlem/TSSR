# 🧮Les unités informatiques

## 🔢 Principes de numération

### Bases numériques utilisées

|Base|Système|Valeurs possibles|
|---|---|---|
|2|Binaire|0, 1|
|8|Octal|0 à 7|
|10|Décimal|0 à 9|
|16|Hexadécimal|0 à 9 + A à F|

### Rappels sur le binaire

- Un **bit** : plus petite unité (0 ou 1)
- Un **octet** : 8 bits
- Un ensemble de bits peut représenter **n’importe quelle valeur**, selon la base choisie

---

## 🔄 Conversions entre bases

### 🧪 Méthodes de conversion (démonstration Packet Tracer)

#### Décimal → Binaire

- **Méthode soustractive** : soustraire des puissances de 2 jusqu'à 0
- **Méthode divisionnaire** : diviser par 2 jusqu'à 0 et lire les restes à l'envers

#### Binaire → Décimal

- Multiplier chaque bit par sa puissance de 2 (de droite à gauche) et additionner

#### Décimal → Octal / Hexadécimal

- Convertir en binaire puis regrouper :
    - par **3 bits** pour l’octal
    - par **4 bits** pour l’hexadécimal

#### Hexadécimal ↔ Binaire

- Chaque chiffre hexadécimal = 4 bits (ex : A = 1010)

#### Hexadécimal → Décimal

- Passer par le binaire ou convertir chaque chiffre par puissance de 16

### 🧠 Astuce

- Retenir les puissances de 2 jusqu’à 2¹⁰ (1, 2, 4, 8… 1024)

---

## 📏 Unités informatiques

### Bit et Octet

- 1 octet = **8 bits**
- Bit (symbole : **b**) / Octet (symbole : **o** ou **B**)

### Préfixes décimaux (base 10 – standard international)

|Nom|Symbole|Valeur|
|---|---|---|
|kilooctet|ko|10³ = 1 000 o|
|mégaoctet|Mo|10⁶ = 1 000 ko|
|gigaoctet|Go|10⁹ = 1 000 Mo|
|téraoctet|To|10¹² = 1 000 Go|

### Préfixes binaires (base 2 – usage informatique)

|Nom|Symbole|Valeur|
|---|---|---|
|kibioctet|Kio|2¹⁰ = 1 024 o|
|mébioctet|Mio|2²⁰ = 1 024 Kio|
|gibioctet|Gio|2³⁰ = 1 024 Mio|
|tébioctet|Tio|2⁴⁰ = 1 024 Gio|

### Préfixes pour les **bits**

|Nom|Symbole|Valeur (bits)|
|---|---|---|
|kibibit|Kibit|1 024 bits|
|mébibit|Mibit|1 048 576 bits|
|gibibit|Gibit|1 073 741 824 bits|

### Exemples d’équivalence

|Unité de base|Équivalents (approx.)|
|---|---|
|1 Ko|0.976 Kio ou 8 kb|
|1 Go|953 Mio ou 7.45 Gibit|
|1 To|931 Gio ou 7 275 Mibit|

---

## 🧠 Conseils pour les conversions

- Toujours **passer par le binaire** pour aller d'une base à une autre
- Respecter les **groupes de 3 bits (octal)** ou **4 bits (hexadécimal)**
- Ne pas confondre **Go** (octet) avec **Gb** (bit)
- Attention : **1 Ko ≠ 1 Kio** (1000 o ≠ 1024 o)

---

## 📘 À retenir pour les révisions

- Maîtriser les **4 bases** : 2, 8, 10, 16
- Savoir convertir **dans les deux sens** (ex : (122)₁₀ ↔ (01111010)₂)
- Connaître la **correspondance des préfixes** décimaux / binaires
- Retenir que :
    - 1 octet = 8 bits
    - 1 Ko = 1000 o / 1 Kio = 1024 o

## 🧑‍💼 Bonnes pratiques professionnelles

- Utiliser les **préfixes binaires (Kio, Mio…)** pour les données techniques
- Toujours **préciser l’unité (bit ou octet)** dans les documents
- Vérifier si l’outil logiciel ou matériel compte en **base 10 ou 2** (important pour stockage, RAM…)
- Ne jamais mélanger **bits et octets** sans conversion claire (1 byte ≠ 1 bit)
