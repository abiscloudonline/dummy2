resource "aws_servicecatalog_product" "oms_vpc" {              #creating a vpc product for service catalog
  name  = "${var.vpc_name}"
  owner = "${var.owner}"
  type  = "${var.type}"

  provisioning_artifact_parameters {
    template_url = "https://${aws_s3_bucket.cf_template_bucket.id}.s3.${var.region}.amazonaws.com/${aws_s3_object.vpctemplate.key}"
    template_url = "https://omsbucketcftemplate.s3.ap-south-1.amazonaws.com/cf_template_vpc_subnet_igw_sg.yaml"
    name = "${var.vpc_name}"
    type  = "${var.type}"
  }
}
resource "aws_servicecatalog_product_portfolio_association" "vpc_assoc" {   #associate product with the portfolio created
  portfolio_id = aws_servicecatalog_portfolio.portfolio.id
  product_id   = aws_servicecatalog_product.oms_vpc.id
}
data "aws_servicecatalog_launch_paths" "vpcproductpath" {       #defining path for the product
  product_id = aws_servicecatalog_product.oms_vpc.id
}
resource "aws_servicecatalog_provisioned_product" "provisioned_vpc" {   #Configuring the product with artifact and path defined
  name                   = "${var.vpc_name}"
  product_id             = aws_servicecatalog_product.oms_vpc.id
  path_id                = data.aws_servicecatalog_launch_paths.vpcproductpath.summaries[0].path_id
  provisioning_artifact_name = aws_servicecatalog_product.oms_vpc.provisioning_artifact_parameters[0].name
}

