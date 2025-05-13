# TrueNAS

## 📌 Présentation

TrueNAS est un système d’exploitation basé sur FreeBSD (ou Linux pour Scale) dédié au stockage en réseau (NAS). Il propose une interface web complète pour gérer des volumes, des partages réseau (SMB, NFS), des instantanés, la réplication, les utilisateurs, et permet l’intégration à Active Directory.

---

## 🧰 Fonctions principales via interface Web

| Fonction | Description |
|----------|-------------|
| **Pool de stockage** | Regroupe un ou plusieurs disques dans un volume ZFS |
| **Dataset** | Sous-volume logique pour configurer droits, quotas, snapshots |
| **SMB (Windows)** | Partage de fichiers compatible Windows (anciennement CIFS) |
| **NFS** | Partage réseau Linux/Unix |
| **AFP / WebDAV / FTP / iSCSI** | Autres protocoles de partage disponibles |
| **Snapshots** | Sauvegardes instantanées et récupérables d’un dataset |
| **Replication** | Copie automatique d’un volume vers un autre serveur NAS |
| **Plugins / Jails** | Conteneurs légers pour héberger des services (Nextcloud, Plex…) |
| **Active Directory** | Intégration possible à un domaine Windows (authentification centralisée) |

---

## 🔧 Étapes clés d'une configuration typique

1. Accéder à l’interface : `http://adresse-ip:80`
2. Créer un **Pool** de disques avec ZFS
3. Ajouter un **Dataset** (ex : `partages/projet`) avec gestion des droits
4. Activer le service **SMB** et créer un **partage**
5. Ajouter des **utilisateurs** locaux ou intégrer à un domaine **AD**
6. Configurer les **permissions ACL** (Accès Contrôle List)
7. Tester depuis un client Windows (`\\truenas\partage`)

---

## 🔒 Intégration Active Directory

- Aller dans `Directory Services > Active Directory`
- Remplir les champs : domaine, compte d’admin du domaine, DNS, etc.
- Cocher « Enable » et appliquer
- Si les paramètres sont corrects, TrueNAS rejoint le domaine → les groupes et utilisateurs AD deviennent visibles

---

## ⚠️ Erreurs fréquentes

- Mauvaise configuration DNS empêchant la jointure AD
- Droits mal appliqués au dataset (pas d’accès réseau malgré le partage)
- Conflit de nom NetBIOS avec un autre équipement
- Problème d’heure système désynchronisée (empêche l’intégration AD)

---

## ✅ Bonnes pratiques

- Toujours utiliser **ZFS** pour bénéficier de la fiabilité (vérification d’intégrité, snapshots…)
- Documenter la structure des datasets et des partages SMB
- Utiliser l’**intégration AD** plutôt que des utilisateurs locaux pour les environnements d’entreprise
- Planifier des **snapshots automatiques** et des **réplications** régulières vers un autre NAS
- Garder le système à jour et faire des sauvegardes de la configuration

---

## 📚 Ressources complémentaires

- [Documentation officielle TrueNAS CORE](https://www.truenas.com/docs/core/)
- [Documentation TrueNAS SCALE](https://www.truenas.com/docs/scale/)
- Forums : [TrueNAS Community](https://www.truenas.com/community/)
