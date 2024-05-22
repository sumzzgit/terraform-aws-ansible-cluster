//Master node public IP
output "Master-node-public-ip" {
  description = "ansible controller node public ip"
  value = aws_instance.master_node.public_ip
}

// local variable for the extracting the public ips of worker nodes
locals {
   ec2-public-ips = concat( aws_instance.worker_nodes_rhel.*.public_ip , aws_instance.worker_nodes_debian.*.public_ip )
}

// Worker Nodes ip 
output "Woker-nodes-public-ip" {
  description = "ansible worker nodes public ip adress"
  value = local.ec2-public-ips
}

