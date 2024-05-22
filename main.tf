//fetch the vpc datasource 
data "aws_vpc" "vpc"{
    id = var.vpc_id
}

//create the security for the nodes 
resource "aws_security_group" "anisble-SG" {
  description = "allow all traffic within the VPC and allow SSH from your public ip"
  name        = "Ansible-SG"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ var.public_ip ]
  }
  //allows all tarffic within the vpc
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ data.aws_vpc.vpc.cidr_block ]
  }
  //allows all the outbound traffic 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "Ansible-SG"
    provision = "terraform"
  }
}

//create the worker nodes - RHEL
resource "aws_instance" "worker_nodes_rhel" {
  count = var.worker_count_rhel
  ami                         = var.worker_ami_rhel
  associate_public_ip_address = true
  instance_type               = var.worker_instance_type
  key_name                    = var.key_name
  subnet_id                   = var.worker_sub_id
  vpc_security_group_ids      = [ aws_security_group.anisble-SG.id ]
  tags = {
    Name      = "worker_node_RHEL_${count.index}"
    provision = "terraform"
    os = "RHEL"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.key_path)
    host        = self.public_ip
  }

  provisioner "file" {
    content = templatefile("${path.module}/scripts/worker_node_RHEL.tpl", {
      ansible_user_password = var.ansible_user_password 
    })
    destination = "/home/ec2-user/worker_node.sh"
  }
  provisioner "remote-exec" {
    inline = [ 
      "sudo yum install dos2unix -y",
      //this is becouse the file is edited in windows so the username has carriage return
      //so convert that file to unix before executing this script
      "sudo dos2unix /home/ec2-user/worker_node.sh",
      "sudo chmod +x /home/ec2-user/worker_node.sh",
      "sudo sh /home/ec2-user/worker_node.sh"
     ]
  }
}

//create the worker nodes - DEBIAN
resource "aws_instance" "worker_nodes_debian" {
  count = var.worker_count_debian
  ami                         = var.worker_ami_debian
  associate_public_ip_address = true
  instance_type               = var.worker_instance_type
  key_name                    = var.key_name
  subnet_id                   = var.worker_sub_id
  vpc_security_group_ids      = [ aws_security_group.anisble-SG.id ]
  tags = {
    Name      = "worker_node_DEBIAN_${count.index}"
    provision = "terraform"
    nanda = "yes"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.key_path)
    host        = self.public_ip
  }

  provisioner "file" {
    content = templatefile("${path.module}/scripts/worker_node_DEBIAN.tpl", {
      ansible_user_password = var.ansible_user_password 
    })
    destination = "/home/ubuntu/worker_node.sh"
  }
  provisioner "remote-exec" {
    inline = [ 
      "sudo apt update -y",
      "sleep 2",
      "sudo apt update",
      "sudo apt install dos2unix -y",
      //this is becouse the file is edited in windows so the username has carriage return
      //so convert that file to unix before executing this script
      "sudo dos2unix /home/ubuntu/worker_node.sh",
      "sudo chmod +x /home/ubuntu/worker_node.sh",
      "sudo sh /home/ubuntu/worker_node.sh"
     ]
  }
}

// local variable for the extracting the private ips of worker nodes
locals {
   ec2-private-ips-rhel = "${aws_instance.worker_nodes_rhel.*.private_ip}"
   ec2-private-ips-debian = "${aws_instance.worker_nodes_debian.*.private_ip}"
   ec2-private-ips = concat( local.ec2-private-ips-rhel , local.ec2-private-ips-debian )
}


//create a ansible master node
resource "aws_instance" "master_node" {
  ami                         = var.master_ami
  associate_public_ip_address = true
  instance_type               = var.master_instance_type
  key_name                    = var.key_name
  subnet_id                   = var.master_sub_id
  vpc_security_group_ids      = [ aws_security_group.anisble-SG.id ]
  tags = {
    Name      = "master_node"
    provision = "terraform"
    nanda = "yes"
  }
  connection {
    type        = "ssh"
    user        = "ec2-user"
    # private_key = file("C:/Users/Minfy/Downloads/my-key.pem")
    private_key = file(var.key_path)
    host        = self.public_ip
  }
  provisioner "file" {
    source      = var.key_path
    destination = "/home/ec2-user/my-key.pem"
  }
  provisioner "file" {
    content = templatefile("${path.module}/scripts/host-ips.tpl", {
      input_list = local.ec2-private-ips
    })
    destination = "/home/ec2-user/host-ips"
  }
  provisioner "file" {
    content = templatefile("${path.module}/scripts/master_ansible.tpl", {
      ansible_user_password = var.ansible_user_password , ip_address = "$ip_address"
    })
    destination = "/home/ec2-user/master_ansible.sh"
  }
  provisioner "file" {
    content = templatefile("${path.module}/scripts/inventory.tpl", {
      input_list = local.ec2-private-ips
    })
    destination = "/home/ec2-user/hosts"
  }
  provisioner "remote-exec" {
    inline = [ 
      "sudo yum install dos2unix -y",
      "sudo dos2unix /home/ec2-user/master_ansible.sh",
      "sudo chmod +x /home/ec2-user/master_ansible.sh",
      "sudo sh /home/ec2-user/master_ansible.sh"
     ]
  }
}

