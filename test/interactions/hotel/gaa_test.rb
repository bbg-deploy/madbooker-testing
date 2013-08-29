require 'test_helper'

class Hotel::GaaTest < ActiveSupport::TestCase


  def ga
    ga ||= Hotel::Gaa.new context: @context, less_ga: @less_ga
  end
  
  context "a google auth" do
    setup do
      @hotel = Gen.hotel gauth_access_token: "access_token"
      @less_ga = mock
      @data = mock
    end
    
    context "with no accounts" do
      setup do
        @accounts = {items: []}
        @data.stubs(:accounts).returns @accounts
        @less_ga.stubs(:data).returns @data
        @context = Context.new hotel: @hotel, params: {}
      end
    
      should "get all the accounts and profiles you can" do
        g = ga.run
        assert !g.go_to_report?
        assert !g.need_to_pick_account?
        assert !g.need_to_pick_profile?
        assert_equal [], g.accounts
        assert_equal [], g.profiles
      end
    end
    
    context "with multiple accounts" do
      setup do
        @accounts = {items: ["a1", "a2"]}
        @data.stubs(:accounts).returns @accounts
        @less_ga.stubs(:data).returns @data
        @context = Context.new hotel: @hotel, params: {}
      end
    
      should "get all the accounts and profiles you can" do
        g = ga.run
        assert !g.go_to_report?
        assert g.need_to_pick_account?
        assert !g.need_to_pick_profile?
        assert_equal @accounts, g.accounts
        assert_equal [], g.profiles
      end
    end
    
        
    context "with one account and two profiles" do
      setup do
        @accounts = {items: [{id: 13241}]}
        @data.stubs(:accounts).returns @accounts
        @profiles = { items: [{id: 1234}, {id: 6432}] }
        @data.stubs(:profiles).returns @profiles
        @less_ga.stubs(:data).returns @data
        @context = Context.new hotel: @hotel, params: {}
      end

      should "get all the accounts and profiles you can" do
        g = ga.run
        assert !g.go_to_report?
        assert !g.need_to_pick_account?
        assert g.need_to_pick_profile?
        assert_equal @accounts, g.accounts
        assert_equal @profiles, g.profiles
      end
    end
    
        
    context "with one account and one profile" do
      setup do
        @accounts = {items: [{id: 13241}]}
        @data.stubs(:accounts).returns @accounts
        @profiles = { items: [{id: 6432}] }
        @data.stubs(:profiles).returns @profiles
        @less_ga.stubs(:data).returns @data
        @context = Context.new hotel: @hotel, params: {}
      end

      should "get the account and profile" do
        g = ga.run
        assert g.go_to_report?
        assert !g.need_to_pick_account?
        assert !g.need_to_pick_profile?
        assert_equal @accounts, g.accounts
        assert_equal @profiles, g.profiles
      end
    end
        
        
    context "having account_id already and two profiles" do
      setup do
        @profiles = { items: [{id: 1234}, {id: 6432}] }
        @data.stubs(:profiles).returns @profiles
        @less_ga.stubs(:data).returns @data
        @hotel.ga_account_id = "account_id"
        @context = Context.new hotel: @hotel, params: {}
      end

      should "get all the accounts and profiles you can" do
        g = ga.run
        assert !g.go_to_report?
        assert !g.need_to_pick_account?
        assert g.need_to_pick_profile?
        assert_equal @profiles, g.profiles
      end
    end


        
    context "having account_id and profile_id already" do
      setup do
        @hotel.ga_account_id = "account_id"
        @hotel.ga_profile_id = "profile_id"
        @context = Context.new hotel: @hotel, params: {}
      end

      should "get all the accounts and profiles you can" do
        g = ga.run
        assert g.go_to_report?
        assert !g.need_to_pick_account?
        assert !g.need_to_pick_profile?
      end
    end


  end
  
  
end