require 'test_helper'

class Packages::CreateTest < MiniTest::Should::TestCase

  def create
    @create ||= Packages::Create.new context: @context
  end
  
  def param model, add_on_ids
    a = model.attributes
    [:id, :hotel_id, :created_at, :updated_at, :active].each do |at|
      a.delete at.to_s
    end
    a[:add_on_ids] = add_on_ids
    ActionController::Parameters.new( package: a)    
  end

  context "while creating" do

    should "fail with empty add_on_ids" do
      @context = Context.new hotel: Gen.hotel, params: param(Gen.package, [])
      create.expects(:save).never
      assert !create.run.errors.blank?

    end

    should "fail with only empty item add_on_ids" do
      @context = Context.new hotel: Gen.hotel, params: param(Gen.package, [""])
      create.expects(:save).never
      assert !create.run.errors.blank?
    end

    should "pass with one empty item and one id add_on_ids" do
      @context = Context.new hotel: Gen.hotel, params: param(Gen.package, ["", "1"])
      create.expects(:save).once
      assert create.run.errors.blank?
    end
  end
  
  
    
end