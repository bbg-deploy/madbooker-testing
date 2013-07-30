class Reports::Revenue < Less::Interaction
  
  
  def run
    @data = []
    self
  end
  
  def data
    fill_data.map do |os|
      {
        date: os.month,
        mobile: os.mobile,
        other: os.other,
        total: os.total
      }
    end.to_json
  end
  
  private 
  def get_data
    context.hotel.sales.range(Date.year).group(:mobile, "month(date)").paid.sum( :price)
  end
  
  def fill_data
    return @data unless @data.blank?
    init_rows
    get_data.each do |datum|
      mobile = datum[0][0]
      month = date_for_month datum[0][1]
      amount = datum[1]
      row = @data.select{|x| x.month == month}.first
      next if row.nil?
      if mobile
        row.mobile = amount
      else
        row.other = amount
      end
    end
    assign_totals
    @data
  end
  
  def assign_totals
    @data.each {|d| d.total = d.mobile + d.other}
  end
  
  def init_rows
    (Date.current.beginning_of_year.month..Date.current.month).to_a.each do |month|
      @data << uninited_row(month: date_for_month(month))
    end
  end
  
  def uninited_row( month: nil)
    OpenStruct.new month: month, mobile: 0.0, other: 0.0, total: 0.0
  end
  
  def date_for_month month
    Date.current.change( month: month, day: 1)
  end
  
end