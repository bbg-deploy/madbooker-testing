# == Schema Information
#
# Table name: projects
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Project < ActiveRecord::Base
  has_many :project_memberships, :dependent => :delete_all
  has_many :people, :through => :project_memberships
  
  scope :i_own, {:conditions => {"project_memberships.owner" => true}}
  scope :by_name, {:order => "name asc"}
  
  validates_presence_of :name
  
  DEFAULT_TITLE = "Your first project"
  
  def self.create_for_owner params, owner
    project = create params
    project.project_memberships.create(:owner => true, :person => owner)
    project
  end
  
  def invite_member params
    person = Person.find_or_create_by_email params[:email]
    person.first_name ||= params[:first_name]
    person.last_name ||= params[:last_name]
    person.save
    pm = project_memberships.build params.merge({:person => person})
    if person.new_record?
      pm.errors_combine person.errors
      return pm
    end
    pm.save
    pm
  end
end
