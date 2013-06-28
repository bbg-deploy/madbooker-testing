require "test_helper"

class BookingMailerTest < ActionMailer::TestCase
  test "confirmation" do
    booking = Gen.booking
    mail = BookingMailer.confirmation booking
    assert !booking.guid.blank?
    assert mail.body.encoded[booking.guid]
  end

end
