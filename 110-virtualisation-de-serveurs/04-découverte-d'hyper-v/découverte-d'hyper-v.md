# Découverte d’Hyper-V

## 💡 Qu’est-ce qu’Hyper-V ?

Hyper-V est l’hyperviseur de type 1 développé par **Microsoft**, intégré en tant que **rôle serveur** dans Windows Server et **fonctionnalité facultative** dans les éditions Windows Pro/Enterprise (à partir de Windows 8).

---

## 📦 Prérequis

### Matériels :

- Processeur 64 bits compatible **Intel VT-x** ou **AMD-V**
- **SLAT** (Second Level Address Translation) requis pour les versions client
- Quantité de RAM et stockage suffisants

### Logiciels :

- OS serveur : **Windows Server 2008 et +**
- OS client : **Windows 8 Pro/Enterprise 64 bits** ou supérieur

🔄 **Deux redémarrages** sont nécessaires lors de l’ajout du rôle sur un serveur

---

## 🧩 Spécificités d’Hyper-V

- Affichage multi-console (chaque VM dans une fenêtre dédiée)
- Intégration via services (compatibilité dépendante de l’OS invité)
- Redirection limitée de périphériques (USB notamment sur les anciennes versions)
- Clavier spécial pour "Ctrl + Alt + Suppr" : **Ctrl + Alt + Fin**

---

## 🖧 Paramétrage réseau Hyper-V

### Types de réseaux virtuels :

|Type|Description|
|---|---|
|**Privé**|Communication uniquement entre VMs invitées|
|**Interne**|Communication entre hôte et VMs|
|**Externe**|Accès au réseau physique via une carte réseau physique|
|**Externe dédié**|L’interface réseau est réservée exclusivement à Hyper-V|

📌 Chaque carte réseau physique peut n’être utilisée que pour **un réseau externe Hyper-V**.

🔧 Configuration via le **Gestionnaire de Réseau Virtuel** dans la console Hyper-V

---

## ⚙️ Création et gestion des VM

- Assistant _Nouveau > Ordinateur virtuel_
- Choix de l’emplacement de stockage et des paramètres (RAM, CPU, disque, ISO…)
- Pour les VMs **génération 1**, le disque système doit être sur une **interface IDE**
- Console de gestion Hyper-V permet la supervision et le paramétrage

---

## 🔁 Exportation et importation

> Attention : les manipulations sont sensibles, surtout avec Hyper-V v3 (2012+)

### Procédure recommandée :

1. **Exporter** la VM depuis la console Hyper-V
2. Copier le répertoire sur l’emplacement cible
3. **Importer** la VM en choisissant ou non de dupliquer les fichiers

🛑 Si l’option « Dupliquer tous les fichiers » est cochée, les disques **sont copiés** dans un nouvel emplacement

---

## ✅ À retenir pour les révisions

- Hyper-V est un **hyperviseur de type 1** intégré dans Windows
- L'installation nécessite des **redémarrages et prérequis CPU** (VT-x / AMD-V / SLAT)
- Une **console dédiée** est disponible pour chaque VM
- L'import/export nécessite une attention sur les chemins et fichiers utilisés
- **Ctrl + Alt + Fin** remplace Ctrl + Alt + Suppr dans une VM Hyper-V

---

## 📌 Bonnes pratiques professionnelles

|Bonne pratique|Pourquoi ?|
|---|---|
|Toujours créer les réseaux virtuels **en amont**|Évite les conflits ou l’isolation non voulue des VMs|
|Bien nommer les interfaces réseau|Clarté dans la supervision et les diagnostics|
|Exporter systématiquement avant déplacement|Assure l'intégrité des fichiers et la portabilité|
|Dédié une interface réseau physique à Hyper-V|Garantit un meilleur débit et une isolation réseau|
|Installer les services d’intégration|Optimise les performances et fonctionnalités entre hôte et invité|
