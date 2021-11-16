provider "aws" {
  region = "sa-east-1"
}

module "instancia" {
  source = "./EC2-Mod"
  Nome = "Instancia-1"
  SubnetId = "subnet-0cde2b21259997493"
  instanceType ="t2.large"
}