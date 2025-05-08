# 📘 Synthèse – Initiation à PowerShell

## 🧱 Principes fondamentaux

### ✅ À connaître absolument

- PowerShell repose sur la **manipulation d’objets** (et non de texte brut comme Bash).
- Les commandes sont des **Cmdlets** au format `Verbe-Nom` (ex. : `Get-Process`).
- L’outil est **cross-platform** depuis PowerShell Core (PS 7+).
- Tout est extensible via **modules**, exécuté dans un **profil** personnalisé.

---

## 📚 Structure de la syntaxe PowerShell

### Cmdlets & aide intégrée

```powershell
Get-Command
Get-Help Get-Process -Full
Update-Help
```

### Pipeline & transformation des objets

```powershell
Get-Service | Where-Object {$_.Status -eq "Running"} | Sort-Object Name
```

### Gestion des erreurs

```powershell
Try { ... } Catch { ... } Finally { ... }
```

### Variables & structures

```powershell
$nom = "Utilisateur"
$liste = @("item1", "item2")
If ($liste.Count -gt 0) { ... }
```

---

## ⚙️ Manipulation d’objets

### Propriétés & méthodes

```powershell
(Get-Process).Name
(Get-Date).AddDays(3)
```

### Cmdlets de traitement

```powershell
Select-Object, Sort-Object, Measure-Object, Format-Table, Format-List
```

### Propriétés calculées

```powershell
Select-Object Name, @{Name="RAM";Expression={[math]::Round($_.WS/1MB,2)}}
```

---

## 🧠 Scripts et fonctions

### Structure type

```powershell
Function Nom {
  Param([string]$param1)
  Try { ... } Catch { ... }
}
```

### Exécution sécurisée

```powershell
Set-ExecutionPolicy RemoteSigned
```

### Personnalisation

```powershell
notepad $PROFILE
```

---

## 🌐 Remoting & administration distante

### Authentification sécurisée

```powershell
$cred = Get-Credential
```

### Exécution distante

```powershell
Invoke-Command -ComputerName SRV01 -Credential $cred -ScriptBlock { Get-Service }
```

### Sessions persistantes

```powershell
$session = New-PSSession -ComputerName DC01
Invoke-Command -Session $session -ScriptBlock { ... }
Remove-PSSession $session
```

---

## 🖧 Scripts avancés (TPs)

### Configuration réseau (ex. DHCP vs statique)

```powershell
New-NetIPAddress, Set-DnsClientServerAddress, Set-NetIPInterface
```

### Menu AD interactif

```powershell
Do { ... Switch ($choix) { ... } } While ($choix -ne "Quitter")
```

---

## ✅ À retenir pour les révisions

- PowerShell est un shell **orienté objet**, sécurisé, scriptable, et puissant.
- Les **fonctions**, **structures conditionnelles**, et **menu interactif** permettent une vraie automatisation.
- Le **remoting** permet l'administration multi-serveur centralisée.
- L’aide intégrée (`Get-Help`) est complète et à jour grâce à `Update-Help`.

## 📌 Bonnes pratiques professionnelles

- Toujours commenter les scripts (`#`, `<#...#>`), même pour usage personnel.
- Ne jamais écrire de mots de passe en clair (utiliser `Get-Credential`).
- Centraliser les tâches répétitives dans des **fonctions**.
- Capturer les erreurs (`Try/Catch`, `-ErrorAction`, `$ErrorVariable`).
- Utiliser `Export-Csv`, `ConvertTo-Json`, etc. pour automatiser les rapports/exportations.

## 🔗 Commandes utiles

```powershell
Get-Command, Get-Help, Update-Help
Get-Process, Get-Service, Get-ADUser
Invoke-Command, Enter-PSSession
New-ADUser, Set-ADUser, Add-ADGroupMember
Export-Csv, ConvertTo-Json
```
