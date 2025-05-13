# XiVO (Téléphonie IP Open Source)

## 📌 Présentation

XiVO est une solution open source de téléphonie IP basée sur Asterisk. Elle permet de gérer un système de communication complet en entreprise (standard téléphonique, postes IP, files d’attente, messagerie vocale, etc.). Elle dispose d’une interface web (XiVO Web Interface) et d’un accès CLI (ligne de commande) pour une configuration fine.

---

## 🧱 Architecture

| Composant | Rôle |
|----------|------|
| **Asterisk** | Moteur de traitement des appels (SIP, files, transfert, etc.) |
| **XiVO UI** | Interface web d’administration |
| **Postes** | Téléphones SIP (physiques ou logiciels) |
| **Trunks** | Connexions vers l’extérieur (opérateurs VoIP, RTC…) |
| **Utilisateurs / Lignes** | Comptes utilisateurs + numéros internes attribués |

---

## ⚙️ Commandes CLI utiles (via SSH ou console XiVO)

```bash
xivo-service status         # État des services XiVO
asterisk -rvvv              # Lancer la console Asterisk en mode verbeux
sip show peers              # Liste des téléphones SIP enregistrés
core show calls             # Appels actifs
queue show                  # État des files d’attente
reload                      # Recharger la configuration Asterisk
```
> Ces commandes sont à entrer dans l'interface Asterisk après `asterisk -rvvv`

---

## 🔧 Cas d’usage courant

- Déployer des téléphones IP en entreprise avec numérotation interne
- Gérer un standard téléphonique avec SVI, files d’attente, musique d’attente
- Intégrer des opérateurs VoIP (SIP trunk) pour les appels externes
- Créer des règles d’appel par plages horaires

---

## ⚠️ Erreurs fréquentes

- Mauvais mot de passe ou port SIP → téléphone non enregistré
- Oubli de `reload` dans Asterisk après modification
- Mauvais plan de numérotation (conflit entre utilisateurs ou groupes)
- Ne pas configurer les permissions dans les profils utilisateurs (annuaire, transferts…)

---

## ✅ Bonnes pratiques

- Structurer clairement le plan de numérotation dès le début (ex : 1XX pour utilisateurs, 2XX pour groupes, 3XX pour SVI)
- Tester chaque scénario d’appel (entrant, sortant, renvoi, répondeur…)
- Activer les logs (`/var/log/asterisk/`) pour diagnostiquer les appels
- Sauvegarder la configuration XiVO après modifications majeures

---

## 📚 Ressources complémentaires

- [Documentation officielle XiVO](https://documentation.xivo.solutions/)
- `man asterisk`, fichiers de conf dans `/etc/asterisk/`
