require 'test_helper'

class AuthTest < ActionDispatch::IntegrationTest
  fixtures :all

  should "signup" do
    assert_difference "User.count" do
    assert_difference "Person.count" do
    assert_difference "Project.count" do
    assert_difference "ProjectMembership.count" do
      visit("/signup")
      fill_in("Email", :with => 'asfd@sdf.com')
      fill_in 'Password', :with => "123456"
      fill_in 'Confirmation', :with => "123456"
      click_button "Submit"
      page.has_content? Project::DEFAULT_TITLE
    end
    end
    end
    end
  end
  
  should "login" do
    team_create
    
      assert_no_difference "User.count" do
      assert_no_difference "Person.count" do
      assert_no_difference "Project.count" do
      assert_no_difference "ProjectMembership.count" do
        visit("/login")
        fill_in("Email", :with => @member.email)
        fill_in 'Password', :with => "xxxxxx"
        click_button "Submit"
        page.has_content? Project::DEFAULT_TITLE
      end
      end
      end
      end
  end
  
end
