class Date
  
  def self.week
    Date.current.beginning_of_week..Date.current.end_of_week
  end
  
  def self.month
    Time.current.beginning_of_month.to_date..Date.current.end_of_month
  end
  
  def self.year
    Date.current.beginning_of_year..Date.current.end_of_year
  end
  
end