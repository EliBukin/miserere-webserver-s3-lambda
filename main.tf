provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "webserver_cluster" {
  source = "./modules/web-server/"
}

module "s3-bucket" {
  source = "./modules/s3-bucket/"
}

module "lambda" {
  source = "./modules/lambda/"
  depends_on = [module.s3-bucket]
}
