# Mise en situation professionnelle : Systèmes clients

## 📄 Contexte de la MSP

La MSP (Mise en Situation Professionnelle) se déroule dans un contexte d’apprentissage approfondi des **systèmes d’exploitation clients**, aussi bien sous **Windows 10 Professionnel** que sous **Debian 10**. Elle s’inscrit dans la logique métier d’un technicien systèmes/réseaux capable de gérer une flotte de postes utilisateurs dans un environnement mixte.

Tu incarnes un **technicien informatique** au sein d’une PME fictive chargée de mettre en place deux postes clients, l’un sous Windows, l’autre sous Linux, puis de les configurer, sécuriser, automatiser, sauvegarder et relier dans un contexte collaboratif avec un binôme.

---

## ✅ Objectifs pédagogiques de la MSP

- Installer, partitionner et configurer deux systèmes clients de manière professionnelle
- Créer et gérer des utilisateurs et groupes locaux sur Windows et Linux
- Appliquer des politiques de sécurité adaptées aux postes clients
- Configurer les volumes, les droits d’accès et les partages locaux/réseaux
- Installer des applications graphiques ou silencieuses sur chaque système
- Planifier des sauvegardes sur chaque OS et prévoir la restauration
- Manipuler le partitionnement avancé (LVM, déplacement de `/home`, `/var/log`, `/opt`...)
- Réaliser l’administration locale et distante (RDP, Webmin, SSH, client RDP Linux)
- Automatiser des actions avec des scripts et les planificateurs intégrés

---

## 📌 Prérequis techniques

- Connaissance de base en virtualisation (VMware Workstation)
- Savoir configurer un réseau en mode Bridged
- Être capable d’utiliser les outils CLI et GUI sous Windows et Linux
- Avoir accès aux ISOs fournis :
    - Windows 10 Pro
    - Debian 10 (version DVD avec interface graphique)


---

## 🔫 Défis techniques majeurs

- Partitionnement manuel Linux (/boot, /home, swap, LVM, etc.)
- Configuration fine des utilisateurs et groupes (restrictions horaires, shell, scripts de connexion…)
- Gestion avancée des disques et systèmes de fichiers : ext4, xfs, LVM, swap
- Mise en œuvre de sauvegardes planifiées et duplication réseau (scp)
- Configuration de partages invisibles (SMB, script PowerShell)
- Gestion d’imprimantes avec droits avancés (groupes, horaires, priorité)
- Administration distante (RDP, SSH, Webmin) et vérification du port RDP
- Création d’un environnement de travail sécurisé (pare-feu, fond d’écran imposé, GPO locales, etc.)

---

## ⚙️ Plan de résolution global

1. **Installation des systèmes (Windows 10 & Debian)**
2. **Création des utilisateurs et environnement (droits, restrictions, scripts)**
3. **Configuration du stockage et des partages (DATA, droits, visibilité)**
4. **Configuration avancée des systèmes (GRUB, swap, RDP, pare-feu, shell)**
5. **Installation d’applications (7zip silencieux, client RDP, Webmin)**
6. **Sauvegardes et restauration (planification, duplication réseau, image système)**
7. **Gestion avancée du stockage (LVM, montage /opt, /var/log)**
8. **Travaux bureautiques complémentaires (Excel, formules, conditions)**
