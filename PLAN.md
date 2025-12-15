## 1) Contexte et objectifs

### Contexte

Projet réalisé dans le cadre du module « Infrastructure Cloud ». Le rendu attendu est un dépôt Git contenant le code source et la documentation en Markdown. Un plan d’action initial sera clairement identifiable dans ce fichier `PLAN.md` et pourra évoluer pendant le projet. 

### Objectifs (fonctionnels et techniques)

- Déployer une infrastructure cloud via **Infrastructure as Code** avec **Terraform**.
- Mettre en place l’observabilité via :
    - **CloudWatch** : métriques + alertes (Alarmes) sur les composants clés.
    - **Grafana** : dashboards de visualisation (sources de données CloudWatch).
- Assurer un workflow de versionning propre avec **Git** (commits réguliers, branches, tags si nécessaire).


## 2) Périmètre

### Inclus

- Provisionnement IaC : réseau (si nécessaire), compute (EC2 / ASG ou instances), sécurité (SG/IAM minimum), logs/métriques CloudWatch, éventuellement stockage.
- Dashboards Grafana :
    - Santé infra (CPU, RAM si disponible, réseau, disque si métriques pertinentes)
    - Disponibilité / erreurs
    - Vue synthèse (indicateurs clés)
- Alerting CloudWatch :
    - Alarmes (ex : CPU élevée, erreurs 5xx, instance down, latence)
    - Notifications (SNS email ou autre selon contraintes)

### Fonctionnalités supplémentaire selon l’avancement

- CI/CD (GitHub Actions)
- Haute dispo complète multi-AZ


## 3) Hypothèses et choix d’architecture

### Fournisseur cloud : AWS

- Utilisation de AWS Academy + AWS School acces si nécessaire

### Choix d’architecture

- Terraform :
    - Modules ou structure par dossiers (ex : `network/`, `compute/`, `monitoring/`)
    - Backend d’état (local ou S3+DynamoDB si possible)
- Monitoring :
    - CloudWatch pour métriques/alertes
    - Grafana connecté à CloudWatch comme datasource
- Git :
    - Branch principale `main`
    - Branche(s) de travail `feature/*`
    - PR/MR entre nous deux (relecture minimale)


## 4) Organisation de l’équipe

### Répartition

- Louis SELLIER
    - Structure repo + modules Terraform
    - Déploiement infra (VPC/EC2/SG/IAM/…)
    - Documentation IaC (variables, outputs, commandes)
- Ousmane BANCE
    - Mise en place Grafana + datasource CloudWatch
    - Conception dashboards
    - Définition alarmes CloudWatch + SNS
    - Documentation monitoring/alerting

### Rituels rapides

- Revue PR systématique avant merge sur `main`


## 5) Découpage des tâches (WBS)

### Lot 0 — Initialisation

- [ ]  Créer dépôt Git + README
- [ ]  Définir arborescence (`terraform/`, `docs/`, `grafana/` si besoin)
- [ ]  Définir conventions :
    - nommage ressources
    - variables Terraform
    - format commits (ex : `feat:`, `fix:`, `docs:`)

### Lot 1 — Infrastructure (Terraform)

- [ ]  Provider + variables + outputs
- [ ]  Réseau (si nécessaire) : VPC/Subnets/Routes (ou utilisation du default VPC)
- [ ]  Sécurité : Security Groups + IAM minimal
- [ ]  Compute : instance(s) EC2 (ou ASG si projet orienté scalabilité)
- [ ]  Tests de déploiement : `terraform plan/apply/destroy`
- [ ]  Doc “how-to deploy”

### Lot 2 — Monitoring & Alerting (CloudWatch)

- [ ]  Sélection des métriques clés (CPU, StatusCheckFailed, NetworkIn/Out, etc.)
- [ ]  Création des alarmes CloudWatch (Terraform si possible)
- [ ]  SNS topic + abonnement (email)
- [ ]  Runbook : “Que faire quand l’alarme X se déclenche ?”

### Lot 3 — Dashboards (Grafana)

- [ ]  Déployer Grafana (docker sur EC2 ou autre approche)
- [ ]  Configurer datasource CloudWatch
- [ ]  Créer dashboards :
    - Santé infra (overview)
    - Détail par composant
    - Alerting overview (si pertinent)
- [ ]  Export JSON des dashboards (si possible) + doc d’import

### Lot 4 — Qualité & Documentation

- [ ]  README principal : objectifs, architecture, prérequis, déploiement
- [ ]  `docs/` :
    - `ARCHITECTURE.md` (schéma + explications)
    - `RUNBOOK.md` (alertes, actions)
    - `DECISIONS.md` (choix et compromis)
- [ ]  Vérifier reproductibilité (clean apply sur compte de test)


## 6) Jalons et livrables

### Jalons

- Repo prêt + Terraform init + première ressource déployée
- Infra complète déployable via Terraform
- Alertes CloudWatch fonctionnelles (SNS qui notifie)
- Grafana opérationnel + dashboards pertinents
- Documentation finalisée + démonstration prête

### Livrables attendus

- Code Terraform  → reproductible automatiquement via Ansible
- Documentation → README.md
- Exports dashboards Grafana (si possible)
- Plan d’action `PLAN.md`


## 7) Stratégie de validation (critères “OK”)

- Un `terraform apply` aboutit sans action manuelle critique.
- Les métriques CloudWatch sont visibles et les alarmes déclenchent une notification.
- Grafana affiche les métriques CloudWatch sur au moins 2 dashboards (overview + détail).
- La doc permet à un tiers de reproduire l’installation.