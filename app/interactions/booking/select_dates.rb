class Booking::SelectDates < Less::Interaction
  
  expects :context
  
  def run
    if has_rooms?
      
    else
    end
  end
  
  private
  def has_rooms?
    a = Chronic.parse( context.params[:booking][:arrive]).to_date
    d = Chronic.parse( context.params[:booking][:depart]).to_date
  end
end