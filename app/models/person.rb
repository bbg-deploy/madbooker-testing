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

class Person < ActiveRecord::Base
  belongs_to :user
  has_many :project_memberships, :dependent => :destroy
  has_many :projects, :through => :project_memberships, :order=>'name'
  
  
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message=>'does not look like an email address.'
  validates_uniqueness_of :email, :case_sensitive => false
  
  
  
  def name
    ((self.first_name || '') + ' ' + (self.last_name || '')).strip  
  end
  
  def f
    full_name
  end
  
  def full_name
    return name unless name.blank?
    return user.email unless user.blank?
    email
  end
  
  
  def self.find_or_create_by_params params
    p = find_by_email params[:email]
    p = create( params) if p.blank?
    p
  end
  
  def create_first_project
    return true unless projects.reload.blank?
    Project.create_for_owner( {:name => Project::DEFAULT_TITLE}, self)
  end
  
end
