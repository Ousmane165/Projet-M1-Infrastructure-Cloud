# Journal de projet – Projet M1 Cloud

Ce document retrace l’évolution du projet, les décisions prises et les étapes validées au fil de l’avancement du projet.

---

## Phase 1 — Mise en place des fondations

### Objectifs
- Valider l’accès AWS
- Configurer l’environnement local
- Déployer une première ressource via Terraform

### Environnement
- OS : Windows
- Shell : Git Bash
- Outils :
  - Terraform
  - AWS CLI
  - Git

### AWS
- Compte AWS personnel
- Région : eu-west-3
- Authentification :
  - Utilisateur IAM : `terraform-admin`
  - MFA activé sur le compte root
  - Profil AWS CLI : `perso`

Commande de validation : aws sts get-caller-identity --profile perso

### Initialisation Terraform
Arborescence initiale :
terraform/
├─ main.tf
├─ providers.tf
├─ versions.tf
├─ variables.tf
├─ outputs.tf


Choix réalisés :
- Provider AWS officiel (hashicorp/aws)
- Région définie par variable
- Utilisation du VPC par défaut
- Tagging basé sur le projet Projet M1 Cloud

### Déploiement de test
Ressources créées :
- 1 Security Group
- 1 instance EC2 de test
    - Type : t3.micro
    - AMI : Amazon Linux 2023
    - IP publique attribuée

Commandes utilisées :
- terraform init
- terraform plan
- terraform apply

Résultat :
- Déploiement sans erreur
- Instance EC2 visible dans la console AWS
- Instance en état Running

### Validation de la phase
Cette phase a permis de :
- Valider Terraform avec AWS
- Vérifier la cohérence AWS CLI / Terraform / Console
- Poser un socle technique fonctionnel

**Phase 1 validée !**

---

## Phase 2 — Scalabilité
Objectifs prévus :
- Mise en place d’un Launch Template
- Création d’un Auto Scaling Group
- Politique de scaling basée sur la charge CPU