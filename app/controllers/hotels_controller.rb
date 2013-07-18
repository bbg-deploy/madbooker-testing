class HotelsController < ApplicationController
    include Hotel::Params

  def index
    redirect_to [:edit, current_hotel] and return if current_hotel
    redirect_to root_url
  end

  def new
    redirect_to [:edit, current_hotel] and return if current_hotel
    hotel = Hotel.new
    hotel.room_types.build
    res hotel.decorate
  end
  
  def edit
    current_hotel.room_types.build if current_hotel.room_types.count == 0
    res current_hotel.decorate
  end  
  
  def create
    hotel = Hotel::Create.new(context).run
    if hotel.persisted?
      redirect_to [:edit, hotel], notice: "Saved"
    else
      res hotel.decorate
    end
  end
  
  def update
    res = Hotel::update.new(context).run
    if res.success?
      redirect_to [:edit, current_hotel], notice: "Saved"
    else
      res current_hotel.decorate
    end
  end
  
  def show
    res current_hotel.decorate
  end
  
  def delete_logo
    render nothing: true and return unless can? :update, current_hotel
    current_hotel.update_attribute :logo, nil
  end
  
  private
  
end
