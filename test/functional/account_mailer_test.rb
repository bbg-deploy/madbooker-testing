require 'test_helper'

class AccountMailerTest < ActionMailer::TestCase
  
  context "invite" do
    should "send invite email" do
      #should only send one mailer for member, not owner
      assert_difference "ActionMailer::Base.deliveries.size" do
        team_create
      end
      assert_match /Hi steve/, ActionMailer::Base.deliveries.first.body
    end
  end
end
