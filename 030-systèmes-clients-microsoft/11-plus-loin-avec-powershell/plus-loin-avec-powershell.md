# Plus loin avec PowerShell

## 🔁 Redirection de flux

### 🔹 Les trois flux standards

|Flux|Description|Numéro|Par défaut|
|---|---|---|---|
|Entrée standard|Ce que reçoit une commande|0|Clavier|
|Sortie standard|Résultat des commandes|1|Écran|
|Sortie d’erreur|Messages d’erreur|2|Écran|

### 🔹 Redirection de la sortie

```powershell
Get-LocalUser > C:\temp\LocalUserList.txt
Get-LocalUser 1> C:\temp\LocalUserList.txt       # Équivalent
Get-LocalUser >> C:\temp\LocalUserList.txt       # Ajout à la fin du fichier
```

### 🔹 Redirection des erreurs

```powershell
Get-LocalUser 2> C:\temp\erreurs.txt             # Erreurs uniquement
Get-LocalUser 2>> C:\temp\erreurs.txt            # Ajout des erreurs
```

### 🔹 Redirection combinée

```powershell
Get-LocalUser > C:\temp\tout.txt 2>&1             # Résultats + erreurs
Get-LocalUser 2>$null                             # Supprimer les erreurs
```

### 🔹 Lecture du fichier généré

```powershell
Get-Content C:\temp\LocalUserList.txt
```

---

## 📦 Utilisation du pipeline

### 🔹 Principe

- Permet de chaîner des cmdlets
- Envoie le résultat d'une cmdlet vers une autre via `|`

### 🔹 Exemple simple

```powershell
Get-NetAdapter | Select Name, Status, LinkSpeed
```

### 🔹 Représentation schématique

```
cmdlet1 | cmdlet2 | cmdlet3
```

- `stdout` de la première devient `stdin` de la suivante

---

## 🔎 Filtrage des résultats

### 🔹 Comparateurs (insensibles à la casse par défaut)

|Type|Insensible|Sensible à la casse|
|---|---|---|
|Égal|-eq|-ceq|
|Différent|-ne|-cne|
|Supérieur|-gt|-cgt|
|Supérieur ou égal|-ge|-cge|
|Inférieur|-lt|-clt|
|Inf. ou égal|-le|-cle|
|Comme|-like|-clike|
|Non comme|-notlike|-cnotlike|

### 🔹 Filtrage simple

```powershell
Get-NetAdapter | Where-Object Status -like "Up"
```

### 🔹 Filtrage avancé

```powershell
Get-NetAdapter | Where-Object { $_.Status -like "Up" -and $_.LinkSpeed -gt 100Mbps }
```

> `$_` ou `$PSItem` représente l’objet actuel du pipeline

---

## 🧾 Formatage des résultats

### 🔹 Cmdlets de formatage

|Cmdlet|Utilisation|
|---|---|
|Format-List|Affichage ligne par ligne|
|Format-Table|Affichage en tableau|
|Format-Wide|Une propriété sur plusieurs colonnes|

> 🔧 À utiliser **en toute fin de pipeline**, car ils arrêtent la transmission des données.

### 🔹 Exemples

```powershell
Get-Service | Format-List
Get-Service | Format-List -Property *
Get-Service | Format-List -Property Name, Status

Get-TimeZone | Format-Table -Property StandardName, BaseUtcOffset -AutoSize

Get-Process | Format-Wide -Property ID -Column 5
```

---

## ✅ À retenir pour les révisions

- Les flux peuvent être redirigés avec `>`, `>>`, `2>`, `2>&1`, etc.
- Le pipeline `|` enchaîne des cmdlets (sortie → entrée)
- `Where-Object` est essentiel pour filtrer des objets
- `Select-Object` permet de choisir les propriétés visibles
- Les cmdlets `Format-*` modifient l'affichage final des résultats

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Utiliser le pipeline pour éviter les variables temporaires|Code plus lisible et performant|
|Filtrer en amont les jeux de données|Évite de traiter trop d’informations inutiles|
|Ne pas abuser des cmdlets Format-* trop tôt|Empêche la réutilisation des objets dans le pipeline|
|Documenter ses scripts avec commentaires|Facilite le transfert et la relecture|
|Rediriger les erreurs lors d’automatisation|Aide au débogage et au suivi en production|
