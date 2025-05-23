# TP – Capture et déploiement d’image Windows

## 🧱 Étapes détaillées avec résolution

### 🧩 1. Préparation du poste de référence Win10-MD

- **Activer le compte Administrateur local** :

```powershell
# Via l’interface Utilisateurs et groupes locaux (lusrmgr.msc)
# OU via PowerShell :
Get-LocalUser -Name "Administrateur" | Enable-LocalUser
Set-LocalUser -Name "Administrateur" -Password (Read-Host -AsSecureString "Mot de passe")
```

- **Créer un snapshot de sécurité** avant toute manipulation importante
- **Supprimer les utilisateurs créés lors de l’atelier 08 et de l'installation** :
    - Supprimer les profils utilisateurs :

```powershell
# Via sysdm.cpl > Paramètres système avancés > Profils utilisateurs
```

- Supprimer les comptes utilisateurs dans `lusrmgr.msc`

### 🔁 2. Lancer Sysprep (généralisation)

```bash
C:\Windows\System32\Sysprep\Sysprep.exe /oobe /generalize /shutdown
```

- Options :
    - `/oobe` : prépare l’accueil initial (Out-of-Box Experience)
    - `/generalize` : supprime les SID, l'identité unique de la machine
    - `/shutdown` : éteint la machine après préparation
- Ne pas redémarrer le master après cette étape !

---

### 🧩 3. Clonage du poste syspreppé

- Créer un dossier `Win10-MD-Clone` dans le répertoire VMs de VMware Workstation
- Cloner la machine depuis l’état **post-Sysprep** avec l’option **Full Clone**

---

### 🧩 4. Configuration et observation du clone

Allumez les deux VM : `Win10-MD` (originale) et `Win10-MD-Clone`. Remplir le tableau suivant après analyse.

| Élément                            | Win10-MD                        | Win10-MD-Clone                               |
| ---------------------------------- | ------------------------------- | -------------------------------------------- |
| **Disques durs**                   | 3                               | 3                                            |
| **Volumes**                        | 6 (incl. lecteur DVD)           | 6                                            |
| **Carte réseau bridgée ?**         | Oui                             | Oui                                          |
| **Snapshots**                      | Variable selon l’historique     | Aucun snapshot                               |
| **Quantité de RAM**                | 4 Go                            | 4 Go                                         |
| **Vmware Tools présents ?**        | Oui                             | Oui                                          |
| **Nom machine**                    | Win10-MD                        | DESKTOP-XXXX (aléatoire post-sysprep)        |
| **Utilisateurs dans SAM**          | Tous les comptes précédents     | Comptes natifs + 1 nouveau créé au démarrage |
| **Adresse IP**                     | Fixe (définie atelier 10)       | DHCP                                         |
| **Date 1er log (journal système)** | Date d'installation (atelier 1) | Date du démarrage post-Sysprep               |
| **Points de restauration**         | Atelier 13 (et autres si faits) | Aucun (protection système désactivée)        |
| **Compte admin actif ?**           | Oui                             | Non (si snapshot fait avant activation)      |
| **Pilote HP LaserJet ?**           | Oui                             | Non                                          |
| **Règle entrante ICMP ?**          | Oui                             | Oui                                          |

---

## ✅ À retenir pour les révisions

- **Sysprep** est obligatoire avant une capture ou un clonage pour éviter les conflits de SID
- Le **Full Clone** sur VMware permet une VM indépendante, à l’inverse du **Linked Clone**
- Un poste syspreppé ne doit **jamais être redémarré** avant la capture ou le clonage
- Toujours vérifier : profil admin actif, pilotes essentiels, suppression des apps Store problématiques

---

## 📌 Bonnes pratiques professionnelles

|Bonnes pratiques|Pourquoi ?|
|---|---|
|Réaliser un snapshot avant Sysprep|Pour pouvoir recommencer en cas de problème|
|Activer et tester le compte admin local|Pour éviter un blocage lors de la première session|
|Supprimer tous les comptes inutiles|Pour garantir une image propre|
|Utiliser un nom générique avant sysprep|Permet de redéfinir facilement le nom post-déploiement|
|Documenter les clones créés|Traçabilité et gestion du parc facilitée|
