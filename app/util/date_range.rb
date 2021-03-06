class DateRange
  
  attr_accessor :range, :format, :custom_start_date, :custom_end_date
  
  def initialize(range: "", start_date: nil, end_date: nil)
    @range             = range
    @custom_start_date = Chronic.parse(start_date) if start_date
    @custom_end_date   = Chronic.parse(end_date) if end_date
  end
  
  def to_a
    [start_date, end_date]
  end
  
  def to_r
    start_date..end_date
  end
  
  def cover? d
    to_r.cover? d
  end
  
  def self.from_params params
    new range: params[:date_range], 
      start_date: params[:start_date], 
      end_date: params[:end_date]
  end
  
  def to_params merge_with = {}
    if @range == "your_dates"
      h = {range: :your_dates, start_date: start_date, end_date: end_date}
    else
      h = {range: @range}
    end
    merge_with.merge h
  end
  
  def blank?
    @range.blank?
  end

  def all?
    @range == 'all_dates'
  end
  
  def start_date=(other)
    @custom_start_date = other
  end

  def end_date=(other)
    @custom_end_date = other
  end


  def start_date
    case @range
    when :week
      Date.week.first
    when :month
      Date.month.first
    when :last_month
      Date.current.last_month.beginning_of_month
    else
      Date.current.beginning_of_month
    end
  end
  
  def start
    start_date
  end

  def end_date
    case @range
    when :week
      Date.week.end + 1.day
    when :month
      Date.month.end + 1.day
    when :last_month
      Date.current.last_month.end_of_month
    else
      Date.current + 1.day
    end
  end
  
  def end
    end_date
  end
  
  private
  
end
