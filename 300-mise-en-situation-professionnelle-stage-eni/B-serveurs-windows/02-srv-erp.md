# 🧩 SRV-ERP — IIS en HTTPS avec PKI de domaine

> Hôte : **SRV-ERP** — IP : **192.168.55.22/25** — Passerelle : **192.168.55.1** — DNS : **192.168.55.20 / 192.168.55.21**  
> FQDN service : **erp.stage.eni** (interne)  
> Dépendances : **PKI d’entreprise** sur **SRV-DC1** (AD CS) ; DNS AD intégré

## 0) Pré‑requis

- **SRV-DC1** : AD DS + **AD CS (Enterprise Root CA)** opérationnels. *(Si non installé, voir encadré plus bas.)*
- **DNS** : zone `stage.eni` active sur DCs.
- **Flux** (cf. matrice) : Clients → SRV-ERP **TCP 443** autorisé ; **pas de publication WAN**.

📌 **Rappel PKI** (si à installer maintenant sur SRV-DC1)
```powershell
# Rôle AD CS (Certification Authority)
Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools
# Configuration en CA racine d’entreprise
Install-AdcsCertificationAuthority -CAType EnterpriseRootCA
```
*(La diffusion du certificat racine dans le domaine est automatique ; les membres font confiance à la chaîne.)*

---

## 1) DNS — Enregistrement du service

Sur **SRV-DC1** (DNS) :

```powershell
Add-DnsServerResourceRecordA -ZoneName "stage.eni" -Name "erp" -IPv4Address 192.168.55.22
```

Vérif depuis un client :

```powershell
Resolve-DnsName erp.stage.eni
```

---

## 2) Installation d’IIS (minimal + redirection HTTP)

Sur **SRV-ERP** :

```powershell
Install-WindowsFeature Web-Server, Web-Common-Http, Web-Default-Doc, Web-Static-Content, `
  Web-Http-Errors, Web-Http-Logging, Web-Request-Monitor, Web-Filtering, `
  Web-Http-Redirect, Web-Mgmt-Console -IncludeManagementTools
```
Vérif : `http://srv-erp` doit afficher la page IIS par défaut (temporaire, avant forçage HTTPS).

---

## 3) Certificat serveur (PKI interne)
### 3.1 Modèle et auto‑inscription (recommandé)

Sur **SRV-DC1 (CA)** :

1. **Dupliquer** le modèle **Web Server** ; autoriser **Computer** à s’inscrire ; ajouter SAN **DNS**.
2. **Publier** le modèle.
3. **GPO** (Domain/Computers) → *Public Key Policies* → **Certificate Services Client – Auto‑Enrollment** : *Enabled* (+ *Renew expired…*, *Update…*).

### 3.2 Demande manuelle (si pas d’auto‑enrollement)

Sur **SRV-ERP** : `mmc` → *Certificates (Local Computer)* → *Personal* → *All Tasks* → *Request New Certificate* → modèle **Web Server** → **Subject/SAN = erp.stage.eni** → *Enroll*.

Vérif : `certlm.msc` → *Personal* → certificat **CN=erp.stage.eni** valide.

---

## 4) Binding HTTPS + SNI sur IIS

Créer (ou réutiliser) le **Default Web Site** pour la maquette.

### GUI (rapide)

IIS Manager → *Sites* → *Default Web Site* → *Bindings…* → **Add** :  
- Type = **https**, Port **443**  
- **Host name** = `erp.stage.eni`  
- **SNI** = coché  
- Certificat = *Web Server – erp.stage.eni*

### PowerShell (automatisé)

```powershell
Import-Module WebAdministration
$site = "Default Web Site"
$thumb = (Get-ChildItem Cert:\LocalMachine\My | Where-Object { $_.Subject -like "*CN=erp.stage.eni*" } | Select-Object -First 1).Thumbprint
# Binding HTTPS + SNI
New-WebBinding -Name $site -Protocol https -Port 443 -HostHeader "erp.stage.eni" -SslFlags 1
# Associer le certificat au binding
New-Item "IIS:\SslBindings\0.0.0.0!443!erp.stage.eni" -Thumbprint $thumb -SSLFlags 1 | Out-Null
```

---

## 5) Forcer la redirection HTTP → HTTPS

Option simple via le module **HTTP Redirect** (installé à l’étape 2) :
1. IIS Manager → *Default Web Site* → **HTTP Redirect**.  
2. **Redirect requests to this destination** : `https://erp.stage.eni/`  
3. Cocher **Only redirect requests to content in this directory** et **Permanent (301)**.  

