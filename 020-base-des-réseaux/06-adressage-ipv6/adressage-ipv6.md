## 🔢 Structure d’une adresse IPv6

- Longueur : **128 bits**, représentés en **8 groupes** de **4 chiffres hexadécimaux** (appelés _hextets_)
- Exemple : `2036:0001:2BC5:0000:0000:0000:087C:000A`

### Formes d’écriture :

- **Complète** : `2036:0001:2BC5:0000:0000:0000:087C:000A`
- **Sans zéros initiaux** : `2036:1:2BC5:0:0:0:87C:A`
- **Compressée** (zéros consécutifs → : :) : `2036:1:2BC5::87C:A`

---

## 🌍 Types d’adresses IPv6

### Monodiffusion

|Type|Préfixe|Utilisation|Routable ?|
|---|---|---|---|
|**Boucle locale**|`::1/128`|Test local sur l’hôte|❌|
|**Lien-local**|`FE80::/10`|Auto-config locale (≃ APIPA)|❌|
|**Locale unique**|`FD00::/8`|Réseaux internes, manuelles|❌|
|**Globale unique**|`2000::/3`|Routables sur Internet|✅|

### Multidiffusion

|Plage|Exemples|Utilisation|
|---|---|---|
|`FF00::/8`|`FF02::1`, `FF02::2`|Tous les nœuds / routeurs locaux|
|`FF02::1:2`||Tous les serveurs DHCP lien local|
|`FF01::FB`||Multicast DNS|

### Anycast (non détaillé dans la démo)

- Même adresse affectée à plusieurs hôtes → **réponse la plus proche**

---

## ⚙️ Auto-configuration et fonctionnement

### Adresse lien-local

- Toujours générée à partir de l’interface
- **Non routable**
- Format : `FE80:: + identifiant d’interface`

### Adresse de multidiffusion de nœud sollicité

- Permet de remplacer le broadcast ARP
- Format : `FF02::1:FFxx:xxxx` où `xx:xxxx` sont les derniers bits d’une adresse unicast

### Exemple sur un hôte :

- `::1` (boucle locale)
- `FE80::1abc:xxxx` (lien-local)
- `FD00::1234` (unique locale)
- `2001:0db8::1` (globale)
- `FF02::1` (multicast tous les hôtes)
- `FF02::1:FFxx:xxxx` (nœud sollicité)

---

## 🧪 Démo Packet Tracer – Reconnaissance des adresses IPv6

1. Tester la **boucle locale** : `ping ::1`
2. Observer l’adresse **FE80::/10** sur chaque interface après démarrage
3. Configurer manuellement des adresses `FD00::/8` (non routables)
4. Utiliser des adresses **`2000::/3`** pour les tests Internet (nécessite pare-feu)
5. Vérifier la présence des adresses **multicast**   ex `FF02::1

---

## 📘 À retenir pour les révisions

- Une adresse IPv6 = **128 bits**, écrite en **hexadécimal**, avec **simplification possible**
- Types principaux : **boucle locale**, **lien-local**, **locale unique**, **globale unique**, **multicast**
- Le **préfixe** indique le type et l’usage de l’adresse
- Pas de **broadcast** en IPv6, remplacé par **multicast** ex : `FF02::1`

## 🧑‍💼 Bonnes pratiques professionnelles

- Toujours vérifier la **présence de l’adresse lien-local** sur les interfaces
- Utiliser des adresses **`FD00::/8`** pour les réseaux internes non routables
- Pour les adresses `2000::/3`, prévoir un **pare-feu** strict → adresse visible depuis Internet !
- Éviter les configurations manuelles hasardeuses → privilégier **DHCPv6** ou SLAAC si dispo
- Documenter précisément les **préfixes, interfaces, routages** mis en place
