provider "aws" {
  region  = "${var.region}"
  access_key = "AKIAWVU6CAPSKYTWJ7XU" #aws_iam_access_key.accesskey_fruser.id
  secret_key = "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"   #aws_iam_access_key.accesskey_fruser.secret
 # access_key = "AKIAWVU6CAPSD45X2C5I"

  #secret_key = "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"
    assume_role {
       #role_arn = "arn:aws:iam::458819240932:role/codebuild-role"
       role_arn = "arn:aws:iam::458819240932:role/portfoliorole" #aws_iam_role.portfoliorole.arn
       
       # profile = "default"
   }
}
resource "aws_servicecatalog_portfolio" "portfolio" {     #creating service catalog portfolio in us-east-1
  name          = "${var.portfolio_name}"
  description   = "${var.description}"
  provider_name = "${var.owner}"
}
resource "aws_servicecatalog_principal_portfolio_association" "associate_role" {  #associate role arn with the portfolio created
  portfolio_id  = aws_servicecatalog_portfolio.portfolio.id
 principal_arn = "arn:aws:iam::458819240932:role/portfoliorole"#aws_iam_role.portfoliorole.arn
 #principal_arn = aws_iam_role.cicd-codebuild-role.arn
#principal_arn = "${var.portfolio_role_arn}"
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

