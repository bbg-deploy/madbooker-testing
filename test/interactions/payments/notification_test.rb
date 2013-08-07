require 'test_helper'
require 'stripe_helper'

class Payments::NotificationTest < MiniTest::Should::TestCase

  def notification
    @notification ||= Payments::Notification.new context: @context
  end
  
  context "responding to an event we don't handle" do
    setup do
        p notification.private_methods.sort
      template = stripe_params("customer.subscription.created")
      template["type"] = "blah"
      @context = Context.new params: template
      Exceptions.expects :record
    end

    should "record it as not handled" do
      notification.run
    end
  end
  
  %w(account.updated charge.dispute.closed charge.dispute.created charge.dispute.updated charge.failed charge.refunded charge.succeeded coupon.created coupon.deleted customer.created customer.deleted customer.discount.created customer.discount.deleted customer.discount.updated customer.subscription.trial_will_end  customer.updated invoice.created invoice.payment_failed invoice.payment_succeeded invoice.updated invoiceitem.created invoiceitem.deleted invoiceitem.updated plan.created plan.deleted plan.updated transfer.created transfer.failed transfer.paid transfer.updated).each do |method|
    context "responding to #{method} event" do
      setup do
        @context = Context.new params: stripe_params(method)
        notification.expects method.gsub(".", "_")
        notification.expects( :update_status).never
      end

      should "call the method with no errors" do
        assert_nil notification.run
      end
    end
  end
  
  context "responding to customer_subscription_created event" do
    setup do
      @context = Context.new params: stripe_params("customer.subscription.created")
      @user = Gen.user(payment_status: "active")
      @user.expects(:update_attribute).with(:payment_status, "trialing")
      notification.stubs(:user).returns @user
    end

    should "call the method and change the subscription" do
      notification.run
    end
  end
    
  context "responding to customer_subscription_updated event" do
    setup do
      @context = Context.new params: stripe_params("customer.subscription.updated")
      @user = Gen.user(payment_status: "active")
      @user.expects(:update_attribute).with(:payment_status, "trialing")
      notification.stubs(:user).returns @user
    end

    should "call the method and change the subscription" do
      notification.run
    end
  end
    
  context "responding to customer_subscription_deleted event" do
    setup do
      @context = Context.new params: stripe_params("customer.subscription.deleted")
      @user = Gen.user
      @user.expects(:update_attribute).with(:payment_status, "canceled")
      notification.stubs(:user).returns @user
    end

    should "call the method and change the subscription" do
      notification.run
    end
  end
    
end