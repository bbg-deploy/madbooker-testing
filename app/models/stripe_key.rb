class StripeKey < Settingslogic
  source "#{Rails.root}/config/stripe.yml"
  namespace Rails.env
end