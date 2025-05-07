# TP – Se connecter à un système Linux via PuTTY

## 🧩 Pré-requis

- Disposer des machines virtuelles Windows 10 et Linux-Mini-CEL
- Avoir configuré la carte réseau des VMs en mode **Bridged**

---

## 🧱 Étapes détaillées

### 🔽 1. Importer la VM Linux

1. Télécharger le fichier `Linux-Mini-CEL.ova` depuis le SharePoint fourni.
2. Ouvrir **VMware Workstation**.
3. Aller dans `File > Open` ou utiliser `Ctrl + o`.
4. Sélectionner le fichier `.ova` téléchargé.
5. Choisir un répertoire d’importation (ex : `D:\LinuxVM\`)
6. Laisser l’importation se terminer complètement.

### ▶️ 2. Démarrer la VM Linux

1. Cliquer sur le bouton **Start** de VMware Workstation.
2. Attendre l’apparition de l’écran de connexion.
3. Noter l’adresse **IP affichée dans la console** de la VM Linux.

### 🖥️ 3. Installer PuTTY sur la VM Windows

1. Télécharger `putty.exe` :  
    [https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe](https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe)
2. Lancer l’installation classique sous Windows.

### 🌐 4. Vérifier la connectivité

1. Depuis la VM Windows 10, ouvrir `cmd.exe`
2. Taper la commande :

```bash
ping 10.107.200.20
```

3. Si réponse, la connectivité est fonctionnelle ✅

### 🔐 5. Paramétrer PuTTY

1. Lancer PuTTY.
2. Dans **Host Name**, entrer l’adresse IP de la VM Linux.
3. Protocole : SSH (port 22)
4. (Optionnel) Enregistrer la session :
    - Taper un nom dans `Saved Sessions`
    - Cliquer sur **Save**
5. Cliquer sur **Open** pour lancer la session.

### 💻 6. Se connecter au système Linux

1. Lors de la connexion SSH, accepter le message de sécurité (empreinte).
2. Entrer les **identifiants fournis** (login + mot de passe).
3. Une fois connecté, le **prompt** Bash doit s'afficher :

```bash
user@linux:~$
```

---

## ✅ À retenir pour les révisions

- `Bridged` permet à chaque VM d’obtenir une IP dans le réseau local.
- `ping` permet de tester la connectivité réseau.
- PuTTY est un client SSH pour Windows léger et pratique.
- SSH est un protocole sécurisé de communication à distance.

---

## 📌 Bonnes pratiques professionnelles

- Toujours noter l’IP de la machine distante lors de la connexion.
- Nommer et sauvegarder les sessions dans PuTTY.
- Fermer proprement les connexions (`exit` ou `Ctrl+D`).
- Ne jamais exposer une VM inutilement au réseau sans pare-feu.
- Vérifier systématiquement la configuration réseau avant test.

