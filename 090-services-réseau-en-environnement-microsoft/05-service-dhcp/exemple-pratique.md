# TP 1 à 3 – Service DHCP : Mise en œuvre, réseaux et haute disponibilité

## ✅ TP 1 : Mise en place du service DHCP

### 🔹 Plan d’adressage (VmNet10)

- **Plage DHCP** : 192.168.10.50 à 192.168.10.149 (/24)
- **Réservations serveur** : 192.168.10.1 à 192.168.10.20

### 🔹 Étapes

1. Installer le rôle DHCP sur SRV-2K19

```powershell
Install-WindowsFeature -Name DHCP -IncludeManagementTools
Add-DhcpServerInDC -DnsName SRV-2K19 -IpAddress 192.168.10.1
```

2. Créer l’étendue :

```powershell
Add-DhcpServerv4Scope -Name "VMNET10" -StartRange 192.168.10.50 -EndRange 192.168.10.149 -SubnetMask 255.255.255.0
```

3. Ajouter exclusions (pour les serveurs IP fixes) :

```powershell
Add-DhcpServerv4ExclusionRange -ScopeId 192.168.10.0 -StartRange 192.168.10.1 -EndRange 192.168.10.20
```

4. Ajouter une réservation (poste client 2)

```powershell
Add-DhcpServerv4Reservation -ScopeId 192.168.10.0 -IPAddress 192.168.10.50 -ClientId "MAC-ADRESSE" -Description "CLI-02"
```

5. Côté client (CLI-01 ou CLI-02) :

```powershell
ipconfig /release
ipconfig /renew
ipconfig /all
```

✔️ Le bail s’obtient avec adresse, masque, passerelle, DNS…

---

## ✅ TP 2 : DHCP et domaines de diffusion multiples

### 🔹 Topologie

- **SRV-2K19-0** : 192.168.0.1 (réseau VMNET10)
- **SRV-2K19-1** : 192.168.1.1 (réseau VMNET11)
- **RTR-00** : 192.168.0.254
- **RTR-01** : 192.168.1.254

### 🔹 Étendue sur SRV-2K19-0

```powershell
Add-DhcpServerv4Scope -Name "VMNET10" -StartRange 192.168.0.100 -EndRange 192.168.0.200 -SubnetMask 255.255.255.0
Add-DhcpServerv4Scope -Name "VMNET11" -StartRange 192.168.1.100 -EndRange 192.168.1.200 -SubnetMask 255.255.255.0
```

- Cela permet à un même serveur de fournir des IP dans 2 domaines de diffusion distincts

### 🔹 Configuration du relais DHCP sur pfSense (RTR-00, RTR-01)

- **Services > DHCP Relay**
- Interface LAN : activée
- IP cible : IP du serveur DHCP (SRV-2K19-0 ou 1 selon le relais)

### 🔹 Test

- Démarrer les clients sur VMNET10 et VMNET11 avec config IP automatique
- Vérifier qu’ils reçoivent bien une IP dans la plage de leur réseau

✔️ Résultat : chaque client reçoit une IP correcte depuis un serveur distant via le **DHCP relay**

---

## ✅ TP 3 : Haute disponibilité DHCP avec Failover

### 🔹 Objectif

Mettre en place la **fonction Failover** entre deux serveurs DHCP (SRV-2K19-0 et SRV-2K19-1)

### 🔹 Création du partenariat (failover)

Sur SRV-2K19-0 (dans DHCP MMC) :

- Clic droit sur l’étendue > Configurer le partenariat failover
- Choisir le serveur partenaire : `SRV-2K19-1`
- Mode : **Load Balance** ou **Hot Standby** (selon la tolérance souhaitée)
- Synchroniser l’étendue

> 🔁 La configuration est automatiquement dupliquée côté SRV-2K19-1

### 🔹 Tests de bascule

- Arrêter le service DHCP sur SRV-2K19-0 :

```powershell
Stop-Service dhcpserver
```

- Lancer un client : il reçoit une IP depuis SRV-2K19-1 ✔️
- Relancer SRV-2K19-0 :

```powershell
Start-Service dhcpserver
```

- Le client suivant reçoit à nouveau son bail depuis le serveur principal ✔️

---

## 🧠 À retenir pour les révisions

- Un serveur DHCP peut gérer plusieurs étendues dans plusieurs réseaux si les relais sont configurés
- La **réservation** permet d’attribuer toujours la même IP à un client donné (via sa MAC)
- Le **DHCP Relay** transmet les requêtes DORA entre domaines de diffusion
- Le **Failover DHCP** offre de la redondance et évite les interruptions de service

---

## 📌 Bonnes pratiques professionnelles

|Pratique|Pourquoi ?|
|---|---|
|Planifier les plages et exclusions|Éviter les conflits IP|
|Réserver les IP des équipements critiques|Ne jamais risquer un changement d’IP serveur ou imprimante|
|Activer l’audit DHCP|Suivre l’attribution des IPs|
|Tester avec `ipconfig /renew`|Vérifier que les bons paramètres sont délivrés|
|Mettre en place un failover DHCP|Maintien de service sans intervention manuelle|
