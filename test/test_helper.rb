ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'fixjours'


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end


class ActionDispatch::IntegrationTest
  require 'capybara/rails'
  require 'capybara/dsl'
  include Capybara
  
  #Capybara.default_driver = :selenium
  Capybara.run_server = true
  Capybara.server_port = 9887

  setup { Capybara.reset_sessions! }

  def hack_dialogs(page, result = true)
    page.evaluate_script("window.alert = function(msg) { return #{result}; }")
    page.evaluate_script("window.confirm = function(msg) { return #{result}; }")
  end
  
end

