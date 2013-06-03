# == Schema Information
#
# Table name: users
#
#  id                   :integer(4)      not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  reset_password_token :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer(4)      default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  password_salt        :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class User < ActiveRecord::Base
  has_many :authentications, :dependent => :destroy
  has_one :person

  # Include devise modules. Others available are:
  # :lockable, :timeoutable, :confirmable and :activatable
  devise :registerable, :validatable, :database_authenticatable,
         :omniauthable, :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  
  after_create :setup_person

  def apply_omniauth(omniauth)
    self.email = omniauth['user_info']['email'] if self.email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  
  
  def setup_person
    p = Person.find_or_create_by_email email
    raise 'User found when should be nil' unless p.user.blank?
    p.update_attributes :user_id=>self.id
    p.create_first_project
  end
  
  
end
