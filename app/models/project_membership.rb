# == Schema Information
#
# Table name: project_memberships
#
#  id            :integer(4)      not null, primary key
#  person_id     :integer(4)
#  project_id    :integer(4)
#  owner         :boolean(1)      default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#  invited_by_id :integer(4)
#

class ProjectMembership < ActiveRecord::Base
  belongs_to :project
  belongs_to :person
  belongs_to :invited_by, :class_name => "Person", :foreign_key => "invited_by_id"
  
  validates_presence_of :person_id, :project_id
  
  scope :with_people, {:joins => [:person]}
  
  attr_accessor :email, :first_name, :last_name
  
  before_destroy :dont_destroy_owner
  after_create :send_invite
  
  
  def send_invite
    return true if owner? || invited_by_id.blank?
    invite = AccountMailer.invite self 
    invite.deliver
  end
  
  
  def dont_destroy_owner
    return false if owner?
  end
  
end
