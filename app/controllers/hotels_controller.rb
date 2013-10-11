class HotelsController < ApplicationController
    include Hotel::Params

  def index
    redirect_to [:edit, current_hotel] and return if current_hotel
    redirect_to root_url
  end

  def new
    redirect_to [:edit, current_hotel] and return if current_hotel && !Rails.env.development?
    hotel = Hotel.new
    hotel.room_types.build
    @hotel = hotel.decorate
    res @hotel
  end
  
  def edit
    current_hotel.room_types.build if current_hotel.room_types.count == 0
    @hotel = current_hotel.decorate
    respond_with @hotel
  end  
  
  def create
    hotel = Hotel::Create.new(context).run
    if hotel.persisted?
      redirect_to setup_instructions_hotels_path, notice: "Saved"
    else
      @hotel = hotel.decorate
      render action: "new"
    end
  end
  
  def update
    res = Hotel::Update.new(context).run
    if res.success?
      redirect_to [:edit, current_hotel], notice: "Saved"
    else
      @hotel = current_hotel.decorate
      res @hotel
    end
  end
  
  def show
    @hotel = DashboardDecorator.decorate current_hotel
  end
  
  def delete_logo
    render nothing: true and return unless can? :update, current_hotel
    current_hotel.update_attribute :logo, nil
  end
  
  def setup_instructions
    render
  end
  
  def ga_instructions
    #render layout: false
  end
  
  def ga_code
    code = ""
    clasic = nil
    begin
      res = HTTParty.get(params[:url])
      if res.code.to_s =~ /\A2/
        if res.body =~ /_gaq\.push\(\['_setAccount', ?'([-\da-zA-Z]*)'\]\)/
          #clasic
          classic = true
          code = $1
        elsif res.body =~ /ga\('create', ?'([-\da-zA-Z]*)'\)/
          #universal
          classic = false
          code = $1
        end
      end
    rescue
    end
    render json: {code: code, classic: classic}
  end
  
end
