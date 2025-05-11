# Les composantes d’une infrastructure vSphere

## 🧩 Architecture vSphere : composants principaux

|Rôle|Élément VMware correspondant|
|---|---|
|Solution de virtualisation|**vSphere**|
|Hyperviseur|**ESXi** (ex-ESX, sans Service Console)|
|Interface d’administration|**vSphere Web Client** (remplace client lourd)|
|Gestion centralisée|**vCenter Server**|

> ⚠️ Les versions des composants doivent être **compatibles entre elles**.

---

## 🧱 Architecture technique

- **Machines physiques** : matériel hôte
- **ESXi** : hyperviseur installé directement sur chaque hôte
- **VMs** : machines virtuelles hébergées sur chaque ESXi
- **vCenter Server** : serveur de gestion centralisé des hôtes, des VMs, des ressources et services

---

## 🧠 Fonctionnalités clés (vSphere avancé)

|Fonctionnalité|Utilité principale|
|---|---|
|**vMotion**|Migration à chaud d’une VM d’un hôte ESXi à un autre sans interruption|
|**Storage vMotion**|Déplacement à chaud du disque d’une VM entre deux datastores|
|**DRS**|Répartition automatique des charges entre hôtes selon les ressources|
|**Storage DRS**|Répartition automatique des VM sur les datastores selon espace dispo/perf|
|**DPM**|Mise en veille des hôtes inutiles et réveil selon la charge du cluster|
|**HA**|Haute disponibilité : redémarrage auto des VMs d’un hôte défaillant sur un autre|
|**FT**|Tolérance de panne : redondance en temps réel d’une VM sans interruption|

> Certaines fonctions (vMotion, FT...) nécessitent un **vCenter actif** et des **licences adéquates**.

---

## 💰 Tarification (indicative, août 2021)

|Édition|Prix (TTC)|Contenu principal|
|---|---|---|
|**ESXi seul**|0 €|Hyperviseur gratuit avec création de compte VMware|
|**vSphere Essentials**|574,13 €|3 hôtes (2 CPU max chacun), + vCenter Essentials|
|**vSphere Standard**|1262,14 €|1 licence CPU + vCenter Standard|
|**vSphere Enterprise Plus**|4326,23 €|Tous services VMware sans limite|

> Les licences sont **illimitées dans le temps** et ne nécessitent plus de gestion de VRAM Pool.

---

## ✅ À retenir pour les révisions

- vSphere regroupe **ESXi + vCenter + outils web** pour une gestion complète
- L’**ESXi** est l’hyperviseur, **vCenter** le cœur de la gestion centralisée
- Les fonctionnalités avancées (vMotion, FT…) nécessitent des **licences spécifiques**
- La disparition du **Service Console** et du **client lourd** (remplacé par vSphere Web Client) simplifie le modèle

---

## 📌 Bonnes pratiques professionnelles

- Toujours vérifier la **compatibilité de version** entre vCenter, ESXi et les VM Tools
- Adapter les licences à la **taille de l’entreprise** (Essentials pour PME, Enterprise pour grand compte)
- Utiliser vMotion/DRS/HA dans les environnements critiques pour **garantir continuité de service**
- Documenter les attributions de licences, hôtes et clusters dans le système d’information

---

## 🔗 Outils / notions clés à connaître

- **ESXi**, **vCenter Server**, **vSphere Web Client**
- **vMotion**, **DRS**, **HA**, **FT**, **Storage DRS**, **DPM**
- **Licences Essentials, Standard, Enterprise Plus**
- Concepts : **cluster**, **datastore**, **host**, **VM**, **appliance vCenter**