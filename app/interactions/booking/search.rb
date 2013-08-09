class Booking::Search < Less::Interaction
  
  
  expects :context
  
  def run
    search 
  end
  
  private
  def search
    if context.params[:q].blank? && !Rails.env.development?
      return context.hotel.bookings.where "1 = 2"
    end
    q = "#{context.params[:q]}%"
    context.hotel.bookings.where("first_name like ? or last_name like ?", q, q).reorder("arrive desc, last_name, first_name")
  end
  
end
  