# Journal de projet – Projet M1 Cloud

## Phase 1 – Configuration du compte AWS

- Création d’un compte AWS personnel
- Sécurisation du compte root avec MFA
- Création d’un utilisateur IAM dédié (`terraform-admin`)
- Configuration de l’AWS CLI avec un profil spécifique (`perso`)
- Vérification de l’identité via `aws sts get-caller-identity`
- Choix de la région `eu-west-3 (Paris)`

Objectif : disposer d’un environnement AWS stable et sans contraintes de sandbox.

---

## Phase 2 – Validation Terraform & première instance EC2

- Initialisation du projet Terraform
- Déploiement d’une première instance EC2 de test
- Validation de la cohérence :
  - Terraform
  - AWS CLI
  - Console AWS

Cette phase a permis de valider l’accès AWS, le provider et le workflow IaC.

---

## Phase 3 – Mise en place de la scalabilité

- Création d’un Launch Template EC2
- Mise en place d’un Auto Scaling Group
- Définition des capacités min / max / desired
- Ajout d’une politique de scaling basée sur la CPU moyenne
- Validation du déclenchement de l’alarme CPU associée au scale-out

### Tests réalisés
- Génération artificielle de charge CPU via AWS Systems Manager (Run Command)
- Observation de la montée de charge dans CloudWatch
- Déclenchement automatique du scale-out
- Création d’une nouvelle instance EC2 par l’ASG

Résultat :  
La scalabilité horizontale fonctionne comme attendu.

---

## Phase 4 – Observabilité et alerting

- Création d’un topic SNS pour les alertes
- Configuration d’une alarme CloudWatch sur la CPU moyenne de l’ASG
- Réception effective des notifications par email
- Création d’un dashboard CloudWatch via Terraform

Le dashboard inclut :
- CPU moyenne de l’ASG
- Capacité désirée vs instances en service
- Instances en attente / terminaison
- État des alarmes CPU

---

## Phase 5 – Nettoyage et reproductibilité

- Destruction complète de l’infrastructure via `terraform destroy`
- Validation que :
  - Aucun coût inutile n’est engagé
  - L’infrastructure est entièrement recréable
  - Les dashboards et alarmes sont gérés par Terraform

---

## Bilan intermédiaire

À ce stade :
- La scalabilité est fonctionnelle
- L’observabilité est opérationnelle
- Le projet respecte les principes d’Infrastructure as Code
- Les coûts sont maîtrisés

Le projet est prêt pour :
- Finalisation de la documentation
- Présentation orale
- Extensions futures (Grafana, logs avancés, etc.)
