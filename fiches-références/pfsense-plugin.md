# Plugins pfSense (extensions système)

## 📌 Présentation

**pfSense** dispose d’un système de paquets (plugins) permettant d’étendre ses fonctionnalités : surveillance réseau, antivirus, proxy, VPN, pare-feu applicatif, etc. Les plugins s’installent facilement depuis l’interface web et apportent des modules spécialisés pour répondre à des besoins avancés.

---

## 📦 Installation d’un plugin

1. Aller dans **System > Package Manager > Available Packages**
2. Chercher le nom du plugin
3. Cliquer sur **Install**, puis **Confirm**
4. Accès via le menu ou dans **Services** / **Status** / **Diagnostics**

---

## 🔧 Plugins recommandés (sélection TSSR/ASR)

### 🔍 `pfBlockerNG`

- Filtrage DNS/IP (géoblocage, antimalware, publicités)
- Extension puissante pour bloquer des plages IP ou domaines nuisibles
- **Cas d’usage** : sécurisation avancée, protection enfants, blocage géopolitique

### 🔐 `openvpn-client-export`

- Ajoute une interface pour exporter facilement les clients VPN OpenVPN
- Génère des fichiers `.ovpn`, archives Zip ou installateurs pour Windows/macOS

### 🧪 `ntopng`

- Supervision réseau en temps réel (trafic, IP, protocoles, ports, utilisateurs…)
- Interface riche avec statistiques, top utilisateurs, alertes

### 📊 `nmap`

- Intégration de l’outil d’analyse réseau Nmap directement dans pfSense
- Scan des ports, détection des hôtes actifs, découverte de services

### 🧱 `suricata` ou `snort`

- Systèmes de détection/prévention d’intrusion (IDS/IPS)
- Analyse du trafic en profondeur, blocage de signatures connues (malwares, scans…)
- **Suricata** recommandé (plus moderne et performant)

### 🧭 `Zabbix-agent`

- Permet de superviser pfSense depuis une console Zabbix externe

### 📈 `BandwidthD`

- Suivi du trafic IP par utilisateur, avec graphique
- Utile pour les petites structures ou en environnement scolaire

---

## ⚠️ Erreurs fréquentes

- Installer trop de plugins → surcharge CPU/RAM
- Ne pas configurer les règles associées (ex : Suricata sans interfaces activées)
- Mauvais ordre d’activation des règles de filtrage (ex : DNS surchargé par pfBlocker)
- Oublier de redémarrer certains services après installation

---

## ✅ Bonnes pratiques

- N’installer que les plugins utiles à ton environnement
- Lire la documentation officielle de chaque plugin après installation
- Tester en environnement isolé avant mise en production
- Sauvegarder pfSense (Diagnostics > Backup) avant chaque installation
- Utiliser les plugins **Suricata + pfBlockerNG** pour sécuriser efficacement une DMZ ou réseau utilisateur

---

## 📚 Ressources complémentaires

- [pfSense Plugins Guide](https://docs.netgate.com/pfsense/en/latest/packages/index.html)
- [pfBlockerNG Dev Documentation](https://docs.netgate.com/pfsense/en/latest/packages/pfblocker.html)
- Forums : [https://forum.netgate.com](https://forum.netgate.com)
