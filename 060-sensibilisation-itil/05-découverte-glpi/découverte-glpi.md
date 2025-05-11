# Découverte de GLPI
## 🧰 Qu’est-ce que GLPI ?

- **GLPI** = _Gestion Libre de Parc Informatique_
- Outil **ITSM** libre (conforme ITIL), licence GPL
- Compatible **Windows / Linux**
- Outil de **gestion de parc** + **centre de services** (support, tickets…)
- Adapté aux petites, moyennes et grandes structures

---

## 🧩 Fonctionnalités principales

|Domaine|Fonctionnalités|
|---|---|
|**Inventaire matériel**|Vue détaillée, composants internes, cycle de vie, historique|
|**Logiciels et licences**|Référencement, suivi des clés, conformité|
|**Réseau**|Composants réseau, cartographie, connexions|
|**Informations admin & financières**|Affectation, coût, fournisseur, garantie|
|**Réservation**|Planification de matériel ou ressources|

---

## 👥 Interfaces GLPI

### Interface simplifiée

- Destinée aux utilisateurs finaux
- Accès aux :
    - Tickets (création/suivi)
    - Réservations
    - FAQ

### Interface standard

- Pour techniciens, administrateurs et gestionnaires
- Accès à tous les modules selon les **droits** attribués
- 3 vues disponibles :
    - **Personnelle** (son propre travail)
    - **Groupe** (tickets liés à son équipe)
    - **Globale** (vision complète pour les admins)

---

## 🔍 Recherches dans GLPI

### Recherche rapide

- Ciblée uniquement sur les champs **visibles**
- Opérateurs supportés (REGEX) :
    - `^` : début du champ
    - `$` : fin du champ
    - `^$` : valeur exacte
    - `NULL` : champs vides

### Recherche avancée

- Multicritères avec **opérateurs logiques** (ET, OU, ET PAS, OU PAS)
- Critères : contient, est, n’est pas, avant/après, sous, etc.
- Possibilité d’utiliser des caractères spéciaux : `<Nb`, `>Nb`, dates formatées, etc.

### Recherches sauvegardées

- Création possible avec nom, portée, entité (récursive ou non)
- Réutilisables à volonté (suivi, rapports…)

---

## 🛠️ Fonctions avancées

### Modification massive

- Modifier plusieurs éléments issus d’une recherche avancée
- Gain de temps pour mises à jour en série

### Fiche élément

- Accès détaillé à chaque CI (matériel, licence, etc.)
- Navigation latérale par onglets (personnalisable)
- Accès rapide aux objets similaires depuis la même page

---

## ✅ À retenir pour les révisions

- **GLPI est un outil ITSM** complet, conforme ITIL, libre et modulaire
- Permet la **gestion du parc**, des **demandes utilisateurs**, et des **services IT**
- La **recherche avancée + modification massive** sont des fonctions clés pour l’administration
- L’interface **s’adapte** au profil de l’utilisateur (simple ou complet)

---

## 📌 Bonnes pratiques professionnelles

- Documenter chaque **CI** dans GLPI dès l’installation
- Utiliser des **recherches sauvegardées** pour vos audits et suivis de conformité
- Gérer les droits d’accès via **groupes et profils** pour limiter les erreurs
- Associer chaque matériel à un utilisateur et à une entité pour un suivi clair
- Mettre à jour GLPI avec les **plugins officiels** pour suivre les évolutions du SI
- Synchroniser GLPI avec **Active Directory** si possible pour centraliser les identités