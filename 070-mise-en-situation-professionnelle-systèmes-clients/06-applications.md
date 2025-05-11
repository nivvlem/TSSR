# Mise en situation professionnelle : Systèmes clients

## Installation d’applications
## 🧱 Objectif

Installer et configurer les applications nécessaires au bon fonctionnement des deux postes clients, avec une attention particulière portée à l’automatisation (installation silencieuse) et à la compatibilité (client RDP NLA). Permettre aussi une gestion distante via une interface web sur Debian (Webmin).

---

## 🪟 Windows 10 – Installation silencieuse de 7-Zip

### 📄 Objectif

Installer **7-Zip** en mode **silencieux**, c’est-à-dire sans intervention de l’utilisateur, sans assistant visible.

### 📦 ISO du logiciel

Chemin : `\\10.0.0.6\Distrib\logiciels\applications\7zip`

### 🔧 Étapes :

1. Copier le `.exe` localement (ex: `7z1900-x64.exe`)
2. Lancer l’installation avec l’option `/S`

```powershell
Start-Process -FilePath "7z1900-x64.exe" -ArgumentList "/S" -Wait
```

> 🔕 `/S` = Silent mode (aucune interaction)

### ✅ Vérification

- Le programme est présent dans `C:\Program Files\7-Zip`
- Icône accessible dans le menu démarrer

---

## 🐧 Debian 10 – Client RDP compatible NLA

### 📄 Objectif

Permettre la connexion à un poste Windows (avec NLA activé) depuis Debian, via une interface **graphique**.

### ❌ Clients à éviter

- `rdesktop`, `vinagre`, `freerdp` : incompatibilités fréquentes avec NLA

### ✅ Client recommandé : **Remmina**

### 🔧 Installation

```bash
sudo apt update
sudo apt install remmina remmina-plugin-rdp -y
```

> 💡 Remmina est un client RDP, VNC, SSH avec interface graphique moderne, compatible NLA

### ✅ Connexion

1. Lancer Remmina (`remmina`)
2. Créer une nouvelle connexion RDP vers l’IP de `W10-Binôme`
3. Authentification NLA → activer
4. Vérifier l’ouverture de session avec compte utilisateur autorisé

---

## 🐧 Debian 10 – Installation de Webmin

### 📄 Objectif

Permettre la gestion de Debian via une **interface web d’administration** complète et sécurisée.

### 🔧 Étapes :

1. Ajouter le dépôt Webmin à `sources.list`

```bash
echo "deb http://download.webmin.com/download/repository sarge contrib" | sudo tee /etc/apt/sources.list.d/webmin.list
```

2. Importer la clé GPG :

```bash
wget -qO - http://www.webmin.com/jcameron-key.asc | sudo apt-key add -
```

3. Mettre à jour + installer Webmin :

```bash
sudo apt update
sudo apt install webmin -y
```

### 🔐 Accès sécurisé via HTTPS

- Par défaut, Webmin écoute sur le port **10000** :

```bash
https://<IP_DEB10>:10000
```

> Le navigateur affichera une alerte liée au certificat autosigné (normal)

### 👤 Connexion

- Utiliser un **compte ayant des droits sudo/root**

---

## ✅ Résumé des validations

|Élément|Action / Résultat attendu|
|---|---|
|7-Zip installé en silencieux|Pas d’interface visible, programme installé|
|Client RDP Debian opérationnel|Connexion à Windows 10 via Remmina (NLA OK)|
|Webmin installé|Accessible via navigateur HTTPS:10000|
|Connexion à Webmin|Accès avec compte admin Debian|
