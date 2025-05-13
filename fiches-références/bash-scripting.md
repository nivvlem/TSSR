# Scripting Bash (Linux)

## 📌 Présentation

Bash est le shell le plus courant sur les systèmes GNU/Linux. Il permet d'automatiser des tâches via des scripts `.sh`, utiles pour la maintenance, le déploiement, les sauvegardes, la surveillance système, etc.

---

## 🧱 Structure d’un script Bash

```bash
#!/bin/bash

# Commentaire
set -euo pipefail  # Bonnes pratiques : arrêt en cas d’erreur, var non définie, gestion de pipe

main() {
  echo "Hello $USER"
}

main "$@"  # Appel de la fonction principale avec les arguments reçus
```

---

## 📦 Variables

```bash
nom="Jean"
echo "Bonjour $nom"
```
- Les variables sont typées dynamiquement (chaînes par défaut)
- Accès via `$nom`, guillemets doubles recommandés

### 🧾 Arguments positionnels
```bash
#!/bin/bash
echo "Nom du script : $0"
echo "Premier argument : $1"
echo "Tous les arguments : $@"
echo "Nombre d’arguments : $#"
```

---

## 🔁 Structures de contrôle
### Conditions

```bash
if [ "$1" = "admin" ]; then
  echo "Bienvenue administrateur"
elif [ "$1" = "user" ]; then
  echo "Accès limité"
else
  echo "Rôle inconnu"
fi
```

### Boucles

```bash
for i in {1..3}; do
  echo "Ligne $i"
done

while [ $i -lt 5 ]; do
  echo $i
  ((i++))
done
```

---

## 🔧 Fonctions

```bash
bonjour() {
  echo "Bonjour $1 !"
}

bonjour "Alice"
```

---

## 🚦 Codes de retour

```bash
mafonction() {
  if [ ! -f "$1" ]; then
    echo "Fichier introuvable" >&2
    return 1
  fi
}

mafonction fichier.txt || exit 1
```
- `$?` : contient le code de retour de la dernière commande

---

## 📁 Fichiers & tests

```bash
if [ -f fichier.txt ]; then
  echo "Le fichier existe"
fi
```

| Test | Signification |
|------|---------------|
| `-f` | Fichier existant |
| `-d` | Dossier existant |
| `-x` | Exécutable |
| `-z` | Chaîne vide |

---

## ⚠️ Erreurs fréquentes

- Ne pas entourer les variables avec guillemets (`"$var"`) → erreurs avec espaces
- Oublier `#!/bin/bash` → le script ne s'exécute pas correctement
- Ne pas rendre le script exécutable (`chmod +x script.sh`)
- Utiliser = au lieu de `-eq`, `-gt` dans les comparaisons numériques

---

## ✅ Bonnes pratiques

- Toujours utiliser `set -euo pipefail`
- Utiliser `main()` et des fonctions pour structurer les scripts
- Ajouter des logs (`echo`, redirection vers fichier log)
- Utiliser des noms de variables explicites

---

## 📚 Ressources complémentaires

- [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/)
- `man bash`
- [Explainshell.com](https://explainshell.com/)
