class Reports::Revenue < Less::Interaction
  
  
  def run
    self
  end
  
  def revenue
    @revenue ||= fill_data(get_revenue_data).to_json
  end
  
  def booking
    @booking ||= fill_data(get_booking_data).to_json
  end
  
  private 
  def get_revenue_data
    context.hotel.sales.range(Date.year).group(:device_type, "month(date)").paid.sum( :price)
  end
  
  def get_booking_data
    context.hotel.sales.range(Date.year).group(:device_type, "month(date)").paid.count
  end
  
  def fill_data input
    out = init_rows
    input.each do |datum|
      device = datum[0][0]
      month = date_for_month datum[0][1]
      amount = datum[1]
      row = out.select{|x| x.date == month}.first
      next if row.nil?
      if row.respond_to? device
        row.send "#{device}=", amount
      else
        row.other = amount
      end
    end
    trim_other(assign_totals out)
  end
  
  def assign_totals arr
    arr.each {|d| d.total = d.desktop + d.mobile + d.tablet + d.other}
  end
  
  def trim_other arr
    trim = true
    arr.each do |d|
      trim = false and break if d.other != 0.0
    end
    return arr unless trim
    arr.each do |d|
      d.delete_field :other
    end
    arr
  end
  
  def init_rows
    arr = []
    (Date.current.beginning_of_year.month..Date.current.month).to_a.each do |month|
      arr << uninited_row(month: date_for_month(month))
    end
    arr
  end
  
  def uninited_row( month: nil)
    OpenStruct.new date: month, desktop: 0.0, tablet: 0.0, mobile: 0.0, other: 0.0
  end
  
  def date_for_month month
    Date.current.change( month: month, day: 1)
  end
  
end