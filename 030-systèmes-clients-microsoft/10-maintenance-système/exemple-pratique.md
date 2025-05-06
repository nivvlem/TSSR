# TP – Maintenance du système

## 🔍 1. Analyse de la fiabilité du système

### 🔹 Affichage de l’historique

```cmd
Rechercher > Afficher l’historique de fiabilité
```

- Vue synthétique : noter la chute de l’indice et les événements critiques
- Vue détaillée : double-clic sur un événement critique (ou provoquer un crash avec un `PowerOff` si aucun n'existe)

---

## 🧠 2. Analyse en temps réel

### 🔹 Procédure

- Lancer plusieurs tâches simultanées :
    - Copier un gros fichier
    - Ouvrir PowerShell, le gestionnaire des tâches, Edge…
- Observer via :

```cmd
taskmgr.exe
resmon.exe
```

### 🔹 Remplir le tableau des ressources

|Ressource|Application la plus consommatrice (exemple)|
|---|---|
|Processeur|Edge / gestionnaire de tâches|
|Mémoire|Edge / Service Host|
|Réseau|Téléchargement en cours|
|Disque|Copie de fichier|

> ⚠️ Les résultats varient selon l’environnement. Utiliser les onglets **Performances** et **Processus**.

---

## 💾 3. Sauvegarde de l’état système et données

### 🔹 Étapes

1. **Activer la protection du système** :
    ```cmd
    sysdm.cpl > Onglet Protection du système
    ```
    - Sélectionner le disque C: > Configurer > Activer la protection
    - Allouer environ 5 % de l’espace disque
2. **Créer un point de restauration manuel** :
    - Bouton "Créer..." > Nom : `Atelier13`
3. **Créer des fichiers test** dans `Documents` :
    - Exemple : `FicAtelier13.txt`, `Rep-Atelier13`
4. **Désinstaller IE11 et Windows Media Player** :
    - Paramètres > Applications > Fonctionnalités facultatives > Supprimer

> 📝 Ces actions permettent de vérifier l’impact d’une restauration système.

---

## 🧯 4. Restauration avec WinRE

### 🔹 Lancement

```cmd
shutdown /r /o /t 0
```

Ou : Maj + Redémarrer > Dépannage > Options avancées > Restauration du système

### 🔹 Étapes

1. Sélectionner le compte administrateur > Saisir mot de passe
2. Suivant > Sélectionner le point `Atelier13` > Terminer > Oui
3. Le système redémarre automatiquement après la restauration

### 🔹 Observations post-restauration

|Élément|Résultat observé|
|---|---|
|Fichiers dans `Documents`|✅ Présents (non concernés par la restauration système)|
|IE11 et Windows Media Player|✅ Réinstallés (puisqu’ils ont été désinstallés **après** le point)|

---

## ✅ Vérifications

|Action réalisée|Preuve attendue|
|---|---|
|Point de restauration créé|Affiché dans sysdm.cpl|
|Fichiers de test créés dans Documents|Existence après restauration|
|Fonctionnalités supprimées restaurées|IE11 et Media Player disponibles de nouveau|
|Fiabilité analysée|Capture de l’outil Historique de fiabilité|
|Performances mesurées|Tableau rempli avec outils TaskMgr/ResMon|

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Créer un point avant toute modification système|Revenir rapidement à un état stable|
|Utiliser l’historique de fiabilité régulièrement|Détecter les erreurs invisibles à l’utilisateur|
|Sauvegarder les données séparément|Car elles ne sont **pas** restaurées par les points système|
|Documenter toutes les manipulations critiques|Facilite le suivi en entreprise|
|Tester les outils WinRE sur machine de test|Mieux anticiper un cas de récupération réel|
