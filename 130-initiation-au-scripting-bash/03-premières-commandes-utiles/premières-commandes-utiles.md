# Premières commandes utiles aux scripts Bash

## 📌 Commandes internes du Shell

Les commandes suivantes sont **intégrées au Shell**. Elles n'ont **pas de binaire externe** associé (elles ne sont pas dans `/bin` ou `/usr/bin`).

---

## 🖨️ `echo` – Affichage dans le terminal

Affiche un message texte à l'écran. Très utilisé pour informer l'utilisateur.

### Syntaxe :

```bash
echo [option] "message"
```

### Options utiles :

|Option|Effet|
|---|---|
|`-e`|Active les séquences spéciales|
|`\n`|Saut de ligne|
|`\t`|Tabulation|
|`\c`|Supprime le retour à la ligne|
|`\\`|Affiche un antislash `\`|

### Exemple :

```bash
echo -e "Bonjour\nBienvenue dans le monde du scripting !"
```

> 💡 Utilise toujours des **guillemets doubles** pour préserver les caractères spéciaux.

---

## 🧼 `clear` – Nettoyer l’écran

Efface tout ce qui est affiché dans le terminal.

```bash
clear
```

Utile pour améliorer la lisibilité de l’affichage dans un script.

---

## 🚪 `exit` – Quitter un script

Permet de **terminer l'exécution d'un script**, avec ou sans code de retour.

### Syntaxe :

```bash
exit [code_retour]
```

- `exit 0` : fin normale (OK)
- `exit 1` ou autre : erreur ou cas particulier

Le **code de retour** est accessible via la variable spéciale `$?`.

> 🔍 À l’appel d’un script, `$?` permet de vérifier s’il s’est bien exécuté :

```bash
./mon_script.sh
echo $?
```

---

## 📚 `help` – Aide sur les commandes internes

Affiche la liste des commandes **intégrées au Shell Bash** ou l’aide d’une commande spécifique.

### Syntaxes :

```bash
help           # liste toutes les commandes internes
help wait      # affiche l’aide sur la commande 'wait'
```

> 📘 Contrairement à `man`, `help` s’applique uniquement aux commandes internes.

---

## ✅ À retenir pour les révisions

- `echo` : affiche du texte (avec `-e` pour les séquences spéciales)
- `clear` : vide le terminal
- `exit` : termine un script avec un code retour (consultable via `$?`)
- `help` : affiche l’aide intégrée de Bash
- Ce sont des **commandes internes**, donc plus rapides et sans dépendances externes.
