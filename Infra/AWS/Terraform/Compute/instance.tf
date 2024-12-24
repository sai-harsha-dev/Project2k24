data "aws_ami" "docker_host_ami" {

  filter {
    name   = "image-id"
    values = ["ami-0e2c8caa4b6378d8c"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "sshkey" {
  key_name   = "docker_host_key"
  public_key = var.ssh_pubkey
}

resource "aws_instance" "docker_host" {

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.docker_host_sg]
  associate_public_ip_address = true

  instance_type = var.instance_type
  ami           = data.aws_ami.docker_host_ami.id

  key_name                    = aws_key_pair.sshkey.key_name
  user_data                   = var.init_script
  user_data_replace_on_change = true


}