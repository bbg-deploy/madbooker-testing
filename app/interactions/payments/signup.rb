class Payments::Signup < Less::Interaction
  
  def run
    what_does_stripe_say
  end
  
  private
  def what_does_stripe_say
    Stripe.api_version  = "2013-07-05"
    Stripe.api_key      = StripeKey.secret_key
    ok                  = nil
    customer            = nil
    ok, customer = check_for_errors do
      Stripe::Customer.create(
        description:  context.user.id.to_s,
        card:         context.params[:user][:stripe_token],
        email:        context.user.email,
        plan:         StripeKey.basic
        )
    end
    if ok
      save_the_stripe_data_to_user customer
      Stat.new_user context: context
      true
    else
      save_the_error_to_the_user customer
      false
    end
  end

  def save_the_stripe_data_to_user customer
    context.user.stripe_customer_id = customer["id"]
    context.user.payment_status = customer["subscription"]["status"]
    context.user.save
  end
  
  def save_the_error_to_the_user message
    context.user.destroy
    context.user.errors.add :base, message
  end
  
  def check_for_errors
    begin
      c = yield
      [true, c]      
    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      [false, e.json_body[:error][:message]]
    rescue Stripe::InvalidRequestError, Stripe::AuthenticationError, Stripe::APIConnectionError, Stripe::StripeError => e
      #there's nothing we can do about these
      Exceptions.record e
      [false, "Uh oh, an error happened. We've been notified, but feel free to contact support for assistance."]
    end
  end
  
  def error ex
    e.json_body[:error]
  end
  
  def error_status ex
    ex.http_status
  end
  
end