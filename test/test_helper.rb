ENV["RAILS_ENV"] ||= "test"

if ENV["TM_RUBY"].nil?
require 'simplecov'
SimpleCov.start
end



require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'minitest/rails'
#require "minitest/should"
#require "minitest/mock"
require "mocha/setup"
require 'timecop'
require 'less_interactions'
require "gen"



class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  def moc name, args = {}
    a = mock name
    return a if args.blank?
    args.each do |name, val|
      a.stubs(name).returns(val)
    end
    a
  end
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  
  def remove_non_permitted_booking_attrs hash
    hash[:booking].delete_if {|k,v| k.to_s.in? %w(id hotel_id encrypted_cc_number encrypted_cc_cvv state customer_id rate discounted_rate created_at updated_at guid paid total) }
    hash
  end

end

class Sms
  def self.deliver to, msg
    true
  end
end
