# Manipulation des objets

## 🔗 Le pipeline PowerShell (`|`)

- Permet de **chaîner les commandes** : l’objet généré devient l’entrée de la commande suivante

```powershell
Get-Service | Get-Member
```

- Utilise la variable spéciale `$PSItem` (ou `$_` raccourci) dans les filtres

```powershell
Get-Process | Where { $_.Id -gt 1500 }
```

---

## 🎯 Cmdlets de manipulation

### 🔹 `Select-Object`

- Sélectionne des **propriétés spécifiques** d’un objet

```powershell
Get-Service | Select-Object -Property Name, Status
```

- Paramètres utiles :
    - `-First`, `-Last`, `-Unique`, `-ExpandProperty`

### 🔹 `Sort-Object`

- Trie les objets selon une propriété

```powershell
Get-Process | Sort-Object -Property Id -Descending
```

### 🔹 `Measure-Object`

- Calcule **le nombre**, la **somme**, la **moyenne**, le **min**, le **max**

```powershell
Get-Process | Measure-Object
Get-ChildItem -File | Measure-Object -Property Length -Average
```

### 🔹 `Where-Object`

- Filtre les objets selon une condition sur leurs propriétés

```powershell
Get-Service | Where-Object { $_.Status -eq "Running" }
Get-Process | Where { $_.Name -like "Power*" -or $_.Id -lt 5000 }
```

> ⚠️ Opérateurs sensibles à la casse : `-eq`/`-ceq`, `-like`/`-clike`, etc.

---

## 📦 Mise en forme et export

### 🔹 `Format-Table`

- Présentation **tabulaire** : colonnes personnalisables, regroupement, en-têtes masqués

```powershell
Get-Service | Format-Table Name, Status
```

### 🔹 `Format-Wide`

- Affiche une seule propriété, répartie sur plusieurs colonnes

```powershell
Get-Service | Format-Wide -Column 3
```

### 🔹 `Format-List`

- Présente **chaque propriété sur une ligne** (affichage vertical)

```powershell
Get-Process | Format-List Name, Id
```

### 🔹 `Export-Csv`

- Exporte des objets PowerShell vers un fichier CSV

```powershell
Get-Process | Export-Csv C:\temp\process.csv -NoTypeInformation -Delimiter ";"
```

### 🔹 `ConvertTo-Html` / `ConvertTo-Json`

- Conversion au format HTML/JSON, à coupler avec `Out-File`

```powershell
Get-Service | ConvertTo-Html | Out-File C:\temp\services.html
```

---

## 🔄 Gestion des fichiers : lecture et écriture

### 🔹 `Out-File`

- Écrit les résultats dans un fichier

```powershell
Get-Service | Out-File C:\temp\services.txt
```

- Options : `-Append`, `-Width`

### 🔹 `Get-Content`

- Lit un fichier ligne par ligne

```powershell
Get-Content C:\temp\services.txt
Get-Content C:\temp\services.txt -Tail 5
```

### 🔹 `Import-Csv`

- Transforme un fichier CSV en **objet PowerShell**

```powershell
Import-Csv C:\users.csv -Delimiter ";" | New-Object
```

> ⚠️ Les noms de colonnes doivent **correspondre aux propriétés attendues**

---

## 🧮 Propriétés calculées

- Permet de **créer ou renommer dynamiquement** une propriété à l’affichage

```powershell
Get-ChildItem -File | Select Name, @{Name='Taille (Mo)'; Expression={ '{0:N2}' -f ($_.Length / 1MB) }}
```

- Autre exemple avec plusieurs propriétés :

```powershell
Get-Volume | Select DriveLetter,
@{n='Taille (GB)'; e={ '{0:N2}' -f ($_.Size / 1GB) }},
@{n='Espace Libre (GB)'; e={ '{0:N2}' -f ($_.SizeRemaining / 1GB) }}
```

---

## ✅ À retenir pour les révisions

- Le **pipeline `|`** est central pour manipuler les objets en série
- `Select`, `Where`, `Sort`, `Measure`, `Format`, `Export`, `Convert` → commandes essentielles
- PowerShell permet une **présentation soignée** et une **exportation efficace** des données
- Les **propriétés calculées** enrichissent dynamiquement l’information à afficher ou exporter

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Utiliser `Select` tôt dans la chaîne|Limite la charge mémoire et améliore les performances|
|Chainer avec `|` jusqu’au format final|
|Toujours vérifier les formats d’export|Évite les erreurs de compatibilité lors des imports|
|Documenter les propriétés calculées|Facilite la relecture des scripts complexes|
|Ne pas mélanger formatage (`Format-*`) et export (`Export-*`)|Les `Format-*` produisent du texte, pas des objets exploitables|
