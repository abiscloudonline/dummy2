provider "aws" {
  region  = "${var.region}"
  access_key = "${var.access_key}"                             #"AKIAWVU6CAPSKYTWJ7XU" aws_iam_access_key.accesskey_fruser.id
  secret_key = "${var.secret_key}"               #"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"   aws_iam_access_key.accesskey_fruser.secret

    assume_role {
       role_arn = "${var.portfolio_role_arn}"            #"arn:aws:iam::458819240932:role/portfoliorole" aws_iam_role.portfoliorole.arn
   }
}
#creating service catalog portfolio in us-east-1

resource "aws_servicecatalog_portfolio" "portfolio" {     
  name          = "${var.portfolio_name}"
  description   = "${var.description}"
  provider_name = "${var.owner}"
}
#associate role arn with the portfolio created

resource "aws_servicecatalog_principal_portfolio_association" "associate_role" {  
  portfolio_id  = aws_servicecatalog_portfolio.portfolio.id
 principal_arn =  "${var.portfolio_role_arn}" #"arn:aws:iam::458819240932:role/portfoliorole" aws_iam_role.portfoliorole.arn
}
#sharing the access of sc products with account 614982824857

resource "aws_servicecatalog_portfolio_share" "portfolio_share" {  
  principal_id = "${var.shareacc_id}"
  portfolio_id = aws_servicecatalog_portfolio.portfolio.id
  type         = "${var.shareacc_type}"
}

#remote storage of tf statefile and object lock using dynamo db

terraform {
    backend "s3" {
        bucket = "terraform-tfstate-s3-bucket"
        key    = "terraform/remote/s3/terraform.tfstate"
        region     = "ap-south-1"
       dynamodb_table  = "dynamodb-state-locking"
    }
}

