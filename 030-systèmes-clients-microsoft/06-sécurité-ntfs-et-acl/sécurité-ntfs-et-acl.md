# La sécurité NTFS et les ACL

## 🔐 Qu’est-ce qu’une ACL ?

- ACL = **Access Control List** : liste de contrôle d'accès appliquée à un objet
- Sur une partition **NTFS**, tous les fichiers et dossiers sont soumis à cette sécurité

### Les composants clés :

- **DACL (Discretionary ACL)** : liste des utilisateurs/groupes ayant des droits
- **ACE (Access Control Entry)** : chaque entrée précisant les droits attribués/refusés à un sujet

> 📌 On accède aux ACL via l'**onglet Sécurité** des propriétés d’un fichier ou dossier.

---

## 🧩 Droits NTFS de base

|Type de droit|Détails inclus|
|---|---|
|Lecture|Voir le contenu, lister les dossiers|
|Lecture & exécution|Idem Lecture + exécution de fichiers|
|Écriture|Ajouter/modifier des fichiers et dossiers|
|Modification|Écriture + suppression de fichiers|
|Contrôle total|Tous les droits précédents + modification des autorisations, prise de contrôle|

### 🔸 Droits avancés (via bouton "Avancé")

- Création de fichiers ou dossiers spécifiques
- Suppression de sous-dossiers
- Lecture des attributs, etc.

---

## 🧬 Héritage des autorisations

- Les **droits sont transmis** automatiquement aux objets enfants
- Les autorisations héritées sont **grisées** dans l’interface graphique

### Pour modifier cela :

- Utiliser le bouton **Avancé** > **Désactiver l’héritage**
- Appliquer avec précaution pour éviter les effets de bord

> ⚠️ Si un refus est hérité, il peut bloquer l'accès malgré une autorisation directe.

---

## 🔄 Comportement lors des copies/déplacements

|Action|Même partition|Partition différente|
|---|---|---|
|**Déplacement**|Conserve les ACL|Hérite des ACL de destination|
|**Copie**|Hérite des ACL du dossier parent||

> 📌 Toujours vérifier les autorisations après une **copie** ou un **déplacement**.

---

## 🔍 Vérification des autorisations effectives

### Deux méthodes principales :

1. **Test direct** avec les comptes concernés
2. **Menu Avancé > Accès effectif** : simuler les droits réels d’un utilisateur/groupe

---

## ✅ À retenir pour les révisions

- ACL = DACL (qui contient des ACE)
- Un refus explicite l’emporte toujours
- Un groupe **non présent** dans la DACL ⇒ **accès refusé (implicite)**
- L’héritage est **activé par défaut** et **doit être géré prudemment**
- Utiliser **les droits NTFS plutôt que le partage réseau** quand c’est possible

---

## 📌 Bonnes pratiques professionnelles

|Bonnes pratiques|Pourquoi ?|
|---|---|
|Utiliser **les groupes** dans les DACL|Meilleure maintenance et évolutivité|
|Préférer les ACE **de base**|Simplicité de gestion|
|**Tester systématiquement** les accès|Prévenir les erreurs de configuration|
|Garder **l’héritage activé** par défaut|Facilite la cohérence des droits|
|Éviter les refus explicites|Difficiles à maintenir, peuvent bloquer même les admins|
|Se méfier du **double jeton admin** (UAC)|Peut fausser les tests d’accès|
