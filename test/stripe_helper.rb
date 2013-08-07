

class MiniTest::Should::TestCase
  # load yaml with specified callback type
  def load_template(callback_type)

    path = "#{Rails.root}/test/fixtures/stripe_webhooks/2013-07-05/#{callback_type}.yml"
    if File.exists?(path)
      template = Psych.load_file(path)
    else
      raise "Webhook not found. Please use a correct webhook type or correct Stripe version"
    end
  end
end

