terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
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

variable "vpc_cidr" {
  type = string
}


module "network_stack" {
  source = "./Network"
  vpc_cidr = var.vpc_cidr
}

module "name" {
  source         = "./Compute"
  ssh_pubkey     = var.ssh_pubkey
  init_script    = var.init_script
  instance_type  = var.instance_type
  subnet_id      = module.network_stack.subnet_id
  docker_host_sg = module.network_stack.docker_host_sg_id
  depends_on = [ module.network_stack ]
}