*(Alternative : module URL Rewrite si règles plus fines nécessaires.)*

---

## 6) Durcissement minimal TLS & IIS

- S’assurer que **TLS 1.2/1.3** sont actifs (par défaut sur WS2025).  
- Limiter l’exposition : laisser **uniquement 443** ouvert côté hôte ; pas d’auth anonyme si l’app ne le requiert pas.  
- Activer **HSTS** (si pas d’impact applicatif) : 

```powershell
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' `
  -filter "system.webServer/httpProtocol/customHeaders" -name "." -value @{name='Strict-Transport-Security';value='max-age=31536000; includeSubDomains'}
```

---

## 7) Tests & validation

Depuis un **client** membre du domaine :

```powershell
Test-NetConnection erp.stage.eni -Port 443
Invoke-WebRequest https://erp.stage.eni -UseBasicParsing | Select-Object StatusCode,Headers
```

Vérifs **certificat** :

```powershell
# Chaîne & usages
certutil -verify "cert.cer"
# Vue rapide côté client (SNI)
openssl s_client -connect erp.stage.eni:443 -servername erp.stage.eni <NUL | openssl x509 -noout -subject -issuer -dates
```
*(Sur Windows, `openssl` via Git Bash / WSL ; sinon tester dans un navigateur : cadenas doit mentionner la **CA interne**.)*

---

## 8) Intégration à la matrice de flux

- **LAN Clients → SRV-ERP (55.22)** : **TCP 443** **ALLOW**.  
- **DMZ/WAN → SRV-ERP** : **DENY** (non publié externe).  
- **Zabbix → SRV-ERP** : TCP **10050** (agent) **ALLOW**.

---

## 9) Supervision & exploitation

- **Zabbix Agent** sur SRV-ERP ; modèle « Microsoft IIS by Zabbix agent ».  
- Logs IIS : `C:\inetpub\logs\LogFiles` ; centraliser si possible.  
- Sauvegarde : inclure **clé privée** du cert (export .pfx) + config IIS (`%windir%\system32\inetsrv\config`).

---

## ✅ Checklist

- [ ] A DNS `erp → 192.168.55.22` créé & résolu depuis clients.  
- [ ] IIS installé (avec **HTTP Redirect**).  
- [ ] Certificat **Web Server (erp.stage.eni)** présent dans *LocalMachine\My*.  
- [ ] Binding **HTTPS:443 + SNI (erp.stage.eni)** actif.  
- [ ] Redirection **HTTP→HTTPS** en 301.  
- [ ] Accès clients **OK** (statut 200, cadenas valide).  
- [ ] Supervision Zabbix branchée.  
- [ ] Sauvegarde cert (.pfx) & conf IIS documentées.

---

## 📎 Annexes — commandes utiles

```powershell
# Lister bindings IIS
Get-WebBinding | ft protocol,bindingInformation,sslFlags
# Voir le cert lié à un binding SNI
Get-ChildItem IIS:\SslBindings | ft hostname,port,thumbprint
# Exporter le cert avec clé privée (pour sauvegarde)
$pwd = Read-Host -AsSecureString
Export-PfxCertificate -Cert "Cert:\\LocalMachine\\My\$thumb" -FilePath C:\\backup\\erp_stage_eni.pfx -Password $pwd
```

---

## 📚 Références (Microsoft Learn)

- **AD CS – Installer la CA** : https://learn.microsoft.com/windows-server/networking/core-network-guide/cncg/server-certs/install-the-certification-authority  
- **Modèles de certificats (concepts)** : https://learn.microsoft.com/windows-server/identity/ad-cs/certificate-template-concepts  
- **Auto‑enrollement par GPO** : https://learn.microsoft.com/windows-server/networking/core-network-guide/cncg/server-certs/configure-server-certificate-auto-enrollment  
- **Installer IIS** : https://learn.microsoft.com/powershell/module/servermanager/install-windowsfeature  
- **HTTP Redirect (IIS)** : https://learn.microsoft.com/iis/configuration/system.webserver/httpredirect/  
- **Bindings HTTPS / PowerShell** : https://learn.microsoft.com/powershell/module/webadministration/new-webbinding  
- **SNI & bindings (IIS)** : https://learn.microsoft.com/iis/configuration/system.applicationhost/sites/site/bindings/binding
