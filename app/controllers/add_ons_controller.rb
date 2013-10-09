class AddOnsController < ApplicationController
  
  def index
    @add_ons = current_hotel.add_ons.paginate(pagination_params).decorate
    redirect_to action: :new and return if @add_ons.blank?
    render
  end
  
  def show
    @add_on = current_hotel.add_ons.find( params[:id]).decorate
    render
  end
  alias_method :edit, :show

  def create
    @add_on = current_hotel.add_ons.create add_on_params
    if @add_on.persistant?
      redirect_to action: "index"
    else
      respond_with current_hotel, @add_on
    end
  end
  
  def update
    @add_on = current_hotel.add_ons.find params[:id]
    if @add_on.update_attributes add_on_params
      redirect_to action: "index"
    else
      respond_with current_hotel, @add_on
    end
  end
  
  def destroy
    @add_on = current_hotel.add_ons.find( params[:id]).decorate
    @add_on.toggle! :active
    render
  end
  
  
  private
  def add_on_params
    params[:add_on].permit :name, :price, :description, :active
  end
  
end
