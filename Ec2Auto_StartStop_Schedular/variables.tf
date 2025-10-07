variable "email" {
  description = "This is the email"
  type = string
  default="venkatasai2611@gmail.com"
}


variable "start_schedule"{
    description="this is scheduled time cron job"
    type=string
    default = "cron(05 15 * * ? *)" 
}

variable "stop_schedule"{
    description="this is scheduled time cron job"
    type=string
    default = "cron(15 15 * * ? *)" 
}


variable "ec2name"{
    type = string
    default = "AUTOEC2VM"
}