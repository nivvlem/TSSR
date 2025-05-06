# Concepts, enjeux et définitions

## 🔒 Pourquoi sauvegarder ?

### Objectifs

- Garantir la **pérennité des données**
- Assurer la **continuité d'activité** en cas d'incident
- Répondre aux obligations **réglementaires** (RGPD, droit à l'oubli…)
- Se prémunir contre les **cyberattaques**, erreurs humaines ou défaillances

### Enjeux

- Maintenir la **disponibilité des systèmes**
- Mettre en œuvre un **PRA** ou **PCA** efficace
- Proposer une politique de sauvegarde **traçable**, **testée** et **documentée**

---

## 📅 Bonnes pratiques de sauvegarde

|Pratique|Pourquoi ?|
|---|---|
|Compte AD dédié aux sauvegardes|Meilleure sécurité et traçabilité|
|Utilisation du groupe "opérateur de sauvegarde"|Permissions adaptées pour les clients Windows|
|Définir un plan de sauvegarde|Cohérence, périmètre et fréquence bien définis|
|Tester régulièrement la **restauration**|Une sauvegarde inutile si elle est inexploitée|

---

## 🤖 Restauration : définition

- La restauration est l'action de **récupérer** des données perdues, supprimées ou corrompues
- Peut être **totale** (système complet) ou **granulaire** (fichiers, bases, boîtes mail…)
- Objectif : **minimiser les interruptions** d'activité et la perte d'informations

---

## 🔁 Règle de sauvegarde 3-2-1

|Principe|Définition|
|---|---|
|**3 copies**|1 originale + 2 copies de sauvegarde|
|**2 types de stockage**|Exemple : disque local + bande ou cloud|
|**1 copie hors site**|Prévention contre le vol, l'incendie, ransomware...|

---

## 🚑 PCA vs PRA

### PCA – Plan de Continuité d'Activité

- Prise en compte **globale** d'une situation de crise
- Englobe la restauration du SI, la sécurité, le repli physique, etc.

### PRA – Plan de Reprise d'Activité

- Partie **opérationnelle** du PCA
- Concerne la **réactivation du SI** :
    - Procédures de restauration
    - Gestion des supports
    - Licences logicielles

---

## 📖 Plan de sauvegarde

Un **plan de sauvegarde** doit contenir :

- Le **périmètre** (quelles données ?)
- Les **contraintes** (temps, volumétrie, dispo)
- Les types de sauvegarde :
    - Complète
    - Différentielle
    - Incrémentielle
- La **fréquence** (quotidienne, hebdo...)
- Le **stockage** (local, cloud, bande...)
- Les tests de **restauration**
- Les procédures de **destruction** des supports

---

## 🌍 Éditeurs de solution

|Éditeur / Solution|Points notables|
|---|---|
|**Veritas Backup Exec**|Solution complète, intégrée, référence historique|
|**Veeam Backup & Replication**|Leader pour environnements virtuels (VMware, Hyper-V)|
|**Atempo, Arcserve, Rubrik...**|Alternatives avec spécialités diverses|

---

## 🛠️ Focus sur Veeam Backup & Replication

- Sauvegarde **VM complète** ou **granulaire** (fichiers, bases, objets AD...)
- **Réplication** = copie temps réel vers autre hyperviseur → redémarrage rapide
- Compatible avec **VSS**, gestion des bases SQL, Exchange, AD
- Types de Backup :
    - Complète
    - Incrémentielle
    - Reverse incrementiel
- Interface : planification des jobs, réception des alertes, tableaux de bord
- Stockage possible sur : disques locaux, partages CIFS/SMB/NFS, bandes, cloud

---

## 🔎 Réplication : points clés

- Création d’une **copie identique** d’une VM vers un autre hôte ESXi ou Hyper-V
- Le réplica **ne doit pas être démarré manuellement**
- Permet une remise en route rapide avec RTO minimal
- Possibilité de fusion (« merge ») après restauration pour conserver les dernières modifications

---

## ✅ À retenir pour les révisions

- Toute stratégie de sauvegarde doit inclure une phase de **test de restauration**
- La règle **3-2-1** est un fondement de résilience
- **Veeam** est une référence pour les environnements VMware et Hyper-V
- **Réplication** = haute disponibilité immédiate ; **sauvegarde** = reprise possible
- Un **plan de sauvegarde bien rédigé** est indispensable pour répondre à un audit ou une crise

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Utiliser un compte AD dédié à la sauvegarde|Isolation des droits, meilleure traçabilité|
|Séparer sauvegarde, réplication et production|Meilleure gestion des flux et des performances|
|Appliquer la règle **3-2-1** systématiquement|Garantit une redondance cohérente|
|Intégrer les sauvegardes dans le **PRA**|Assure une reprise d’activité structurée|
|Documenter et tester régulièrement les restaurations|Vérifie la fiabilité et réduit le risque d’échec en urgence|
