output "ec2_public_ip" {

    description = "Public IP"
    value=module.ec2_instance.public_ip
  
}