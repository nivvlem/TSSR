# Mise en situation professionnelle : Services réseau

## Domaine AD

## 💡 1. Préparation du serveur SRV-AD-MD

### Renommage

Dans PowerShell :

```powershell
Rename-Computer -NewName "SRV-AD-MD" -Restart
```

### Configuration IP

- IP : `192.168.55.101`
- Masque : `255.255.255.0`
- Passerelle : `192.168.55.254`
- DNS primaire : `192.168.55.101` (auto-référencement AD)

> Important : le serveur AD doit **se résoudre lui-même** pour fonctionner correctement.

---

## 🛠 2. Installation des services AD DS et DNS

### Via PowerShell :

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

---

## 🏢 3. Promotion en contrôleur de domaine

### Lancer l’assistant de promotion

1. **Gestionnaire de serveur** > Notification > **Promouvoir ce serveur en contrôleur de domaine**.
2. Choisir : **Ajouter une nouvelle forêt**.
3. Nom de domaine racine : `melvin13.domaine.tssr`
4. Niveaux fonctionnels : `Windows Server 2016`
5. Mot de passe DSRM : `*********`
6. Valide et redémarre le serveur.

---

## 🚧 4. Analyse de la zone DNS AD

Dans la console DNS (SRV-AD-MD) :

- Une nouvelle zone `melvin13.domaine.tssr` a été créée automatiquement.
- Elle contient :
    - Enregistrements SRV (LDAP, Kerberos)
    - Nom de la machine, DC, GC, etc.

> Ces entrées sont indispensables au bon fonctionnement de l’annuaire AD.

---

## 🔗 5. Redirecteur conditionnel sur SRV-SVC-MD

Pour que le DNS interne (`SRV-SVC-MD`) puisse résoudre les noms du domaine `melvin13.domaine.tssr` :

1. Sur `SRV-SVC-MD`, ouvrir la console **DNS**.
2. Clic droit sur le serveur > **Propriétés** > onglet **Redirecteurs conditionnels**.
3. Ajouter :
    - Zone : `melvin13.domaine.tssr`
    - Serveur cible : `192.168.55.101`

---

## 📁 6. Intégration des machines au domaine

### Windows Client (CLT-WIN-MD)

1. **Paramètres système** > Nom de l'appareil > Modifier.
2. Choisir **Domaine** > `melvin13.domaine.tssr`
3. Entrer les identifiants admin du domaine (Administrator).
4. Redémarrer.

### Serveur SRV-SVC-MD

Même procédure pour le rattacher au domaine.

> Le domaine doit être résolu correctement par les DNS configurés.

### Test de jonction :

```powershell
nltest /dsgetdc:melvin13.domaine.tssr
```

---

## ⚖️ Bonnes pratiques

- Toujours utiliser une adresse DNS **pointant sur le serveur AD** avant de joindre un domaine.
- S'assurer que le nom NETBIOS et le FQDN soient cohérents.
- Ne pas rediriger de flux DNS externes depuis le contrôleur de domaine directement.

---

## 📄 Synthèse

|Composant|Valeur|
|---|---|
|Domaine AD|melvin13.domaine.tssr|
|Contrôleur|SRV-AD-MD (192.168.55.101)|
|DNS principal|SRV-AD-MD|
|Redirecteur DNS|SRV-SVC-MD → vers SRV-AD-MD|
|Machines liées|CLT-WIN-MD, SRV-SVC-MD|
