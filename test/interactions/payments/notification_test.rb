require 'test_helper'
require 'stripe_helper'

class Payments::NotificationTest < MiniTest::Should::TestCase

  def notification
    @notification ||= Payments::Notification.new context: @context
  end
  
  context "responding to an event we don't handle" do
    setup do
      template = stripe_params("customer.subscription.created")
      template["type"] = "blah"
      @context = Context.new params: template
      Exceptions.expects :record
    end

    should "record it as not handled" do
      notification.run
    end
  end
  
  Payments::Notification::IGNORED_EVENTS.each do |method|
    context "responding to #{method} event" do
      setup do
        @context = Context.new params: stripe_params(method)
        @user = Gen.user(payment_status: "active")
        notification.stubs(:user).returns @user
        #notification.expects method.gsub(".", "_")
        notification.expects( :update_status).never
      end

      should "call the method with no errors" do
        assert_nil notification.run
      end
    end
  end
  
  
  Payments::Notification::HANDLED_EVENTS.each do |method|
    context "responding to #{method} event" do
      setup do
        @context = Context.new params: stripe_params(method)
        @user = Gen.user(payment_status: "active")
        @user.expects(:update_attribute).with(:payment_status, status( method))
        notification.stubs(:user).returns @user
      end

      should "call the method and change the subscription" do
        notification.run
      end
    end
  end
      
      
  def status method
    if method.in? %w(customer.subscription.deleted)
      "canceled"
    else
      "trialing"
    end
  end
    
end