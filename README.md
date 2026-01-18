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
- **Visualisation** : Grafana (local)
- **Versioning** : Git

---

## 5. Organisation du projet

terraform/
docs/
├─ schema_Infra.png
├─ JOURNAL.md
README.md
PLAN.md

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

## 8. Scalabilité et tests

L’infrastructure met en œuvre un mécanisme de **scalabilité automatique** basé sur les services natifs AWS.

### Principe retenu
- Utilisation d’un **Launch Template** pour définir les instances EC2
- Déploiement d’un **Auto Scaling Group (ASG)** :
  - Capacité minimale : 1 instance
  - Capacité maximale : 2 instances
- Politique de scaling basée sur la **charge CPU moyenne du groupe**

### Tests réalisés
- Génération d’une charge CPU artificielle sur les instances
- Observation du **scale-out automatique** (création d’une seconde instance)
- Validation du comportement via :
  - Auto Scaling Group (Activity History)
  - CloudWatch (métriques CPU)

Les tests ont permis de valider le bon fonctionnement de la scalabilité sans intervention manuelle !
