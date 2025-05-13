# SQL (Structured Query Language)

## 📌 Présentation

SQL est un langage standardisé pour interagir avec des bases de données relationnelles. Il permet de **créer**, **lire**, **modifier**, **supprimer** des données, ainsi que de **structurer** les tables et gérer les droits utilisateurs.

---

## 🧱 Catégories de commandes

| Type | Abréviation | Exemples |
|------|-------------|----------|
| **Requêtes** | DQL (Data Query Language) | `SELECT` |
| **Manipulation** | DML (Data Manipulation Language) | `INSERT`, `UPDATE`, `DELETE` |
| **Définition** | DDL (Data Definition Language) | `CREATE`, `DROP`, `ALTER` |
| **Contrôle** | DCL (Data Control Language) | `GRANT`, `REVOKE` |

---

## 🧰 Commandes SQL essentielles

### 🔍 Lire les données

```sql
SELECT * FROM clients;
SELECT nom, email FROM clients WHERE ville = 'Caen';
SELECT COUNT(*) FROM commandes;
```

### ➕ Ajouter des données

```sql
INSERT INTO clients (nom, email, ville) VALUES ('Durand', 'durand@mail.fr', 'Caen');
```

### ✏️ Modifier des données

```sql
UPDATE clients SET ville = 'Paris' WHERE id = 3;
```

### ❌ Supprimer des données

```sql
DELETE FROM clients WHERE id = 4;
```

### 🏗️ Créer une table

```sql
CREATE TABLE clients (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nom VARCHAR(50),
  email VARCHAR(100),
  ville VARCHAR(50)
);
```

### 🔁 Jointures (JOIN)

```sql
SELECT clients.nom, commandes.date
FROM clients
JOIN commandes ON clients.id = commandes.client_id;
```

---

## 🔎 Cas d’usage courant

- Rechercher des données clients, commandes, tickets, machines, etc.
- Créer un système d’inventaire ou de suivi de tickets
- Gérer un outil interne (CMDB, parc machines, incidents)
- Automatiser des exports ou rapports via scripts SQL

---

## ⚠️ Erreurs fréquentes

- Oublier la clause `WHERE` dans un `DELETE` ou `UPDATE` → affecte toute la table
- Mal utiliser les jointures : doublons, résultats incorrects
- Mauvais types de données ou absence de contraintes (`NOT NULL`, `FOREIGN KEY`…)
- Injection SQL si les entrées utilisateurs ne sont pas protégées (faille de sécurité)

---

## ✅ Bonnes pratiques

- Toujours sauvegarder la base avant des opérations destructives
- Documenter les structures de tables et relations (diagramme ER si possible)
- Utiliser des noms explicites (`client_id`, `date_creation`, etc.)
- Optimiser les requêtes avec `INDEX` sur les colonnes de recherche
- Limiter les droits SQL en fonction des rôles (lecture, écriture…)

---

## 📚 Ressources complémentaires

- [SQL.sh – Référence française](https://sql.sh/)
- [W3Schools – SQL Tutorial](https://www.w3schools.com/sql/)
- `man mysql`, `psql`, `sqlite3` selon le système utilisé
