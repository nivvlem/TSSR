# TP – Manipuler des objets PowerShell

## 📄 Énoncé synthétisé

> **Machine utilisée :** CLI01  

### Étapes principales :

- Manipulation des objets `Get-ADUser`, `Get-ChildItem`, `Get-EventLog`
- Utilisation de `Select-Object`, `Where-Object`, `Sort-Object`, `Measure-Object`
- Export CSV/HTML et mise en forme (`Format-Table`, `Format-List`)
- Regroupement (`GroupBy`) et propriétés calculées

---

## ✅ Résolution structurée

### 🔹 Affichage des utilisateurs avec propriétés spécifiques

```powershell
Get-ADUser -Filter * -Properties * |
Select-Object GivenName, Name, Enabled, Department, City
```

> Pour afficher toutes les propriétés : `-Properties *`

### 🔹 Les 5 premiers utilisateurs

```powershell
Get-ADUser -Filter * | Select-Object -First 5
```

### 🔹 Tri sur City puis Department

```powershell
Get-ADUser -Filter * -Properties * |
Select Name, Enabled, Department, City |
Sort-Object City, Department
```

### 🔹 Ajouter une condition : nom contenant "r"

```powershell
Get-ADUser -Filter * -Properties * |
Where-Object { $_.Name -match "r" } |
Select Name, Enabled, Department, City |
Sort-Object City, Department
```

### 🔹 BONUS : Désactiver les comptes commençant par "D"

```powershell
Get-ADUser -Filter 'Name -like "D*"' | Disable-ADAccount
```

---

### 🔹 Utilisateurs actifs dont le nom commence par A ou F

```powershell
Get-ADUser -Filter * |
Where-Object { $_.Enabled -eq $true -and $_.Name -match "^[AF]" } |
Select Name, Enabled
```

### 🔹 Comptage utilisateurs actifs/inactifs

```powershell
Get-ADUser -Filter * | Where Enabled -eq $true | Measure-Object
Get-ADUser -Filter * | Where Enabled -eq $false | Measure-Object
```

---

## 🔹 Manipulation des fichiers réseau

### Tous les fichiers du partage :

```powershell
Get-ChildItem \\CD01\Partage -File -Recurse
```

### Taille moyenne, min, max :

```powershell
Get-ChildItem \\CD01\Partage -File -Recurse | Measure-Object -Property Length -Average
Get-ChildItem \\CD01\Partage -File -Recurse | Measure-Object -Property Length -Minimum -Maximum
```

### Fichiers de taille entre 10 Mo et 100 Mo + tri :

```powershell
Get-ChildItem \\CD01\Partage -File -Recurse |
Where-Object { $_.Length -gt 10MB -and $_.Length -lt 100MB } |
Select Name, Length, Mode |
Sort-Object Name -Descending
```

---

## 🔹 Mise en forme

### Liste des utilisateurs sur 5 colonnes :

```powershell
Get-ADUser -Filter * | Format-Wide -Column 5
```

### Format tableau avec filtrage :

```powershell
Get-ADUser -Filter * -Properties * |
Where Enabled -eq $true |
Format-Table Name, Enabled, Department, City
```

### Groupes AD avec regroupement par type :

```powershell
Get-ADGroup -Filter * -Properties * |
Format-Table Name, Description, Created -GroupBy GroupScope
```

### Ordinateurs AD groupés par OS :

```powershell
Get-ADComputer -Filter * -Properties * |
Format-List Name, DnsHostName, DistinguishedName, IPv4Address -GroupBy OperatingSystem
```

---

## 🔹 Journaux d’événement

### Affichage complet

```powershell
Get-EventLog System | Format-List TimeWritten, Index, Message
```

---

## 🔹 Export CSV, HTML, fusion, et importation

### Export utilisateurs en CSV + HTML

```powershell
Get-ADUser -Filter * | Export-Csv \\CD01\Partage\Exports\CSV\Users.csv -Delimiter ';' -NoTypeInformation
Get-ADUser -Filter * -Properties * | ConvertTo-Html | Out-File \\CD01\Partage\Exports\CSV\Users.html
```

### Ajout des ordinateurs au CSV :

```powershell
Get-ADComputer -Filter * | Export-Csv \\CD01\Partage\Exports\CSV\Users.csv -Append -Delimiter ';' -Force
```

### Import avec renommage de colonne :

```powershell
Import-Csv \\CD01\Partage\Exports\CSV\Users.csv -Delimiter ';' |
Select @{Name="Name"; Expression={$_.Nom}} | New-ADUser
```

### Alternative avec propriété calculée (sans modifier le CSV) :

```powershell
Import-Csv \\CD01\Partage\Exports\CSV\Users.csv -Delimiter ';' |
Select @{n="Name";e={$_.Nom}} | New-ADUser
```

---

## ✅ À retenir pour les révisions

- Utilise `Select`, `Where`, `Sort`, `Measure`, `Export`, `Format`, `ConvertTo-*`
- Chaine les cmdlets avec `|` pour manipuler les objets de bout en bout
- Utilise des **propriétés calculées** pour adapter l’affichage ou l’import/export
- `Export-Csv` écrase le fichier → utiliser `-Append` pour conserver les données

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Tester les filtres avant les actions|Pour éviter de désactiver ou supprimer par erreur|
|Utiliser `Measure-Object`|Pour valider les résultats de filtrage|
|Ne pas mélanger Format-* avec Export-*|Format-* génère du texte, Export-* attend des objets|
|Traduire les propriétés via `@{}`|Utile pour normaliser les exports/imports|
|Sauvegarder les exports dans des noms datés|Traçabilité des actions d’administration|
