provider "aws" {
  region  = "ap-south-1"
 # access_key = aws_iam_access_key.accesskey_fruser.id
  #secret_key = "my-secret-key"
  #access_key = "AKIAWVU6CAPSPJUSQBLJ"

  #secret_key = "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"
}
resource "aws_servicecatalog_portfolio" "portfolio" {     #creating service catalog portfolio in us-east-1
  name          = "${var.portfolio_name}"
  description   = "${var.description}"
  provider_name = "${var.owner}"
}
resource "aws_servicecatalog_principal_portfolio_association" "associate_role" {  #associate role arn with the portfolio created
  portfolio_id  = aws_servicecatalog_portfolio.portfolio.id
 #principal_arn = aws_iam_role.portfoliorole.arn
# principal_arn = aws_iam_role.cicd-cp-role.arn
principal_arn = "${var.portfolio_role_arn}"
}
resource "aws_servicecatalog_portfolio_share" "portfolio_share" {  #sharing the access of sc products with account 614982824857
  principal_id = "${var.shareacc_id}"
  portfolio_id = aws_servicecatalog_portfolio.portfolio.id
  type         = "${var.shareacc_type}"
}
terraform {
    backend "s3" {
        bucket = "terraform-tfstate-s3-bucket"
        key    = "terraform/remote/s3/terraform.tfstate"
        region     = "ap-south-1"
       dynamodb_table  = "dynamodb-state-locking"
    }
}

