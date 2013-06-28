ENV["RAILS_ENV"] ||= "test"

if ENV["TM_RUBY"].nil?
require 'simplecov'
SimpleCov.start
end



require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/rails'
require "minitest/should"
#require "minitest/mock"
require 'timecop'
require 'less_interactions'
require "gen"

class MiniTest::Should::TestCase
  include Mocha::API
  include ActiveSupport::Testing::Assertions
  ActiveRecord::Migration.check_pending!
  def moc name, args = {}
    a = mock name
    return a if args.blank?
    args.each do |name, val|
      a.stubs(name).returns(val)
    end
    a
  end
end


class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
