# Services complémentaires Microsoft 365
## 💻 Déploiement du pack Office 365

### Versions disponibles

- Office Web (Word/Excel/PowerPoint/OneNote Online)
- Office 365 ProPlus (client lourd Windows/Mac)
- Versions mobiles (Android, iOS)
- Visio, Project Pro (licences séparées)

### Fonctionnalités depuis Office 2016

- Co-authoring (coédition temps réel)
- Intégration Teams & OneDrive
- Support multiplateforme
- Priorisation intelligente dans Outlook

### Gestion des mises à jour

|Canal|Fréquence|Usage|
|---|---|---|
|Mensuel|Tous les mois|Dernières nouveautés|
|Semi-annuel|Janvier / Juillet|Stabilité en production|
|Semi-annuel ciblé|Mars / Septembre|Environnement pilote|

### Modes d’installation

- **Via CDN Microsoft** (téléchargement automatique)
- **Via sources locales** :

```powershell
setup.exe /download \\serveur\office_365\Configuration.xml
setup.exe /configure \\serveur\office_365\Configuration.xml
```

- Utilisation de [https://config.office.com](https://config.office.com/) pour générer un fichier XML adapté

### Déploiement par GPO

1. Créer un partage réseau `\\serveur\Office_365`
2. Extraire `officedeploymenttool.exe`
3. Générer le fichier XML
4. Créer une OU avec les postes concernés
5. Appliquer un script `.cmd` dans la GPO pour lancer l’installation

---

## ☁️ Administration OneDrive

### Paramètres clés

- Centre d’administration OneDrive
- Contrôle :
    - Lien de partage par défaut
    - Restrictions d’accès (IP, appareils)
    - Permissions applicables

### Synchronisation

- Premier lancement = forte bande passante
- Ensuite : synchronisation **différentielle** (incrémentale)
- Attention à la consommation réseau sur sites distants

---

## 🌐 SharePoint Online

### Usages

- Création de sites (intranet, projet, documentaires)
- Bibliothèques de documents
- Listes collaboratives

### Avantages

- Plateforme de travail centralisée
- Inclus dans la majorité des licences
- Remplace les serveurs de fichiers locaux
- Socle de Teams (stockage des fichiers)

### Limitations

|Limite|Business|Entreprise|
|---|---|---|
|Stockage total|1 To + 10 Go/licence|idem|
|Stockage par site|25 To|25 To|
|Nombre de sites|2 millions|2 millions|

### Bonnes pratiques

- Éviter la création libre de sites → perte de maîtrise
- Privilégier des **droits simples et segmentés**
- Éviter le stockage de fichiers métier lourds (Photoshop…)
- Attention à la synchronisation hors-ligne massive → latence

---

## 💬 Administration Teams

### Généralités

- Outil de travail collaboratif central (réunions, chat, fichiers)
- Croissance exponentielle post-2020

### Risques

- Création libre d’équipes non contrôlées
- Partages externes mal gérés
- Fuites d’informations internes

### Bonnes pratiques d’administration

- Restreindre la création d’équipes à un **groupe autorisé**
- Appliquer le script PowerShell recommandé par Microsoft
- Contrôler les **droits par canal**, la confidentialité des équipes
- Auditer régulièrement les équipes, membres et usages

### Paramétrage des réunions

- Gestion audio/vidéo, participants, partages
- Application de **stratégies personnalisées** selon les groupes d’utilisateurs

### Paramètres d’organisation

- Gestion des invités (droits, restrictions)
- Blocage ou autorisation des applications tierces (Dropbox, Google Drive…)

---

## ✅ À retenir pour les révisions

- Le déploiement d’Office peut se faire **via GPO** ou **CDN Microsoft**
- SharePoint = **socle documentaire** de Microsoft 365 (Teams, OneDrive inclus)
- Une **synchronisation mal maîtrisée** sur SharePoint ou OneDrive = problèmes réseau ou doublons
- Teams doit être **cadré** pour éviter les débordements (création libre, fuites, surcharge)

---

## 📌 Bonnes pratiques professionnelles

- Générer le fichier XML d’installation Office sur [https://config.office.com](https://config.office.com/)
- Tester toute stratégie (GPO, Teams, SharePoint) sur un **groupe pilote**
- Restreindre la création de groupes M365 avec un script PowerShell dédié
- Documenter tous les sites créés, droits appliqués et synchronisations actives
- Auditer régulièrement les partages OneDrive et Teams (internes / externes)