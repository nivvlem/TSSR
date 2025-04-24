# TP – Configurer un serveur DNS résolveur avec BIND9 (Debian)

## 🧪 Étape 1 – Installation et configuration initiale du service DNS sur DEB-S2

### 🔹 Installation du service BIND9

```bash
apt update && apt install bind9 bind9-utils bind9-doc
```

### 🔹 Configuration principale : `/etc/bind/named.conf.options`

```bash
options {
  directory "/var/cache/bind";
  recursion yes;
  allow-query { any; };
  allow-recursion {
    172.18.100.0/24;
    192.168.100.0/24;
  };
  dnssec-validation no;
};
```

> ✅ Cette configuration autorise la résolution récursive pour les machines internes et désactive DNSSEC.

### 🔹 Vérifications

```bash
named-checkconf             # Vérifie la syntaxe
rndc reload                  # Recharge la config
systemctl restart bind9     # Redémarrage du service
```

---

## 🧩 Étape 2 – Configuration des clients pour utiliser le serveur DNS

### 🔹 Poste : CLI-DB-12

```bash
apt install dnsutils
```

Modifier `/etc/resolv.conf` :

```bash
nameserver 192.168.100.12    # Adresse IP de DEB-S2
```

### 🔹 Serveurs DEB-S1, DEB-S2, RouTux

Modifier `/etc/resolv.conf` sur chacun :

```bash
nameserver 192.168.100.12
```

---

## 🔍 Étape 3 – Tests de résolution DNS

### 🔹 Depuis la machine physique et CLI-DB-12

```bash
dig www.isc.org @192.168.100.12
dig www.yahoo.fr @192.168.100.12
```

> 💡 À ce stade, les résolutions se font via les **serveurs racines**, car aucun redirecteur n’est encore configuré. Le fichier `root.hints` de BIND est utilisé automatiquement.

---

## 🔄 Étape 4 – Ajout d’un redirecteur DNS (forwarder)

### 🔹 Modification de `/etc/bind/named.conf.options`

```bash
options {
  directory "/var/cache/bind";
  recursion yes;
  allow-query { any; };
  allow-recursion {
    172.18.100.0/24;
    192.168.100.0/24;
  };
  dnssec-validation no;
  forwarders {
    9.9.9.9;
    1.1.1.1;
  };
};
```

### 🔹 Redémarrage du service

```bash
named-checkconf
rndc reload
rndc flush
```

> ✅ Le cache DNS est vidé pour forcer une nouvelle résolution via les redirecteurs configurés.

---

## ✅ Vérifications finales

- Le serveur DEB-S2 répond bien aux requêtes `dig` depuis CLI-DB-12, DEB-S1, RouTux
- Les noms de domaine publics sont résolus avec les redirecteurs spécifiés (et non via root.hints)
- La résolution est **plus rapide** grâce au cache et aux redirecteurs fiables (Quad9, Cloudflare)

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Restreindre les IP autorisées à interroger|Éviter l’ouverture publique du DNS à Internet|
|Toujours tester avec `named-checkconf` avant reload|Éviter les interruptions dues à une erreur de syntaxe|
|Désactiver DNSSEC si non utilisé|Éviter des erreurs de validation ou lenteurs inutiles|
|Documenter les IP des serveurs DNS dans `/etc/resolv.conf`|Maintenir une cohérence réseau et facilité de maintenance|
|Surveiller les logs (`syslog`, `journalctl -u bind9`)|Détecter anomalies ou erreurs de configuration DNS|
