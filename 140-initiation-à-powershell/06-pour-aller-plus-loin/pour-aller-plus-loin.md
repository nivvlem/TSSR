# Pour aller plus loin 
## 🔐 Pourquoi l’authentification est essentielle

### Contexte professionnel

- En entreprise, les scripts PowerShell sont souvent exécutés **avec des comptes restreints** (non admin).
- Certaines actions exigent des privilèges élevés (modification AD, arrêt machine, installation…)
- Objectif : **séparer les droits élevés du contexte utilisateur standard**, tout en permettant une élévation ponctuelle

---

## 🧰 `Get-Credential` : outil d’authentification sécurisé

### 📌 Syntaxe de base

```powershell
$Cred = Get-Credential
```

- Affiche une boîte de dialogue système
- Demande un **nom d’utilisateur** et **un mot de passe masqué**
- Résultat : un objet de type `[System.Management.Automation.PSCredential]`

### 📋 Affichage du type

```powershell
$Cred.GetType()
# Résultat : IsPublic True, Name PSCredential
```

---

## ✨ Personnalisation de la fenêtre d’invite

### Ajouter un message et un nom d’utilisateur par défaut

```powershell
$Cred = Get-Credential -Message "Entrez vos identifiants Admin du domaine" -UserName "eni\Administrateur"
```

> 📌 Le mot de passe n’apparaît jamais en clair ni en mémoire ni dans l'historique de la console.

---

## 🔐 Utilisation typique dans un script

```powershell
$Cred = Get-Credential -Message "Connexion requise pour l’action" -UserName "DOMAIN\admin"
Invoke-Command -ComputerName SRV01 -Credential $Cred -ScriptBlock {
    Get-Service -Name Spooler
}
```

---

## ✅ À retenir pour les révisions

- `Get-Credential` est **l’outil standard** pour capturer des identifiants utilisateur
- Il retourne un **objet PSCredential** que l’on peut utiliser dans n’importe quelle commande distante (`Invoke-Command`, `New-PSSession`, etc.)
- Le mot de passe n’est **jamais visible** dans le script ni dans l’environnement

---

## 📌 Bonnes pratiques professionnelles

- **Ne jamais coder un mot de passe en clair** dans un script
- Toujours demander les credentials à l’exécution, ou stocker un fichier chiffré si besoin
- Préférer la **personnalisation de la boîte de dialogue** pour guider l’utilisateur
- Nettoyer les variables sensibles après usage : `$Cred = $null`

---

## 🔗 Commandes utiles

```powershell
$Cred = Get-Credential
$Cred = Get-Credential -Message "Message" -UserName "Domaine\Nom"
Invoke-Command -ComputerName SRV01 -Credential $Cred -ScriptBlock {...}
```

