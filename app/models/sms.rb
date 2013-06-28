class Sms
  
  def self.deliver to, msg
    client = Twilio::REST::Client.new(App.twilio_sid, App.twilio_auth)
    client.account.sms.messages.create(from: App.twilio_number, to: to, body:msg)
  end
  
end