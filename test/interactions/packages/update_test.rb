require 'test_helper'

class Packages::UpdateTest < ActiveSupport::TestCase

  def update
    @update ||= Packages::Update.new context: @context
    @update.stubs(:package).returns @package
    @update
  end
  
  def param model, add_on_ids
    a = model.attributes
    [:id, :hotel_id, :created_at, :updated_at, :active].each do |at|
      a.delete at.to_s
    end
    a[:add_on_ids] = add_on_ids
    ActionController::Parameters.new( package: a)    
  end

  context "while updating" do
    setup do
      @add_on = Gen.add_on!
      @package = Gen.package!
      @package.update_attribute :add_on_ids, [@add_on.id]
    end
    
    teardown do
      @package.delete
      @package = nil
    end

    should "fail with empty add_on_ids" do
      @context = Context.new hotel: Gen.hotel, params: param(@package, [])
      update.expects(:save).never
      assert !update.run.errors.blank?
    end

    should "fail with only empty item add_on_ids" do
      @context = Context.new hotel: Gen.hotel, params: param(Gen.package, [""])
      update.expects(:save).never
      assert !update.run.errors.blank?
    end

    should "pass with one empty item and one id add_on_ids" do
      Gen.add_on! id: 1
      @context = Context.new hotel: Gen.hotel, params: param(Gen.package, ["", "1"])
      update.expects(:save).once
      assert update.run.errors.empty?
    end
  end
  
  
    
end