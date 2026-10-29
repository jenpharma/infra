terraform {
  backend "s3" {
    bucket       = "jen-pharma-terraform-state"
    key          = "envs/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
