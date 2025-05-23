# TP – Services complémentaires M365 : Déploiement Office et administration SharePoint/OneDrive

## 🧾 TP 1 – Déploiement Office 365 par GPO

### 1. Préparation du poste client

- Créer une VM Windows 10 nommée `Client2`
- Joindre `Client2` au domaine Active Directory

### 2. Désactivation du téléchargement manuel d’Office par les utilisateurs

- Se connecter au **Centre d'administration Microsoft 365**
- Accéder à **Paramètres > Paramètres de l'organisation > Logiciels**
- Désactiver la case : "Les utilisateurs peuvent installer des applications Office"

### 3. Téléchargement de l'outil de déploiement

- Télécharger l’outil ODT : [Microsoft Office Deployment Tool](https://www.microsoft.com/en-us/download/details.aspx?id=49117)
- Extraire dans un dossier partagé réseau : `\\SRV-FICHIERS\Office_365`

### 4. Configuration XML personnalisée

- Générer un fichier `Configuration.xml` sur [https://config.office.com](https://config.office.com/)
- Exemple minimal :

```xml
<Configuration>
  <Add OfficeClientEdition="64" Channel="Monthly">
    <Product ID="O365ProPlusRetail">
      <Language ID="fr-fr" />
    </Product>
  </Add>
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
```

### 5. Téléchargement et déploiement

```powershell
setup.exe /download \\SRV-FICHIERS\Office_365\Configuration.xml
setup.exe /configure \\SRV-FICHIERS\Office_365\Configuration.xml
```

### 6. Création d’un script d’installation

```cmd
@echo off
\\SRV-FICHIERS\Office_365\setup.exe /configure \\SRV-FICHIERS\Office_365\Configuration.xml
```

- Renommer en `deploy_office.cmd`

### 7. GPO d’installation automatique

- Créer une OU pour `Client2`
- Créer une GPO liée à l’OU :
    - `Configuration ordinateur > Paramètres Windows > Scripts > Démarrage`
    - Ajouter le script `deploy_office.cmd`
- Vérifier que le partage réseau est lisible par les machines clientes

### 8. Application de la GPO

```powershell
gpupdate /force
```

- Redémarrer la machine
- Vérifier que le pack Office est installé

---

## 🛠️ TP 2 – Administration SharePoint et OneDrive

### 1. Création du site SharePoint

- Aller dans [https://admin.microsoft.com](https://admin.microsoft.com/)
- Section **SharePoint > Sites actifs > Créer**
- Choisir modèle **Centre de documents**
- Nommer le site, choisir la langue et le propriétaire

### 2. Création de groupes AGDLP synchronisés

- Dans l’AD local :
    - Créer les groupes dans une OU dédiée : `DL_SP_Fichiers_RW`, `DL_SP_Fichiers_RO`
    - Créer groupes globaux correspondants (GG_ServiceIT...)
    - Ajouter les membres aux groupes globaux, puis les groupes globaux aux DL
- Lancer une synchronisation Azure AD Connect

### 3. Attribution des droits sur le site

- Aller dans les paramètres du site SharePoint > Autorisations
- Supprimer les groupes par défaut inutiles (ex : `Visiteurs – All Company`)
- Ajouter les groupes AD synchronisés avec droits :
    - RW : Collaboration
    - RO : Visiteur

### 4. Restrictions et sécurisation

- **Désactiver la synchronisation hors-ligne**
    - `Paramètres du site > Disponibilité du mode hors connexion`
    - Choisir "Ne pas autoriser l’utilisation hors connexion"
- **Restreindre les partages externes et invitations**
    - `Paramètres de la bibliothèque > Demandes d’accès`
    - Décocher toutes les options permettant les invitations ou demandes

### 5. Nettoyage de l’affichage

- Modifier le volet de navigation : masquer les sections inutiles
- Ajouter une **charte de nommage des bibliothèques** pour éviter les doublons

---

## ✅ À retenir pour les révisions

- Le déploiement d’Office par GPO permet un **contrôle centralisé et silencieux**
- SharePoint est plus efficace quand les **droits sont gérés via l’AD synchronisé**
- La synchronisation OneDrive peut impacter fortement le réseau ➜ limiter les usages

---

## 📌 Bonnes pratiques professionnelles

- Ne jamais donner aux utilisateurs les droits d’installation manuelle Office
- Ne pas déployer SharePoint sans stratégie de **gouvernance des droits**
- Organiser les groupes AD avec le modèle **AGDLP** dès le départ
- Interdire le partage externe par défaut puis autoriser à la demande
- Documenter toutes les bibliothèques, droits appliqués et groupes utilisés