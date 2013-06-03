# == Schema Information
#
# Table name: projects
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  context "with team" do
    setup do
      team_create
    end
  
    should "delete memberships" do
      assert_difference "ProjectMembership.count", -2 do
        @project.destroy
      end
    end
    
    should "invite existing person" do
      person = create_person
      assert_difference "ProjectMembership.count" do
      assert_no_difference "Person.count" do
        @project.invite_member :email => person.email, :invited_by => @owner
      end
      end
    end

    should "invite new person" do
      assert_difference "ProjectMembership.count" do
      assert_difference "Person.count" do
        @project.invite_member :email => "adfsasdfasdf@sdfkh.com", :invited_by => @owner
      end
      end
    end

  end
  
  context "new owner" do
    should "create first project" do
      assert_difference "Project.count" do
      assert_difference "Person.count" do
        create_user
      end
      end
    end
  end
end
