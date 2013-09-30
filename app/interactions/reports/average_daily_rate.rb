class Reports::AverageDailyRate < Less::Interaction
  
  
  def run
    self
  end
  
  def adr_data
    @adr ||= fill_data.to_json
  end
  
  
  
  
  private 
  def get_adr_data
    @get_adr_data ||= context.hotel.room_types.sum :number_of_rooms
  end
  
  def get_revpar_data
    return @get_revpar_data if @get_revpar_data
    data = context.hotel.inventories.range(Date.year).group("month(date)").sum :available_rooms
    h = {}
    data.each do |month, available_rooms|
      h[month] = available_rooms / Time.days_in_month(month)
    end
    @get_revpar_data = h
  end
  
  def room_revenue
    @room_revenue ||= context.hotel.sales.range(Date.year).group("month(date)").paid.sum( :total)  
  end

  def fill_data
    a = []
    init_months do |m| 
      struct = uninited_row month: m
      struct.revpar = do_math room_revenue[m.month], get_revpar_data[m.month]
      struct.adr = do_math room_revenue[m.month], get_adr_data
      a << struct
    end
    a
  end
  
  def do_math rev, quantity
    rev, quantity = rev.to_d, quantity.to_i
    if rev == 0 || quantity == 0
      0
    else
      (rev / quantity).round(2)
    end
  end
  
  
  def uninited_row( month: nil)
    OpenStruct.new date: month, revpar: 0.0, adr: 0.0
  end
  
  def init_months
    (Date.current.beginning_of_year.month..Date.current.month).to_a.each do |month|
      yield date_for_month(month)
    end
  end
  
  def date_for_month month
    Date.current.change( month: month, day: 1)
  end
  
end