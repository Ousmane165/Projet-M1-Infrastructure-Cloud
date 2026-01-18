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
