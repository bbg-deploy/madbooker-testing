class Booking::Build < Less::Interaction
  
  
  expects :context
  
  def run
    build 
  end
  
  private
  
  def build
    booking = context.hotel.bookings.new( context.params).decorate
    
    context.hotel.sales_taxes.decorate.each do |tax|
      booking.applied_sales_taxes.build({
         name: tax.name, 
         calculated_by: tax.calculated_by, 
         calculated_how: tax.calculated_how, 
         quantity: tax.quantity(booking.days), 
         total: tax.price(booking.lowest_rate, booking.days)
      })
    end
    if booking.rate #don't add this if rate is nil, error will be caught higher in the stack
      booking.total = booking.lowest_rate + booking.applied_sales_taxes.map(&:total).sum
    end
    booking
  end
  
  
end
  