# Remote Desktop Services (RDS) - Publication d'applications
## 🧩 Principe de la publication d'applications

### RemoteApp

- Fonction de **RDS** qui permet de **publier une application spécifique** plutôt qu’un bureau complet
- L’application **s’exécute sur le serveur**, mais s’affiche localement sur le poste client

### Avantages

- Réduction de la bande passante (vs. bureau complet)
- Environnement utilisateur **plus fluide** (ne déstabilise pas le poste)
- Sécurisation des données (les fichiers restent sur le serveur)

### Fonctionnement

```text
Client RDP → RD Session Host → Application spécifique (RemoteApp)
```

---

## ⚙️ Étapes de mise en œuvre - RemoteApp

1️⃣ Installer les **rôles RDS** (comme vu au Module 2)  
2️⃣ Créer une **collection** spécifique pour RemoteApp  
3️⃣ Ajouter le ou les **serveurs RD Session Host** dans cette collection  
4️⃣ Sélectionner les **applications à publier**

Exemples :

- Microsoft Office (Word, Excel)
- Logiciels métiers
- Navigateurs sécurisés

---

## 🚀 Mise à disposition des applications publiées

### Canaux d’accès

|Méthode|Description|
|---|---|
|RD Web Access|Portail web accessible par navigateur (HTML5)|
|Fichier .RDP|Téléchargé ou déployé par GPO|
|Intégration dans le menu Démarrer|RemoteApp and Desktop Connections|

### Exemple de configuration GPO

```text
Ordinateur > Configuration > Paramètres Windows > Connexions RemoteApp et Bureau
```

---

## 🎬 Démonstration - Utilisation des RemoteApp

### Expérience utilisateur

- L’application apparaît **en fenêtre locale** sur le poste utilisateur
- Barre de titre personnalisée (indiquant que c’est une RemoteApp)
- Possibilité de **redirection de périphériques** (imprimantes, presse-papiers, audio)

### Cas d’usage typiques

- Applications non compatibles avec les postes clients (anciennes versions)
- Accès sécurisé depuis l’extérieur (via Gateway)
- Optimisation des licences (moins de postes lourds)

---

## ⚙️ Configuration avancée des collections

### Points avancés

- **Segmentation des utilisateurs** par collection
- **Restriction des sessions** par GPO
- Redirection des imprimantes **locale ou centrale**
- Gestion fine des **profils utilisateurs** (FSLogix recommandé)

### Bonnes pratiques

- Créer une collection **dédiée aux RemoteApp** (ne pas mélanger avec les bureaux)
- Surveiller la **charge** sur les serveurs RD Session Host
- Mettre en place des **mécanismes de haute disponibilité** (Connection Broker en cluster)

---

## 🛡️ Filtrage et restrictions

### Objectifs

- **Limiter les accès** aux seules applications autorisées
- Empêcher les utilisateurs de contourner les restrictions

### Méthodes

- Affecter des RemoteApp **par groupe AD**
- GPO : désactiver l’accès au bureau complet si nécessaire
- Auditer régulièrement les affectations

### GPO utiles

```text
Utilisateur > Modèles d'administration > Composants Windows > RemoteApp and Desktop Connections
```

- Masquer l’accès au bureau complet
- Restreindre la redirection de périphériques
- Restreindre le presse-papiers partagé

---

## ✅ À retenir pour les révisions

- **RemoteApp** permet de **publier des applications** spécifiques, sans bureau complet
- Nécessite une **collection dédiée**
- Accès possible via **portail web**, fichier .RDP ou **GPO**
- La sécurité repose sur un **filtrage strict des applications et des utilisateurs**
- La gestion fine des **profils et redirections** est clé pour une expérience utilisateur réussie

---

## 📌 Bonnes pratiques professionnelles

- **Isoler** les collections RemoteApp des collections de bureaux distants
- Affecter les RemoteApp **par groupe AD** et non utilisateur individuel
- Restreindre les **redirections** aux besoins réels (imprimantes, presse-papiers)
- Éviter la publication d’applications lourdes sans test de montée en charge
- **Documenter** la configuration des collections et des affectations
- Surveiller régulièrement les **logs RDS** (RemoteApp et session host)
- Vérifier la **compatibilité des applications** en mode RemoteApp
- Prévoir un **plan de maintenance** (mise à jour des applis publiées)
