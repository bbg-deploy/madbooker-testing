class HotelsController < ApplicationController
  
  def new
    hotel = Hotel.new
    hotel.room_types.build
    res hotel.decorate
  end
  
  def edit
    current_hotel.room_types.build if current_hotel.room_types.count == 0
    res current_hotel.decorate
  end  
  
  def create
    hotel = Hotel.create hotel_params.merge(user_id: current_user.id)
    if hotel.persisted?
      redirect_to [:edit, hotel], notice: "Saved"
    else
      res hotel.decorate
    end
  end
  
  def update
    if current_hotel.update_attributes hotel_params
      redirect_to [:edit, current_hotel], notice: "Saved"
    else
      res current_hotel.decorate
    end
  end
  
  def show
    res current_hotel.decorate, nil, layout: "public"
  end
  
  def delete_logo
    render nothing: true and return unless can? :update, current_hotel
    current_hotel.update_attribute :logo, nil
  end
  
  private
  def hotel_params
    params[:hotel].permit :user_id, :name, :address, :url, :phone, :fax, 
      :url, :room_rates_display, :subdomain, :google_analytics_code, :time_zone,
      :fine_print, :logo, :room_rates_display, 
      :room_types_attributes => [:name, :description, :number_of_rooms, 
        :default_rate, :discounted_rate, :_destroy, :id]
  end
  
end
