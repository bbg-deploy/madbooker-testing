class Booking::Build < Less::Interaction
  
  
  expects :context
  
  def run
    build 
  end
  
  private
  
  def booking
    @booking ||= context.hotel.bookings.new( context.params).decorate
  end
  
  def build
    return nil if booking.rate.nil?
    context.hotel.sales_taxes.decorate.each do |tax|
      booking.applied_sales_taxes.build({
         name: tax.name, 
         calculated_by: tax.calculated_by, 
         calculated_how: tax.calculated_how, 
         quantity: tax.quantity(booking.nights), 
         total: tax.price(booking.lowest_rate, booking.nights)
      })
    end
    booking.total = calc_total
    booking
  end
  
  def nights
    (booking.arrive..(booking.depart-1)).to_a.size
  end
  
  def rate
    booking.lowest_rate * nights
  end

  def calc_total
    return nil if booking.rate.nil? #don't add this if rate is nil, error will be caught higher in the stack
    rate + booking.applied_sales_taxes.map(&:total).sum
  end  
  
end
  