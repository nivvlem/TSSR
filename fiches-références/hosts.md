# Fichier hosts

## 📌 Présentation

Le fichier `hosts` est un fichier système utilisé pour faire de la résolution de noms locale. Il permet d’associer manuellement des adresses IP à des noms de domaine ou hôtes, sans passer par un serveur DNS. Très utile pour les tests, les environnements locaux ou le blocage de domaines.

---

## 📁 Emplacement selon système

| OS | Chemin |
|----|--------|
| Linux / Unix | `/etc/hosts` |
| Windows | `C:\Windows\System32\drivers\etc\hosts` |
| macOS | `/etc/hosts` |

---

## 🧰 Syntaxe

```plaintext
<adresse IP> <nom_domaine> [alias1 alias2...]
```

### Exemple :

```plaintext
127.0.0.1       localhost
192.168.52.10   serveur-web.mondomaine.local serveur-web
10.0.0.1        testvpn.local
```

---

## 🔎 Cas d’usage courant

- Rediriger un nom vers une IP locale ou distante (sans DNS)
- Tester un site web avant sa mise en ligne (ex : `www.exemple.com` → IP locale)
- Accéder à une VM ou un serveur par un nom convivial
- Simuler la présence d’un domaine dans un environnement de formation
- Bloquer des domaines en les pointant vers `127.0.0.1`

---

## ⚠️ Erreurs fréquentes

- Mauvais format (espaces multiples, absence de tabulation correcte)
- IP mal saisie → nom non résolu
- Oublier d’élever les droits administrateur pour modifier le fichier (sudo sous Linux, Notepad en admin sous Windows)
- Confusion entre DNS public et résolution locale : le `hosts` **a toujours priorité**

---

## ✅ Bonnes pratiques

- Utiliser des noms cohérents et explicites (`srv-dns`, `srv-web`, etc.)
- Ajouter des commentaires pour chaque ligne :
  ```plaintext
  192.168.52.11  dns01 # Serveur DNS interne
  ```
- Ne pas utiliser ce fichier comme solution DNS permanente sur plusieurs machines : uniquement pour tests ou dépannage
- Sauvegarder le fichier avant modification, surtout en environnement critique

---

## 📚 Ressources complémentaires

- `man hosts` (Linux)
- [Ubuntu Documentation – /etc/hosts](https://help.ubuntu.com/community/Hosts)
