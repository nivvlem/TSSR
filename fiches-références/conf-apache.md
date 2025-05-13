# Fichiers `.conf` Apache & Directives

## 📌 Présentation

Apache utilise des fichiers de configuration en syntaxe déclarative `.conf`, situés principalement dans `/etc/apache2` sous Linux. Ils permettent de configurer les hôtes virtuels, les options de dossier, les logs, les redirections ou encore les règles de réécriture.

---

## 🧱 Structure typique d’un VirtualHost

```apache
<VirtualHost *:80>
    ServerName monsite.local
    DocumentRoot /var/www/monsite

    <Directory /var/www/monsite>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/monsite_error.log
    CustomLog ${APACHE_LOG_DIR}/monsite_access.log combined
</VirtualHost>
```

---

## 🧰 Directives courantes

| Directive | Rôle | Exemple |
|-----------|------|---------|
| `ServerName` | Nom DNS du site | `ServerName monsite.local` |
| `DocumentRoot` | Répertoire source | `/var/www/html` |
| `DirectoryIndex` | Page par défaut | `index.php index.html` |
| `ErrorLog` | Chemin du log d’erreur | `${APACHE_LOG_DIR}/error.log` |
| `CustomLog` | Chemin et format du log d’accès | `${APACHE_LOG_DIR}/access.log combined` |
| `Alias` | Redirige un chemin URL vers un autre dossier | `Alias /docs /var/www/documents` |
| `Redirect` | Redirection HTTP | `Redirect / https://monsite.local` |
| `RewriteRule` | Réécrit une URL (nécessite `mod_rewrite`) | `RewriteRule ^page$ page.php [L]` |

---

## 🔒 Exemple `.htaccess`

Permet de gérer localement certaines options si `AllowOverride` est activé :
```apache
RewriteEngine On
RewriteRule ^article/(.*)$ article.php?id=$1 [L,QSA]
```

---

## 🔎 Cas d’usage courant

- Création de sites web en VirtualHost (intranet, test, prod)
- Ajout de redirections (`http` → `https`, `www` → `sans-www`)
- Activation du module `rewrite` pour URLs personnalisées
- Sécurisation de répertoires (`Require`, `AuthType`, etc.)

---

## ⚠️ Erreurs fréquentes

- Fichier `.conf` non activé (oubli du `a2ensite`)
- Mauvais chemin `DocumentRoot` (erreur 403 ou 404)
- Oubli de `AllowOverride All` → `.htaccess` inopérant
- Directive `Require` mal placée ou incompatible (erreurs d’accès 403)
- Redémarrage/rechargement Apache oublié après modification

---

## ✅ Bonnes pratiques

- Un fichier `.conf` par site dans `sites-available/`
- Toujours valider la syntaxe avec `apache2ctl configtest`
- Créer des logs séparés pour chaque site web
- Documenter les blocs VirtualHost avec des commentaires
- Utiliser les variables `${APACHE_LOG_DIR}` pour la portabilité

---

## 📚 Ressources complémentaires

- [Directive Index Apache officielle](https://httpd.apache.org/docs/current/mod/directives.html)
- [Guide VirtualHost Apache](https://httpd.apache.org/docs/current/vhosts/)
- `man apache2`, `man a2ensite`, etc.
