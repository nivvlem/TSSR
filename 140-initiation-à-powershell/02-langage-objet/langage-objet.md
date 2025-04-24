# PowerShell : Langage Objet

## 🧠 PowerShell, un langage orienté objet

- Contrairement à Bash ou CMD, **PowerShell manipule des objets** (et non du texte brut).
- Chaque objet est composé de **propriétés** (informations) et de **méthodes** (actions).

### Exemple simple :

```powershell
Get-Service -Name "WSearch"
```

> Cela retourne un **objet de type `System.ServiceProcess.ServiceController`**, avec des propriétés comme `Status`, `DisplayName`, `CanStop`, etc.

---

## 🔍 Explorer un objet avec `Get-Member`

- Permet de voir :
    - Le **type d’objet**
    - Les **propriétés** disponibles (membres statiques)
    - Les **méthodes** disponibles (actions)

```powershell
Get-Service | Get-Member
```

### Les 3 commandes clés PowerShell :

```powershell
Get-Command
Get-Help
Get-Member
```

> Indispensables pour découvrir et comprendre une Cmdlet ou un objet.

---

## 🧾 Propriétés d’un objet

|Type|Description|
|---|---|
|`String`|Texte entre guillemets|
|`Int`|Entier (positif ou négatif)|
|`Boolean`|`$true`, `$false`, `$null`|
|`Array`|Tableau d’éléments indexés|
|`Object`|Un objet complet (imbriqué)|

### Exemple de lecture et modification :

```powershell
(Get-Service -Name "WSearch").DisplayName

Set-Service -Name "WSearch" -DisplayName "Recherche Windows"
```

> ⚠️ Pour modifier une propriété, utiliser une Cmdlet adaptée comme `Set-*`, pas d’affectation directe !

---

## 🔄 Méthodes : effectuer des actions sur un objet

- Contrairement aux propriétés (valeurs), les **méthodes** effectuent des actions.
- Syntaxe : `(<objet>).<Méthode>(paramètre)`

### Exemple : manipuler une date

```powershell
(Get-Date).AddDays(1)   # Ajoute un jour à la date actuelle
```

### Exemple : contrôler un service

```powershell
$svc = Get-Service -Name "WSearch"
$svc.Stop()    # Appelle la méthode Stop
$svc.Start()   # Appelle la méthode Start
```

> 🧠 Les méthodes dépendent du type d’objet. Utilise `Get-Member` pour les découvrir !

---

## ✅ À retenir pour les révisions

- PowerShell retourne et manipule des **objets** (et pas du texte brut).
- Un objet a :
    - Des **propriétés** (statut, nom, etc.)
    - Des **méthodes** (Start, Stop, AddDays…)
- Utilise `Get-Member` pour découvrir les capacités d’un objet
- Utilise `Set-*` pour modifier des propriétés système
- La syntaxe `(<objet>).<méthode>(valeur)` est essentielle

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Toujours tester avec `Get-Member`|Pour connaître toutes les possibilités d’un objet|
|Ne pas essayer de modifier directement une propriété système|Utiliser la Cmdlet prévue (`Set-*`)|
|Utiliser les méthodes pour des actions précises|Plus propre et plus explicite que des scripts manuels|
|Explorer les objets renvoyés par les Cmdlets `Get-*`|Approche pédagogique et robuste de l'administration|
|Rester en mode objet jusqu'à la sortie finale|Pour enchaîner proprement les Cmdlets et éviter les erreurs|
