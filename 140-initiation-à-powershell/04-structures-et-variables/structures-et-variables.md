# Les structures et variables

## 💡 Les variables PowerShell

### Déclaration de base :

```powershell
$nom = "Alphonse"
$nombre = 42
```

### Obtenir le type :

```powershell
$nom.GetType().FullName
```

### Saisie utilisateur :

```powershell
$choix = Read-Host "Entrez votre choix"
```

### Affichage dans une chaîne :

```powershell
Write-Host "Votre choix est $choix"
```

### Variables contenant des objets :

```powershell
$services = Get-Service
$services[0].DisplayName
```

### Méthodes applicables :

```powershell
$date = (Get-Date).ToString("yyyyMMdd")
$date.GetType()
```

---

## 📋 Types de variables

|Type|Description|Exemple|
|---|---|---|
|`String`|Texte entre guillemets|`$s = "Bonjour"`|
|`Int`|Entier numérique|`$a = 2; $b = 3; $c = $a + $b`|
|`Array`|Tableau à taille fixe|`$array = "a","b","c"`|
|`ArrayList`|Tableau dynamique (ajout/suppression possible)|`[System.Collections.ArrayList]$list = "PC1","PC2"`|

### Ajout et suppression avec ArrayList :

```powershell
$list.Add("PC3")
$list.Remove("PC1")
```

---

## 🧠 Structures conditionnelles : If / ElseIf / Else

```powershell
if ($x -eq 10) {
    Write-Host "x vaut 10"
} elseif ($x -lt 10) {
    Write-Host "x est inférieur à 10"
} else {
    Write-Host "x est supérieur à 10"
}
```

> 💡 Résultat toujours booléen (`$true` ou `$false`)

---

## 🔁 Boucles

### `While` – test en entrée :

```powershell
$x = ""
while ($x -ne "q") {
    $x = Read-Host "Taper q pour quitter"
}
```

### `Do-While` – test en sortie :

```powershell
do {
    $x = Read-Host "Choix ?"
} while ($x -ne "q")
```

### `Do-Until` – boucle jusqu’à vraie condition :

```powershell
do {
    $x = Read-Host "Choix ?"
} until ($x -eq "q")
```

### `Foreach` – parcours de tableaux :

```powershell
$array = "PC1","PC2","PC3"
foreach ($machine in $array) {
    Write-Host "Machine : $machine"
}
```

> `Break` pour sortir de la boucle, `Continue` pour passer à l’itération suivante

---

## 🔀 Structure `Switch`

Permet de traiter plusieurs cas en fonction de la valeur d’une variable :

```powershell
switch ($choix) {
    '1' { Write-Host "Sauvegarde" }
    '2' { Write-Host "Restauration" }
    default { Write-Host "Choix invalide" }
}
```

> Peut aussi être utilisé avec `-Regex` pour des cas avancés

---

## 🧱 Imbrication de structures

Il est possible de **combiner plusieurs structures** pour créer des logiques plus complexes :

```powershell
do {
    if ($x -gt 10) {
        switch ($x) {
            '11' { Write-Host "Valeur 11" }
            '12' { Write-Host "Valeur 12" }
        }
    } else {
        $x = Read-Host "Saisir une valeur > 10"
    }
} while ($x -lt 100)
```

---

## ✅ À retenir pour les révisions

- Toutes les variables commencent par `$`
- `ArrayList` est préférable à `Array` quand on veut ajouter/retirer dynamiquement
- `If`, `While`, `Switch`, `Foreach` sont les structures de base d’un script PowerShell
- Une boucle doit toujours **avoir une condition claire** pour ne pas être infinie
- Imbriquer les structures permet de créer des **menus interactifs puissants**

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Nommer les variables explicitement|Facilite la compréhension et la maintenance|
|Initialiser les variables avant usage|Évite les erreurs de comparaison ou les boucles bloquées|
|Utiliser `ArrayList` pour la souplesse|Plus simple à manipuler dans les boucles|
|Préférer `Switch` à plusieurs `If`|Plus lisible pour gérer des cas multiples|
|Ajouter des commentaires clairs|Indique la logique derrière les choix ou conditions|
