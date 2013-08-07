class Payments::Notification < Less::Interaction

  def run
    handle_notification
  end
  
  private
  
  def handle_notification
    if respond_to? event, true
      send event 
    else
      #don't ever return an excpetion.
      #stripe will try again and again to send the event.
      #if we can't handle it today, we prob can't tomorrow, better to record it and tell stripe we got it.
      #(by returning 200)
      Exceptions.record "Unhanded Stripe event '#{event}'"
      nil
    end
  end  
  
  def event
    @event ||= context.params["type"].gsub( ".", "_").to_sym
  end
  
  def data
    @data ||= context.params["data"]["object"]
  end
  
  def user
    return @user if @user
    u = User.find_by_id data["customer"]
    return @user = u if u
    Exceptions.record "User not found while handling Stripe event", context.params
    nil
  end
  
  #these are the only methods that deal with changes to the subscription status
  %w(
    customer_created 
    customer_updated 
    customer_deleted 
    customer.subscription.trial_will_end 
    customer_subscription_updated 
    customer_subscription_deleted
    customer_subscription_created
    ).each do |method|
      define_method method do
        update_status
      end
    end
  
  def update_status
    return unless user
    user.update_attribute :payment_status, data["status"]
  end
  
  
  #these are the stripe events we don't care about
  %w(customer_subscription_trial_will_end  balance_available  charge_succeeded  charge_failed  charge_refunded  charge_captured  charge_dispute_created  charge_dispute_updated  charge_dispute_closed  customer_card_created  customer_card_updated  customer_card_deleted  customer_discount_created  customer_discount_updated  customer_discount_deleted  invoice_created  invoice_updated  invoice_payment_succeeded  invoice_payment_failed  invoiceitem_created  invoiceitem_updated  invoiceitem_deleted  plan_created  plan_updated  plan_deleted  coupon_created  coupon_deleted  transfer_created  transfer_updated  transfer_paid  transfer_failed  ping).each do |method|
    define_method method do
      #nothing
      nil
    end
  end
  
  

end