variable "aws_region" {
  type        = string
  description = "Région AWS"
  default     = "eu-west-3"
}

variable "aws_profile" {
  type        = string
  description = "Profil AWS CLI"
  default     = "perso"
}

variable "project_name" {
  type        = string
  description = "Nom du projet"
  default     = "Projet M1 Cloud"
}

variable "instance_type" {
  type        = string
  description = "Type d'instance pour l'ASG"
  default     = "t3.micro"
}

variable "asg_min" {
  type        = number
  description = "Taille min ASG"
  default     = 1
}

variable "asg_max" {
  type        = number
  description = "Taille max ASG"
  default     = 2
}

variable "asg_desired" {
  type        = number
  description = "Capacite desiree ASG"
  default     = 1
}

variable "cpu_target" {
  type        = number
  description = "Cible CPU moyenne ASG (en %)"
  default     = 50
}
