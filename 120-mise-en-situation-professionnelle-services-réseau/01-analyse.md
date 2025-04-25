# Mise en situation professionnelle : Services réseau
## Analyse
## 📄 Contexte de la MSP

La MSP (Mise en Situation Professionnelle) se déroule dans un contexte de maquettage d’infrastructure pour une société fictive nommée **Support-Terre**, spécialisée dans le support informatique aux PME.

Tu fais partie de l'équipe technique sur le projet **TSSRC-Série-EU**, avec pour objectif de mettre en place une infrastructure complète, fonctionnelle et redondante en environnement **virtualisé (VMware Workstation)**, avec des machines Windows et GNU/Linux.

---

## ✅ Objectifs pédagogiques de la MSP

- Mettre en place un **routage et une segmentation réseau** propre avec **pfSense**.
- Créer et configurer plusieurs **machines virtuelles (clients et serveurs)**.
- Déployer les services critiques suivants :
    - DHCP
    - DNS interne (avec redirecteurs)
    - Active Directory (ADDS)
    - Partage de fichiers et gestion des droits d’accès
    - GPO (stratégies de groupe)
    - Services redondants (DNS, DHCP, AD)
    - Accès distant et administration centralisée

---

## 📌 Prérequis techniques

- **VMware Workstation** installé (ou environnement équivalent de virtualisation).
- Images ISO disponibles :
    - **pfSense**
    - **Windows Server** (2016 ou 2019)
    - **Debian** (sans interface graphique pour le serveur, avec GUI pour le client)

---

## 🔫 Défis techniques majeurs

- Création d'un **plan d'adressage IP** adapté au contexte (/22 → /24)
- Utilisation de **pfSense** pour isoler LAN Clients / LAN Serveurs / WAN
- Intégration DNS/AD sur Windows et Debian en fonction de la parité du poste
- **Résolution directe et inverse**, avec redirecteurs conditionnels
- Mise en place **d'unités d'organisation (OU)** et d'utilisateurs dans l'AD
- Mise en place de **partages réseaux avancés** avec droits granulaires
- **Redondance DNS, DHCP, AD** → tolérance de panne
- Administration à distance : RDP, SSH, RSAT, WAC

---

## ⚙️ Plan de résolution global 

1. **Infrastructure réseau (pfSense, LAN/WAN)**
2. **Ajout des serveurs Windows/Linux**
3. **Ajout des clients Windows/Linux**
4. **Services de base : routage, NAT, DNS public**
5. **Installation & configuration du DHCP**
6. **Mise en place DNS interne + redirecteurs**
7. **Domaine Active Directory : création et intégration**
8. **Utilisateurs, groupes et unités d'organisation**
9. **Partages et droits NTFS/Shares**
10. **Stratégies GPO & tests clients**
11. **Redondance : DNS, DHCP, AD**
12. **Accès distant & outils d'administration (RSAT, WAC)**

