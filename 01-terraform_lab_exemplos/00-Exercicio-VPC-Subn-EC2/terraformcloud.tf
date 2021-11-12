terraform {
  backend "remote" {
    organization = "EH_Home"

    workspaces {
      name = "workspace1"
    }
  }
}