# Mise en situation professionnelle : Systèmes clients

## Création des utilisateurs et environnement

## 🧱 Objectif 

Créer et configurer les utilisateurs et groupes locaux sur Windows 10 et Debian 10, en appliquant une convention de nommage stricte, des politiques de sécurité (mots de passe, restrictions horaires), et un environnement de travail personnalisé (script, dossiers, pare-feu, fond d’écran, etc.).

---

## 👥 Création des utilisateurs et groupes

### Convention de nommage :

- **Identifiant** : première lettre du prénom + nom de famille (ex. Rick Grimes → `rgrimes`)
- **Groupes** : `GG_<NomService>` (Groupes Globaux), nom identique sur Windows et Linux

### 📄 Liste des services et membres

| Service      | Membres                                     |
| ------------ | ------------------------------------------- |
| Direction    | Rick Grimes                                 |
| Commercial   | Daryl Dixon, Gabriel Stokes, Maggie Greene  |
| Comptabilité | Eugene Porter, Carol Peletier (intérimaire) |
| Informatique | Binôme + moi                                |
| Logistique   | Rosita Espinosa, Morgan Jones               |

### 🔐 Politique de mot de passe (recommandations ANSSI)

- Longueur minimale : 12 caractères
- Complexité activée : Oui
- Expiration : 25 jours
- Pas d’expiration pour les comptes créés (sauf exception imposée)
- Changement obligatoire à la première connexion pour le prestataire

---

## 🖥️ Sur Windows 10 : `W10-MD`

### 📁 Création des groupes

- `GG_Direction` et `GG_Comptabilité` via interface graphique
- `GG_Logistique` et `GG_Informatique` via PowerShell :

```powershell
New-LocalGroup -Name "GG_Logistique" -Description "Groupe Logistique"
New-LocalGroup -Name "GG_Informatique" -Description "Groupe Informatique"
```

### 👤 Création des utilisateurs

- Utiliser `net user` pour les services `Direction` et `Comptabilité` :

```cmd
net user rgrimes "P@ssw0rdRick" /add /fullname:"Rick Grimes" /comment:"Direction"
```

- Utiliser l’interface graphique pour les `Commerciaux`
- Utiliser PowerShell pour les `Informatique`, `Logistique` :

```powershell
New-LocalUser -Name mgreene -FullName "Maggie Greene" -Password (ConvertTo-SecureString "P@ssword" -AsPlainText -Force)
Add-LocalGroupMember -Group GG_Commercial -Member mgreene
```

### ⏱ Restriction horaire (intérimaire Carol Peletier)

```cmd
net user cpeletier /time:M-F,09:00-12:00
```

### 🗂 Personnalisation de l’environnement utilisateur

- Dossier `Procédures` sur le Bureau de chaque utilisateur :

```powershell
New-Item -Path "C:\Users\<NomUtilisateur>\Desktop\Procédures" -ItemType Directory
Copy-Item -Path "C:\Règlement\reglement.pdf" -Destination "C:\Users\<NomUtilisateur>\Desktop\Procédures"
```

### 🔐 Autres paramètres système

- Créer un second compte admin :

```cmd
net user admin2 "SuperPass123!" /add && net localgroup administrators admin2 /add
```

- Membres de GG_Informatique doivent être dans le groupe `Administrateurs`

### 🎨 Environnement restreint (non-admins)

Configurer via stratégie locale ou GPO :

- Désactiver la gravure CD/DVD
- Empêcher l’exécution de `regedit`
- Imposer un fond d’écran :

```powershell
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name wallpaper -Value "C:\wallpaper\fond.jpg"
```

- Vérifier que le **pare-feu est actif** pour tous les profils :

```powershell
Get-NetFirewallProfile | Set-NetFirewallProfile -Enabled True
```

---

## 🐧 Sur Debian 10 : `DEB10-MD`

### 👥 Création des groupes

```bash
sudo groupadd GG_Direction
sudo groupadd GG_Commercial
sudo groupadd GG_Comptabilite
sudo groupadd GG_Informatique
sudo groupadd GG_Logistique
```

### 👤 Création des utilisateurs

- Tous les utilisateurs ont `/bin/bash`, sauf le prestataire (`/bin/ksh`)
- Forcer le changement de mot de passe à la première connexion :

```bash
sudo useradd -m -s /bin/bash -g GG_Commercial ddixon
sudo passwd -e ddixon
```

### 🛠 Fichier de mot de passe exemple :

```bash
sudo passwd rgrimes
sudo usermod -s /bin/ksh cpeletier
sudo chage -d 0 cpeletier
```

---

## 🧰 Bonnes pratiques

- Appliquer une convention de nommage cohérente entre OS
- Ne jamais utiliser le compte administrateur principal pour une session normale
- Séparer les scripts PowerShell `.ps1` et les scripts Bash dans un répertoire dédié (`~/scripts` ou `C:\Scripts`)
- Sauvegarder la liste des utilisateurs/groupes dans un fichier texte ou `.md`

---

## ✅ Résumé des validations

|Élément|Résultat attendu|
|---|---|
|Groupes créés sur les deux OS|OK (mêmes noms sur Debian et Windows)|
|Utilisateurs créés|OK avec conventions de nommage|
|Dossiers "Procédures"|Présents avec règlement intérieur|
|Restrictions (CD, regedit) appliquées|OK pour les utilisateurs non-admin|
|Intérimaire restreint horaires|Session limitée à 09:00 – 12:00|
|Changement de mot de passe forcé|Valide pour prestataire|
|Fond d’écran et pare-feu|Appliqués systématiquement|
