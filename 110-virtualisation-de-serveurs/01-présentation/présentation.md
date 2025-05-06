# Présentation de la virtualisation de serveurs

## 🧩 Définitions clés

|Terme|Définition|
|---|---|
|**Mutualisation**|Utilisation d’une même infrastructure matérielle pour plusieurs usages|
|**Consolidation**|Réduction du nombre de serveurs physiques en les regroupant sur moins d’hôtes|
|**Rationalisation**|Optimisation de l’usage des ressources pour limiter le gaspillage|

---

## 🕓 La virtualisation en 8 dates clés

|Date|Événement marquant|
|---|---|
|Années 60-70|IBM expérimente la virtualisation sur mainframes|
|Années 90|Émulateurs pour micro-ordinateurs (Amiga, Atari, consoles…)|
|1999|VMware popularise la virtualisation x86|
|2006|Les CPU intègrent des instructions de virtualisation|
|2007|XenSource est racheté par Citrix|
|2007|KVM est intégré au noyau Linux|
|2009|Il y a plus de VMs que de serveurs physiques|
|~2010+|Essor des VDI (Virtual Desktop Infrastructure)|

---

## 💡 Usages de la virtualisation

- Hébergement d’infrastructure (sur site ou en cloud)
- Environnements de test et rétrocompatibilité
- Plan de Reprise d’Activité (PRA)

### Avantages :

- Optimisation du matériel (CPU/RAM/disques)
- Réduction des coûts et de l’énergie
- Flexibilité de déploiement et d’administration

### Inconvénients :

- Concentration du risque (single point of failure)
- Complexité initiale et investissement
- Contraintes spécifiques (sauvegarde, supervision…)

---

## 🧱 Couches de virtualisation

La virtualisation s’applique à différents niveaux :

- 🖥️ Poste de travail
- 🧩 Applications
- 🖧 Réseau (ex. VLAN, VXLAN)
- 💾 Stockage (ex. vSAN, Ceph)
- 🛠️ Services (ex. containers, microservices)

---

## 🖥️ Solutions principales

|Type|Solutions utilisateurs (type 2)|Solutions serveurs (type 1)|
|---|---|---|
|OS|VMware Workstation, VirtualBox, Hyper-V Client|VMware ESXi, Hyper-V Server, KVM, XenServer|

---

## ⚙️ Composants et paramètres importants

- **Paramétrage matériel** : CPU, RAM, BIOS, disques, périphériques
- **Formats de disques** : `.vhd`, `.vmdk`, `.vdi`
- **Médias virtuels** : ISO, IMG, USB virtuel
- **Réseaux virtuels** : NAT, Bridge, Interne, LAN dédié
- **Fichiers de config** : `.vmx`, `.vbox`, XML…

---

## 🧠 Types d’hyperviseurs

### 🔹 Type 1 (natif / bare-metal)

- Fonctionne directement sur le matériel
- Très performant, usage en production
- Exemples : ESXi, Hyper-V, KVM, XenServer

### 🔹 Type 2 (hébergé)

- Installé dans un système d’exploitation
- Moins performant, idéal pour les tests
- Exemples : VirtualBox, VMware Workstation

---

## 🧪 Paravirtualisation

- Les VMs accèdent au matériel via des _hypercalls_ et non via des traductions binaires
- Optimise les performances avec un noyau ou pilotes adaptés (ex : VirtIO sous Linux)
- Exemple d’usage : Xen en mode paravirtualisé

---

## ✅ À retenir pour les révisions

- La **virtualisation** optimise les coûts, la consommation et la gestion des ressources
- **Hyperviseur type 1** = performant, production ; **type 2** = pratique, test
- Attention à la **concentration du risque** (dépendance à l’hôte physique)
- La **paravirtualisation** améliore les performances via des appels directs à l’hyperviseur

---

## 📌 Bonnes pratiques professionnelles

|Bonnes pratiques|Pourquoi ?|
|---|---|
|Tester sur des hyperviseurs type 2 avant prod|Réduire les erreurs de configuration|
|Choisir un format de disque adapté|Compatibilité (ex. `.vhd` pour Hyper-V, `.vmdk` pour VMware)|
|Activer la virtualisation dans le BIOS/UEFI|Nécessaire au bon fonctionnement (Intel VT-x, AMD-V)|
|Isoler les réseaux de test|Éviter les conflits réseau ou les fuites de trafic|
|Sauvegarder les fichiers VM et snapshots|Permet un retour rapide en cas de problème|
