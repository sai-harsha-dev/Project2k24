variable "subnet_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ssh_pubkey" {
  type      = string
  sensitive = true
}

variable "init_script" {
  type      = string
  sensitive = true
}

variable "docker_host_sg" {
  type = string
}