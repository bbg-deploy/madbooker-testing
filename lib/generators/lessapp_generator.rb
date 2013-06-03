class LessappGenerator < Rails::Generators::Base
  argument :url, :type => :string, :default => 'example.com'

  def mailer
    insert_into_file "config/environments/development.rb", :before => /^end$/ do
      "\n  config.action_mailer.default_url_options = { :host => 'localhost:3000' }\n\n"
    end
    insert_into_file "config/environments/test.rb", :before => /^end$/ do
      "\n  config.action_mailer.default_url_options = { :host => 'localhost:3000' }\n\n"
    end
    insert_into_file "config/environments/production.rb", :before => /^end$/ do
      %|\n  config.action_mailer.default_url_options = { :host => '#{url}' }\n\n|
    end
  end

  def devise
    devise_file = "config/initializers/devise.rb"
    prepend_to_file devise_file, "require 'openid/store/filesystem'\n\n"
    gsub_file devise_file, /please-change-me@config-initializers-devise.com/, "info@#{url}"
    insert_into_file devise_file, :after => "Devise.setup do |config|\n" do
%{
  config.omniauth :facebook, "", ""
  config.omniauth :twitter, "", ""
  config.omniauth :google_apps, OpenID::Store::Filesystem.new('/tmp'), :domain => 'gmail.com'
  config.omniauth :open_id, OpenID::Store::Filesystem.new('/tmp')

}
    end
  end
end