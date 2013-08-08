require 'test_helper'
require 'stripe_helper'

class Payments::SignupTest < MiniTest::Should::TestCase

  def signup
    @signup ||= Payments::Signup.new context: context
  end
  
  def context
    @context ||= Context.new( user: @user, params: {"user"=>{"email"=>"xx@gmail.com", "password"=>"[FILTERED]", "password_confirmation"=>"[FILTERED]", "cc_number"=>"", "cc_month"=>"2", "cc_year"=>"2014", "cc_cvv"=>"", "stripe_token"=>"tok_2LdyrgYEFCOjYa"}}.with_indifferent_access)
  end
  
  
  context "a user and a proper stripe" do
    setup do
      @user = Gen.user
      @user.expects :save
      Stripe::Customer.expects(:create).returns( {"id" => 1, "subscription" => {"status" => "active"}})
    end

    should "create a stripe subscription" do
      assert signup.run
    end
  end
  
  context "a user and an improper stripe" do
    setup do
      @user = Gen.user
      @user.expects( :save).never
      @user.expects( :destroy)
      Stripe::Customer.expects(:create).raises(Stripe::CardError.new("message", "param", "code", "http_status", "http_body", {error:{message:"card error"}}))
    end

    should "not create a stripe subscription" do
      assert !signup.run
    end
  end
  
  [Stripe::InvalidRequestError, 
    Stripe::AuthenticationError, 
    Stripe::APIConnectionError, 
    Stripe::StripeError].each do |error|
    context "a user and an improper stripe #{error}" do
      setup do
        @user = Gen.user
        @user.expects( :save).never
        @user.expects( :destroy)
        Stripe::Customer.expects(:create).raises(error.new("message", "param", "code"))
        Exceptions.expects :record
      end

      should "not create a stripe subscription" do
        assert !signup.run
      end
    end
  end
  
end
  
