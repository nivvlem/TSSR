# CMD (Command Prompt)

## 📌 Présentation

CMD (ou cmd.exe) est l’interpréteur de commandes historique de Windows. Moins puissant que PowerShell, il reste présent sur tous les systèmes Windows pour des opérations simples : navigation dans le système, diagnostic réseau, exécution de scripts `.bat`, etc.

---

## 🧰 Commandes essentielles

| Commande | Description | Exemple |
|----------|-------------|---------|
| `dir` | Liste les fichiers d’un répertoire | `dir C:\Users` |
| `cd` | Change de répertoire | `cd C:\Windows\System32` |
| `cls` | Efface l’écran | `cls` |
| `copy` | Copie un fichier | `copy fichier.txt D:\backup\` |
| `xcopy` | Copie avancée (dossiers récursifs) | `xcopy /E /I source destination` |
| `del` | Supprime un fichier | `del fichier.txt` |
| `move` | Déplace ou renomme un fichier | `move test.txt archive\` |
| `ren` | Renomme un fichier | `ren ancien.txt nouveau.txt` |
| `mkdir` | Crée un dossier | `mkdir logs` |
| `rmdir` | Supprime un dossier | `rmdir /S /Q temp` |
| `echo` | Affiche un texte à l’écran | `echo Bonjour` |
| `type` | Affiche le contenu d’un fichier | `type texte.txt` |
| `pause` | Interrompt un script jusqu’à validation utilisateur | `pause` |
| `ping` | Test de connectivité | `ping 8.8.8.8` |
| `ipconfig` | Affiche la config IP | `ipconfig /all` |
| `netstat` | Affiche les connexions réseau actives | `netstat -an` |
| `tasklist` | Liste les processus actifs | `tasklist` |
| `taskkill` | Termine un processus | `taskkill /IM notepad.exe /F` |
| `exit` | Ferme la console CMD | `exit` |

---

## 🔎 Cas d’usage courant

- Scripts `.bat` de déploiement simples
- Diagnostics réseau rapides : `ipconfig`, `ping`, `netstat`
- Automatisation de copies ou suppressions de fichiers
- Utilisation dans des environnements sans PowerShell (très rare aujourd’hui)

---

## ⚠️ Erreurs fréquentes

- Oublier les guillemets autour de chemins avec espaces : `C:\Program Files`
- Ne pas utiliser `/S` pour supprimer des dossiers avec `rmdir`
- Mauvais usage des redirections `>` (écrasement accidentel de fichiers)
- Ne pas exécuter CMD avec droits administrateur pour les opérations système

---

## ✅ Bonnes pratiques

- Préférer `xcopy` à `copy` pour les arborescences
- Documenter ses scripts `.bat` avec `REM` (commentaire)
- Créer des alias ou des raccourcis vers CMD avec privilèges si besoin
- Passer progressivement à PowerShell pour toute nouvelle automatisation

---

## 📚 Ressources complémentaires

- [Commandes CMD officielles Microsoft](https://learn.microsoft.com/fr-fr/windows-server/administration/windows-commands/windows-commands)
- `help` ou `commande /?` dans l’invite de commande
