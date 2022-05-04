module "app_service_test" {
    source = "./modules/"
    app_service_plan_name = "plan-test"
    app_service_name = "kenrick-app-service-test"
    resource_group_name = "appservice-sample-test-rg"
    resource_group_location = "East US"
}
