# TP – Activités pour aller plus loin

## 📄 Énoncé synthétisé

> **Machines utilisées :** CLI01 et CD01

### Activité 1 – Comprendre et commenter un script

📄 Fichier : `creation_objets_ad_v6-Q1.ps1`

- Lire un script de création d'utilisateurs, d’unités organisationnelles et de groupes dans un environnement AD
- Commenter chaque bloc ou ligne importante du script
- Analyser les actions réalisées : création, affectation, mots de passe, permissions, exports, etc.

### Activité 2 – Corriger un script DNS

📄 Fichier : `Tp6-Q2.ps1`

- Corriger les erreurs dans un script de configuration DNS : noms de Cmdlets, paramètres incorrects, fautes de frappe
- Assurer que :
    - Les zones soient créées correctement
    - Les enregistrements A, PTR et NS soient bien définis
    - Les redirecteurs et mises à jour soient activés

### Activité 3 – Créer un script complet (au choix)

🧩 Option A – Gestion réseau :

- Créer un script gérant l’adresse IP, le masque, la passerelle, le DNS
- Possibilité de rendre le tout interactif avec des menus

🧩 Option B – Menu de gestion Active Directory :

- Créer un menu PowerShell avec plusieurs choix :
    - Créer un utilisateur à partir d’un modèle
    - Lister les groupes AD
    - Ajouter un utilisateur à un groupe
    - Exporter les informations d’un utilisateur

---

## ✅ Résolution structurée (extraits)

### 🔹 Activité 1 – Exemple de commentaire pour un bloc du script AD

```powershell
# Création de l’unité organisationnelle principale
$societe="_Entreprise"
New-ADOrganizationalUnit $societe -ProtectedFromAccidentalDeletion $false
```

> 💬 Création d’une OU racine nommée _Entreprise avec suppression protégée désactivée

### 🔹 Création de modèles utilisateurs (mod_dir, mod_info…)

```powershell
# Création d’un utilisateur modèle pour le service Direction
New-ADUser -Name "_mod_dir" -SamAccountName "mod_dir" -Department Direction ...
```

### 🔹 Affectation à des groupes + export

```powershell
Add-ADGroupMember G_Compta christelle,christophe
Get-ADUser david | Out-File -Encoding utf8 "C:\detail_user_david.txt"
```

---

### 🔹 Activité 2 – Exemples de correction (DNS)

```powershell
# Mauvais :
Add-DnsServerRessourceRecord -A -Name "s2-w-cd" ...
# Corrigé :
Add-DnsServerResourceRecordA -Name "s2-w-cd" ...
```

```powershell
# Correction des noms de zones et glue records
Add-DnsServerPrimaryZone -Name "ad.gilles.eni" -ZoneFile "ad.gilles.eni.dns"
```

---

### 🔹 Activité 3 – Extrait de menu interactif AD (option B)

```powershell
do {
    Clear-Host
    Write-Host "Menu de gestion AD :"
    Write-Host "1 - Créer un utilisateur"
    Write-Host "2 - Lister les groupes"
    Write-Host "3 - Ajouter à un groupe"
    Write-Host "4 - Export infos utilisateur"
    Write-Host "5 - Quitter"

    $choix = Read-Host "Choix"

    switch ($choix) {
        '1' { # logique création }
        '2' { Get-ADGroup -Filter * | Format-Table Name }
        '3' { # ajout utilisateur à un groupe }
        '4' { # export infos }
    }
} while ($choix -ne '5')
```

---

## 🧠 À retenir pour les révisions

- Savoir **auditer et commenter** un script est une compétence très recherchée
- La rigueur sur la **syntaxe des Cmdlets** évite de nombreux bugs
- Créer un menu interactif est une excellente approche pour l’automatisation et l’administration

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Ajouter un `<# bloc de doc #>`|Donne le contexte du script (auteur, version, usage)|
|Utiliser des variables explicites|Meilleure compréhension dans un audit ou une relecture|
|Simuler avec `-WhatIf` ou `-Confirm`|Avant de modifier des objets AD ou DNS|
|Sauvegarder les exports avec date|Assure la traçabilité et les contrôles|
|Modulariser dans des fonctions|Réutilisable, testable, plus facile à corriger|
