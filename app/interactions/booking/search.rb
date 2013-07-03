class Booking::Search < Less::Interaction
  
  
  expects :context
  
  def run
    search 
  end
  
  private
  def search
    q = "#{context.params[:q]}%"
    context.hotel.bookings.where("first_name like ? or last_name like ?", q, q)
  end
  
end
  