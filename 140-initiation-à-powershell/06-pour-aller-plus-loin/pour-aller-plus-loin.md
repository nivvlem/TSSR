# Pour aller plus loin : L’authentification PowerShell

## 🔐 Pourquoi gérer l’authentification ?

Dans un environnement sécurisé, l’utilisateur peut être restreint par défaut :

- Interdiction d’exécuter des scripts critiques sans droits d’administrateur
- Exécution sur des **comptes à privilèges limités** (bonnes pratiques sécurité)

Pour contourner cela **sans stocker de mot de passe en clair**, PowerShell permet de demander à l’utilisateur **une authentification sécurisée au moment du besoin**.

---

## 🔑 La Cmdlet `Get-Credential`

Permet d’ouvrir une fenêtre de saisie sécurisée (type pop-up Windows) :

```powershell
$Cred = Get-Credential
```

- La **variable `$Cred`** contient un objet de type `[PSCredential]`
- Utilisable avec de nombreuses Cmdlets PowerShell qui nécessitent des credentials

### Exemple d’usage :

```powershell
Invoke-Command -ComputerName CD01 -Credential $Cred -ScriptBlock { Get-Process }
```

---

## 🎨 Personnaliser la fenêtre de saisie

Tu peux **prédéfinir le login** et personnaliser le message affiché :

```powershell
$Cred = Get-Credential -Message "Entrez votre login Admin du Domaine" -UserName "eni\Administrator"
```

> 💬 L’utilisateur doit toujours confirmer le mot de passe manuellement. Aucun mot de passe n’est écrit en dur dans le script.

---

## 🧠 À retenir pour les révisions

- `Get-Credential` permet une **authentification sécurisée** (popup)
- La variable retournée est un objet `[PSCredential]`
- Tu peux personnaliser le **message affiché** et le **nom d’utilisateur proposé**
- Utilisé avec : `Invoke-Command`, `Enter-PSSession`, `New-PSSession`, etc.
- **Ne jamais coder un mot de passe en dur** dans un script professionnel !

---
## 📌 Bonnes pratiques professionnelles

|Bonnes pratiques|Pourquoi ?|
|---|---|
|Ne jamais écrire un mot de passe en clair|Risque majeur en cas de fuite de script ou de log|
|Utiliser `Get-Credential` dès que possible|Pop-up sécurisé, supporté nativement par PowerShell|
|Pré-remplir uniquement le `UserName`|Évite les erreurs, tout en gardant le mot de passe secret|
|Définir `$Credential` comme paramètre facultatif dans un script|Pour pouvoir automatiser sans compromettre la sécurité|



