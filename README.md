# État du projet – Projet M1 Cloud

## 1. Contexte

Ce projet est réalisé dans le cadre du module **Infrastructure Cloud**.  
Il vise à mettre en œuvre une infrastructure cloud scalable, observable et reproductible à l’aide de la technologie d’Infrastructure as Code (Terraform) et de services AWS.

Le projet est réalisé avec Ousmane Bancé et s’appuie sur un **compte AWS personnel**, afin d’éviter les limitations des environnements de type sandbox (AWS Academy).

---

## 2. Environnement de travail

### Poste local
- Système : Windows
- Shell principal : Git Bash
- Outils installés :
  - Terraform
  - AWS CLI
  - Git

### AWS
- Compte AWS personnel
- Région principale : **eu-west-3 (Paris)**
- Authentification :
  - Utilisateur IAM dédié : `terraform-admin`
  - Accès programmatique (AWS CLI)
  - MFA activé sur le compte root

### AWS CLI
- Profil utilisé : `perso`
- Commande de validation :
```bash
aws sts get-caller-identity --profile perso
