class Payments::Notification < Less::Interaction

  #these are the stripe events we don't care about
  IGNORED_EVENTS = %w(account.updated charge.dispute.closed charge.dispute.created charge.dispute.updated charge.failed charge.refunded charge.succeeded coupon.created coupon.deleted customer.discount.created customer.discount.deleted customer.discount.updated invoice.created invoice.payment_succeeded invoice.updated invoiceitem.created invoiceitem.deleted invoiceitem.updated plan.created plan.deleted plan.updated transfer.created transfer.failed transfer.paid transfer.updated)

  #these are the only methods that deal with changes to the subscription status
  HANDLED_EVENTS = %w(customer.created customer.updated customer.deleted customer.subscription.trial_will_end customer.subscription.updated customer.subscription.deleted customer.subscription.created )
  
  #these have custom implamantations
  CUSTOM_EVENTS = %w( invoice.payment_failed )

 
 
  def run
    handle_notification
  end
  
  def self.clean_event_name name
    name.gsub(".", "_")
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
      Exceptions.record "Unhanded Stripe event '#{event}'", context
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
    u = User.find_by_stripe_customer_id data["customer"]
    return @user = u if u
    Exceptions.record "User not found while handling Stripe event", context
    nil
  end
  
  HANDLED_EVENTS.each do |method|
      define_method clean_event_name(method) do
        if data["status"]
          update_status data["status"]
        else
          update_status data["subscription"]["status"]
        end
      end
    end
      
  def update_status status
    return unless user
    user.update_attribute :payment_status, status
    Stat.subscription user: user
  end
  
  
  IGNORED_EVENTS.each do |method|
    define_method clean_event_name(method) do
      #nothing
      nil
    end
  end
  
  
  def invoice_payment_failed
    PaymentMailer.send("charged_failed_#{context.params["data"]["attempt_count"]}", user).deliver
  end
  
  

end