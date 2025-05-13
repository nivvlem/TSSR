# Découverte et installation de serveurs web
## 🌐 Qu’est-ce qu’un serveur web ?

Un serveur web est un service hébergé sur un réseau (intranet ou Internet) permettant de :

- Répondre à des requêtes HTTP ou HTTPS via un navigateur web
- Héberger des contenus web statiques (HTML/CSS) ou dynamiques

### Serveurs web les plus répandus :

- **Apache HTTP Server**
- **NGINX (EngineX)**
- **IIS (Internet Information Services)**

### Accès à un site web : 3 modes

- Par **adresse IP**
- Par **port spécifique**
- Par **nom d’hôte (FQDN)** + résolution DNS

---

## 🔄 Fonctionnement général

1. L’utilisateur saisit une URL (ex : [https://nivvlem.github.io/TSSR/#/](https://nivvlem.github.io/TSSR/#/))
2. Le navigateur interroge un serveur DNS pour résoudre le FQDN en adresse IP
3. Il envoie une requête HTTP (`GET /index.html`)
4. Le serveur web interprète la requête, sélectionne le site (vhost)
5. Il renvoie un **statut HTTP** + le contenu de la page
6. Le navigateur affiche la réponse

---

## 🔐 Certificats numériques (SSL/TLS)

Un **certificat** est l’équivalent d’une **carte d’identité numérique**, contenant :

- N° de série
- Nom du titulaire de la clé publique (FQDN)
- Période de validité
- Algorithme de chiffrement + clé publique
- Signature de l’autorité de certification (CA)

### Utilité :

- Authentifier un serveur web
- Garantir la confidentialité et l’intégrité des données

---

## ✅ Connexion HTTPS (HTTP sécurisé)

- Utilise **TLS** (anciennement SSL) pour chiffrer les échanges
- Nécessite un **certificat valide** présenté par le serveur
- Validé par une **autorité de certification** connue du navigateur
- Présence du **cadenas** dans la barre d’adresse = certificat accepté

---

## 🧾 Obtenir un certificat : 3 options

|Méthode|Avantages|Inconvénients|
|---|---|---|
|**Autosigné**|Gratuit, rapide|Non reconnu par les navigateurs|
|**CA interne**|Adapté aux intranets|Nécessite gestion de l’AC|
|**CA publique** (Let’s Encrypt, etc.)|Reconnu partout|Parfois payant ou durée limitée|

---

## 🔐 Chaîne de certification (PKI)

1. Le **navigateur** fait une requête vers le serveur (ex : `https://www.monsite.fr`)
2. Le **serveur web** présente son certificat SSL/TLS
3. Le navigateur valide la **chaîne de certification** :
    - L’autorité racine est-elle connue et de confiance ?
    - Le certificat est-il valide (non expiré, domaine correct, non révoqué) ?
4. Si oui → le **canal HTTPS est établi** (chiffré)

---

## 📜 Historique SSL/TLS

|Version|Date|Remarques|
|---|---|---|
|SSL 1.0|1994|Jamais publié|
|SSL 2.0|1995|Obsolète|
|SSL 3.0|1996|Ancien standard, vulnérable|
|TLS 1.0|1999|Successeur de SSL 3.0|
|TLS 1.1|2006|Obsolète|
|TLS 1.2|2008|Standard sécurisé courant|
|TLS 1.3|2018|Version actuelle recommandée|

> SSL est désormais **déprécié**. Toujours préférer **TLS 1.2 ou 1.3**.

---

## ✅ À retenir pour les révisions

- Un serveur web répond à des requêtes HTTP/HTTPS pour fournir du contenu
- L’accès peut se faire par IP, port ou nom d’hôte (via DNS)
- Un certificat **authentifie** un serveur et **chiffre** les communications
- Le protocole **TLS** garantit : **authentification, confidentialité, intégrité**
- Toujours utiliser **TLS 1.2 ou supérieur** en production

---

## 📌 Bonnes pratiques professionnelles

- Utiliser des **certificats signés par des autorités reconnues** (Let’s Encrypt…)
- **Désactiver les protocoles SSL et TLS < 1.2**
- Automatiser le renouvellement des certificats (cron + certbot)
- Séparer les sites par **vhost** pour meilleure sécurité et isolation
- Documenter les ports ouverts, chemins de configuration, procédures SSL