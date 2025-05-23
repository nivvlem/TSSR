# Sécurité et conformité dans Microsoft 365
## 📧 Messagerie : vecteur principal d’attaque

### Types d’attaques

|Attaque|Description|
|---|---|
|Spam|Courriers non sollicités (publicité, phishing)|
|Phishing|Usurpation de marque pour voler des infos (ex. faux formulaire)|
|Malware|Fichiers joints ou liens malveillants dans un mail|
|Scam|Arnaques financières par usurpation d’identité|
|Spear Phishing|Ciblage personnalisé (collègue, direction…)|
|Usurpation de domaine|Dérivés de domaine (faceboook.com) ou erreur de config DNS|
|Piratage de compte|Listes de mots de passe en ligne, bruteforce|

### Moyens de protection

- Antispam + Antivirus (EOP, ATP…)
- **SPF**, **DKIM**, **DMARC**
- Sensibilisation des utilisateurs
- Surveillance des connexions suspectes
- **2FA obligatoire** pour les comptes sensibles

---

## 🛡️ Le Centre de sécurité et conformité M365

Accessible via : [https://security.microsoft.com](https://security.microsoft.com/)

### Outils clés

- **DLP** : protection contre la perte de données sensibles (RIB, carte d’identité…)
- **Stratégies de rétention** : conservation et suppression automatique
- **Archivage Exchange** : active les archives en ligne (non accessibles mobile)
- **Audit & journalisation** : traçabilité des activités (consultation, suppression, accès admin)
- **Gestion des menaces** : quarantaine, détection, remédiation

---

## 🔐 Gestion des mots de passe & 2FA

### Recommandations (ANSSI / Microsoft)

- 12 caractères minimum, pas de rotation forcée inutile
- Bannir les mots de passe communs (admin123, 2024@Azerty)
- Ne pas réutiliser les mots de passe pro dans la sphère perso
- Éviter l’enregistrement automatique dans les navigateurs

### Authentification multifacteur (MFA)

- Par défaut activée depuis 2021
- Combinée à une méthode :
    - App mobile (Microsoft Authenticator, Free OTP)
    - SMS / Appel vocal
    - OTP matériel


### Commandes utiles

```powershell
Set-MsolUser -UserPrincipalName satella@domain.tld -PasswordNeverExpires $true
Set-MsolUserPassword -UserPrincipalName satella@domain.tld -ForceChangePassword $true
```

---

## 🧩 Mécanismes DNS pour sécuriser les envois

### SPF (Sender Policy Framework)

- Enregistrement TXT dans la zone DNS

```txt
v=spf1 include:spf.protection.outlook.com -all
```

- Limite les IP autorisées à envoyer pour le domaine

### DKIM (DomainKeys Identified Mail)

- Ajoute une signature chiffrée à l’en-tête
- 2 enregistrements CNAME à configurer + activation dans Microsoft 365

### DMARC (Domain-based Message Authentication, Reporting & Conformance)

- Complète SPF + DKIM avec politique (none / quarantine / reject)

```txt
v=DMARC1; p=quarantine; rua=mailto:admin@domain.tld
```

---

## 📦 Antispam et filtres avancés

### Exchange Online Protection (EOP)

- Filtrage des mails en réception
- Suppression automatique des pièces jointes malveillantes
- Journalisation des envois suspects

### Critères paramétrables

- Liste verte / noire (domaine, IP)
- Pays bloqués, langue du message
- Heuristique sur l’en-tête SMTP

### Solutions tierces intégrables (API)

- Fortinet, Barracuda, Mailinblack…
- Intégration avec Outlook / EOP / ATP

---

## 🗄️ Sauvegarde des données Microsoft 365

### Limitations natives

- Microsoft n’est pas responsable de la **sauvegarde**, seulement de la **disponibilité**
- Risque en cas de suppression volontaire ou accidentelle d’un utilisateur

### Solutions tierces (SkyKick, Veeam, Acronis…)

- Connexion via API M365
- Sauvegarde de :
    - Exchange Online
    - SharePoint / Teams
    - OneDrive
    - Groupes Microsoft 365
- Rétention illimitée, stockage Azure ou site local

---

## ✅ À retenir pour les révisions

- La **messagerie est la première source de menaces** dans M365
- La protection repose sur : **filtrage, configuration DNS, MFA, DLP et archivage**
- Le centre de sécurité permet de **surveiller, prévenir, archiver, tracer**
- Microsoft n’assure pas les sauvegardes : des solutions tierces sont à prévoir

---

## 📌 Bonnes pratiques professionnelles

- Imposer le **2FA à tous les comptes** avec privilèges
- Déployer **SPF, DKIM, DMARC** dès la mise en production du domaine
- Éviter l’usage d’une boîte générique comme admin@… sans protection
- Sensibiliser les utilisateurs (affiches, mails réguliers, faux phishing internes)
- Compléter M365 avec une **solution de sauvegarde externalisée**