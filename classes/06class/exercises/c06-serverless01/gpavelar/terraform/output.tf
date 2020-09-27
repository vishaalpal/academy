#API Gateway
output "api_gw_api_url" {
  value = module.apigw.api_url
}

output "api_key" {
  value = module.apigw.api_gw_api_key
}