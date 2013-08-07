require 'test_helper'
require 'stripe_helper'

class Payments::NotificationTest < MiniTest::Should::TestCase

  def notification
    @notification ||= Payments::Notification.new context: @context
  end
  
  context "responding to an event we don't handle" do
    setup do
      template = load_template(:invoice_created)
      template["type"] = "blah"
      @context = Context.new params: template
      Exceptions.expects :record
    end

    should "record it as not handled" do
      notification.run
    end
  end
  
  %w(charge_failed  
  charge_refunded
  charge_succeeded    
  customer_created    
  customer_deleted
  customer_subscription_trial_will_end
  invoice_payment_failed
  invoice_payment_succeeded  
  invoice_updated
  invoice_created).each do |method|
    context "responding to #{method} event" do
      setup do
        @context = Context.new params: load_template(method)
        notification.expects method
      end

      should "call the method with no errors" do
        assert_nil notification.run
      end
    end
  end
  
  
  context "responding to customer_subscription_created event" do
    setup do
      @context = Context.new params: load_template(:customer_subscription_created)
      @user = Gen.user(payment_status: "trailing")
      @user.expects(:update_attribute).with(:payment_status, "active")
      notification.stubs(:user).returns @user
    end

    should "call the method and change the subscription" do
      notification.run
    end
  end
    
  context "responding to customer_subscription_updated event" do
    setup do
      @context = Context.new params: load_template(:customer_subscription_updated)
      @user = Gen.user(payment_status: "trailing")
      @user.expects(:update_attribute).with(:payment_status, "active")
      notification.stubs(:user).returns @user
    end

    should "call the method and change the subscription" do
      notification.run
    end
  end
    
  context "responding to customer_subscription_deleted event" do
    setup do
      @context = Context.new params: load_template(:customer_subscription_deleted)
      @user = Gen.user
      @user.expects(:update_attribute).with(:payment_status, "canceled")
      notification.stubs(:user).returns @user
    end

    should "call the method and change the subscription" do
      notification.run
    end
  end
    
end