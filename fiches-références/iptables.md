# iptables (pare-feu Linux)

## 📌 Présentation

`iptables` est l’outil en ligne de commande qui permet de configurer le pare-feu netfilter sous Linux. Il fonctionne via des règles organisées en chaînes et tables, pour contrôler le trafic réseau entrant, sortant ou traversant le système.

---

## 🧱 Principes de base

- **Table** : ensemble de chaînes (ex : `filter`, `nat`, `mangle`)
- **Chaîne** : ensemble de règles (ex : `INPUT`, `OUTPUT`, `FORWARD`)
- **Règle** : action à appliquer si les conditions sont remplies (ACCEPT, DROP, REJECT…)

---

## 📊 Tables principales

| Table | Usage |
|-------|-------|
| `filter` | Par défaut, pour autoriser ou bloquer du trafic |
| `nat` | Traduction d’adresse (NAT, DNAT, SNAT) |
| `mangle` | Modification avancée des paquets (QoS, TTL…) |

---

## 🧰 Commandes de base

| Commande | Description | Exemple |
|----------|-------------|---------|
| `iptables -L -v` | Liste les règles avec détails |
| `iptables -F` | Vide toutes les règles |
| `iptables -A INPUT -p tcp --dport 22 -j ACCEPT` | Autorise SSH en entrée |
| `iptables -A INPUT -s 192.168.1.100 -j DROP` | Bloque un hôte spécifique |
| `iptables -A INPUT -i lo -j ACCEPT` | Autorise la boucle locale (loopback) |
| `iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT` | Autorise les connexions déjà établies |
| `iptables -P INPUT DROP` | Politique par défaut : tout bloquer |

---

## 🗃️ Sauvegarder & restaurer la configuration

```bash
# Debian/Ubuntu
sudo iptables-save > /etc/iptables/rules.v4
sudo iptables-restore < /etc/iptables/rules.v4
```

---

## 🔎 Cas d’usage courant

- Protéger un serveur Linux exposé à Internet
- Restreindre les ports autorisés à une liste IP donnée
- Empêcher certains types de paquets (ICMP, ping, scans…)
- Implémenter un pare-feu interne sur une passerelle Linux

---

## ⚠️ Erreurs fréquentes

- Oublier d’autoriser le port SSH → perte d’accès distant
- Mauvais ordre des règles (la première qui matche s’applique)
- Oublier de rendre les règles persistantes après redémarrage
- Confusion entre `DROP` (silencieux) et `REJECT` (réponse envoyée)

---

## ✅ Bonnes pratiques

- Toujours commencer par autoriser SSH avant de restreindre (sinon coupure)
- Définir une **politique par défaut stricte** (`DROP`) et **ajouter des exceptions explicites**
- Sauvegarder régulièrement les règles (`iptables-save`)
- Utiliser des commentaires dans les scripts de configuration
- Tester les règles dans un environnement local avant un déploiement serveur

---

## 📚 Ressources complémentaires

- `man iptables`, `iptables --help`
- [Iptables Tutorial (netfilter.org)](https://www.netfilter.org/documentation/HOWTO/packet-filtering-HOWTO.html)