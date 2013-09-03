# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  time_zone              :string(255)
#  stripe_customer_id     :string(255)
#  payment_status         :string(255)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  #used just to get fields on the devise form
  attr_accessor :cc_number, :cc_cvv, :cc_month, :cc_year, :stripe_token
      
  has_many :memberships
  has_many :hotels, through: :memberships
  
  scope :paying, ->{ where "payment_status in ('trialing', 'active')" }
  
  def paying?
    payment_status.in?( %w(trialing active))
  end
  
end
