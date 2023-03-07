output "instance_a_id" {
  description = "ID of the EC2 instance A"
  value       = aws_instance.lab02-a.id
}

output "instance_a_public_ip" {
  description = "Public IP address of the EC2 instance A"
  value       = aws_instance.lab02-a.public_ip
}

output "instance_b_id" {
  description = "ID of the EC2 instance B"
  value       = aws_instance.lab02-b.id
}

output "instance_b_private_ip" {
  description = "Private IP address of the EC2 instance B"
  value       = aws_instance.lab02-b.private_ip
}
