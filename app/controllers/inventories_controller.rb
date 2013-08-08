class InventoriesController < ApplicationController
  
  def index
    i = Inventory::Calendar.new(context: context).run
    @calendar = CalendarDecorator.new i
  end
  
  def show
    index
    render action: "index"
  end
  
  def create
     i = Inventory::Create.new( context:context).run
    create_resource_helper_methods_for i.object, :inventory_form
    create_resource_helper_methods_for i, :resp
  end
  
  
  
  def form
    res Inventory::Form.new(context: context).run, :inventory_form, layout: false
  end
  
end
