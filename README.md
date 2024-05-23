# terraform-aws-ansible-cluster
terraform module to launch the ansible cluster
MAINTAINED BY SUMZZ

EXAMPLE -> 
```
// launch the master , worker node ansible cluster 
module "ansible" {
  source = "sumzzgit/ansible-cluster/aws"
  vpc_id = var.vpc_id
  public_ip = var.public_ip
  master_ami = var.master_ami
  worker_ami_rhel = var.worker_ami_rhel
  worker_ami_debian = var.worker_ami_debian 
  master_instance_type = var.master_instance_type
  worker_instance_type = var.worker_instance_type
  master_sub_id = var.master_sub_id
  worker_sub_id = var.worker_sub_id
  key_name = var.key_name
  worker_count_rhel = var.worker_count_rhel
  worker_count_debian = var.worker_count_debian 
  key_path = var.key_path
  ansible_user_password = var.ansible_user_password
}

```