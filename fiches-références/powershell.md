# PowerShell

## 📌 Présentation

PowerShell est un shell et un langage de script développé par Microsoft, conçu pour l'automatisation des tâches système, la gestion de la configuration, et l'administration de Windows (et désormais Linux avec PowerShell Core). Il repose sur des objets .NET, ce qui le rend très puissant pour manipuler des données structurées.

---

## 🧰 Commandes essentielles

| Cmdlet | Description | Arguments utiles | Exemple |
|--------|-------------|------------------|---------|
| `Get-Help` | Affiche l’aide d’une commande | `-Full`, `-Examples` | `Get-Help Get-Process -Examples` |
| `Get-Command` | Liste les cmdlets disponibles | `-Name`, `-Module` | `Get-Command -Name *service*` |
| `Get-Process` | Affiche les processus | `-Name`, `-Id` | `Get-Process -Name notepad` |
| `Stop-Process` | Termine un processus | `-Id`, `-Name`, `-Force` | `Stop-Process -Name notepad` |
| `Get-Service` | Affiche les services | `-Name`, `-DisplayName` | `Get-Service` |
| `Start-Service` / `Stop-Service` | Démarre / Arrête un service | `-Name`, `-Force` | `Start-Service -Name Spooler` |
| `Set-Service` | Configure un service | `-StartupType` | `Set-Service -Name Spooler -StartupType Disabled` |
| `Get-Item` / `Set-Item` | Accède / Modifie un fichier, dossier, registre… | `-Path` | `Get-Item -Path C:\Temp` |
| `Get-Content` | Lit un fichier | `-Path`, `-Tail` | `Get-Content fichier.txt` |
| `Set-ExecutionPolicy` | Définit la politique d’exécution de scripts | `RemoteSigned`, `Unrestricted` | `Set-ExecutionPolicy RemoteSigned` |
| `New-Item` | Crée un fichier ou dossier | `-Path`, `-ItemType` | `New-Item -Path test.txt -ItemType File` |
| `Copy-Item` / `Move-Item` | Copie / Déplace | `-Path`, `-Destination` | `Copy-Item -Path a.txt -Destination b.txt` |
| `Remove-Item` | Supprime un fichier ou dossier | `-Recurse`, `-Force` | `Remove-Item -Path dossier -Recurse` |
| `Test-Connection` | Test de ping (équivalent à `ping`) | `-ComputerName`, `-Count` | `Test-Connection google.com` |
| `Get-EventLog` | Lit les journaux Windows | `-LogName`, `-Newest` | `Get-EventLog -LogName System -Newest 10` |
| `Import-Module` / `Get-Module` | Charge ou affiche les modules | `-Name` | `Import-Module ActiveDirectory` |
| `Get-ADUser` / `New-ADUser` | Cmdlets Active Directory | `-Filter`, `-Name`, etc. | `Get-ADUser -Filter *` |

---

## 🔎 Cas d’usage courant

- Administration de postes clients et serveurs Windows
- Automatisation de la gestion des utilisateurs, services, fichiers, imprimantes, etc.
- Relevé d'informations (processus, services, réseau…)
- Maintenance programmée (scripts planifiés, tâches automatisées)
- Intégration avec Active Directory

---

## ⚠️ Erreurs fréquentes

- **Scripts bloqués** : par défaut, PowerShell ne permet pas l’exécution de scripts (`Set-ExecutionPolicy` requis)
- **Confusion entre chaînes et objets** : contrairement au Bash, PowerShell manipule des objets .NET, pas du texte brut
- **Manque de filtrage** : oublier `-Filter` ou `Where-Object`, ce qui ralentit les scripts ou renvoie trop de données
- Utiliser `-Force` ou `-Recurse` sans vérifier ce que cela impacte

---

## ✅ Bonnes pratiques

- Utiliser systématiquement `Get-Help` pour comprendre les cmdlets
- Filtrer les données au plus tôt (`-Filter` plutôt que `Where-Object` après coup)
- Ajouter des commentaires explicites dans les scripts
- Utiliser des noms de variables clairs (`$userList`, `$logPath`…)
- Éviter d’utiliser `-Force` sans contrôle préalable
- Organiser ses scripts en blocs logiques : paramètres, fonctions, logique principale

---

## 📚 Ressources complémentaires
- [Microsoft Learn – PowerShell](https://learn.microsoft.com/fr-fr/powershell/)
- [SS64 – Référence rapide PowerShell](https://ss64.com/ps/)
- `Get-Help` intégré dans PowerShell
- [PowerShell Gallery (modules)](https://www.powershellgallery.com/)
