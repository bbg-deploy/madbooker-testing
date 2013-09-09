class Reports::Denials < Less::Interaction
  
  
  def run
    self
  end
  
  
  
  
  def headers
    @headers ||= data.map &:date
  end
  
  def series
    @series ||= [{
      name: "Denials",
      data: data.map( &:count)
    }]
  end
  
  private 
  def range
    @range ||= (Date.current)..(Date.current+30)
  end
  
  def stats
    @stats ||= Stat.range(range).denials
  end
  
  def data
    return @data if @data
    stats
    @data = inited_rows.each do |row|
      row.count += add_count row.date
    end
  end
  
  def add_count date
    stats.select { |stat| date.in? stat.start..stat.end }.size
  end
  
  def inited_rows
    range.map do |date|
      OpenStruct.new date: date, count: 0
    end
  end
  
end