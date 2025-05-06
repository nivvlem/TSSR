# Les composantes d’une infrastructure vSphere

## 🧱 Architecture d'une infrastructure vSphere

Une solution VMware vSphere repose sur les composants suivants :

|Élément|Rôle dans l’infrastructure vSphere|
|---|---|
|**ESXi**|Hyperviseur de type 1 déployé sur les serveurs physiques|
|**vCenter Server**|Console centralisée d’administration|
|**VM (Machine virtuelle)**|Système invité exécuté sur un hyperviseur|
|**vSphere Web Client**|Interface d’administration accessible via navigateur|

🆕 Depuis vSphere 6.x :

- Disparition du client lourd
- **vCenter sous forme d’appliance virtuelle** (VCSA)
- Interface web unifiée (HTML5)

---

## 🔧 Fonctionnalités principales

|Fonctionnalité|Description|
|---|---|
|**vMotion**|Migration à chaud d’une VM entre deux hôtes ESXi|
|**Storage vMotion**|Migration du stockage d’une VM d’un datastore à un autre|
|**DRS**|Répartition automatique des charges sur les hôtes disponibles|
|**Storage DRS**|Répartition automatique des VM selon l’espace/disponibilité des datastores|
|**DPM**|Mise en veille et réveil automatique des hôtes selon la charge|
|**HA (High Availability)**|Redémarrage automatique des VM sur un autre hôte en cas de panne|
|**FT (Fault Tolerance)**|Haute disponibilité sans interruption pour certaines VM critiques|


---

## 💰 Comparatif des licences (2021)

|Édition|Prix indicatif|Contenu principal|
|---|---|---|
|**ESXi seul**|0 €|Gratuit, mais sans vCenter|
|**Essentials**|574 € TTC|6 CPU max (3 serveurs x2 CPU) + vCenter Essentials|
|**Standard**|1262 € TTC|1 CPU + vCenter Standard, support de base des fonctionnalités|
|**Enterprise Plus**|4326 € TTC|Toutes les fonctionnalités avancées de vSphere|

🎯 Le choix dépend du **nombre d’hôtes**, des **ressources nécessaires** et du **niveau de haute disponibilité souhaité**.

---

## ✅ À retenir pour les révisions

- **ESXi** est l’hyperviseur de base utilisé par vSphere
- **vCenter Server** permet la gestion centralisée de plusieurs hôtes
- Le **vSphere Web Client** est désormais l’interface principale
- Les fonctionnalités comme **vMotion**, **HA**, **DRS** apportent souplesse et continuité
- Les éditions varient fortement en **fonctionnalités et coûts**

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Maintenir les versions ESXi et vCenter **alignées**|Évite les problèmes de compatibilité|
|Déployer vCenter sous forme d’**appliance VCSA**|Plus simple à maintenir, rapide à déployer|
|Activer les fonctionnalités **HA** et **DRS**|Augmente la disponibilité et optimise les ressources|
|Nommer les ressources (VM, datastores, hôtes) clairement|Facilite la gestion dans un environnement multi-serveurs|
|Prévoir un **plan de licence évolutif**|Adapter la plateforme aux besoins futurs sans tout reconfigurer|
