# TP – Les stratégies de groupe local (LGPO)

## 🧩 Étapes de résolution complète

### 🔐 1. Renforcer la stratégie de mot de passe

**Console utilisée :** `secpol.msc` (Stratégie de sécurité locale)

**Accès :**

```bash
Win + R > secpol.msc
```

**Actions :**

- Stratégies de compte → Stratégie de mot de passe
    - Longueur minimale du mot de passe : **7 caractères**
    - Conserver l'historique des mots de passe : **3**
    - Le mot de passe doit respecter les exigences de complexité : **Activé**

**Tests recommandés :**

- Créer un compte standard et tenter de changer son mot de passe pour vérifier les règles.

---

### 👥 2. Créer une GPO pour les non-administrateurs

**Console utilisée :** `mmc` + composant logiciel enfichable _Éditeur d’objet de stratégie de groupe_

**Étapes :**

1. `Win + R > mmc`
2. `Fichier > Ajouter un composant logiciel enfichable > Éditeur d’objet de stratégie de groupe`
3. Parcourir > Onglet Utilisateurs > sélectionner `Non-administrateurs`

**Paramètres à configurer :**

- Interdire l’accès au **Panneau de configuration et à Paramètres**
    - `Configuration utilisateur > Modèles d'administration > Panneau de configuration`    
    - Activer : _Interdire l’accès au Panneau de configuration et à l’application Paramètres du PC_
- Verrouiller la **barre des tâches**
    - `Configuration utilisateur > Modèles d’administration > Menu démarrer et barre des tâches`
    - Activer : _Verrouiller la barre des tâches_
- Définir un **papier peint**
    - `Configuration utilisateur > Modèles d’administration > Bureau`
    - Activer : _Papier peint du bureau_ + Chemin d’accès à une image (en .jpg ou .bmp)

**Tests recommandés :**

- Se connecter avec un compte standard et vérifier que les restrictions s’appliquent.

---

### 👤 3. Créer une GPO pour l’utilisateur Romain

**Console utilisée :** `mmc` + composant logiciel enfichable _Éditeur d’objet de stratégie de groupe_

**Étapes :**

1. Ajouter un nouveau composant pour l’utilisateur `romain`
2. Parcourir > Utilisateurs > sélectionner `romain`

**Paramètres à configurer :**

- **Accès autorisé** au Panneau de configuration et à Paramètres
    - `Configuration utilisateur > Modèles d’administration > Panneau de configuration`
    - Désactiver : _Interdire l’accès au Panneau de configuration et à l’application Paramètres du PC_
- **Supprimer l’accès au gestionnaire des tâches**
    - `Configuration utilisateur > Modèles d’administration > Système > Options Ctrl+Alt+Suppr`
    - Activer : _Supprimer le gestionnaire des tâches_

**Tests recommandés :**

- Se connecter avec l’utilisateur `romain` et valider les comportements attendus

---

## ✅ À retenir pour les révisions

- `gpedit.msc` et `secpol.msc` sont complémentaires pour gérer les stratégies locales
- Les **LGPO** s’appliquent par utilisateur ou groupe d’utilisateurs spécifiques
- Il est possible de **personnaliser finement** l’environnement Windows sans modifier directement le registre
- Toujours **tester les GPO dans un environnement de test** avant déploiement en production

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Documenter chaque stratégie appliquée|Assure la traçabilité et facilite le dépannage|
|Tester les GPO avec un utilisateur cible|Vérifie la bonne application sans affecter tous les comptes|
|Sauvegarder les GPO (via `LGPO.exe` si dispo)|Permet réutilisation ou restauration rapide|
|Centraliser dans un script ou modèle si répété|Gain de temps et homogénéité|
