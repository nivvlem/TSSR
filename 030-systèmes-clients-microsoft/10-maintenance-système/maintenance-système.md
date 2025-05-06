# La maintenance du système

## 🧠 Les problématiques de maintenance

### 🔹 Performances

- Le système est-il capable d’exécuter les tâches demandées ?
- 4 composants à surveiller : **processeur**, **mémoire**, **disque**, **réseau**

### 🔹 Fiabilité

- Le système fonctionne-t-il comme attendu au démarrage, au lancement des services, des applications ?

### 🔹 Méthodes d’analyse

|Méthode|Description|
|---|---|
|Analyse en temps réel|État actuel du système (performances, services, ressources)|
|Analyse historique|Événements et erreurs passés (journaux, fiabilité, performances planifiées)|
|Diagnostic automatique|Détection proactive par Windows, parfois avec résolution automatique|

---

## 🛠️ Outils d’analyse en temps réel

|Outil|Description|
|---|---|
|`taskmgr.exe` (Gestionnaire de tâches)|Vue rapide sur les performances, processus et services actifs|
|`resmon.exe` (Moniteur de ressources)|Analyse détaillée par composant|
|`perfmon.exe` (Analyseur de performances)|Analyse via des compteurs configurables|
|`eventvwr.msc` (Observateur d’événements)|Vue centralisée de tous les journaux d’événements|

---

## 🧾 Outils d’analyse sur l’historique

|Outil|Description|
|---|---|
|Historique de fiabilité|Vue graphique de l’état global du système jour par jour|
|Observateur d’événements|Accès aux journaux système, sécurité, application, etc.|
|Analyseur de performances|Permet de **programmer des collectes** sur des périodes spécifiques|

---

## 🧪 Diagnostic automatique

|Outil|Fonction|
|---|---|
|Diagnostic mémoire Windows|Test complet de la RAM au redémarrage|
|Résolution de problèmes intégrée|Propose une solution (non affichée) à l'utilisateur pour divers scénarios|

🔎 Pour approfondir un problème détecté : consulter l’aide Windows, Technet, ou blogs spécialisés.

---

## 💾 Points de restauration système

### 🔹 Description

- Sauvegarde du registre + fichiers système critiques + programmes installés
- **Ne sauvegarde pas les données personnelles**
- Fonction désactivée par défaut, à activer par lecteur

### 🔹 Création

- Quotidienne (automatique)
- Sur évènement système (installation de pilote, désinstallation de logiciel…)
- Manuelle via :

```cmd
sysdm.cpl → Protection du système
```

### 🔹 Stockage

- Utilise un espace disque dédié, fonctionne en **FIFO** (First In, First Out)

### 🔹 Restauration

- Via Windows ou WinRE (Recovery Environment)
- Administration requise

---

## 🧯 Récupération système avec WinRE

### 🔹 Lancement de WinRE

|Méthode|Description|
|---|---|
|`Maj + Redémarrer` depuis le menu démarrer|Accès rapide|
|`shutdown /r /o`|Redémarrage vers WinRE|
|Paramètres > Mise à jour > Récupération|Redémarrer maintenant|
|Support d’installation > Réparer|Depuis une clé ou un ISO|
|Chargement automatique|Après 2 échecs de démarrage consécutifs|

### 🔹 Options avancées de WinRE

- **Restauration du système**
- **Récupération via image système** (nécessite une sauvegarde préalable)
- **Invite de commandes (admin)**
- **Rétrograder vers version précédente** (si issue d’une mise à jour majeure)
- **Paramètres de démarrage** :
    - Mode sans échec
    - Désactiver le contrôle des signatures
    - Activer le mode vidéo basse résolution…
- **Outil de redémarrage système** :
    - Répare le MBR et le magasin BCD

---

## ✅ À retenir pour les révisions

- Utiliser `taskmgr`, `resmon`, `perfmon`, `eventvwr` pour analyser les performances et erreurs
- Les **points de restauration** ne protègent pas les données utilisateurs
- WinRE est une interface légère permettant la **récupération avancée du système**
- Toujours activer la protection du système sur le disque **C:** au minimum

---

## 📌 Bonnes pratiques professionnelles

|Bonnes pratiques|Pourquoi ?|
|---|---|
|Créer un point de restauration avant toute intervention|Revenir en arrière en cas de problème|
|Analyser l’historique de fiabilité en cas d’instabilité|Comprendre les erreurs récurrentes|
|Tester la mémoire régulièrement en cas de crash|Identifier une RAM défectueuse|
|Documenter les incidents avec captures et logs|Aide à la résolution et à la traçabilité|
|Sauvegarder régulièrement une image système complète|Permet une restauration intégrale en cas de défaillance|
