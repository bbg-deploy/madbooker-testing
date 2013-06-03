# == Schema Information
#
# Table name: people
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  first_name :string(255)
#  last_name  :string(255)
#  icon       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  
    def test_should_create_user
     assert_difference "User.count" do
       user = create_user
       assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
       assert user.person
     end
    end


  should "destroy and dependents" do
    u = users(:first)
    assert u.person
    u.destroy

    assert_nil u.person.reload
    assert_nil User.find_by_id(u.id)
  end




  should "create a new user and grab an existing person" do
    assert u = create_user( :email=>'13_invited@example.com')
    assert !u.new_record?
    assert_equal u, Person.find_by_email('13_invited@example.com').user
    assert_equal Person.find_by_email('13_invited@example.com'), u.reload.person
  end

  
  context "The Person class" do
    
    
    should "return an exiting person from find" do
      email = people(:first).email
      assert Person.find_by_email(email)
      assert p = Person.find_or_create_by_params(:email=>email)
      assert !p.new_record?
      assert_equal people(:first), p.reload
    end
  end

  protected
  def create_user(options = {})
    User.create({ :email => 'quire@example.com',
                :password => 'quiree', :password_confirmation => 'quiree' }.merge(options))
  end
end
