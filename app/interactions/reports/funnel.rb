class Reports::Funnel < Less::Interaction
  
  
  def run
    self
  end
  
  def data
    @data ||= fill_data.to_json
  end
  
  
  
  
  private 
  def get_data
    @get_data ||= context.hotel.stats.funnels.group(:url, "month(created_at)").count
  end
  
  def fill_data
    a = []
    init_months do |m| 
      struct = uninited_row month: m
      a << struct
    end
    get_data.each do |k,v|
      step = k[0]
      count = v
      month = k[1]
      struct = a.select{|x| x.date.month == month}.first
      struct.data << uninited_data( step, count)
    end
    normalize_data( ensure_each_has_same_steps a)
  end
        
  def uninited_row( month: nil)
    OpenStruct.new date: month, data: []
  end
  
  def uninited_data step = "", count = 0
    OpenStruct.new step: step, count: count, order: 0
  end
  
  def init_months
    (Date.current.beginning_of_year.month..Date.current.month).to_a.each do |month|
      yield date_for_month(month)
    end
  end
  
  def date_for_month month
    Date.current.change( month: month, day: 1)
  end
  
  def ensure_each_has_same_steps arr
    steps = arr.map(&:data).flatten.map{|a| a.step}.flatten.uniq
    arr.each do |struct|
      steps.each do |step|
        next if step.in? struct.data.map(&:step)
        struct.data << uninited_data(step)
      end
    end
    arr
  end
  
  def normalize_data arr
    out = []
    arr.each do |month|
      struct = uninited_row month: month.date
      struct.data = normalize_steps month.data
      out << struct      
    end
    out
  end
  
  # removes simliar urls while retaining their counts
  def normalize_steps steps_and_counts
    out = []
    steps_and_counts.each do |step_and_count|
      new_step_and_count = out.select{|x| x.step == step_and_count.step}.first
      if new_step_and_count.nil?
        new_step_and_count = uninited_data step_and_count.step
        out << new_step_and_count
      end
      new_step_and_count.count += step_and_count.count
    end
    sort_steps out
  end
  
  def sort_steps arr
    order = [Stat::FUNNEL_STEPS[:start], Stat::FUNNEL_STEPS[:choose_dates], Stat::FUNNEL_STEPS[:choose_room], Stat::FUNNEL_STEPS[:attempt], Stat::FUNNEL_STEPS[:booked]]
    arr.sort {|a,b| order.index(a.step) <=> order.index(b.step)}
  end
  
end