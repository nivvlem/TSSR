# DNS Résolveur (Linux / BIND9)

## 🌐 Rôle et fonctionnement du DNS

Le **DNS (Domain Name System)** permet :

- de convertir un **FQDN** (ex : [www.google.com](http://www.google.com)) en adresse IP,
- de retrouver un **nom d’hôte** à partir d’une IP (recherche inverse),
- de localiser les **serveurs de messagerie** d’un domaine (MX records).

### 🔹 Types de serveurs DNS

|Type de serveur|Rôle|
|---|---|
|Résolveur complet|Résout toute requête client, fait appel aux serveurs racines|
|Autorité|Source officielle d’un domaine, contient les enregistrements|
|Redirecteur (forwarder)|Reçoit des requêtes récursives et les transmet|

### 🔹 Mécanismes

- Les requêtes sont **itératives** ou **récursives** selon les cas
- Un serveur résolveur **met en cache** les réponses pour améliorer les performances

---

## 🛠️ Mise en place d’un DNS résolveur avec BIND9

### 🔹 Paquet à installer

```bash
sudo apt install bind9 bind9-utils bind9-doc
```

### 🔹 Fichiers de configuration principaux

|Fichier|Description|
|---|---|
|`/etc/bind/named.conf`|Fichier principal (inclusion d’autres)|
|`/etc/bind/named.conf.options`|Configuration générale (DNS récursif, cache)|
|`/etc/bind/named.conf.local`|Zones spécifiques définies par l’administrateur|
|`/etc/bind/named.conf.default-zones`|Zones par défaut (racines, localhost...)|

### 🔹 Exemple minimal dans `named.conf.options`

```bash
options {
  directory "/var/cache/bind";
  recursion yes;
  allow-query { any; };
  forwarders {
    9.9.9.9;
    1.1.1.1;
  };
};
```

> ✅ Cette configuration permet à BIND9 d’agir comme **DNS résolveur avec redirecteur**.

---

## 🔍 Outils de vérification

### 🔹 Syntaxe et zones

```bash
named-checkconf                  # vérifie la syntaxe des fichiers
named-checkzone example.com db.example.com  # vérifie la validité d’une zone
```

### 🔹 Commandes de tests

```bash
dig www.google.com @127.0.0.1
nslookup ftp.fr.debian.org
```

### 🔹 Logs

- Fichier principal : `/var/log/syslog`

```bash
tail -f /var/log/syslog | grep named
```

---

## ✅ À retenir pour les révisions

- Le serveur **BIND9** agit comme résolveur en configurant correctement `named.conf.options`
- On peut utiliser **des redirecteurs (forwarders)** pour améliorer la rapidité de résolution
- La **structure DNS est hiérarchique et arborescente**
- Les fichiers sont tous inclus depuis `named.conf`
- `dig` permet de tester une requête en spécifiant le DNS utilisé (ex : `@127.0.0.1`)

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Ne pas faire tourner BIND9 inutilement comme autorité|Réduire l’exposition et simplifier la config|
|Limiter les requêtes avec `allow-query` ou `ACL`|Sécuriser l’accès au résolveur interne|
|Tester chaque configuration avec `named-checkconf`|Éviter un plantage du service au redémarrage|
|Utiliser des redirecteurs fiables (ex : Quad9, Cloudflare)|Rapidité et confidentialité améliorées|
|Surveiller les logs DNS|Détecter les échecs de résolution ou attaques DNS|
