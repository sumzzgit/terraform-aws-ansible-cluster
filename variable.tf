// VPC ID 
variable "vpc_id" {
  description = "VPC ID"
  type = string
}

// user public IP
variable "public_ip" {
  description = "User Public IP"
  type = string
}

// Master node AMI ID
variable "master_ami" {
 description = "Master node AMI ID"
 type = string 
}

// Worker node AMI ID for RHEL instances
variable "worker_ami_rhel" {
 description = "Worker node AMI ID"
 type = string 
}

// Worker node AMI ID for DEBIAN instances
variable "worker_ami_debian" {
 description = "Worker node AMI ID"
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
  description = "pem key name"
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
  description = "Key file path in local machine"
  type = string
}

//ansible user password
variable "ansible_user_password" {
  description = "ansible user password"
  type = string
}