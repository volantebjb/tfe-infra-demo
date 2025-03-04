module "vpc_secondary" {
  source            = "../../vpc"
  vpc_name          = "${data.aws_caller_identity.current.account_id}-vpc-secondary"
  vpc_cidr_block    = "10.0.1.0/24"
  subnet_cidr_block = "10.0.1.0/28"
}

resource "aws_flow_log" "vpc_flow_log" {
  vpc_id               = module.vpc_secondary.vpc_id
  log_destination      = data.terraform_remote_state.vpc_flow_log.outputs.vpc_flow_log.s3_bucket_arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
}

module "ec2_secondary" {
  source    = "../../ec2"
  ami       = "ami-07b69f62c1d38b012"
  subnet_id = module.vpc_secondary.subnet_id
  key_name  = "ec2-key"
  public_key_path = "../ec2-key.pub"
}
