output "ec2_public_ip" {
  description = "Adresse IP publique de l'instance EC2 de test"
  value       = aws_instance.test.public_ip
}
