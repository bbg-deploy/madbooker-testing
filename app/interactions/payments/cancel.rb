class Payments::Cancel < Less::Interaction
  class Payments::Cancel::Exception < Exception; end
  
  def run
    remove
  end
  
  private
  
  def remove
    Stripe.api_version  = "2013-07-05"
    Stripe.api_key      = StripeKey.secret_key
    begin
      c = Stripe::Customer.new context.user.stripe_customer_id, Stripe.api_key
      c.delete
    rescue => e
      pe = Payments::Cancel::Exception.new "Exception while canceling for user_id: #{context.user.id}, stripe_customer_id: #{context.user.stripe_customer_id}. Original Exception: #{e.inspect}"
      Exceptions.record pe, context
    end

  end
end