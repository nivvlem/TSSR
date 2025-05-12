# Réseaux – Manipulations IOS et configurations de base

## 🖥️ Modes de l’IOS (Cisco)

### Modes de commande

|Mode|Prompt|Description|
|---|---|---|
|**Utilisateur**|`>`|Accès en lecture à quelques commandes simples (ex : `ping`, `show`)|
|**Privilégié**|`#`|Accès complet en lecture (ex : `show running-config`)|
|**Configuration globale**|`(config)#`|Accès aux paramètres système|
|**Ligne**|`(config-line)#`|Configuration des accès (console, VTY)|
|**Interface**|`(config-if)#`|Configuration d’une interface réseau|

### Navigation entre les modes

- `enable` : utilisateur → privilégié
- `configure terminal` : privilégié → config globale
- `line vty 0 15` : accès aux lignes VTY
- `interface vlan 1` : configurer l’interface virtuelle du switch
- `exit`, `end`, `Ctrl + Z` : pour sortir d’un mode

---

## ⌨️ Commandes et structure

### Syntaxe des commandes

- Structure : `commande argument`
- Ex : `ping 192.168.10.5`

### Aides intégrées

|Touche|Fonction|
|---|---|
|`?`|Affiche les commandes possibles|
|`^`|Montre l’emplacement de l’erreur dans la ligne|
|`Tab`|Autocomplète les commandes|
|`Flèche haut / Ctrl+P`|Historique des commandes|

---

## 🔐 Sécurisation des accès

### Configuration des mots de passe

|Accès|Commandes|
|---|---|
|Console|`line console 0` + `password xxxx` + `login`|
|VTY (SSH/Telnet)|`line vty 0 15` + `password xxxx` + `login`|
|Mode privilégié|`enable secret xxxx`|

### Chiffrement des mots de passe

- Commande : `service password-encryption`
- Vérification : `show running-config`

### Bannière de connexion

- `banner motd #Message d’accueil#`

### Recommandations ANSSI (résumé)

- Longueur : ≥ 12 caractères (majuscules, minuscules, chiffres, symboles)
- Ne jamais stocker en clair / éviter les mots liés à l’utilisateur
- Renouvellement régulier (90j pour les données sensibles)

---

## 💾 Sauvegarde de la configuration

### Composants mémoire Cisco

|Élément|Localisation|Description|
|---|---|---|
|`running-config`|RAM|Config en cours, perdue au redémarrage|
|`startup-config`|NVRAM|Config de démarrage (boot)|
|`copy running-config startup-config`|Sauvegarde de la config active||

### Démarrage du routeur

|Composant|Rôle|
|---|---|
|Bootstrap ROM|Lance l’IOS|
|POST|Test matériel au démarrage|
|ROM Monitor|Dépannage / tests|
|Mini IOS|IOS réduit pour récupération|

---

## 🌐 Configuration réseau de base

### Attribuer une IP à un switch (SVI)

1. `interface vlan 1`
2. `ip address 192.168.X.X 255.255.255.X`
3. `no shutdown`

> Nécessaire pour pouvoir accéder à distance (via SSH/Telnet)

---

## 🧪 Packet Tracer – Manipulations proposées

- Naviguer dans l’IOS (prompt, commandes show)
- Appliquer les configurations de base sur switch et routeur
- Utiliser `show running-config`, `show ip interface brief`, `ping`, etc.
- Implémenter la connectivité IP de base
- Paramétrer l’adresse IP du SVI sur un switch

---

## ✅ À retenir pour les révisions

- L’IOS Cisco repose sur **plusieurs modes hiérarchiques** avec des niveaux de droits
- Chaque type d’accès (console, VTY, privilégié) doit être **sécurisé** par mot de passe
- La **configuration active** (`running-config`) doit être régulièrement sauvegardée (`startup-config`)
- Pour accéder à distance à un switch, il faut **configurer une IP sur le VLAN 1**

---

## 📌 Bonnes pratiques professionnelles

- Toujours **chiffrer les mots de passe** et supprimer les mots de passe par défaut
- Ne pas oublier d’exécuter `copy running-config startup-config` après chaque modification
- Créer une **bannière d’avertissement** pour les connexions externes
- Vérifier l’**accessibilité du switch à distance** (ping, SSH, Telnet)
- Utiliser **Packet Tracer** en environnement simulé pour tester ses commandes