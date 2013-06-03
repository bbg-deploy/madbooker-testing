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

require 'test_helper'

class ProjectMembershipTest < ActiveSupport::TestCase
  context "with team" do
    setup do
      team_create
    end
    
    should "delete membership for member" do
      assert_difference "ProjectMembership.count", -1 do
        ProjectMembership.where(:person_id => @member.id).destroy_all
      end
    end

    should "not delete membership for owner" do
      assert_no_difference "ProjectMembership.count" do
        ProjectMembership.where(:person_id => @owner.id).destroy_all
      end
    end
    
  end
end
