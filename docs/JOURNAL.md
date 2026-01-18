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

## Phase 2 — Mise en place de la scalabilité

### Objectifs
- Mettre en place une infrastructure capable de s’adapter automatiquement à la charge
- Valider le fonctionnement d’un Auto Scaling Group sur AWS
- Tester la montée en charge dans des conditions réelles

---

### Configuration réalisée

#### Infrastructure
- Utilisation du **VPC par défaut**
- Instances EC2 basées sur **Amazon Linux 2023**
- Type d’instance : `t3.micro`
- Sécurité :
  - Accès HTTP (port 80)
  - Aucun accès SSH (sécurité renforcée)

#### Scalabilité
- Création d’un **Launch Template**
- Mise en place d’un **Auto Scaling Group** :
  - min = 1
  - max = 2
  - desired = 1
- Politique de scaling :
  - Type : Target Tracking
  - Métrique : `ASGAverageCPUUtilization`
  - Cible : 50 %

---

### Accès et automatisation (SSM)

Afin d’éviter l’usage du SSH, les instances EC2 sont gérées via **AWS Systems Manager (SSM)** :
- Création d’un rôle IAM dédié aux instances EC2
- Attachement de la policy `AmazonSSMManagedInstanceCore`
- Accès aux instances via **Run Command**

Cette approche est conforme aux bonnes pratiques AWS en matière de sécurité.

---

### Tests de scalabilité

#### Méthodologie
- Génération d’une charge CPU artificielle à l’aide de commandes exécutées via SSM
- Commande exécutée à distance sur les instances de l’ASG :
`stress --cpu 2 --timeout 300`

#### Observations
- Augmentation de la charge CPU sur l’instance existante
- Déclenchement automatique de la politique de scaling
- Création d’une seconde instance EC2
- Répartition des instances sur différentes zones de disponibilité

#### Validation :
- Scale-out observé sans intervention manuelle
- Événements visibles dans l’Activity History de l’ASG
- Corrélation avec les métriques CloudWatch

Statut de la phase 2 : validé !