# DMZ
## 📃 Introduction à la DMZ (zone démilitarisée)

Une **DMZ** (_Demilitarized Zone_) est un sous-réseau physique ou logique qui contient et expose les **services accessibles depuis l'extérieur** (Internet) tout en protégeant le réseau interne.

**Objectif :**

- Ajouter une **couche de sécurité supplémentaire**
- Isoler les services publics du réseau interne
- Contrôler les flux de données entre **Internet**, **DMZ**, et **réseau interne**

---

## 🛏️ Exemple de DMZ

- Un **serveur Web** d'entreprise placé dans une DMZ peut être **accessible depuis Internet**
- Si le serveur est compromis, l'attaquant n'a pas d'accès direct au réseau interne.

---

## 🔢 Avantages de la DMZ

- ✅ **Sécurité renforcée**
- ✅ **Segmentation du réseau**
- ✅ **Contrôle d'accès amélioré**
- ✅ **Protection contre la reconnaissance**
- ✅ **Conformité réglementaire**
- ✅ **Flexibilité pour les nouvelles technologies**
- ✅ **Prévention de l'usurpation d'adresse IP**
- ✅ **Tampon pour les services publics**

---

## 🔄 Impacts de la DMZ

- ⚠️ **Latence légèrement accrue**
- ⚠️ **Charge supplémentaire sur les pare-feux**
- ⚠️ **Complexité accrue du réseau**
- ⚠️ **Besoin de ressources supplémentaires**
- ⚠️ **Optimisation des flux de données**
- ⚠️ **Isolation des services publics**

---

## 🔧 Services typiques en DMZ

|Service|Rôle|
|---|---|
|**Serveur DNS**|Résolution de noms publics|
|**Serveur FTP**|Transfert de fichiers public|
|**Serveur de messagerie / Broker**|Relais de mails public / queue de messages|
|**Serveur Proxy**|Proxy inversé pour applications Web|
|**Serveur Web**|Présentation de contenus Internet|

---

## 🛡️ Les attaques informatiques (rappel)

**Motivations :**

- Gain financier
- Espionnage
- Sabotage / destruction
- Usurpation d'identité
- Vol d'informations sensibles

**Types :**

- **Virus / Vers / Trojans**
- **Ransomwares**
- **DDoS**
- **Phishing / Ingénierie sociale**
- **Man-in-the-middle**
- **Injection de code**
- **Modifications de site web**
- **Attaques sur réseaux Wi-Fi**

---

## 💡 Exemples d'attaques cyber notables

|Cas|Impact|
|---|---|
|**Yahoo (2013-2014)**|3 milliards de comptes compromis|
|**Home Depot (2014)**|56 millions de cartes de paiement|
|**MySpace (2013)**|360 millions de comptes piratés|
|**Microsoft Exchange (2021)**|30k entreprises US touchées|
|**Change Healthcare (2024)**|Ransomware sur systèmes de santé|
|**CDK Global (2024)**|Concessionnaires auto bloqués|
|**Ivanti VPN (2024)**|Vulnérabilités massivement exploitées|

---

## 🕵️️ Systèmes de détection et de prévention

### IDS / IPS

- **IDS** (_Intrusion Detection System_)
    - Surveille le trafic et signale les anomalies
- **IPS** (_Intrusion Prevention System_)
    - Bloque activement les activités malveillantes

### EDR / XDR / MDR

- **EDR** : Endpoint Detection & Response
- **XDR** : Extended Detection & Response
- **MDR** : Managed Detection & Response

### ZTNA

- **Zero Trust Network Access** : vérification stricte et continue de l'identité et des droits.

### Bastion

- Contrôle centralisé des accès privilégiés.
- Journalisation et audit des connexions sensibles.

---

## ✅ À retenir pour les révisions

- Une **DMZ (Demilitarized Zone)** est un sous-réseau isolé pour héberger les **services accessibles depuis Internet**
- La DMZ protège le **réseau interne** en cas de compromission des services exposés
- Les flux doivent être strictement contrôlés entre :
    - **Internet ↔ DMZ**
    - **DMZ ↔ Réseau interne (LAN)**
- Les **services typiques** en DMZ :
    - **Serveur Web**
    - **Serveur DNS public**
    - **Serveur FTP**
    - **Serveur de messagerie en relais**
    - **Proxy inversé**
- La DMZ est un élément clé de la **défense en profondeur**
- Les flux autorisés doivent être documentés dans une **matrice de flux**
- Surveillance indispensable via des solutions type **IDS/IPS** → détection des tentatives d’intrusion

---

## 📌 Bonnes pratiques professionnelles

- **Segmenter** physiquement ou logiquement la DMZ
- Appliquer des **pare-feux stricts** entre DMZ et LAN interne
- Contrôler finement les flux entrants et sortants
- Surveiller les journaux de sécurité de la DMZ
- Mettre en place un **IDS/IPS** adapté
- Mettre à jour régulièrement les systèmes exposés

---

## ⚠️ Pièges à éviter

- **Conception floue** de la DMZ (ex : une "fausse" DMZ mal isolée)
- Autoriser des **connexions non nécessaires** vers le LAN interne
- Oublier la **supervision** de la DMZ
- Exposer inutilement des services obsolètes ou non maintenus

---

## ✅ Commandes utiles (diagnostic DMZ)

### Sur les pare-feux (pfSense / Linux / Windows Firewall)

```bash
# Vérifier les flux entre zones (pfSense)
pfctl -sr | grep dmz

# Sur Linux : tracer les flux (DMZ vers Internet)
sudo iptables -L -v -n | grep dmz

# Vérification des logs IDS/IPS
cat /var/log/suricata/fast.log
```

### Test réseau DMZ

```bash
# Vérifier l'accessibilité d'un service exposé (exemple HTTP)
curl -I http://ip_publique_service_dmz

# Scanner de ports (depuis un hôte de contrôle)
nmap -Pn ip_publique_service_dmz
```
