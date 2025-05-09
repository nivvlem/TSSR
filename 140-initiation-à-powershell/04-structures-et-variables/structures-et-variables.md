# Les structures et variables

## 💡 Les variables PowerShell

### Déclaration

```powershell
$nom = "Saya"
$age = 30
$service = Get-Service -Name Spooler
```

- Le type est implicite selon la valeur (String, Int, Object…)
- Utiliser `$maVariable.GetType()` pour connaître le type

### Variables système utiles

- `$PSItem`, `$PROFILE`, `$env:`

### Saisie utilisateur et affichage

```powershell
$choix = Read-Host "Votre choix"
Write-Host "Vous avez choisi : $choix"
```

---

## 🔢 Types de variables

### String

```powershell
$a = "abc"
$b = "def"
$c = $a + $b  # abcdef
```

### Int

```powershell
$a = 1
$b = 2
$c = $a + $b  # 3
```

### Array (tableau à taille fixe)

```powershell
$array = "PC1", "PC2", "PC3"
$array[1]  # PC2
```

### ArrayList (tableau à taille dynamique)

```powershell
[System.Collections.ArrayList]$machines = "PC1", "PC2"
$machines.Add("PC3")
$machines.Remove("PC2")
```

---

## 🧠 Objet dans une variable

```powershell
$user = Get-ADUser -Filter *
$user[0].Name
$user[0].Enabled
```

- Propriétés via `.`
- Méthodes :

```powershell
(Get-Date).ToString("yyyyMMdd")
```

---

## 📐 Structures conditionnelles

### `If`, `Else`, `ElseIf`

```powershell
If ($x -eq 1) {
 Write-Host "Vrai"
} ElseIf ($x -eq 2) {
 Write-Host "Deux"
} Else {
 Write-Host "Faux"
}
```

### Imbrication possible (If + Switch + boucle…)

---

## 🔁 Structures de boucle

### `While`

```powershell
$x = "A"
While ($x -ne "q") {
 $x = Read-Host "Choix ?"
}
```

### `Do While` / `Do Until`

```powershell
Do {
 $x = Read-Host "Entrée"
} While ($x -ne "q")

Do {
 $x = Read-Host "Entrée"
} Until ($x -eq "q")
```

---

## 🔄 Boucle `ForEach`

### Sur tableau

```powershell
$array = "PC1", "PC2", "PC3"
ForEach ($item in $array) {
 Write-Host $item
}
```

### Sur objets

```powershell
$users = Get-ADUser -Filter *
ForEach ($u in $users) {
 Write-Host $u.Name
}
```

- Actions : `break`, `continue`

---

## 🔁 Switch : alternative à `If` multiples

```powershell
Switch ($choix) {
 '1' { Write-Host "Un" }
 '2' { Write-Host "Deux" }
 default { Write-Host "Invalide" }
}
```

- Accepte les actions `Break` / `Continue`
- Peut utiliser `-Regex` pour tester des motifs

---

## 🧱 Imbrication des structures

```powershell
Do {
 If ($x -gt 10) {
   Switch ($x) {
     '11' { Write-Host "Onze" }
   }
 } Else {
   $x = Read-Host "Saisir > 10"
 }
} While ($x -lt 100)
```

---

## ✅ À retenir pour les révisions

- `$` : toutes les variables en PowerShell commencent par ce symbole
- Types : String, Int, Array, ArrayList, Object
- Structures classiques : `If`, `While`, `ForEach`, `Switch`, `Do-Until`, `Do-While`
- Les objets permettent d’accéder aux propriétés/méthodes via `.`

---

## 📌 Bonnes pratiques professionnelles

- Noms de variables clairs, cohérents avec le contenu
- Initialiser les variables avant les boucles conditionnelles
- Utiliser des structures simples, bien indentées
- Toujours tester les scripts dans un environnement isolé avant production

---

## 🔗 Commandes utiles

```powershell
$var.GetType()
[array]$arr = "A", "B"
[System.Collections.ArrayList]$list = "PC1", "PC2"
Switch ($input) { ... }
While (...) { ... }
ForEach (...) { ... }
```

