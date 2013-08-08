class BookingsController < ApplicationController
  before_filter :ensure_hotel
  skip_filter :authenticate_user!

  def show
    if hotel_from_subdomain
      @booking = hotel_from_subdomain.bookings.find_by_guid( params[:id]).decorate
      render layout: 'hotel'
    elsif @booking = current_hotel.bookings.find_by_id( params[:id]).decorate
      render :private, layout: 'application'
    else
      raise ActiveRecord::RecordNotFound
    end
  end
  
  def index
    params[:date] ||= Date.current.to_s :db
    @list = Booking::List.new(context: context).run
  end
  
  def search
    @bookings = Booking::Search.new(context: context).run.paginate(pagination_params).decorate
  end
  
  def no_shows
    @bookings = current_hotel.bookings.no_shows.paginate(pagination_params).decorate
  end
  
  def edit
    res current_hotel.bookings.find(params[:id]).decorate
  end
  
  def update
    b = current_hotel.bookings.find params[:id]
    b.update_attributes booking_params
    res b
  end
  
  
    
  def check_in
    current_hotel.bookings.find(params[:id]).check_in!
    redirect_to( {action: :show}, notice: "Checked in.")
  end
  
  def check_out
    current_hotel.bookings.find(params[:id]).check_out!
    redirect_to( {action: :show}, notice: "Checked out.")
  end
  
  def cancel
    current_hotel.bookings.find(params[:id]).cancel!
    redirect_to( {action: :show}, notice: "Cancel.")
  end
  
  def open
    current_hotel.bookings.find(params[:id]).open!
    redirect_to( {action: :show}, notice: "Open.")
  end
  
  def no_show
    current_hotel.bookings.find(params[:id]).no_show!
    redirect_to( {action: :show}, notice: "No show.")
  end
  
  def pay
    booking = current_hotel.bookings.find(params[:id])
    if booking.paid
      booking.update_attribute :paid, nil
      redirect_to( {action: :show}, notice: "unpaid.")
    else
      booking.update_attribute :paid, Time.zone.now
      redirect_to( {action: :show}, notice: "paid.")
    end
  end
  

  
  private
  
  def booking_params
    par = params[:booking].permit :arrive, :depart, :room_type_id, :first_name, :last_name, :made_by_first_name,
      :made_by_last_name, :email_confirmation, :email, :sms_confirmation, :cc_zipcode, :cc_cvv, :cc_year, 
      :cc_month, :cc_number
    par[:arrive] = Chronic.parse( params[:booking][:arrive]).to_date unless params[:booking][:arrive].blank?
    par[:depart] = Chronic.parse( params[:booking][:depart]).to_date unless params[:booking][:depart].blank?
    par
  end
  
end
