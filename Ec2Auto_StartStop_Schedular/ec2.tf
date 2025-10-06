data "aws_vpc" "default" {
  default=true
}

data "aws_subnets" "default"{
    
    filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }

}

resource "aws_key_pair" "auto" {
  key_name = "auto"
  public_key = file("keys/auto.pub")
}

resource "aws_security_group" "autosg" {
  name = "autosg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port=22
    to_port=22
    protocol="tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "AutoEC2"

  instance_type = "t2.micro"
  key_name      = aws_key_pair.auto.key_name
  monitoring    = true
  subnet_id = data.aws_subnets.default.ids[0]
  security_group_name = aws_security_group.autosg.name
  
  root_block_device = {
    encrypted  = true
    type       = "gp3"
    throughput = 200
    size       = 10
  }

  tags = {
    Environment = "dev"
  }
}