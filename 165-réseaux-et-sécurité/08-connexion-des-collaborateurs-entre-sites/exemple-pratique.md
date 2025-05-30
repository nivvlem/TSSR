# 🛡️ TP - Connecter les collaborateurs Site à Site (VPN IPsec)
## 🛠️ 1. Configuration du VPN IPsec
### 🔸 1.1 Création de la **Phase 1 (IKE)**

#### Sur pfSense-A :

1. Aller dans le menu **VPN > IPsec > Tunnels**.
2. Cliquer sur **Add P1** pour ajouter une nouvelle phase 1.
3. Configurer les paramètres suivants :

| Paramètre             | Valeur                                              |
| --------------------- | --------------------------------------------------- |
| Key Exchange Version  | IKEv2                                               |
| Internet Interface    | WAN                                                 |
| Remote Gateway        | Adresse IP publique de pfSense-B                    |
| Authentication Method | Mutual PSK                                          |
| Pre-Shared Key        | `MaCléSecrètePerso123&)` (exemple, à personnaliser) |
| Encryption Algorithm  | AES-256                                             |
| Hash Algorithm        | SHA256                                              |
| DH Group              | 14 (2048 bits)                                      |

4. Cliquer sur **Save** et **Apply Changes**.

#### Sur pfSense-B :

1. Aller dans le menu **VPN > IPsec > Tunnels**.
2. Cliquer sur **Add P1** pour ajouter une nouvelle phase 1.
3. Configurer les paramètres suivants :

| Paramètre             | Valeur                                        |
| --------------------- | --------------------------------------------- |
| Key Exchange Version  | IKEv2                                         |
| Internet Interface    | WAN                                           |
| Remote Gateway        | Adresse IP publique de pfSense-A              |
| Authentication Method | Mutual PSK                                    |
| Pre-Shared Key        | Même que pfSense-A : `MaCléSecrètePerso123&)` |
| Encryption Algorithm  | AES-256                                       |
| Hash Algorithm        | SHA256                                        |
| DH Group              | 14 (2048 bits)                                |

4. Cliquer sur **Save** et **Apply Changes**.

---

### 🔸 1.2 Configuration de la **Phase 2 (ESP)**

#### Sur pfSense-A :

1. Dans le tunnel IPsec créé, cliquer sur **Show Phase 2 Entries**.
2. Cliquer sur **Add P2**.
3. Configurer les paramètres suivants :

|Paramètre|Valeur|
|---|---|
|Local Network|`192.168.10.0/24`|
|Remote Network|`192.168.20.0/24`|
|Encryption Algorithm|AES-256|
|Hash Algorithm|SHA256|
|PFS Key Group|14|

4. Cliquer sur **Save** et **Apply Changes**.

#### Sur pfSense-B :

1. Dans le tunnel IPsec créé, cliquer sur **Show Phase 2 Entries**.
2. Cliquer sur **Add P2**.
3. Configurer les paramètres suivants :

|Paramètre|Valeur|
|---|---|
|Local Network|`192.168.20.0/24`|
|Remote Network|`192.168.10.0/24`|
|Encryption Algorithm|AES-256|
|Hash Algorithm|SHA256|
|PFS Key Group|14|

4. Cliquer sur **Save** et **Apply Changes**.

---

## 🛡️ 2. Configuration des règles de pare-feu
### 🔸 2.1 Autoriser le trafic **IPsec**

#### Sur pfSense-A :

1. Aller dans le menu **Firewall > Rules > IPsec**.
2. Cliquer sur **Add**.
3. Configurer les paramètres suivants :

|Champ|Valeur|
|---|---|
|Action|Pass|
|Protocol|Any|
|Source|`192.168.10.0/24`|
|Destination|`192.168.20.0/24`|

4. Cliquer sur **Save** et **Apply Changes**.

#### Sur pfSense-B :

1. Aller dans le menu **Firewall > Rules > IPsec**.
2. Cliquer sur **Add**.
3. Configurer les paramètres suivants :

|Champ|Valeur|
|---|---|
|Action|Pass|
|Protocol|Any|
|Source|`192.168.20.0/24`|
|Destination|`192.168.10.0/24`|

4. Cliquer sur **Save** et **Apply Changes**.

---

### 🔸 2.2 Autoriser le trafic entre **LAN** et **VPN**

#### Sur pfSense-A :

1. Aller dans **Firewall > Rules > LAN**.
2. Cliquer sur **Add**.
3. Créer une règle pour permettre le trafic vers `192.168.20.0/24`.

|Champ|Valeur|
|---|---|
|Action|Pass|
|Protocol|Any|
|Source|`192.168.10.0/24`|
|Destination|`192.168.20.0/24`|

4. Cliquer sur **Save** et **Apply Changes**.

#### Sur pfSense-B :

1. Aller dans **Firewall > Rules > LAN**.
2. Cliquer sur **Add**.
3. Créer une règle pour permettre le trafic vers `192.168.10.0/24`.

|Champ|Valeur|
|---|---|
|Action|Pass|
|Protocol|Any|
|Source|`192.168.20.0/24`|
|Destination|`192.168.10.0/24`|

4. Cliquer sur **Save** et **Apply Changes**.

---

## 🛠️ 3. Tests de validation
### 🔸 3.1 Vérification de l’état du tunnel

1. Aller dans le menu **Status > IPsec**.
2. Vérifier que le tunnel est **Established / Connected**.

---

### 🔸 3.2 Test de connectivité inter-sites

1. Depuis une machine sur le LAN de pfSense-A (`192.168.10.x`), effectuer un ping vers une machine sur le LAN de pfSense-B (`192.168.20.x`).
2. Depuis une machine sur le LAN de pfSense-B (`192.168.20.x`), effectuer un ping vers une machine sur le LAN de pfSense-A (`192.168.10.x`).
3. Tester également des connexions applicatives (ex : partage de fichiers SMB, RDP, HTTP).

---

### 🔸 3.3 Analyse des logs

1. Aller dans **Status > System Logs > IPsec**.
2. Vérifier qu’il n’y a pas d’erreurs.
3. Confirmer que le trafic passe bien par le tunnel chiffré.

---

## ✅ Bonnes pratiques

- Toujours utiliser des **algorithmes forts** : AES-256, SHA256.
- Modifier la clé PSK régulièrement.
- Restreindre les règles IPsec (éviter le "Allow All" en production).
- Mettre en place une surveillance du tunnel VPN.

---

## ⚠️ Pièges courants

- Mauvaise correspondance des **réseaux locaux / distants**.
- PSK différente entre les pfSense.
- Pare-feu WAN qui bloque l’IKE (UDP 500 / 4500).
- Oublier de configurer les règles **LAN** pour autoriser le trafic.
