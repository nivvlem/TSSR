# TP 1 à 5 – Interagir avec Windows (Interface graphique, CMD, PowerShell)

# ✅ TP 1 – Prise en main de l'interface graphique

### 🔹 Objectifs

- Personnaliser l'environnement Windows
- Utiliser MMC pour centraliser l'administration

### 🔹 Actions réalisées

- Modifier le mot de passe utilisateur via `CTRL+ALT+INSER` (Pas `SUPPR` car VM)
- Nettoyer la barre des tâches (détacher Store et Courrier)
- Épingler PowerShell à la barre des tâches
- Suspendre les mises à jour Windows Update pendant 35 jours
- Renommer la machine (`Win10-MD`) via Paramètres > Système > Informations système
- Créer une MMC personnalisée avec :
    - Gestion des disques
    - Utilisateurs et groupes locaux
    - Dossiers partagés
- Personnaliser le fond d’écran
- Désactiver la mise en veille automatique via les paramètres d'alimentation

✔️ Snapshot pris à l'issue de la personnalisation.

---

# ✅ TP 2 – Prise en main de la CMD

### 🔹 Objectifs

- Se familiariser avec les commandes de base `cmd.exe`
- Manipuler des fichiers et répertoires

### 🔹 Actions réalisées

- Personnaliser l'affichage de l'invite de commande (Police Consolas, taille 24, couleurs personnalisées)
- Utiliser `help` pour explorer les commandes internes
- Créer un dossier `C:\CommandList`
- Générer un fichier texte listant toutes les commandes internes (`help > InternalCommands.txt`)
- Copier ce fichier sur le bureau
- Utiliser `dir /OS` pour lister les fichiers par taille croissante

✔️ Snapshot "TP2 terminé" enregistré.

---

# ✅ TP 3 – Premiers pas avec PowerShell

### 🔹 Objectifs

- Découvrir l'environnement PowerShell et ses premières commandes

### 🔹 Actions réalisées

- Ajuster la taille de la police dans PowerShell (`Ctrl+Molette`)
- Vérifier la version PowerShell via `$PSVersionTable` et `Get-Host`
- Lister les fichiers d'un répertoire avec `Get-ChildItem` (`ls` en alias)
- Lister tous les alias (`Get-Alias`), trouver ceux correspondant à `Get-ChildItem`

✔️ Snapshot "TP3 terminé" pris après validation.

---

# ✅ TP 4 – Manipuler l’aide de PowerShell

### 🔹 Objectifs

- Utiliser efficacement le système d’aide de PowerShell

### 🔹 Actions réalisées

- Sur Discovery : consulter l’aide complète de `Get-Alias`
- Sur Win10-MD : constater l'absence d'aide installée
- Exécuter `Update-Help` pour télécharger l’aide locale
- Afficher les exemples de commandes `Get-Help Get-Process -Examples`
- Explorer les topics d'aide `about_*` pour comprendre les concepts fondamentaux
- Modifier `$MaximumHistoryCount` pour augmenter l'historique des commandes

✔️ Familiarisation complète avec le système d'aide PowerShell.

---

# ✅ TP 5 – Devenir autonome avec PowerShell

### 🔹 Objectifs

- Approfondir l'utilisation de PowerShell
- Comprendre la gestion d'objets et de propriétés

### 🔹 Actions réalisées

- Lister toutes les commandes disponibles (`Get-Command`)
- Filtrer uniquement les cmdlets (`Get-Command -CommandType Cmdlet`)
- Filtrer les cmdlets avec verbe `Get` (`Get-Command -Verb Get`)
- Identifier et manipuler les groupes locaux (`Get-LocalGroup`, `Get-LocalGroupMember`)
- Extraire des propriétés spécifiques (`Select-Object FriendlyName, BusType` sur les disques)
- Exporter la liste des membres du groupe Administrateurs dans un fichier texte (`Out-File`)

✔️ Pratique concrète de la manipulation d'objets PowerShell terminée.

---

## ✅ Vérifications finales

- Customisation interface graphique réalisée sur Win10-XX et Discovery
- Gestion basique de fichiers et navigation confirmée sous `cmd.exe`
- Utilisation efficace de PowerShell (commandes de base, aide, objets)
- Snapshots créés pour documentation et éventuels retours arrière

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Travailler sur VM dédiée|Sécuriser l’environnement de test|
|Documenter les commandes PowerShell utilisées|Faciliter la maintenance et la réutilisation ultérieure|
|Utiliser la complétion (`Tab`) et l’aide (`Get-Help`)|Optimiser l’efficacité et limiter les erreurs|
|Prendre des snapshots fréquents|Prévenir les erreurs majeures et faciliter la restauration|
|Séparer clairement l’apprentissage CLI et GUI|Développer une double compétence indispensable en IT|
