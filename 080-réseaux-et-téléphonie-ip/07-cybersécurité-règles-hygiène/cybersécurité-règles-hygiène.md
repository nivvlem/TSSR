# Cybersécurité – Hygiène informatique
## 🧩 Connaître le Système d’Information

### Identifier les composants du SI

- Matériels : serveurs, routeurs, commutateurs, PC, smartphones…
- Logiciels : OS, applications, versions installées
- Données sensibles : mots de passe, fichiers clients, contrats

### Inventorier les biens

- Identifier tous les équipements physiques et applicatifs
- Associer chaque équipement à un usage / utilisateur
- Utiliser des outils d’inventaire (GLPI, OCS Inventory…)

### c. Interconnexions

- Identifier les points d’entrée / sortie : box, VPN, liaisons opérateurs…
- Documenter les interconnexions (prestataires, partenaires, cloud)

---

## 🌐 Maîtriser le réseau

### Cloisonner le réseau

- Créer des **zones** distinctes (utilisateurs, serveurs, invités)
- Utiliser **VLAN**, **VRF**, sous-réseaux
- Appliquer le principe : "**Tout ce qui n’est pas explicitement autorisé est interdit**"

### Accès sécurisé

- Contrôle d’accès réseau 802.1X (certificat, carte à puce, RADIUS)
- VPN IPsec/SSL pour les connexions distantes
- Accès distant via SSH, SFTP, HTTPS

### Réseau Wifi sécurisé

- WPA2 + clé > 15 caractères + CCMP
- Modifier SSID et mots de passe par défaut
- Éviter WPS, désactiver ports inutiles

---

## 🖥️ Sécuriser les terminaux

### Applications

- Télécharger depuis les sites **officiels** uniquement
- Interdire les sources inconnues (smartphones)
- Vérifier les **signatures numériques** et checksums

### Mises à jour

- Appliquer les correctifs **OS + logiciels**
- Gérer via serveur centralisé (ex. : WSUS)

### Antivirus / Antimalware

- Mise à jour automatique des signatures
- Analyse périodique complète, clés USB et mails

### Détection de compromission

- Pop-ups, ralentissements, antivirus désactivé sans intervention
- Envois de mails non réalisés par l’utilisateur

### Chiffrement et sauvegarde

- Chiffrer les données sensibles (AxCrypt, VeraCrypt…)
- Sauvegarder localement + dans le cloud

### Durcissement des postes

- Désactiver ports inutiles, supprimer services superflus
- Mot de passe BIOS, blocage boot USB
- Activer la journalisation

---

## 👤 Gérer les utilisateurs

### Principes de droits

- Principe du **moindre privilège**
- Compte nominatif = 1 utilisateur = 1 traçabilité
- Retrait immédiat des accès lors d’un départ

### Charte informatique

- Signée par l’utilisateur : rôles, responsabilités, sanctions

### Politique de mot de passe

- Longueur ≥ 8 caractères (≥10 pour admin)
- Changement tous les 6 mois
- Pas de réutilisation / pas de mot de passe unique pour plusieurs services

### Stockage sécurisé

- Chiffrement, coffre-fort numérique, pas dans le navigateur web

### Authentification renforcée

- MFA : biométrie, carte à puce, OTP, SSO

### Protection contre le spam et le phishing

- Ne jamais cliquer sans vérifier l’émetteur
- Signaler les tentatives à la cellule SSI

---

## 🛡️ Contrôler la sécurité du SI

### Supervision

- Journalisation des accès et tentatives
- Définition de seuils d’alerte (stockage, CPU…)

### Plan de secours

- PCA / PRA : double alimentation, sauvegardes régulières
- Tests de restauration périodiques

---

## ✅ À retenir pour les révisions

- L’hygiène informatique repose sur : inventaire, cloisonnement, mises à jour, sensibilisation
- Les accès doivent être **tracés, restreints et justifiables**
- Le réseau, les postes et les données doivent être **surveillés et protégés**
- Le mot de passe ne suffit plus → privilégier l’**authentification forte**

---

## 📌 Bonnes pratiques professionnelles

- Cloisonner le réseau et filtrer tous les flux par défaut
- Tenir un **inventaire complet et à jour** de l’infrastructure
- Appliquer systématiquement les **mises à jour** et activer la **journalisation**
- Former régulièrement les utilisateurs à la cybersécurité (phishing, comportement en ligne…)
- Utiliser une **authentification multifactorielle (MFA)** pour tous les accès sensibles
- Tester le **PRA/PCA** et chiffrer les sauvegardes critiques