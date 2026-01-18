# Projet M1 Cloud – Infrastructure Cloud

## 1. Présentation

Ce projet est réalisé dans le cadre du module **Infrastructure Cloud** (Master M1).  
Il a pour objectif de concevoir et déployer une infrastructure cloud **scalable**, **observable** et **reproductible**, en s’appuyant sur les principes de l’**Infrastructure as Code (IaC)**.

L’infrastructure est déployée sur **AWS** à l’aide de **Terraform** et intègre des mécanismes de **scalabilité automatique**, de **monitoring** et d’**alerting**.

---

## 2. Objectifs du projet

- Déployer une infrastructure cloud via Terraform
- Mettre en place la **scalabilité automatique** (Auto Scaling)
- Observer le comportement de l’infrastructure (CloudWatch, Grafana)
- Mettre en place des **alertes** en cas d’anomalie
- Garantir la **reproductibilité** et la traçabilité via Git

---

## 3. Architecture cible

L’architecture cible repose sur :
- AWS EC2
- Auto Scaling Group
- CloudWatch (métriques & alarmes)
- SNS (notifications)
- Grafana (visualisation)

📌 Un schéma d’architecture détaillé est disponible dans la documentation.

---

## 4. Stack technique

- **Cloud provider** : AWS
- **Infrastructure as Code** : Terraform
- **Monitoring** : CloudWatch
- **Visualisation** : Grafana
- **Versioning** : Git

---

## 5. Organisation du projet

Projet-M1-Infrastructure-Cloud/
├── docs/
│   ├── JOURNAL.md
│   ├── Projets Module Infrastructure Cloud.md
│   └── schema_infra.png           
│
├── grafana/
│   └── (à mettre en plce)
│
├── terraform/
│   ├── .terraform/                
│   ├── .terraform.lock.hcl        
│   ├── cloudwatch_alarms.tf       
│   ├── cloudwatch_dashboard.tf    
│   ├── main.tf                    
│   ├── outputs.tf                 
│   ├── providers.tf               
│   ├── sns.tf                     
│   ├── terraform.tfstate          
│   ├── terraform.tfstate.backup   
│   ├── terraform.tfvars           
│   ├── variables.tf               
│   └── versions.tf                
│
├── .gitignore                     
├── PLAN.md                        
└── README.md                      


---

## 6. Équipe projet

- **Louis Sellier** :  
  Infrastructure, Terraform, architecture, déploiement

- **Ousmane Bancé** :  
  Monitoring, observabilité, alerting, documentation associée

---

## 7. Déploiement & destruction
- terraform init
- terraform plan
- terraform apply
- terraform destroy

Les commandes Terraform sont exécutées depuis le dossier terraform/.

---

## 8. Scalabilité et observabilité

### Scalabilité (Auto Scaling)

L’infrastructure met en œuvre une **scalabilité horizontale automatique** basée sur AWS Auto Scaling.

Les éléments suivants ont été implémentés via Terraform :

- Launch Template EC2 (Amazon Linux 2023, t3.micro)
- Auto Scaling Group :
  - Capacité minimale : 1
  - Capacité maximale : 2
  - Capacité désirée : 1
- Politique de scaling :
  - Target Tracking basé sur la **moyenne CPU**
  - Seuil cible configurable via variable Terraform

Des tests de montée en charge CPU ont été réalisés afin de valider :
- Le déclenchement automatique du scale-out
- La création dynamique de nouvelles instances EC2
- La cohérence entre métriques CloudWatch et comportement de l’ASG

### Observabilité (CloudWatch & Alerting)

L’observabilité de l’infrastructure repose sur AWS CloudWatch et a été intégralement définie via Terraform.

Les composants suivants ont été mis en place :

- Alarmes CloudWatch :
  - Alarme CPU élevée sur l’Auto Scaling Group
  - Seuil configurable (par défaut : 60 %)
  - Actions associées : notifications SNS
- Notifications :
  - Topic SNS dédié aux alertes
  - Envoi des alertes par email
- Dashboard CloudWatch :
  - CPU moyenne de l’ASG
  - Capacité désirée et instances en service
  - Instances en attente et en terminaison
  - État de l’alarme CPU

L’utilisation de Terraform permet de garantir la **recréation automatique du dashboard et des alarmes** après destruction complète de l’infrastructure.

---

## 9. État du projet

- Infrastructure : validée
- Scalabilité : fonctionnelle
- Observabilité : fonctionnelle
- Reproductibilité : garantie via Terraform
