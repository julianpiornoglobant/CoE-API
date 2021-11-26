terraform {
  backend "azurerm" {
    resource_group_name  = "#{tf_sa_rg_name}#"
    storage_account_name = "#{tf_sa_name}"
    container_name       = "#{proyecto}#"
    key                  = "#{api_lowercase_name}#-#{env_short_code}#-#{proyecto}#.terraform.tfstate"
  }
}
locals {
  api             = "#{api_lowercase_name}#"
  api_serviceUrl  = "#{api_serviceUrl}#"
  api_description = "#{api_long_description}#"
  rg_name         = "#{apim_rg_name}#"
  apim_name       = "#{apim_name}#"
  product_id      = "#{api_product_id}#"
  env             = "#{env_short_code}#"
}
module "api" {
  source         = "../tf_modules/apim_api"
  name           = "${local.api}-${local.env}"
  rg_name        = local.rg_name
  apim_name      = local.apim_name
  revision       = "1"
  description    = local.api_description
  display_name   = "${local.api}-${local.env}"
  path           = "${local.api}${local.env}"
  protocol       = "https"
  service_url    = local.api_serviceUrl
  content_format = "openapi+json"
  swagger_json   = "${file("apis/${local.api}/api_${local.api}_swagger.json")}"
  #swagger_json   = "${file("../../manifests/${local.api}/api_${local.api}_swagger.json")}"
}
module "api_product" {
  source     = "../tf_modules/apim_product"
  api_name   = "${local.api}-${local.env}"
  rg_name    = local.rg_name
  apim_name  = local.apim_name
  product_id = local.product_id
  dependency = module.api.apimapi_id
}
# module "api_policy" {
#   source     = "../tf_modules/apim_api_policy"
#   name       = "${local.api}-${local.env}"
#   rg_name    = local.rg_name
#   apim_name  = local.apim_name
#   policy_xml = "${file("apis/${local.api}/api_${local.api}_policy.xml")}"
#   dependency = module.api.apimapi_id
# }
#module "operation_post_policy" {
#  source       = "../tf_modules/apim_operation_policy"
#  name         = "${local.api}-${local.env}"
#  rg_name      = local.rg_name
#  apim_name    = local.apim_name
#  policy_xml   = "${file("apis/${local.api}/operation_post_policy.xml")}"
#  dependency   = module.api.apimapi_id
#  operation_id = "post"
#}
