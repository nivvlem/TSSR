# TP – Manipuler des objets PowerShell

## 📄 Énoncé du TP

Ce TP permet de manipuler les objets retournés par PowerShell, notamment des services et des utilisateurs locaux. Il s’appuie sur la console de la machine virtuelle `CLI01`.

### Étapes principales :

- Utiliser `Get-Member` pour explorer un objet
- Identifier les propriétés et méthodes d’un objet
- Lire et modifier des propriétés
- Exécuter une méthode

---

## ✅ Résolution structurée

### 🔹 1. Explorer un objet

```powershell
Get-Service | Get-Member
```

> Cette commande retourne les membres de type `System.ServiceProcess.ServiceController`

**Exemples de propriétés `String` :**

- `DisplayName`
- `ServiceName`

**Méthodes :**

- `Equals()` → type Bool
- `GetHashCode()` → type Int

### 🔹 2. Explorer un service spécifique

```powershell
Get-Service -Name Spooler | Get-Member -MemberType Property
Get-Service -Name Spooler
```

**Propriétés affichées par défaut :** `Status`, `Name`, `DisplayName`

### 🔹 3. Travailler avec un utilisateur local

```powershell
Get-LocalUser -Name "Adara Mcintyre"
```

**Propriétés utiles :** `Name`, `Enabled`, `Description`

#### Modifier la description :

```powershell
Set-LocalUser -Name "Adara Mcintyre" -Description "Administrateur"
Get-LocalUser -Name "Adara Mcintyre"
```

---

### 🔹 4. Utiliser une méthode : arrêter un service

```powershell
(Get-Service -Name Spooler).Stop()
Get-Service -Name Spooler
```

> Appelle directement la **méthode `Stop()`** de l’objet `ServiceController`

---

### 🔹 Bonus : Modifier une propriété avec une méthode objet

#### Définir une date d’expiration de compte dans 48h :

```powershell
New-LocalUser "Axel Rios" -AccountExpires (Get-Date).AddDays(2) 
Get-LocalUser -Name "Axel Rios" | Select *
```

> `AddDays(2)` est une **méthode** de l’objet `System.DateTime` retourné par `Get-Date`

---

## 🧠 À retenir pour les révisions

- Les objets PowerShell sont inspectables avec `Get-Member`
- `Get-Member` donne le **type**, les **propriétés** et les **méthodes** de l’objet
- Les propriétés se lisent comme `.NomPropriété`, les méthodes s’utilisent comme `.NomMéthode()`
- `Set-*` permet de modifier les propriétés système (ex : `Set-LocalUser`)
- On peut chaîner : `(Get-Service).Stop()`

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Utiliser `Get-Member` pour tout objet|Pour découvrir toutes les capacités disponibles|
|Ne pas modifier les propriétés critiques sans test|Évite les erreurs système|
|Préférer les méthodes aux scripts complexes|Plus fiable et explicite|
|Utiliser des objets jusqu’au bout|Permet d’enchaîner proprement les actions dans les scripts|
