# Virtualisation sur poste de travail (VMware Workstation)

## 💻 Prérequis matériels et logiciels

| Élément     | Détail                                               |
| ----------- | ---------------------------------------------------- |
| Processeur  | Compatible Intel VT-x ou AMD-V (activé dans BIOS)    |
| RAM         | Minimum 8 Go recommandé pour le confort d’usage      |
| Disque dur  | Prévoir un volume adapté (10 à 30 Go par VM typique) |
| OS hôte     | Windows 10/11 ou Linux                               |
| Application | VMware Workstation 17                                |

---

## ⚙️ Installation et version

- Préférez la **dernière version stable** compatible avec l’OS hôte
- Une VM créée avec une version récente **n’est pas rétrocompatible**
- Utilisez les **paramètres d’installation par défaut**

---

## 🧱 Création d’une VM – Étapes essentielles

1. **Choisir l’option** : _I will install the operating system later_
2. **Système cible** : définir l’OS invité (Windows, Linux…)
3. **Nom et dossier de la VM** : éviter « Mes documents », utiliser un dossier dédié
4. **Disque virtuel** : choisir _Store virtual disk in a single file_ pour les performances
5. **Personnaliser le matériel** : CPU, RAM, lecteur ISO, carte réseau, USB, etc.

📌 _Accès aux réglages :_ `Virtual Machine Settings`

---

## 🖧 Modes de réseau disponibles

|Mode|Description|
|---|---|
|**Bridged**|La VM est vue comme une machine physique sur le réseau|
|**NAT**|La VM utilise l’accès réseau de l’hôte (connexion Internet partagée)|
|**Host-only**|Communication entre l’hôte et les VM uniquement (réseau privé)|
|**LAN Segment**|Réseau isolé, à créer manuellement dans VMware|

Services associés :

- `VMware NAT Service`
- `VMware DHCP Service`

💡 Si besoin d’un adressage personnalisé, désactiver ces services.

---

## 🧩 Gestion du matériel et interaction

- **Capture clavier/souris** : Ctrl + Alt pour relâcher
- **Ctrl + Alt + Suppr** dans la VM : utiliser Ctrl + Alt + Inser
- **Périphériques virtuels** : disquettes, CD/DVD, USB…
- **Shared Folder** : partage d’un dossier de l’hôte dans la VM
- **Ajout à chaud** possible pour disques, cartes réseau…

---

## 🛠️ Problèmes fréquents et solutions

|Problème|Solution recommandée|
|---|---|
|Réseau instable|Désactiver / réactiver les cartes réseau de l’hôte|
|Démarrage impossible sur CD|Appuyer sur Échap au logo VMware / modifier ordre de boot|
|Espace disque hôte saturé|Déplacer la VM ou libérer de l’espace|
|Espace disque VM insuffisant|Ajouter un disque virtuel ou augmenter la taille (complexe)|

---

## ✅ À retenir pour les révisions

- Hyperviseur **type 2** = installé sur OS, idéal pour tests
- Le **mode bridged** connecte la VM au réseau physique directement
- Utiliser **Shared Folder** pour échanger fichiers facilement
- Choisir une **taille de disque suffisante dès le départ**
- Utiliser l’installation manuelle pour un meilleur contrôle

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Créer un dossier dédié par VM|Meilleure organisation et maintenance|
|Utiliser des ISO officiels|Éviter les erreurs ou versions corrompues|
|Sauvegarder les VM importantes|Restauration rapide en cas de crash|
|Isoler les VM en LAN segment pour les tests|Évite toute interaction réseau non désirée|
|Documenter les paramètres VM|Permet la reproductibilité et la compréhension à long terme|
