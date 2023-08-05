# Specifies the AWS provider to use and the region to create resources in.
provider "aws" {
  region = "us-east-1"
}

# Specifies the use of a pre-built Terraform module to create a VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  #specify the version of the module. Good practice to do so in production environment because of stability
  version = "3.19.0"
  
  #label the VPC with a name for identification
  name = var.vpc_name
  
  #Choose a CIDR block that provides enough IP addresses for our needs
  cidr = var.vpc_cidr_block

  #choose the number and location of availability zones (AZs) for your subnets carefully to ensure high availability and fault tolerance.
  azs = var.availability_zones

  #creating private subnets in each availability zone to host resources that don't need to be publicly accessible, such as databases or application servers
  private_subnets = var.private_subnets

  #creating public subnets in each availability zone to host resources that need to be publicly accessible, such as web servers or load balancers.
  public_subnets  = var.public_subnets

  #enabling NAT gateway for private subnets to access the internet, which is necessary for resources in private subnets to download software updates or communicate with external services.
  enable_nat_gateway = true

  #using only single nat gateway for all the private subnets. Useful for cost savings
  single_nat_gateway = true

  # enabling DNS support and DNS hostnames for the VPC, which allows resources within the VPC to use Amazon-provided DNS servers to resolve domain names.
  enable_dns_support = true

  # Create tags to help identify the resources
  tags = {
    Terraform = "true"
    Environment = "prod"
  }
}
# This line creates an AWS key pair that will be used to access EC2 instances
resource "aws_key_pair" "ssh-key" {
  key_name   = "server-key"
  public_key =  file(var.public_key_location)  
}


# 
#I decided to create kubernetes cluster using kubdeadm module in terraform. This tools provide more options for customization and offer better support for high availability and security
# It configures Kubernetes with secure defaults for network policies and authentication
# It creates a security group that restricts traffic to the control plane nodes only from the worker nodes and the administrator's IP address.
module "kubeadm" {
  #provided the source of the module and version for stability 
  source  = "weibeld/kubeadm/aws"
  version = "0.2.6"

 # specify the name of the Cluster that would be created on AWS
  cluster_name = "my-kubernetes-cluster"

  # Specify the ID of the VPC and the ID of the subnet where the Kubernetes cluster will be deployed.
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.private_subnets[0] 

  # Allows you to specify the SSH keys for secure access to the instances, 
  public_key_file  = var.public_key_location
  private_key_file = var.private_key_location


 # Create tags to help identify the resources
  tags = {
    Environment = "production"
  }


}


#The kubeadm module provides a range of customizable options for fine-tuning the high availability and security of the Kubernetes cluster
#I can specify the number and type of worker nodes, the size of the instances, and the version of Kubernetes to use. I used the default because of cost