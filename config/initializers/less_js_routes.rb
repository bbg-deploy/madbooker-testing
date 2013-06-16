Less::Js::Routes::Config.configure do |config|
  config.debug = false                                                  #default is false
  config.ignore = [/admin/]       #default is []
  config.only = [
      :inventories
      ]                         #default is []
  config.output_path = "#{Rails.root}/app/assets/javascripts/less_routes.js"
end