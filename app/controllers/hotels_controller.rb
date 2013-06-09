class HotelsController < ApplicationController
  
  def new
    hotel = Hotel.new
    res hotel.decorate
  end
end
