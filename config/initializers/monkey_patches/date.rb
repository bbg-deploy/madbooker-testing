class Date
  
  def week
    Date.current.beginning_of_week..Date.current
  end
  
  def month
    Time.current.beginning_of_month.to_date..Date.current
  end
  
end