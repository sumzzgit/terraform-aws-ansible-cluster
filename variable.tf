// VPC ID 
variable "vpc_id" {
  description = "Add your existing VPC ID"
  type = string
}

// user public IP
variable "public_ip" {
  description = "Your public IP , this IP will be white listed in SG , Defaults to 0.0.0.0/0 exp - 10.15.37.23/32"
  type = string
  default = "0.0.0.0/0"
}

// Master node AMI ID
variable "master_ami" {
 description = "Master node AMI ID (should be RHEL or Amazon linux)"
 type = string 
}

// Worker node AMI ID for RHEL instances
variable "worker_ami_rhel" {
 description = "Worker node AMI ID (RHEL or Amazon linux)"
 type = string 
}

// Worker node AMI ID for DEBIAN instances
variable "worker_ami_debian" {
 description = "Worker node AMI ID (Debian or Ubuntu)"
 type = string 
}


// Master node instance type
variable "master_instance_type" {
 description = "Master node instance type"
 type = string 
}

// Woker node instance type
variable "worker_instance_type" {
 description = "Worker node instance type"
 type = string 
}

// Master node subnet id 
variable "master_sub_id" {
  description = "Master node subnet ID"
  type = string
}

// Worker node subnet id 
variable "worker_sub_id" {
  description = "worker node subnet ID"
  type = string
}

// Key Name
variable "key_name" {
  description = "pem key name for nodes"
  type = string
}

//Worker node count - RHEL
variable "worker_count_rhel" {
  description = "Worker Node Count - RHEL"
  type = number
}

//Worker node count - DEBIAN
variable "worker_count_debian" {
  description = "Worker Node Count - DEBIAN"
  type = number
}


//Key path in local machine
variable "key_path" {
  description = "PEM Key file path in local machine"
  type = string
}

//ansible user password
variable "ansible_user_password" {
  description = "password to create ansible user"
  type = string
}