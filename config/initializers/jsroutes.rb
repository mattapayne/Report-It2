JsRoutes.setup do |config|
  config.namespace = "ReportIt.routes"
  config.exclude = [/^routes$/, /^rails_info$/, /^rails_info_routes$/, /^rails_info_properties$/]
end