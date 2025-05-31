# Authentification AD et habilitations
## 🧩 Les entités dans GLPI

### Définition

- Permettent de **segmenter l’administration** de l’application GLPI
- Modélisent la structure organisationnelle (groupe, client, site géographique…)
- Chaque entité dispose :
    - De ses propres objets (tickets, matériel, utilisateurs)
    - De ses propres règles d’administration

### Cloisonnement

|Mode|Effet|
|---|---|
|Sans récursivité|Cloisonnement strict|
|Avec récursivité|Visibilité sur les sous-entités|

### Exemple typique

```text
Société
 ├── Client1
 │   ├── Filiale A
 │   └── Filiale B
 └── Client2
     └── Filiale A
```

---

## 🎛️ Interfaces GLPI

|Interface|Public visé|Fonctionnalités|
|---|---|---|
|Simplifiée|Utilisateurs finaux|Tickets, FAQ, réservations|
|Standard|Techniciens / Admin|Inventaire, tickets, configuration complète|

Le **profil** détermine quelle interface est proposée à l’utilisateur.

---

## 👤 Profils GLPI

- Définissent **les droits et interfaces** associés à un utilisateur
- Plusieurs profils possibles pour un même utilisateur (par entité)

### Profils prédéfinis

|Profil|Droits|
|---|---|
|Super-Admin|Tous les droits sur GLPI|
|Admin|Tous les droits d’administration|
|Technician|Gestion de tickets et inventaire|
|Hotliner|Saisie et suivi des tickets|
|Observer|Lecture seule sur les objets|
|Self-Service|Interface simplifiée, dépôt de tickets|

### Droits configurables par module

- Parc (matériel)
- Assistance (tickets)
- Licences, fournisseurs, budgets…
- Administration (règles, entités)
- Configuration générale

### Droits par action

- Lecture / Mettre à jour / Créer / Supprimer / Purger

---

## 🏷️ Intitulés et lieux

### Intitulés

- Valeurs catégorisantes : types de matériel, fournisseurs, statuts, etc.
- Liste arborescente possible

### Lieux

- Permettent de **placer géographiquement** : matériel, utilisateurs, entités
- Reposent sur une **convention de nommage OBLIGATOIRE**

---

## 🔑 Authentification AD (LDAP)

### Fonctionnement

- Permet une **authentification centralisée**
- Base de comptes : Active Directory (LDAP)
- Avantages :
    - Centralisation des identités
    - Moins d’erreurs / duplications
    - Synchronisation automatique des attributs (nom, mail...)

### Types de bases de comptes

|Type|Exemple|
|---|---|
|Interne|Base GLPI|
|Externe LDAP|Active Directory|
|Messagerie|POP/IMAP|
|Certificats|X509|

### Méthodes d’import

- **Manuel**
- **Automatique** à la première connexion (recommandé)

---

## ⚙️ Configuration de l’authentification AD

### Étapes

1. **Configuration > Authentification > Annuaires LDAP** → +
2. Choisir la **préconfiguration Active Directory**
3. Renseigner :
    - Nom
    - @IP du serveur AD
    - **Base DN** : `DC=mondomaine,DC=TLD`
    - **DN du compte** utilisé pour interroger l’AD :
        ```text
        CN=Administrateur,OU=admin,OU=IT,DC=mondomaine,DC=TLD
        ```
    - Mot de passe
4. Vérifier la **synchronisation automatique des champs** (nom, mail…)

### Points de vigilance

- Filtre d’exclusion des **utilisateurs désactivés**
- Vérification dans l’**éditeur d’attributs AD**

---

## 🛠️ Habilitations dans GLPI

### Définition

- Déterminent les **droits** et leur **portée** (entité)
- Une habilitation = **profil + entité**
- **Récursivité** possible sur les sous-entités

### Types

|Type|Mode de gestion|
|---|---|
|Statiques|Affectées manuellement|
|Dynamiques|Basées sur des règles (automatique)|

---

## ⚙️ Habilitations statiques

- Attribution manuelle des habilitations par l’admin GLPI
- Risques :
    - Non centralisé
    - Maintenance lourde
    - Risques d’erreurs

---

## ⚙️ Habilitations dynamiques

- Basées sur les **règles d’affectation**
- Les règles sont lues **à chaque connexion**

### Critères possibles

|Critère|Exemple|
|---|---|
|(LDAP) MemberOf|`GG_GLPI_Technician`|
|Attribut AD|ex: `department=IT`|

### Opérateurs

- `Contient` (recommandé car plus souple)
- `Est` (strict)

### Actions possibles

|Action|Exemple|
|---|---|
|Profil|`Technician`|
|Entité|`Client X`|
|Récursivité|Activée / non activée|
|Refus d’import|Exclure certains comptes|

### Processus de mise en œuvre

1️⃣ Identification des besoins → Ex: tech sur l’entité client  
2️⃣ Création des groupes AD → Ex: `GG_GLPI_Technician`  
3️⃣ Affectation des utilisateurs dans l’AD  
4️⃣ Création des **règles d’affectation d’habilitation**  
5️⃣ **Vérification** dans GLPI (profil, entité)

---

## ✅ À retenir pour les révisions

- La gestion fine des **entités** permet un GLPI multi-client ou multi-site
- L’authentification LDAP **centralise les identités**
- Les **habilitations dynamiques** sont à privilégier : souples et maintenables
- Les **profils** structurent les droits des utilisateurs
- Il est crucial d’avoir une **convention de nommage claire** pour : lieux, groupes AD, intitulés

---

## 📌 Bonnes pratiques professionnelles

- **Documenter** la structure d’entités et de profils
- Mettre en place des **groupes AD dédiés** pour GLPI (préfixe type `GG_GLPI_*`)
- Préférer les habilitations **dynamiques** aux statiques
- Auditer régulièrement les habilitations et leur cohérence
- Restreindre l’usage de Super-Admin
- Mettre en place des **règles d’import contrôlées** (filtrage LDAP)
- Conserver une **traçabilité des connexions** et synchronisations LDAP
