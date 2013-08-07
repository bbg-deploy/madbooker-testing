class Payments::Notification < Less::Interaction

  def run
    handle_notification
  end
  
  private
  
  def handle_notification
    if respond_to? event, true
      send event 
    else
      Exceptions.record "Unhanded Stripe event '#{event}'"
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
  
  def customer_subscription_updated 
    update_status
  end
  
  def customer_subscription_deleted
    update_status
  end
  
  def customer_subscription_created
    update_status
  end
  
  def account_updated
    update_status
  end
  
  def account_application_deauthorized
    update_status
  end
  
  def update_status
    return unless user
    user.update_attribute :payment_status, data["status"]
  end
  
  
  #these are the stripe events we don't care about
  %w(customer_subscription_trial_will_end  balance_available  charge_succeeded  charge_failed  charge_refunded  charge_captured  charge_dispute_created  charge_dispute_updated  charge_dispute_closed  customer_created  customer_updated  customer_deleted  customer_card_created  customer_card_updated  customer_card_deleted  customer_discount_created  customer_discount_updated  customer_discount_deleted  invoice_created  invoice_updated  invoice_payment_succeeded  invoice_payment_failed  invoiceitem_created  invoiceitem_updated  invoiceitem_deleted  plan_created  plan_updated  plan_deleted  coupon_created  coupon_deleted  transfer_created  transfer_updated  transfer_paid  transfer_failed  ping).each do |method|
    define_method :method do
      #nothing
    end
  end
  
  
#  Parameters: {"created"=>1326853478, "livemode"=>false, "id"=>"evt_00000000000000", "type"=>"charge_succeeded", "object"=>"event", "data"=>{"object"=>{"id"=>"ch_00000000000000", "object"=>"charge", "created"=>1375725302, "livemode"=>false, "paid"=>true, "amount"=>100, "currency"=>"usd", "refunded"=>false, "fee"=>0, "fee_details"=>nil, "card"=>{"id"=>"cc_00000000000000", "object"=>"card", "last4"=>"4242", "type"=>"Visa", "exp_month"=>8, "exp_year"=>2014, "fingerprint"=>"YVUUSXlbnc9u230c", "customer"=>nil, "country"=>"US", "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "cvc_check"=>nil, "address_line1_check"=>nil, "address_zip_check"=>nil}, "captured"=>true, "failure_message"=>nil, "failure_code"=>nil, "amount_refunded"=>0, "customer"=>nil, "invoice"=>nil, "description"=>"My First Test Charge (created for API docs)", "dispute"=>nil}}, "stripe"=>{"created"=>1326853478, "livemode"=>false, "id"=>"evt_00000000000000", "type"=>"charge_succeeded", "object"=>"event", "data"=>{"object"=>{"id"=>"ch_00000000000000", "object"=>"charge", "created"=>1375725302, "livemode"=>false, "paid"=>true, "amount"=>100, "currency"=>"usd", "refunded"=>false, "fee"=>0, "fee_details"=>nil, "card"=>{"id"=>"cc_00000000000000", "object"=>"card", "last4"=>"4242", "type"=>"Visa", "exp_month"=>8, "exp_year"=>2014, "fingerprint"=>"YVUUSXlbnc9u230c", "customer"=>nil, "country"=>"US", "name"=>nil, "address_line1"=>nil, "address_line2"=>nil, "address_city"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_country"=>nil, "cvc_check"=>nil, "address_line1_check"=>nil, "address_zip_check"=>nil}, "captured"=>true, "failure_message"=>nil, "failure_code"=>nil, "amount_refunded"=>0, "customer"=>nil, "invoice"=>nil, "description"=>"My First Test Charge (created for API docs)", "dispute"=>nil}}}}

end