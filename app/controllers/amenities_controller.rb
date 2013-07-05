class AmenitiesController < ApplicationController
  
  def index
    @amenities = current_hotel.amenities.paginate(pagination_params).decorate
    redirect_to action: :new and return if @amenities.blank?
    render
  end
  
  def show
    @amenity = current_hotel.amenities.find( params[:id]).decorate
    render
  end
  alias_method :edit, :show

  def create
    @amenity = current_hotel.amenities.create amenity_params
    respond_with [current_hotel, @amenity]
  end
  
  def update
    @amenity = current_hotel.amenities.find params[:id]
    @amenity.update_attributes amenity_params
    respond_with [current_hotel, @amenity]
  end
  
  def destroy
    @amenity = current_hotel.amenities.find( params[:id]).decorate
    @amenity.toggle! :active
    render
  end
  
  
  private
  def amenity_params
    params[:amenity].permit :name, :price, :description, :active
  end
  
end
